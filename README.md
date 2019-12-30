fauxClip
=============

**fauxClip** is a Vim plugin to provide a pseudo _clipboard_ support for
versions of Vim compiled without _+clipboard_

---

**fauxClip** uses _xclip_ as default copy and paste command, but you can
override either of these commands if you have more specific needs.

(The following examples Linux's utilize defaults)

* Copy:
``` vim
let g:fauxClip_copy_cmd         = 'xclip -f -i -selection clipboard'
let g:fauxClip_copy_primary_cmd = 'xclip -f -i'
```
* Paste:
``` vim
let g:fauxClip_paste_cmd         = 'xclip -o -selection clipboard 2> /dev/null'
let g:fauxClip_paste_primary_cmd = 'xclip -o 2> /dev/null'
```
