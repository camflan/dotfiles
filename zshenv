# ZSH configuration is stored in another location
# Ths will tell ZSH where to load from and allow
# usage of our own zshenv

# Setup XDG locations
# Use MacOS cache location
export XDG_CACHE_HOME=$HOME/Library/Caches

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"

# my DOTFILES config path
export CBFDOTFILES_DIR=$HOME/dotfiles

. $ZDOTDIR/.zshenv
