;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-471) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-471
;; Translate one of the above definitions into proper
;; list form using list and proper symbols.

(define sample-graph
  '((A (B E))
    (B (E F))
    (C (D))
    (D ())
    (E (C F))
    (F (D G))
    (G ())))

(check-expect
 sample-graph
 (list (list 'A (list 'B 'E))
       (list 'B (list 'E 'F))
       (list 'C (list 'D))
       (list 'D '())
       (list 'E (list 'C 'F))
       (list 'F (list 'D 'G))
       (list 'G '())))

;; The data representation for nodes is straightforward:
;;
;; A Node is a Symbol.
;;
;; Formulate a data definition to describe the class of
;; all Graph representations, allowing an arbitrary number
;; of nodes and edges. Only one of the above
;; representations has to belong to Graph.


;; A GraphRecord is (cons Node (cons [List-of Node] '()))
(define rA '(A (B E)))
(define rB '(B (E F)))
(define rC '(C (D)))
(define rD '(D ()))
(define rE '(E (C F)))    
(define rF '(F (D G)))
(define rG '(G ()))

;; A Graph is a [NEList-of GraphRecord]
(define gSample (list rA rB rC rD rE rF rG))

;; Design the function neighbors. It consumes a Node n
;; and a Graph g and produces the list of immediate
;; neighbors of n in g.

;; Node Graph -> [List-of Node]
;; computes immediate neighbors of n in g
(check-expect (neighbors 'A gSample) '(B E))
(check-expect (neighbors 'B gSample) '(E F))
(check-expect (neighbors 'E gSample) '(C F))

(define (neighbors n g)
  (foldr
   (lambda (r rst)
     (if (symbol=? n (first r)) (second r) rst))
   '() g))
