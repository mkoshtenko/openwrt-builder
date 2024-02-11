# openwrt-builder

This project contains all necessary files to build a custom OpenWRT image for Raspberry Pi model 4, which can be provisioned with Ansible immediately after the installation. 

The latest Raspberry Pi 4 compatible image can be downloaded from the official OpenWRT website. 
The image should be taken from the target:
  - [bcm2711](https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/)

## How it works
Custom OpenWRT images can be created with an image builder for bcm2711 target. This image builder is stored in the same folder with an original build.
`openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz`

The image builder will be downloaded and executed in a virtual machine with Debian OS that is managed by Vagrant. The virtual machine uses VirtualBox as a provider and Ansible as a provisioning tool.

## Build Requirements
Created image should be compatible with Ansible:
  - `python` package installed
  - key-based ssh enabled

Created image should be compatible with [RPi CM4 DFRobot Carrier Board Mini](https://wiki.dfrobot.com/Compute_Module_4_IoT_Router_Board_Mini_SKU_DFR0767):
  - NIC driver `kmod-r8169`
  - USB Contour driver `kmod-usb-dwc2`
  - Raspberry Pi user utilities `bcm27xx-userland`

## OSX Steps
Install all dependencies before moving forward
  - Vagrant `brew install vagrant`
  - Ansible `brew install ansible`
  - VirtualBox can be downloaded from https://www.virtualbox.org
    - Note: ARM64(aka Apple CPU) hosts are not supported at the moment   

Clone the builder repo:
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
vagrant ssh -c './scripts/build.sh'
```

Clean up:
```
vagrant destroy
```

The image file should be in `./builds` directory, e.g. `./builds/openwrt-rpi-4.img.gz`

## Troubleshooting
Run Ansible playbook w/o destroying the deployment:
```
vagrant provision
```
