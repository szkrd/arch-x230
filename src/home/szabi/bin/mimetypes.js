#!/usr/bin/env node
/*
Lists mimetypes and their associations.
Defaults are not shown, calling `xdg-mime query default`
would require async and a somewhat more complicated approach

----
If you are reading this, you probably want to modify a mimetype kiddo.
[https://wiki.archlinux.org/index.php/default_applications#XDG_standard]

- determine a file's MIME type
  `xdg-mime query filetype photo.jpeg`
- determine the default application
  `xdg-mime query default image/jpeg`
- change the default
  `xdg-mime default feh.desktop image/jpeg`
- open a file
  `xdg-open photo.jpeg`
*/
const fs = require('fs');
const cp = require('child_process');

let dir = '/usr/share/applications/';
let items = fs.readdirSync(dir);
let allMimeTypes = [];
let mimeMap = {};
let maxLen = 0;
(items || []).forEach(item => {
  let contents = fs.readFileSync(dir + item, 'utf-8') + '';
  contents = contents.split(/[\r\n]/);
  let mts = (contents.find(line => line.startsWith('MimeType=')) || '');
  mts = mts.replace(/^MimeType=/, '');
  mts = mts.split(';');
  mts.forEach(mt => {
    if (!mt) {
      return;
    }
    maxLen = Math.max(maxLen, mt.length);
    mimeMap[mt] = mimeMap[mt] || [];
    mimeMap[mt].push(item.replace(/\.desktop/, ''));
  });
  allMimeTypes = [...new Set(allMimeTypes.concat(mts))];
});
allMimeTypes = allMimeTypes.filter(mt => !!mt.trim())
allMimeTypes.sort();
allMimeTypes.forEach(mt => {
  let split = new Array(maxLen - mt.length + 2).join('-');
  console.log(mt + ' ' + split + '> '+ mimeMap[mt] || '');
});
