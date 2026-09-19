from typing import Annotated, TypedDict

from langchain_core.messages import BaseMessage
from langgraph.graph import add_messages


class DBAgentState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]
    generated_query: str
    user_query: str
    tables: str
    table_schemas: str
    is_safe: bool
    invalid_query_reason: str
    end: bool
