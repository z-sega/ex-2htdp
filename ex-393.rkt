;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-393) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-393
;; Fig-62 presents two data definitions for finite
;; sets. Design the union function for the representation
;; of finite sets of your choice. It consumes two sets
;; and produces on that contains the elements of both.

;; Case 1 - Treat one of the sets as atomic data

; [Either X Y ...] is one of:
; - X
; - Y
; - ...
; example: [Either Symbol String]

; [X Y] [List-of X] [List-of Y] -> [List-of [Either X Y]]
; computes a list containing all elements of x* and y*
(check-expect (union '() '()) '())
(check-expect (union '(a b c) '()) '(a b c))
(check-expect (union '() '(1 2)) '(1 2))
(check-expect (union '(a b c) '(1 2)) '(a b c 1 2))

(define (union x* y*)
  (append x* y*))

;; Design intersect for the same set representation.
;; It consumes two sets and produces the set of exactly
;; those elements that occur in both.

; CASE 1

; [X Y] [List-of X] [List-of Y] -> [List-of [Either X Y]]
; computes a list of elements that are in both x* and y*
(check-expect (intersect '() '()) '())
(check-expect (intersect '(a b c) '(1 2)) '())
(check-expect (intersect '(a b c) '(b c)) '(b c))
(check-expect (intersect '(1 2) '(b c 2)) '(2))
(check-expect (intersect '(b c 2) '(1 2)) '(2))

(define (intersect x* y*)
  (filter (lambda (x) (member? x y*)) x*))
