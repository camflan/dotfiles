# ZSH configuration is stored in another location
# Ths will tell ZSH where to load from and allow
# usage of our own zshenv

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"

# my DOTFILES config path
export CBFDOTFILES_DIR=$HOME/dotfiles

. $ZDOTDIR/.zshenv
