
(library (surl)
  (export surl)
  (import
    (rnrs)
    (irregex)
    (srfi :8)
    (http))

  (begin

    (define (string-is-url? str)
      (irregex-search
        "^https?://" str))


    (define (surl url . file)
      (let ((ofile (if (null? file)
                     #f (car file))))
        (receive (body . rest)
          (http-get url)
          (if ofile
            (call-with-port
              (open-file-output-port ofile)
              (lambda (out)
                (put-bytevector out body)))
            body))))

    ))
