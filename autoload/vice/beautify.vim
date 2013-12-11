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
    if executable('tidy')
        silent! exe '%!tidy -q -i --show-body-only true -wrap 0 --preserve-entities true --show-warnings false --fix-uri false --char-encoding utf8 --input-encoding utf8 --output-encoding utf8 --ascii-chars true --fix-uri false --quote-ampersand false'
        redraw!
    endif
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

func! vice#beautify#AstyleBeautify()
    if executable('astyle')
        let temp_file = tempname()
        exe 'w '.temp_file
        silent exe '!astyle -k1 -p -F -C -N -Y -U -H -xe -xy -q --indent=spaces -c --style=kr '.temp_file
        silent redraw!
        normal G$dgg
        exe '0r '.temp_file
    endif
endf
