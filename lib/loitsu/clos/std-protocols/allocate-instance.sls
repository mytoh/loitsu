;; *************************************************************************
;; Copyright (c) 1992 Xerox Corporation.
;; All Rights Reserved.
;;
;; Use, reproduction, and preparation of derivative works are permitted.
;; Any copy of this software or of any derivative work must include the
;; above copyright notice of Xerox Corporation, this paragraph and the
;; one after it.  Any distribution of this software or derivative works
;; must comply with all applicable United States export control laws.
;;
;; This software is made available AS IS, and XEROX CORPORATION DISCLAIMS
;; ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
;; PURPOSE, AND NOTWITHSTANDING ANY OTHER PROVISION CONTAINED HEREIN, ANY
;; LIABILITY FOR DAMAGES RESULTING FROM THE SOFTWARE OR ITS USE IS
;; EXPRESSLY DISCLAIMED, WHETHER ARISING IN CONTRACT, TORT (INCLUDING
;; NEGLIGENCE) OR STRICT LIABILITY, EVEN IF XEROX CORPORATION IS ADVISED
;; OF THE POSSIBILITY OF SUCH DAMAGES.
;; *************************************************************************
;;
;; port to R6RS -- 2007 Christian Sloma
;;

(library (loitsu clos std-protocols allocate-instance)

    (export class-allocate-instance
            entity-class-allocate-instance)

  (import (only (rnrs) define let* let if null? begin car cdr + quote)
          (loitsu clos private allocation)
          (loitsu clos slot-access))

  (define (class-allocate-instance class)
    (shared-allocate-instance class
                              really-allocate-instance))

  (define (entity-class-allocate-instance entity-class)
    (shared-allocate-instance entity-class
                              really-allocate-entity-instance))

  (define (shared-allocate-instance class really-allocate)
    (let* ((field-count (slot-ref class 'number-of-fields))
           (field-inits (slot-ref class 'field-initializers))
           (new-object (really-allocate class field-count)))
      (let loop ((inits field-inits)
                 (index 0))
           (if (null? inits)
             new-object
             (begin
                 (instance-set! new-object index ((car inits)))
               (loop (cdr inits)
                     (+ index 1)))))))

  ) ;; library (clos std-protocols allocate-instance)
