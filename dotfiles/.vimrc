if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'VundleVim/Vundle.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mattn/emmet-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
" Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'mg979/vim-visual-multi'
Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'airblade/vim-gitgutter'
Plug 'jremmen/vim-ripgrep'
Plug 'w0rp/ale'
Plug 'tomtom/tcomment_vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'gorodinskiy/vim-coloresque'
Plug 'pangloss/vim-javascript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'mxw/vim-jsx'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'ervandew/supertab'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --ts-completer' }
Plug 'SirVer/ultisnips'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'dhruvasagar/vim-zoom'
Plug 'jparise/vim-graphql'
call plug#end()

" let g:UltiSnipsSnippetsDir = $HOME . "/mac-install/dotfiles/UltiSnips"
let g:UltiSnipsSnippetDirectories = [$HOME . "/mac-install/dotfiles/UltiSnips"]
let g:UltiSnipsEditSplit="vertical"

" make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'
set completeopt-=preview

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger="<C-q>"
let g:UltiSnipsJumpForwardTrigger="<C-q>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"

" let g:UltiSnipsExpandTrigger="<Tab>"
" let g:UltiSnipsJumpForwardTrigger="<Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
"
" Js syntax highlight
let g:javascript_plugin_jsdoc = 1
let g:jsx_ext_required = 0

" Leader
let mapleader = ","
"
" Emmet
let g:user_emmet_leader_key='<C-S>'

" Theme
syntax on
colorscheme solarized8_flat
set cc=72,92
" set synmaxcol=0
filetype plugin indent on    " required
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" let g:DevIconsEnableFoldersOpenClose = 1

"Make background transparent
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer  guibg=NONE ctermbg=NONE

" Set colors of color column and cursor line/column
hi! ColorColumn cterm=NONE ctermbg=88
" hi! CursorColumn cterm=NONE ctermbg=22 guibg=#262626
" hi! CursorLine cterm=none ctermbg=52 guibg=#262626
"
" highlight SignColumn ctermbg=NONE
highlight GitGutterAdd    ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1

" air line
let g:airline_theme='iceberg'
let g:airline#extensions#tabline#enabled = 1
" set laststatus=2

" custom
set nu " add line numbers
set relativenumber " use relative line numbers
" disable relative line numbers when leaving buffer
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &ft!="nerdtree"|set relativenumber|endif
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
" noremap jk <esc>
" inoremap <esc> <nop>
inoremap jk <esc>
" nnoremap ,cd :cd %:p:h<cr>:pwd<cr>
set undofile
set undoreload=250
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
nnoremap <c-g> :Rg<cr>
" Search in files with selection
vnoremap // y:Rg <C-r>=escape(@",'/\')<CR><CR>
" copy selected text to clipboard
vnoremap yc :%w !pbcopy<CR><CR>
augroup autosourcing
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END

" Maps Alt-J and Alt-K to macros for moving lines up and down
" Works for modes: Normal, Insert and Visual
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Search
set incsearch
set ignorecase
nnoremap <silent> <Space>  :set hlsearch! hlsearch?<Bar>:echo<CR>

"Indentation
set nowrap
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" NerdTree
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
map <C-a> :NERDTreeTabsToggle<CR>
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
autocmd StdinReadPre * let s:std_in=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" " file, and we're not in vimdiff
" function! SyncTree()
"   if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
"     NERDTreeFind
"     wincmd p
"   endif
" endfunction
"
" " Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()

" No beep when using mapped commands
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

set encoding=utf8
set list
set listchars=tab:▸\ ,eol:¬
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

set cursorline
set cursorcolumn

"Fonts
set guifont=DroidSansMono\ Nerd\ Font\ Mono:h14
" let g:airline_pedkolev/tmuxline.vimowerline_fonts = 1

" " Multiple cursors
" let sdag:multi_cursor_use_default_mapping=0
" let sdag:multi_cursor_next_key='<C-n>'
" let sdag:multi_cursor_prev_key='<C-b>'
" let sdag:multi_cursor_skip_key='<C-x>'
" let sdag:multi_cursor_quit_key='<Esc>'

" Visual multi
function! VM_Start()
  nmap <buffer> <C-C> <Esc>
  imap <buffer> <C-C> <Esc>
endfunction

function! VM_Exit()
  nunmap <buffer> <C-C>
  iunmap <buffer> <C-C>
endfunction

" ctrlp config
let g:ctrlp_show_hidden = 1
" use ripgrep for insane speed
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --hidden'
  let g:ctrlp_use_caching = 0
endif

" ALE Config
let g:ale_sign_warning = '⚠'
" let g:ale_sign_error = '✗'
let g:ale_sign_error = '>>'
let g:ale_sign_column_always = 1
" let g:ale_change_sign_column_color = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'css': ['styleline'],
\   'scss': ['styleline'],
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\}

" Treat JSX as Javascript files
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

" gitgutter config (enable check on save)
autocmd BufWritePost * GitGutter

" magit config
let g:magit_refresh_gitgutter=1

" Vim Markdown Preview
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_temp_file=1
let vim_markdown_preview_browser='Google Chrome'

" Splits
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nnoremap ,h :split<enter>
nnoremap ,v :vsplit<enter>
set splitbelow

" Tabs
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
nnoremap H         gT " Go to prev tab
nnoremap L         gt " Go to next tab

" Auto toggle paste/nopaste
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap f <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap f <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
