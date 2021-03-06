version := "v1.2.0"

commit := $(shell git rev-parse --short HEAD)


build: dist/sso-auth dist/sso-proxy

dist/sso-auth:
	mkdir -p dist
	go generate ./...
	go build -o dist/sso-auth ./cmd/sso-auth

dist/sso-proxy:
	mkdir -p dist
	go generate ./...
	go build -o dist/sso-proxy ./cmd/sso-proxy

tools:
	go get golang.org/x/lint/golint
	go get github.com/rakyll/statik 

test:
	./scripts/test

clean:
	rm -r dist

imagepush:
	docker build -t buzzfeed/sso-dev:$(commit) .
	docker push buzzfeed/sso-dev:$(commit)

releasepush:
	docker build -t buzzfeed/sso:$(version) .
	docker push buzzfeed/sso:$(version)

.PHONY: dist/sso-auth dist/sso-proxy tools
