IMAGE = ghcr.io/cohadar/ik_llama
TAG = 0.1.1

login:
	podman login ghcr.io -u cohadar

build:
	podman build -t $(IMAGE):$(TAG) .

push:
	podman push $(IMAGE):$(TAG)
