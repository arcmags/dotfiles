// ==UserScript==
// @name        0x0.st
// @include     *://0x0.st*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/0x0.css.js :: */

GM_addStyle(`
    body {
        background: var(--user-color-bg) !important;
        color: var(--user-color-fg) !important;
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
