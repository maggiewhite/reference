" following is probably a noop https://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless
set nocompatible

" expand tabs into spaces
set expandtab
" set tabs to have 4 spaces
set tabstop=4
" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
" highlight search matches
set hlsearch
" show column and line number in bottom right hand corner
set ruler
" show line numbers
set number
" Set relative numbering on left hand side
set relativenumber
" show the matching part of the pair for [] {} and ()
set showmatch

" colors!
colorscheme desert
hi Search cterm=NONE ctermfg=white ctermbg=darkgrey
" show color column at char 101 to avoid long lines
let &colorcolumn=join(range(101,101),",")
highlight ColorColumn ctermbg=0 guibg=darkgrey
" enable syntax highlighting
syntax enable

" XXX: what does this do?
set viminfo='100,<1000,s100,h

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" setup ctags and cscope
set tags=tags;
source ~/.vim/cscope_maps.vim

set omnifunc=syntaxcomplete#Complete

"** setup VUNDLE **"
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" How-to add vundle plugins: https://goo.gl/XYpkUS
Plugin 'flazz/vim-colorschemes'
" Avoid needing to do :set paste
Plugin 'conradlrwin/vim-bracketed-paste'
" Autocomplete. Way too big/complicated.
Plugin 'Valloric/YouCompleteMe'
" Show git diff in most left column
Plugin 'airblade/vim-gitgutter'
call vundle#end()
"** VUNDLE **"

filetype plugin indent on
syntax on
