;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-259) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; ex-259
;; Use a local expression to organize the functions for rearranging
;; words from Word Games, the Heart of the Problem. 

(require 2htdp/batch-io)

; ---

(define
  LOCATION "/usr/share/dict/words")

; [List-of String]
(define ls1 (list "dfksl" "fish" "chair" "rabbi"))

; The Dictionary is a LStrings (short for List-of-Strings).
(define DICTIONARY (read-lines LOCATION))

; ---

; A Word is [List-of 1String]
(define w-to (list "t" "o"))
(define w-cat (list "c" "a" "t"))
(define w-dear (list "d" "e" "a" "r"))

; [List-of Word]
(define lw1 (list w-cat w-dear))  
(define lw2 (list (list "t" "o")
                  (list "o" "t")))


; String -> [List-of String]
; finds all words that the letters of some given word spell
(check-member-of (alternative-words "cat")
                 (list "act" "cat")
                 (list "cat" "act"))
(define (alternative-words s)
  (local [
          ; [List-of Word] -> [List-of String]
          ; converts all Words in lw to Strings
          (define (words->strings lw)
            (cond
              [(empty? lw) '()]
              [else (cons (word->string (first lw))
                          (words->strings (rest lw)))]))

          ; Word -> String
          ; converts w to a String
          (define (word->string w)
            (implode w))
          
          ; String -> Word
          ; converts s to a Word
          (define (string->word s)
            (explode s))]
    ; - IN -
    (in-dictionary
     (words->strings (arrangements (string->word s))))))
  
; [List-of String] -> [List-of String]
; picks out all those Strings that occur in the dictionary.
(check-expect (in-dictionary '()) '())
(check-expect (in-dictionary ls1) (list "fish" "chair" "rabbi"))
(define (in-dictionary ls)
  (cond
    [(empty? ls) '()]
    [else (if (string-in-dictionary? (first ls))
              (cons (first ls)
                    (in-dictionary (rest ls)))
              (in-dictionary (rest ls)))]))
  
; String -> Boolean
; # if s is in the DICTIONARY
(check-expect (string-in-dictionary? "cat") #t)
(check-expect (string-in-dictionary? "cata") #f)
(define (string-in-dictionary? s)
  (member? s DICTIONARY))
  
; Word -> [List-of Word]
; creates all rearrangements of the letters in w
(check-expect (arrangements '())
              (list '()))
(check-expect (arrangements (list "d"))
              (list (list "d")))
(check-expect (arrangements (list "d" "e"))
              (list (list "d" "e")
                    (list "e" "d")))
(define (arrangements w)
  (local [
          ; 1String [List-of Word] -> [List-of Word]
          ; inserts 1s at the beginning, between all letters,
          ; and at the end of all words of the given list lw.
          (define (insert-everywhere/in-all-words 1s lw)
            (local [
                    ; 1String Word -> [List-of Word]
                    ; inserts 1s at the beginning, between all letters,
                    ; and at the end of given suf.
                    (define (insert-everywhere/in-word 1s w)
                      (insert-everywhere/in-word* 1s '() w))

                    ; 1String Word -> [List-of Word]
                    ; inserts 1s at the beginning, between all letters,
                    ; and at the end of given suf.
                    ; *implementation-detail*
                    ; the function begins with w <-> suf, then with each
                    ; recursion moves a letter from suf -> pre.
                    ; this is how it is able to put 1s everywhere in w
                    (define (insert-everywhere/in-word* 1s pre suf)
                      (cond
                        [(empty? suf)
                         (list (append pre
                                       (list 1s)))]
                        [else
                         (append (list(append pre (list 1s) suf))
                                 (insert-everywhere/in-word*
                                  1s
                                  (append pre (list (first suf)))
                                  (rest suf)))]))

                    (define inserted-everwhere-in-all-words
                      (cond
                        [(empty? lw) '()]
                        [else (append (insert-everywhere/in-word 1s (first lw))
                                      (insert-everywhere/in-all-words 1s (rest lw)))]))]
              ; - IN -
              inserted-everwhere-in-all-words))

          (define word-arrangements
            (cond
              [(empty? w) (list '())]
              [else
               (insert-everywhere/in-all-words (first w)
                                               (arrangements (rest w)))]))]
    ; - IN -
    word-arrangements))
