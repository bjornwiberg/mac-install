set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ryanoasis/vim-devicons'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ajh17/Spacegray.vim'
Plugin 'blueyed/smarty.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'jremmen/vim-ripgrep'
call vundle#end()
" required

" Theme
set t_Co=256
colorscheme spacegray
set cc=80
filetype plugin indent on    " required

" Air line
let g:airline_theme='wombat'
set laststatus=2

" Custom
set nu " Add line numbers
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <esc> <nop>
inoremap jk <esc>
syntax on
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>
set undofile
set undoreload=10000
set undodir=~/.vim/undo//
set directory=~/.vim/swap//

augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
augroup END

"Indentation
set nowrap
set tabstop=2
set softtabstop=2
set shiftwidth=2

autocmd Filetype php setlocal ts=4 sw=4 sts=0 expandtab

" No beep when using mapped commands
set noerrorbells visualbell t_vb=
if has('autocmd')
	  autocmd GUIEnter * set visualbell t_vb=
endif

"Fonts
set encoding=utf8
set guifont=DroidSansMono\ Nerd\ Font\ Mono:h14
let g:airline_powerline_fonts = 1

" Multiple cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-b>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" use ripgrep for insane speed
if executable('rg')
	set grepprg=rg\ --color=never
	let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
	let g:ctrlp_use_caching = 0
endif

" Splits
nmap <silent> <c-k> :wincmd k<CR>                                                                                                                       
nmap <silent> <c-j> :wincmd j<CR>                                                                                                                       
nmap <silent> <c-h> :wincmd h<CR>                                                                                                                       
nmap <silent> <c-l> :wincmd l<CR>
nnoremap ,v :split<enter>
nnoremap ,h :vsplit<enter>

" Tabs
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
nnoremap <C-W> 	   :tabclose<CR>
nnoremap H         gT " Go to prev tab
nnoremap L         gt " Go to next tab

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
