from typing import TypeVar

from langchain_core.messages import BaseMessage
from pydantic import BaseModel

T = TypeVar("T", bound=BaseModel)


def structure_response(response: BaseMessage, output_model: type[T]) -> T | None:
    try:
        content = next(
            block["text"]  # type: ignore
            for block in response.content
            if block["type"] == "text"  # type: ignore
        )
        result = output_model.model_validate_json(content)
        return result
    except Exception as e:
        print(f"{e} Exception")
        return None
