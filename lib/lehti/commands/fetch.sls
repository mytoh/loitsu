
(library (lehti commands fetch)
  (export
    fetch)
  (import
    (rnrs)
    (only (mosh)
          set-current-directory!)
    (only (mosh file)
          delete-directory)  
    (loitsu process)
    (loitsu file)
    (lehti scm)
    (lehti env))

  (begin

    (define (fetch url package)
      (let ((tmpdir (*lehti-cache-directory*)))
        (make-directory* tmpdir)
        (set-current-directory! tmpdir)
        (cond
          ((url-is-git? url)
           (if (file-exists? package)
             (delete-directory package))
           (run-command `(git clone -q ,url ,package)))
          (else
            "not supported url")
        )))
))
