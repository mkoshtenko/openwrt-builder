# openwrt-builder

This project contains all necessary files to build a custom OpenWRT image for Raspberry Pi model 4, which can be provisioned with Ansible immediately after the installation. 

The latest Raspberry Pi 4 compatible image can be downloaded from the official OpenWRT website. 
The image should be taken from the target:
  - [bcm2711](https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/)

In order to make this OpenWRT image compatible with Ansible, we should:
  - add `python` module
  - setup ssh

## How it works
Custom OpenWRT images can be created with an image builder for bcm2711 target. This image builder is stored in the same folder with an original build.
`openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz`

The image builder will be downloaded and executed in a virtual machine with Debian OS that is managed by Vagrant. The virtual machine uses VirtualBox as a provider and Ansible as a provisioning tool.

## Dependencies
  - VirtualBox
  - Vagrant
  - Ansible
  
## Steps

Get builder infrastructure:
```
git clone https://github.com/mkoshtenko/openwrt-builder.git
cd openwrt-builder
```

Setup the infrastructure:
```
vagrant up
```

Create build:
```
vagrant ssh -c 'cd ~/; ./scripts/build'
```

Clean up:
```
vagrant destroy
```

The image file should be in `./builds` directory, e.g. `openwrt-rpi-4.img.gz`

## TODO
  - Make proper config injection
  - Include USB drivers (Gigabit Ethernet Adapter) 
  - SSH
  - Run builder inside a docker container
  - Test inside QEMU emulator
