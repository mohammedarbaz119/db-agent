import asyncio

from langgraph.graph import END, START, StateGraph

from db_agent.nodes import (
    error_end,
    execute_query,
    generate_query,
    verify_query,
    verify_query_router,
)
from db_agent.state import DBAgentState
from db_agent.utils.db import close_pool, create_pool


async def main():
    await create_pool()

    graph = StateGraph(DBAgentState)
    graph.add_node("query_gen", generate_query)
    graph.add_node("answer_gen", execute_query)
    graph.add_node("verify", verify_query)
    graph.add_edge(START, "query_gen")
    graph.add_edge("answer_gen", END)
    graph.add_conditional_edges("query_gen", error_end, {"yes": END, "no": "verify"})
    graph.add_conditional_edges(
        "verify",
        verify_query_router,
        {"end": END, "execute": "answer_gen", "regenerate": "query_gen"},
    )
    agent = graph.compile()

    user_query = input("enter your query:- ")

    result = await agent.ainvoke(
        {
            "messages": [{"role": "user", "content": user_query}],
            "user_query": user_query,
            "is_safe": True,
        }  # type: ignore
    )
    print(result["messages"][-1])
    print("end")
    await close_pool()


asyncio.run(main())
