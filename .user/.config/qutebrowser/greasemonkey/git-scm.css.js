// ==UserScript==
// @name        git-scm
// @include     *://git-scm.com*
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/git-scm.css.js :: */
/* intended for qutebrowser with darkmode enabled */

GM_addStyle(`
    :root {
        --box2-comment: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAABiAQMAAAAsisI4AAAABlBMVEURalVQUHokaxNLAAAAAXRSTlMAQObYZgAAAClJREFUKM9jYCAaMB8AYyKo///t//z/j50i3hTaA+LdMnipgQ0XOsc0AMGuePGoxt1xAAAAAElFTkSuQmCC) 32 16 round;
        /* base16 colors: */
        --color-black: #00002a;
        --color-blue: #66b0ff;
        --color-cyan: #0ef0f0;
        --color-cyan1: #32a6a6;
        --color-gray1: #30305a;
        --color-gray2: #20204a;
        --color-gray: #50507a;
        --color-green1: #3da651;
        --color-green: #59f176;
        --color-magenta: #fc4cb8;
        --color-orange: #fc8d28;
        --color-red1: #b32e2e;
        --color-red: #ff4242;
        --color-white1: #d0d0fa;
        --color-white: #f5f5ff;
        --color-yellow: #f3e877;
        /* extra colors: */
        --color-pink: #f10596;
        --color-purple: #f003ef;
        /* syntax colors: */
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

    * {
        font-family: Hack, Hack-Regular, monospace !important;
    }

    body {
        background: var(--color-bg) !important;
    }

    #masthead, #main {
        background: var(--color-bg1) !important;
    }

    .content {
        background: var(--color-bar) !important;
    }

    code, pre {
        background: var(--color-bg) !important;
        color: var(--color-code) !important;
    }

    h1, h2, h3, h4, h5, h6 {
        color: var(--color-heading) !important;
    }


    a {
        color: var(--color-link) !important;
    }

    a:hover {
        color: var(--color-active) !important;
    }

`)
