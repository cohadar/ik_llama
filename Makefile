IMAGE = ghcr.io/cohadar/ik_llama
TAG = 0.3.6

login:
	podman login ghcr.io -u cohadar

build:
	podman build -t $(IMAGE):$(TAG) .

download:
	podman run --rm -v ik_llama_models:/models $(IMAGE):$(TAG) --download-only $(MODEL)

download-all:
	podman run --rm -v ik_llama_models:/models --entrypoint download-all.sh $(IMAGE):$(TAG)

run:
	podman run --rm -d --name ik_llama -v ik_llama_models:/models -p 11434:11434 $(IMAGE):$(TAG) $(MODEL)

stop:
	podman stop ik_llama

push:
	podman push $(IMAGE):$(TAG)
