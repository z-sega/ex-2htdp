;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname identity-m) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Row is a list of strictly one 1 and none or many 0s.

; A Matrix is a [List-of Row]

; Number -> Matrix
(define (identityM n)
  (local (; Number Number -> [List-of Row]
          ; build matrix of SIZE, tracking
          ; each row as I
          (define (build-matrix size i)
            (cond
              [(> i size) '()]
              [else
               (cons (build-row size i 1)
                     (build-matrix size (add1 i)))]))
                                   
          ; Number Number Number -> Row
          ; build row of SIZE, tracking:
          ; - each row as I
          ; - each column as J
          (define (build-row size i j)
            (cond
              [(> j size) '()]
              [else
               (cons (if (= i j) 1 0)
                     (build-row size i (add1 j)))])))
    ; - in:
    (build-matrix n 1)))

(identityM 2)

; Number Number -> [List-of Row]
; build matrix of SIZE, tracking
; each row as I
(define (build-matrix size i)
  (cond
    [(> i size) '()]
    [else
     (cons (build-row size i 1)
           (build-matrix size (add1 i)))]))

; Number Number Number -> Row
; build row of SIZE, tracking:
; - each row as I
; - each column as J
(define (build-row size i j)
  (cond
    [(> j size) '()]
    [else
     (cons (if (= i j) 1 0)
           (build-row size i (add1 j)))]))