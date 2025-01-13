// ==UserScript==
// @name        git-scm
// @include     *://git-scm.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/git-scm.css.js :: */

GM_addStyle(`
    * {
        font-family: var(--font-family) !important;
    }

    body {
        background: var(--color-bg) !important;
    }

    #masthead, #main {
        background: var(--color-bg1) !important;
    }

    code, pre {
        background: var(--color-bg) !important;
        color: var(--color-code) !important;
    }

    h1, h2, h3, h4, h5, h6 {
        color: var(--color-heading) !important;
    }

    a {
        color: var(--color-link) !important;
        transition: none !important;
    }
    a:hover {
        color: var(--color-active) !important;
    }

`);
