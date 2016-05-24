.DEFAULT_GOAL := build
.PHONY: build run deps

deps:
	@hash docker ps > /dev/null 2>&1 || \
		(echo "Cannot connect to docker host."; exit 1)

run:
	docker run -d -p 8765:80 'github-varnish:latest'

kill:
	docker ps -a | grep 'github-varnish:latest' | awk '{print $$1}' | xargs docker kill
	docker ps -a | grep 'github-varnish:latest' | awk '{print $$1}' | xargs docker rm

build: deps kill default.vcl nginx-https-proxy.conf start.sh
	docker build -t 'github-varnish:latest' . && \
