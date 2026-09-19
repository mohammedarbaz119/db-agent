from pydantic import BaseModel, Field


# Pydantic response models
class TableSelectionResponse(BaseModel):
    tables: list[str] = Field(default_factory=list)
    error: str | None = None


class SQLGenerationResponse(BaseModel):
    query: str | None = None
    error: str | None = None


class SQLVerifierResponse(BaseModel):
    valid: bool
    read_only: bool
    reason: str  # always populated — explains the verdict either way
