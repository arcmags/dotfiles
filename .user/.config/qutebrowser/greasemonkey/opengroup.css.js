// ==UserScript==
// @name        Open Group Publications
// @include     https://pubs.opengroup.org/onlinepubs*
// ==/UserScript==
//
var hrs = document.getElementsByTagName('hr');
for (let i = 0; i < hrs.length; i++) {
    while(hrs[i].attributes.length > 0) {
        hrs[i].removeAttributeNode(hrs[i].attributes[0]);
    };
};

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
    }

    ul, li, table {
        color: unset !important;
        background: unset !important;
    }

    hr {
        border-top: 2px solid var(--color-bar) !important;
        color: var(--color-bar) !important;
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

    h1, h2, h3, h4, h5, h6 {
        color: var(--color-code) !important;
        background: unset !important;
    }

    .topOfPage {
        display: none !important;
    }
`);
