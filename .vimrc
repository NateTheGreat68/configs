set tabstop=4 expandtab shiftwidth=4 smarttab autoindent nowrap
syntax on

nmap <S-Tab> <<
vmap <S-Tab> <
imap <S-Tab> <Esc><<i

nmap <Tab> >>
vmap <Tab> >

highlight OverLength ctermbg=darkred ctermfg=white
match OverLength /\%>72v.\+/
