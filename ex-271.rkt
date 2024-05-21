;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-271) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-271
;; Use ormap to define find-name. The function consumes
;; a name and a list of names. It determines whether
;; any of the names on the latter are equal to or an
;; extension of the former.
(check-expect (find-name "elis" (list "elsa"
                                      "backanon"
                                      "elisium"))
              #t)
(define (find-name n los)
  (local (; String -> Boolean
          ; #t if x contains or extends n
          (define (contains-n? x)
            (string-contains? n x)))
    (ormap contains-n? los)))

;; With andmap you can define a function that checks
;; all names on a list of names that start with the letter
;; "a".
;;
;; Should you use ormap or andmap to define a function
;; the ensures that no name on some list exceeds a given
;; width?
;;
;; -> andmap should be used
;; By definition,
;; (ormap p? l) determines whether p? holds for at least
;; one item in l
;; This is not what we want, we need an abstraction
;; function that checks all items on l
;; Enter (andmap p? l), which determines whether p?
;; holds for all items of l
;; Which is exactly what we need to ensure that all names
;; are shorter than a given width (-> the predicate p)


