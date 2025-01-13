// ==UserScript==
// @name        xkcd
// @include     *://xkcd.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/xkcd.css.js :: */

var content = document.getElementById('middleContainer');
content.innerHTML = content.innerHTML.split('<br>')[0] + '<div>\n';

GM_addStyle(`
    body, #middleContainer {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
    }

    #bottom,
    #topContainer {
        display: none !important;
    }

    ul.comicNav li a {
        background: var(--color-bar) !important;
        border: none !important;
        box-shadow: none !important;
        -mox-box-shadow: none !important;
        -webkit-box-shadow: none !important;
    }

    .box {
        border: none !important;
    }

    a {
        text-decoration: none !important;
        transition: none !important;
    }
    a, a:visited {
        color: var(--color-link) !important;
    }
    a:hover {
        color: var(--color-active) !important;
    }
`);
