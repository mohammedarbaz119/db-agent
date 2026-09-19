import os

import asyncpg
from dotenv import load_dotenv

load_dotenv()

_pool: asyncpg.Pool | None = None


async def create_pool():
    global _pool
    if not _pool:
        _pool = await asyncpg.create_pool(
            user=os.getenv("DB_READONLY_USER"),
            password=os.getenv("DB_READONLY_PASSWORD"),
            database=os.getenv("POSTGRES_DB"),
            host="127.0.0.1",
            min_size=1,
            max_size=10,
        )


def get_pool():
    global _pool
    if _pool is None:
        raise RuntimeError("_pool is not intialized yet. intiliaze it")
    return _pool


async def close_pool():
    global _pool
    if _pool is not None:
        await _pool.close()
        _pool = None
    return True
