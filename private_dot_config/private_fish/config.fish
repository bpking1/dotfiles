if status is-interactive
    # Commands to run in interactive sessions can go here

    # gpg 签名（git commit）/ chezmoi 解密时在当前终端弹出密码输入
    # tmux 下 gpg-agent 会缓存旧 tty，须每个 prompt 刷新，否则 pinentry 卡住不弹窗
    function __gpg_update_tty --on-event fish_prompt
        set -gx GPG_TTY (tty)
        gpg-connect-agent updatestartuptty /bye >/dev/null
    end
end
# for nvidia driver tarui bug,setted in hyprland conf
# set -x WEBKIT_DISABLE_DMABUF_RENDERER 1
# mise 必须先于 starship 激活(starship/yazi 由 mise 提供)
if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end
if type -q starship
    starship init fish | source
end
if test -f /usr/share/z.lua/z.lua
    lua /usr/share/z.lua/z.lua --init fish | source
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
export PATH="$HOME/.local/bin:$PATH"


# Added by Antigravity CLI installer
set -gx PATH "/home/hj/.local/bin" $PATH

# opencode
fish_add_path /home/hj/.opencode/bin
