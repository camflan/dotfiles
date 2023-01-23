# aliases
alias oh="open ."
alias ls="exa --long --grid --header --classify --all --group-directories-first --git"
alias lsv="/bin/ls"
alias ll="ls -lahL"
alias con="tail -40 -f /var/log/system.log"

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
alias tel="telepresence"

export REPORTTIME=15

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

export EDITOR="nvim"
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
export TERM=xterm-256color

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

export PAGER='bat'

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

export PATH="$HOME/.yarn/bin:$PATH"

# homebrew
# load for Apple Silicon
if [[ "$APPLE_SILICON" = 1 && -a /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# configure FZF to use rg, not to ignore hidden files, but to ignore .git
export FZF_DEFAULT_COMMAND='rg --hidden --files --smart-case'

### GCLOUD# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/bin/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/bin/google-cloud-sdk/completion.zsh.inc'; fi


# cache the compdump once per day
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# FASD
eval "$(fasd --init auto)"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
 source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

eval "$(starship init zsh)"

# npm completions, from https://github.com/lukechilds/zsh-better-npm-completion
source "${HOME}/conf.d/npm.zsh_completion"
# https://github.com/BuonOmo/yarn-completion
source "${HOME}/conf.d/yarn.zsh_completion"

function delete-branches() {
  local branches_to_delete
  branches_to_delete=$(git branch | fzf --multi)

  if [ -n "$branches_to_delete" ]; then 
    git branch --delete --force $branches_to_delete
  fi
}


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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/bin/google-cloud-sdk/path.zsh.inc'; fi
if [ -f "$HOME/bin/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/bin/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/bin/google-cloud-sdk/completion.zsh.inc'; fi
if [ -f "$HOME/bin/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/bin/google-cloud-sdk/completion.zsh.inc"; fi


source /Users/camron/.docker/init-zsh.sh || true # Added by Docker Desktop
