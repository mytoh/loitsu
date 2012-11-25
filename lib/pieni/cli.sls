
(library (pieni cli)
  (export
    runner)
  (import
    (scheme base)
    (scheme write)
    (srfi :8 receive)
    (srfi :37 args-fold)
    (loitsu file)
    (loitsu process)
    (pieni check))

  (begin

    (define option-format
      (option '(#\f "format") #t #f
                    (lambda (opt name arg report)
                      (values arg))))

    (define (runner args)
      (receive (report)
        (args-fold (cdr args)
                   (list option-format)
                   (lambda (opt name arg . seeds)  ; unrecognized
                     (error name (string-append "unrecognized optino:" name)))
                   (lambda (operand report ) ;operand
                     report)
                   'default ; default value of report style
                   )
    (for-each
      (lambda (f)
        (display (string-append "test file " f))
        (newline)
        (display (run-command (list 'nmosh f))))
      (directory-list-rec "test"))

        ))


    ))
