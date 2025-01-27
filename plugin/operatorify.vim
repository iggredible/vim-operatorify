" Prevent loading twice
if exists('g:loaded_operatorify')
  finish
endif
let g:loaded_operatorify = 1

" Set default values
if !exists('g:operatorify_list')
  let g:operatorify_list = []
endif

if !exists('g:operatorify_list_options')
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
endif

if exists('g:operatorify_no_mappings')
  finish
endif

" default mapping gl
call operatorify#mapper('gl', 'Lister')
