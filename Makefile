TS_VERSION=$(or $(VERSION),3.0.13.8)

all:	build

build:
	docker build --build-arg TS_VERSION=$(TS_VERSION) -t phaldan/tsdns:$(TS_VERSION) .

push:
	docker push phaldan/tsdns:$(TS_VERSION)

run:
	docker run --name tsdns -d -v ${PWD}/tsdns_settings.ini:/tsdns/tsdns_settings.ini -p 41144:41144 phaldan/tsdns:$(TS_VERSION)
