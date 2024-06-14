;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-400) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-400
;; Design the function DNAprefix. The function takes two
;; arguments, both lists of 'a, 'c, 'g, and 't, symbols
;; that occur in DNA descriptions. The first list is
;; called a pattern, the second one a search string. The
;; function returns #true if the pattern is identical
;; to the initial part of the search string; otherwise
;; it returns #false.

; A DNABlock is one of:
; - 'a
; - 'c
; - 'g
; - 't

; A DNASequence is one of:
; - '()
; - (cons DNABlock DNASequence)
(define seq-1 '(a))
(define seq-2 '(a c))
(define seq-3 '(a c g))
(define seq-4 '(a c g t))
(define seq-5 '(a c g t c))

(require 2htdp/abstraction)

; DNASequence DNASequence -> Boolean
; #true if pattern p* is identical to
; the initial part of search string ss*,
; else #false
(check-expect (DNAprefix '() '()) #true)
(check-expect (DNAprefix seq-1 '()) #false)
(check-expect (DNAprefix seq-1 seq-1) #true)
(check-expect (DNAprefix seq-1 seq-2) #true)
(check-expect (DNAprefix seq-1 seq-3) #true)
(check-expect (DNAprefix seq-2 '(g t)) #false)

(define (DNAprefix p* ss*)
  (cond
    [(and (empty? p*) (empty? ss*)) #true]
    [(and (empty? p*) (cons? ss*)) #true]
    [(and (cons? p*) (empty? ss*)) #false]
    [(and (cons? p*) (cons? ss*))
     (and (symbol=? (first p*) (first ss*))
          (DNAprefix (rest p*) (rest ss*)))]))

;; Also design DNAdelta. This funciton is like DNAprefix
;; but returns the first item in the search string beyond
;; the pattern. If the lists are identical and there is no
;; DNA letter beyond the pattern, the function signals an
;; error. If the pattern does not match the beginning of
;; the search string, it returns #false. The function
;; must not traverse either of the lists more than once.

; A [Maybe X] is one of:
; - #false
; - X
; example: [Maybe Symbol]

(define ERR "invalid search string")

; DNASequence DNASequence -> [Maybe Symbol]
; returns the first item in search string ss*
; beyond the pattern p* if
; (and (DNAprefix p* ss*) (> (length ss*) (length p*)))
; ERROR if (equal p* ss*),
; #false if (not (DNAprefix p* ss*))
(check-error (DNAdelta '() '()) ERR)
(check-expect (DNAdelta seq-1 '()) #false)
(check-error (DNAdelta seq-2 seq-2) ERR)
(check-expect (DNAdelta '() seq-1) 'a)
(check-expect (DNAdelta seq-1 seq-2) 'c)
(check-expect (DNAdelta seq-1 seq-3) 'c)
(check-expect (DNAdelta seq-2 seq-3) 'g)
(check-expect (DNAdelta seq-2 '(g t)) #false)

(define (DNAdelta p* ss*)
  (local ((define pattern-size (length p*))
          (define search-string-size (length ss*)))
    (cond
      [(DNAprefix p* ss*)
       (if (equal? pattern-size search-string-size)
           (error ERR)
           (list-ref ss* pattern-size))]
      [else #false])))

;; Can DNAprefix or DNAdelta be simplified?
;; 
;; They can be simplified.
;; For example: Using DNAprefix to define DNAdelta 
