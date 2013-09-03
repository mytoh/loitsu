(library (pikkukivi commands)
    (export
      tosixel
      kuva
      ;; boards
      futaba
      pahvi
      geeli
      yotsuba
      ylilauta
      konachan
      kolmio

      print-path

      mount-nfs

      ascii-taide

      uname

      mkd
      starwars
      jblive
      sumo
      sumo2
      sumo3
      gsp
      )
  (import
    (silta base)
    (pikkukivi commands tosixel)
    (pikkukivi commands futaba)
    (pikkukivi commands kuva)
    (pikkukivi commands yotsuba)
    (pikkukivi commands ylilauta)
    (pikkukivi commands geeli)
    (pikkukivi commands pahvi)
    (pikkukivi commands kolmio)
    (pikkukivi commands konachan)
    (pikkukivi commands mount-nfs)
    (pikkukivi commands print-path)
    (pikkukivi commands alias)
    (pikkukivi commands uname)
    (pikkukivi commands ascii-taide)
    ))
