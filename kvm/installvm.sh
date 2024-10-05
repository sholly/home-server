#!/usr/bin/env bash
qemu-img create -f qcow2 /kvm-nvme/zeus-dev.qcow2 95G
qemu-img create -f qcow2 /kvm-nvme/zeus-z1.qcow2 50G
qemu-img create -f qcow2 /kvm-nvme/zeus-z2.qcow2 50G
qemu-img create -f qcow2 /kvm-nvme/zeus-z3.qcow2 50G
qemu-img create -f qcow2 /kvm-nvme/zeus-z4.qcow2 50G
qemu-img create -f qcow2 /kvm-nvme/zeus-z5.qcow2 50G
qemu-img create -f qcow2 /kvm-nvme/zeus-z6.qcow2 50G
virt-install --name zeus-dev --ram 65536 --vcpus 6 --disk /kvm-nvme/zeus-dev.qcow2 \
	--disk /kvm-nvme/zeus-z1.qcow2 \
	--disk /kvm-nvme/zeus-z2.qcow2 \
	--disk /kvm-nvme/zeus-z3.qcow2 \
	--disk /kvm-nvme/zeus-z4.qcow2 \
	--disk /kvm-nvme/zeus-z5.qcow2 \
	--disk /kvm-nvme/zeus-z6.qcow2 \
      	--network bridge=br0 \
      	--network bridge=zeus192.22 \
	--network bridge=zeus192.31 \
	--network bridge=zeus192.32 \
       	--graphics vnc,listen=0.0.0.0 \
	--cdrom /kvm-nvme/debian-11.6.0-amd64-DVD-1.iso \
	--os-type=linux --os-variant=debian11 --noautoconsole

