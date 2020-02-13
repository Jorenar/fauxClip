fauxClip
=============

**fauxClip** is a Vim plugin to provide a pseudo _clipboard_ support for
versions of Vim compiled without _+clipboard_

---

**fauxClip** uses

* _xclip_
* _pbcopy_/_pbpaste_
* _clip.exe_/_paste.exe_

as default copy and paste command, but you can
override either of these commands if you have more specific needs.

(The following examples utilize Linux's defaults)

* Copy:
``` vim
let g:fauxClip_copy_cmd         = 'xclip -f -i -selection clipboard'
let g:fauxClip_copy_primary_cmd = 'xclip -f -i'
```
* Paste:
``` vim
let g:fauxClip_paste_cmd         = 'xclip -o -selection clipboard'
let g:fauxClip_paste_primary_cmd = 'xclip -o'
```

---

If you for some reasons don't want to suppress error messages from clipboard
command (e.g. `xclip`'s empty clipboard), then:
```vim
let g:fauxClip_suppress_errors = 0
```
