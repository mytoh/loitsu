(library (pikkukivi commands uname)
    (export
      uname)
  (import
    (silta base)
    (silta write)
    (silta cxr)
    (only (srfi :13)
          string-tokenize)
    (loitsu match)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (maali)
    (loitsu util)
    (surl))

  (begin


    (define (uname-command option)
      (car (string-tokenize (run-command (append '("uname") (list option))))))

    (define (command)
      (let* ((os (paint (uname-command "-m") 174))
             (host (paint (uname-command "-n") 33))
             (release (paint (uname-command "-r") 94))
             (system (paint (uname-command "-s") 149))
             (delim (paint " | " 55)))
        (string-append
            os
          delim
          host
          delim
          release
          delim
          system
          delim)))

    (define (uname args)
      (display (command)))

    ))
