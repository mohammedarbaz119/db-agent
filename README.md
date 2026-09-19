# DB Agent

A read-only AI database agent built with **LangGraph** that interprets natural-language user queries, translates them into SQL, and executes the generated queries against a PostgreSQL database.

## Features

- **Read-only database access** — designed to prevent data modification operations such as `INSERT`, `UPDATE`, `DELETE`, and `DROP`.
- **Natural Language to SQL** — interprets user queries and generates corresponding SQL queries.
- **Query Execution** — executes validated read-only SQL queries against PostgreSQL and returns the results.
- **Agent Workflow** — uses LangGraph to orchestrate the query understanding, SQL generation, validation, and execution workflow.
- **LLM Integration** — built with LangChain and Cloudflare AI Workers models.
- **PostgreSQL** — uses PostgreSQL as the underlying database.

## Tech Stack

- Python
- LangGraph
- LangChain
- Cloudflare AI Workers / Models
- PostgreSQL

## Future Improvements

- Add **Row-Level Security (RLS)** policies for more granular database access control.
- Further strengthen SQL validation and database-level read-only enforcement.
- Expand the agent workflow with additional safeguards around query execution.
