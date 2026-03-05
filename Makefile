IMAGE = ghcr.io/cohadar/ik_llama
TAG = 0.3.2

login:
	podman login ghcr.io -u cohadar

build:
	podman build -t $(IMAGE):$(TAG) .

run:
	podman run --rm -d --name ik_llama -p 8080:8080 $(IMAGE):$(TAG) --help

stop:
	podman stop ik_llama

push:
	podman push $(IMAGE):$(TAG)
