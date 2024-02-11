#!/bin/bash
# Works only with x86 images.

sNAME="openwrt-rpi-4-`date +%Y%m%d-%H%M`"
VMFOLD="~/VirtualBoxVM"
VDI="${sNAME}.vdi"
DISKSIZE='512000000'
VMNAME="${sNAME}"
IMGC=".builds/openwrt-rpi-4.img.gz"
GUNZIP="gunzip"; VBOXMANAGE="VBoxManage"

echo '➜ Create VM.'
$VBOXMANAGE createvm --name $VMNAME --register

echo '➜ Setup VM.'
$VBOXMANAGE modifyvm $VMNAME \
    --description "openwrt vbox" \
    --ostype "Linux26" \
    --memory "512" \
    --cpus "1" \
    --nic1 "bridged" \
    --nictype1 82540EM \
    --nic2 "bridged" \
    --nictype2 82540EM

echo '➜ Add storage.'
$VBOXMANAGE storagectl $VMNAME \
    --name "SATA Controller" \
    --add "sata" \
    --portcount "4" \
    --hostiocache "on" \
    --bootable "on" && \

echo '➜ Convert IMG to VDI.'
mkdir -p ${VMFOLD}/${VMNAME}
$GUNZIP --stdout "${IMGC}" | $VBOXMANAGE convertfromraw --format VDI stdin ${VMFOLD}/${VMNAME}/${VDI} $DISKSIZE

echo '➜ Attach storage.'
$VBOXMANAGE storageattach $VMNAME \
    --storagectl "SATA Controller" \
    --port "1" \
    --type "hdd" \
    --nonrotational "on" \
    --medium $VMFOLD/${VMNAME}/$VDI

exit 0
