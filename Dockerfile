FROM ubuntu:latest

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables
ENV VENV_PATH=/opt/venv
ENV NVM_DIR=/opt/nvm
ENV NODE_VERSION=lts/*
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin"

# Install base system utilities and tools
RUN apt-get update && apt-get install -y \
    curl wget git build-essential ca-certificates gnupg lsb-release procps \
    software-properties-common apt-transport-https unzip vim tree file jq lsof \
    net-tools iproute2 iputils-ping iputils-tracepath iputils-arping \
    iputils-clockdiff dnsutils bind9-dnsutils ldnsutils traceroute tcptraceroute \
    mtr-tiny nmap netcat-openbsd socat rsync duf ncdu \
    iperf3 iftop nethogs iptraf-ng strace htop iotop \
    bridge-utils vlan iptables ipset ebtables arptables conntrack \
    apache2-utils ipcalc mosh ripgrep w3m neovim swaks tmux toilet \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/nvim /usr/bin/vim \
    && ln -sf /usr/bin/nvim /usr/bin/vi

# Install Node.js with nvm and set PATH
RUN mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && npm install -g npm@latest \
    && echo "export NVM_DIR=\"$NVM_DIR\"" >> /root/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc

# Set Node.js in PATH
ENV PATH="${NVM_DIR}/versions/node/$(ls ${NVM_DIR}/versions/node)/bin:${PATH}"

# Install Python tools
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 \
       python3-venv \
       build-essential \
       libffi-dev \
       libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m venv $VENV_PATH \
    && $VENV_PATH/bin/pip install --upgrade pip \
    && $VENV_PATH/bin/pip install \
       magic-wormhole \
       speedtest-cli \
       httpie \
       scapy

# Add Python venv to PATH
ENV PATH="${VENV_PATH}/bin:${PATH}"

# Install Azure CLI
RUN curl -sLS https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install -y azure-cli \
    && az aks install-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Kubernetes tools
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
    | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
    | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && rm -rf /var/lib/apt/lists/* \
    && K9S_VER=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest \
       | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz" \
       | tar xzf - -C /usr/local/bin k9s \
    && chmod +x /usr/local/bin/k9s \
    && curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install -y helm \
    && rm -rf /var/lib/apt/lists/* \
    && KUST_VER=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep -Po '"tag_name": "kustomize/v\K[^"]*') \
    && curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUST_VER}/kustomize_v${KUST_VER}_linux_amd64.tar.gz" \
    | tar xz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/kustomize

# Install CNI plugins
RUN mkdir -p /opt/cni/bin \
    && CNI_VERSION=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo /tmp/cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}/cni-plugins-linux-amd64-v${CNI_VERSION}.tgz" \
    && tar -xzf /tmp/cni-plugins.tgz -C /opt/cni/bin \
    && rm -f /tmp/cni-plugins.tgz

# Install additional container tools
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && NCTL_VER=$(curl -s https://api.github.com/repos/containerd/nerdctl/releases/latest \
        | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/containerd/nerdctl/releases/download/v${NCTL_VER}/nerdctl-${NCTL_VER}-linux-amd64.tar.gz" \
        | tar -C /usr/local/bin -xz \
    && REGCTL_VER=$(curl -s https://api.github.com/repos/regclient/regclient/releases/latest \
        | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/regclient/regclient/releases/download/v${REGCTL_VER}/regctl-linux-amd64" \
        > /usr/local/bin/regctl && chmod +x /usr/local/bin/regctl \
    && LOADER_VER=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest \
        | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/jesseduffield/lazydocker/releases/download/v${LOADER_VER}/lazydocker_${LOADER_VER}_Linux_x86_64.tar.gz" \
        | tar -C /usr/local/bin -xz

# Install DNS tools
RUN DOG_VER=$(curl -s https://api.github.com/repos/ogham/dog/releases/latest | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/ogham/dog/releases/download/v${DOG_VER}/dog-v${DOG_VER}-x86_64-unknown-linux-gnu.zip" -o /tmp/dog.zip \
    && unzip /tmp/dog.zip -d /tmp/dog \
    && mv /tmp/dog/bin/dog /usr/local/bin/ \
    && chmod +x /usr/local/bin/dog \
    && rm -rf /tmp/dog /tmp/dog.zip \
    && DRILL_VER=$(curl -s https://api.github.com/repos/jaywink/drill/releases/latest \
       | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/jaywink/drill/releases/latest/download/drill-linux-amd64.tar.gz" \
       | tar xzf - -C /usr/local/bin drill \
    || true

# Install glow for Markdown reading
RUN curl -L https://github.com/charmbracelet/glow/releases/download/v2.1.0/glow_2.1.0_amd64.deb -o /tmp/glow.deb \
    && dpkg -i /tmp/glow.deb \
    && rm /tmp/glow.deb

# Install yq YAML processor
RUN YQ_VER=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -sL "https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_amd64" -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Configure aliases
RUN echo "alias sco='skopeo'" >> /root/.bash_aliases && \
    echo "alias regctl='regctl'" >> /root/.bash_aliases && \
    echo "alias lazydocker='lazydocker'" >> /root/.bash_aliases && \
    echo "alias wg='wormhole'" >> /root/.bash_aliases && \
    echo "alias dog='dog'" >> /root/.bash_aliases && \
    echo "alias w3='w3m'" >> /root/.bash_aliases && \
    echo "alias yaml='yq'" >> /root/.bash_aliases

# Configure shell
RUN echo "source /root/.bash_aliases" >> /root/.bashrc && \
    echo "source <(kubectl completion bash)" >> /root/.bashrc && \
    echo "complete -o default -F __start_kubectl k" >> /root/.bashrc

# Copy documentation
COPY docs /docs

# Copy welcome message script
COPY docs/welcome-message.sh /usr/local/bin/welcome-message
RUN chmod +x /usr/local/bin/welcome-message

# Configure welcome message
RUN echo '# Show documentation information' >> /root/.bashrc && \
    echo '/usr/local/bin/welcome-message' >> /root/.bashrc

# Set working directory
WORKDIR /workspace

# Install container tools and configure rootless podman
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       podman \
       buildah \
       skopeo \
       sudo \
       libfuse3-dev \
       fuse-overlayfs \
       runc \
    && rm -rf /var/lib/apt/lists/*

# Set up container runtime storage and user namespace configuration for rootless operation
RUN mkdir -p /etc/containers && \
    echo '[storage]' > /etc/containers/storage.conf && \
    echo 'driver = "overlay"' >> /etc/containers/storage.conf && \
    echo 'runroot = "/tmp/podman-run"' >> /etc/containers/storage.conf && \
    echo 'graphroot = "/tmp/podman-graph"' >> /etc/containers/storage.conf && \
    echo "[engine]" > /etc/containers/containers.conf && \
    echo "userns = \"keep-id\"" >> /etc/containers/containers.conf && \
    echo "cgroup_manager = \"cgroupfs\"" >> /etc/containers/containers.conf && \
    echo "runtime = \"runc\"" >> /etc/containers/containers.conf

# Set default command
CMD ["/bin/bash"]
