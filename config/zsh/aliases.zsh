# aliases
alias oh="open ."

alias ls="eza --long --grid --header --classify --all --group-directories-first --git"
alias lsv="/bin/ls"
alias ll="ls -lahL"

# foregrounds a backgrounded job
alias fg1="fg %1"
alias fg2="fg %2"
alias fg3="fg %3"

alias sbook="cd $HOME/src/srcbook; npm run start"

# opens oil in neovim
alias oil="nvim -c Oil"

alias dc="docker compose"
alias nr="npm run"

# bat supports paging, syntax highlighting, searching, etc
alias cat="bat"

alias -s html=open

# temporary alias to my neovim 12 config
alias n12="mise r neovim-nightly"

tempe () {
    cd "$(mktemp -d)"
    chmod -R 0700 .
    if [[ $# -eq 1 ]]; then
        \mkdir -p "$1"
        cd "$1"
        chmod -R 0700 .
    fi
}
