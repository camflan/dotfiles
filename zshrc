# ENV
# loaded from .zshenv

# aliases
alias oh="open ."
alias ls="exa --long --grid --header --classify --all --group-directories-first --git"
alias lsv="/bin/ls"
alias ll="ls -lahL"

alias fg1="fg %1"
alias fg2="fg %2"
alias fg3="fg %3"

alias ggraph="git log --graph --all --decorate --stat --date=iso"
alias gplog="git log --pretty=%B"

alias dc="docker compose"

alias rm="trash"
alias rrm="/bin/rm"

# bat supports paging, syntax highlighting, searching, etc
alias cat="bat"

setopt inc_append_history
setopt share_history
setopt bang_hist
setopt hist_verify

setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt cdable_vars

setopt complete_in_word
setopt list_ambiguous
setopt glob_complete
setopt rec_exact

setopt bad_pattern
setopt equals
setopt extended_glob
setopt glob_dots

setopt noclobber
setopt correct

# detect ARM
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        # echo "Running on Rosetta 2"
        APPLE_SILICON=0
    else
        # echo "Running on native Intel"
        APPLE_SILICON=0
    fi 
elif [ "${arch_name}" = "arm64" ]; then
    # echo "Running on ARM"
    APPLE_SILICON=1
else
    echo "Unknown architecture: ${arch_name}"
fi

# homebrew
# load for Apple Silicon
if [[ "$APPLE_SILICON" = 1 && -a /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export CFLAGS="-I$(brew --prefix)/include"
export LDFLAGS="-L$(brew --prefix)/lib"

# FASD
# Quick jump to directories/etc
# aliased to z and zz
eval "$(fasd --init auto)"

eval "$(starship init zsh)"

# npm completions, from https://github.com/lukechilds/zsh-better-npm-completion
source "${HOME}/conf.d/npm.zsh_completion"
# https://github.com/BuonOmo/yarn-completion
source "${HOME}/conf.d/yarn.zsh_completion"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
 source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# To profile zsh bootup
# zmodload zsh/zprof # top of your .zshrc file
# zprof # keep at the end

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

# https://asdf-vm.com/#/core-manage-asdf
. $HOME/.asdf/asdf.sh

# rust
source "$HOME/.cargo/env"
. "$HOME/.cargo/env"

source /Users/camron/.docker/init-zsh.sh || true # Added by Docker Desktop


# cache the compdump once per day
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

