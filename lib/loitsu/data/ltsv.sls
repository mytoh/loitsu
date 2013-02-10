
(library (loitsu data ltsv )
    (export
      parse-line
      parse-file)
  (import
    (silta base)
    (loitsu string)
    (loitsu file)
    (only (srfi :1)
          remove)
    (only (srfi :13)
          string-join))

  (begin

    (define (parse-line s)
      (let ((untabbed (map split-tab (split-newline s))))
        (map
         (lambda (s)
           (let loop ((s s))
             (cond
              ((null? s)
               '())
              (else
               (cons (split-colon (car s))
                     (loop (cdr s)))))))
         untabbed)))

    (define (parse-file file)
      (let ((s  (file->string file)))
        (parse-line s)))

    (define (split-newline st)
      (remove
       (lambda (s)
         (equal? s ""))
       (string-split st #\newline)))

    (define (split-tab st)
      (string-split st #\tab))

    (define (split-colon st)
      (let ((s (string-split st #\:)))
        (cons (car s) (cadr s))))


    ))
