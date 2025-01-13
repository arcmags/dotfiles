// ==UserScript==
// @name        SMBC
// @include     *://*.smbc-comics.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/smbc-comics.css.js :: */

GM_addStyle(`
    body {
        background: var(--color-bg) !important;
    }

    #mainwrap {
        border: none !important;
        background: none !important;
        padding: 0px !important;
    }

    #comicleft {
        float: none !important;
        margin: auto !important;
    }

    #blogarea, #blogheader, #blogmsgmobile, #boardleader, #buythis,
    #comicright, #commentarea, #comment-space, #footer, #header, #hw-jumpbar,
    #midleader, #mobad1, #mobaftercomic, #mobfacebook, #mobilefooter,
    #mobilemenu, #mobilepermalink, #mobtumblr, #mobtwitter,
    #navtop + script + a, #permalink, #sharebar, #sharemob, .cc-tagline {
        display: none !important;
    }
`);
