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
        background: var(--user-color-bg) !important;
    }
    #content, header {
        background: var(--user-color-bg1) !important;
        border: 2px solid var(--user-color-bar) !important;
    }
    .s-sidebarwidget--user-header {
        background: var(--user-color-bg1) !important;
    }
    .s-btn {
        background: none !important;
    }

    a {
        color: var(--user-color-heading) !important;
        text-decoration: none !important;
        transition: none !important;
    }
    a:visited {
        color: var(--user-color-link) !important;
    }
    a:hover {
        color: var(--user-color-active) !important;
    }

    .js-overflowai-cta {
        display: none !important;
    }
`);
