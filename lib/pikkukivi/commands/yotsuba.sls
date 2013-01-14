
(library (pikkukivi commands yotsuba)
  (export
    yotsuba)
  (import
    (rnrs)
    (irregex)
    (match)
    (only (srfi :1)
          delete-duplicates
          last)
    (srfi :26 cut)
    (srfi :39 parameters)
    (only (mosh concurrent)
          sleep)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (loitsu maali)
    (loitsu util)
    (surl))

  (begin

    (define (make-thread-url board thread)
      (string-append "http://boards.4chan.org/"
                     board "/res/" thread))

    (define (get-html board thread)
      (surl->utf8 (make-thread-url board thread)))

    (define (parse-image-url html)
      (let ((image-regexp '(: "//images.4chan.org/"
                              alphabetic
                              "/src/"
                              (+ numeric)
                              "."
                              (or "jpg" "gif" "png")))
            (match->url (lambda  (m)
                          (string-append "http:"
                                         (irregex-match-substring m)))))
        (delete-duplicates
          (map match->url
               (irregex-fold image-regexp
                             (lambda (i m s) (cons m s))
                             '()
                             html)))))

    (define (extract-file-name uri)
      (last (irregex-split "/" uri)))

    (define (fetch uri)
      (let ((file (extract-file-name uri)))
        (unless (file-exists? file)
          (surl uri file))))

    (define (setup-path number)
      (unless (file-exists? number)
        (make-directory* number)))

    (define (thread-exists? url)
      (not (equal? "" (surl url))))

    (define (yotsuba-get-one-thread board thread)
      (cond
        ((thread-exists? (make-thread-url board thread))
         (setup-path thread)
         (display thread)
         (let ((urls (parse-image-url (get-html board thread))))
           (with-cwd thread
                     (map fetch
                          urls)))
         (newline))))


    (define (yotsuba args)
      (let ((args (cddr args)))
        (match args
          ((board)
           (display board))
          ((board thread)
           (yotsuba-get-one-thread board thread)))))

    ))
