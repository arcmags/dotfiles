---
title: Python Virtual Environments
author: Chris Magyar
description: Python virtual environments and pipx quick reference tips.
keywords: python, venv, pipx
---

A Python virtual environment ([venv](https://docs.python.org/3/library/venv.html)) is a self contained Python interpreter and
libraries, isolated from the system-wide Python. Python includes the `venv` tool
to work with virtual environments.

# Virtual Environments

Create a virtual environment:

    $ python -m venv <DIR>

Activate virtual environment:

    $ cd <DIR>
    $ source bin/activate

Deactive virual environment:

    $ deactivate

# pipx

Install in clean virtual environment, add any entrypoints to ~/.local/bin:

    $ pipx install <PACKAGE>

Install editable local package in clean virtual environment, add entrypoints:

    $ pipx install -e <PATH_TO_PACKAGE>

# test.pypi

Install from testpypi:

    $ pip install --index-url https://test.pypi.org/simple --extra-index-url https://pypi.org/simple <PACKAGE>


``` python
code = 99
```
