
(import
  (scheme base)
  (pieni check)
  (loitsu maali))


(check (paint "J-_-L") => "J-_-L")

(check (paint "J-_-L" 'yellow) => "\x1B;[33mJ-_-L\x1B;[0m")
(check (paint "J-_-L" '(255 200 0)) =>  "\x1B;[38;5;220mJ-_-L\x1B;[0m")
(check (paint "J-_-L" "#123456") =>  "\x1B;[38;5;24mJ-_-L\x1B;[0m")
(check (paint "J-_-L" "123456") =>  "\x1B;[38;5;24mJ-_-L\x1B;[0m")
(check (paint "J-_-L" "#fff") =>  "\x1B;[38;5;255mJ-_-L\x1B;[0m")
(check (paint "J-_-L" "fff") =>   "\x1B;[38;5;255mJ-_-L\x1B;[0m")
(check (paint "J-_-L"  "#4183C4") =>  "\x1B;[38;5;74mJ-_-L\x1B;[0m")
(check (paint "J-_-L"  "MediumPurple") =>   "\x1B;[38;5;141mJ-_-L\x1B;[0m")


(check-report)

