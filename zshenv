#
# Defines environment variables.
#

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


# Android Studio/SDK
export ANDROID_AVD_HOME=$HOME/.android/avd
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

# rust
source "$HOME/.cargo/env"
. "$HOME/.cargo/env"


export CFLAGS="-I$(brew --prefix)/include"
export LDFLAGS="-L$(brew --prefix)/lib"
