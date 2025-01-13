// ==UserScript==
// @name        Reddit
// @include     *://*.reddit.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/reddit.css.js :: */

GM_addStyle(`
    body, body:before, textarea, #header, #siteTable, .comment, .commentarea,
    .option, .side, .sitetable, .titlebox, .usertext-body {
        background: var(--color-bg) !important;
        background-image: none !important;
        color: var(--color-fg) !important;
    }

    #sr-header-area {
        background: var(--color-bg1) !important;
    }
    #sr-header-area a {
        color: var(--color-heading) !important ;
    }
    #sr-header-area a:hover {
        color: var(--color-active) !important;
    }

    a {
        color: var(--color-heading) !important ;
        text-decoration: none !important;
    }
    a:visited {
        color: var(--color-link) !important ;
    }
    a:hover {
        color: var(--color-active) !important;
    }

    .account-activity-box, .premium-banner, .premium-banner-outer, .promoted,
    .promotedlink, .redesign-beta-optin, .sidebox.create {
        display: none !important;
    }
`);
