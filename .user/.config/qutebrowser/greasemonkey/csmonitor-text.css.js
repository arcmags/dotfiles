// ==UserScript==
// @name        Christian Science Monitor Text Edition
// @include     *://www.csmonitor.com/text_edition*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/csmonitor-text.css.js :: */

GM_addStyle(`
    body, footer {
        background: var(--user-color-bg) !important;
        color: var(--user-color-fg) !important;
    }

    div[data-field='summary'] {
        color: var(--user-color-fg) !important;
    }

    u {
        text-decoration: none !important
    }

    a, .content-title>* {
        border: none !important;
        transition: none !important;
        -webkit-transition: none !important;
    }

    a, footer a:visited, .top-navigation a:visited, a:visited.navbar-brand {
        color: var(--user-color-heading) !important;
        text-decoration: none !important;
    }
    a:visited {
        color: var(--user-color-link) !important;
    }
    a:hover, footer a:hover, .top-navigation a:hover, a:hover.navbar-brand {
        color: var(--user-color-active) !important;
    }

    span[data-view='kicker'], h2 + small, .underlined,
    .footer-logo, #issn, .footer-social-links {
        display: none !important;
    }
`);
