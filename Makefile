NAME = jacoelho/confd-nginx
TAG = dev

.PHONY: build

build:
	docker build --rm -t $(NAME):$(TAG) .
