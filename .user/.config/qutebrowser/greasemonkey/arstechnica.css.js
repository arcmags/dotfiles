// ==UserScript==
// @name        Ars Technica
// @include     *://arstechnica.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/arstechnica.css.js :: */

GM_addStyle(`
    .ad.ad.ad, .ad_wrapper, .ad-wrapper {
        display: none !important;
    }
    .listing-top.with-feature .article.top-feature figure .listing,
    .listing-top.with-feature .article.top-latest figure .listing,
    .listing-top.with-feature .article figure .listing,
    .listing-earlier .article figure .listing,
    .listing-latest .article figure .listing,
    .listing-rest .article figure .listing,
    .with-xrail .xrail .featured-video .video-thumbnail {
        background: none;
    }
`);
