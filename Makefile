IMAGE = ghcr.io/cohadar/ik_llamma
TAG = 0.1.0

build:
	podman build -t $(IMAGE):$(TAG) .

push:
	podman push $(IMAGE):$(TAG)
