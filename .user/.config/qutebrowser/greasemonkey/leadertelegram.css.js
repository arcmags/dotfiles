// ==UserScript==
// @name        Leader Telegram
// @include     *://*.leadertelegram.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/leadertelegram.css.js :: */

GM_addStyle(`
    #app, #asset-below, #main-bottom-container, #main-top-container,
    #site-footer-container, #site-header, #site-header-container,
    #sticky-anchor, #tncms-region-article_bottom, #tncms-region-front-full-top,
    .ad-col, .dfp-ad, .fixed-col-right, .grecaptcha-badge, .header-promo,
    .hidden-print, .main-sidebar, .modal-body, .navbar-header, .nav-home,
    .not-logged-in, .paging-link, .row-senary, .site-logo-container,
    .subscription-required, .tnt-ads, .tnt-photo-purchase, .tnt-stack {
        display: none !important;
    }
`);
