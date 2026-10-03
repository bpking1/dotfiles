# name: eilmeldung 终端 RSS 阅读器(GitHub release)
# scope: all

app_installed() { command -v eilmeldung >/dev/null; }
app_install() {
  [ "$(uname -m)" = x86_64 ] || { echo "未适配架构: $(uname -m)"; return 1; }
  local tag tmp; tag=$(gh_tag christo-auer/eilmeldung); tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fSL --progress-bar "https://github.com/christo-auer/eilmeldung/releases/download/${tag}/eilmeldung-x86_64-unknown-linux-musl-${tag}.tar.gz" | tar -xz -C "$tmp"
  install -m755 "$tmp/eilmeldung/eilmeldung" "$BIN/eilmeldung"
}
