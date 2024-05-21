;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-319) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

;; ex-319
;; Design substitute. It consumes an S-expression s and two
;; symbols, old and new. The result is like s with all
;; occurences of old replaced by new.

; S-expr -> S-expr
; replaces all old with new in s
(check-expect (substitute "new" 'a 'b) "new")
(check-expect (substitute 'a 'a 'b) 'b)
(check-expect (substitute '("new" 1 a b) 'a 'b) '("new" 1 b b))
(check-expect (substitute '("new" 1 (deeper a) b) 'a 'b)
              '("new" 1 (deeper b) b))

(define (substitute s old new)
  (local (; S-expr -> S-expr
          ; replaces all old with new in s
          (define (sub-sexp s)
            (cond
              [(atom? s) (sub-atom s)]
              [else (sub-sl s)]))

          ; SL -> SL
          ; replaces all old with new in sl
          (define (sub-sl sl)
            (cond
              [(empty? sl) '()]
              [else (cons (sub-sexp (first sl))
                          (sub-sl (rest sl)))]))

          ; Atom -> Atom
          ; replaces all old with new in at
          (define (sub-atom at)
            (cond
              [(number? at) at]
              [(string? at) at]
              [(symbol? at) (if (symbol=? at old)
                                new
                                at)])))
    (sub-sexp s)))


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