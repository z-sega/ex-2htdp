;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-390) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-390
;; Design the function tree-pick. The function consumes
;; a tree of symbols and a list of directions:

(define-struct branch [left right])

; A TOS is one of:
; - Symbol
; - (make-branch TOS TOS)
(define tree-case-1 'a)
(define tree-case-2 (make-branch 'b 'c))
(define tree-case-3 (make-branch 'a (make-branch 'b 'c)))

; A Direction is one of:
; - 'left
; - 'right
; A list of Directions is also called a path
(define d*-case-1 '())
(define d*-case-2 '(left))
(define d*-case-3 '(right left))
(define d*-case-4 '(right right))

;; Clearly a Direction tells the function whether to
;; choose the left or the right branch in a nonsymbolic
;; tree.
;; What is the result of the tree-pick function?
;
; ->
; The result is a TOS. The tree will be a symbol
; if the given list of directions terminates at a Symbol
; or a branch if it terminates at a branch.
;
;; Don't forget to formulate a full signature. The
;; function signals an error when given a symbol and a
;; non-empty path.

(define ERR "given symbol and non-empty path")

; TOS [List-of Direction]-> TOS
; returns a TOS that terminates at d* (path) for tree
; signals error when given a symbol and a non-empty path
(check-expect (tree-pick tree-case-1 d*-case-1) tree-case-1)
(check-error (tree-pick tree-case-1 d*-case-2) ERR)
(check-expect (tree-pick tree-case-2 d*-case-1) tree-case-2)
(check-expect (tree-pick tree-case-2 d*-case-2) 'b)
(check-expect (tree-pick tree-case-3 d*-case-3) 'b)
(check-expect (tree-pick tree-case-3 d*-case-4) 'c)

(define (tree-pick tree d*)
  (cond
    [(and (empty? d*) (symbol? tree)) tree]
    [(and (empty? d*) (branch? tree)) tree]
    [(and (cons? d*) (symbol? tree)) (error ERR)]
    [(and (cons? d*) (branch? tree))
     (cond
       [(symbol=? (first d*) 'left)
        (tree-pick (branch-left tree) (rest d*))]
       [(symbol=? (first d*) 'right)
        (tree-pick (branch-right tree) (rest d*))])]))
     
          


