// ==UserScript==
// @name        Man Pages
// @include     *://man7.org/*
// @include     *://man.freebsd.org/cgi/man.cgi*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/man7.css.js :: */

GM_addStyle(`
    * {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
        font-family: Hack, Hack-Regular, monospace !important;
        font-size: var(--font-size) !important;
    }

    h1, h2, h3, h4, h5, h6 {
        color: var(--color-heading) !important;
        padding: 0 !important;
        margin-top: 2ch !important;
        margin-bottom: 0 !important;
    }

    a {
        color: var(--color-link) !important ;
        background: var(--color-bg) !important;
        text-decoration: none !important;
    }
    a:hover {
        color: var(--color-active) !important;
        text-decoration: none !important;
    }

    b {
        color: var(--color-heading) !important;
        font-weight: normal !important;
    }

    i {
        color: var(--color-active) !important;
        font-style: normal !important;
    }

    hr, hr.nav-end {
        border: none !important;
        clear: both !important;
        border-bottom: solid !important;
        border-image: var(--box2-comment) !important;
        border-width: 2ch !important;
        color: var(--color-comment) !important;
        border-color: var(--color-comment) !important;
        margin-bottom: 0 !important;
    }

    input, button, select {
        border-color: var(--color-comment) !important;
        border-style: solid !important;
    }

    #container {
        width: 100% !important;
        margin-left: 1ch !important;
        margin-right: 1ch !important;
    }

    .footer, .top-link, td.search-box, hr.start-footer, hr.end-footer,
    .nav-bar, hr.nav-end, #header, #headercontainer, #footer {
        display: none !important;
    }

    pre {
        margin-top: 0 !important;
    }

`);
