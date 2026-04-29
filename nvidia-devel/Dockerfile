ARG OVERMIND_VERSION=v2.5.1
ARG OVERMIND=overmind-${OVERMIND_VERSION}-linux-amd64

#
# Overmind
#
FROM alpine:3.19 AS overmind

ARG OVERMIND_VERSION
ARG OVERMIND

ENV OVERMIND_FILE=overmind-${OVERMIND_VERSION}-linux-amd64.gz

ENV OVERMIND_URL=https://github.com/DarthSim/overmind/releases/download/${OVERMIND_VERSION}/${OVERMIND_FILE}

WORKDIR /

RUN wget "$OVERMIND_URL" && gunzip ${OVERMIND_FILE} && chmod +x "$OVERMIND"


#
# Main
#
FROM nvidia/cuda:13.2.1-cudnn-devel-ubuntu24.04

ARG OVERMIND
ARG USERNAME=idp
ARG UID=1000
ARG GID=1000

ENV OVERMIND_CAN_DIE=startup

RUN apt update && apt install -y \
    curl \
    tmux \
    tzdata \
    iproute2 \
    iptables \
    sudo

RUN curl -fsSL https://tailscale.com/install.sh | sh

# Only if you require a base user account to tailscale ssh into

# RUN usermod -d /workspace ubuntu \
#     && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
#     && chmod 0440 /etc/sudoers.d/ubuntu

VOLUME /workspace

WORKDIR /

COPY --from=overmind /${OVERMIND} /usr/bin/overmind

COPY Procfile .
COPY start.sh .

CMD ["overmind", "start"]