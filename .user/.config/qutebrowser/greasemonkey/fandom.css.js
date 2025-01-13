// ==UserScript==
// @name        Fandom
// @include     *://*.fandom.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/fandom.css.js :: */

GM_addStyle(`
    div[itemprop=video],
    #WikiaBar,
    #mixed-content-footer,
    .bottom-ads-container,
    .fandom-sticky-header.is-visible,
    .page__right-rail,
    .top-ads-container {
        display: none !important;
    }

    .main-container {
        background: #ffffff !important;
    }

    body.theme-fandomdesktop-dark .main-page .mcwiki-header {
        background: none !important;
        border: none !important;
    }
`);
