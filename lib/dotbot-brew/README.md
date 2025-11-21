# Dotbot Brew Plugin

Custom dotbot plugin for managing Homebrew and Brewfiles.

## Features

- Install Homebrew if not already installed
- Run `brew bundle` commands to install packages from Brewfiles

## Usage

### Install Homebrew

```yaml
- install-brew: true
```

This will check if Homebrew is installed and install it if needed.

### Process Brewfiles

```yaml
- brewfile:
    - Brewfile
    - path/to/another/Brewfile
```

Or for a single Brewfile:

```yaml
- brewfile: Brewfile
```

This will run `brew bundle --file <brewfile>` for each specified Brewfile.

## Configuration

You can configure output verbosity in the defaults section:

```yaml
- defaults:
    homebrew:
      stdout: true  # Show stdout from brew commands
      stderr: true  # Show stderr from brew commands
```
