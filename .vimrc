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
Plugin 'ojroques/vim-oscyank' " vim copy/paste between remote and ios
Plugin 'scrooloose/nerdtree' " file tree, not sure what htis does...

Plugin 'jnurmine/Zenburn' " color scheme
Plugin 'altercation/vim-colors-solarized' " color scheme, GUI mode
Plugin 'scrooloose/syntastic' " check sytax at save
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} " info line... doesn't seem to work
Plugin 'tmhedberg/SimpylFold' " code folding
Plugin 'vim-scripts/indentpython.vim' " autoindent PEP8 python
" Plugin 'ctrlpvim/ctrlp.vim' " file finder, hit <CTRL-p>


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Other settings to be set here:

" Enable ios copy paste
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif"


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

" simpler switching of active tab with alt-arrows
noremap <S-Right> :wincmd w<CR>

" RUN PYTHON IN WINDOW - test crazy window idea:
" Bind ` to save file if modified and execute python script in a buffer.
nnoremap <silent> ` :call SaveAndExecutePython()<CR>
vnoremap <silent> ` :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction
