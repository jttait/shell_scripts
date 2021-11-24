
" ##############################################################################
" # Colors                                                                     #
" ##############################################################################

colorscheme delek " colour scheme
syntax on         " enable syntax processing

" ##############################################################################
" # Indentation                                                                #
" ##############################################################################

filetype indent on " load filetype-specific indent files
set tabstop=3      " number of visual spaces shown for a tab character
set shiftwidth=3   " number of spaces when using < and > commands
set softtabstop=3  " number of spaces inserted (or removed) when you hit <TAB>
set expandtab      " tabs are spaces

" ##############################################################################
" # Line numbers                                                               #
" ##############################################################################

set number    " show line numbers
set showmatch " highlight matching [], (), {}

set ruler

" ##############################################################################
" # Searching                                                                  #
" ##############################################################################

set incsearch  " search as characters are entered
set hlsearch   " highlight matches
set ignorecase " ignore upper/lower case when searching

" ##############################################################################
" # Plugin: ALE                                                                #
" ##############################################################################

let g:ale_linters = { 'javascript': ['standard'], }
let g:ale_fixers = { 'javascript': ['standard'] }
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

" ##############################################################################
" # Plugin: Nerdcommenter                                                      #
" ##############################################################################

let g:NERDSpaceDelims = 1
nmap // <leader>c<space>
vmap // <leader>c<space>
