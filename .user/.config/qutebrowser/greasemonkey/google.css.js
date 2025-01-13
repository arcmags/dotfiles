// ==UserScript==
// @name        Google
// @include     *://*.google.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/google.css.js :: */

GM_addStyle(`
    #tadsb, #taw, .cu-container {
        display: none !important;
    }
`);
