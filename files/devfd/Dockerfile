FROM fedora:latest

# 安装基础工具和依赖
RUN dnf update -y && \
    dnf install -y wget git unzip

# 安装 fish
RUN dnf install -y fish && chsh -s /usr/bin/fish

# 安装 ripgrep, fd, exa, broot, duf, dog, fzf, jq, cheat-bin, file(for yazi), bat
RUN dnf install -y ripgrep fd exa fzf jq cheat gitui lua file bat p7zip p7zip-plugins

# font ,好像不用安装字体，需要在terminal设置nerd fonts就可以了
# RUN dnf install -y fontconfig fira-code-fonts

# install lazygit
RUN dnf copr enable atim/lazygit -y && \
    dnf install -y lazygit

# 安装 dotnet core
RUN dnf install -y dotnet-sdk-9.0

# 安装 syncthing
RUN dnf install -y syncthing

# forgit 不好安装

# 安装 tmux,neovim
RUN dnf install -y tmux neovim

# install z.lua

RUN git clone https://github.com/skywind3000/z.lua.git /usr/share/z.lua

# install starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# yazi
RUN curl -sL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip" -o yazi.zip && \
    unzip yazi.zip && \
    mv yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin && \
    rm yazi.zip && \
    rm -rf yazi-x86_64-unknown-linux-musl

# cliflux
RUN curl -L "https://github.com/spencerwi/cliflux/releases/latest/download/cliflux_amd64" -o /usr/local/bin/cliflux && chmod +x /usr/local/bin/cliflux
# chezmoi 同步就行了
#RUN mkdir -p /root/.config/cliflux && \
#    cat <<EOF > /root/.config/cliflux/config.toml
#server_url = "http://123.xyz:8033"
#api_key = "123456"
#allow_invalid_certs = true
#EOF

# 设置工作目录
WORKDIR /root/workspace

# 创建开发用户 (可选，如果需要非root用户)
# RUN useradd -ms /bin/bash developer

# 切换到开发用户 (可选)
# USER developer

# 启动命令 (根据你的需求修改)
CMD ["/usr/bin/fish"]  # 保持容器运行
# 或者
# CMD ["tmux", "new-session", "-d"] # 启动 tmux
