# Preseeding only locale sets language, country and locale.
d-i debian-installer/locale string en_US
# Keyboard selection.
d-i keyboard-configuration/xkb-keymap select us

# Load non-free firmware
d-i hw-detect/load_firmware boolean true

# Static network
d-i netcfg/disable_dhcp boolean true
d-i netcfg/disable_autoconfig boolean true
d-i netcfg/choose_interface select enp1s0
d-i netcfg/get_ipaddress string 172.31.1.10
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string 172.31.1.1
d-i netcfg/get_nameservers string 1.1.1.1 4.4.4.4
d-i netcfg/get_hostname string pan
d-i netcfg/get_domain lab.internal
d-i netcfg/confirm_static boolean true
d-i netcfg/get_ipaddress seen true
d-i netcfg/get_netmask seen true



# User account has sudo, no root
d-i passwd/root-login boolean false
#d-i passwd/make-user boolean false
# To create a normal user account.
d-i passwd/user-fullname string Ansible User
d-i passwd/username string ansible
# Normal user's password, either in clear text
d-i passwd/user-password password changeme
d-i passwd/user-password-again password changeme

#Clock/TimeZone
d-i clock-setup/utc boolean true
d-i time/zone string America/Denver
d-i clock-setup/ntp boolean true

# Partitioning
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string lvm
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-auto/choose_recipe select atomic
# This makes partman automatically partition without confirmation, provided
# that you told it what to do using one of the methods above.
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# ensure GPT partition
d-i partman-efi/non_efi_system boolean true
d-i partman-partitioning/choose_label select gpt
d-i partman-partitioning/default_label string gpt

# Mirror
d-i mirror/country string manual
d-i mirror/http/hostname string http.us.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true
d-i apt-setup/use_mirror boolean true
# Avoid CD/DVD scan
d-i apt-setup/disable-cdrom-entries	boolean	true
d-i apt-setup/cdrom/set-first boolean false
d-i apt-setup/cdrom/set-next boolean false
#d-i apt-setup/cdrom/set-failed boolean false


tasksel tasksel/first multiselect ssh-server

popularity-contest popularity-contest/participate boolean false

d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev string /dev/sda

# Avoid that last message about the install being complete.
d-i finish-install/reboot_in_progress note

d-i preseed/late_command string \
                in-target apt-get install -y git ansible
