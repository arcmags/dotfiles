// ==UserScript==
// @name        Stack Exchange
// @include     *://stackexchange.com*
// @include     *://*.stackexchange.com*
// @include     *://stackoverflow.com*
// @include     *://mathoverflow.net*
// @include     *://superuser.com*
// @include     *://askubuntu.com*
// @include     *://serverfault.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/stackexchange.css.js :: */

GM_addStyle(`
    html,  body, .s-sidebarwidget {
        background: var(--color-bg) !important;
    }
    #content, header {
        background: var(--color-bg1) !important;
        border: 2px solid var(--color-bar) !important;
    }
    .s-sidebarwidget--header {
        background: var(--color-bg1) !important;
    }
    .s-btn {
        background: none !important;
    }

    a {
        color: var(--color-heading) !important;
        text-decoration: none !important;
        transition: none !important;
    }
    a:visited {
        color: var(--color-link) !important;
    }
    a:hover {
        color: var(--color-active) !important;
    }

    .js-overflowai-cta {
        display: none !important;
    }
`);
