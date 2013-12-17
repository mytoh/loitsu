
(library (loitsu arrows)
    (export
      ->
      ->>
      -?>
      ;; ->*
      ;; ->>*
      ;; -<
      ;; -<<
      -<>
      -<>>
      )
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

    (define-syntax -?>
      (syntax-rules ()
        ((_ x) x)
        ((_ x (proc args ...) expr ...)
         (if-let1 y (proc x args ...) (-?> y expr ...)))
        ((_ x proc expr ...)
         (if-let1 y (proc x) (-?> y expr ...) #f))))

    ;;; diamond

    (define-syntax -<>-helper
      (syntax-rules (<>)
        ((_ () x (acc ...))
         (-> x (acc ...))) ; (acc ...)
        ((_ (<> rest ...) x (acc ...))
         (acc ... x rest ...))
        ((_ (a rest ...) x (acc ...))
         (-<>-helper (rest ...) x (acc ... a)))
        ((_ form x ())
         (form x))))

    (define-syntax -<>
      (syntax-rules ()
        ((_ x) x)
        ((_ x form rest ...)
         (let ((r (-<>-helper form x ())))
           (-<> r rest ...)))))

    (define-syntax -<>>-helper
      (syntax-rules (<>)
        ((_ () x (acc ...))
         (->> x (acc ... ))) ; (acc ...)
        ((_ (<> rest ...) x (acc ...))
         (acc ... x rest ...))
        ((_ (a rest ...) x (acc ...))
         (-<>>-helper (rest ...) x (acc ... a)))
        ((_ form x ())
         (form x))))

    (define-syntax -<>>
      (syntax-rules ()
        ((_ x) x)
        ((_ x form rest ...)
         (let ((r (-<>>-helper form x ())))
           (-<>> r rest ...)))))

    ;; -?<>
    (define-syntax -?<>-helper
      (syntax-rules (<>)
        ((_ () x (acc ...))
         (-> x (acc ...))) ; (acc ...)
        ((_ (<> rest ...) x (acc ...))
         (acc ... x rest ...))
        ((_ (a rest ...) x (acc ...))
         (-?<>-helper (rest ...) x (acc ... a)))
        ((_ proc x ())
         (proc x))))

    (define-syntax -?<>
      (syntax-rules ()
        ((_ x) x)
        ((_ #f form rest ...)
         #f)
        ((_ x form rest ...)
         (let ((r (-?<>-helper form x ())))
           (-?<> r rest ...)))))


    ;;; http://practical-scheme.net/wiliki/wiliki.cgi?Gauche%3aClojure%3a->%2c->>
    (define-syntax =*>-helper
      (syntax-rules (<*>)
        ((_ () x (acc ...))
         (acc ...))
        ((_ (<*> rest ...) x (acc ...))
         (acc ... x rest ...))
        ((_ (a rest ...) x (acc ...))
         (=*>-helper (rest ...) x (acc ... a)))))

    (define-syntax =*>
      (syntax-rules ()
        ((_ x) x)
        ((_ x form rest ...)
         (let ((r (=*>-helper form x ())))
           (=*> r rest ...)))))
    ))
