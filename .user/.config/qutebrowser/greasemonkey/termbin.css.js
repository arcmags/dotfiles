// ==UserScript==
// @name        termbin
// @include     *://termbin.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/termbin.css.js :: */

GM_addStyle(`
    body {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
    }

    pre {
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
