FROM arm64v8/debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        sshpass \
        ansible \
        watch \
        ntfs-3g \
        python3-apt \
        zsh \
    && rm -rf /var/lib/apt/lists/*

COPY ansible /ansible
WORKDIR /ansible
RUN mkdir -p /ansible/disks

# Create test block devices to simulate SSD disks
RUN dd if=/dev/zero of=/ansible/disks/disk1.img bs=1M count=1024 && \
    dd if=/dev/zero of=/ansible/disks/disk2.img bs=1M count=1024

RUN mkntfs -F /ansible/disks/disk1.img && \
    mkntfs -F /ansible/disks/disk2.img

#CMD ["ansible-playbook", "/ansible/rpi_multi_services.yaml", "-i", "localhost"]
COPY docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
