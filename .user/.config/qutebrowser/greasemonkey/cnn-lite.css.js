// ==UserScript==
// @name        CNN Lite
// @include     *://lite.cnn.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/cnn-lite.css.js :: */

GM_addStyle(`
    body {
        color: var(--user-color-fg) !important;
        background: var(--user-color-bg) !important;
    }

    a, footer a:visited, header a:visited {
        color: var(--user-color-heading) !important;
        text-decoration: none !important;
    }

    a:visited {
        color: var(--user-color-link) !important;
    }

    a:hover, footer a:hover, header a:hover {
        color: var(--user-color-active) !important;
    }

    ul {
        list-style-type: none !important;
        padding-inline-start: unset !important;
    }
`);
