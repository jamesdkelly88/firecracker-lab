ARG VERSION_TAG=latest

FROM debian:${VERSION_TAG}

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Download dependencies

RUN apt update \
    && apt install -y \
        dbus \
        iproute2 \
        libc6 \
        libpam-systemd \
        openssh-server \
        python-is-python3 \
        sudo \
        systemd \
        systemd-sysv \
        udev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Set root password
RUN echo "root:root" | chpasswd

# Allow root login over SSH (optional)
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create minimal fstab
RUN echo "proc /proc proc defaults 0 0" > /etc/fstab

# The /root directory will contain a script that copies
# files from the mounted docker volume into the mounted
# EXT4 file
COPY root /root

# Enable DHCP on eth0
RUN printf "[Match]\nName=eth0\n\n[Network]\nDHCP=yes\n" > /etc/systemd/network/eth0.network

# Enable systemd-networkd
RUN systemctl enable systemd-networkd

# Ansible
RUN useradd -m -G sudo -s /bin/bash ansible  \
    && echo "ansible:ansible" | chpasswd

# Clean machine-id (important for cloning)
RUN truncate -s 0 /etc/machine-id