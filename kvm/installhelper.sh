#!/usr/bin/env bash
virt-builder --size 10G --format qcow2 fedora-35 -o /kvm-nvme/zeushelper.qcow2 \
	--root-password password:cheese --hostname zeushelper.lab.internal \
	--firstboot  ./zeushelper-network.sh \
       --run-command 'useradd -G wheel bobbytables -p ""  '  --run-command 'chage -d 0 bobbytables ' \
       --selinux-relabel
virt-install --import --name zeushelper --memory 4096 --vcpus 2 --disk /kvm-nvme/zeushelper.qcow2 \
	--network bridge=zeus192.22 --graphics none --os-variant fedora35

