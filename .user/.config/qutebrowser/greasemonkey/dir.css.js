// ==UserScript==
// @name        local directory
// @include     file://*/
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/dir.css.js :: */

GM_addStyle(`
    :root {
        --box1-heading: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAABiAQMAAAAsisI4AAAABlBMVEXoFlZmsP/bK+TbAAAAAXRSTlMAQObYZgAAADRJREFUKM9jYCAaMB8AY3TK/g8G9f+//Z///4EUAwMyBRbEqgGr0bQHOHw0pCg6hsvAxzQA7+WCycmpv9AAAAAASUVORK5CYII=) 32 16 round;
        --color-active: #0ef0f0;
        --color-bg: #00002a;
        --color-fg: #d0d0fa;
        --color-heading: #66b0ff;
        --color-link: #32a6a6;
    }

    * {
        border: none !important;
        margin: 0px !important;
        padding: 0px !important;
        color: var(--color-fg) !important;
        background: var(--color-bg) !important;
        font-family: Hack, Hack-Regular, monospace !important;
        font-size: 16px !important;
        text-decoration: none !important;
    }

    body {
        display: block !important;
        color: var(--color-fg) !important;
        background-color: var(--color-bg) !important;
        font-style: none !important;
        font-weight: normal !important;
        padding-left: 1ch !important;
        padding-right: 1ch !important;
    }

    h1 {
        border-color: var(--color-heading) !important;
        color: var(--color-heading) !important;
        display: table !important;
        font-weight: bold !important;
        border-bottom: solid !important;
        border-width: 2ch !important;
        border-image: var(--box1-heading) !important;
    }

    a {
        color: var(--color-link) !important ;
    }

    a:hover {
        color: var(--color-active) !important;
    }

    td {
        padding-right: 2ch !important;
    }

    #parentDirLinkBox, #parentDirLink, #parentDirText,
    thead, #theader,
    td:nth-child(2), td:nth-child(3) {
        display: none !important;
    }
`);

var header = document.getElementById('header');
var text = header.textContent.slice(9);
header.textContent = text;
document.title = text;

if (text != '/') {
    var table = document.getElementsByTagName('table')[0];
    var row = table.insertRow(1);
    var cell = row.insertCell();
    var a = document.createElement('a');
    var updir = document.createTextNode('../');
    a.href = '../';
    a.appendChild(updir);
    cell.appendChild(a);
};
