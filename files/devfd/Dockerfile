FROM fedora:latest

# 安装基础工具和依赖
RUN dnf update -y && \
    dnf install -y wget git unzip

# 安装 fish
RUN dnf install -y fish && chsh -s /usr/bin/fish

# 安装 ripgrep, fd, exa, broot, duf, dog, fzf, jq, cheat-bin
RUN dnf install -y ripgrep fd exa fzf jq cheat gitui

# 安装 lazyvim
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim && rm -rf ~/.config/nvim/.git

# 安装 dotnet core
RUN dnf install -y dotnet-sdk-9.0

# 安装 syncthing
RUN dnf install -y syncthing

# forgit 不好安装

# 安装 tmux,neovim
RUN dnf install -y tmux neovim

# yazi
RUN curl -sL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip" -o yazi.zip && \
    unzip yazi.zip && \
    mv yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin && \
    rm yazi.zip && \
    rm -rf yazi-x86_64-unknown-linux-musl

# 设置工作目录
WORKDIR /home/developer

# 创建开发用户 (可选，如果需要非root用户)
# RUN useradd -ms /bin/bash developer

# 切换到开发用户 (可选)
# USER developer

# 配置 lazyvim (可选，可以复制自己的配置)
# COPY .config/nvim /home/developer/.config/nvim

# 暴露端口 (如果需要)
# EXPOSE 8080

# 启动命令 (根据你的需求修改)
# CMD ["/bin/bash"]  # 保持容器运行
# 或者
# CMD ["tmux", "new-session", "-d"] # 启动 tmux
