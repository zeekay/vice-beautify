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

func! vice#beautify#HTML()
    if executable('tidy')
        silent! exe '%!tidy -q -i --show-body-only true -wrap 0 --preserve-entities true --show-warnings false --fix-uri false --char-encoding utf8 --input-encoding utf8 --output-encoding utf8 --ascii-chars true --fix-uri false --quote-ampersand false'
        redraw!
    endif
endf

func! vice#beautify#JavaScript()
    call s:Initialize()
    call JsBeautify()
endf

func! vice#beautify#CSS()
    call s:Initialize()
    " Remove all leading indentation first, since js-beautify doesn't
    exe '%le'
    call CSSBeautify()
endf

func! vice#beautify#JSON()
    if !executable('uglifyjs2')
        exe '!npm install -g uglify-js2'
    endif

    normal gg
    normal iv=
    silent %!uglifyjs2 -b indent-level=2,quote-keys=true
    normal 4x
    normal Gdd$x
    normal gg

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

func! vice#beautify#Astyle()
    if !executable('astyle')
        echoerr 'astyle must be installed to beautify'
    endif

    let temp_file = tempname()
    exe 'w '.temp_file
    silent exe '!astyle -k1 -p -F -C -N -Y -U -H -xe -xy -q --indent=spaces -c --style=kr '.temp_file
    silent redraw!
    normal G$dgg
    exe '0r '.temp_file
endf

func! vice#beautify#Python()
    if !executable('autopep8')
        exe '!pip install autopep8'
        exe '!pip install -e "git+https://github.com/zeekay/docformatter#egg=docformatter"'
    endif

    silent exe '%!autopep8 --aggressive --aggressive -'
    silent exe '%!docformatter --no-blank --pre-summary-newline -'
    silent redraw!
endf

func! vice#beautify#Go()
    if !executable('gofmt')
        echerr 'Unable to beautify, please install gofmt!'
    endif

    let view = winsaveview()

    " If spaces are used for indents, configure gofmt
    if &expandtab
        let tabs = ' -tabs=false -tabwidth=' . (&sw ? &sw : (&sts ? &sts : &ts))
    else
        let tabs = ''
    endif

    silent! execute "silent! %!" . g:gofmt_command . tabs
    redraw!

    if v:shell_error
        let errors = []
        for line in getline(1, line('$'))
            let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
            if !empty(tokens)
                call add(errors, {"filename": @%,
                                 \"lnum":     tokens[2],
                                 \"col":      tokens[3],
                                 \"text":     tokens[4]})
            endif
        endfor
        if empty(errors)
            % | " Couldn't detect gofmt error format, output errors
        endif
        undo
    endif
    call winrestview(view)
endf
