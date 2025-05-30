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
        background: var(--user-color-bg) !important;
        color: var(--user-color-fg) !important;
    }

    ul, li, table {
        color: unset !important;
        background: unset !important;
    }

    hr {
        border-top: 2px solid var(--user-color-bar) !important;
        color: var(--user-color-bar) !important;
    }

    a {
        color: var(--user-color-heading) !important;
        text-decoration: none !important;
    }
    a:visited {
        color: var(--user-color-link) !important;
    }
    a:hover {
        color: var(--user-color-active) !important;
    }

    h1, h2, h3, h4, h5, h6 {
        color: var(--user-color-code) !important;
        background: unset !important;
    }

    .topOfPage {
        display: none !important;
    }
`);
