# add the IP address, username and hostname of the target hosts here
USERNAME=jomoon
COMMON="yes"
ANSIBLE_HOST_PASS="changeme"
ANSIBLE_TARGET_PASS="changeme"
ANSIBLE_PLAYBOOK_CMD="ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts'"

# include ./*.mk

GPHOSTS := $(shell grep -i '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ./ansible-hosts | sed -e "s/ ansible_ssh_host=/,/g")

all:
	@echo ""
	@echo "[ Available targets ]"
	@echo ""
	@echo "init:            will install basic requirements (will ask several times for a password)"
	@echo "install:         will install the host with what is defined in install.yml"
	@echo "update:          run OS updates"
	@echo "ssh:             jump ssh to host"
	@echo "available-roles: list known roles which can be downloaded"
	@echo "clean:           delete all temporary files"
	@echo ""
	@for GPHOST in ${GPHOSTS}; do \
		IP=$${GPHOST#*,}; \
		HOSTNAME=$${LINE%,*}; \
		echo "Current used hostname: $${HOSTNAME}"; \
		echo "Current used IP: $${IP}"; \
		echo "Current used user: ${USERNAME}"; \
		echo ""; \
	done


init: init-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} init-hosts.yml --tags="init"

uninit: init-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} init-hosts.yml --tags="uninit"

build: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="build"

prepare: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="prepare"

partition: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="partition"

download: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="download"

env: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="env"

binutils: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="binutils"

gcc: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="gcc"

headers: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="headers"

glibc: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="glibc"

libstdc: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="libstdc"

temp-tools: setup-lfs.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ansible-hosts -u ${USERNAME} setup-lfs.yml --tags="temp-tools"


boot: control-vms.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} control-vms.yml --extra-vars "power_state=powered-on power_title=Power-On VMs"

shutdown: control-vms.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} control-vms.yml --extra-vars "power_state=shutdown-guest power_title=Shutdown VMs"

clean:
	rm -rf ./known_hosts install.yml update.yml

.PHONY:	all init install update ssh common clean no_targets__ 
