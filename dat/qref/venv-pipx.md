# Python Virtual Environments

A Python virtual environment
([venv](https://docs.python.org/3/library/venv.html)) is a self contained
Python interpreter and libraries, isolated from the system-wide Python. Python
includes the `venv` tool to work with virtual environments.

## Virtual Environments

Create a virtual environment:

    $ python -m venv <dir>

Activate virtual environment:

    $ cd <dir>
    $ source bin/activate

Deactive virual environment:

    $ deactivate

## pipx

Install in clean virtual environment, add any entrypoints to ~/.local/bin:

    $ pipx install <pkg>

Install editable local package in clean virtual environment, add entrypoints:

    $ pipx install -e <path_to_pkg>

## test.pypi

Install from testpypi:

    $ pip install --index-url https://test.pypi.org/simple --extra-index-url https://pypi.org/simple <pkg>
