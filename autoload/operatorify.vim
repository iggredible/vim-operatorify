function! Operatorify#Wrapper(f = 'test_null_function', context = {}, type = '') abort
  if a:type == ''
    let context = #{
      \ dot_command: v:false,
      \ extend_block: '',
      \ virtualedit: [&l:virtualedit, &g:virtualedit],
      \ }
    let &operatorfunc = function('Operatorify#Wrapper', [a:f, context])
    set virtualedit=block
    return 'g@'
  endif

  let save = #{
    \ clipboard: &clipboard,
    \ selection: &selection,
    \ virtualedit: [&l:virtualedit, &g:virtualedit],
    \ register: getreginfo('"'),
    \ visual_marks: [getpos("'<"), getpos("'>")],
    \ }
  
  let orig_pos = getpos('.')

  try
    set clipboard= selection=inclusive virtualedit=
    let commands = #{
      \ line: "'[V']",
      \ char: "`[v`]",
      \ block: "`[\<C-V>`]",
      \ }[a:type]
    let [_, _, col, off] = getpos("']")
    if off != 0
      let vcol = getline("'[")->strpart(0, col + off)->strdisplaywidth()
      if vcol >= [line("'["), '$']->virtcol() - 1
        let a:context.extend_block = '$'
      else
        let a:context.extend_block = vcol .. '|'
      endif
    endif
    if a:context.extend_block != ''
      let commands ..= 'oO' .. a:context.extend_block
    endif

    let commands ..= 'y'
    
    execute 'silent noautocmd keepjumps normal! ' .. commands

    let regText = getreg('"')
    execute 'call function(a:f)(regText)'

    if a:type ==# 'line'
      call setpos('.', orig_pos)
    endif

  finally
    call setreg('"', save.register)
    call setpos("'<", save.visual_marks[0])
    call setpos("'>", save.visual_marks[1])
    let &clipboard = save.clipboard
    let &selection = save.selection
    let [&l:virtualedit, &g:virtualedit] = get(a:context.dot_command ? save : a:context, 'virtualedit')
    let a:context.dot_command = v:true
  endtry
endfunction

function! Operatorify#Mapper(key, funcname, wrapper = 'Operatorify#Wrapper') abort
  let l:plug = '<Plug>' . a:funcname
  let l:expr = a:wrapper . '("' . a:funcname . '")'
  let l:last_char = a:key[strlen(a:key)-1]

  execute 'nnoremap <expr> ' . l:plug . ' ' . l:expr
  execute 'xnoremap <expr> ' . l:plug . ' ' . l:expr
  execute 'nnoremap <expr> ' . l:plug . 'Line ' . l:expr . ' .. "_"'

  " If key is 'gs', then line operator is gss
  " If key is 'go', then line operator is goo
  " If key is 'z', then line operator is zz
  execute 'nnoremap ' . a:key . ' ' . l:plug
  execute 'xnoremap ' . a:key . ' ' . l:plug
  execute 'nnoremap ' . a:key . l:last_char . ' ' . l:plug . 'Line'
endfunction

function! Operatorify#Lister(text = '')
  let l:list = get(g:, 'operatorify_list', [])

  function! PopupCallback(id, result) closure
    if a:result != -1
      let funcname = l:list[a:result-1]
      execute 'call ' .. funcname .. '(' .. string(a:text) .. ')'
    endif
  endfunction

  let cursor_pos = screenpos(win_getid(), line('.'), col('.'))
  let screen_row = cursor_pos.row
  let screen_col = cursor_pos.col
  let total_height = &lines
  let space_below = total_height - screen_row
  let needed_height = len(l:list)

  let options = get(g:, 'operatorify_options', {
        \ 'callback': 'PopupCallback',
        \ 'border': [],
        \ 'padding': [0,1,0,1],
        \ 'pos': 'topleft',
        \ 'moved': [0, 0, 0],
        \ 'scrollbar': 0,
        \ 'fixed': 1
        \ })

  if space_below < needed_height
    let options.line = cursor_pos.row - needed_height
    let options.pos = 'botleft'
  else
    let options.line = screen_row + 1
  endif

  let options.col = screen_col
  let winid = popup_menu(l:list, options)
endfunction
