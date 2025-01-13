// ==UserScript==
// @name        die.net
// @include     *://linux.die.net*
// @include     *://die.net*
// @include     *://www.die.net*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/dienet.css.js :: */

GM_addStyle(`
    body {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
    }
    #logo, #menu {
        background: var(--color-bg1) !important;
        color: var(--color-fg) !important;
        border: none !important;
    }

    #bg {
        max-width: unset !important;
    }

    #content {
        font-family: var(--font-family) !important;
        font-size: var(--font-size) !important;
    }

    h1 {
        border: none !important;
    }

    h1, h2, h3, h4, h5, h6 {
        font-size: var(--font-size) !important;
        color: var(--color-heading) !important;
        padding: 0 !important;
        margin-top: 2ch !important;
        margin-bottom: 0 !important;
    }

    b {
        color: var(--color-heading) !important;
    }

    input {
        background: var(--color-bg) !important;
        color: var(--color-code) !important;
        border-color: 2px solid var(--color-bar) !important;
    }

    a {
        color: var(--color-link) !important ;
        text-decoration: none !important;
    }
    a:hover {
        color: var(--color-active) !important;
        text-decoration: none !important;
    }
    #logo a, #menu a {
        background: none !important;
    }

    img[alt='Back'], #adright, #cse-search-box {
        display: none !important;
    }
`);
