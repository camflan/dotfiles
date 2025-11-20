#!/usr/bin/env python

import os
import subprocess
import sys
from typing import Any, List, Union

import dotbot


class Brew(dotbot.Plugin):
    """Custom dotbot plugin for Homebrew management."""

    def can_handle(self, directive: str) -> bool:
        return directive in ["install-brew", "brewfile"]

    def handle(self, directive: str, data: Union[bool, List[str], str]) -> bool:
        if directive == "install-brew":
            return self._handle_install_brew(data)
        elif directive == "brewfile":
            return self._handle_brewfile(data)
        else:
            self._log.error(f"Cannot handle directive: {directive}")
            return False

    def _handle_install_brew(self, data: bool) -> bool:
        """Install Homebrew if not already installed."""
        if not data:
            self._log.lowinfo("Skipping Homebrew installation (disabled)")
            return True

        # Check if brew is already installed
        try:
            subprocess.run(
                ["brew", "--version"],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            self._log.info("Homebrew is already installed")
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            self._log.info("Homebrew not found, attempting to install...")

        # Install Homebrew
        install_script = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        try:
            result = subprocess.run(
                install_script,
                shell=True,
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
            )
            if self._context.defaults().get("homebrew", {}).get("stdout", False):
                self._log.info(result.stdout)
            self._log.info("Homebrew installed successfully")
            return True
        except subprocess.CalledProcessError as e:
            # Don't fail if we can't install brew - might be running in an environment
            # where brew isn't supported (Docker, CI, etc.)
            self._log.warning(
                f"Could not install Homebrew (this is OK if not on macOS/Linux): {e}"
            )
            if self._context.defaults().get("homebrew", {}).get("stderr", False):
                self._log.warning(e.output if hasattr(e, 'output') else str(e))
            # Return True to not block the rest of the dotbot run
            return True

    def _handle_brewfile(self, data: Union[List[str], str]) -> bool:
        """Run brew bundle for specified Brewfile(s)."""
        # Normalize data to list
        if isinstance(data, str):
            brewfiles = [data]
        elif isinstance(data, list):
            brewfiles = data
        else:
            self._log.error(f"Invalid brewfile data type: {type(data)}")
            return False

        if not brewfiles:
            self._log.lowinfo("No Brewfiles specified")
            return True

        # Check if brew is installed
        try:
            subprocess.run(
                ["brew", "--version"],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
        except (subprocess.CalledProcessError, FileNotFoundError):
            self._log.warning(
                "Homebrew is not installed. Skipping brewfile processing. "
                "Run install-brew first or install Homebrew manually."
            )
            return True

        # Process each Brewfile
        success = True
        for brewfile in brewfiles:
            # Resolve path relative to base directory
            brewfile_path = os.path.join(self._context.base_directory(), brewfile)

            if not os.path.exists(brewfile_path):
                self._log.error(f"Brewfile not found: {brewfile_path}")
                success = False
                continue

            self._log.info(f"Running brew bundle for {brewfile}")

            try:
                result = subprocess.run(
                    ["brew", "bundle", "--file", brewfile_path],
                    check=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    cwd=self._context.base_directory(),
                )
                if self._defaults.get("homebrew", {}).get("stdout", False):
                    self._log.info(result.stdout)
                self._log.info(f"Successfully processed {brewfile}")
            except subprocess.CalledProcessError as e:
                self._log.error(f"Failed to process {brewfile}: {e}")
                if self._context.defaults().get("homebrew", {}).get("stderr", False):
                    self._log.error(e.output)
                success = False

        return success
