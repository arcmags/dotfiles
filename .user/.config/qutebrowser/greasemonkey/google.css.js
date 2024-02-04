// ==UserScript==
// @name        Google
// @include     *://*.google.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/google.css.js :: */
/* intended for qutebrowser with darkmode enabled */

GM_addStyle(`
    #tadsb,
    #taw,
    .cu-container {
        display: none !important;
    }
`)
