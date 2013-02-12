
(library (loitsu cli)
    (export
      puts
      puts-columns
      match-short-command
      find-short-command)
  (import
    (silta base)
    (silta write)
    (only (srfi :1)
          fold)
    (only (srfi :13)
          string-pad-right
          string-drop-right)
    (srfi :48)
    (loitsu process)
    (loitsu list)
    (loitsu irregex))

  (begin

    (define (find-short-command short cmd)
      (let ((command-re `(: ,short (* ascii))))
        (irregex-match command-re cmd)))

    (define-syntax match-short-command
      (syntax-rules ()
        ((_ short (command expr))
         (cond
          ((find-short-command short command)
           expr)
          (else
           (error "match-short-command" (string-append "no matching pattern for " short)))))
        ((_ short (command expr) (c2 e2)  ...)
         (cond
          ((find-short-command short command)
           expr)
          (else
           (match-short-command short (c2 e2) ...))))))

    (define (puts s)
      (display s)
      (newline)
      (values))

    (define (string-longest string-list)
      (fold (lambda (s r)
              (if (< r (string-length s))
                  (string-length s)
                  r))
            0 string-list))

    (define (remove-newline s)
      (string-drop-right s 1))


    (define (puts-columns items)
      (let* ((console-width (if (< 80 (string->number (remove-newline (process-output->string "tput cols" ))))
                                80 (string->number (remove-newline (process-output->string "tput cols")))))
             (longest (string-longest items))
             (optimal-col-width (exact (floor (inexact (/ console-width (+ longest 2))))))
             (cols (if (< 1 optimal-col-width ) optimal-col-width 1)))
        (let loop ((items items))
          (cond
           ((< (length items) cols)
            (for-each
             (lambda (s)
               (display
                (string-pad-right s (+ longest 2))))
             (take* items cols)))
           (else
            (for-each
             (lambda (s)
               (display
                (string-pad-right s (+ longest 2))))
             (take* items cols))
            (newline)
            (loop (drop* items cols)))))
        (newline)))

    ))
