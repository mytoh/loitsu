
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
    (maali rgb-colours))

  (define ansi-colours
    '((black   0)
      (red     1)
      (green   2)
      (yellow  3)
      (blue    4)
      (magenta 5)
      (cyan    6)
      (white   7)
      (default 9)
      ))

  (define ansi-effects
    '((reset 0) (nothing 0)
                (bright 1) (bold    1)
                (faint          2)
                (italic         3)
                (underline      4)
                (blink           5)  (slow_blink        5)
                (rapid_blink    6)
                (inverse         7)  (swap              7)
                (conceal         8)  (hide              9)
                (default_font   10)
                (font0   10) (font1   11) (font2   12) (font3   13) (font4   14)
                (font5   15) (font6   16) (font7   17) (font8   18) (font9   19)
                (fraktur        20)
                (bright_off      21) (bold_off          21) (double_underline   21)
                (clean          22)
                (italic_off      23) (fraktur_off       23)
                (underline_off  24)
                (blink_off      25)
                (inverse_off     26) (positive          26)
                (conceal_off     27) (show              27) (reveal             27)
                (crossed_off     29) (crossed_out_off   29)
                (frame          51)
                (encircle       52)
                (overline       53)
                (frame_off       54) (encircle_off      54)
                (overline_off   55)
                ))

  (define ansi-colours-foreground
    '((black    30)
      (red      31)
      (green    32)
      (yellow   33)
      (blue     34)
      (magenta  35)
      (cyan     36)
      (white    37)
      (default  39)
      ))

  (define ansi-colours-background
    '((black    40)
      (red      41)
      (green    42)
      (yellow   43)
      (blue     44)
      (magenta  45)
      (cyan     46)
      (white    47)
      (default  49)
      ))

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
