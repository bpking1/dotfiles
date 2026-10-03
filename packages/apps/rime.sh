# name: Rime 雾凇拼音(小鹤双拼)+ 万象语法模型
# scope: desktop

RIME_DIR="$HOME/.local/share/fcitx5/rime"

app_installed() { [ -d "$RIME_DIR/cn_dicts" ]; }
app_install() {
  rm -rf "$HOME/plum"
  git clone --depth 1 https://github.com/rime/plum "$HOME/plum"
  (cd "$HOME/plum" && rime_dir="$RIME_DIR" bash rime-install iDvel/rime-ice)
  (cd "$HOME/plum" && rime_dir="$RIME_DIR" bash rime-install iDvel/rime-ice:others/recipes/grammar:schema=rime_ice)
  (cd "$HOME/plum" && rime_dir="$RIME_DIR" bash rime-install iDvel/rime-ice:others/recipes/config:schema=double_pinyin_flypy)
  rm -rf "$HOME/plum"
}
