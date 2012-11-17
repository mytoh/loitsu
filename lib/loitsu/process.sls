
(library (loitsu process)
  (export
    process-output->string
    run-command
    with-cwd)
  (import
    (scheme base)
    (only (srfi :13 strings)
          string-join)
    (except (mosh)
            read-line)
    (only (mosh process)
          call-process
          waitpid
          spawn pipe)
    (only (rnrs)
          transcoded-port make-transcoder
          utf-8-codec)
    (loitsu string)
    )

  (begin

    ; (define (process-output->string cmd)
    ;   (let-values (((cout status x) (call-process cmd)))
    ;     cout))

    (define (process-output->string cmd)
      (let ((commands (string-split cmd #\ )))
      ;; get output as string
      (let-values ([(in out) (pipe)])
        (define (port->string p)
          (let loop ([ret '()][c (read-char p)])
            (if (eof-object? c)
              (list->string (reverse ret))
              (loop (cons c ret) (read-char p)))))
        (let-values ([(pid cin cout cerr) (spawn (car commands) (cdr commands)  (list #f out out))])
          (close-port out)
          (let ((res (port->string (transcoded-port in (make-transcoder (utf-8-codec))))))
            (close-port in)
            (waitpid pid)
            res)))))

    (define-syntax with-cwd
      (syntax-rules ()
        ((_ dir body ...)
         (let ((cur (current-directory))
               (dest dir))
           (set-current-directory! dest)
           body
           ...
           (set-current-directory! cur)))))

    (define (run-command lst)
      (let ((command (string-join (map x->string lst))))
        (call-process command)))

    ))
