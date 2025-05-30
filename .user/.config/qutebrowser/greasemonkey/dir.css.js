// ==UserScript==
// @name        local directory
// @include     file://*/
// ==/UserScript==

/* ~/.config/qutebrowser/greasemonkey/dir.css.js :: */

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

GM_addStyle(`
    * {
        border: none !important;
        margin: 0px !important;
        padding: 0px !important;
        color: var(--user-color-fg) !important;
        background: var(--user-color-bg) !important;
        font-family: var(--user-font-family) !important;
        font-size: var(--user-font-size) !important;
        text-decoration: none !important;
    }

    body {
        display: block !important;
        color: var(--user-color-fg) !important;
        background-color: var(--user-color-bg) !important;
        font-style: none !important;
        font-weight: normal !important;
        padding-left: 1ch !important;
        padding-right: 1ch !important;
    }

    h1 {
        border-color: var(--user-color-heading) !important;
        color: var(--user-color-heading) !important;
        display: table !important;
        font-weight: bold !important;
        border-bottom: solid !important;
        border-width: 2ch !important;
        border-image: var(--user-box1-heading) !important;
    }

    a {
        color: var(--user-color-link) !important ;
    }

    a:hover {
        color: var(--user-color-active) !important;
    }

    td {
        padding-right: 2ch !important;
    }

    #parentDirLinkBox, #parentDirLink, #parentDirText,
    thead, #theader, td:nth-child(2), td:nth-child(3) {
        display: none !important;
    }
`);
