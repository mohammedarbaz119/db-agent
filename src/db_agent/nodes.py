from db_agent.llm import llm
from db_agent.prompts import (
    ANSWER_GENERATION_PROMPT,
    SQL_GENERATION_PROMPT,
    SQL_REGENERATION_PROMPT,
    SQL_VERIFIER_PROMPT,
    TABLE_RESELECTION_PROMPT,
    TABLE_SELECTION_PROMPT,
)
from db_agent.response_models import (
    SQLGenerationResponse,
    SQLVerifierResponse,
    TableSelectionResponse,
)
from db_agent.state import DBAgentState
from db_agent.tools.execute import execute
from db_agent.tools.sql_utilities import get_table_schema, list_tables
from db_agent.utils.structure_response import structure_response


def error_end(state: DBAgentState):
    return "yes" if state["end"] == True else "no"


def verify_query_router(state: DBAgentState):
    if state["end"] == True:
        return "end"
    return "execute" if state["is_safe"] == True else "regenerate"


async def generate_query(state: DBAgentState):
    """Langgraph node to select a relavant tables and generate a appropriate query"""
    if state["is_safe"] is not None and state["is_safe"] == False:
        """Regeneration block"""
        unparsed_result = llm.invoke(
            TABLE_RESELECTION_PROMPT.format(
                user_query=state["user_query"],
                tables=state["tables"],
                reason=state["invalid_query_reason"],
            )
        )
        table_selection_result = structure_response(
            unparsed_result, TableSelectionResponse
        )
        if table_selection_result is None:
            return (
                {
                    "messages": [
                        {
                            "role": "assistant",
                            "content": "there was an error please try again",
                        }
                    ],
                    "end": True,
                },
            )
        if error := table_selection_result.error:
            return {
                "messages": [
                    {
                        "role": "assistant",
                        "content": error,
                    }
                ],
                "end": True,
            }
        selected_tables: list[str] = table_selection_result.tables
        tables_schema_list = []

        for x in selected_tables:
            x_schema = await get_table_schema(x)
            tables_schema_list.append(x_schema)

        query_generated_result = llm.invoke(
            SQL_REGENERATION_PROMPT.format(
                user_query=state["user_query"],
                tables=state["tables"],
                table_schemas="\n".join(tables_schema_list),
                reason=state["invalid_query_reason"],
                previous_query=state["generated_query"],
            )
        )
        query_generated_result = structure_response(
            query_generated_result, SQLGenerationResponse
        )
        if query_generated_result is None:
            return (
                {
                    "messages": [
                        {
                            "role": "assistant",
                            "content": "there was an error please try again",
                        }
                    ],
                    "end": True,
                },
            )

        if error := query_generated_result.error:
            return {
                "messages": [
                    {
                        "role": "assistant",
                        "content": error,
                    }
                ],
                "end": True,
            }

        return {
            "generated_query": query_generated_result.query,
            "table_schemas": "\n".join(tables_schema_list),
            "end": False,
        }

    else:
        user_query = state["user_query"]
        tables = await list_tables()

        unparsed_result = llm.invoke(
            TABLE_SELECTION_PROMPT.format(user_query=user_query, tables=tables)
        )
        table_selection_result = structure_response(
            unparsed_result, TableSelectionResponse
        )
        if table_selection_result is None:
            return (
                {
                    "messages": [
                        {
                            "role": "assistant",
                            "content": "there was an error please try again",
                        }
                    ],
                    "end": True,
                },
            )
        if error := table_selection_result.error:
            return {
                "messages": [
                    {
                        "role": "assistant",
                        "content": error,
                    }
                ],
                "end": True,
            }
        selected_tables: list[str] = table_selection_result.tables
        tables_schema_list = []

        for x in selected_tables:
            x_schema = await get_table_schema(x)
            tables_schema_list.append(x_schema)

        query_generated_result = llm.invoke(
            SQL_GENERATION_PROMPT.format(
                user_query=user_query,
                tables=tables,
                table_schemas="\n".join(tables_schema_list),
            )
        )
        query_generated_result = structure_response(
            query_generated_result, SQLGenerationResponse
        )
        if query_generated_result is None:
            return (
                {
                    "messages": [
                        {
                            "role": "assistant",
                            "content": "there was an error please try again",
                        }
                    ],
                    "end": True,
                },
            )

        if error := query_generated_result.error:
            return {
                "messages": [
                    {
                        "role": "assistant",
                        "content": error,
                    }
                ],
                "end": True,
            }

        return {
            "generated_query": query_generated_result.query,
            "tables": tables,
            "table_schemas": "\n".join(tables_schema_list),
            "end": False,
        }


async def verify_query(state: DBAgentState):
    sql_verifier_result = llm.invoke(
        SQL_VERIFIER_PROMPT.format(
            user_query=state["user_query"],
            tables=state["tables"],
            table_schemas=state["table_schemas"],
            generated_query=state["generated_query"],
        )
    )

    sql_verifier_result = structure_response(sql_verifier_result, SQLVerifierResponse)
    if sql_verifier_result is None:
        return {
            "messages": [
                {
                    "role": "assistant",
                    "content": "there was an error, Please Try again",
                }
            ],
            "end": True,
        }
    if not sql_verifier_result.valid or not sql_verifier_result.read_only:
        return {"is_safe": False, "invalid_query_reason": sql_verifier_result.reason}
    return {"is_safe": True}


async def execute_query(state: DBAgentState):
    try:
        query_result = await execute(state["generated_query"])
        answer = llm.invoke(
            ANSWER_GENERATION_PROMPT.format(
                user_query=state["user_query"],
                result_set=query_result,
                table_schemas=state["table_schemas"],
            )
        )
        return {"messages": [answer]}
    except Exception as e:
        result = llm.invoke(
            f"Explain this error to the user in a short, clear, and simple way. Error: {e}"
        )
        return {"messages": [result]}
