#
# Defines environment variables.
#

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

# configure FZF to use rg, not to ignore hidden files, but to ignore .git
export FZF_DEFAULT_COMMAND='rg --hidden --files --smart-case'

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# ASDF
# Store asdf data outside of config
export ASDF_DATA_DIR=$HOME/.asdf-data
if [[ ! -a $ASDF_DATA_DIR ]]; then
  mkdir -p $ASDF_DATA_DIR
fi

# Created by `pipx` on 2022-03-07 19:40:36
export PATH="$PATH:/Users/camron/.local/bin"

# add poetry to path
export PATH="$HOME/.poetry/bin:$PATH"

# add volta to path
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# yarn globals
export PATH="$HOME/.yarn/bin:$PATH"

# Android Studio/SDK
export ANDROID_AVD_HOME=$HOME/.android/avd
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/bin/google-cloud-sdk/path.zsh.inc'; fi
if [ -f "$HOME/bin/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/bin/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/bin/google-cloud-sdk/completion.zsh.inc'; fi
if [ -f "$HOME/bin/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/bin/google-cloud-sdk/completion.zsh.inc"; fi

