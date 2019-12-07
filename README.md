fauxClip
=============

**fauxClip** is a Vim plugin to provide a pseudo _clipboard_ support for
versions of Vim compiled without _+clipboard_

---

**fauxClip** uses _xclip_ as default copy and paste command, but you can
override either of these commands if you have more specific needs.

(The following examples utilize defaults)

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

---

The main difference between **fauxClip** and +clipboard are command line `:yank`
and `:delete`. For range based selection through command line mode this plugin
defines two commands: `[range]Y [x]` and `[range]D [x]`, where `[x]` is either
`+` or `*`.

Example: Yank to _clipboard_ whole file then to _primary_ delete lines from 4 to 16

```vim
:%Y +
:4,16D *
```

---

If variable `g:fauxClip_enable_aliases` is set to `1`, fauxClip will define
the following command line mode aliases:

```
{lhs}   {rhs}
------  ------
d*      D *
d+      D +
y*      Y *
y+      Y +
%d*     %D *
%d+     %D +
%y*     %Y *
%y+     %Y +
```
