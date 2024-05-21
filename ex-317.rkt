;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-317) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
; An Atom is one of:
; - Number
; - String
; - Symbol

; An S-expr is one of:
; - Atom
; - SL

; An SL is one of:
; - '()
; - (cons S-expr SL)

;; ex-317
;; A program that consists of three connected functions ought
;; to express this relationship with a local expression.
;;
;; Copy and reorganize the program from figure 117 into a
;; single function using local. Validate the revised code
;; with the test suite for count.
;;
;; The second argument to the local functions, sy, never changes.
;; It is always the same as the original symbol. Hence you can
;; eliminate it from the local function definitions to tell
;; the reader that sy is a constant across the traversal
;; process.


; S-expr Symbol -> N
; counts all occurences of sy in sexp
(check-expect (count 'world 'hello) 0)
(check-expect (count '(world hello) 'hello) 1)
(check-expect (count '(((world) hello) hello) 'hello) 2)
(define (count sexp sy)
  (local (; S-expr -> N
          ; counts all occurences of sy in sexp
          (define (count-sexp sexp)
            (cond
              [(atom? sexp) (count-atom sexp)]
              [else (count-sl sexp)]))

          ; SL -> N
          ; counts all occurences of sy in sl
          (define (count-sl sl)
            (cond
              [(empty? sl) 0]
              [else (+ (count-sexp (first sl))
                       (count-sl (rest sl)))]))

          ; Atom -> N
          ; counts all occurences of sy in at
          (define (count-atom at)
            (cond
              [(number? at) 0]
              [(string? at) 0]
              [(symbol? at) (if (symbol=? at sy) 1 0)])))
    (count-sexp sexp)))


; X -> Boolean
; #t if x is an Atom
(check-expect (atom? 19) #t)
(check-expect (atom? "atom") #t)
(check-expect (atom? 'b) #t)
(check-expect (atom? '()) #f)

(define (atom? x)
  (cond
   [(number? x) #true]
   [(string? x) #true]
   [(symbol? x) #true]
   [else #false]))