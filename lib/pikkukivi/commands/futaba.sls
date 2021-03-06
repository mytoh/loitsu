;;; futab.sls --- futaba image get script

;;; Code:

;;; library declare
(library (pikkukivi commands futaba)
    (export
      futaba)
  (import
    (silta base)
    (silta write)
    (silta file)
    (only (srfi :1 lists)
          delete-duplicates
          last)
    (srfi :26 cut)
    ;;    (srfi :39 parameters)
    (only (mosh concurrent)
          sleep)
    (loitsu irregex)
    (loitsu match)
    (loitsu lamb)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (maali)
    (loitsu util)
    (surl))

  (begin

    (define (extract-file-name uri)
      (last (irregex-split "/" uri)))

    (define (fetch uri)
      (let* ((file (extract-file-name uri))
             (tmp (temp-name file)))
        (unless (file-exists? file)
          (when (file-exists? tmp)
            (remove-file tmp))
          (surl uri tmp)
          (rename-file tmp file))))

    (define (temp-name orig)
      (let ((ext "!tmp"))
        (path-add-extension orig ext)))


    (define (find-server board thread)
      (let ((get (lambda (s)
                   (let ((res (bytevector-length (surl (string-append "http://" s ".2chan.net/"
                                                                      board "/res/"
                                                                      thread ".htm")))))
                     (cond
                       ((not (number? res)) #f)
                       ((and (number? res)
                          (zero? res))
                        #f)
                       (else s))))))
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
            (map (cut irregex-match-substring <> 0)
              (irregex-fold image-regexp
                            (lambda (i m s) (cons m s))
                            '()
                            (get-thread-html board thread))))))

    (define (get-thread-html board thread)
      (surl->utf8 (make-url board thread)))

    (define (save-html thread str)
      (let ((file (build-path thread (path-swap-extension thread "html"))))
        (if (file-exists? file)
          (remove-file file))
        (call-with-output-file file
          (lambda (out)
            (display str out)))))

    (define (setup-path thread)
      (unless (file-exists? thread)
        (make-directory* thread)))

    (define (valid-thread-number? num)
      (number? (string->number num)))

    (define (repeat f)
      (lambda args
        (let ((wait (* (* 60 (* 6 1000)) 1)))
          (let loop ()
               (apply f args)
               ;; (sleep wait)
               (loop)))))

    (define (force-loop body)
      (guard (e (else
                    (display "error, go back loop")
                  (newline)
                  (force-loop body)))
        (body)))

    (define *deleted-thread*
      (make-parameter '()))

    (define (update-deleted-thread thread)
      (if (not (memq thread (*deleted-thread*)))
        (*deleted-thread* (cons thread (*deleted-thread*)))))

    ;;; get functions
    ;; get one thread
    (define (futaba-get-one-thread board thread)
      (cond
        ((and (not (member thread (*deleted-thread*)))
           (valid-thread-number? thread))
         (cond
           ((thread-exists? board thread)
            (puts (paint thread 173))
            (let ((res (get-thread-html board thread)))
              (unless (string=? "" res)
                (setup-path thread)
                (save-html thread res)
                (with-cwd
                 thread
                 (map fetch
                   (get-image-url/thread board thread))))))
           (else
               (update-deleted-thread thread))))))
    ;;; all thread
    (define (futaba-get-all-thread board)
      (let ((threads (directory-list2 (current-directory))))
        (for-each
            (cut futaba-get-one-thread board <>)
          threads)
        (puts (paint "-----------------------------" 29))))

    (define-case futaba-get
      ((board) (force-loop ((repeat futaba-get-all-thread) board)))
      ((board thread) (futaba-get-one-thread board thread)))


    ;;; main
    (define (futaba args)
      (let ((args (cddr args)))
        (match args
          ((board)
           (futaba-get board))
          ((board thread)
           (futaba-get board thread)))))

    ))
