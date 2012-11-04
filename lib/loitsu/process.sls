
(library (loitsu process)
  (export process-output->string)
  (import (rnrs)
    (mosh process))


  (define (process-output->string cmd)
    (let-values (((cout status x) (call-process cmd)))
      cout))



  )
