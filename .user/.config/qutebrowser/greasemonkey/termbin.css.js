// ==UserScript==
// @name        termbin
// @include     *://termbin.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/termbin.css.js :: */

GM_addStyle(`
    body {
        background: var(--user-color-bg) !important;
        color: var(--user-color-fg) !important;
    }

    pre {
        font-size: var(--user-font-size) !important;
    }

    u {
        text-decoration: none !important
    }

    a {
        color: var(--user-color-heading) !important;
        text-decoration: none !important;
    }
    a:visited {
        color: var(--user-color-link) !important;
    }
    a:hover {
        color: var(--user-color-active) !important;
    }
`);
