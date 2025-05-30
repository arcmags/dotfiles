// ==UserScript==
// @name        git-scm
// @include     *://git-scm.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/git-scm.css.js :: */

GM_addStyle(`
    * {
        font-family: var(--user-font-family) !important;
    }

    body {
        background: var(--user-color-bg) !important;
    }

    #masthead, #main {
        background: var(--user-color-bg1) !important;
    }

    code, pre {
        background: var(--user-color-bg) !important;
        color: var(--user-color-code) !important;
    }

    h1, h2, h3, h4, h5, h6 {
        color: var(--user-color-heading) !important;
    }

    a {
        color: var(--user-color-link) !important;
        transition: none !important;
    }
    a:hover {
        color: var(--user-color-active) !important;
    }

`);
