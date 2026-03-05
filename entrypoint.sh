#!/bin/sh
set -e

MODELS_DIR="/models"

show_help() {
    echo "Usage: entrypoint.sh <model-name>"
    echo ""
    echo "Supported models:"
    echo "  llama-8b     Meta-Llama-3.1-8B-Instruct Q4_K_M  (~4.9 GB)"
    echo "  qwen-14b    Qwen2.5-14B-Instruct Q4_K_M         (~8.9 GB)"
    exit 0
}

case "$1" in
    -h|--help)
        show_help
        ;;
    llama-8b)
        MODEL_FILE="Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-14b)
        MODEL_FILE="Qwen2.5-14B-Instruct-Q4_K_M.gguf"
        MODEL_URL="https://huggingface.co/bartowski/Qwen2.5-14B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
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
