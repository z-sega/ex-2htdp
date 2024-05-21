#lang htdp/isl+

;; Develop n-inside-playground?, a specification of the random-posns
;; function below. The function generates a predicate that ensures
;; that the length of the given list is some given count and that
;; all Posns in the list are within a WIDTH by HEIGHT rectangle:

; distance in terms of pixels
(define WIDTH 300)
(define HEIGHT 300)

; N -> [List-of Posn]
; generates n random Posns in [0, WIDTH) by [0, HEIGHT)
(check-satisfied (random-posns 3)
                 (n-inside-playground? 3))
(define (random-posns n)
  (build-list n (lambda (i)
                  (make-posn (random WIDTH) (random HEIGHT)))))

; N -> [[List-of Posn] -> Boolean]
; specification for random-posns
; computes a function that is #t
; if tl is equal to n (the given count),
; AND all Posns on tl are within a WIDTH
; by HEIGHT rectangle
(check-expect [(n-inside-playground? 0) '()]
              #true)
(check-expect [(n-inside-playground? 2) (list (make-posn 50 50)
                                              (make-posn 100 150))]
              #true)
(check-expect [(n-inside-playground? 2) (list (make-posn 50 50))]
              #false)
(check-expect [(n-inside-playground? 2) (list (make-posn 500 50)
                                              (make-posn 100 150))]
              #false)
(define (n-inside-playground? n)
  (lambda (tl)
    (local (; [List-of X] -> Boolean
            ; #t if the length of tl equals n
            (define (length-is-valid? l)
              (equal? (length l) n))

            ; [List-of Posn] -> Boolean
            ; #t if all Posns in l are within the WIDTH by
            ; HEIGHT rectangle
            (define (all-within-rectangle? l)
              (local (; Number Number Number -> Boolean
                      ; #t if t is within in [start, end
                      (define (valid? t start end)
                        (and (>= t start)
                             (< t end))))
                (andmap (lambda (p)
                          (and (valid? (posn-x p) 0 WIDTH)
                               (valid? (posn-y p) 0 HEIGHT)))
                        l))))
      (and (not (negative? n)) 
           (length-is-valid? tl)
           (all-within-rectangle? tl)))))


;; Define random-posns/bad that satisfies n-inside-playground? and does
;; not live up to the expectations implied by the above purpose statement
;; (which purpose statement? the one for (random-posns)).
;; *Note* This specification is *incomplete*. Although the word "partial"
;; might come in mind, computer scientists reserve the phrase
;; "partial specification" for a different purpose.


; N -> [List-of Posn]
; generates n NOT random Posns in [0, WIDTH) by [0, HEIGHT)
(check-satisfied (random-posns/bad 3)
                 (n-inside-playground? 3))
(define (random-posns/bad n)
  (build-list n (lambda (i)
                  (make-posn (- WIDTH 10) (- HEIGHT 10)))))
