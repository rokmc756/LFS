
[ ERROR 1 ]

$ ansible-playbook -i inventory/host.yml main.yml

TASK [Disable Ubuntu's annoying habit of automounting newly formatted disks] ******************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "cmd": "gsettings set org.gnome.desktop.media-handling automount false", "msg": "[Errno 2] No such file or directory", "rc": 2}
        to retry, use: --limit @/root/LFS/main.retry

-> apt install dconf-editor libglib2.0-bin

https://www.suse.com/support/kb/doc/?id=000019002


[ ERROR 2 ]

TASK [Create a new MBR label on the disk, along with the boot partition] **********************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "err": "Error: Could not stat device /dev/vdb - No such file or directory.\n", "msg": "Error while getting device information with parted script: '/sbin/parted -s -m /dev/vdb -- unit 'KiB' print'", "out": "", "rc": 1}
        to retry, use: --limit @/root/LFS/main.retry

-> vi partition.yml
vdb -> sdb


[ ERROR 3 ]
TASK [Create the root partition] **************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: list object has no element 0\n\nThe error appears to have been in '/root/LFS/partition.yml': line 14, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: Create the root partition\n  ^ here\n"}
        to retry, use: --limit @/root/LFS/main.retry


[ ERROR 4 ]
TASK [Download the sources list] **************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "dest": "/mnt/lfs/sources/wget-list", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "http://www.linuxfromscratch.org/lfs/view/8.3-systemd/wget-list"}
        to retry, use: --limit @/root/LFS/main.retry

# dpkg --list | grep systemd
~~ snip
ii  systemd                                237-3ubuntu10.57                                amd64        system and service manager
ii  systemd-sysv                           237-3ubuntu10.57                                amd64        system and service manager - SysV links


# vi download_sources.yml

- name: Download the sources list
  get_url:
    url: http://www.linuxfromscratch.org/lfs/view/10.0-systemd/wget-list
    dest: "{{ lfs_root }}/sources/wget-list"
    # url: http://www.linuxfromscratch.org/lfs/view/8.3-systemd/wget-list


[ ERROR 5 ]

failed: [localhost] (item=https://prdownloads.sourceforge.net/expat/expat-2.2.9.tar.xz) => {"changed": false, "dest": "/mnt/lfs/sources/expat-2.2.9.tar.xz", "item": "https://prdownloads.sourceforge.net/expat/expat-2.2.9.tar.xz", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "https://prdownloads.sourceforge.net/expat/expat-2.2.9.tar.xz"}


https://sourceforge.net/projects/expat/files/expat/2.2.9/

~~ snip

failed: [localhost] (item=http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz) => {"changed": false, "dest": "/mnt/lfs/sources/libpipeline-1.5.3.tar.gz", "item": "http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz"}
changed: [localhost] => (item=http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz)

https://download-mirror.savannah.gnu.org/releases/libpipeline/

~~ snip

changed: [localhost] => (item=http://ftp.gnu.org/gnu/make/make-4.3.tar.gz)
failed: [localhost] (item=http://download.savannah.gnu.org/releases/man-db/man-db-2.9.3.tar.xz) => {"changed": false, "dest": "/mnt/lfs/sources/man-db-2.9.3.tar.xz", "item": "http://download.savannah.gnu.org/releases/man-db/man-db-2.9.3.tar.xz", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "http://download.savannah.gnu.org/releases/man-db/man-db-2.9.3.tar.xz"}

https://download-mirror.savannah.gnu.org/releases/man-db/

~~ snip

failed: [localhost] (item=https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.3.tar.xz) => {"changed": false, "dest": "/mnt/lfs/sources/psmisc-23.3.tar.xz", "item": "https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.3.tar.xz", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.3.tar.xz"}

# wget https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.4.tar.xz

~~ snip

failed: [localhost] (item=http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.97.tar.xz) => {"changed": false, "dest": "/mnt/lfs/sources/sysvinit-2.97.tar.xz", "item": "http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.97.tar.xz", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.97.tar.xz"}

# https://download-mirror.savannah.gnu.org/releases/sysvinit/

~~ snip

failed: [localhost] (item=https://zlib.net/zlib-1.2.11.tar.xz) => {"changed": false, "dest": "/mnt/lfs/sources/zlib-1.2.11.tar.xz", "item": "https://zlib.net/zlib-1.2.11.tar.xz", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "state": "absent", "status_code": 404, "url": "https://zlib.net/zlib-1.2.11.tar.xz"}

https://www.zlib.net/fossils/zlib-1.2.11.tar.gz


[ ERROR 6 ]

make[2]: Entering directory '/mnt/lfs/sources/gcc-10.2.0/build/mpfr'
CDPATH="${ZSH_VERSION+.}:" && cd ../../mpfr && /bin/sh /mnt/lfs/sources/gcc-10.2.0/mpfr/missing aclocal-1.16 -I m4
/mnt/lfs/sources/gcc-10.2.0/mpfr/missing: line 81: aclocal-1.16: command not found

~~ snip
apt install automake
apt install automake1.11



