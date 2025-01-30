# vim-operatorify

Turn Vim functions into operators easily. So OP.

## What it does

- Turn any function into a Vim operator (note: the function will receive a text 1st argument)
- Automatically handles dot-repeat
- Helper for a quick operator mapping
- Want to map multiple functions into an operator? No problem. Use a popup menu helper to manage multiple operators

## Usage

### Basic Function Requirements

Your function should accept a string as its first argument:

```vim
function! MyFunction(text)
    " Do something with text
    echo "Processing: " .. a:text
endfunction
```

### Creating Operators

#### Using the Mapper Helper

```vim
call Operatorify#Mapper('go', 'MyFunction')
```

The mapper follows the convention that repeating the last character of the key creates a line operator.
- `go` operates on a motion
- `goo` operates on the current line
- `go` in visual mode operates on the selection

#### Manually

If you want to create your own set of mapping:

```vim
" Create mappings
nnoremap <expr> <Plug>MyFunction Operatorify#Wrapper('MyFunction')
nnoremap <expr> <Plug>MyFunctionLine Operatorify#Wrapper('MyFunction') .. '_'

" Map to keys
nmap go  <Plug>MyFunction
nmap goo <Plug>MyFunctionLine
```

## Configuration

### Popup List Options

You can customize the appearance and behavior of the popup menu:

```vim
let g:operatorify_lister_options = {
    \ 'callback': 'PopupCallback',
    \ 'border': [0,0,0,0],
    \ 'padding': [0,1,0,0],
    \ 'pos': 'topleft',
    \ 'moved': [0, 0, 0],
    \ 'scrollbar': 1,
    \ 'maxheight': 5,
    \ 'fixed': 1,
    \ 'highlight': 'Normal',
    \ 'minwidth': 25
    \ }
```

### Using And Managing the Popup List Items

You can manage multiple operators through a popup menu. By default, this is mapped to `gl`:

```vim
" Define your functions
function! ToUpper(text)
    return toupper(a:text)
endfunction

function! ToLower(text)
    return tolower(a:text)
endfunction

" Set up the list
let g:operatorify_list = ['ToUpper', 'ToLower']

" Default mapping is gl, but you can change it
" You can run it as a command too
nnoremap <leader>o :call Operatorify#Lister()<CR>
```

To disable the default mapping, add this to your vimrc:
```vim
let g:operatorify_no_mappings = 1
```

## Installation

### Using vim-plug

```vim
Plug 'iggredible/vim-operatorify'
```

Source the file, then run `:PlugInstall`.

Should work with other plugin managers.

## Documentation

```vim
:help operatorify
```

## Examples

### Creating a Case-Changing Operator

```vim
function! ToggleCase(text)
    return a:text =~# '\u' ? tolower(a:text) : toupper(a:text)
endfunction

call Operatorify#Mapper('gt', 'ToggleCase')

" gt{motion} - toggle case of motion
" gtt        - toggle case of current line
" gt         - toggle case of visual selection
```

### Multiple Operators with Popup

```vim
" Define text transformation functions
let g:operatorify_list = [
    \ 'ToUpper',
    \ 'ToLower',
    \ 'Capitalize',
    \ 'CamelCase',
    \ 'SnakeCase'
    \ ]

" Map to gz
call Operatorify#Mapper('gz', 'Operatorify#Lister')
```

## License

Distributed under the same terms as Vim itself. See `:help license`.
