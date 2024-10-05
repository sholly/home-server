#!/usr/bin/env bash
virt-builder --size 10G --format qcow2 fedora-35 -o /kvm_pool/testvm.qcow2 \
	--root-password password:cheese --hostname testvm.lab.internal \
	--firstboot  ./testvm-network.sh \
       --run-command 'useradd -G wheel bobbytables -p ""  '  --run-command 'chage -d 0 bobbytables ' \
       --selinux-relabel
virt-install --import --name testvm --memory 4096 --vcpus 2 --disk /kvm_pool/testvm.qcow2 \
	--network none --graphics none --os-variant fedora33

