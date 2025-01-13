// ==UserScript==
// @name        CNN Lite
// @include     *://lite.cnn.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/cnn-lite.css.js :: */

GM_addStyle(`
    body {
        color: var(--color-fg) !important;
        background: var(--color-bg) !important;
    }

    a, footer a:visited, header a:visited {
        color: var(--color-heading) !important;
        text-decoration: none !important;
    }

    a:visited {
        color: var(--color-link) !important;
    }

    a:hover, footer a:hover, header a:hover {
        color: var(--color-active) !important;
    }

    ul {
        list-style-type: none !important;
        padding-inline-start: unset !important;
    }
`);
