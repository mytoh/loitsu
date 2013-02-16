
(library (loitsu port)
    (export
      port->list
      port->sexp-list
      port->string-list)
  (import
    (rnrs)
    (only (mosh)
          read-line))

  (begin

    (define (port->string-list port)
      (port->list read-line port))

    (define (port->sexp-list port)
      (port->list read port))

    (define (port->list reader port)
      (let loop ((res '()))
        (let ((l (reader port)))
          (if (eof-object? l)
            res
            (cons l (loop res))))))

    ))
