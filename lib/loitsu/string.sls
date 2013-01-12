
(library (loitsu string)
  (export
    string-split
    str
    split-words
    underscore
    dasherize
    pluralize
    x->string
    conc)
  (import
    (silta base)
    (only (srfi :13 strings)
          string-downcase
          string-join)
    (srfi :48 intermediate-format-strings)
    (irregex)
    (loitsu control)
    (loitsu string compat))

  (begin

    (define (x->string obj)
      (cond
        ((string? obj) obj)
        ((number? obj) (number->string obj))
        ((symbol? obj) (symbol->string obj))
        ((char?   obj) (string obj))
        (else          (format "~a" obj))))

    (define (str . rest)
      (string-join (map x->string rest)
                   ""))

    (define (split-words s)
      "function from github.com/magnars/s.el"
      (string-split
        (underscore->space
          (dash->space
            (irregex-replace/all "([a-z])([A-Z])" s
                                 (lambda (m)
                                   (string-append (irregex-match-substring m 1)
                                                  " "
                                                  (irregex-match-substring m 2))))))
        #\ ))

    (define (dash->space s)
      (irregex-replace/all "-" s " "))

    (define (underscore->space s)
      (irregex-replace/all "_" s " "))


    (define (underscore s)
      "function from github.com/flatland/useful"
      (string-join
        (map (lambda (word)
               (string-downcase word))
             (split-words s))
        "_"))

    (define (dasherize s)
      "function from github.com/flatland/useful"
      (string-join
        (map (lambda (word)
               (string-downcase word))
             (split-words s))
        "-"))

    (define (pluralize num singular . args)
      (let-optionals* args
                      ((plural #f))
                      (str num " "
                           (if (= 1 num)
                             singular
                             (or plural
                               (string-append singular "s"))))))


    (define (conc . args)
      ;; from chicken scheme
      (apply string-append (map x->string args)))

    ))

