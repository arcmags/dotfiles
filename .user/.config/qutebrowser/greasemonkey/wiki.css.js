// ==UserScript==
// @name        ArchWiki/Wikimedia
// @include     *://*.wikibooks.org/*
// @include     *://*.wikidata.org/*
// @include     *://*.wikimedia.org/*
// @include     *://*.wikinews.org/*
// @include     *://*.wikipedia.org/*
// @include     *://*.wikiquote.org/*
// @include     *://*.wikisource.org/*
// @include     *://*.wikiversity.org/*
// @include     *://*.wikivoyage.org/*
// @include     *://*.wiktionary.org/*
// @include     *://wiki.archlinux.org/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/wiki.css.js :: */

GM_addStyle(`
    body, #mw-head, #mw-panel, .mw-list-item {
        background: #ffffff !important;
    }
    .vector-menu-heading, .vector-menu-tabs a, .vector-menu-tabs,
    .vector-toc::after {
        background: none !important;
    }

    .vector-menu-heading {
        border-bottom: 1px solid #606060 !important;
    }
    .cn-fundraising {
        display: none !important;
    }
`);
