" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif
"
" " Leader
" let mapleader = ","
"
" " Dim inactive windows using 'colorcolumn' setting
" " This tends to slow down redrawing, but is very useful.
" " Based on https://groups.google.com/d/msg/vim_use/IJU-Vk-QLJE/xz4hjPjCRBUJ
" " XXX: this will only work with lines containing text (i.e. not '~')
" " from
" if exists('+colorcolumn')
"   function! s:DimInactiveWindows()
"     for i in range(1, tabpagewinnr(tabpagenr(), '$'))
"       let l:range = ""
"       if i != winnr()
"         if &wrap
"          " HACK: when wrapping lines is enabled, we use the maximum number
"          " of columns getting highlighted. This might get calculated by
"          " looking for the longest visible line and using a multiple of
"          " winwidth().
"          let l:width=256 " max
"         else
"          let l:width=winwidth(i)
"         endif
"         let l:range = join(range(1, l:width), ',')
"       endif
"       call setwinvar(i, '&colorcolumn', l:range)
"     endfor
"   endfunction
"   augroup DimInactiveWindows
"     au!
"     au WinEnter * call s:DimInactiveWindows()
"     au WinEnter * set cursorline
"     au WinLeave * set nocursorline
"   augroup END
" endif
"
" " copy selected text to clipboard
" vnoremap yc :%w !pbcopy<CR><CR>
"
" " reload .vimrc on save
" augroup autosourcing
"   autocmd!
"   autocmd BufWritePost .vimrc source %
" augroup END
"
" " Maps Alt-J and Alt-K to macros for moving lines up and down
" " Works for modes: Normal, Insert and Visual
" nnoremap ∆ :m .+1<CR>==
" nnoremap ˚ :m .-2<CR>==
" inoremap ∆ <Esc>:m .+1<CR>==gi
" inoremap ˚ <Esc>:m .-2<CR>==gi
" vnoremap ∆ :m '>+1<CR>gv=gv
" vnoremap ˚ :m '<-2<CR>gv=gv
"
" " Search
" set incsearch
" set ignorecase
" nnoremap <silent> <Space>  :set hlsearch! hlsearch?<Bar>:echo<CR>
"
"
" set nu " add line numbers
" set relativenumber
" " disable relative line numbers when leaving buffer
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END
"
"
" set smarttab
" set cindent
" set tabstop=2
" set shiftwidth=2
" set nowrap
" " always uses spaces instead of tab characters
" set expandtab
"
" " Splits
" nnoremap ,h :split<enter>
" nnoremap ,v :vsplit<enter>
" set splitbelow
"
" let g:use_new_config = 1  " 0 represents false, 1 represents true
" if  g:use_new_config
"   call plug#begin('~/.vim/plugged')
"   " Initialize plugin system
"   call plug#end()
" else
"   " Specify a directory for plugins
"   call plug#begin('~/.vim/plugged')
"   Plug 'neoclide/coc.nvim', {'branch': 'release'}
"   Plug 'APZelos/blamer.nvim'
"   Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"   Plug 'junegunn/fzf.vim'
"   Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
"
"   Plug 'yardnsm/vim-import-cost', { 'do': 'npm install --production' }
"
" " Initialize plugin system
"   call plug#end()
"
"   " Gitgutter
"   nmap <leader>d :GitGutterNextHunk<CR>
"   nmap <leader>s :GitGutterPrevHunk<CR>
"   nmap <leader>a :GitGutterPreviewHunk<CR>
"
"
"   " FZF
"   " Include hidden files and respect .gitignore when searching for file
"   let $FZF_DEFAULT_COMMAND='rg --files -g "!.git/" --hidden'
"   " Include hidden files and search only file content when searching in workspace
"   " command! -bang -nargs=* Rg call fzf#vim#grep('rg --color=always --column -g "!.git/" --hidden -n --no-heading -S -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({ 'options': '-d : -n 4..' }), <bang>0)
"   " ALT+f to search in workspace
"   nnoremap ƒ :Rg<cr>
"   " CTRL+p to search for file
"   nnoremap <C-P> :Files<cr>
"
"   let g:coc_snippet_next = '<tab>'
"   imap <C-l> <Plug>(coc-snippets-expand)
"
"   " Set prisma extension to graphql
"   au BufNewFile,BufRead *.prisma setfiletype graphql
"
"   " Dont use arrow keys in normal mode
"   noremap <up> <nop>
"   noremap <down> <nop>
"   noremap <left> <nop>
"   noremap <right> <nop>
"
"
"   " Search in files with selection
"   vnoremap // y:Rg <C-r>=escape(@",'/\')<CR><CR>
"
"   " Markdown Preview
"   nmap <C-m> <Plug>MarkdownPreviewToggle
"
"   " Whitespace
"   set list
"   set listchars=tab:▸\ ,eol:↴
"   highlight ExtraWhitespace ctermbg=red guibg=red
"   match ExtraWhitespace /\s\+$/
"   autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"   autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"   autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"   autocmd BufWinLeave * call clearmatches()
"
"   " Theme
"   set cc=72,92
"   let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"
"   " Set colors of color column and cursor line/column
"   hi! ColorColumn cterm=NONE ctermbg=88
"   set cursorline
"   set cursorcolumn
"
"   " always show signcolumns
"   set signcolumn=yes
"   "
"
"   " Search for selected text, forwards or backwards.
"   vnoremap <silent> * :<C-U>
"     \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
"     \gvy/<C-R><C-R>=substitute(
"     \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
"     \gV:call setreg('"', old_reg, old_regtype)<CR>
"   vnoremap <silent> # :<C-U>
"     \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
"     \gvy?<C-R><C-R>=substitute(
"     \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
"     \gV:call setreg('"', old_reg, old_regtype)<CR>
"
"   " coc config
"   let g:coc_global_extensions = [
"     \ 'coc-css',
"     \ 'coc-emmet',
"     \ 'coc-eslint',
"     \ 'coc-html',
"     \ 'coc-json',
"     \ 'coc-pairs',
"     \ 'coc-prettier',
"     \ 'coc-tsserver',
"     \ 'coc-yaml',
"     \ 'coc-rome',
"     \ 'coc-snippets',
"     \ 'coc-tabnine',
"     \ ]
"   " from readme
"   " if hidden is not set, TextEdit might fail.
"   set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
"   set updatetime=300
"   "
"   " don't give |ins-completion-menu| messages.
"   set shortmess+=c
"
"   " Symbol renaming.
"   nmap <leader>rn <Plug>(coc-rename)
"
"
"   " Use tab for trigger completion with characters ahead and navigate.
"   " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"   inoremap <silent><expr> <TAB>
"         \ pumvisible() ? "\<C-n>" :
"         \ <SID>check_back_space() ? "\<TAB>" :
"         \ coc#refresh()
"   inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"   function! s:check_back_space() abort
"     let col = col('.') - 1
"     returf !col || getline('.')[col - 1]  =~# '\s'
"   endfunction
"
"   " Use <c-space> to trigger completion.
"   inoremap <silent><expr> <c-space> coc#refresh()
"
"   " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
"   " Coc only does snippet and additional edit on confirm.
"   " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"   " Or use `complete_info` if your vim support it, like:
"   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"
"   " Use `[g` and `]g` to navigate diagnostics
"   nmap <silent> [g <Plug>(coc-diagnostic-prev)
"   nmap <silent> ]g <Plug>(coc-diagnostic-next)
"   " show diagnostics with []
"   nmap <silent> [] :CocDiagnostics<CR>
"
"   " Remap keys for applying codeAction to the current line.
"   nmap <leader>do  <Plug>(coc-codeaction)
"   " Apply AutoFix to problem on the current line.
"   nmap <leader>qf  <Plug>(coc-fix-current)
"
"   " Remap keys for gotos
"   nmap <silent> gd <Plug>(coc-definition)
"   nmap <silent> gy <Plug>(coc-type-definition)
"   nmap <silent> gi <Plug>(coc-implementation)
"   nmap <silent> gr <Plug>(coc-references)
"
"   " Show documentation on hover
"   function! ShowDocIfNoDiagnostic(timer_id)
"     if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
"       silent call CocActionAsync('doHover')
"     endif
"   endfunction
"
"   function! s:show_hover_doc()
"     call timer_start(500, 'ShowDocIfNoDiagnostic')
"   endfunction
"
"   autocmd CursorHoldI * :call <SID>show_hover_doc()
"   autocmd CursorHold * :call <SID>show_hover_doc()
"
"   " Highlight symbol under cursor on CursorHold
"   autocmd CursorHold * silent call CocActionAsync('highlight')
"
"   augroup mygroup
"     autocmd!
"     " Setup formatexpr specified filetype(s).
"     autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"     " Update signature help on jump placeholder
"     autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"   augroup end
"
"   " blamer
"   let g:blamer_enabled = 1
"   let g:blamer_template ='<author>, <author-time> • <summary>'
"   let g:blamer_show_in_visual_modes = 0
"   let g:blamer_prefix = ' > '
"
"   " Automatic import cost
"   augroup import_cost_auto_run
"     autocmd!
"     autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx ImportCost
"     autocmd BufEnter *.js,*.jsx,*.ts,*.tsx ImportCost
"     autocmd CursorHold *.js,*.jsx,*.ts,*.tsx ImportCost
"   augroup end
" endif
