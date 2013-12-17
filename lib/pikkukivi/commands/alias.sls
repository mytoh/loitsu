(library (pikkukivi commands alias)
    (export
      starwars
      jblive
      sumo
      sumo2
      sumo3
      bbc1
      gsp
      mkd)
  (import
    (rnrs)
    (loitsu process))

  (begin


    (define (mkd args)
      (run-command `(mkdir -p ,@(cddr args))))

    (define (starwars args)
      (run-command '(starwars towel.blinkenlights.nl)))

    (define (jblive)
      (run-command '(mplayer "rtsp://videocdn-us.geocdn.scaleengine.net/jblive/jblive.stream")))

    (define (sumo)
      (run-command '(mplayer -playlist "http://sumo.goo.ne.jp/hon_basho/torikumi/eizo_haishin/asx/sumolive.asx")))

    (define (sumo2)
      (run-command '(mplayer -playlist "mms://a776.l12513450775.c125134.a.lm.akamaistream.net/D/776/125134/v0001/reflector:50775")))

    (define (sumo3)
      (run-command '(mplayer -playlist "mms://a792.l12513450791.c125134.a.lm.akamaistream.net/D/792/125134/v0001/reflector:50791")))

    (define (bbc1)
      (run-command '(mplayer --playlist=http://www.bbc.co.uk/radio/listen/live/r1.asx)))

    (define (gsp args)
      (run-command `(gosh -ptime ,@(cddr args))))

    ))
