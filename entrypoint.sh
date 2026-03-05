#!/bin/sh
set -e

MODELS_DIR="/models"

show_help() {
    echo "Usage: entrypoint.sh <model-name>"
    echo ""
    echo "Supported models:"
    echo ""
    echo "  Small:"
    echo "    llama-1b         Llama-3.2-1B-Instruct Q4_K_M          (~0.8 GB)"
    echo "    llama-3b         Llama-3.2-3B-Instruct Q4_K_M          (~2.0 GB)"
    echo "    qwen-3b          Qwen2.5-3B-Instruct Q4_K_M            (~2.1 GB)"
    echo ""
    echo "  Medium:"
    echo "    mistral-7b       Mistral-7B-Instruct-v0.3 Q4_K_M       (~4.4 GB)"
    echo "    qwen-7b          Qwen2.5-7B-Instruct Q4_K_M            (~4.7 GB)"
    echo "    llama-8b         Meta-Llama-3.1-8B-Instruct Q4_K_M     (~4.9 GB)"
    echo "    gemma-9b         Gemma-2-9B-it Q4_K_M                  (~5.8 GB)"
    echo "    qwen-coder-7b    Qwen2.5-Coder-7B-Instruct Q4_K_M     (~4.7 GB)"
    echo ""
    echo "  Large:"
    echo "    qwen-14b         Qwen2.5-14B-Instruct Q4_K_M           (~8.9 GB)"
    echo "    qwen-coder-14b   Qwen2.5-Coder-14B-Instruct Q4_K_M    (~8.9 GB)"
    echo "    mistral-22b      Mistral-Small-24B-Instruct-2501 Q4_K_M (~14 GB)"
    echo "    gemma-27b        Gemma-2-27B-it Q4_K_M                 (~16 GB)"
    echo "    qwen-32b         Qwen2.5-32B-Instruct Q4_K_M          (~19 GB)"
    echo "    qwen-coder-32b   Qwen2.5-Coder-32B-Instruct Q4_K_M   (~19 GB)"
    echo ""
    echo "  XL:"
    echo "    llama-70b        Meta-Llama-3.1-70B-Instruct Q4_K_M   (~40 GB)"
    echo "    qwen-72b         Qwen2.5-72B-Instruct Q4_K_M          (~42 GB)"
    exit 0
}

case "$1" in
    -h|--help)
        show_help
        ;;
    llama-1b)
        MODEL_FILE="Llama-3.2-1B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    llama-3b)
        MODEL_FILE="Llama-3.2-3B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-3b)
        MODEL_FILE="Qwen2.5-3B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-3B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    mistral-7b)
        MODEL_FILE="Mistral-7B-Instruct-v0.3-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Mistral-7B-Instruct-v0.3-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-7b)
        MODEL_FILE="Qwen2.5-7B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    llama-8b)
        MODEL_FILE="Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    gemma-9b)
        MODEL_FILE="gemma-2-9b-it-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/gemma-2-9b-it-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-coder-7b)
        MODEL_FILE="Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-14b)
        MODEL_FILE="Qwen2.5-14B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-14B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-coder-14b)
        MODEL_FILE="Qwen2.5-Coder-14B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-Coder-14B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    mistral-22b)
        MODEL_FILE="Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Mistral-Small-24B-Instruct-2501-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    gemma-27b)
        MODEL_FILE="gemma-2-27b-it-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/gemma-2-27b-it-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-32b)
        MODEL_FILE="Qwen2.5-32B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-32B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-coder-32b)
        MODEL_FILE="Qwen2.5-Coder-32B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    llama-70b)
        MODEL_FILE="Meta-Llama-3.1-70B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Meta-Llama-3.1-70B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-72b)
        MODEL_FILE="Qwen2.5-72B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-72B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    *)
        echo "Error: unknown model '$1'"
        echo ""
        show_help
        ;;
esac

MODEL_PATH="${MODELS_DIR}/${MODEL_FILE}"

if [ ! -f "$MODEL_PATH" ]; then
    echo "Downloading ${MODEL_FILE}..."
    curl -L -o "$MODEL_PATH" "$MODEL_URL"
fi

exec llama-server \
    --model "$MODEL_PATH" \
    --host 0.0.0.0 \
    --port 8080 \
    --ctx-size 4096
