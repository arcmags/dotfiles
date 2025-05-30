// ==UserScript==
// @name        xkcd
// @include     *://xkcd.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/xkcd.css.js :: */

var content = document.getElementById('middleContainer');
content.innerHTML = content.innerHTML.split('<br>')[0] + '<div>\n';

GM_addStyle(`
    body, #middleContainer {
        background: var(--user-color-bg) !important;
        color: var(--user-color-fg) !important;
    }

    #bottom,
    #topContainer {
        display: none !important;
    }

    ul.comicNav li a {
        background: var(--user-color-bar) !important;
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
        color: var(--user-color-link) !important;
    }
    a:hover {
        color: var(--user-color-active) !important;
    }
`);
