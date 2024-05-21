;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-275) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-275
;; Real-World Data: Dictionaries deals with relatively
;; simple tasks relating to English dictionaries. The
;; design of two of them just call out for the use of
;; existing abstractions:
;; - Design nost-frequest.
;; The function consumes a Dictionary and
;; produces the Letter-Count for the letter
;; that is most frequently used as the first
;; one in the words of the given Dictionary.
;;
;; For the data definitions, see fig-74

(require 2htdp/batch-io)

; [List-of String]
(define sm-l (list "Albarn"
                   "allen"
                   "barn"
                   "bishop"
                   "Ken"
                   "vision"
                   "zed"
                   "Zebra"))

; On OS X:
(define LOCATION "/usr/share/dict/words")

; A Dictionary is a [List-of String]
; where each string is in system-dictionary (i.e LOCATION)
(define AS-LIST (read-lines LOCATION))

; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

(define-struct LC [letter count])
; LC (short for Letter-Count) is a structure:
;   (make-LC Letter Number)
; *intepretation*
; (make-LC "a" 2) describes the statistic that
; connects "a" to 2. It is used to keep
; track of how many times a letter appears in
; a given List-of-Strings
(define lc-a (make-LC "a" 2))
(define lc-b (make-LC "b" 2))
(define lc-c (make-LC "c" 0))


; [List-of LC]
(define lc1 (list lc-a))
(define lc0 (list (make-LC "a" 0)
                  (make-LC "b" 0)
                  (make-LC "c" 0)
                  (make-LC "d" 0)
                  (make-LC "e" 0)
                  (make-LC "f" 0)
                  (make-LC "g" 0)
                  (make-LC "h" 0)
                  (make-LC "i" 0)
                  (make-LC "j" 0)
                  (make-LC "k" 0)
                  (make-LC "l" 0)
                  (make-LC "m" 0)
                  (make-LC "n" 0)
                  (make-LC "o" 0)
                  (make-LC "p" 0)
                  (make-LC "q" 0)
                  (make-LC "r" 0)
                  (make-LC "s" 0)
                  (make-LC "t" 0)
                  (make-LC "u" 0)
                  (make-LC "v" 0)
                  (make-LC "w" 0)
                  (make-LC "x" 0)
                  (make-LC "y" 0)
                  (make-LC "z" 0)))
(define lcx (list (make-LC "a" 1)
                  (make-LC "b" 2)
                  (make-LC "c" 0)
                  (make-LC "d" 0)
                  (make-LC "e" 0)
                  (make-LC "f" 0)
                  (make-LC "g" 0)
                  (make-LC "h" 0)
                  (make-LC "i" 0)
                  (make-LC "j" 0)
                  (make-LC "k" 0)
                  (make-LC "l" 0)
                  (make-LC "m" 0)
                  (make-LC "n" 0)
                  (make-LC "o" 0)
                  (make-LC "p" 0)
                  (make-LC "q" 0)
                  (make-LC "r" 0)
                  (make-LC "s" 0)
                  (make-LC "t" 0)
                  (make-LC "u" 0)
                  (make-LC "v" 1)
                  (make-LC "w" 0)
                  (make-LC "x" 0)
                  (make-LC "y" 0)
                  (make-LC "z" 1)))

; An LCOrFalse is one:
; - LC
; - #f

; Dictionary -> LCOrFalse
; computes the LC for the letter that occurs
; the most often as the first one in the given
; los
; *implementation*
; selects the first from a sorted list of pairs
(check-expect (most-frequent '()) #f)
(check-expect (most-frequent sm-l) (make-LC "b" 2))

(define (most-frequent los)
  (local (; LC LC -> Boolean
          ; #t if a is more or atleast as frequent as b
          (define (letter-count>= a b)
            (>= (LC-count a) (LC-count b))))
    ; - IN -
    (cond
      [(empty? los) #f]
      [else
       (first
        (sort (count-by-letter los) letter-count>=))])))

; --------- generate LCs

; [List-of String] -> [List-of LC]
; counts how often each letter is used as the
; first one of a word in the given los
(check-expect (count-by-letter '()) '())
(check-expect (count-by-letter sm-l) lcx)

(define (count-by-letter los)
  (cond
    [(empty? los) '()]
    [else (count-by-letter-for-letters LETTERS los)]))


; [List-of Letter] [List-of Word] -> [List-of LC]
; given a lol and los, where lol is the list
; of letters to check with, compute a List-of-LC
; based on starts-with# for each lol in los
(check-expect (count-by-letter-for-letters
               (list "a" "b") sm-l)
              (list (make-LC "a" 1)
                    (make-LC "b" 2)))

(define (count-by-letter-for-letters lol los)
  (local (; Letter [List-of String] -> LC
          ; counts how often the given letter is
          ; used as the first letter of a word in los
          (define (lc-for-letter l acc)
            (cons (starts-with-to-lc l los) acc)))
    ; - IN -
    (foldr lc-for-letter '() lol)))


; Letter [List-of String] -> LC
; counts how often the given letter is used as
; the first letter of a word los
(check-expect (starts-with-to-lc "a" sm-l) (make-LC "a" 1))
(check-expect (starts-with-to-lc "v" sm-l) (make-LC "v" 1))
(check-expect (starts-with-to-lc "c" sm-l) (make-LC "c" 0))

(define (starts-with-to-lc l los)
  (make-LC l (starts-with# l los)))


; Letter [List-of String] -> Number
; counts the number of words in los that start with l
(check-expect (starts-with# "f" sm-l) 0)
(check-expect (starts-with# "z" sm-l) 1)
(check-expect (starts-with# "b" sm-l) 2)

(define (starts-with# l los)
  (local ((define TARGET l)
          
          ; Letter String -> Number
          ; returns 1 if s begins with TARGET
          (define (incr-on-starts-with s acc)
            (if (starts-with? s) (add1 acc)
                acc))
          
          ; Letter String -> Boolean
          ; #t if the string s begins with TARGET
          (define (starts-with? s)
            (string=? TARGET
                      (first (explode s)))))
    ; - IN -
    (foldr incr-on-starts-with 0 los)))


;; - Design words-by-first-letter.
;; The function consumes a Dictionary and produces
;; a list of Dictionaries, one per Letter. Do not
;; include '() if there are no words for some letter;
;; ignore the empty group instead.

(define sm-l2 '("allen"
                "cat"
                "verizon"
                "alvin"
                "fish"
                "fire"))

; Dictionary -> [List-of Dictionary]
; returns a [List-of Dictionary] where each Dictionary
; contains words starting with some letter.
(check-expect (words-by-first-letter sm-l2)
              (list (list "allen" "alvin")
                    (list "cat")
                    (list "fish" "fire")
                    (list "verizon")))

(define (words-by-first-letter dict)
  (local (; Letter -> [List-of String]
          ; construct list of words starting with l
          (define (words-for-letter l)
            (local ((define TARGET l)
                    ; String -> Boolean
                    ; #t if String starts with TARGET
                    (define (starts-with? s)
                      (string=? TARGET
                                (first (explode s)))))
              (filter starts-with? dict)))

          ; Letter [List-of String] -> [List-of String]
          ; if there are words for l, accumulate them
          (define (words-for-each-letter l acc)
            (local ((define words (words-for-letter l)))
              (if (cons? words)
                  (cons words acc)
                  acc))))
    (foldr words-for-each-letter '() LETTERS)))
