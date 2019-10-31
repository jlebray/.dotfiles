" NeoVim init - Johan Le Bray
"  {{{ ===== SETTINGS
syntax on
set autoindent
set autoread
set breakindent
set cc=80,100
set complete=.,w,b,u,t,i
set cursorline
set dictionary='/usr/dict/words'
set expandtab
set foldmethod=marker
set hidden
set history=10000
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set mouse=a
set nobackup
set noswapfile
set number
set relativenumber
set rtp+=/home/johan/.fzf
set ruler
set scrolloff=10
set sessionoptions+=tabpages,globals
set shiftround
set shiftwidth=2
set smartcase
set smarttab
set softtabstop=2
set spelllang=fr
set splitbelow
set splitright
set tabstop=2
set timeoutlen=500 ttimeoutlen=0
set title
set undodir=~/.vim/undo
set undofile
set visualbell
set wildignorecase
set wildmode=list:full,full
if (has('termguicolors'))
  set termguicolors
endif
if exists('&inccommand')
  set inccommand=split
endif

augroup filetypes_stuff
  autocmd BufRead,BufNewFile *.{arb} set filetype=ruby
  autocmd BufRead,BufNewFile *.{ecr} set filetype=html
  autocmd BufRead,BufNewFile *.{vim} set foldmethod=marker
  autocmd FileType ruby set iskeyword+=!,?
  autocmd BufRead,BufNewFile *.{tex} set spell breakindent linebreak
  autocmd BufRead,BufNewFile *.scss.css setfiletype scss
  autocmd BufRead,BufNewFile *.less setfiletype css
augroup END

"python
let g:python3_host_prog = '/home/johan/.pyenv/versions/neovim/bin/python3'
let g:python_host_prog = '/home/johan/.pyenv/versions/neovim2/bin/python'
" }}}
" {{{ ===== PLUGINS
" {{{ Sources
"install vim-plug if not present
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" ❤️
Plug 'junegunn/fzf', { 'dir': '/home/johan/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug '/usr/local/opt/fzf'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'

" statusline
Plug 'itchyny/lightline.vim'

" text manipulation
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Fuzzy completion
Plug 'tpope/vim-repeat'                                       " Better repeat
Plug 'tpope/vim-surround'                                     " surround verb
Plug 'tpope/vim-commentary'                                   " Easy comment
Plug 'junegunn/vim-easy-align'                                " easy align
Plug 'kana/vim-textobj-user'                                  " custom blocks
Plug 'bronson/vim-trailing-whitespace'                        " remove whitespace
Plug 'FooSoft/vim-argwrap'                                    " Line splitting
Plug 'tpope/vim-endwise'                                      " smart ends
Plug 'tommcdo/vim-exchange'                                   " cx/X to exchange
Plug 'tpope/vim-abolish'                                      " Smart replace with :S, case switching
Plug 'terryma/vim-expand-region'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'vim-scripts/LargeFile'                                  "Edit large files

" tools
Plug 'beloglazov/vim-online-thesaurus'
Plug 'janko/vim-test'
Plug 'sheerun/vim-polyglot'
Plug 'kshenoy/vim-signature'
Plug 'kassio/neoterm'                                        " Fast access to terminal
Plug 'kepbod/quick-scope'                                     " highlight fF
Plug 'simnalamburt/vim-mundo'
Plug 'gcmt/taboo.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

" snippets
Plug 'Shougo/neosnippet'
Plug 'jlebray/snippets'

" errors
Plug 'w0rp/ale'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'mhinz/vim-signify'
Plug 'junegunn/gv.vim'
Plug 'jreybert/vimagit'

" HTML
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'vim-scripts/liquid.vim'                                 " Liquid syntax
Plug 'ap/vim-css-color'

" Ruby
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rails'

" Python
Plug 'szymonmaszke/vimpyter'
Plug '5long/pytest-vim-compiler'

" Clojure
Plug 'tpope/vim-fireplace'

" Writing
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'

" Themes
Plug 'jlebray/spacemacs-theme.vim'
Plug 'joshdick/onedark.vim'
Plug 'pgdouyon/vim-yin-yang'

" Prez
Plug 'vim-scripts/SyntaxRange'

" Deoplete plugins
Plug 'deoplete-plugins/deoplete-tag'
Plug 'ncm2/float-preview.nvim'

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'

call plug#end()
" }}}
" {{{ Options
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
let g:netrw_localrmdir='rm -r'       "Delete non empty directories with netrw

"Surround
let g:surround_no_insert_mappings = 1
let g:surround_35 = "<%# \r %>"
let g:surround_37 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

"deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#enable_refresh_always=0
let g:deoplete#enable_smart_case=1
let g:deoplete#file#enable_buffer_path=1
let g:deoplete#buffer#require_same_filetype=0
let g:deoplete#tag#cache_limit_size = 5000000

call deoplete#custom#option('max_list', 30)

call deoplete#custom#source('tag', 'rank', 10)
call deoplete#custom#source('ale', 'rank', 15)
call deoplete#custom#source('buffer', 'rank', 9998)
call deoplete#custom#source('neosnippet', 'rank', 9999)

call deoplete#custom#var('buffer', { 'require_same_filetype': v:false })
let g:float_preview#docked = 0

"vim-dispatch
let g:dispatch_compilers = {
      \ 'pytest': 'pytest',
      \ 'py.test': 'pytest'}

"neosnippets
let g:neosnippet#snippets_directory = "/home/johan/.config/nvim/plugged/snippets/neosnippets/"
function! s:neosnippet_complete()
  if neosnippet#expandable()
    return "\<Plug>(neosnippet_expand)"
  else
    if pumvisible()
      return "\<c-n>"
    else
      return "\<tab>"
    endif
  endif
endfunction

function! s:neosnippet_jump()
  if neosnippet#jumpable()
    return "\<Plug>(neosnippet_jump)"
  endif
endfunction

imap <expr><TAB> <SID>neosnippet_complete()
imap <expr><C-j> <SID>neosnippet_jump()
smap <expr><C-j> <SID>neosnippet_jump()

"argwrap
let g:argwrap_padded_braces = '{'
let g:argwrap_tail_comma_braces = '[{'

"Ruby
let g:ruby_indent_block_style = 'do'
let g:ruby_indent_assignment_style = 'variable'

"neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_term_per_tab = 1 " Different terminal for each tab
let g:neoterm_auto_repl_cmd = 0 " Do not launch rails console on TREPLsend

"ALE
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'javascript.jsx': ['eslint'],
\   'jsx': ['eslint'],
\   'json': ['fixjson'],
\   'ruby': ['rubocop'],
\   'rust': ['rustfmt'],
\   'python': ['autopep8'],
\}

let g:ale_enabled = 1
let g:ale_set_highlights = 0
let g:ale_fix_on_save = 0
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_echo_msg_format = '%linter% — %s'

"highlight
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_first_occurrence_highlight_color = '#afff5f'
let g:qs_second_occurrence_highlight_color = '#5fffff'

"Magit
let g:magit_default_sections = ['info', 'commit', 'staged', 'unstaged']

"statusline
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'filename': 'LightlineFilename'
      \ },
      \ }

function! LightlineFilename()
  let filename = expand('%') !=# '' ? expand('%') : '[No Name]'
  return filename
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

"vim-expand-region
call expand_region#custom_text_objects({
      \ 'a]' :1,
      \ 'ab' :1,
      \ 'aB' :1,
      \ })

call expand_region#custom_text_objects('ruby', {
      \ 'im' :0,
      \ 'am' :0,
      \ })

"vim-whiplash
let g:WhiplashProjectsDir = "~/code/"

"vim-test
let test#strategy = "neoterm"
let test#ruby#rspec#options = "--require spec_helper --require /home/johan/code/impacters-back/private/rspec_quickfix_formatter.rb --format QuickfixFormatter --profile 0"

"Fuzzy finder configuration
"let g:fzf_files_options = '--preview \"(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'\"'
let g:fzf_files_options =
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" CTRL-A CTRL-Q to select all and build quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction


let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" Vimpyter
autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>

"vim-notes
let g:notes_directories = ['~/.notes']

" }}}
" }}}
" {{{ ===== THEME
set background=dark
" colorscheme spacemacs-theme
colorscheme onedark
highlight ExtraWhitespace guibg=#990000 ctermbg=red
highlight TermCursor ctermfg=red guifg=red

" }}}
" {{{ ===== FUNCTIONS
"Loop cnext
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry

"Move between splits (or exit term)
func! s:moveToSplit(direction)
  func! s:move(direction)
    stopinsert
    execute "wincmd" a:direction
  endfunc

  execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
        \ "<C-\\><C-n>"
        \ ":call <SID>move(\"" . a:direction . "\")<CR>"
  " execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
  "       \ ":call <SID>move(\"" . a:direction . "\")<CR>"
endfunc

for dir in ["h", "j", "l", "k"]
  call s:moveToSplit(dir)
endfor

"Replace unicode codes by chars
function! ReplaceUnicode()
  %s/\\u\(\x\{4\}\)/\=nr2char('0x'.submatch(1),1)/g
endfunction
command! ReplaceUnicode call ReplaceUnicode()

"Format JSON
function! FormatJSON()
  %!python -m json.tool
endfunction
command! FormatJSON call FormatJSON()

"line spec in terminal
func! SpecLine()
  execute "T rspec %:" . line(".")
endfunc
command! SpecLine call SpecLine()

"Fix db/structure.sql conflict TODO: Fix
function! FixStruct()
  normal /<<<\<cr>kmajdd/===\<cr>dd/>>>\<cr>dd'akvG
  execute "sort u"
  normal ddvG
  execute "s/$/\r"
endfunction
command! FixStruct call FixStruct()

"Alias commands
fun! SetupCommandAlias(from, to)
  execute 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

"Switch project
function! s:open_project(project)
  execute "tcd ~/code/" . a:project
  execute "TabooRename " . a:project
endfunction
function! s:open_file_in_project(project)
  execute "tcd ~/code/" . a:project
  call fzf#vim#files(".")
  call feedkeys('i')
endfunction

function! s:switch_project()
  try
    call fzf#run({
    \ 'source':  'ls ~/code/',
    \ 'sink':    function('s:open_project')})
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction
command! SwitchProject call s:switch_project()

"Remove non visible buffers
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! DeleteInactiveBufs :call DeleteInactiveBufs()

" }}}
" {{{ ===== MAPPINGS
"Leader = Spacebar
let mapleader = " "
let maplocalleader = ","

"Move between visual lines BUT keep correct count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

"Keep selection when indenting
vnoremap < <gv
vnoremap > >gv

"Highlight selection
vnoremap * y:let @/ = @"<CR>

"Move between quickfix
nnoremap <M-h> :Cprev<cr>
nnoremap ˙ :Cprev<cr>
nnoremap <M-j> :Lnext<cr>
nnoremap ∆ :Lnext<cr>
nnoremap <M-k> :Lprev<cr>
nnoremap ˚ :Lprev<cr>
nnoremap <M-l> :Cnext<cr>
nnoremap ¬ :Cnext<cr>

"Emacs like movements
inoremap <M-b> <C-o>b
inoremap ∫ <C-o>b
inoremap <M-f> <C-o>f
inoremap ƒ <C-o>b
inoremap <M-a> <C-o>(
inoremap å <C-o>(
inoremap <M-e> <C-o>)
inoremap ´ <C-o>)
inoremap <M-{> <C-o>{
inoremap “ <C-o>{
inoremap <M-}> <C-o>}
inoremap ‘ <C-o>}
inoremap <M-o> <ESC>o
inoremap ø <ESC>o
inoremap <M-O> <ESC>O
inoremap Ø <ESC>O
inoremap <M-A> <ESC>A
inoremap Å <ESC>A

"J is used to switch tabs, so use C-n to join lines
nnoremap <c-n> J

"Run current file
vnoremap <leader>e :TREPLSendSelection<cr>
nnoremap <leader>e :TREPLSendFile<cr>

vnoremap <leader>y "+y
nnoremap Y y$

"files
nnoremap <leader>s :w<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>m :Move <c-R>%
nnoremap <leader>x :Unlink<cr>
nnoremap <leader>n :Rg<cr>
nnoremap <leader>u :MundoToggle<cr>
vnoremap 1 "hy:Rg <C-R>h<cr>
vnoremap <F5> "hy:Tags <C-R>h<cr>

"Buffers
nnoremap <leader>b :Buffers<cr>
nnoremap <tab> <C-^>
nnoremap <C-p> <tab>
nnoremap <leader>/ :BLines<cr>

"Window
nnoremap <silent> <leader>1 :only<cr>
nnoremap <silent> <leader>2 :vsplit<cr>
nnoremap <silent> <leader>3 :split<cr>
nnoremap <silent> <leader>d :q<cr>

"Files
nnoremap K :tabnext<cr>
nnoremap J :tabprev<cr>

"Align
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

"Git
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gb :Gblame<cr>

"DB
nnoremap <leader>q :DB postgres://postgres:4242424242@localhost:5432/pg_development<space>
vnoremap <leader>q :DB postgres://postgres:4242424242@localhost:5432/pg_development

"NeoVim
nnoremap <leader>vr :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>ve :tabedit ~/.config/nvim/init.vim<cr>
nnoremap <leader>vq :qa!<cr>

"Plug
nnoremap <leader>oi  :PlugInstall<cr>
nnoremap <leader>oug :PlugUpgrade<cr>
nnoremap <leader>oud :PlugUpdate<cr>
nnoremap <leader>oc  :PlugClean<cr>

"Misc
nnoremap <silent> <leader>h :nohlsearch<cr><c-l>
nnoremap <silent> <leader>l :ArgWrap<CR>

"Function keys
nnoremap <F2> :tabnew<cr>
nnoremap <F3> :Ttoggle<cr>
nnoremap <F4> :Magit<cr>
nnoremap <F5> :Tags<cr>
nnoremap <F6> :Dispatch<cr>
nnoremap <F7> :Make<cr>
nnoremap <F8> :set filetype=<cr>
nnoremap <F9> :ALEFix<cr>
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"Project
nnoremap <leader>p :SwitchProject<cr>

"Specs
nnoremap <leader>tt :TestFile<cr>
nnoremap <leader>tl :TestLast<cr>
nnoremap <leader>tn :TestNearest<cr>
nnoremap <leader>to :TestVisit<cr>

"Commands
call SetupCommandAlias("Ag","Rg")

"Remove search highlighting
nnoremap * *N

"CTags
nnoremap <C-]> g<C-]>

nnoremap <Leader>w :FixWhitespace<CR>
nnoremap <leader><leader> :T<space>
" }}}
" {{{ ===== CUSTOM BLOCKS
call textobj#user#plugin('erb', {
\   'code': {
\     'pattern': ['<%', '%>'],
\     'select-a': 'ay',
\     'select-i': 'iy',
\   },
\ })

call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction

call textobj#user#plugin('entire', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'ae',  '*select-a-function*': 's:select_a',
\        'select-i': 'ie',  '*select-i-function*': 's:select_i'
\      }
\    })

function! s:select_a()
  mark '

  keepjumps normal! gg0
  let start_pos = getpos('.')

  keepjumps normal! G$
  let end_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction

function! s:select_i()
  mark '

  keepjumps normal! gg0
  call search('^.', 'cW')
  let start_pos = getpos('.')

  keepjumps normal! G$
  call search('^.', 'bcW')
  normal! $
  let end_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction
" }}}
