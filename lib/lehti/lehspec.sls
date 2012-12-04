
(library (lehti lehspec)
  (export
    package->lehspec
    spec
    spec-name
    spec-description
    spec-homepage
    spec-files
    <lehspec>)
  (import
    (except (rnrs)
            define-record-type)  
    (srfi :9)
    (loitsu file)
    (lehti env)
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

 (define (package->lehspec package)
      (spec (cdar (file->sexp-list
                    (build-path (*lehti-dist-directory*) package
                                (path-swap-extension package "lehspec"))))))


    ))

