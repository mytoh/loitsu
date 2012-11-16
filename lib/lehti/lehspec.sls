
(library (lehti lehspec)
  (export
    spec
    spec-name
    spec-description
    spec-homepage
    spec-files
    <lehspec>)
  (import
    (scheme base)
    (srfi :9)
    (kirjain)
    )

  (begin

    (define-record-type <lehspec>
      (make-spec
        name
        description
        homepage
        files)
      lehspec?
      (name spec-name set-spec-name)
      (description spec-description set-spec-description)
      (homepage spec-homepage set-spec-homepage)
      (files spec-files set-spec-files))

    (define (spec infos)
      (let ((register (lambda (i e)
                        (if (assoc e  i)
                            (cadr (assoc e i))
                          #f)))
            (lehspec (make-spec #f #f #f #f)))

              (set-spec-name lehspec (register infos 'name))
              (set-spec-files lehspec (register infos 'files))
              (set-spec-description lehspec (register infos 'description))
              (set-spec-homepage lehspec (register infos 'homepage))
              ; (register infos 'dependencies)
              lehspec))



    ))

