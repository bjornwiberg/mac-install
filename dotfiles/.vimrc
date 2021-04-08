if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'tomtom/tcomment_vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'edkolev/tmuxline.vim'
Plug 'dhruvasagar/vim-zoom'
Plug 'jparise/vim-graphql'
Plug 'SirVer/ultisnips'
Plug 'APZelos/blamer.nvim'
Plug 'jreybert/vimagit'
Plug 'eliba2/vim-node-inspect'
Plug 'benmills/vimux'
Plug 'tyewang/vimux-jest-test'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Initialize plugin system
call plug#end()

set foldmethod=syntax
set nofoldenable

"" FZF
"" Include hidden files and respect .gitignore when searching for file
let $FZF_DEFAULT_COMMAND='rg --files -g "!.git/" --hidden'
"" Include hidden files and search only file content when searching in workspace
command! -bang -nargs=* Rg call fzf#vim#grep('rg --color=always --column -g "!.git/" --hidden -n --no-heading -S -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({ 'options': '-d : -n 4..' }), <bang>0)
"" ALT+f to search in workspace
nnoremap ƒ :Rg<cr>
"" CTRL+p to search for file
nnoremap <C-P> :Files<cr>

" termguicolors
set termguicolors
let g:Hexokinase_highlighters = ['sign_column']
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Node inspect mappings
nnoremap <silent><F4> :NodeInspectStart<cr>
nnoremap <silent><F5> :NodeInspectRun<cr>
nnoremap <silent><F6> :NodeInspectConnect("127.0.0.1:9229")<cr>
nnoremap <silent><F7> :NodeInspectStepInto<cr>
nnoremap <silent><F8> :NodeInspectStepOver<cr>
nnoremap <silent><F9> :NodeInspectToggleBreakpoint<cr>
nnoremap <silent><F10> :NodeInspectStop<cr>

" Leader
let mapleader = ","

" UltiSnips
let g:UltiSnipsSnippetDirectories = [$HOME . "/mac-install/dotfiles/UltiSnips"]
let g:UltiSnipsEditSplit="horizontal"
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
              return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<tab>"

" Set prisma extension to graphql
au BufNewFile,BufRead *.prisma setfiletype graphql

" Dont use arrow keys in normal mode
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap jk <ESC>

" Set undo and swap
set undofile
set undoreload=250
set undodir=~/.vim/undo//
set directory=~/.vim/swap//

" Search in files with selection
vnoremap // y:Rg <C-r>=escape(@",'/\')<CR><CR>

" copy selected text to clipboard
vnoremap yc :%w !pbcopy<CR><CR>

" reload .vimrc on save
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

" NerdTree
map <C-a> :NERDTreeTabsToggle<CR>
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
let g:NERDTreeWinPos = "right"
nmap <silent> <c-f> :NERDTreeFind<CR>
let g:NERDTreeWinSize=45

" Leader
let mapleader = ","

" Markdown Preview
nmap <C-m> <Plug>MarkdownPreviewToggle

set nu " add line numbers
set relativenumber
" disable relative line numbers when leaving buffer
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &ft!="nerdtree"|set relativenumber|endif
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set nowrap
" always uses spaces instead of tab characters
set expandtab

" Whitespace
set list
set listchars=tab:▸\ ,eol:¬
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Theme
colorscheme gruvbox
set cc=72,92
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" Make background transparent
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer  guibg=NONE ctermbg=NONE

" Set colors of color column and cursor line/column
hi! ColorColumn cterm=NONE ctermbg=88
set cursorline
set cursorcolumn

" air line
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline_extensions = ['branch', 'hunks', 'coc', 'tabline']
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'
" Configure error/warning section to use coc.nvim
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" coc config
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-emmet',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-tsserver',
  \ 'coc-ultisnips',
  \ 'coc-yaml',
  \ 'coc-rome',
  \ ]
" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
"
" don't give |ins-completion-menu| messages.
set shortmess+=c

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" always show signcolumns
set signcolumn=yes

" Splits
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nnoremap ,h :split<enter>
nnoremap ,v :vsplit<enter>
set splitbelow

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

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  returf !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" blamer
let g:blamer_enabled = 1
let g:blamer_template ='<author>, <author-time> • <summary>'
let g:blamer_show_in_visual_modes = 0
let g:blamer_prefix = ' > '
