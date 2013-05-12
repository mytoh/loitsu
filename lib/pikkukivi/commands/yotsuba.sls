(library (pikkukivi commands yotsuba)
    (export
      yotsuba)
  (import
    (rnrs)
    (loitsu irregex)
    (only (srfi :1)
          delete-duplicates
          last)
    (srfi :8 receive)
    (only (srfi :13 strings)
          string-every)
    (srfi :14 char-sets)
    (srfi :26 cut)
    (srfi :39 parameters)
    (srfi :37 args-fold)
    (only (mosh concurrent)
          sleep)
    (loitsu match)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (maali)
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
            (match->url (lambda (m)
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
         (newline))
        (else
            (display (string-append thread "'s gone"))
          (newline))))

    (define (string-number? s)
      (string-every char-set:digit s))

    (define (yotsuba-get-all-thread board)
      (for-each (lambda (t) (yotsuba-get-one-thread board t))
        (filter (lambda (d) (string-number? d)) (directory-list2 (current-directory)))))


    (define (repeat f . args)
      (let loop ()
           (let ((wait (* (* 60 (* 6 1000)) 5)))
             (apply f args)
             (sleep 10000)
             (loop))))

    (define option-repeat
      (option
          '(#\r "repeat") #f #t
          (lambda (option name arg repeat all)
            (values #t all))))

    (define option-all
      (option
          '(#\a "all") #f #t
          (lambda (option name arg repeat all)
            (values repeat #t))))

    (define (yotsuba args)
      (let ((args (cddr args)))
        (receive (repeat? all?)
                 (args-fold args
                   (list option-repeat option-all)
                   (lambda (option name arg . seeds) ; unrecognized
                     (error "Unrecognized option:" name))
                   (lambda (operand repeat all)        ; operand
                     (values repeat all))
                   #f                              ; default value of repeat?
                   #f                             ; default value of all?
                   )
                 (cond (repeat?
                        (match (cdr args)
                          ((board)
                           (repeat yotsuba-get-all-thread board))
                          ((board thread)
                           (repeat yotsuba-get-one-thread board thread))))
                       (else
                           (match args
                             ((board)
                              (yotsuba-get-all-thread board))
                             ((board thread)
                              (yotsuba-get-one-thread board thread))))))))

    ))
