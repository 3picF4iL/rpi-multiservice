FROM arm64v8/debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-apt \
        sshpass \
        ntfs-3g \
        systemctl \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache --upgrade pip setuptools
RUN python3 -m pip install \
	requests \
	ansible \
	ansible-cmdb

RUN ansible-galaxy collection install community.general

RUN mkdir -p /ansible/disks
WORKDIR /ansible

# Create test block devices to simulate SSD disks
RUN dd if=/dev/zero of=/ansible/disks/disk1.img bs=1M count=1024 && \
    dd if=/dev/zero of=/ansible/disks/disk2.img bs=1M count=1024

RUN mkntfs -F /ansible/disks/disk1.img && \
    mkntfs -F /ansible/disks/disk2.img

COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
