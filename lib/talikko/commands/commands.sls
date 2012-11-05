
(library (talikko commands commands)
  (export commands)
  (import
    (rnrs)
    (only (srfi :13 strings)
      string-join)  
    (mosh file)
    (mosh))

  (define(commands)
    (for-each
      print
      (map
        (lambda (path) (car (string-split path #\.)))
        (directory-list (string-join `(,(car (command-line)))
                                     "/")))))
  )
