"------------------------------------
" Preliminaries
"------------------------------------
let g:ale_set_signs = 1
set signcolumn=yes:1
set shell=/bin/zsh
let g:python3_host_prog = "/usr/bin/python3"
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
highlight clear SignColumn
filetype plugin indent on 
filetype on
set mouse=a
set lbr
set shortmess+=I
set number! relativenumber!
set hlsearch
" set guifont=Iosevka
set guioptions=agim
set guioptions-=e
set expandtab
set shiftwidth=4
set tabstop=4
set wrap
set ignorecase
set smartcase
set guitablabel=\[%N\]\ %t\ %M 
set lisp
set diffopt=vertical

let @m="i %>%\r  "
"nnoremap <C-m> @m " No funciona
"inoremap <C-M> <C-O>@m " No funciona

if exists('g:gui_oni')
    set nocompatible              " be iMproved, required
    filetype off                  " required

    set number
    set noswapfile
    set smartcase

    " Turn off statusbar, because it is externalized
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd

    " Enable GUI mouse behavior
    set mouse=a
endif

"------------------------------------
" Allow F11 to make full size window.
"------------------------------------
map <silent> <F11>
\    :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>


"------------------------------------
"NeoVim handles ESC keys as alt+key, set this to solve the problem
"------------------------------------
set ttimeout
set timeoutlen=1000 ttimeoutlen=0


"------------------------------------
" vim composer update 
"------------------------------------
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

"------------------------------------
" vimtex settings 
"------------------------------------
"let g:polyglot_disabled = ['latex']

"------------------------------------
" vim-plug 
" Set vim-plug to be the package manager
call plug#begin('~/.config/nvim/plugged')

 " Git Gutter
 Plug 'airblade/vim-gitgutter'

 Plug 'scrooloose/nerdtree'
 Plug 'github/copilot.vim'
 Plug 'sheerun/vim-polyglot' 
 Plug 'vim-pandoc/vim-pandoc-syntax'
 Plug 'vim-pandoc/vim-pandoc'
 Plug 'vim-pandoc/vim-rmarkdown'
 Plug 'jalvesaq/NVim-R'
 Plug 'mllg/vim-devtools-plugin'
 Plug 'ncm2/ncm2'
 Plug 'roxma/nvim-yarp'
 Plug 'gaalcaras/ncm-R'
 Plug 'ncm2/ncm2-cssomni'
 Plug 'ncm2/ncm2-tern'
 Plug 'ncm2/ncm2-path'
 Plug 'ncm2/ncm2-pyclang'
 Plug 'ncm2/ncm2-jedi'
 Plug 'ncm2/ncm2-go'
 Plug 'junegunn/vim-easy-align'
 Plug 'w0rp/ale'
 Plug 'ryanoasis/vim-devicons'

 " telescope requirements...
 Plug 'nvim-lua/popup.nvim'
 Plug 'nvim-lua/plenary.nvim'
 Plug 'nvim-telescope/telescope.nvim'

" Vim in chrome and firefox
" Plug 'glacambre/firenvim', { 'do': function('firenvim#install') }

call plug#end()

" Git Gutter

highlight GitGutterAdd guifg=#009900 ctermfg=Green
highlight GitGutterChange guifg=#bbbb00 ctermfg=Yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=Red
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0

" NERD Tree
map <leader>nn :NERDTreeToggle<CR>
map <leader>tm :botright vsp term://zsh<CR>


"------------------------------------
" Appearance
"------------------------------------

set colorcolumn=100
highlight ColorColumn ctermbg=darkgrey
syntax on

"-----------------------------
" ack.vim requirements
" -------------------------------
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"-----------------------------
" ncm requirements
" -------------------------------
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()
autocmd FileType TelescopePrompt  call ncm2#disable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc
" Note that omnifunc does not run in background and may probably block the
" editor. If you don't want to be blocked by omnifunc too often, you could
" add 180ms delay before the omni wrapper:
"  'on_complete': ['ncm2#on_complete#delay', 180,
"               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
au User Ncm2Plugin call ncm2#register_source({
        \ 'name' : 'css',
        \ 'priority': 9, 
        \ 'subscope_enable': 1,
        \ 'scope': ['css','scss'],
        \ 'mark': 'css',
        \ 'word_pattern': '[\w\-]+',
        \ 'complete_pattern': ':\s*',
        \ 'on_complete': ['ncm2#on_complete#delay', 180,
        \  'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
        \ })

" path to directory where libclang.so can be found
let g:ncm2_pyclang#library_path = '/usr/lib/llvm-11/lib'

"------------------------------------
" Fix syntax highlighting performance
"------------------------------------
" Workaround for slow syntax highlighting
" https://bugs.archlinux.org/task/36693
"set regexpengine=2
"set nocursorcolumn
"set nocursorline
"syntax sync minlines=28
"noremap <F10> <Esc>:syntax sync fromstart<CR>
"inoremap <F10> <C-o>:syntax sync fromstart<CR>


"------------------------------------
" Neomake Linter settings
"------------------------------------
" Make the file on every write
"autocmd! BufWritePost,BufEnter * Neomake
"
"let g:neomake_python_enabled_makers = ['pylint']
"let g:neomake_python_pylint_exe = 'pylint2'
"
"let g:neomake_r_lintr_maker = {
"    \ 'exe': 'R',
"    \ 'args': ['-e lintr::lint("%:p")'], 
"    \ 'errorformat': 
"        \ '%W%f:%l:%c: style: %m,' .
"        \ '%W%f:%l:%c: warning: %m,' .
"        \ '%E%f:%l:%c: error: %m,'
"    \ }
"
"let g:neomake_r_enabled_makers = ['lintr']
"
"------------------------------------
" ALE Linter settings
"------------------------------------
let b:alelinters = ['lintr', 'eslint', 'hadolint', 'jq', 'sqlint', 'swaglint']
let b:alefixers = ['lintr']
"let g:ale_r_lintr_options = 'lintr::with_defaults(object_name_linter(style=c("lowerCamelCase", "dotted.case")'
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1


"------------------------------------
" Deoplete Settings
"------------------------------------
"set runtimepath+=~/.config/nvim/plugged/deoplete.nvim/
"let g:deoplete#enable_at_startup = 1

"------------------------------------
" Spell Check
"------------------------------------
let g:myLang=0
let g:myLangList=["nospell","en_us", "es"]
function! ToggleSpell()
  let g:myLang=g:myLang+1
  if g:myLang>=len(g:myLangList) | let g:myLang=0 | endif
  if g:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, g:myLang)
  endif
  echo "spell checking language:" g:myLangList[g:myLang]
endfunction

hi clear SpellBad
hi SpellBad cterm=underline

nmap <silent> <C-S> :call ToggleSpell()<CR>
set guioptions-=T

 " a mi me gusta la tecnologia


"------------------------------------
" Shortcut for copy - paste
"------------------------------------

" nmap <C-V> "+gp
" imap <C-V> <ESC><C-V>a
" vmap <C-C> "+y


"------------------------------------
" Toggle filetypes R, Rnw, Lua and Tex 
"------------------------------------
let b:myFileType=-1   
let g:myFileTypeList=["tex","rnoweb","r", "lua"]
function! ToggleFileType()
  let b:myFileType=b:myFileType+1
  if b:myFileType>=len(g:myFileTypeList) | let b:myFileType=0 | endif
  execute "set filetype=".get(g:myFileTypeList, b:myFileType)
  echo "Filetype set to:" g:myFileTypeList[b:myFileType]
endfunction
nmap <silent> <F10> :call ToggleFileType()<CR>


"------------------------------------
" Filetype options and syntax
"------------------------------------
"autocmd BufNewFile,BufRead,BufEnter *.enaml setfiletype enaml
"au BufRead,BufNewFile *.drt set filetype=tex 
"au BufRead,BufNewFile *.Rnw set filetype=tex 
au BufRead,BufNewFile *.xtx set filetype=tex 
au BufRead,BufNewFile *.cls set filetype=tex 
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END


""------------------------------------
"" Tex-9 tex_nine settings 
""------------------------------------
"let g:tex_fold_enabled=0
"let g:tex_flavor="latex"
"let vimtex_compiler_progname = 'nvr'
"au BufRead,BufNewFile *.Rnw set tw=0 


"------------------------------------
" Nvim-R plugin
"------------------------------------
let vimrplugin_never_unmake_menu = 1
let vimrplugin_objbr_place = "console,right"
let vimrplugin_openpdf = 1
let rrst_syn_hl_chunk = 1
let rmd_syn_hl_chunk = 1
let R_assign = 2 
let R_pdfviewer="zathura"

if $DISPLAY != ""
    let vimrplugin_openpdf = 1
    let vimrplugin_openhtml = 1
endif

if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    inoremap <Nul> <C-x><C-o>
endif
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine


"------------------------------------
" Showmarks
"------------------------------------
let marksCloseWhenSelected = 0
let showmarks_include="abcdefghijklmnopqrstuvwxyz"


"------------------------------------
" configuration for vim-pandoc and vim-rmarkdown
"------------------------------------
let g:pandoc#modules#disabled = ["folding", "spell"]
let g:pandoc#syntax#conceal#use = 0
" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format


"------------------------------------
" Shortcuts
"------------------------------------
" Press F9 to toggle highlighting on/off, and show current value.
noremap <F9> :set hlsearch! hlsearch?<CR>


"------------------------------------
" Set R filetypes
"------------------------------------
" Copied from the vim-r-plugin ftdetect file
autocmd BufNewFile,BufRead *.Rprofile set ft=r
autocmd BufRead *.Rhistory set ft=r
autocmd BufNewFile,BufRead *.r set ft=r
autocmd BufNewFile,BufRead *.R set ft=r
autocmd BufNewFile,BufRead *.s set ft=r
autocmd BufNewFile,BufRead *.S set ft=r

autocmd BufNewFile,BufRead *.Rout set ft=rout
autocmd BufNewFile,BufRead *.Rout.save set ft=rout
autocmd BufNewFile,BufRead *.Rout.fail set ft=rout

autocmd BufNewFile,BufRead *.Rrst set ft=rrst
autocmd BufNewFile,BufRead *.rrst set ft=rrst

autocmd BufNewFile,BufRead *.Rmd set ft=rmd
autocmd BufNewFile,BufRead *.rmd set ft=rmd
" vim-r-plugin settings
let vimrplugin_assign_map = "<M-->"


"------------------------------------
" Set R tabstops to 2
"------------------------------------
autocmd FileType r setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType rnoweb setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType rdoc setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType rrst setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType rmd setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType css setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 expandtab

" Lines added by the Vim-R-plugin command :RpluginConfig (2014-Jun-04 08:48):
filetype plugin on

"------------------------------------
" Set R tabstops to 2
" from: http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file
"------------------------------------
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ----------------------------------------------------------
" indentLine settings
" ----------------------------------------------------------
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#4d4d4d'
let g:indentLine_color_tty_light = 7
let g:indentLine_color_dark = 7
let g:indentLine_char = '┆'

" ----------------------------------------------------------
" Look for long lines
" ----------------------------------------------------------
map <F2> :/\%>80v.\+<CR>

" ----------------------------------------------------------
" the silver searcher
" ----------------------------------------------------------
let g:ag_working_path_mode="r"

" ----------------------------------------------------------
" fill rest of line with characters
" from http://stackoverflow.com/questions/3364102/
"   \how-to-fill-a-line-with-character-x-up-to-column-y-using-vim
" ----------------------------------------------------------
function! FillLine( str )
    " set tw to the desired total length
    let tw = &textwidth
    if tw==0 | let tw = 78 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction

nmap <silent> <F3> :call FillLine('#')<CR>
nmap <silent> <S-F3> :call FillLine('%')<CR>


" ----------------------------------------------------------
" NETRW
" ----------------------------------------------------------
" NETRW settings
"function! IgnoreHTML()
"    let g:netrw_list_hide = '\.HTML$'
"endfunction

:tnoremap <C-n> <C-\><C-n>

" To align lines with brackets to the left
let r_indent_align_args = 0

" Stop indenting on brackets (especially for written text / non-code)
nmap <F4>:set noai<CR>

"------------------------------------
" New Statusline
"------------------------------------
let g:currentmode={
    \ 'n'  : 'N ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'V ',
    \ 'V'  : 'V·Line ',
    \ '^V' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'I ',
    \ 'R'  : 'R ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" Automatically change the statusline color depending on mode
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermfg=008'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine ctermfg=005'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermfg=004'
  else
    exe 'hi! StatusLine ctermfg=006'
  endif

  return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

com! FormatJSON %!python -m json.tool

set laststatus=2
set statusline +=%8*\ [%n]                               " buffernr 
set statusline +=%8*\ %<%F\ %{ReadOnly()}\ %m\ %w\       " File+path 
set statusline +=%#warningmsg#
set statusline +=%*
set statusline +=%9*\ %=                                 " Space
set statusline +=%8*\ %y\                                " FileType
set statusline +=%7*\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ 
set statusline +=%8*\ %-3(%{FileSize()}%)                " File size
set statusline +=%0*\ %3p%%\ \ %l:\ %3c\                " Rownumber/total (%)

hi StatusLine ctermbg=black
hi User1 ctermfg=007
hi User2 ctermfg=008
hi User3 ctermfg=008
hi User4 ctermfg=008
hi User5 ctermfg=008
hi User7 ctermfg=008
hi User8 ctermfg=008
hi User9 ctermfg=007


" ALE Settings
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
inoremap <C-k> %>%<CR>
highlight ALEWarning ctermbg=black
let NERDTreeShowHidden=1

nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-o> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
