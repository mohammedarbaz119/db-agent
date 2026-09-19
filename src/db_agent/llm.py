from dotenv import load_dotenv
from langchain_nvidia_ai_endpoints import ChatNVIDIA
from langchain_cloudflare.chat_models import ChatCloudflareWorkersAI

load_dotenv()


llm = ChatCloudflareWorkersAI(
    model_name="@cf/nvidia/nemotron-3-120b-a12b",
)
nvidia_llm = ChatNVIDIA(model="nvidia/nemotron-3-super-120b-a12b")
