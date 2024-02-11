# openwrt-builder

This project contains all necessary files to build a custom OpenWRT image for Raspberry Pi model 4 or CM4 with the following additions to the oficial image:
- has all dependencies for Ansible support;
- supports [RPi CM4 DFRobot Carrier Board Mini](https://wiki.dfrobot.com/Compute_Module_4_IoT_Router_Board_Mini_SKU_DFR0767).

The latest Raspberry Pi 4 compatible image can be downloaded from the official OpenWRT website from the target [bcm2711](https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/)

## How it works
Custom OpenWRT images can be created with the official bcm2711 image builder. This image builder is stored in the same folder with the original build `openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz`. 
The builder requires Linux-based operating system running on x86_64 CPU.

Vagrant prepares a virtual Debian host using Ansible playbook for building a new image. It uses VirtualBox as a provider for virtual hosts.
The `build.sh` script downloads all necessary files on the virtual host, runs all build steps and returns the final build to the workstation.

If your workstation is a linux host, you don't need a virtual machine and can execute `scripts/build.sh` directly from the repo's root folder.

## Hardware RPi-4 setup
```
                                        |
                                  ______| lan = 1Gb/s
                                 /      |___________________
                   --eth0 ------/         PoE IEEE 802.3af/at SWITCH
RPi4(w/ PoE hat)--|                     ____________________
                   --eth1-usb3 -\       |
                                 \_____ | wan = 1Gb/s       [------ CABLE/FIBRE
                                        |___________________
                                          ISP MODEM
```


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
