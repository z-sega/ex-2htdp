;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-399) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-399
;; Louise, Jane, Laura, Dana, and Mary decide to run
;; a lottery that assigns one gift recipient to each
;; of them. Since Jane is a developer, they ask her
;; to write a program that performs this task in an
;; impartial manner. Of course, the program must not
;; assign any of the sisters to herself.
;;
;; Here is the core of Jane's program:

(define louise "Louise")
(define jane "Jane")
(define laura "Laura")
(define dana "Dana")
(define mary "Mary")

(define ladies `(,louise ,jane ,laura ,dana ,mary))

; [List-of String] -> [List-of String]
; picks a random non-identity arrangement of names
(check-random (gift-pick ladies)
              (random-pick
               (non-same ladies (arrangements ladies))))

(define (gift-pick names)
  (random-pick
   (non-same names (arrangements names))))

; [List-of String] -> [List-of [List-of String]]
; creates all rearrangements of the letters in w
(check-expect (arrangements '()) '(()))
(check-expect (arrangements (list louise))
              (list (list louise)))
(check-expect (arrangements (list louise jane))
              (list (list louise jane) 
                    (list jane louise)))

(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [else
     (insert-everywhere/in-all-words
      (first w)
      (arrangements (rest w)))]))

;; It consumes a list of names and randomly picks one
;; of those permutations that do not agree with the
;; original list at any place.
;; 
;; Your task is to design two auxiliary functions:

; [NEList-of X] -> X
; returns a random item from the list
(check-random (random-pick ladies)
              (list-ref ladies (random 5)))
(define (random-pick l)
  (local ((define SIZE (length l)))
    (list-ref l (random SIZE))))

; [List-of String ] [List-of [List-of String]]
; -> [List-of [List-of String]]
; produces the list of those lists in ll that
; do not agree with names at any place
(check-expect (non-same
               (list louise laura)
               (list
                (list louise laura)
                (list laura louise)))
              (list
                (list laura louise)))
(check-expect (non-same
               (list louise laura jane)
               (list
               (list louise jane laura)
               (list jane louise laura)
               (list jane laura louise)
               (list louise laura jane)
               (list laura louise jane)
               (list laura jane louise)))
              (list
               (list louise jane laura)
               (list jane louise laura)
               (list jane laura louise)
               (list laura louise jane)
               (list laura jane louise)))

(define (non-same names ll)
  (filter (lambda (l)
            (not
             (string=? (foldr string-append "" names)
                       (foldr string-append "" l)))) ll))

;; Recall that random picks a random number; see
;; ex-99.

;; arrangements helper:
;; --------------------

; String [List-of [List-of String]]
; -> [List-of [List-of String]]
; inserts s at the beginning, between all strings,
; and at the end of all strings of the given s*.
(check-expect (insert-everywhere/in-all-words
               louise '())
              '())
(check-expect (insert-everywhere/in-all-words
               louise (list (list jane)))
              (list (list louise jane)
                    (list jane louise)))
(check-expect (insert-everywhere/in-all-words
               louise (list (list jane laura)
                         (list laura jane)))
              (list
               (list louise jane laura)
               (list jane louise laura)
               (list jane laura louise)
               (list louise laura jane)
               (list laura louise jane)
               (list laura jane louise)))

(define (insert-everywhere/in-all-words s s*)
  (cond
    [(empty? s*) '()]
    [else
     (append
      (insert-everywhere/in-list s (first s*))
      (insert-everywhere/in-all-words s (rest s*)))]))

; String [List-of String] -> [List-of [List-of String]]
; inserts s at the beginning, between all string,
; and at the end of given suf.
(check-expect (insert-everywhere/in-list louise '())
              (list (list louise)))
(check-expect (insert-everywhere/in-list louise
                                         (list jane))
              (list (list louise jane)
                    (list jane louise)))
(check-expect (insert-everywhere/in-list louise
                                         (list jane laura))
              (list (list louise jane laura)
                    (list jane louise laura)
                    (list jane laura louise)))

(define (insert-everywhere/in-list s s*)
  (insert-everywhere/in-list* s '() s*))
  

; String [List-of String] [List-of String]
; -> [List-of [List-of String]]
; inserts s at the beginning, between all strings,
; and at the end of given suf.
; *implementation-detail*
; the function begins with w <-> suf, then with each
; recursion moves a letter from suf -> pre.
; this is how it is able to put 1s everywhere in w
(check-expect (insert-everywhere/in-list* louise
                                          '()
                                          '())
              (list (list louise)))
(check-expect (insert-everywhere/in-list* louise
                                          '()
                                          (list jane))
              (list (list louise jane)
                    (list jane louise)))
(check-expect (insert-everywhere/in-list* louise
                                          '()
                                          (list jane laura))
              (list (list louise jane laura)
                    (list jane louise laura)
                    (list jane laura louise)))

(define (insert-everywhere/in-list* s pre suf)
  (cond
    [(empty? suf) (list (append pre (list s)))]
    [else (append (list (append pre (list s) suf))
             (insert-everywhere/in-list*
              s
              (append pre (list (first suf)))
              (rest suf)))]))
       