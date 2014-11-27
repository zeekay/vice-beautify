let g:gofmt_command = 'gofmt'

au FileType javascript                command! -buffer Beautify call vice#beautify#JavaScript()
au FileType css                       command! -buffer Beautify call vice#beautify#CSS()
au FileType xml,xhtml,html,htmldjango command! -buffer Beautify call vice#beautify#HTML()
au FileType json                      command! -buffer Beautify call vice#beautify#JSON()
au FileType c,cpp,java                command! -buffer Beautify call vice#beautify#Astyle()
au FileType python                    command! -buffer Beautify call vice#beautify#Python()
au FileType go                        command! -buffer Beautify call vice#beautify#Go()
