## Introduction What is GPFarmer?
This ansible playbook builds LFS conveniently and the main purpose of this project is actually very simple for studying Linux personally From Scratch step by step.

## Where is it from and how is it changed?
It has been developing based on ansible-lfs - https://github.com/sodle/ansible-lfs. sodle! Thanks for sharing it.
Since it only provide simple playbooks I have been converting it to ansible-galaxy type with make utility.

## Ansible Playbooks to Build Linux From Scratch
Tested on Ubuntu 22.04.x LTS.

## Instructions
### Download / Configure / Run LFS Ansible Playbook
#### 1) Clone LFS Ansible Playbook into your Local machine
```
$ git clone https://github.com/rokmc756/LFS
```
#### 2) Go to LFS directory
```
$ cd LFS
```
#### 3) Change password for sudo user of ansible or target host
```
$ vi Makefile
~~ snip
ANSIBLE_HOST_PASS="changeme"    # It should be changed with password of user in ansible host that sudo user would be run.
ANSIBLE_TARGET_PASS="changeme"  # It should be changed with password of sudo user in managed nodes that sudo user would be installed.
~~ snip
```
#### 4) Change your sudo user and password on target host
```
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"     # Replace with username of sudo user
remote_machine_password="changeme"   # Replace with password of sudo user

[lfs_build_hosts]
ubt22-lfs ansible_ssh_host=192.168.1.129    # Change IP address of oracle host
```
#### 5) Set versions and configuration infos of LFS
```
$ vi group_vars/all.yaml

ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"

lfs:
  user: jomoon
  group: jomoon
  # mnt_dir: /home/jomoon/mnt/lfs
  # tools_dir: /home/jomoon/tools
  mnt_dir: /mnt/lfs
  tools_dir: /tools
  binutils_version: "2.43.1"
  gcc_version: "14.2.0"
  glibc_version: "2.35"
  mpc_version: "1.3.1"
  mpfr_version: "4.2.1"
  gmp_version: "6.3.0"
  systemd_version: "12.2"
  root_dev: sdb
  domain: "jtest.pivotal.io"
  net:
    gateway: "192.168.1.1"
    type: "virtual"                  # or physical
    ipaddr0: "192.168.0.12"
    ipaddr1: "192.168.1.12"
    ipaddr2: "192.168.2.12"
```
#### 6) Set hosts and role name
```
$ vi init-hosts.yml
- hosts: all
  become: true
  roles:
    - init-hosts
```

#### 7) Initialize or Uninitialize Build Host
```
$ make init   # or uninit
```

#### 8) Set hosts and role name
```
$ vi setup-lfs.yml
---
- hosts: ubt22-lfs
  become: yes
  vars:
    print_debug: true
  roles:
    - { role: lfs }
```

#### 9) Build LFS at once or seperately
```
$ make build
or
$ make prepare
$ make partition
$ make download
$ make env
$ make bintuils
$ make gcc
```

## Version
This ansible playbook builds initially the [12.2-systemd](http://www.linuxfromscratch.org/lfs/view/12.2-systemd/) latest version of LFS.

## Progress
- [x] Convert Ansible Galaxy type from Original
- [x] Configure host build system, including installing dependencies and patching host system quirks
- [x] Partition, format, and mount the future LFS disk
- [x] Download and verify the LFS packages and patches
- [x] Create the LFS user
- [ ] Define Automatically the software versions such as gcc,mpc,gmp and so on depends on systemd version
- [ ] Uninstall LFS and Unmount Buildroot
- [ ] Build the temporary root
- [ ] Install the base system
- [ ] Configure the system
- [ ] Make the system bootable
- [ ] Make compatibility for Red Hat Based Linux

