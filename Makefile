CREDS=
IMAGE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))result/
REGISTRY=localhost:5000
VERIFY=true

result:
	nix-build -A allImages

.PHONY: push
push/%: IMAGE_NAME=$*
push/%: IMAGE_PATH=$(IMAGE_DIR)$(IMAGE_NAME)/
push/%: result
	skopeo \
		--insecure-policy \
		--override-os=linux \
		sync \
			$(if $(CREDS),--dest-creds=$(CREDS),) \
			--dest-tls-verify=$(VERIFY) \
			--src=dir \
			--dest=docker \
			$(IMAGE_PATH) \
			$(REGISTRY)

.PHONY: push-all
push-all: $(patsubst %,push/%,$(notdir $(wildcard $(IMAGE_DIR)*)))
