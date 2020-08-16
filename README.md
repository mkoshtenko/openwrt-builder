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
TODO: these steps should be grouped in a shell script.

Create and run the virtual machine:
```
$ vagrant up
```

Connect to the builder over SSH:
```
$ vagrant ssh
```

Create builder folder:
```
$ mkdir builder
$ cd builder
```

Download and unpack the image builder:
```
$ wget https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz
$ tar --strip-components=1 -xf openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz
```

Build new image:
```
$ make image PROFILE=rpi-4 PACKAGES="python"
$ exit
```

Copy the image to the host machine:
```
$ vagrant plugin install vagrant-scp
$ vagrant scp default:/home/vagrant/builder/bin/targets/bcm27xx/bcm2711/openwrt-bcm27xx-bcm2711-rpi-4-ext4-factory.img.gz .
```

Stop and destroy the VM:
```
$ vagrant halt
$ vagrant destroy
```
