
(library (loitsu maali colours)
  (export
    ansi-colours
    ansi-effects
    ansi-colours-foreground
    ansi-colours-background)
  (import (scheme base))


  (begin

  (define ansi-colours
    '((black   0)
      (red     1)
      (green   2)
      (yellow  3)
      (blue    4)
      (magenta 5)
      (cyan    6)
      (white   7)
      (default 9)
      )) 

  (define ansi-effects
    '((reset 0) (nothing 0)
                (bright 1) (bold    1)
                (faint          2)
                (italic         3)
                (underline      4)
                (blink           5)  (slow_blink        5)
                (rapid_blink    6)
                (inverse         7)  (swap              7)
                (conceal         8)  (hide              9)
                (default_font   10)
                (font0   10) (font1   11) (font2   12) (font3   13) (font4   14)
                (font5   15) (font6   16) (font7   17) (font8   18) (font9   19)
                (fraktur        20)
                (bright_off      21) (bold_off          21) (double_underline   21)
                (clean          22)
                (italic_off      23) (fraktur_off       23)
                (underline_off  24)
                (blink_off      25)
                (inverse_off     26) (positive          26)
                (conceal_off     27) (show              27) (reveal             27)
                (crossed_off     29) (crossed_out_off   29)
                (frame          51)
                (encircle       52)
                (overline       53)
                (frame_off       54) (encircle_off      54)
                (overline_off   55)
                )) 

  (define ansi-colours-foreground
    '((black    30)
      (red      31)
      (green    32)
      (yellow   33)
      (blue     34)
      (magenta  35)
      (cyan     36)
      (white    37)
      (default  39)
      )) 

  (define ansi-colours-background
    '((black    40)
      (red      41)
      (green    42)
      (yellow   43)
      (blue     44)
      (magenta  45)
      (cyan     46)
      (white    47)
      (default  49)
      ))) 

  )
