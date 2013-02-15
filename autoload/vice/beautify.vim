func! vice#beautify#CssBeautify()
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
