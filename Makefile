all: build

build: guard-TAG
	docker build -t draky-dev/mariadb-alpine:${TAG} .

guard-%:
	@ if [ "${${*}}" = "" ]; then \
	    echo "Environment variable $* not set"; \
	    exit 1; \
	fi
