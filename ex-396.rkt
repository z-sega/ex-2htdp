;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-396) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-396
;; Hangman is a well-known guessing game. One player
;; picks a word, the other player gets told how many
;; letters the word contains. The latter picks a letter
;; and asks the first player whether and where this
;; letter occurs in the chosen word. The game is over
;; after an agreed-upon time or number of rounds.
;;
;; Fig-136 presents the essence of a time-limited version
;; of the game. See "Local Definitions Add Expressive
;; Power" for why checked-compare is defined locally.

;; Fig-136: A simple hangman game
;; ------------------------------
(require 2htdp/batch-io)
(require 2htdp/universe)
(require 2htdp/image)

(define LOCATION "/usr/share/dict/words")
(define AS-LIST (read-lines LOCATION))
(define SIZE (length AS-LIST))
(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz"))

; An HM-Word is a [List-of Letter or "_"]
; *interpretation* "_" represents a letter to be guessed

; HM-Word N -> String
; runs a simplistic hangman game, produces the current
; state
(define (play the-pick time-limit)
  (local ((define the-word  (explode the-pick))
          (define the-guess
            (make-list (length the-word) "_"))
          ;; HM-Word KeyEvent -> HM-Word
          (define (checked-compare current-status ke)
            (if (member? ke LETTERS)
                (compare-word the-word current-status ke)
                current-status)))
    (implode
     (big-bang the-guess ;; HM-Word
       [to-draw (lambda (s) (text (implode s) 30 'black))]
       [on-tick (lambda (s) s) 1 time-limit]
       [on-key  checked-compare]))))

;; ------------------------------

;; The goal of this exercise is to design compare-word,
;; the central function. It consumes the word to be
;; guessed, a word s that represents how much/little the
;; guessing player has discovered, and the current guess.
;; The function produces s with all "_" where the guess
;; revealed a letter.

; HM-Word HM-Word 1String -> HM-Word
; returns s with correct letter revealed, if applicable
; CASE 2: same w and s are always the same length.
(check-expect (compare-word '() '() "a") '())
(check-expect (compare-word '("a" "t")
                            '("_" "_")
                            "a")
              '("a" "_"))
(check-expect (compare-word '("a" "t")
                            '("a" "_")
                            "t")
              '("a" "t"))
(check-expect (compare-word '("b" "a" "t")
                            '("_" "_" "_")
                            "a")
              '("_" "a" "_"))
(check-expect (compare-word '("b" "a" "t")
                            '("_" "a" "_")
                            "a")
              '("_" "a" "_"))
(check-expect (compare-word '("b" "a" "t")
                            '("_" "a" "_")
                            "x")
              '("_" "a" "_"))

(define (compare-word w s guess)
  (cond
    [(empty? w) '()]
    [else
     (cons
      ; CAUTION: be wary of comparing with eq?
      (if (string=? (first w) guess) guess (first s))
      (compare-word (rest w) (rest s) guess))]))

;; Once you have designed the function, run the program
;; like this:

(play (list-ref AS-LIST (random SIZE)) 20)

;; See Fig-74 for an explanation. Enjoy and refine
;; as desired!
