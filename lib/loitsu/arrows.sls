
(library (loitsu arrows)
  (export
    -<
    -<<
    -<>
    -<>>
    )
  (import
    (rnrs)
    (loitsu control)
    (loitsu util)
    )

  (begin


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
      ; (-<>> <> 3 (+ 3) (* 99))
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
