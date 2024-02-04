// ==UserScript==
// @name        xkcd
// @include     *://xkcd.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/xkcd.css.js :: */

GM_addStyle(`
    body,
    #middleContainer {
        background: none !important;
    }

    #bottom,
    #topContainer {
        display: none !important;
    }
`)
