ARG VERSION_TAG=latest

FROM alpine:${VERSION_TAG}

WORKDIR /root

# Set root password
RUN echo "root:root" | chpasswd

# Download dependencies
RUN apk add --update --no-cache \
    openrc \
    util-linux

# Setup login terminal on ttyS0
RUN ln -s agetty /etc/init.d/agetty.ttyS0 \
    && echo ttyS0 > /etc/securetty \
    && rc-update add agetty.ttyS0 default

# Make sure special file systems are mounted on boot
RUN rc-update add devfs boot \
    && rc-update add procfs boot \
    && rc-update add sysfs boot \
    && rc-update add local default

# The /root directory will contain a script that copies
# files from the mounted docker volume into the mounted
# EXT4 file
COPY root /root

# setup ssh and dhcp
COPY interfaces /etc/network/interfaces

RUN apk add \
        openssh-server \
        dhcpcd \
    && rc-update add dhcpcd \
    && rc-update add sshd \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# ansible
RUN apk add \
        python3 \
        sudo \
    && adduser ansible -D \
    && addgroup ansible wheel \
    && echo "ansible:ansible" | chpasswd

COPY wheel /etc/sudoers.d/wheel

