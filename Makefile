BASE := chain33
TAG := v1.0.2
BUSYBOX_IMAGE := ${BASE}busybox:${TAG}
CHAIN33_IMAGE := ${BASE}:${TAG}

.PHONY: default

default: docker

build:
	@go build -o deploy

docker:
	@if [ -n "`docker images -q ${BUSYBOX_IMAGE}`" ];then docker rmi ${BUSYBOX_IMAGE}; fi
	@if [ -n "`docker images -q ${CHAIN33_IMAGE}`" ];then docker rmi ${CHAIN33_IMAGE}; fi
	@docker build -t ${BUSYBOX_IMAGE} -f busybox/Dockerfile ./busybox
	@docker build -t ${CHAIN33_IMAGE} -f chain33/Dockerfile ./chain33

push: docker
	@docker tag ${BUSYBOX_IMAGE} harbor.benlian.co:8888/${BUSYBOX_IMAGE}
	@docker push harbor.benlian.co:8888/${BUSYBOX_IMAGE}
	@docker tag ${CHAIN33_IMAGE} harbor.benlian.co:8888/${CHAIN33_IMAGE}
	@docker push harbor.benlian.co:8888/${CHAIN33_IMAGE}