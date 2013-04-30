
(library (loitsu control)
    (export
      ;; doto
      let-optionals*)
  (import
    (silta base)
    (loitsu control compat))

  (begin

    ;; (define-syntax doto
    ;;   (syntax-rules ()
    ;;     ((_ x) x)
    ;;     ((_ x (fn args ...) expr ...)
    ;;      (let ((val x))
    ;;        (fn val args ...)
    ;;        ...
    ;;        val))))

    ))
