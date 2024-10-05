# My Little Home Server


## Introduction

I've been running a home server since 2006.  It started as a place to store files and hack around.  It now stores all my data, 
and hosts most of the services for my home network. The problem with 
stuff like this is, I always seem to forget how something was configured, or I took terrible notes. Now I configure everything
in the lab with Ansible, and these are the playbooks. 

## The server

The current iteration of this machine has the following specs: 

* Ryzen 5600 6 core CPU. 
* 64GB ECC ram. 
* 1TB NVME boot drive. 
* 6x16TB HDD's in a raidz2 array. 
* Nvidia 2070 Super, for Frigate object detection and Jellyfin transcoding
* 2x 10GB SFP ports, 2x 1G ethernet.  
    1. MacVLAN, Storage
    2. MacVLAN 
    3. MacVLAN
    4. MacVTAP for KVM

Each of the 4 interfaces above is given its own separate VLAN and Class C network, attached to a layer 3 switch. 
I like this approach because it allows me to run multiple DNS servers, and trivializes issues like
ssh listening ports for a gitea server.  


## What the playbooks do


### Development
1.  Mostly-Automated Debian KVM VM install via network-hosted preseed.  Sets up network, disk partition, ansible user, and ssh keys. 
2.  Sets up the development KVM to mirror production as closely as possible.  

### Production
1. Automated Debian preseed install on bare metal. 
2. Configures the production server. 

## Layout

I'm attempting to follow the best practices noted here: 

[Ansible Best Practices](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)

### Playbooks

* site.yaml: this configures the entire server, in dependent order.  
* services.yaml: installs and configures all the docker containers. 

Most of the others are single-purpose playbooks that mostly call their respective roles. 


### Inventory

1. Development:  For creating the development VM
2. Production
3. Production_kvm:  This was an attempt at creating Debian VM based wireguard, superseded

In both inventories, note the secrets.yaml.  I put all sensitive data here.  If this is committed to git, run 

`ansible-vault encrypt secrets.yaml` 

to encrypt the file. 

### Roles

Most of the functionality is in roles.  For some it might be overkill, but it keeps things neat and tidy.  


## How to Use

### Development

Run the dev_vm playbook to set up the KVM storage pool, networks, preseed, and the VM. 

```
ansible-playbook -i inventory/development/ dev_vm.yaml --ask-vault-pass
```

The VM will have a VNC console by default. 

`virsh vncdisplay $VM`

gives you the VM port number


Connect, login as ansible, clone this repo, run playbooks, and test. 

To clean up: 

```
ansible-playbook -i inventory/development/ dev_vm_destroy.yaml --ask-vault-pass
```


### Production.

1.  Configure production inventory
2.  Clone this code on a machine that will be on the same network as the server. 
3.  Start the preseed container: 
    
    `ansible-playbook -i inventory/development/ podman_preseed.yaml --ask-vault-pass`
4.  Start debian installer, select 'automated install'
5.  Set up the network with DHCP or a throwaway static ip. 
6.  When prompted, give it the preseed URL: 'http://1.2.3.4/preseed.cfg'
7.  Finish install.  
8.  Clone repo on freshly installed server.  
9.  Run playbooks up to network (The network playbook will fail since the config changed and things won't restart properly)
10. Reboot after error, finish with the rest of the playbooks.  


Running a specific playbook: 

```
ansible-playbook -i inventory/development/ network.yaml -K --ask-vault-pass
```

run all: 

```
ansible-playbook -i inventory/development/ site.yaml -K --ask-vault-pass
```
## Notes on ZFS

I create a raidz2 pool if it doesn't exist.  Then I create the defined zfs filesystems.  

TODO: The code is supposed to check the zfs_create_pool flag, but it doesn't do so, this will be fixed *soon*...

## Notes on backups

### Backup scripts

The backups role handles creating simple backup scripts for services.  This is mostly stopping a container, rsyncing its
persistent directory to backup, then starting the container.  There are a few,  such as gitea, that require extra steps like
the Postgres database dump, and the `gitea-dump` command inside the container. 


### Sanoid/Syncoid

There is an excellent open-source project for ZFS backups called [Sanoid](https://github.com/jimsalterjrs/sanoid).

Sanoid handles creating ZFS snapshots on a schedule, so I utilize that here.  

Syncoid handles syncing ZFS snapshots to another ZFS pool.  Offsite backups are accomplished by creating ZFS pools on 
external hard drives, and letting syncoid sync up the snapshots.  


## Notes on specific services


### CoreDNS & Adguard

CoreDNS acts as local DNS server, and forwards upstream queries to Adguard.  This way we get local, ad-blocked DNS. 
The same stack is on another machine on the network to provide redundant DNS. 

### Gluetun, Sabnzbd, Sonarr, and Radarr

Gluetun is meant to pass all traffic from Sabnzbd, Sonarr, and Radarr through a VPN, so Sabnzbd, Sonarr, and Radarr are 
attached to Gluetun's network.

## Frigate

Open source security camera system.   I share the GPU between this and Jellyfin via the Nvidia Container Toolkit.
