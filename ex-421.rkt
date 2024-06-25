;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-421) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
; idea: take n items and drop n at a time
(define (bundle s n)
  (cond [(empty? s) '()]
        [else (cons (implode (take s n))
                    (bundle (drop s n) n))]))

; [List-of X] N -> [List-of X]
; keeps the first n items from l if possible
; or everything
(define (take l n)
  (cond [(zero? n) '()]
        [(empty? l) '()]
        [else (cons (first l)
                    (take (rest l) (sub1 n)))]))

; [List-of X] N -> [List-of X]
; removes the first n items from l if possible
; or everything
(define (drop l n)
  (cond [(zero? n) l]
        [(empty? l) l]
        [else (drop (rest l) (sub1 n))]))

;; ex-421
;; Q: Is (bundle '("a" "b" "c") 0) a proper use of
;; the bundle function?
;; A: No. According to the function signature 0 is a proper
;; input, but it will cause infinite recursion, because
;; in the drop function the same list will be returned
;; repeatedly.
;;
;; Q: What does it produce? Why?
;; A: It produces '(""). This is because the function
;; bundle's else clause consists of two parts that
;; are consed together:
;; - (implode (take s n))
;; - (bundle (drop s n) n)
;;
;; (implode (take s n)) when n is 0 (take ... 0)
;; evaluates to '(), and (implode '()) evaluates to "".
;;
;; (bundle (drop s n) n) when n is 0 (drop s 0)
;; evaluates to s, and then (bundle s 0) evaluates to
;; (cons "" ...) where ... does not terminate because
;; drop always returns s when n is 0.
