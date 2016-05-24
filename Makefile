.DEFAULT_GOAL := build
.PHONY: build deps

SOURCE_FILES = default.vcl nginx-https-proxy.conf
IMAGE_TAG = github-varnish:latest

deps:
	@hash docker ps > /dev/null 2>&1 || \
		(echo "Cannot connect to docker host."; exit 1)

build: deps $(SOURCE_FILES)
	docker build -t $(IMAGE_TAG) .
