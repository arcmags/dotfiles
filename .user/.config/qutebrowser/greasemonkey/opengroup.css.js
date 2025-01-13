// ==UserScript==
// @name        Open Group Publications
// @include     https://pubs.opengroup.org/onlinepubs*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/opengroup.css.js :: */

var hrs = document.getElementsByTagName('hr');
for (let i = 0; i < hrs.length; i++) {
    while(hrs[i].attributes.length > 0) {
        hrs[i].removeAttributeNode(hrs[i].attributes[0]);
    };
};

GM_addStyle(`
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
