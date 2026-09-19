from langchain_core.tools import tool

from db_agent.utils.db import get_pool


async def list_tables():
    try:
        conn_pool = get_pool()
        async with conn_pool.acquire() as conn:
            tables = await conn.fetch("""
                SELECT table_name
                FROM information_schema.tables
                WHERE table_schema = 'public'
                AND table_type = 'BASE TABLE'
                ORDER BY table_name;
            """)

        return "\n".join([row['table_name'] for row in tables])
    except RuntimeError as e:
        print(e)


async def get_table_schema(table_name: str) -> str:
    conn_pool = get_pool()
    async with conn_pool.acquire() as conn:
        rows = await conn.fetch(
            """
            SELECT
                column_name,
                data_type,
                is_nullable,
                column_default
            FROM information_schema.columns
            WHERE table_schema = 'public'
              AND table_name = $1
            ORDER BY ordinal_position;
        """,
            table_name,
        )

    table_schema = "\n".join(
        (
            f"{row['column_name']} {row['data_type']}"
            f" {'NOT NULL' if row['is_nullable'] == 'NO' else 'NULL'}"
            + (f" DEFAULT {row['column_default']}" if row["column_default"] else "")
        )
        for row in rows
    )
    return f"{table_name} schema \n {table_schema}"
