// ==UserScript==
// @name        Man Pages
// @include     *://man7.org/*
// @include     *://man.freebsd.org/cgi/man.cgi*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/man7.css.js :: */
/* intended for qutebrowser with darkmode enabled */

GM_addStyle(`
    :root {
        --box2-comment: url(https://mags.zone/css/box2_50507a.png) 32 16 round;
        /* named colors: */
        --color-blue: #66b0ff;
        --color-cyan: #0ef0f0;
        --color-green: #59f176;
        --color-orange: #fc8d28;
        --color-pink: #f10596;
        --color-purple: #f003ef;
        --color-red: #ff4242;
        --color-yellow: #f3e877;
        /* syntax colors: */
        --color-active: #0ef0f0;
        --color-bg: #00002a;
        --color-code: #f5f5ff;
        --color-comment: #50507a;
        --color-em: #fc4cb8;
        --color-fg: #d0d0fa;
        --color-heading: #66b0ff;
        --color-link: #32a6a6;
    }

    * {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
        font-family: Hack, Hack-Regular, monospace !important;
        font-size: 16px !important;
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

    .footer, .top-link, td.search-box, hr.start-footer, hr.end-footer, .nav-bar,
    hr.nav-end,
    #header, #headercontainer, #footer {
        display: none !important;
    }

    pre {
        margin-top: 0 !important;
    }

`)
