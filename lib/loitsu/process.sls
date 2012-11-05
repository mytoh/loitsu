
(library (loitsu process)
  (export process-output->string
    with-cwd)
  (import
    (scheme base)
    (except (mosh)
      read-line)  
    (mosh process))


  (define (process-output->string cmd)
    (let-values (((cout status x) (call-process cmd)))
      cout))

(define-syntax with-cwd
  (syntax-rules ()
  ((_ dir body)
  (let ((cur (current-directory))
         (dest dir))
     (set-current-directory! dest)
     body
     (set-current-directory! cur)))))


  )
