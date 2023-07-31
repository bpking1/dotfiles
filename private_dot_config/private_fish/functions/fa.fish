function fa
    FZF_DEFAULT_COMMAND='fd --hidden --exclude={.git,.idea,.cache,.sass-cache,node_modules,build} --type f' FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'" fzf --height 60% --layout reverse --info inline --border --color 'border:#b48ead' $argv
end
