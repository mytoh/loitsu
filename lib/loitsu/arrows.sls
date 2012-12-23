
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
    )

  (begin


    (define-syntax -<>
      ; (-<> <> 3 (+ 3) (* 99))
      (syntax-rules ()
        ((_ var x form ...)
         (let ((var x))
           (-> var form ...)))))

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
