" Prevent loading twice
if exists('g:loaded_operatorify')
  finish
endif
let g:loaded_operatorify = 1

if exists('g:operatorify_no_mappings')
  finish
endif
call Operatorify#Mapper('gl', 'Operatorify#Lister')
