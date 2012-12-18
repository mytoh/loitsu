
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
    (srfi :39 parameters)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (loitsu maali)
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
      (let ((get (lambda (s)
                   (if (= 0 (bytevector-length (surl (string-append "http://" s ".2chan.net/"
                                                                    board "/res/"
                                                                    thread ".htm"))))
                     #f  s))))
        (match board
          ("b"
           (or (get "jun")
               (get "may")
               (get "dec")))
          ("l" ;二次元壁紙
           (get  "dat" ))
          ("k" ;壁紙
           (get "cgi"))
          ("7" ;ゆり
           (get "zip"))
          ("40" ;東方
           (get "may"))
          ("id"
           (get "may")))))

    (define (thread-exists? board thread)
      (find-server board thread))

    (define (make-url board thread)
      (string-append "http://"  (find-server board thread) ".2chan.net/" board "/res/"
                     thread ".htm"))

    (define (get-image-url/thread  board thread)
      (let ((image-regexp `(: "http://" (+ alphabetic) ".2chan.net/" (+ alphabetic) "/"
                              ,board "/src/" (+ (~ #\")))))
        (delete-duplicates
          (map (lambda (m) (irregex-match-substring m 0))
               (irregex-fold image-regexp
                             (lambda (i m s) (cons m s))
                             '()
                             (bytevector->string (get-thread-html board thread)
                                                 (make-transcoder (latin-1-codec))))))))

    (define (get-thread-html board thread)
      (surl (make-url board thread)))

    (define (setup-path thread)
      (if (not (file-exists? thread))
        (make-directory* thread)))

    (define (valid-thread-number? num)
      (number? (string->number num)))

    (define (futaba-get-one-thread board thread)
      (cond
        ((and (not (member thread (deleted-thread)))
           (valid-thread-number? thread))
         (setup-path thread)
         (cond
           ((thread-exists? board thread)
            (puts thread)
            (let ((res (get-thread-html board thread)))
              (unless (= 0 (bytevector-length res))
                (with-cwd
                  thread
                  (map (lambda (u) (fetch u))
                       (get-image-url/thread board thread))))))
           (else
             (update-deleted-thread thread))))))

    (define (futaba-get-all-thread board)
      (let ((threads (directory-list2 (current-directory))))
        (for-each
          (lambda (t)
            (futaba-get-one-thread board t))
          threads)
        (puts (paint "-----------------------------" 29))))

    (define futaba-get
      (case-lambda
        ((board) ((repeat futaba-get-all-thread) board))
        ((board thread) (futaba-get-one-thread board thread))))

    (define (repeat f)
      (lambda args
        (let loop ()
          (apply f args)
          (loop))))


    (define deleted-thread
      (make-parameter '()))

    (define (update-deleted-thread thread)
      (if (not (memq thread (deleted-thread)))
        (deleted-thread (cons thread (deleted-thread)))))

    (define (futaba args)
      (let ((args (cddr args)))
        (match args
          ((board)
           (futaba-get board))
          ((board thread)
           (futaba-get board thread)))))

    ))
