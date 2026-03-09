IMAGE = ghcr.io/cohadar/ik_llama
TAG = 0.3.7

login:
	podman login ghcr.io -u cohadar

build:
	podman build -t $(IMAGE):$(TAG) .

download:
	podman run --rm -v ik_llama_models:/models $(IMAGE):$(TAG) --download-only $(MODEL)

download-all:
	podman run --rm -v ik_llama_models:/models --entrypoint download-all.sh $(IMAGE):$(TAG)

run:
	podman run --rm -it --name ik_llama -v ik_llama_models:/models -p 11434:11434 $(IMAGE):$(TAG) $(MODEL)

stop:
	podman stop ik_llama

push:
	podman push $(IMAGE):$(TAG)

S3_ENDPOINT = https://minio.i.cohadar.cc
S3_BUCKET = s3://models

s3-upload:
	podman run --rm -v ik_llama_models:/models \
		-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
		--entrypoint aws $(IMAGE):$(TAG) \
		s3 sync /models $(S3_BUCKET) --endpoint-url $(S3_ENDPOINT)

s3-download:
	podman run --rm -v ik_llama_models:/models \
		-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
		--entrypoint aws $(IMAGE):$(TAG) \
		s3 sync $(S3_BUCKET) /models --endpoint-url $(S3_ENDPOINT)
