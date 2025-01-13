// ==UserScript==
// @name        NPR Text-Only
// @include     *://text.npr.org*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/npr-text.css.js :: */

GM_addStyle(`
    body {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
        max-width: 750px !important;
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

    .hr-line {
        display: none !important;
    }
`);
