# Boxes

Build QEMU images with Packer.

Builds utilize [QEMU's virtualization accelerators](https://www.qemu.org/docs/master/system/introduction.html#virtualisation-accelerators) and will target the host's CPU architecture.

## Usage

Use `make` to build images, as it will dynamically pass in needed variables:

```sh
make build
```

## Configuration

### EFI Firmware

The local `efi_firmware_paths_os_map` has host OS/architecture mappings for some EFI firmware files.

#### NixOS

On NixOS, install the [`OVMF`](https://search.nixos.org/packages?channel=24.05&show=OVMF&from=0&size=50&sort=relevance&type=packages&query=OVMF) package. You can then set a convenience environment variable in your shell (via Nix):

```
export OVMF_PATH="${pkgs.OVMF.fd}/FV"
```

You can then pass the EFI firmware paths via environment variables:

```
export PKR_VAR_efi_firmware_code="${OVMF_PATH}/OVMF_CODE.fd"
export PKR_VAR_efi_firmware_vars="${OVMF_PATH}/OVMF_VARS.fd"
```