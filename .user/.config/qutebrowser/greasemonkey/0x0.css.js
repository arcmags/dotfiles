// ==UserScript==
// @name        0x0.st
// @include     *://0x0.st*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/0x0.css.js :: */

GM_addStyle(`
    body {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
        font-size: var(--font-size) !important;
    }

    u {
        text-decoration: none !important
    }

    a {
        color: var(--color-heading) !important;
        text-decoration: none !important;
    }
    a:visited {
        color: var(--color-link) !important;
    }
    a:hover {
        color: var(--color-active) !important;
    }
`);
