#!/bin/sh
set -e

MODELS_DIR="/models"
HF="https://huggingface.co"

download_model() {
    local dest="${MODELS_DIR}/$1"
    if [ -f "$dest" ]; then
        echo "$1 already exists, skipping"
        return
    fi
    rm -f "${dest}.tmp"
    echo "Downloading $1..."
    curl -L -o "${dest}.tmp" "$2"
    mv "${dest}.tmp" "$dest"
}

download_split() {
    local base="$1"
    local repo="$2"
    local subdir="$3"
    local parts="$4"
    local i=1
    local total_padded=$(printf "%05d" "$parts")
    while [ "$i" -le "$parts" ]; do
        local padded=$(printf "%05d" "$i")
        local file="${base}-${padded}-of-${total_padded}.gguf"
        if [ ! -f "${MODELS_DIR}/${file}" ]; then
            rm -f "${MODELS_DIR}/${file}.tmp"
            echo "Downloading ${file}..."
            curl -L -o "${MODELS_DIR}/${file}.tmp" "${HF}/${repo}/resolve/main/${subdir}/${file}"
            mv "${MODELS_DIR}/${file}.tmp" "${MODELS_DIR}/${file}"
        fi
        i=$((i + 1))
    done
    MODEL_PATH="${MODELS_DIR}/${base}-00001-of-${total_padded}.gguf"
}

show_help() {
    cat <<'HELP'
Usage: entrypoint.sh <model-name>

Supported models (Q4_K_M unless noted):

  Small (< 4 GB):
    llama-1b              Llama-3.2-1B-Instruct                   (~0.8 GB)
    qwen3-1.7b            Qwen3-1.7B                              (~1.1 GB)
    llama-3b              Llama-3.2-3B-Instruct                   (~2.0 GB)
    qwen-3b               Qwen2.5-3B-Instruct                     (~2.1 GB)
    qwen3-4b              Qwen3-4B                                (~2.5 GB)

  Medium (4-10 GB):
    mistral-7b            Mistral-7B-Instruct-v0.3                (~4.4 GB)
    qwen-7b               Qwen2.5-7B-Instruct                     (~4.7 GB)
    qwen-coder-7b         Qwen2.5-Coder-7B-Instruct               (~4.7 GB)
    deepseek-r1-7b        DeepSeek-R1-Distill-Qwen-7B             (~4.7 GB)
    llama-8b              Meta-Llama-3.1-8B-Instruct               (~4.9 GB)
    qwen3-8b              Qwen3-8B                                 (~5.0 GB)
    gemma-9b              Gemma-2-9B-it                            (~5.8 GB)
    qwen-14b              Qwen2.5-14B-Instruct                     (~8.9 GB)
    qwen-coder-14b        Qwen2.5-Coder-14B-Instruct               (~8.9 GB)
    deepseek-r1-14b       DeepSeek-R1-Distill-Qwen-14B             (~8.9 GB)
    qwen3-14b             Qwen3-14B                                (~9.0 GB)
    phi-4                 Phi-4                                    (~9.0 GB)

  Large (10-40 GB):
    mistral-22b           Mistral-Small-24B-Instruct-2501          (~14 GB)
    gemma-27b             Gemma-2-27B-it                           (~16 GB)
    qwen3-30b-a3b         Qwen3-30B-A3B [MoE]                     (~18 GB)
    qwen-32b              Qwen2.5-32B-Instruct                     (~19 GB)
    qwen-coder-32b        Qwen2.5-Coder-32B-Instruct               (~19 GB)
    deepseek-r1-32b       DeepSeek-R1-Distill-Qwen-32B             (~19 GB)
    qwen3-32b             Qwen3-32B                                (~19 GB)
    qwq-32b               QwQ-32B [reasoning]                      (~19 GB)
    mixtral-8x7b          Mixtral-8x7B-Instruct-v0.1 [MoE]        (~26 GB)

  XL (40+ GB):
    llama-70b             Meta-Llama-3.1-70B-Instruct              (~40 GB)
    deepseek-r1-70b       DeepSeek-R1-Distill-Llama-70B            (~40 GB)
    qwen-72b              Qwen2.5-72B-Instruct                     (~42 GB)
    qwen3-235b-a22b       Qwen3-235B-A22B-Instruct-2507 Q2_K [MoE] (~77 GB)
HELP
    exit 0
}

SPLIT=0
DOWNLOAD_ONLY=0

if [ "$1" = "--download-only" ]; then
    DOWNLOAD_ONLY=1
    shift
fi

case "$1" in
    -h|--help)
        show_help
        ;;

    # --- Small ---
    llama-1b)
        MODEL_FILE="Llama-3.2-1B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-1.7b)
        MODEL_FILE="Qwen_Qwen3-1.7B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_Qwen3-1.7B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    llama-3b)
        MODEL_FILE="Llama-3.2-3B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-3b)
        MODEL_FILE="Qwen2.5-3B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-3B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-4b)
        MODEL_FILE="Qwen_Qwen3-4B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_Qwen3-4B-GGUF/resolve/main/${MODEL_FILE}"
        ;;

    # --- Medium ---
    mistral-7b)
        MODEL_FILE="Mistral-7B-Instruct-v0.3-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Mistral-7B-Instruct-v0.3-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-7b)
        MODEL_FILE="Qwen2.5-7B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-7B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-coder-7b)
        MODEL_FILE="Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    deepseek-r1-7b)
        MODEL_FILE="DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    llama-8b)
        MODEL_FILE="Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-8b)
        MODEL_FILE="Qwen_Qwen3-8B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_Qwen3-8B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    gemma-9b)
        MODEL_FILE="gemma-2-9b-it-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/gemma-2-9b-it-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-14b)
        MODEL_FILE="Qwen2.5-14B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-14B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-coder-14b)
        MODEL_FILE="Qwen2.5-Coder-14B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-Coder-14B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    deepseek-r1-14b)
        MODEL_FILE="DeepSeek-R1-Distill-Qwen-14B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/DeepSeek-R1-Distill-Qwen-14B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-14b)
        MODEL_FILE="Qwen_Qwen3-14B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_Qwen3-14B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    phi-4)
        MODEL_FILE="phi-4-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/phi-4-GGUF/resolve/main/${MODEL_FILE}"
        ;;

    # --- Large ---
    mistral-22b)
        MODEL_FILE="Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Mistral-Small-24B-Instruct-2501-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    gemma-27b)
        MODEL_FILE="gemma-2-27b-it-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/gemma-2-27b-it-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-30b-a3b)
        MODEL_FILE="Qwen_Qwen3-30B-A3B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_Qwen3-30B-A3B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-32b)
        MODEL_FILE="Qwen2.5-32B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-32B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-coder-32b)
        MODEL_FILE="Qwen2.5-Coder-32B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    deepseek-r1-32b)
        MODEL_FILE="DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-32b)
        MODEL_FILE="Qwen_Qwen3-32B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_Qwen3-32B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwq-32b)
        MODEL_FILE="Qwen_QwQ-32B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen_QwQ-32B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    mixtral-8x7b)
        MODEL_FILE="mixtral-8x7b-instruct-v0.1.Q4_K_M.gguf"
        MODEL_URL="${HF}/TheBloke/Mixtral-8x7B-Instruct-v0.1-GGUF/resolve/main/${MODEL_FILE}"
        ;;

    # --- XL ---
    llama-70b)
        MODEL_FILE="Meta-Llama-3.1-70B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Meta-Llama-3.1-70B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    deepseek-r1-70b)
        MODEL_FILE="DeepSeek-R1-Distill-Llama-70B-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen-72b)
        MODEL_FILE="Qwen2.5-72B-Instruct-Q4_K_M.gguf"
        MODEL_URL="${HF}/bartowski/Qwen2.5-72B-Instruct-GGUF/resolve/main/${MODEL_FILE}"
        ;;
    qwen3-235b-a22b)
        SPLIT=1
        SPLIT_BASE="Qwen_Qwen3-235B-A22B-Instruct-2507-Q2_K"
        SPLIT_REPO="bartowski/Qwen_Qwen3-235B-A22B-Instruct-2507-GGUF"
        SPLIT_PARTS=3
        ;;

    *)
        echo "Error: unknown model '$1'"
        echo ""
        show_help
        ;;
esac

if [ "$SPLIT" = "1" ]; then
    download_split "$SPLIT_BASE" "$SPLIT_REPO" "$SPLIT_BASE" "$SPLIT_PARTS"
else
    MODEL_PATH="${MODELS_DIR}/${MODEL_FILE}"
    download_model "$MODEL_FILE" "$MODEL_URL"
fi

if [ "$DOWNLOAD_ONLY" = "1" ]; then
    echo "Download complete."
    exit 0
fi

exec llama-server \
    --model "$MODEL_PATH" \
    --host 0.0.0.0 \
    --port 8080 \
    --ctx-size "${CTX_SIZE:-4096}"
