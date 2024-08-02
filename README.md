# Boxes

Build QEMU images with Packer.

Builds utilize [QEMU's virtualization accelerators](https://www.qemu.org/docs/master/system/introduction.html#virtualisation-accelerators) and will target the host's CPU architecture.

## Usage

Use `make` to build images, as it will dynamically pass in needed variables:

```sh
make build
```