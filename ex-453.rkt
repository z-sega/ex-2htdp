;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-453) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-453
;; Design the function tokenize. It turns a Line into
;; a list of tokens. Here a token is either a 1String
;; or a String that consists of lower-case letters
;; and nothing else. That is, all white-space 1Strings
;; are dropped; all other non-letters remain as is;
;; and all consecutive letters are bundled into "words".
;;
;; Hint:
;; Read up on the string-whitespace? function.

;; A Line is [List-of 1String]

;; A Token is one of:
;; - 1String[(not (string-whitespace? ...))]
;; - String[(andmap (not (string-whitespace? ...)) ...)]

;; Line -> [List-of Token]
;; translates a line into a [List-of Token]
;; how:
;; conses the first segment from l as a token to
;; the result of tokenizing the l without the
;; first segment
;; termination:
;; the recurrence recieves shorter lines and
;; will eventually recieve '()
(check-expect (tokenize (explode "")) '())
(check-expect (tokenize (explode "abc")) '("abc"))
(check-expect (tokenize (explode "a bc")) '("a" "bc"))
(check-expect (tokenize (explode "ab c")) '("ab" "c"))
(check-expect (tokenize (explode "a b c"))
              '("a" "b" "c"))

(define (tokenize l)
  (cond
    [(empty? l) '()]
    [else (cons (first-token l)
                (tokenize (rm-first-token l)))]))

;; Line -> Token
;; retrieves the first token from l
(check-expect (first-token (explode "abc")) "abc")
(check-expect (first-token (explode "a bc")) "a")
(check-expect (first-token (explode "ab c")) "ab")
(check-expect (first-token (explode "a b c")) "a")

(define (first-token l)
  (cond [(empty? l) ""]
        [(string-whitespace? (first l)) ""] ;; simplify
        [else (string-append (first l)
                             (first-token (rest l)))])
  #;(cond
    [(empty? l) ""]
    [else (if (string-whitespace? (first l))
              "" ;; end-recursion
              (string-append (first l)
                             (first-token (rest l))))]))

;; Line -> Line
;; removes the first retrieved token from l
(check-expect (rm-first-token (explode "abc")) '())
(check-expect (rm-first-token (explode "a bc"))
              (explode "bc"))
(check-expect (rm-first-token (explode "ab c"))
              (explode "c"))
(check-expect (rm-first-token (explode "a b c"))
              (explode "b c"))

(define (rm-first-token l)
  (cond [(empty? l) '()]
        [(string-whitespace? (first l)) (rest l)]
        [else (rm-first-token (rest l))]))