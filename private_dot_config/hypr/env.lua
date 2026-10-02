-- 环境变量

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")

-- fcitx5 输入法:Wayland 下推荐不设 GTK/QT IM 模块,
-- 应用直接走 text-input-v3 协议(fcitx5 waylandim 前端);
-- XMODIFIERS 仅给 XWayland 应用兜底。Chromium 系应用需 --enable-wayland-ime。
hl.env("XMODIFIERS", "@im=fcitx")
