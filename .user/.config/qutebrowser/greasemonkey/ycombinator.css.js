// ==UserScript==
// @name        Hacker News
// @include     *://news.ycombinator.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/ycominator.css.js :: */

var style = getComputedStyle(document.body)
var colorBg = style.getPropertyValue('--color-bg')
var colorBg1 = style.getPropertyValue('--color-bg1')
var colorBar = style.getPropertyValue('--color-bar')

var hnmain = document.getElementById('hnmain');
hnmain.style.background = colorBg1;

var tds = document.getElementsByTagName('td');
for (let i = 0; i < tds.length; i++) {
    if (tds[i].bgColor.toLowerCase() == '#ff6600') {
        tds[i].bgColor = colorBar;
    };
};

var imgs = document.getElementsByTagName('img');
for (let i = 0; i < imgs.length; i++) {
    imgs[i].src = 'data:,';
};

GM_addStyle(`
    body, td, input, textarea, .default, .title, .pagetop, .comment {
        font-size: 14px !important;
    }
    .admin, .admin td {
        font-size: 12px !important;
    }
    .subtext, .subtext td {
        font-size: 10px !important;
    }

    body, input, textarea {
        background: var(--color-bg) !important;
    }
    body {
        color: var(--color-fg) !important;
    }
    input, textarea {
        color: var(--color-bar) !important;
        border-color: var(--color-bar) !important;
        border-style: solid !important;
    }

    input[type='submit'] {
        background: var(--color-bar) !important;
        border-color: var(--color-bg) !important;
        color: var(--color-heading) !important;
    }
    input[type='submit']:hover {
        background: var(--color-bg1) !important;
        border-color: var(--color-bar) !important;
        border-style: solid !important;
        color: var(--color-active) !important;
    }

    a, .pagetop a:visited, .yclinks a:visited,
    a[href='https://www.ycombinator.com/apply/']:visited {
        color: var(--color-heading) !important;
    }
    a:visited {
        color: var(--color-link) !important;
    }
    a:hover, .pagetop a:hover, .yclinks a:hover,
    a[href='https://www.ycombinator.com/apply/']:hover {
        color: var(--color-active) !important;
    }
`);
