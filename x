let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/dev/ex/midterm/check_point
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 test/check_point_web/schema/user_mutation.exs
badd +54 test/check_point_web/schema/user_query_test.exs
badd +1 test/check_point_web/schema/user_subscription_test.exs
badd +2 ~/dev/ex/midterm/check_point/lib/check_point_web/resolvers/contact.ex
badd +1 ~/dev/ex/midterm/check_point/lib/check_point_web/schema.ex
argglobal
%argdel
$argadd test/check_point_web/schema/user_mutation.exs
$argadd test/check_point_web/schema/user_query_test.exs
$argadd test/check_point_web/schema/user_subscription_test.exs
edit ~/dev/ex/midterm/check_point/lib/check_point_web/schema.ex
argglobal
if bufexists(fnamemodify("~/dev/ex/midterm/check_point/lib/check_point_web/schema.ex", ":p")) | buffer ~/dev/ex/midterm/check_point/lib/check_point_web/schema.ex | else | edit ~/dev/ex/midterm/check_point/lib/check_point_web/schema.ex | endif
if &buftype ==# 'terminal'
  silent file ~/dev/ex/midterm/check_point/lib/check_point_web/schema.ex
endif
setlocal fdm=manual
setlocal fde=
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 24) / 48)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
