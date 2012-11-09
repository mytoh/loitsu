
(library (loitsu port)
  (export
    port->list
    port->string-list)
  (import
    (scheme base))

  (begin

    (define (port->string-list port)
      (port->list read-line port)
      )

    (define (port->list reader port)
      (let loop ((res '()))
        (let ((l (reader port)))
          (if (eof-object? l)
            res
            (cons l (loop res))))))

    ))

