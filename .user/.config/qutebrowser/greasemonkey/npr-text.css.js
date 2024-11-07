// ==UserScript==
// @name        NPR Text-Only
// @include     *://text.npr.org*
// ==/UserScript==

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
