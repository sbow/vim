set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'scrooloose/nerdtree' " file tree, not sure what htis does...

Plugin 'jnurmine/Zenburn' " color scheme
Plugin 'altercation/vim-colors-solarized' " color scheme, GUI mode
Plugin 'scrooloose/syntastic' " check sytax at save
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} " info line... doesn't seem to work
Plugin 'tmhedberg/SimpylFold' " code folding
Plugin 'Valloric/YouCompleteMe' " code completion
Plugin 'vim-scripts/indentpython.vim' " autoindent PEP8 python
Plugin 'ctrlpvim/ctrlp.vim' " file finder, hit <CTRL-p>


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Other settings to be set here:
let python_highlight_all=1
syntax on	" sytax highlightin

if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif

autocmd vimenter * NERDTree
set nu

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

" PEP8 indentation:
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" Set UTF8, esp w Python 3
set encoding=utf-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
