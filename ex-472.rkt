;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-472) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; A Path is a [List-of Node].
;; interpretation: the list of nodes specifies a sequence
;; of immediate neighbors that leads from the first Node
;; on the list to the last one.

;; Node Node Graph -> [Maybe Path]
;; finds a path from origination to destination in G
;; if there is no path, the function produces #false.
(check-expect (find-path 'C 'C gSample) '(C))
(check-expect (find-path 'C 'D gSample) '(C D))
(check-member-of (find-path 'E 'D gSample)
                 '(E F D)
                 '(E C D))
(check-expect (find-path 'C 'G gSample) #false)

(define (find-path origination destination G)
  (cond [(symbol=? origination destination) (list destination)]
        [else (local ((define next (neighbors origination G))
                      (define candidate
                        (find-path/list next destination G)))
                (cond [(boolean? candidate) #false]
                      [else (cons origination candidate)]))]))

;; [List-of Node] Node Graph -> [Maybe Path]
;; finds a path from some node on lo-Os to D
;; if there is no path, the function produces #false
(check-member-of (find-path/list '(F C) 'D gSample)
                 '(F D))
                 
(define (find-path/list lo-Os D G)
  (cond [(empty? lo-Os) #false]
        [else (local ((define candidate
                        (find-path (first lo-Os) D G)))
                (cond [(boolean? candidate)
                       (find-path/list (rest lo-Os) D G)]
                      [else candidate]))]))

;; ex-472
;; Develop a test for find-path on the inputs 'A, 'G, and sample-graph

(check-expect (find-path 'A 'G gSample) '(A B E F G))

;; Take a look at fig-168.
;; Q: Which path with the function find? Why?
;; A: The function will take the path A, B, E, F, G. This is because
;; of the way the data definition identifies neighboring nodes, and
;; the ordering of these nodes. At B, the function finds next
;; as '(E F), it selects E first, then it computes
;; (find-path 'E 'G sample-graph) which results in '(E F G)


;; Design test-on-all-nodes, a function that consumes a graph g
;; and determines whether there is a path between every pair of nodes.

(require 2htdp/abstraction)

(define gConnected
  '((A (B))
    (B (E))
    (E (A))))

;; Graph -> Boolean
;; #t if there is a path between every pair of nodes in g
(check-expect (test-on-all-nodes gSample) #false)
(check-expect (test-on-all-nodes gConnected) #true)

(define (test-on-all-nodes g)
  (local ((define all-nodes (map first g)))
    (for*/and ([f all-nodes]
               [t all-nodes]) (cons? (find-path f t g)))))

;; For other graphs, however, find-path may not terminate for certain
;; pairs of nodes. Consider the graph in fig-170.

;; Stop! Define cyclic-graph to represent the graph in this figure.

(define cyclic-graph
  '((A (B E))
    (B (E F))
    (C (B D))
    (D ())
    (E (C F))
    (F (D G))
    (G ())))