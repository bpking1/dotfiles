if status is-interactive
    # Commands to run in interactive sessions can go here

    # gpg 签名（git commit）时在当前终端弹出密码输入
    set -gx GPG_TTY (tty)
end
# for nvidia driver tarui bug,setted in hyprland conf
# set -x WEBKIT_DISABLE_DMABUF_RENDERER 1
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
if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end


# Added by Antigravity CLI installer
set -gx PATH "/home/hj/.local/bin" $PATH

# opencode
fish_add_path /home/hj/.opencode/bin
