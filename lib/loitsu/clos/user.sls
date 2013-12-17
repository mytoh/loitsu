(library (loitsu clos user)

    (export

      ;; classes

      <top>
      <object>

      ;; procedures

      slot-ref
      slot-set!

      get-arg
      print-object-with-slots
      initialize-direct-slots

      ;; base level generics

      make
      initialize
      print-object

      ;; syntax

      define-class
      define-generic
      define-method

      )

  ;; mosh. We need minimum import for serialize library
  (import (only (rnrs) define-syntax syntax-rules syntax-case define ...
                lambda call-with-values datum->syntax quote cons values
                reverse list unsyntax unsyntax-splicing if null? apply
                error car  cdr  not syntax let with-syntax quasisyntax)
          (only (loitsu clos core) <class> print-object initialize make
                initialize-direct-slots print-object-with-slots
                get-arg slot-set! slot-ref <object> <top> add-method
                <method> <generic>))

  (define-syntax define-class
    (syntax-rules ()
      ((_ ?name () ?slot-def ...)
       (define-class ?name (<object>) ?slot-def ...))
      ((_ ?name (?super ...) ?slot-def ...)
       (define ?name
         (make <class>
           'definition-name '?name
           'direct-supers (list ?super ...)
           'direct-slots    '(?slot-def ...))))))

  (define-syntax define-generic
    (syntax-rules ()
      ((_ ?name)
       (define ?name
         (make <generic>
           'definition-name '?name)))))

  (define-syntax define-method
    (lambda (x)
      (define (analyse args)
        (let loop ((args args) (qargs '()) (types '()))
             (syntax-case args ()
               (((?qarg ?type) . ?args)
                (loop #'?args (cons #'?qarg qargs) (cons #'?type types)))
               (?tail
                (values (reverse qargs) (reverse types) #'?tail)))))
      (define (build kw qualifier generic qargs types tail body)
        (let ((call-next-method (datum->syntax kw 'call-next-method))
              (next-method?     (datum->syntax kw 'next-method?)))
          (with-syntax (((?arg ... . ?rest) tail))
                       (let ((rest-args (syntax-case #'?rest ()
                                          (() #''())
                                          (_  #'?rest))))
                         #`(add-method #,generic
                                       (make <method>
                                         'specializers (list #,@types)
                                         'qualifier    '#,qualifier
                                         'procedure
                                         (lambda (%generic %next-methods #,@qargs ?arg ... . ?rest)
                                           (let ((#,call-next-method
                                                  (lambda ()
                                                    (if (null? %next-methods)
                                                      (apply error
                                                        'apply
                                                        "no next method"
                                                        %generic
                                                        #,@qargs ?arg ... #,rest-args)
                                                      (apply (car %next-methods)
                                                        %generic
                                                        (cdr %next-methods)
                                                        #,@qargs ?arg ... #,rest-args))))
                                                 (#,next-method?
                                                  (not (null? %next-methods))))
                                             . #,body))))))))
      (syntax-case x (quote)
        ((?kw '?qualifier ?generic ?args . ?body)
         (call-with-values
             (lambda ()
               (analyse #'?args))
           (lambda (qargs types tail)
             (build #'?kw #'?qualifier #'?generic qargs types tail #'?body))))
        ((?kw ?generic '?qualifier ?args . ?body)
         #'(?kw '?qualifier ?generic ?args . ?body))
        ((?kw ?generic ?args . ?body)
         #'(?kw 'primary ?generic ?args . ?body)))))

  ) ;; library (clos user)
