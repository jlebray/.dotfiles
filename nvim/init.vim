" NeoVim init - Johan Le Bray
" {{{ ===== SETTINGS
syntax on
set autoindent
set breakindent
set complete=.,w,b,u,t,i
set cursorline
set dictionary="/usr/dict/words"
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
set rtp+=/usr/local/opt/fzf
set ruler
set scrolloff=10
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
set undofile
set undodir=~/.vim/undo
set visualbell
set wildignorecase
set wildmode=list:full,full
if (has("termguicolors"))
  set termguicolors
endif
if exists('&inccommand')
  set inccommand=split
endif

autocmd BufRead,BufNewFile *.{arb} set filetype=ruby
autocmd BufRead,BufNewFile *.{ecr} set filetype=html
autocmd BufRead,BufNewFile *.{tex} set spell breakindent linebreak
autocmd BufRead,BufNewFile *.scss.css setfiletype scss
autocmd BufRead,BufNewFile *.less setfiletype css
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

"File management
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'

"statusline
Plug 'itchyny/lightline.vim'

"text manipulation
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "Fuzzy completion
Plug 'tpope/vim-repeat'                "Better repeat
Plug 'tpope/vim-surround'              "surround verb
Plug 'tpope/vim-commentary'            "Easy comment
Plug 'junegunn/vim-easy-align'         "easy align
Plug 'kana/vim-textobj-user'           "custom blocks
Plug 'bronson/vim-trailing-whitespace' "remove whitespaces
Plug 'FooSoft/vim-argwrap'             "Line splitting
Plug 'tpope/vim-endwise'               "smart ends
Plug 'tommcdo/vim-exchange'            "cx/X to exchange
Plug 'adelarsq/vim-matchit'            "Better % match
Plug 'tpope/vim-abolish'               "Smart replace with :S
Plug 'terryma/vim-expand-region'
Plug 'jlebray/splitjoin.vim'

"tools
Plug 'beloglazov/vim-online-thesaurus'
Plug 'sbdchd/vim-run'                  "Run scripts
Plug 'sheerun/vim-polyglot'
Plug 'kshenoy/vim-signature'
Plug 'kassio/neoterm'                  "Fast access to terminal
Plug 'kepbod/quick-scope' "highlight fF
Plug 'simnalamburt/vim-mundo'

"snippets
Plug 'Shougo/neosnippet'
Plug 'jlebray/snippets'

"errors
Plug 'w0rp/ale'

"Git
Plug 'tpope/vim-fugitive'   "Keep for blame
Plug 'tpope/vim-rhubarb'
Plug 'mhinz/vim-signify'
Plug 'junegunn/gv.vim'
Plug 'jreybert/vimagit'

"HTML
Plug 'othree/html5.vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'cakebaker/scss-syntax.vim'
Plug 'vim-scripts/liquid.vim'          "Liquid syntax

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rails'
Plug 'KurtPreston/vim-autoformat-rails'

"Crystal
Plug 'rhysd/vim-crystal'

"Clojure
Plug 'tpope/vim-fireplace'

"Markdown
Plug 'plasticboy/vim-markdown'

"Writing
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'

"Themes
Plug 'junegunn/seoul256.vim'
Plug 'jlebray/spacemacs-theme.vim'

call plug#end()
" }}}
" {{{ Options
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ackprg = 'ag --vimgrep'      "The silver searcher
endif
let g:netrw_localrmdir='rm -r'       "Delete non empty directories with netrw

"Surround
let g:surround_no_insert_mappings = 1
let g:surround_35 = "<%# \r %>"
let g:surround_37 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

"deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#auto_completion_start_length=2
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ["neosnippet"]
let g:neosnippet#snippets_directory = "/Users/johan/.config/nvim/plugged/snippets/neosnippets/"
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

function! s:autocomplete_end()
  if pumvisible()
    return "\<C-y>"
  else
    return "\<CR>"
  endif
endfunction

imap <expr><TAB> <SID>neosnippet_complete()
imap <expr><C-j> <SID>neosnippet_jump()
imap <expr><CR> <SID>autocomplete_end()

"multi cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-b>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"argwrap
let g:argwrap_padded_braces = '{'
let g:argwrap_tail_comma_braces = '[{'

"Ruby
let g:ruby_indent_block_style = 'do'
let g:ruby_indent_assignment_style = 'variable'

"neoterm
let g:neoterm_position = 'vertical'

"ALE
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'ruby': ['rubocop'],
\}
let g:ale_enabled = 1
let g:ale_set_highlights = 0

let test#ruby#rspec#options = "--require ~/Code/formatter/rspec.rb --format QuickfixFormatter"

"highlight
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_first_occurrence_highlight_color = '#afff5f'
let g:qs_second_occurrence_highlight_color = '#5fffff'

"Magit
let g:magit_default_sections = ['info', 'commit', 'staged', 'unstaged']

"statusline
let g:lightline = {
      \ 'colorscheme': 'wombat',
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

" }}}
" }}}
" {{{ ===== THEME
set background=dark
" let g:seoul256_background = 235
" colorscheme seoul256
colorscheme spacemacs-theme
highlight ExtraWhitespace guibg=#990000 ctermbg=red
highlight TermCursor ctermfg=red guifg=red

" }}}
" {{{ ===== MAPPINGS
"Leader = Spacebar
let mapleader = " "

"Move between visual lines BUT keep correct count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

"Keep selection when indenting
vnoremap < <gv
vnoremap > >gv

"Move between quickfix
nnoremap <M-h> :cprev<cr>
nnoremap <M-j> :lnext<cr>
nnoremap <M-k> :lprev<cr>
nnoremap <M-l> :cnext<cr>

"J is used to switch tabs, so use C-n to join lines
nnoremap <c-n> J

"Run current file
vnoremap <leader>e :TREPLSendSelection<cr>
nnoremap <leader>e :TREPLSendFile<cr>

vnoremap <leader>y "+y
nmap Y y$

"files
nnoremap <leader>s :w<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>r :Move <c-R>%
nnoremap <leader>x :Unlink<cr>
nnoremap <leader>n :Ag<cr>
nnoremap <leader>u :MundoToggle<cr>
vnoremap 1 "hy:Ag <C-R>h<cr>

"Buffers
nnoremap <leader>b :Buffers<cr>
nnoremap <tab> <C-^>
nnoremap <leader>/ :BLines<cr>

"Window
nnoremap <silent> <leader>1 :only<cr>
nnoremap <silent> <leader>2 :vsplit<cr>
nnoremap <silent> <leader>3 :split<cr>
nnoremap <silent> <leader>d :q<cr>

"Files
nnoremap <leader>f :Files<cr>
nnoremap K :tabnext<cr>
nnoremap J :tabprev<cr>

"Align
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

"Git
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gp :!Git push<cr>
nnoremap <leader>gb :Gblame<cr>

"NeoVim
nnoremap <leader>vr :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>ve :tabedit ~/.config/nvim/init.vim<cr>
nnoremap <leader>vq :qa!<cr>

"Plug
nnoremap <leader>pi  :PlugInstall<cr>
nnoremap <leader>pug :PlugUpgrade<cr>
nnoremap <leader>pud :PlugUpdate<cr>
nnoremap <leader>pc  :PlugClean<cr>

"Notes
nnoremap <leader>n  :Note<space>
nnoremap <leader>nd :DeleteNote!<cr>
nnoremap <leader>ns :SearchNotes<space>
vnoremap <leader>n  :NoteFromSelectedText<cr>

"Misc
nnoremap <silent> <leader>h :nohlsearch<cr><c-l>
nnoremap <silent> <leader>l :ArgWrap<CR>

"Dash
fun! s:get_visual_selection()
  let l=getline("'<")
  let [line1,col1] = getpos("'<")[1:2]
  let [line2,col2] = getpos("'>")[1:2]
  return l[col1 - 1: col2 - 1]
endfun

"Function keys
nnoremap <F1> :Dash<cr>
nnoremap <F2> :tabnew<cr>
nnoremap <F3> :Ttoggle<cr>
nnoremap <F4> :Magit<cr>
nnoremap <F5> :Tags<cr>
nnoremap <F6> :set filetype=<cr>


"Fuzzy finder configuration
"let g:fzf_files_options = '--preview \"(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'\"'
let g:fzf_files_options =
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

"Remove search highlighting
nnoremap * *<c-o>

"CTags
nnoremap <C-]> g<C-]>

nnoremap <Leader>w :FixWhitespace<CR>
nnoremap <leader><leader> :T<space>
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}
" {{{ ===== MISC
"Move between splits
func! s:moveToSplit(direction)
  func! s:move(direction)
    stopinsert
    execute "wincmd" a:direction
  endfunc

  execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
        \ "<C-\\><C-n>"
        \ ":call <SID>move(\"" . a:direction . "\")<CR>"
  execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
        \ ":call <SID>move(\"" . a:direction . "\")<CR>"
endfunc

for dir in ["h", "j", "l", "k"]
  call s:moveToSplit(dir)
endfor

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
