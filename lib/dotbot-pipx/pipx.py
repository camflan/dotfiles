import os
import subprocess

import dotbot


class Brew(dotbot.Plugin):
    _pipx_directive = "pipx"

    # Default outputs
    _default_stdout = False
    _default_stderr = False
    _use_user_directory = False

    _supported_directives = [
        _pipx_directive,
    ]

    # API methods

    def can_handle(self, directive):
        return directive in self._supported_directives

    def handle(self, directive, data):
        data = self._maybe_convert_to_dict(data)

        try:
            self._handle_install(directive, data)
            return True
        except ValueError as e:
            self._log.error(e)
            return False

    # Utility

    @property
    def cwd(self):
        return self._context.base_directory()

    # Inner logic

    def _maybe_convert_to_dict(self, data):
        if isinstance(data, str):
            return {"file": data}
        return data

    def _get_binary(self, directive, data):
        """
        Return correct binary path.
        """
        if data.get("binary", False):
            return data.get("binary")

        return directive

    def _get_parameters(self, data):
        """
        Prepare the optional parameters
            :param self:
            :param data:
        """
        parameters = {
            "stdout": data.get("stdout", self._default_stdout),
            "stderr": data.get("stderr", self._default_stderr),
            "user_directory": data.get("user", self._use_user_directory),
        }
        return parameters

    # Handlers

    def _handle_install(self, directive, data):
        binary = self._get_binary(directive, data)
        parameters = self._get_parameters(data)

        to_install = data.get("install", [])

        for req in to_install:
            command = f"{binary} install {req}"

            with open(os.devnull, "w") as devnull:
                result = subprocess.call(
                    command,
                    shell=True,
                    stdin=devnull,
                    stdout=True if parameters["stdout"] else devnull,
                    stderr=True if parameters["stderr"] else devnull,
                    cwd=self.cwd,
                )

                if result not in [0, 1]:
                    raise ValueError(f"Failed to install {req}")
