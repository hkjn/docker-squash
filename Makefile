USERNAME=hkjn
NAME=$(shell basename $(PWD))

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support
IMAGE=$(USERNAME)/$(NAME)
DOCKER_ARCH=$(shell . $(RELEASE_SUPPORT) ; getDockerArch)
VERSION=$(shell . $(RELEASE_SUPPORT) ; getVersion)

SHELL=/bin/bash

.PHONY: pre-build docker-build post-build build showver \
	push do-push post-push

build: pre-build docker-build post-build

pre-build:

post-build:

post-push:
	docker run -v $(HOME)/.docker:/root/.docker:ro --rm hkjn/manifest-tool \
	       push from-args --platforms linux/amd64,linux/arm \
	                      --template $(IMAGE):ARCH \
	                      --target $(IMAGE)

docker-build: .release
	docker build -t $(IMAGE):$(VERSION)-$(DOCKER_ARCH) .
	docker tag $(IMAGE):$(VERSION)-$(DOCKER_ARCH) $(IMAGE):$(DOCKER_ARCH)

.release:
	@echo "0.0.0" > .release
	@echo INFO: .release created
	@cat .release

release: check-status check-release build push

push: do-push post-push

do-push:
	@echo "Pushing image.."
	docker push $(IMAGE):$(DOCKER_ARCH)

snapshot: build push

showver: .release
	@. $(RELEASE_SUPPORT); getVersion
