;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-485) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-485
;; A number tree is either a number or a pair of number trees.
;; Design sum-tree, which determines the sum of the numbers
;; in a tree.

;; A [Pair X Y] is:
;; - (list X Y)

;; An NT (short for Number Tree) is one of:
;; - Number
;; - [Pair NT]

(define t0 0)
(define t1 1)
(define t2 (list 2 5))
(define t3 (list t0 t1)) ;; (+ 0 1)
(define t4 (list t1 t2)) ;; (+ 1 7)
(define t5 (list t2 t3)) ;; (+ 7 (+ 0 1))

;; NT -> Number
;; computes the sum of numbers on t
(check-expect (sum-tree t0) 0)
(check-expect (sum-tree t1) 1)
(check-expect (sum-tree t2) 7)
(check-expect (sum-tree t3) (+ 0 1))
(check-expect (sum-tree t4) (+ 1 7))
(check-expect (sum-tree t5) (+ 7 (+ 0 1)))

(define (sum-tree t)
  (cond [(number? t) t]
        [else (+ (sum-tree (first t))
                 (sum-tree (second t)))]))

;; Q: What is its abstract running time?
;; A: The program sum-tree takes on the order of 2^n steps.
;;
;; Q: What is an acceptable measure of the size of such a
;;    tree?
;; A: An acceptable measure of the size of the tree is the
;;    maximum depth of the tree
;;
;; Q: What is the worst possible shape of the tree?
;; A: The worst possible shape of the tree is a tree
;;    consisting of pairings up until its last depth level.
;;
;; Q: What's the best possible shape? 
;; A: The best possible shape of the tree is one
;;    consisting of only a number.