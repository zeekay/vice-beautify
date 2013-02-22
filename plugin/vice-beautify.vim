if !exists('g:vice.beautify')
    let g:vice.beautify = {}
endif

if !exists('g:vice.beautify.loaded') || &cp
    let g:vice.beautify.loaded = 1
else
    finish
endif

let addon_dir = expand('<sfile>:p:h:h')
let &rtp.=','.addon_dir

call vice#Extend({
    \ 'ft_addons': {
        \ 'javascript\|css\|html\|xhtml\|xml': [
            \ 'github:zeekay/vim-jsbeautify',
            \ 'github:zeekay/js-beautify',
        \ ]
    \ }
\ })

let g:jsbeautify_file = g:vice.addons_dir.'/js-beautify/beautify.js'
let g:htmlbeautify_file = g:vice.addons_dir.'/js-beautify/beautify-html.js'
let g:cssbeautify_file = g:vice.addons_dir.'/js-beautify/beautify-css.js'
let g:jsbeautify = {'indent_size': 2, 'indent_char': ' ', 'max_preserve_newlines': 2, 'unescape_strings': 1, 'keep_array_indentation': 1}
let g:htmlbeautify = {'indent_size': 2, 'indent_char': ' ', 'max_char': 78, 'brace_style': 'expand', 'unformatted': ['a', 'sub', 'sup', 'b', 'i', 'u']}
let g:cssbeautify = {'indent_size': 2, 'indent_char': ' '}

au FileType javascript     command! -buffer Beautify call vice#beautify#JsBeautify()
au FileType css            command! -buffer Beautify call vice#beautify#CssBeautify()
au FileType xml,xhtml,html command! -buffer Beautify call vice#beautify#HtmlBeautify()
au FileType json           command! -buffer Beautify call vice#beautify#JsonBeautify()
