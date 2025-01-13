// ==UserScript==
// @name        YouTube
// @include     *://*.youtube.com/*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/youtube.css.js :: */

document.addEventListener('load', () => {
    try { document.querySelector('.ad-showing video').currentTime = 99999 } catch {}
    try { document.querySelector('.ytp-ad-skip-button').click() } catch {}
}, true);

GM_addStyle(`
    ytd-compact-promoted-video-renderer, .ytd-action-companion-ad-renderer,
    .ytd-ad-slot-renderer, .ytd-promoted-sparkles-web-renderer {
        display: none !important;
    }
`);
