if status is-interactive
    # Commands to run in interactive sessions can go here
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
~/.local/bin/mise activate fish | source


# Added by Antigravity CLI installer
set -gx PATH "/home/hj/.local/bin" $PATH

# opencode
fish_add_path /home/hj/.opencode/bin
