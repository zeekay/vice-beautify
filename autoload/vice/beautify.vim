func! vice#beautify#stdin_to_file(cmd, temp_file)
    exe 'w '.a:temp_file
    silent exe a:cmd
    silent redraw!
    normal G$dgg
    exe '0r '.a:temp_file
endf

func! vice#beautify#HTMLTidy()
    if !executable('tidy')
        echoerr 'Please install html-tidy: https://github.com/w3c/tidy-html5'
        return
    endif

    let args = [
        \ '-wrap 0',
        \ '--preserve-entities true',
        \ '--show-warnings false',
        \ '--fix-uri false',
        \ '--char-encoding utf8',
        \ '--input-encoding utf8',
        \ '--output-encoding utf8',
        \ '--ascii-chars true',
        \ '--fix-uri false',
        \ '--quote-ampersand false',
        \ '--vertical-space no',
        \ '--hide-comments false',
        \ '--doctype auto',
        \ '--tidy-mark false',
    \ ]

    " Simple heuristic to decide whether to show body or not. There is a
    " show-body-only auto setting, but it doesn't work very well.
    if match(getline(1,10), '<html') == -1
        call add(args, '--show-body-only true')
    endif

    silent! exe '%!tidy -q -i '.join(args, ' ')
    redraw!
endf

func! vice#beautify#JavaScript()
    if !executable('js-beautify')
        echoerr 'Please install js-beautify (github.com/beautify-web/js-beautify): pip install jsbeautifier'
        return
    endif

    exe '%!js-beautify -k -x --brace-style=collapse --indent-size='.&shiftwidth.' -i'
endf

func! vice#beautify#CSS()
    if !executable('css-beautify')
        echoerr 'Please install js-beautify (github.com/beautify-web/js-beautify), which provides css-beautify: npm install -g js-beautify'
        return
    endif

    exe '%!css-beautify --indent-size='.&shiftwidth.' -f -'
endf

func! vice#beautify#HTML()
    if !executable('html-beautify')
        echoerr 'Please install js-beautify (github.com/beautify-web/js-beautify), which provides html-beautify: pip install jsbeautifier'
        return
    endif

    exe '%!html-beautify -f -'
endf

func! vice#beautify#JSON()
    call vice#beautify#PythonJSON()
endf

func! vice#beautify#PythonJSON()
    silent %!python -m json.tool
endf

func! vice#beautify#UglifyJS2()
    normal gg
    normal iv=
    silent %!uglifyjs2 -b indent-level=2,quote-keys=true
    normal 4x
    normal Gdd$x
    normal gg
endf

func! vice#beautify#Astyle()
    if !executable('astyle')
        if has('mac') && executable('brew')
            exe '!brew install astyle'
        else
            echoerr 'astyle must be installed to beautify: http://astyle.sourceforge.net'
            return
        endif
    endif

    let temp_file = tempname()
    let cmd = '!astyle -k1 -p -F -C -N -Y -U -H -xe -xy -q --indent=spaces -c --style=kr '.temp_file
    call vice#beautify#stdin_to_file(cmd, temp_file)
endf

func! vice#beautify#Python()
    if !executable('autopep8') || !executable('docformatter')
        if executable('pip')
            exe '!pip install autopep8'
            exe '!pip install docformatter'
        else
            echoerr 'autopep8 and docformatter must be installed to use vice#beautify#Python'
            return
        endif
    endif

    silent exe '%!autopep8 --aggressive --aggressive -'
    silent exe '%!docformatter --no-blank --pre-summary-newline -'
    silent redraw!
endf

func! vice#beautify#Go()
    if !executable('gofmt')
        echerr 'Unable to beautify, please install gofmt!'
        return
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
