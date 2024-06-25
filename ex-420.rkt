;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-420) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-420
;; JANUS is just a fixed list, but take a look at this
;; function:

; N -> [List-of Number]
;; produces the first n elements of a 
;; mathematical series
(define (oscillate n)
  (local ((define (O i)
            (cond
              [(> i n) '()]
              [else (cons (expt #i-0.99 i)
                          (O (add1 i)))])))
    (O 1)))

; [List-of Number] -> Number
; sum all elements on n* from left to right
(define (sum n*)
  (foldl + 0 n*))

;; Summing its result from left to right computes a
;; different result than from right to left:

(sum (oscillate #i1000.0))
;; !=
(sum (reverse (oscillate #i1000.0)))

;; Again, the difference may appear to be small until
;; we see the context:

(- (* 1e+16 (sum (oscillate #i1000.0)))
   (* 1e+16 (sum (reverse (oscillate #i1000.0)))))

;; Q. Can this difference matter?
;; A. Ofcourse, a difference like this might be dangerous
;; depending on the situation. Take this contrived
;; expression for example:

(local ((define crucial-diff
          (- (* 1e+16
                (sum (oscillate #i1000.0)))
             (* 1e+16
                (sum (reverse (oscillate #i1000.0)))))))
  (cond
    [(> crucial-diff 10) 'kill-all-humans]
    [else 'do-nothing]))

;; Q. Can we trust computers?
;; A. Yes, as long as we know their limitations, and can
;; act accordingly.
