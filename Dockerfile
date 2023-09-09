ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND noninteractive

ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_DEFAULT_REGION=

SHELL [ "/bin/bash", "-c" ]

ARG AWSCLI_VERSION

RUN apt update && apt install -y zip curl mandoc less jq socat && \
    arch=$(dpkg --print-architecture) && \
    if [[ "$arch" == "amd64" ]]; then aws_cli_arch=x86_64; else aws_cli_arch=aarch64; fi && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${aws_cli_arch}-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws/install && \
    apt remove -y zip

# session manager plugin
RUN arch=$(dpkg --print-architecture) && \
    if [[ "$arch" == "amd64" ]]; then aws_ssm_arch=64bit; else aws_ssm_arch=arm64; fi && \
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_${aws_ssm_arch}/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
    dpkg -i session-manager-plugin.deb && \
    rm -rf session-manager-plugin.deb

COPY ./setup-tunnel.sh /setup-tunnel.sh
RUN chmod +x /setup-tunnel.sh

ENTRYPOINT ["/setup-tunnel.sh"]
