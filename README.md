# vim-operatorify

A powerful utility that turns Vim functions into operators with minimal effort.

## Features

- Turn any function that accepts text into a Vim operator
- Automatically handles dot-repeat
- Works with motions and visual selections
- Provides utilities for quick operator mapping
- Optional popup menu to manage multiple operators

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

#### Manual Method

```vim
" Create mappings
nnoremap <expr> <Plug>MyFunction operatorify#wrapper('MyFunction')
xnoremap <expr> <Plug>MyFunction operatorify#wrapper('MyFunction')
nnoremap <expr> <Plug>MyFunctionLine operatorify#wrapper('MyFunction') .. '_'

" Map to keys
nmap go  <Plug>MyFunction
xmap go  <Plug>MyFunction
nmap goo <Plug>MyFunctionLine
```

#### Using the Mapper Helper

```vim
" Does the same as above in one line
call operatorify#mapper('go', 'MyFunction')
```

The mapper follows the convention that repeating the last character of the key creates a line operator. For example:
- `go` operates on a motion
- `goo` operates on the current line
- `go` in visual mode operates on the selection

### Using the Popup List

You can manage multiple operators through a popup menu:

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

" Map the lister to a key
nnoremap <leader>o :call operatorify#lister()<CR>
```

## Configuration

### Popup List Options

You can customize the appearance and behavior of the popup menu:

```vim
let g:operatorify_list_options = {
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

## Installation

### Using vim-plug

```vim
Plug 'iggredible/vim-operatorify'
```

### Using pathogen

```bash
cd ~/.vim/bundle
git clone https://github.com/iggredible/vim-operatorify.git
```

### Manual Installation

Copy the contents of each directory in the plugin into the corresponding directories in your `~/.vim` directory.

## Documentation

Detailed documentation is available in Vim:
```vim
:help operatorify
```

## Examples

### Creating a Case-Changing Operator

```vim
function! ToggleCase(text)
    return a:text =~# '\u' ? tolower(a:text) : toupper(a:text)
endfunction

call operatorify#mapper('gt', 'ToggleCase')

" Now you can use:
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

" Map popup trigger
nnoremap <leader>o :call operatorify#lister()<CR>
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Distributed under the same terms as Vim itself. See `:help license`.
