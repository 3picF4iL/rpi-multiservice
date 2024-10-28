FROM arm64v8/debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        sshpass \
        ansible \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ansible
COPY ../ansible /ansible/

CMD ["ansible-playbook", "/ansible/rpi_multi_services.yaml", "-i", "localhost"]
