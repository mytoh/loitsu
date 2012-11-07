
(library (talikko commands commands)
  (export commands)
  (import
    (scheme base)
    (scheme process-context)
    (only (srfi :13 strings)
      string-join)
    (mosh file)
    (except (mosh)
      read-line))

  (begin

  (define(commands)
    (for-each
      print
      (map
        (lambda (path) (car (string-split path #\.)))
        (directory-list (string-join `(,(car (command-line)))
                                     "/")))))) 
  )
