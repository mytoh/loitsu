
(library (lehti commands install)
    (export
      search-project-address
      get-projects-repository
      install
      install-package)
  (import
    (except (rnrs)
            find)
    (only (srfi :1 lists)
          find)
    (srfi :39 parameters)
    (lehti base)
    (lehti env)
    (lehti util)
    (lehti lehspec)
    (lehti commands fetch)
    )

  (begin

    (define  (get-projects-repository)
      (cond
       ((not (file-exists? (*lehti-projects-repository-directory*)))
        (ohei "getting projects repository")
        (run-command `(git clone ,(*projects-repository*) ,(*lehti-projects-repository-directory*))))
       (else
        (update-projects-repository))))

    (define (update-projects-repository)
      (with-cwd (*lehti-projects-repository-directory*)
                (run-command `(git pull))))

    (define  (project-exists? package)
      (member package (directory-list2 (*lehti-projects-repository-directory*))))

    (define (search-project-address package)
      (if (project-exists? package)
          (car
           (file->sexp-list (build-path (*lehti-projects-repository-directory*)
                                        package "source.sps")))
          (error "project does not exists!")))

    (define (install args)
      (let ((packages (cddr args)))
        (for-each
         (lambda (p)
           (ohei (string-append "install " (paint p 133)))
           (install-package p))
         packages)))

    (define (install-package package)
      (get-projects-repository)
      (cond
       ((and (not (package-installed? package)))
        (fetch (cadr (search-project-address package)) package)
        (set-current-directory! (build-path (*lehti-cache-directory*)
                                            package))
        (let* ((cache-directory (build-path (*lehti-cache-directory*)
                                            package))
               (lehspec (spec (cdar (file->sexp-list (build-path cache-directory
                                                                 (path-swap-extension package "lehspec")))))))
          (install-leh-package-files  lehspec)
          (make-executables package)
          (remove-directory* cache-directory)))
       ((package-installed? package)
        (display "package already installed ")
        (newline))))

    (define (install-leh-package-files spec)
      (let ((files (spec-files spec))
            (package-name (spec-name spec)))
        (create-directory (build-path (*lehti-dist-directory*) package-name))
        (for-each
         (lambda (file)
           (cond
            ((file-directory? file)
             (make-directory* (build-path (*lehti-dist-directory*) package-name file)))
            (else
             (make-directory* (build-path (*lehti-dist-directory*) package-name (path-dirname file)))
             (copy-file file
                        (build-path (*lehti-dist-directory*) package-name file)))))
         files)))

    (define (make-executables name)
      (if (file-exists? (build-path (*lehti-dist-directory*)
                                    name "bin"))
          (for-each
           (lambda (f)
             (run-command `("chmod" "+x" ,(build-path (*lehti-dist-directory*) name "bin" f)))
             (create-symbolic-link (build-path (*lehti-dist-directory*) name "bin" f)
                                   (build-path (*lehti-bin-directory*) f)))
           (directory-list2 (build-path (*lehti-dist-directory*)
                                        name "bin")))))

    ))
