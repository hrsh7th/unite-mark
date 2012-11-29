let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#mark#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'mark',
      \ }

function! s:source.gather_candidates(args, context)
  let a:context.source__marks = map(readfile(g:unite_source_mark_path), 's:create_mark(v:val)')
  let a:context.source__marks = filter(a:context.source__marks, '!empty(v:val)')

  let pad = max(map(deepcopy(a:context.source__marks), "strlen(fnamemodify(v:val.path, ':t') . '(' . v:val.lnum . ')')"))
  return map(a:context.source__marks, "{
        \   'word': s:padding(fnamemodify(v:val.path, ':t') . '(' . v:val.lnum . ')', pad) . ' | ' . v:val.description,
        \   'kind': 'mark',
        \   'action__mark': v:val,
        \   'action__path': v:val.path,
        \   'action__line': v:val.lnum,
        \ }")
endfunction

function! s:create_mark(line)
  try
    let [path, lnum, col, description] = split(a:line, "\t")
  catch
    return {}
  endtry
  return {
        \ 'line': a:line,
        \ 'path': path,
        \ 'lnum': lnum,
        \ 'col': col,
        \ 'description': description,
        \ }
endfunction

function! s:padding(word, num)
  let word = a:word . repeat(' ', a:num)
  return word[0:a:num]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
