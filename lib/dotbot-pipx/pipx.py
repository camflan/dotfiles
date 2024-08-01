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
        print("file: main.py~line: 24~handle", directive, data)

        data = self._maybe_convert_to_dict(data)
        print("file: main.py~line: 27~data", data)

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

        print("file: pipx.py~line: 75~binary", binary, parameters)

        # param = ""
        # if parameters["user_directory"] and is_pip:
        #     param = "--user"

        to_install = data.get("install", [])
        print("file: pipx.py~line: 84~to_install", to_install)

        for req in to_install:
            print("file: pipx.py~line: 87~req", req)
            command = "{} install {}".format(binary, req)

            with open(os.devnull, "w") as devnull:
                result = subprocess.call(
                    command,
                    shell=True,
                    stdin=devnull,
                    stdout=True,  # if parameters["stdout"] else devnull,
                    stderr=True,  # if parameters["stderr"] else devnull,
                    cwd=self.cwd,
                )
                print("file: pipx.py~line: 92~result", result)

                if result not in [0, 1]:
                    raise ValueError("Failed to install requirements.")
