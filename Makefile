BASE := chain33
TAG := 1.0.1
BUSYBOX_IMAGE := ${BASE}busybox:${TAG}
CHAIN33_IMAGE := ${BASE}:${TAG}

.PHONY: default

default: docker

build:
	@go build -o deploy

docker:
	@if [[ -z $(docker images $${BUSYBOX_IMAGE}|grep -v 'TAG') ]];then docker rmi ${BUSYBOX_IMAGE}; fi
	@if [[ -z $(docker images $${CHAIN33_IMAGE}|grep -v 'TAG') ]];then docker rmi ${CHAIN33_IMAGE}; fi
	@docker rmi  ${BUSYBOX_IMAGE} ${CHAIN33_IMAGE}
	@docker build -t ${BUSYBOX_IMAGE} -f busybox/Dockerfile ./busybox
	@docker build -t ${CHAIN33_IMAGE} -f chain33/Dockerfile ./chain33

push: docker
	@docker tag ${BUSYBOX_IMAGE} harbor.benlian.co:8888/${BUSYBOX_IMAGE}
	@docker push harbor.benlian.co:8888/${BUSYBOX_IMAGE}
	@docker tag ${CHAIN33_IMAGE} harbor.benlian.co:8888/${CHAIN33_IMAGE}
	@docker push harbor.benlian.co:8888/${CHAIN33_IMAGE}