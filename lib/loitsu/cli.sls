
(library (loitsu cli)
  (export
    puts
    match-short-command
    find-short-command)
  (import
    (rnrs)
    (irregex))

  (begin

    (define (find-short-command short cmd)
      (let ((command-re `(: ,short (* ascii))))
        (irregex-match command-re cmd)))

    (define-syntax match-short-command
      (syntax-rules ()
        ((_ short (command expr))
         (cond
           ((find-short-command short command)
            expr)
           (else
             (error "match-short-command" (string-append "no matching pattern for " short)))))
        ((_ short (command expr) (c2 e2)  ...)
         (cond
           ((find-short-command short command)
            expr)
           (else
             (match-short-command short (c2 e2) ...))))))

    (define (puts s)
      (display s)
      (newline)
      (values))

    ))
