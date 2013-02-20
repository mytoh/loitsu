
;; create-directory function from gauche

(library (loitsu file create-directory)
    (export
      collect-options
      ;;create-directory-tree
      )
  (import
    (silta base)
    (loitsu match)
    (loitsu lamb)
    (only (srfi :1)
          cons*)
    (srfi :8)
    (only (srfi :13 strings)
          string-join
          string-take-right
          string-trim-right
          )
    )

  (begin

    (define (collect-options args)
      (let loop ((args args)
                 (r '()))
        (match args
          (() (values (reverse r) #f))
          ;; (((? keyword? k) val . rest) (loop rest (cons* val k r)))
          ((arg) (values (reverse r) arg))
          (_ (error "invalid option list:" args)))))

    (define (name? x) (or (string? x) (symbol? x)))

    (define (mkpath dir name) (build-path dir dir (symbol->string name)))

    (define (ensure dir node) (walk dir node ensure-file ensure-dir))
    (define-case ensure-file
      ((path content mode owner group symlink)
       (if symlink
         (symlink path)))
      )


    (define (walk dir node do-file do-dir)
      (match node
        ((? name?) (do-file (mkpath dir node) #f))
        (((? name? n) . args)
         (receive (opts content) (collect-options args)
                  (if (list? content)
                    (apply do-dir (mkpath dir n) content opts)
                    (apply do-file (mkpath dir n) content opts))))
        (_ (error "invalid tree node:" node))))



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; utilities from loitsu.file.path
    (define-case build-path
      ((path) path)
      (paths (string-join
              (map (lambda (s)
                     (if (equal? "" s)
                       ""
                       (if (equal? "/" (string-take-right s 1))
                         (remove-trailing-slash s)
                         s)))
                paths)
              "/")))

    (define (remove-trailing-slash path)
      (string-trim-right path #\/))



    ))
