// ==UserScript==
// @name        Christian Science Monitor Text Edition
// @include     *://www.csmonitor.com/text_edition*
// ==/UserScript==

GM_addStyle(`
    :root {
        --color-active: #0ef0f0;
        --color-bar: #30305a;
        --color-bg: #00002a;
        --color-bg1: #20204a;
        --color-code: #f5f5ff;
        --color-comment: #50507a;
        --color-em: #fc4cb8;
        --color-fg: #d0d0fa;
        --color-heading: #66b0ff;
        --color-link: #32a6a6;
    }

    body, footer {
        background: var(--color-bg) !important;
        color: var(--color-fg) !important;
    }

    div[data-field='summary'] {
        color: var(--color-fg) !important;
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
        color: var(--color-heading) !important;
        text-decoration: none !important;
    }
    a:visited {
        color: var(--color-link) !important;
    }
    a:hover, footer a:hover, .top-navigation a:hover, a:hover.navbar-brand {
        color: var(--color-active) !important;
    }

    span[data-view='kicker'], h2 + small, .underlined,
    .footer-logo, #issn, .footer-social-links {
        display: none !important;
    }
`);
