;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-479) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-479
;; Design the threatening? function. It consumes two
;; QPs and determines whether queens placed on the two
;; respective squares would threaten each other.
;;
;; Domain Knowledge:
;; 1. Study fig-172. The queen in this figure threatens
;; all squares on the horizontal, the vertical, and
;; the diagonal lines. Conversely, a queen on any square
;; on these lines threatens the queen.
;;
;; 2. Translate your insights into mathematical conditions
;; that relate the squares' coordinates to each other.
;; For example, all squares on a horizontal have the same
;; y-coordinate. Similarly, all squares on one diagonal
;; have coordinates whose sums are the same. Which
;; diagonal is that? For the other diagonal, the
;; differences between the two coordinates remain the
;; same. Which diagonal does this idea describe?
;;
;; Hint:
;; One you have figured out the domain knowledge,
;; formulate a test suite that covers horizontals,
;; verticals, and diagonals. Don't forget to
;; include arguments for which threatening? must produce
;; #false.

(define QUEENS 8)
;; A QP is a structure:
;;   (make-posn CI CI)
;; A CI is an N in [0, QUEENS).
;; interpretation:
;; (make-posn r c) denotes the square at the
;; r-th row and the c-th column

;; QP QP -> Boolean
;; #true if two queens a and b placed on respective
;; squares would threaten each other.
(check-expect (threatening? (make-posn 6 1)
                            (make-posn 5 2)) #true)
(check-expect (threatening? (make-posn 1 4)
                            (make-posn 3 2)) #true)
(check-expect (threatening? (make-posn 1 4)
                            (make-posn 1 7)) #true)
(check-expect (threatening? (make-posn 1 4)
                            (make-posn 7 4)) #true)
(check-expect (threatening? (make-posn 1 4)
                            (make-posn 3 5)) #false)
(check-expect (threatening? (make-posn 5 6)
                            (make-posn 4 4)) #false)
(check-expect (threatening? (make-posn 2 2)
                            (make-posn 3 0)) #false)

(define (threatening? a b)
  (local ((define r-a (posn-x a))
          (define c-a (posn-y a))
          (define r-b (posn-x b))
          (define c-b (posn-y b))
          
          (define threatening-row? (= r-a r-b))
          (define threatening-column? (= c-a c-b))
          (define threatening-diagonal?
            (local ((define toward-top-left?
                      (= (- r-a c-a)
                         (- r-b c-b)))
                    (define toward-top-right?
                      (= (+ r-a c-a)
                         (+ r-b c-b))))
              (or toward-top-left?
                  toward-top-right?))))
    (or threatening-row?
        threatening-column?
        threatening-diagonal?)))
