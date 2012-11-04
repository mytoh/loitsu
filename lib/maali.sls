
(library (maali)
  (export paint
    pa
    unpaint)
  (import
    (rnrs)
    (only (srfi :13)
      string-trim)
    (irregex)
    (match)
    (maali colours)
    (maali rgb-colours))

  (define (rgb-value red green blue)
    ;; receive three numbers and
    ;; return string like ";5;120"
    (if (if-gray-possible red green blue)
      (string-append
        ";5;"
        (number->string
          (+ 232
             (exact (floor (/ (+ red green blue) 33))))))
      ; ";5;#{ 232 + ((red.to_f + green.to_f + blue.to_f)/33).round }"
      (string-append
        ";5;"
        (number->string
          (+ 16
             (* (exact (floor (* 6 (/ red 256)))) 36)
             (* (exact (floor (* 6 (/ green 256)))) 6)
             (* (exact (floor (* 6 (/ blue 256)))) 1))))))

  (define (if-gray-possible red green blue)
    (let loop ((sep 42.5)
               (cnt 1))
      (cond
        ((or (< red (* sep cnt))
           (< green (* sep cnt))
           (< blue  (* sep cnt)))
         (and (< red (* sep cnt))
           (< green (* sep cnt))
           (< blue (* sep))))
        ((< cnt 6)
         (loop sep (+ cnt 1)))
        ((< 6 cnt)
         #t))))


  (define (escape s)
    (string-append "[" s))

  (define (reset)
    (wrap (escape "0")))

  (define (wrap str)
    (escape (string-append  str "m")))

  (define (colour-simple-number str)
    (string-append "38;5;" (number->string str)))

  (define (colour-rgb r g b)
    (string-append
      "38"
      (rgb-value r g b)))

  (define (colour-hex colour)
    (let ((s (string-trim colour #\#)))
      (cond
        ((= (string-length s) 6)
         (colour-rgb (string->number (substring s 0 2) 16)
                     (string->number (substring s 2 4) 16)
                     (string->number (substring s 4 6) 16)))
        ((= (string-length s) 3)
         (colour-hex (duplicate-string s))))))

  (define (duplicate-string s)
    (list->string
      (fold-left
        (lambda (c r)
          (append (list c c) r))
        '() (string->list s))))


  (define (symbol-colour-foreground lyst colour)
    (number->string (cadr (assoc colour lyst))))

  (define (colour-symbol colour)
    (let ((c (symbol-colour-foreground ansi-colours-foreground colour)))
      (cond
        (c c))))

  (define (colour-rgb-name name)
    (let* ((cols (cadr (assoc (string->symbol name) rgb-colours)))
           (r (car cols))
           (g (cadr cols))
           (b (caddr cols)))
      (colour-rgb r g b)))

  (define (make-colour lst)
    (map (lambda (str)
           (match str
             ((r g b)
              (colour-rgb r g b))
             ((? string? s)
              (cond
                ((irregex-match (irregex "^#?(?:[a-zA-Z0-9]{3}){1,2}$" ) s)
                 (colour-hex s))
                (else
                  (colour-rgb-name s))))
             ((? number? s)
              (colour-simple-number s))
             (colour
               (colour-symbol colour))))
         lst))

  (define (paint s . rest)
    (string-append
      (wrap (apply string-append  (make-colour rest)))
      s (reset)))

  (define (pa x . rest)
    (display (apply paint x rest))
    (newline)
    x)


  ; (define (unpaint s)
  ;   (irregex-replace/all '(: "[" (* (+ numeric ) ";" ) (+ numeric) "m") s "" ))

  ; ; "\[((\d)+\;)*(\d)+m"

  )
