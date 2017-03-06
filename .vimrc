" Pathogen (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()


" https://dougblack.io/words/a-good-vimrc.html

" Colors
colorscheme molokai        " https://github.com/tomasr/molokai
let g:molokai_original = 1
syntax enable              " enable syntax processing

" Spaces & Tabs
au BufNewFile,BufRead *.py
    \ set tabstop=4       " number of visual spaces per TAB
    \ set softtabstop=4   " number of spaces in tab when editing
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab       " tabs are spaces
   " \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" Flagging unnecessary whitespace
" (https://github.com/RadoRado/dotfiles/blob/35f34cd0ebaab8815dd1f9d30b0df4e138265e75/vimrc#L151)
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" UI Config
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent plugin on " load filetype-specific indent files (http://vim.wikia.com/wiki/Example_vimrc)
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.

" Searching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" Folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
nnoremap <space> za
" (space open/closes folds)
set foldmethod=indent   " fold based on indent level

" Leader Shortcuts
nnoremap <leader>u :GundoToggle<CR>
" (toggle gundo)
nnoremap <leader>a :Ack
" (open ack.vim)
"let g:ackprg = 'ag --nogroup --nocolor --column' " https://github.com/ggreer/the_silver_searcher
"let g:ackprg = 'ag --vimgrep'
" Which has the same effect but will report every match on the line.


" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Enable use of the mouse for all modes
set mouse=a

" UTF8 support
set encoding=utf-8


" Syntastic (https://github.com/vim-syntastic/syntastic)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


set backspace=indent,eol,start

