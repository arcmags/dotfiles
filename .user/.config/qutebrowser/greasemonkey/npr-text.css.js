// ==UserScript==
// @name        NPR Text-Only
// @include     *://text.npr.org*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/npr-text.css.js :: */

GM_addStyle(`
    body {
        background: var(--user-color-bg) !important;
        color: var(--user-color-fg) !important;
        max-width: 750px !important;
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

    .hr-line {
        display: none !important;
    }
`);
