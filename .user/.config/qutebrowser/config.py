## ~/.config/qutebrowser/config.py ::
# required:
# - apps: mpv, ranger, vim, xterm, yt-dlp, zathura
# - fonts: Hack
# - userscripts: transmisison.sh, vim.sh, yt-dlp-mpv.sh, zathura.sh
# - xresources: *.color_0 - *.color_15

import subprocess

dir_dl = '/tmp/in'
cmd_xterm = ['xterm', '-T', 'xterm_float', '-e']

def bind_hint(key, command):
    config.bind(',' + key, command)
    config.bind(key, command, mode='hint')

def hex_to_rgba(hex, alpha):
    hex = hex.strip('#')
    return 'rgba(' + str(int('0x' + hex[0:2], 0)) + ',' + str(int('0x' + \
        hex[2:4], 0)) + ',' + str(int('0x' + hex[4:6], 0)) + ',' + str(alpha) + ')'

def read_xresources(prefix):
    xresources = {}
    output = subprocess.run(['xrdb', '-query'], stdout=subprocess.PIPE)
    lines = output.stdout.decode().split('\n')
    for line in filter(lambda l : l.startswith(prefix), lines):
        prop, _, value = line.partition(':\t')
        xresources[prop] = value
    return xresources

xresources = read_xresources('*')
subprocess.run(['mkdir', '-p', dir_dl])

config.load_autoconfig(False)

## fonts ::
# I like Hack, but for some reason bold doesn't work in qutebrowser. May have to use something else.
c.fonts.default_family = [ 'Hack', 'monospace' ]
c.fonts.default_size = '14px'
c.fonts.completion.category = 'bold default_size default_family'
c.fonts.completion.entry = 'default_size default_family'
c.fonts.contextmenu = 'default_size default_family'
c.fonts.debug_console = 'default_size default_family'
c.fonts.downloads = 'default_size default_family'
c.fonts.hints = 'bold 12px default_family'
c.fonts.keyhint = 'default_size default_family'
c.fonts.messages.error = 'default_size default_family'
c.fonts.messages.info = 'default_size default_family'
c.fonts.messages.warning = 'default_size default_family'
c.fonts.prompts = 'default_size default_family'
c.fonts.statusbar = 'bold default_size default_family'
c.fonts.tabs.selected = 'bold default_size default_family'
c.fonts.tabs.unselected = 'normal default_size default_family'
c.fonts.tooltip = 'default_size default_family'
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 14
c.fonts.web.size.minimum = 4
c.fonts.web.size.minimum_logical = 6

## colors ::
color_bg = xresources['*.color0']
color_warn = xresources['*.color3']
color_bar = xresources['*.color4']
color_menu = xresources['*.color5']
color_special = xresources['*.color6']
color_fg = xresources['*.color7']
color_comment = xresources['*.color8']
color_error = xresources['*.color9']
color_good = xresources['*.color10']
color_heading = xresources['*.color12']
color_link = xresources['*.color14']
color_match = xresources['*.color13']

# completion menu:
c.colors.completion.category.bg = color_menu
c.colors.completion.category.border.bottom = color_menu
c.colors.completion.category.border.top = color_menu
c.colors.completion.category.fg = color_heading
c.colors.completion.even.bg = color_menu
c.colors.completion.fg = [color_fg, color_comment, color_special]
c.colors.completion.item.selected.bg = color_bar
c.colors.completion.item.selected.border.bottom = color_bar
c.colors.completion.item.selected.border.top = color_bar
c.colors.completion.item.selected.fg = color_good
c.colors.completion.item.selected.match.fg = color_match
c.colors.completion.match.fg = color_match
c.colors.completion.odd.bg = color_menu
c.colors.completion.scrollbar.bg = color_bar
c.colors.completion.scrollbar.fg = color_comment

# context menu:
c.colors.contextmenu.disabled.bg = color_menu
c.colors.contextmenu.disabled.fg = color_comment
c.colors.contextmenu.menu.bg = color_menu
c.colors.contextmenu.menu.fg = color_fg
c.colors.contextmenu.selected.bg = color_bar
c.colors.contextmenu.selected.fg = color_fg

# downloads bar:
c.colors.downloads.bar.bg = color_bar
c.colors.downloads.error.bg = color_bar
c.colors.downloads.error.fg = color_warn
c.colors.downloads.start.bg = color_bar
c.colors.downloads.start.fg = color_heading
c.colors.downloads.stop.bg = color_bar
c.colors.downloads.stop.fg = color_good
c.colors.downloads.system.bg = 'none'
c.colors.downloads.system.fg = 'none'

# tooltips:
c.colors.tooltip.bg = color_bar
c.colors.tooltip.fg = color_fg

# hints:
c.colors.hints.bg = color_link
#c.colors.hints.bg = hex_to_rgba(color_link, 0.8)
c.colors.hints.fg = color_bg
c.colors.hints.match.fg = color_comment
c.hints.border = '2px solid ' + color_bg

# hints: mapping:
c.colors.keyhint.bg = color_menu
c.colors.keyhint.fg = color_fg
c.colors.keyhint.suffix.fg = color_link

# messages:
c.colors.messages.error.bg = color_bg
c.colors.messages.error.border = color_bg
c.colors.messages.error.fg = color_error
c.colors.messages.info.bg = color_bg
c.colors.messages.info.border = color_bg
c.colors.messages.info.fg = color_good
c.colors.messages.warning.bg = color_bg
c.colors.messages.warning.border = color_bg
c.colors.messages.warning.fg = color_warn

# prompts:
c.colors.prompts.bg = color_menu
c.colors.prompts.border = '2px solid ' + color_comment
c.colors.prompts.fg = color_fg
c.colors.prompts.selected.bg = color_bar
c.colors.prompts.selected.fg = color_fg

# statusbar:
c.colors.statusbar.caret.bg = color_bar
c.colors.statusbar.caret.fg = color_good
c.colors.statusbar.caret.selection.bg = color_bar
c.colors.statusbar.caret.selection.fg = color_good
c.colors.statusbar.command.bg = color_bg
c.colors.statusbar.command.fg = color_fg
c.colors.statusbar.command.private.bg = color_bg
c.colors.statusbar.command.private.fg = color_fg
c.colors.statusbar.insert.bg = color_bar
c.colors.statusbar.insert.fg = color_good
c.colors.statusbar.normal.bg = color_bar
c.colors.statusbar.normal.fg = color_heading
c.colors.statusbar.passthrough.bg = color_bar
c.colors.statusbar.passthrough.fg = color_good
c.colors.statusbar.private.bg = color_bar
c.colors.statusbar.private.fg = color_match
c.colors.statusbar.progress.bg = color_comment
c.colors.statusbar.url.error.fg = color_warn
c.colors.statusbar.url.fg = color_good
c.colors.statusbar.url.hover.fg = color_special
c.colors.statusbar.url.success.http.fg = color_good
c.colors.statusbar.url.success.https.fg = color_good
c.colors.statusbar.url.warn.fg = color_warn

# tabs:
c.colors.tabs.bar.bg = color_bar
c.colors.tabs.even.bg = color_bar
c.colors.tabs.even.fg = color_fg
c.colors.tabs.indicator.error = color_comment
c.colors.tabs.indicator.start = color_comment
c.colors.tabs.indicator.stop = color_comment
c.colors.tabs.indicator.system = 'none'
c.colors.tabs.odd.bg = color_bar
c.colors.tabs.odd.fg = color_fg
c.colors.tabs.pinned.even.bg = color_bar
c.colors.tabs.pinned.even.fg = color_fg
c.colors.tabs.pinned.odd.bg = color_bar
c.colors.tabs.pinned.odd.fg = color_fg
c.colors.tabs.pinned.selected.even.bg = color_bar
c.colors.tabs.pinned.selected.even.fg = color_good
c.colors.tabs.pinned.selected.odd.bg = color_bar
c.colors.tabs.pinned.selected.odd.fg = color_good
c.colors.tabs.selected.even.bg = color_bar
c.colors.tabs.selected.even.fg = color_good
c.colors.tabs.selected.odd.bg = color_bar
c.colors.tabs.selected.odd.fg = color_good

# darkmode:
c.colors.webpage.bg = color_bg
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = 'smart-simple'
c.colors.webpage.darkmode.threshold.background = 160
c.colors.webpage.darkmode.threshold.foreground = 128
c.colors.webpage.preferred_color_scheme = 'dark'

## content  ::
c.content.default_encoding = 'utf-8'
c.content.headers.accept_language = 'en-US,en;q=0.9'

# adblock:
c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.blocking.hosts.block_subdomains = True
c.content.blocking.whitelist = []

# privacy/security:
c.content.desktop_capture = False
c.content.geolocation = False
c.content.headers.do_not_track = True
c.content.headers.referer = 'same-domain'
c.content.media.audio_capture = False
c.content.media.audio_video_capture = False
c.content.media.video_capture = False
c.content.register_protocol_handler = 'ask'
c.content.tls.certificate_errors = 'ask'
c.content.unknown_url_scheme_policy = 'allow-from-user-interaction'
c.content.mouse_lock = False
c.content.local_storage = True
c.content.persistent_storage = False
c.content.plugins = False
c.content.xss_auditing = True

# cookies:
c.content.cookies.accept = 'all'
c.content.cookies.store = True

# javascript:
c.content.javascript.enabled = True
c.content.javascript.alert = True
c.content.javascript.clipboard = 'access'
c.content.javascript.can_close_tabs = False
c.content.javascript.can_open_tabs_automatically = False
c.content.javascript.modal_dialog = False
c.content.javascript.prompt = True
c.content.local_content_can_access_file_urls = True
c.content.local_content_can_access_remote_urls = True
c.content.local_storage = True

# media:
c.content.autoplay = False
c.content.mute = False
c.content.images = True

# notifications:
c.content.notifications.enabled = False
c.content.notifications.presenter = 'messages'
c.content.notifications.show_origin = True

# style:
c.content.frame_flattening = True
c.content.fullscreen.overlay_timeout = 0
c.content.prefers_reduced_motion = True
c.content.user_stylesheets = ['css/user.css']

# pdfjs:
c.content.pdfjs = True

## completion ::
c.completion.favorite_paths = ['/home/mags/user/']
c.completion.height = '40%'
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 16
c.completion.show = 'always'
c.completion.web_history.exclude = ['https://*.google.com', 'https://duckduckgo.com']

## downloads ::
c.downloads.location.directory = dir_dl
c.downloads.location.prompt = False
c.downloads.location.remember = True
c.downloads.location.suggestion = 'path'
c.downloads.position = 'bottom'
c.downloads.remove_finished = 4000
#c.downloads.open_dispatcher = None
c.downloads.prevent_mixed_content = True

## editor ::
c.editor.command = cmd_xterm + ['vim', '{file}']
c.editor.encoding = 'utf-8'
c.editor.remove_file = True

c.fileselect.handler = 'external'
c.fileselect.folder.command = cmd_xterm + ['ranger', '--choosedir={}']
c.fileselect.multiple_files.command = cmd_xterm + ['ranger', '--choosefiles={}']
c.fileselect.single_file.command = cmd_xterm + ['ranger', '--choosefile={}']

## hints ::
c.hints.chars = 'asdfghjkl'
#c.hints.padding = {'top': 0, 'bottom': 0, 'left': 3, 'right': 3}
#c.hints.find_implementation = 'python'
c.hints.find_implementation = 'javascript'
c.hints.auto_follow = 'unique-match'
c.hints.leave_on_load = False
c.hints.radius = 0
c.hints.uppercase = False

## input ::
c.input.media_keys = False

## keyhint ::
#c.keyhint.blacklist = []
c.keyhint.delay = 200
c.keyhint.radius = 0

## logging ::
c.logging.level.console = 'critical'
c.logging.level.ram = 'debug'

## messages ::
c.messages.timeout = 3000

## new instance ::
#c.new_instance_open_target = 'tab'
#c.new_instance_open_target_window = 'last-focused'

## prompt ::
#c.prompt.filebrowser = True
c.prompt.radius = 0

## qt webengine ::
#c.qt.args = []
#c.qt.chromium.low_end_device_mode = 'auto'
#c.qt.chromium.process_model = 'process-per-site-instance'
#c.qt.chromium.sandboxing = 'enable-all'
#c.qt.environ = {}
#c.qt.force_platform = None
#c.qt.force_platformtheme = None
#c.qt.force_software_rendering = 'none'
#c.qt.highdpi = False
#c.qt.workarounds.locale = False
#c.qt.workarounds.remove_service_workers = False

## scrolling ::
c.scrolling.bar = 'always'
#c.scrolling.smooth = False

## search ::
#c.search.ignore_case = 'smart'
#c.search.incremental = True
#c.search.wrap = True

## session ::
#c.session.default_name = None
#c.session.lazy_restore = False

## spellcheck ::
c.spellcheck.languages = ['en-US']

## statusbar ::
c.statusbar.padding = {'top': 1, 'bottom': 1, 'left': 0, 'right': 10}
c.statusbar.position = 'bottom'
c.statusbar.show = 'always'
c.statusbar.widgets = ['keypress', 'search_match', 'url', 'scroll', 'tabs']

## tabs ::
c.tabs.background = True
c.tabs.close_mouse_button = 'middle'
c.tabs.close_mouse_button_on_bar = 'new-tab'
c.tabs.favicons.show = 'never'
c.tabs.indicator.padding = {'top': 0, 'bottom': 0, 'left': 0, 'right': 10}
c.tabs.indicator.width = 2
c.tabs.last_close = 'close'
c.tabs.max_width = 320
c.tabs.padding = {'top': 1, 'bottom': 2, 'left': 0, 'right': 8}
c.tabs.position = 'top'
c.tabs.select_on_remove = 'prev'
c.tabs.show = 'always'
c.tabs.tabs_are_windows = False
c.tabs.title.alignment = 'left'
c.tabs.title.format = '{current_title}'
c.tabs.title.format_pinned = '{current_title}'
c.tabs.tooltips = False
c.tabs.undo_stack_size = 24

## url ::
c.url.auto_search = 'naive'
c.url.default_page = 'file:///home/mags/user/sync/www/links/index.html'
c.url.open_base_url = True
c.url.searchengines = {
    'DEFAULT': 'https://google.com/search?q={}',
    '7x': 'https://1337x.to/search/{}/1/',
    'am': 'https://www.allmusic.com/search/all/{}',
    'ap': 'https://archlinux.org/packages/?q={}',
    'aur': 'https://aur.archlinux.org/packages?K={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
    'bsd': 'https://man.freebsd.org/cgi/man.cgi?query={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'g': 'https://google.com/search?q={}',
    'gh': 'https://github.com/search?q={}',
    'imdb': 'https://www.imdb.com/find?q={}',
    'irc': 'https://netsplit.de/channels/?chat={}',
    'man': 'https://www.google.com/search?q={}&sitesearch=man7.org%2Flinux%2Fman-pages',
    'mc': 'https://minecraft.fandom.com/wiki/Special:Search?query={}',
    'pip': 'https://pypi.org/search/?q={}',
    'pb': 'https://thepiratebay.org/search.php?q={}',
    'subdl': 'https://subdl.com/search?query={}',
    'w': 'https://en.wikipedia.org/w/index.php?search={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'yts': 'https://yts.mx/browse-movies/{}',
}
c.url.start_pages = 'file:///home/mags/user/sync/www/links/index.html'

## window ::
c.window.hide_decoration = True
c.window.title_format = 'qtb: {current_title}'
c.window.transparent = False

## zoom ::
c.zoom.default = '100%'
#c.zoom.levels = ['25%', '33%', '50%', '67%', '75%', '90%', '100%', '110%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '500%']
#c.zoom.mouse_divider = 512
#c.zoom.text_only = False

## domain settings ::
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.register_protocol_handler', True, 'https://mail.google.com?extsrc=mailto&url=%25s')

## bindings ::
#c.bindings.key_mappings = {
    #'<Ctrl-[>': '<Escape>',
    #'<Ctrl-6>': '<Ctrl-^>',
    #'<Shift-Return>': '<Return>',
    #'<Enter>': '<Return>',
    #'<Shift-Enter>': '<Return>',
    #'<Ctrl-Enter>': '<Ctrl-Return>'
#}

# TODO: fix this to open largest image if setsrc is used
config.bind(';I', ':hint images run open -t -- {hint-url}')
config.unbind(';I')
config.unbind(';Y')
config.unbind(';b')
config.unbind(';d')
config.unbind(';f')
config.unbind(';h')
config.unbind(';i')
config.unbind(';r')
config.unbind('r')
config.unbind('<Ctrl-Shift-w>')
config.unbind('<Ctrl-v>')
config.unbind('<Ctrl-w>')
config.unbind('D')
config.unbind('d')
# TODO: maybe redo all semicolon bindings?
config.bind(';;', 'hint links')
config.bind(';<Ctrl-l>', 'config-source ;; reload -f')
config.bind(';B', 'hint links tab-bg')
config.bind(';F', 'hint all')
config.bind(';P', 'hint links run open -p {hint-url}')
config.bind(';R', 'hint --rapid links tab-bg')
config.bind(';T', 'hint links tab-fg')
config.bind(';W', 'hint links window')
config.bind(';f', 'hint links run open -- http://12ft.io/{hint-url}')
config.bind(';m', 'hint all hover')
config.bind(';x', 'hint all delete')
config.bind('<Alt-h>', 'fake-key <Left>')
config.bind('<Alt-j>', 'fake-key <Down>')
config.bind('<Alt-k>', 'fake-key <Up>')
config.bind('<Alt-l>', 'fake-key <Right>')
config.bind('<Ctrl-Escape>', 'mode-enter passthrough')
config.bind('<Ctrl-Shift-c>', 'fake-key <Ctrl-c>')
config.bind('<Ctrl-Shift-q>', 'quit')
config.bind('<Ctrl-e>', 'open -w')
config.bind('<Ctrl-j>', 'cmd-run-with-count 8 scroll down')
config.bind('<Ctrl-k>', 'cmd-run-with-count 8 scroll up')
config.bind('<Ctrl-l>', 'reload -f')
config.bind('<Ctrl-n>', 'tab-next')
config.bind('<Ctrl-o>', 'cmd-set-text -s :open -w')
config.bind('<Ctrl-p>', 'tab-prev')
config.bind('<Ctrl-q>', 'tab-close')
config.bind('<Shift-Escape>', 'fake-key <Escape>')
config.bind('EM', 'hint links spawn --userscript yt-dlp-mpv.sh download {hint-url}')
config.bind('Em', 'hint links userscript yt-dlp-mpv.sh')
config.bind('Et', 'hint links userscript transmission.sh')
config.bind('Ev', 'hint links userscript vim.sh')
config.bind('Ey', 'hint links spawn -u yt-dlp-mpv.sh download-only {hint-url}')
config.bind('Ez', 'hint links userscript zathura.sh')
config.bind('H', 'back --quiet')
config.bind('I', 'hint images run open -t -- {hint-url}')
config.bind('L', 'forward --quiet')
config.bind('R', 'hint --rapid links tab-bg')
config.bind('SB', 'bookmark-list -t')
config.bind('SH', 'history -t')
config.bind('SM', 'messages -t')
config.bind('SP', 'open -t ;; process')
config.bind('SQ', 'open -t qute://help/')
config.bind('Sb', 'bookmark-list')
config.bind('Sm', 'messages')
config.bind('Sp', 'process')
config.bind('Sq', 'open qute://help/')
config.bind('T', 'hint links tab-fg')
config.bind('W', 'hint links window')
config.bind('Yg', 'hint userscript xclip-git.bash')
config.bind('Yf', 'hint links yank')
config.bind('cm', 'clear-messages')
config.bind('dd', 'download')
config.bind('df', 'hint links download')
config.bind('di', 'hint images download')
config.bind('eM', 'spawn -u yt-dlp-mpv.sh download {url}')
config.bind('em', 'spawn -u yt-dlp-mpv.sh')
config.bind('ev', 'spawn -u vim.sh')
config.bind('ey', 'spawn -u yt-dlp-mpv.sh download-only {url}')
config.bind('ez', 'spawn -u zathura.sh')
config.bind('g<Ctrl-e>', 'open -w {url}')
config.bind('g<Ctrl-t>', 'open -t {url}')
config.bind('gT', 'tab-prev')
config.bind('gt', 'tab-next')
config.bind('rf', 'open -- http://12ft.io/{url}')
config.bind('sh', 'config-cycle -p -t fonts.hints 12px 14px 16px 20px 24px')
config.bind('tb', 'config-cycle -p -t statusbar.show always in-mode')
config.bind('tg', 'config-cycle -p -t content.javascript.enabled ;; reload')
config.bind('tt', 'config-cycle -p -t tabs.show always multiple never')
config.bind('yg', 'spawn -u xclip-git.bash')

# caret:
config.bind('<Alt-h>', 'fake-key --global <Left>', mode='caret')
config.bind('<Alt-j>', 'fake-key --global <Down>', mode='caret')
config.bind('<Alt-k>', 'fake-key --global <Up>', mode='caret')
config.bind('<Alt-l>', 'fake-key --global <Right>', mode='caret')
config.bind('<Ctrl-c>', 'mode-leave', mode='caret')
config.bind('<Ctrl-d>', 'cmd-run-with-count 8 move-to-next-line', mode='caret')
config.bind('<Ctrl-e>', 'scroll down', mode='caret')
config.bind('<Ctrl-u>', 'cmd-run-with-count 8 move-to-prev-line', mode='caret')
config.bind('<Ctrl-y>', 'scroll up', mode='caret')

# command:
config.bind('<Alt-h>', 'fake-key --global <Left>', mode='command')
config.bind('<Alt-j>', 'fake-key --global <Down>', mode='command')
config.bind('<Alt-k>', 'fake-key --global <Up>', mode='command')
config.bind('<Alt-l>', 'fake-key --global <Right>', mode='command')
config.bind('<Alt-r>', 'rl-backward-kill-word', mode='command')
config.bind('<Alt-u>', 'rl-kill-line', mode='command')
config.bind('<Alt-w>', 'rl-forward-word', mode='command')
config.bind('<Alt-x>', 'rl-kill-word', mode='command')
config.bind('<Ctrl-c>', 'mode-leave', mode='command')
config.bind('<Ctrl-d>', 'rl-delete-char', mode='command')
config.bind('<Ctrl-j>', 'command-history-next', mode='command')
config.bind('<Ctrl-k>', 'command-history-prev', mode='command')
config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')
config.bind('<Ctrl-x>', 'completion-item-del', mode='command')

# hint:
config.bind('<Ctrl-c>', 'mode-leave', mode='hint')
config.bind(';', 'hint links', mode='hint')
config.bind('B', 'hint links tab-bg', mode='hint')
config.bind('F', 'hint all', mode='hint')
config.bind('I', 'hint images run open -t -- {hint-url}', mode='hint')
config.bind('O', 'hint links fill :open -r -t {hint-url}', mode='hint')
config.bind('P', 'hint links run open -p {hint-url}', mode='hint')
config.bind('R', 'hint --rapid links tab-bg', mode='hint')
config.bind('T', 'hint links tab-fg', mode='hint')
config.bind('W', 'hint links window', mode='hint')
config.bind('m', 'hint all hover', mode='hint')
config.bind('o', 'hint links fill :open {hint-url}', mode='hint')
config.bind('t', 'hint inputs', mode='hint')
config.bind('x', 'hint all delete', mode='hint')
config.bind('y', 'hint links yank', mode='hint')

# insert:
config.bind('<Alt-b>', 'fake-key <Ctrl-Left>', mode='insert')
config.bind('<Alt-d>', 'fake-key <Ctrl-Delete>', mode='insert')
config.bind('<Alt-f>', 'fake-key <Ctrl-Right>', mode='insert')
config.bind('<Alt-h>', 'fake-key --global <Left>', mode='insert')
config.bind('<Alt-j>', 'fake-key --global <Down>', mode='insert')
config.bind('<Alt-k>', 'fake-key --global <Up>', mode='insert')
config.bind('<Alt-l>', 'fake-key --global <Right>', mode='insert')
config.bind('<Alt-r>', 'fake-key <Ctrl-Backspace>', mode='insert')
config.bind('<Alt-v>', 'edit-text', mode='insert')
config.bind('<Alt-w>', 'fake-key <Ctrl-Right>', mode='insert')
config.bind('<Alt-x>', 'fake-key <Ctrl-Delete>', mode='insert')
config.bind('<Ctrl-Shift-c>', 'fake-key --global <Ctrl-c>', mode='insert')
config.bind('<Ctrl-Shift-v>', 'fake-key --global <Ctrl-v>', mode='insert')
config.bind('<Ctrl-a>', 'fake-key <Home>', mode='insert')
config.bind('<Ctrl-b>', 'fake-key <Left>', mode='insert')
config.bind('<Ctrl-d>', 'fake-key <Delete>', mode='insert')
config.bind('<Ctrl-e>', 'fake-key <End>', mode='insert')
config.bind('<Ctrl-f>', 'fake-key <Right>', mode='insert')
config.bind('<Ctrl-h>', 'fake-key <Backspace>', mode='insert')
config.bind('<Ctrl-j>', 'fake-key <Down>', mode='insert')
config.bind('<Ctrl-k>', 'fake-key <Up>', mode='insert')
config.bind('<Ctrl-n>', 'fake-key <Down>', mode='insert')
config.bind('<Ctrl-p>', 'fake-key <Up>', mode='insert')
#config.bind('<Ctrl-w>', 'fake-key <Ctrl-Backspace>', mode='insert')
#config.bind('<Ctrl-w>', 'fake-key <Alt-Backspace>', mode='insert')

# passthrough:
config.bind('<Ctrl-Escape>', 'mode-leave', mode='passthrough')

# prompt:
config.bind('<Alt-h>', 'fake-key --global <Left>', mode='prompt')
config.bind('<Alt-j>', 'fake-key --global <Down>', mode='prompt')
config.bind('<Alt-k>', 'fake-key --global <Up>', mode='prompt')
config.bind('<Alt-l>', 'fake-key --global <Right>', mode='prompt')
config.bind('<Alt-r>', 'rl-backward-kill-word', mode='prompt')
config.bind('<Alt-u>', 'rl-kill-line', mode='prompt')
config.bind('<Alt-w>', 'rl-forward-word', mode='prompt')
config.bind('<Ctrl-c>', 'mode-leave', mode='prompt')
config.bind('<Ctrl-d>', 'rl-delete-char', mode='prompt')
config.bind('<Ctrl-j>', 'prompt-item-focus next', mode='prompt')
config.bind('<Ctrl-k>', 'prompt-item-focus prev', mode='prompt')
config.bind('<Ctrl-n>', 'prompt-item-focus next', mode='prompt')
config.bind('<Ctrl-p>', 'prompt-item-focus prev', mode='prompt')

# yesno:
config.bind('<Return>', 'prompt-accept yes', mode='yesno')
