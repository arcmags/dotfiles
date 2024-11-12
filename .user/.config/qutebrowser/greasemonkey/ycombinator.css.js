// ==UserScript==
// @name        Hacker News
// @include     *://news.ycombinator.com*
// ==/UserScript==
/* ~/.config/qutebrowser/greasemonkey/ycominator.css.js :: */

var colorBg = '#00002a';
var colorBg1 = '#20204a';
var colorBar = '#30305a';

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
    :root {
        --color-active: #0ef0f0;
        --color-bar: #30305a;
        --color-bg: #00002a;
        --color-bg1: #20204a;
        --color-code: #f5f5ff;
        --color-comment: #50507a;
        --color-em: #fc4cb8;
        --color-fg: #d0d0fa;
        --color-heading: #66b0ff;
        --color-link: #32a6a6;
    }

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
