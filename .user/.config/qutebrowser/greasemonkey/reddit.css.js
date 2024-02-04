// ==UserScript==
// @name        Reddit
// @include     *://*.reddit.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/reddit.css.js :: */
/* intended for qutebrowser with darkmode enabled */

GM_addStyle(`
    .account-activity-box,
    .premium-banner,
    .premium-banner-outer,
    .promoted,
    .promotedlink,
    .redesign-beta-optin,
    .sidebox.create {
        display: none !important;
    }

    body,
    body:before,
    #header,
    #siteTable,
    .comment,
    .commentarea,
    .option,
    .side,
    .sitetable,
    .titlebox,
    .usertext-body {
        background: none !important;
        background-image: none !important;
    }

    textarea {
        background: #000000 !important;
    }
`)
