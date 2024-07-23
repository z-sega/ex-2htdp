;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-493) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] -> [List-of X]
; constructs the reverse of alox
(check-expect (invert '(a b c)) '(c b a))

(define (invert alox)
  (cond
    [(empty? alox) '()]
    [else (add-as-last (first alox)
                       (invert (rest alox)))]))

; X [List-of X] -> [List-of X]
; adds an-x to the end of alox
(check-expect (add-as-last 'a '(c b)) '(c b a))

(define (add-as-last an-x alox)
  (cond
    [(empty? alox) (list an-x)]
    [else (cons (first alox)
                (add-as-last an-x (rest alox)))]))

(invert '(a b c))
;;
(add-as-last 'a (invert '(b c)))
(add-as-last 'a (add-as-last 'b (invert '(c))))
(add-as-last 'a (add-as-last 'b (add-as-last 'c (invert '()))))
(add-as-last 'a (add-as-last 'b (add-as-last 'c '())))
(add-as-last 'a (add-as-last 'b '(c)))
(add-as-last 'a '(c b))
'(c b a)

;; ex-493
;; Argue that, in the terminology of Intermezzo 5:
;; The Cost of Computation, invert consumes O(n^2) time
;; when the given list consists of n items.

(invert '(a))
;; n: 1
;; calls:
;;   add-as-last: 1
;;   invert: 1
(add-as-last 'a (invert '()))
(add-as-last 'a '())
'(a)

(invert '(a b))
;; n: 2
;; calls:
;;   add-as-last: 2
;;   invert: 2
(add-as-last 'a (invert '(b)))
(add-as-last 'a (add-as-last 'b (invert '())))
(add-as-last 'a (add-as-last 'b '()))
(add-as-last 'a '(b))
'(b a)

(invert '(a b c))
;; n: 3
;; calls:
;;   add-as-last: 3
;;   invert: 3
(add-as-last 'a (invert '(b c)))
(add-as-last 'a (add-as-last 'b (invert '(c))))
(add-as-last 'a (add-as-last 'b (add-as-last 'c (invert '()))))
(add-as-last 'a (add-as-last 'b (add-as-last 'c '())))
(add-as-last 'a (add-as-last 'b '(c)))
(add-as-last 'a '(c b))
'(c b a)

;; We can see that for each item n in the input there are
;; n recursive calls to invert. And for each of those
;; calls of invert there are n recursive calls of
;; add-as-last. There is some arithmetic fuzziness in
;; here that I don't really understand that says
;; the sum of all those calls (which is an arithmetic
;; series) is (/ (* n (sub1 n)) 2). The dominant factor
;; of that expression is n^2. So that means invert
;; runs on the order of O(n^2) steps.
