#!/usr/bin/env python
## ~/.ipython/profile_default/ipython_config.py ::

c = get_config()
c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.colors = 'Linux'
c.InteractiveShellApp.extensions = []
c.InteractiveShellApp.exec_lines = []
c.InteractiveShellApp.exec_files = []
c.TerminalInteractiveShell.extra_open_editor_shortcuts = True
c.TerminalInteractiveShell.history_length = 500
c.TerminalInteractiveShell.history_load_length = 500
c.TerminalInteractiveShell.editing_mode='vi'
