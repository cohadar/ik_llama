#!/bin/sh
set -e

MODELS="
llama-1b
qwen3-1.7b
llama-3b
qwen-3b
qwen3-4b
mistral-7b
qwen-7b
qwen-coder-7b
deepseek-r1-7b
llama-8b
qwen3-8b
gemma-9b
qwen-14b
qwen-coder-14b
deepseek-r1-14b
qwen3-14b
phi-4
mistral-22b
gemma-27b
qwen3-30b-a3b
qwen-32b
qwen-coder-32b
deepseek-r1-32b
qwen3-32b
qwq-32b
mixtral-8x7b
llama-70b
deepseek-r1-70b
qwen-72b
qwen3-235b-a22b
"

for model in $MODELS; do
    echo "=== $model ==="
    entrypoint.sh --download-only "$model"
done

echo "All models downloaded. Sleeping."
exec sleep infinity
