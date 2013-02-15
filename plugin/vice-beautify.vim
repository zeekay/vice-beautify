call vice#Extend({
    \ 'ft_addons': {
        \ 'javascript\|css\|html\|xhtml\|xml': [
            \ 'github:zeekay/vim-jsbeautify',
            \ 'github:zeekay/js-beautify',
        \ ]
    \ }
\ })

let g:jsbeautify_file = $VIMHOME."/addons/js-beautify/beautify.js"
let g:htmlbeautify_file = $VIMHOME."/addons/js-beautify/beautify-html.js"
let g:cssbeautify_file = $VIMHOME."/addons/js-beautify/beautify-css.js"
let g:jsbeautify = {'indent_size': 2, 'indent_char': ' ', 'max_preserve_newlines': 2, 'unescape_strings': 1, 'keep_array_indentation': 1}
let g:htmlbeautify = {'indent_size': 2, 'indent_char': ' ', 'max_char': 78, 'brace_style': 'expand', 'unformatted': ['a', 'sub', 'sup', 'b', 'i', 'u']}
let g:cssbeautify = {'indent_size': 2, 'indent_char': ' '}

au FileType javascript command! Beautify -buffer call JsBeautify()
au FileType css command! Beautify -buffer call vice#beautify#CssBeautify()
au FileType xml,xhtml,html command! Beautify -buffer call HtmlBeautify()
au FileType json command! Beautify -buffer call vice#beautify#JsonBeautify()
