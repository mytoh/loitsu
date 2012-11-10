
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
    (mosh process)
    (loitsu string)
    )

  (begin

    (define (process-output->string cmd)
      (let-values (((cout status x) (call-process cmd)))
        cout))

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
