FROM ubuntu:24.04 AS build

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ikawrakow/ik_llama.cpp.git /src

WORKDIR /src

RUN cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DGGML_NATIVE=ON \
    && cmake --build build --target llama-server -j$(nproc)

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /src/build/bin/llama-server /usr/local/bin/
COPY --from=build /src/build/src/*.so /usr/local/lib/
COPY --from=build /src/build/ggml/src/*.so /usr/local/lib/
RUN ldconfig

ENTRYPOINT ["llama-server"]
