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

(library (loitsu clos std-protocols print-object)

    (export object-print-object)

  (import (only (rnrs) define)
          (loitsu clos introspection)
          (loitsu clos helpers))

  (define (object-print-object object port)
    (print-unreadable-object (port #t #t object)))

  ) ;; library (clos std-protocols initialize)
