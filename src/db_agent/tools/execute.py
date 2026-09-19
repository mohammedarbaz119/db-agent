import json

from db_agent.utils.db import get_pool


async def execute(query: str) -> str:
    conn_pool = get_pool()
    async with conn_pool.acquire() as conn:
        stmt = await conn.prepare(query)
        columns = [attr.name for attr in stmt.get_attributes()]  # type: ignore
        result = await stmt.fetch()
        data_dicts = [dict(row) for row in result]
        result_set = {"rows": data_dicts, "columns": columns}
        llm_input_string = json.dumps(result_set, indent=2, default=str)
        return llm_input_string
