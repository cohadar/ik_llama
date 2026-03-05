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

RUN mkdir /libs && find /src/build -name '*.so' -exec cp {} /libs/ \;

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    libgomp1 \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /src/build/bin/llama-server /usr/local/bin/
COPY --from=build /libs/ /usr/local/lib/
RUN ldconfig

COPY entrypoint.sh download-all.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/download-all.sh

ENTRYPOINT ["entrypoint.sh"]
