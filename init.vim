" camron flanders <me@camronflanders.com>
" last update: July 2022:CBF

" feel free to use all or part of my vimrc to learn, modify, use. If used in
" a .vimrc you intend to distribute, please credit appropriately.

set nocompatible                                                    "vim's better

"git-plug configuration {{{

" plug-ins list  {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.nvim-plugins')

" NVIM LSP
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" LSP Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

" Telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'folke/trouble.nvim'
Plug 'folke/todo-comments.nvim'

Plug 'axelvc/template-string.nvim'
Plug 'Raimondi/delimitMate'                             " auto closes quotes/brackets/etc
Plug 'Shougo/vimproc.vim'                               " async processing for vim
Plug 'itchyny/lightline.vim'                            " way faster than powerline

Plug 'sgur/vim-editorconfig'                            " project specific editor configuration

Plug 'wincent/terminus'                                 " meant to improve tmux/vim/term integration
Plug 'christoomey/vim-tmux-navigator'
Plug 'MikeDacre/tmux-zsh-vim-titles'

Plug 'kristijanhusak/vim-carbon-now-sh'                 " send code to Carbon

Plug 'AndrewRadev/switch.vim'
Plug 'dzeban/vim-log-syntax'
"Plug 'easymotion/vim-easymotion'
Plug 'phaazon/hop.nvim'                                 " easymotion replacement for nvim
Plug 'godlygeek/tabular'

Plug 'brooth/far.vim'                                   " powerful Find And Replace

Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdcommenter'

Plug 'tpope/vim-abolish'                                " replacements with case manipulation
Plug 'tpope/vim-characterize'                           " more char data on 'ga'
Plug 'tpope/vim-eunuch'                                 " unix helpers that work on the buffer and file together. delete/move/copy/etc
Plug 'tpope/vim-fugitive'                               " git integration
Plug 'tpope/vim-rhubarb'                                " github extension for fugitive
Plug 'tpope/vim-repeat'                                 " repeat on steroids
Plug 'tpope/vim-rsi'                                    " support readline keys on cmdline
Plug 'tpope/vim-speeddating'                            " C-A/X to inc/dec dates, numbers, more
Plug 'tpope/vim-surround'                               " better surround support
Plug 'tpope/vim-vinegar'                                " better Explore
Plug 'tpope/vim-jdaddy'                                 " JSON stuff
Plug 'tpope/vim-unimpaired'                                 " handy mappings for qf, lines, etc

Plug 'vim-scripts/YankRing.vim'
Plug 'wellle/targets.vim'                               " more text targets in vim
Plug 'docunext/closetag.vim'                            " autoclose tags in html/jsx

" REQUIRES treesitter
"Plug 'David-Kunz/jester'                                " jest test helpers

" syntax/language files
Plug 'sheerun/vim-polyglot'                             " handles all/most of the syntax files needed
Plug 'chrisbra/csv.vim'
Plug 'evanleck/vim-svelte'
Plug 'groenewege/vim-less'                              " LESS support
Plug 'neovimhaskell/haskell-vim'
Plug 'pantharshit00/vim-prisma'
Plug 'thalesmello/lkml.vim'                             " LookML
Plug 'akinsho/git-conflict.nvim'                        " git conflicts

" color themes
Plug 'altercation/vim-colors-solarized'
Plug 'srcery-colors/srcery-vim'
Plug 'tjammer/blayu.vim'
Plug 'tomasr/molokai'
Plug 'mhartington/oceanic-next'
Plug 'marciomazza/vim-brogrammer-theme'
Plug 'haishanh/night-owl.vim'
Plug 'sts10/vim-pink-moon'
Plug 'fenetikm/falcon'
Plug 'phanviet/vim-monokai-pro'
Plug 'andreypopp/vim-colors-plain'
Plug 'cocopon/iceberg.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

" https://github.com/catppuccin/nvim#compile
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

" https://github.com/EdenEast/nightfox.nvim#compile
Plug 'EdenEast/nightfox.nvim'

call plug#end()


" helper to check if a plugin has been loaded
function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

"}}}
"}}}


if &t_Co > 2
    syntax on
endif

if &t_Co >= 256 || has("termguicolors") || has("gui_running")
    if has("termguicolors") && &t_Co > 256
        set termguicolors
    endif

    if has("gui_running")
        set macligatures
        set anti                                                    " make text pretty
        set guifont=Fantasque\ Sans\ Mono:h15                       " tip: use guifont=* to open font picker
        set linespace=4

        set guitablabel=%t                                                  "tabs display file name

        "kick it old school, no gui needed.
        set guioptions-=T                                                   "kill toolbar
        set guioptions-=m                                                   "kill menu
        set guioptions-=r                                                   "kill right scrollbar
        set guioptions-=l                                                   "kill left scrollbar
        set guioptions-=L                                                   "kill left scrollbar with multiple buffers
    else
        set mouse=a
    endif


    if PlugLoaded('catppuccin')
    else
        if PlugLoaded('dracula')
            color dracula                                                   " best with Dracula terminal theme
        endif
    endif
endif

let g:node_host_prog = "$HOME/.volta/bin/neovim-node-host"

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j                                              " makes lines join properly, removes extra comment syntax and such
endif

let mapleader = "\<Space>"                                          "set leader to spacebar
let maplocalleader = "\\"                                           "set localleader to \

set timeoutlen=300                                                   " shorten key chord timeout len from 1000 to 300ms

set autoread
set noshowmode
set splitbelow
set splitright

set path+=**

"set cursorline                                                      "highlight the current line

" only highlight the cursorline in the active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

"startup settings {{{

"backup/swp settings {{{

set nobackup
set noswapfile
set noundofile

"}}}
"file type settings, on {{{

filetype on
filetype plugin on                                                  "turn on filetype based plugins
                                                                    "filetype indent is also on, in the next section.

"}}}

"}}}
"indentation stuff {{{

filetype indent on                                                  "indent based on filetype
set shiftround                                                      "round to a multiple of my tab settings

"}}}
"stuff {{{

let xml_use_xhtml = 1                                               "close html as xhtml, properly.
set encoding=utf-8
set scrolloff=3
set nowrap
set hidden                                                          "let me have hidden buffers
set showmatch                                                       "show me where the matching bracket is
set ttyfast
set ruler                                                           "show me the ruler!
set rulerformat=%35(%5l,%-6(%c%V%)\ %5L\ %P%)                       "my ruler shows: line/vColumn/total/pos
set history=1000                                                    "keep last 1000 commands
set undolevels=1000                                                 "use many muchos levels of undo
set sc                                                              "show commands as I type
set visualbell                                                      "a quiet vim is a happy vim
set backspace=indent,eol,start                                      "allow backspacing over everything
set modeline
set shortmess=atITA                                                 "I don't want long messages
set nostartofline                                                   "keep my cursor where it was
set fen                                                             "let me fold things
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
"set foldexpr=lsp#ui#vim#folding#foldexpr()
"set foldtext=lsp#ui#vim#folding#foldtext()
set foldlevel=7

set lazyredraw                                                      "don't update the screen during macros

set listchars=tab:▸\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»
set list                                                            "show chars

nnoremap <leader>z za

"}}}
"wildmenu {{{

set wildmenu                                                        "go wild!
set wildmode=longest,list:longest                                      "tame the wildness, using unix-style match
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db,*/.git/*,*/tmp/*,*.swp          "don't show me crap I don't want

set completeopt=preview,menuone,noinsert,noselect
"}}}
"cursor options {{{

set gcr=a:blinkwait500-blinkon1000-blinkoff150                      "tune the blinking of the cursor
set gcr=i:hor10                                                     "underline cursor. not too thick not too thin. goldielocks style
set gcr=v:block                                                     "selecting should cover the text

"}}}
"tab stuff {{{

set expandtab                                                       "expand tabs to spaces, when not an indent
set smarttab                                                        "let's be smart about our tabs
set shiftwidth=4                                                    "make tabs 4 spaces
set softtabstop=4                                                   "softtab value, 4 spaces
set tabstop=4                                                       "keep default for softtab compat.

"}}}
"search / diff {{{

set hlsearch                                                        "highlight what I find
set incsearch                                                       "show matches as I type
set ignorecase smartcase                                            "ignore case unless I type in multi-case

set laststatus=2

"}}}
"plugin settings {{{

"easymotion {{{
"move to line
"map <Leader>l <Plug>(easymotion-bd-jk)
"nmap <Leader>l <Plug>(easymotion-overwin-line)
nnoremap <Leader>l :HopLineStart<CR>

" Move to word
"map  <Leader>w <Plug>(easymotion-bd-w)
"nmap <Leader>w <Plug>(easymotion-overwin-w)
nnoremap <Leader>w :HopWord<CR>

"}}}

"multi cursor
"let g:multi_cursor_start_key='<C-m>'

"surround {{{

autocmd FileType php let b:surround_45 = "<?php \r ?>"
autocmd FileType php let b:surround_95 = "<?= \r ?>"

"}}}

"telescope settings {{{

nnoremap <leader>T :Telescope<CR>
nnoremap <leader>f :Telescope find_files<CR>
nnoremap <leader>r :Telescope live_grep<CR>
nnoremap <leader>b :Telescope buffers<CR>
nnoremap <leader>h :Telescope help_tags<CR>
nnoremap <leader>g :Telescope git_commits<CR>
nnoremap <leader>ts :Telescope treesitter<CR>

nnoremap <leader>fr :Telescope lsp_references<CR>
nnoremap <leader>fi :Telescope lsp_implementations<CR>
nnoremap <leader>fd :Telescope lsp_definitions<CR>
nnoremap <leader>ft :Telescope lsp_type_definitions<CR>
nnoremap <leader>fa :Telescope lsp_code_actions<CR>


"}}}

"fzf settings {{{

"  nnoremap <leader>f :Files<CR>
"  nnoremap <leader>d :Buffers<CR>
"  nnoremap <leader>h :Helptags<CR>
"  nnoremap <leader>g :Commits<CR>
"  nnoremap <leader>G :Commits<CR>
"  nnoremap <leader>r :Rg
"  nnoremap <leader>R :Rg<CR>
"
"  "[Buffers] Jump to the existing window if possible
"  let g:fzf_buffers_jump = 1
"
"  " Customize fzf colors to match your color scheme
"  let g:fzf_colors =
"    \ { 'fg':      ['fg', 'Normal'],
"    \ 'bg':      ['bg', 'Normal'],
"    \ 'hl':      ['fg', 'Comment'],
"    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"    \ 'hl+':     ['fg', 'Statement'],
"    \ 'info':    ['fg', 'PreProc'],
"    \ 'border':  ['fg', 'Ignore'],
"    \ 'prompt':  ['fg', 'Conditional'],
"    \ 'pointer': ['fg', 'Exception'],
"    \ 'marker':  ['fg', 'Keyword'],
"    \ 'spinner': ['fg', 'Label'],
"    \ 'header':  ['fg', 'Comment'] }

"}}}

"lightline {{{
let g:lightline = {
            \   'component': {
                \       'lineinfo': "%3l:%-2v/%{line('$')}"
                \   },
                \ }
"}}}

"YankRing {{{
let g:yankring_history_dir = "/tmp"
"}}}

"JSX {{{
let g:jsx_ext_required = 0

"}}}

"Move lines {{{
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
"}}}

" vim-svelte {{{
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0
"}}}

"Explore map & settings {{{
let g:netrw_liststyle=3
autocmd FileType netrw setl bufhidden=delete        " this will remove the explore buffers when hidden, so we can quit without bd! each one

"}}}

"NERDCommenter {{{

let NERDShutUp  =   1                                               "don't complain to me
map <leader>cc <plug>NERDCommenterToggle

"}}}

"}}}

autocmd BufNewFile,BufRead *.scss set ft=scss.css

"}}}
"abbreviations {{{

" Correct Typos {{{

" English {{{
iab beacuse    because
iab becuase    because
iab acn        can
iab cna        can
iab centre     center
iab chnage     change
iab chnages    changes
iab chnaged    changed
iab chnagelog  changelog
iab Chnage     Change
iab Chnages    Changes
iab ChnageLog  ChangeLog
iab debain     debian
iab Debain     Debian
iab defualt    default
iab Defualt    Default
iab differnt   different
iab diffrent   different
iab emial      email
iab Emial      Email
iab figth      fight
iab figther    fighter
iab fro        for
iab fucntion   function
iab ahve       have
iab homepgae   homepage
iab logifle    logfile
iab lokk       look
iab lokking    looking
iab mial       mail
iab Mial       Mail
iab miantainer maintainer
iab amke       make
iab mroe       more
iab nwe        new
iab recieve    receive
iab recieved   received
iab erturn     return
iab retrun     return
iab retunr     return
iab seperate   separate
iab shoudl     should
iab soem       some
iab taht       that
iab thta       that
iab teh        the
iab tehy       they
iab truely     truly
iab waht       what
iab wiht       with
iab whic       which
iab whihc      which
iab yuo        you
iab databse    database
iab versnio    version
iab obnsolete  obsolete
iab flase      false
iab recrusive  recursive
iab Recrusive  Recursive
"}}}
" Days of week {{{
iab monday     Monday
iab tuesday    Tuesday
iab wednesday  Wednesday
iab thursday   Thursday
iab friday     Friday
iab saturday   Saturday
iab sunday     Sunday
"}}}

"}}}

"}}}
"key mappings {{{
"plugin mappings {{{

let g:user_emmet_leader_key = '<C-Y>'

"}}}
".vimrc editing maps {{{

"makes it easy to edit/reload vimrc for tweaks. I like to tweak.
:nmap <leader>s :so $MYVIMRC<CR>
:nmap <leader>v :tabe $MYVIMRC<CR>

"}}}

"buffer navigation nmaps {{{

map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l

"}}}
"general maps {{{

"make vim use correct regexes
nnoremap / /\v
vnoremap / /\v

nnoremap <leader>L :set list!<cr>

"changes :command to ;command making it faster
nnoremap ; :
vnoremap ; :

"make this the way it should work by default
noremap Y y$

"toggle wrap
nmap <leader>W :set nowrap!<CR>

"toggle linenumbers
nmap <leader>N :set number!<CR>

"when wrapping, wrap text to the correct indentation
set breakindent
set showbreak=↪

" make jj esc, in insert mode.
inoremap jj <C-[>

" easily, temporarily disable search highlighting"
nmap <silent> <leader>/ :silent :nohlsearch<CR>

" sudo write to files that weren't opened with sudo originally!
cmap w!! w !sudo tee % >/dev/null

"}}}
"expansions {{{

"file directory
imap <leader>fd    <C-R>=expand("%:p:h")<CR>
" present working dir
imap <leader>pwd   <C-R>=getcwd()<CR>
" insert todays date YYYY-MM-DD
imap <leader>td    <C-R>=strftime("%Y-%m-%d")<CR>

"}}}

"}}}

"autocmd {{{
"remove trailling whitespace
autocmd FileType c,cpp,java,php,javascript,python autocmd BufWritePre <buffer> %s/\s\+$//e
"}}}

nnoremap <leader>S :setlocal spell! spelllang=en_us<CR>

lua << EOF
require("core")
EOF

" vim:foldmethod=marker:foldlevel=0:ft=vim:
