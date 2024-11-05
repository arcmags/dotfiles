// ==UserScript==
// @name        Hacker News
// @include     *://news.ycombinator.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/ycominator.css.js :: */
/* intended for qutebrowser with darkmode enabled */

var colorBg = '#00002a';
var colorBg1 = '#20204a';
var colorBar = '#30305a';

var hnmain = document.getElementById('hnmain');
hnmain.style.background = colorBg1;

var tds = document.getElementsByTagName('td');
for (let i = 0; i < tds.length; i++) {
    if (tds[i].bgColor == '#ff6600') {
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
    body, input, textarea {
        background: var(--color-bg) !important;
    }
    a {
        color: var(--color-heading) !important;
    }
    a:visited {
        color: var(--color-link) !important;
    }
    a:hover {
        color: var(--color-active) !important;
    }
`);
