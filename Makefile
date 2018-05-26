.PHONY : all build update run clear check logs upgrade
VERSION?=3.1.3
UPGRADE_SCRIPT=upgrade.sh
DOCKER_IMAGE=phaldan/tsdns
DOCKER_CONTAINER=tsdns
DOCKER_CLI=$(shell which docker.io || which docker)
MAKE=make -s

all:	build

build:
	$(DOCKER_CLI) build --build-arg TS_VERSION=$(VERSION) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		-t $(DOCKER_IMAGE):$(VERSION) .

update:
	$(DOCKER_CLI) pull $(shell sed -n 's/^FROM //p' Dockerfile)
	$(MAKE) build

push:
	$(DOCKER_CLI) push $(DOCKER_IMAGE):$(VERSION)

run:
	$(DOCKER_CLI) run -d --name $(DOCKER_CONTAINER) \
	-v ${PWD}/tsdns_settings.ini:/tsdns/tsdns_settings.ini \
	-p 41144:41144 \
	$(DOCKER_IMAGE):$(VERSION)

clear:
	$(DOCKER_CLI) stop $(DOCKER_CONTAINER)
	$(DOCKER_CLI) rm $(DOCKER_CONTAINER)

logs:
	$(DOCKER_CLI) logs $(DOCKER_CONTAINER)

upgrade: build
	curl -o $(UPGRADE_SCRIPT) https://raw.githubusercontent.com/phaldan/docker-tags-upgrade/master/$(UPGRADE_SCRIPT)
	chmod +x $(UPGRADE_SCRIPT)
	./$(UPGRADE_SCRIPT) "$(DOCKER_IMAGE)" "$(VERSION)"

