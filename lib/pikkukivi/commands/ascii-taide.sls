
(library (pikkukivi commands ascii-taide)
  (export
    ascii-taide)
  (import
    (rnrs)
    (only (mosh)
          read-line)
    (loitsu file))

  (begin

    (define ascii-directory
      (build-path (home-directory) ".aa"))

    (define (file-is-aa? name)
      (if (string=? "aa" (path-extension name))
        #t
        #f))

    (define (display-aa-file file)
      (call-with-input-file
        file
        (lambda (in)
          (let loop ((line (read-line in)))
            (cond
              ((eof-object? line)
               "")
              (else
                (display line)
                (newline)
                (loop (read-line in))))))))

    (define (ascii-taide args)
      (let ((files (cddr args)))
        (for-each
          display-aa-file
          (map (lambda (f)
                 (find-file-in-paths (path-swap-extension f "aa")
                                     (list ascii-directory)))
               files))))

    ))

