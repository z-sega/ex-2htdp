;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-520) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; PuzzleState -> PuzzleState
; is the final state reachable from state0
; generative: creates a tree of possible boat rides
; termination: ???
#;(check-expect (solve initial-puzzle) final-puzzle)

#;(define (solve state0)
  (local [; [List-of PuzzleState] -> PuzzleState
          ; generative: generates the successors of los
          (define (solve* los)
            (cond
              [(ormap final? los)
               (first (filter final? los))]
              [else
               (solve* (create-next-states los))]))]
    (solve* (list state0))))

;; ex-520
;; The solve* function generates all states reachable
;; with n boat trips before it looks at state that require
;; n + 1 boat trips, even if some of those boat trips
;; return to previously encountered states. Because of
;; this systematic way of traversing the tree, solve*
;; cannot go into an infinite loop. Why?
;;
;; This is because the game-tree has a finite number of
;; states. In the alternate method of checking the
;; alpha-omega of each path one at a time, if one of the
;; intermediate states had already been visited this would
;; lead to an infinite loop. However, in this method,
;; only the states reachable by 1 step is generated,
;; and then for each of those generated steps 1 step is
;; generated (slowly unravelling and never over-investing).
;;
;; An accumulator-function could even be used to speed
;; up the function by skipping subsequent steps for
;; already visited states.

;; Terminalogy: This way of searching a tree or graph is
;; dubbed breadth-first search.