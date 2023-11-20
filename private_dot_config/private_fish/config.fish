if status is-interactive
    # Commands to run in interactive sessions can go here
end
# for nvidia driver tarui bug,setted in hyprland conf
# set -x WEBKIT_DISABLE_DMABUF_RENDERER 1
starship init fish | source
lua /usr/share/z.lua/z.lua --init fish | source
