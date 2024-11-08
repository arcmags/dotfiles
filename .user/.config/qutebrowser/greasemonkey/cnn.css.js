// ==UserScript==
// @name        CNN Lite
// @include     *://lite.cnn.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/cnn.css.js :: */
/* intended for qutebrowser with darkmode enabled */

GM_addStyle(`
    :root {
        --color-active: #0ef0f0;
        --color-bar: #30305a;
        --color-bg: #00002a;
        --color-bg1: #20204a;
        --color-code: #f5f5ff;
        --color-comment: #50507a;
        --color-em: #fc4cb8;
        --color-fg: #d0d0fa;
        --color-heading: #66b0ff;
        --color-link: #32a6a6;
    }

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
