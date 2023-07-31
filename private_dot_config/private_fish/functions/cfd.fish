function cfd
    cd (FZF_DEFAULT_COMMAND='fd --hidden --exclude={.git,.idea,.cache,.sass-cache,node_modules,build} --type d' FZF_DEFAULT_OPTS="--preview 'exa -lah -sold {}'" fzf --height 60% --layout reverse --info inline --border --color 'border:#b48ead') $argv
end
