;; -*- coding: utf-8 -*-

;; module to convert rgb.txt to list

(library (loitsu maali util)
  (export
    rgb-txt->list)
  (import
    (except (rnrs)
            remove)  
    (only (srfi :1 lists)
      last
      remove)
    (only (srfi :13 strings)
      string-tokenize
      string-trim-both)
    (mosh file))

  (begin

  (define (comment? string-line)
    (cond
      ((= (string-length string-line) 0)
       #f)
      ((equal? #\# (string-ref (string-trim-both (string-trim-both string-line) #\t) 0))
       #t)
      (else #f))) 

  (define (empty-line? line)
    (if (string=? "" line)
      #t #f)) 

  (define (colour-list lst)
    (map
      (lambda (e)
        (let ((colours (string-tokenize (string-trim-both e))))
          `(,(last colours)
             (,(car colours)
               ,(cadr colours)
               ,(caddr colours)))))
      lst)) 

  (define (rgb-txt->list file)
    (colour-list
      (remove
        (lambda (l)
          (or (comment? l)
            (empty-line? l)))
        (file->list file))))) 


)

