call vice#Extend({
    \ 'ft_addons': {
        \ 'javascript\|css\|html\|xhtml\|xml': [
            \ 'github:zeekay/vim-jsbeautify',
            \ 'github:zeekay/js-beautify',
        \ ]
    \ }
\ })

let g:jsbeautify_file   = g:vice.addons_dir.'/js-beautify/beautify.js'
let g:htmlbeautify_file = g:vice.addons_dir.'/js-beautify/beautify-html.js'
let g:cssbeautify_file  = g:vice.addons_dir.'/js-beautify/beautify-css.js'
let g:jsbeautify        = {'indent_size': 2, 'indent_char': ' ', 'max_preserve_newlines': 2, 'unescape_strings': 1, 'keep_array_indentation': 1}
let g:htmlbeautify      = {'indent_size': 2, 'indent_char': ' ', 'max_char': 78, 'brace_style': 'expand', 'unformatted': ['a', 'sub', 'sup', 'b', 'i', 'u']}
let g:cssbeautify       = {'indent_size': 2, 'indent_char': ' '}
let g:gofmt_command     = "gofmt"

au FileType javascript                command! -buffer Beautify call vice#beautify#JavaScript()
au FileType css                       command! -buffer Beautify call vice#beautify#CSS()
au FileType xml,xhtml,html,htmldjango command! -buffer Beautify call vice#beautify#HTML()
au FileType json                      command! -buffer Beautify call vice#beautify#JSON()
au FileType c,cpp,java                command! -buffer Beautify call vice#beautify#Astyle()
au FileType python                    command! -buffer Beautify call vice#beautify#Python()
au FileType go                        command! -buffer Beautify call vice#beautify#Go()
