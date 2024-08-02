OS := $(shell uname)
ARCH := $(shell uname -m)

DEBUG ?= 0

PACKER_BUILD_ON_ERROR ?= cleanup

PACKER_BUILD_CMD := PACKER_LOG=${DEBUG} packer build -on-error="${PACKER_BUILD_ON_ERROR}" -warn-on-undeclared-var -var "host_os=${OS}" -var "host_arch=${ARCH}" -var "headless=${HEADLESS}"

.PHONY: build-all
build-all:
	@${PACKER_BUILD_CMD} .

.PHONY: build-ubuntu
build-ubuntu:
	@${PACKER_BUILD_CMD} -only=ubuntu.qemu.ubuntu .

.PHONY: build-nixos
build-nixos:
	${PACKER_BUILD_CMD} -only=nixos.qemu.nixos .

.PHONY: fmt
fmt:
	@packer fmt -write=true -recursive .

.PHONY: validate
validate:
	@packer validate .

.PHONE: clean
clean:
	rm -rf builds