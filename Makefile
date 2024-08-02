OS := $(shell uname)
ARCH := $(shell uname -m)

.PHONY: build
build:
ifeq ($(OS), Darwin)
	@packer build -var "host_os=${OS}" -var "host_arch=${ARCH}" -var "headless=${HEADLESS}" .
endif

.PHONY: fmt
fmt:
	@packer fmt -write=true -recursive .

.PHONY: validate
validate:
	@packer validate .

.PHONE: clean
clean:
	rm -rf builds