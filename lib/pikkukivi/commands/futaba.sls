
(library (pikkukivi commands futaba)
  (export
    futaba)
  (import
    (rnrs)
    (irregex)
    (match)
    (only (srfi :1)
          delete-duplicates
          last)
    (loitsu file)
    (kirjain)
    (surl))

  (begin

    (define (extract-file-name uri)
      (last (irregex-split "/" uri))
      )

    (define (fetch uri)
      (let ((file (extract-file-name uri)))
        (unless (file-exists? file)
          (surl uri file))))

    (define (find-server board thread)
      (match board
        ("b"
         (let ((get (lambda (s b t)
                      (if (not (null? (surl (string-append "http://" s ".2chan.net/"
                                                           board "/res/"
                                                           thread ".htm"))))
                        s #f))))
           (or (get "jun" board thread)
               (get "may" board thread)
               (get "dec" board thread))))))

    (define (make-url board thread)
      (string-append "http://" (find-server board thread) ".2chan.net/" board "/res/"
                     thread ".htm"))

    (define (get-image-url/thread board thread)
      (let ((image-regexp `(: "http://" (+ alphabetic) ".2chan.net/" (+ alphabetic) "/"
                              ,board "/src/" (+ (~ #\")))))
        (map (lambda (m) (irregex-match-substring m 0))
             (irregex-fold image-regexp
                           (lambda (i m s) (cons m s))
                           '()
                           (bytevector->string (surl (make-url board thread))
                                               (make-transcoder (latin-1-codec)))))))

    (define (setup-path thread)
      (if (not (file-exists? thread))
        (make-directory* thread)))

    (define (futaba args)
      (let ((board (caddr args))
            (thread (cadddr args)))
        (setup-path thread)
        (set-current-directory! thread)
        (map
          (lambda (u)
            (display (fetch u)))
          (delete-duplicates
            (get-image-url/thread board thread))) ))

    ))
