
(library (loitsu arrows)
    (export
      ->
      ->>
      ->*
      ->>*
      -<
      -<<
      -<>
      -<>>)
  (import
    (silta base)
    (loitsu control)
    (loitsu util))

  (begin


    (define-syntax ->
      (syntax-rules ()
        ((_ x) x)
        ((_ x (proc args ...) expr ...)
         (-> (proc x args ...) expr ...))
        ((_ x proc expr ...)
         (-> (proc x) expr ...))))


    (define-syntax ->>
      (syntax-rules ()
        ((_ x) x)
        ((_ x (proc args ...) expr ...)
         (->> (proc args ... x) expr ...))
        ((_ x proc expr ...)
         (->> (proc x) expr ...))))

    (define-syntax ->*
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y z ...) rest ...)
         (->* (receive args x
                       (apply y (append args (list z ...))))
              rest ...))))

    (define-syntax ->>*
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y z ...) rest ...)
         (->>* (receive args x
                        (apply y (append (list z ...) args)))
               rest ...))))

    (define-syntax -<>
      (syntax-rules ()
        ((_ x form ...)
         (let (('<> x))
           (-> var form ...)))))

    (define-syntax diamond?
      (syntax-rules ()
        ((_ form)
         (member '<> 'form))))

    (define-syntax -<>>
      ;; (-<>> <> 3 (+ 3) (* 99))
      (syntax-rules ()
        ((_ var x form ...)
         (let ((var x))
           (->> var form ...)))))

    (define-syntax -<
      (syntax-rules ()
        ((_ form branch)
         (let ((result form))
           (list (-> result branch))))
        ((_ form branch ...)
         (let ((result form))
           (list (-> result branch)
             ...)))))

    (define-syntax -<<
      (syntax-rules ()
        ((_ form branch)
         (let ((result form))
           (list (->> result branch))))
        ((_ form branch ...)
         (let ((result form))
           (list (->> result branch)
             ...)))))


    (define-syntax -<><
      (syntax-rules ()
        ((_ form branch)
         (let ((result form))
           (list (-<> <> result branch))))
        ((_ form branch ...)
         (let ((result form))
           (list (-<> <> result branch)
             ...)))))
    ))
