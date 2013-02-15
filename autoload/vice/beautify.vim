let s:initialized = 0

func! s:Initialize()
    if s:initialized == 1
        return
    endif

    let s:initialized = 1
    call vice#Extend({
        \ 'ft_addons': {
            \ 'javascript\|css\|html\|xhtml\|xml': [
                \ 'github:zeekay/vim-jsbeautify',
                \ 'github:zeekay/js-beautify',
            \ ]
        \ }
    \ })
endf

func! vice#beautify#HtmlBeautify()
    call s:Initialize()
    call HtmlBeautify()
endf

func! vice#beautify#JsBeautify()
    call s:Initialize()
    call JsBeautify()
endf

func! vice#beautify#CssBeautify()
    call s:Initialize()
    " Remove all leading indentation first, since js-beautify doesn't
    exe '%le'
    call CSSBeautify()
endf

func! vice#beautify#JsonBeautify()
    call s:Initialize()
    if executable('uglifyjs2')
        normal gg
        normal iv=
        silent %!uglifyjs2 -b indent-level=2,quote-keys=true
        normal 4x
        normal Gdd$x
        normal gg
    endif
    silent %!node -e "
        \ sys = require('sys');
        \ process.stdin.resume();
        \ process.stdin.setEncoding('utf8');
        \ data = '';
        \ process.stdin.on('data', function(chunk) {
        \   data += chunk;
        \ });
        \ process.stdin.on('end', function() {
        \   console.log(JSON.stringify(JSON.parse(data), null, 2));
        \ })"
endf
