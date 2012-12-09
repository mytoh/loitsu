

(library (pikkukivi commands tosixel)
  (export
    tosixel)
  (import
    (rnrs)
    (loitsu file)
    (loitsu process)
    )

  (begin

    (define (topnm-command file)
      (cond
        ((string=? "png" (path-extension file))
         'pngtopnm)
        ((string=? "jpg" (path-extension file))
         'jpgtopnm)))

    (define (tosixel args)
      (let ((file (caddr args)))
        (call-with-output-file
          (path-swap-extension file "sixel")
          (lambda (out)
            (display (run-command `(,(topnm-command file) ,file "|" pnmquant 256 "|" ppmtosixel))
                     out)))))


    ))
