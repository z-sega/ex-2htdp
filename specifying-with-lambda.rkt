;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname specifying-with-lambda) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
; [X] [List-of X] [X X -> Boolean] -> [List-of X]
; sorts alon0 according to cmp
(check-expect (sort-cmp '("c" "b") string<?) '("b" "c"))
(check-expect (sort-cmp '(2 1 3 4 6 5) <)
              '(1 2 3 4 5 6))

(define (sort-cmp alon0 cmp)
  (local (; [List-of Number] -> [List-of Number]
          ; produces the sorted version of alon
          (define (isort alon)
            (cond
              [(empty? alon) '()]
              [else (insert (first alon)
                            (isort (rest alon)))]))

          ; Number [List-of Number] -> [List-of Number]
          ; inserts n into the sorted list of numbers alon
          (define (insert n alon)
            (cond
              [(empty? alon) (cons n '())]
              [else (if (cmp n (first alon))
                        (cons n alon)
                        (cons (first alon)
                              (insert n (rest alon))))])))
    (isort alon0)))

; [X] [X X -> Boolean] -> [[List-of X] -> Boolean]
; produces a function that determines whether some
; some list is sorted according to cmp
(check-expect [(sorted string<?) '("b" "c")] #true)
(check-expect [(sorted <) '(1 2 3 4 5 6)] #true)
(check-expect [(sorted <) '(1 2 3 43 5 6)] #false)
(check-expect [(sorted <) '()] #true)
(define (sorted cmp)
  (lambda (l0)
    (local ((define (sorted/l l)
              (cond
                [(empty? (rest l)) #true]
                [else (and (cmp (first l) (second l))
                           (sorted/l (rest l)))])))
      (if (empty? l0)
          #true
          (sorted/l l0)))))

; [X] [X X -> Boolean] -> [[List-of X] -> Boolean]
; produces a function that determines whether some
; some list is sorted according to cmp
(check-expect [(sorted.v2 string<?) '("b" "c")] #true)
(check-expect [(sorted.v2 <) '(1 2 3 4 5 6)] #true)
(check-expect [(sorted.v2 <) '(1 2 3 43 5 6)] #false)
(check-expect [(sorted.v2 <) '()] #true)
(define (sorted.v2 cmp)
  (lambda (l0)
     (if (empty? l0)
         #true
         (sorted? cmp l0))))


;; So if we want to check if a list is sorted we know of an
;; additional way to check. The methods are:
;;
;; 1. Check the result of the operation with an expected-result,
;; 2. Check the result using a function that checks if the
;; result is sorted.
;;
;; The benefit of method two is that we can pass additional
;; parameters to such a function. For example, to check
;; whether the result is sorted according to some rule.
;; Another benefit, is that since we are checking a property
;; of the result (the property of being sorted),
;; using the second method we no longer need "expected-results".
;; The results, whatever they are, can be checked using the
;; function that does the checking by passing in the parameters
;; that produced the result.
;; This is function is what is called a SPECIFICATION, more on
;; that later


; [X X -> Boolean] [NEList-of X] -> Boolean
; determines whether l is sorted according to cmp
(check-expect (sorted? < '(1 2 3)) #true)
(check-expect (sorted? < '(2 1 3)) #false)

(define (sorted? cmp l)
  (cond
    [(empty? (rest l)) #true]
    [else (and (cmp (first l) (second l))
               (sorted? cmp (rest l)))]))

;; Consider this function definition:

; [List-of Number][List-of Number]
; lie: produces a sorted version of l
(define (sort-cmp/bad l)
  '(9 8 7 6 5 4 3 2 1 0))

;; To design a predicate that exposes sort-cmp/bad as flawed,
;; we need to understand the purpose of sort-cmp or sorting
;; in general.
;; It clearly is unacceptable to throw away the given list
;; and to prodcue some other list in its place. That's why
;; the purpose statement of isort says that the function
;; "produces a variant of" the given list. "Variant" means
;; the function does not throw away any of the items on the
;; given list.
;; 
;; With these thoughts in mind, we can now say that we
;; want a predicate that checks whether the result is sorted
;; and contains all the items from the given list:

; [X] [List-of X] [X X -> Boolean] -> [[List-of X] -> Boolean]
; is l0 sorted according to cmp
; are all items in list k members of list l0
(check-expect [(sorted-variant-of '(3 2) <) '(2 3)] #true)
(check-expect [(sorted-variant-of '(3 2) <) '(3)] #false)
(define (sorted-variant-of k cmp)
  (lambda (l0)
    (and (sorted? cmp l0)
         (contains? l0 k))))

; [X] [List-of X] [List-of X] -> Boolean
; are all the items in list k members of list l

(check-expect (contains? '(1 2 3) '(1 4 3)) #false)
(check-expect (contains? '(1 2 3 4) '(1 3)) #true)

(define (contains? l k)
  (andmap (lambda (in-k) (member? in-k l)) k))


;; Sadly, sorted-variant-of fails to describe sorting functions
;; properly. Consider this variant of a sorting function:

; [List-of Number] -> [List-of Number]
; produces a sorted version of l
(define (sort-cmp/worse l)
  (local ((define sorted (sort-cmp l <)))
    (cons (- (first sorted) 1)
          sorted)))

;; The function above is used like:
;> (sort-cmp/worse '(1 2 3))
;  (list 0 1 2 3)

;; It is again easy to expose a flaw in the function with
;; a check-expect test that it ought to pass but clearly fails:

(check-expect (sort-cmp/worse '(1 2 3)) '(1 2 3))

;; Surprisingly, a check-satisfied test based on
;; sorted-variant-of succeeds:

(check-satisfied (sort-cmp/worse '(1 2 3))
                 (sorted-variant-of '(1 2 3) <))

;; Indeed, such a test succeeds for any list of numbers, not just
;; '(1 2 3), because the predicate generator merely checks that
;; all the items on the original list are members of the resulting
;; list; it fails to check whether all items on the resulting list
;; are also members of the original list!
;; 
;; The easiet way to add this third check to sorted-variant-of
;; is to add a third sub-expression to the and expression:

(define (sorted-variant-of.v2 k cmp)
  (lambda (l0)
    (and (sorted? cmp l0)
         (contains? l0 k)
         (contains? k l0))))

;; At this point, you may wonder why we are bothering with the
;; development of such a predicate when we can rule out bad
;; sorting functions with plain check-expect tests.
;; 
;; The difference is that check-expect checks only that our
;; sorting functions work on specific lists. With a predicate
;; such as sorted-variant-of.v2, we can articulate the claim
;; that a sorting function works for all possible inputs:

; (define a-list (build-list-of-random-numbers 500))
; (check-satisfied (sort-cmp a-list <)
;                  (sorted-variant-of.v2 a-list <))

;; Let's take a close look at these two lines. The first line
;; generates a list of 500 numbers. Every time you ask DrRacket
;; to evaluate this test, it is likely to generate a list never
;; seen before. The second line is a test case that says sorting
;; this generated list produces a list that:
;; 1. is sorted, 
;; 2. contains all the numbers on the generated list, and
;; 3. contains nothing else.
;; In other words, it is almost like saying that for all
;; possible lists, sort-cmp produces outcomes that
;; sorted-variant-of.v2 blesses.


;; The specification is still flawed if the given list contains
;; duplicate elements. Construct two list of numbers
;; - call them l1 and l2 - such that
;; (check-satisfied l1 (sorted-variant-of.v2 l2 <)) yields #true

(define l1 '(1 2 3 4))
(define l2 '(1 2 2 3 4))
(check-satisfied l1 (sorted-variant-of.v2 l2 <))

;(define l1 '(1 2 2 3 4))
;(define l2 '(1 2 3 4))
;; This set up fails, why? 


;; Computer scientists call sorted-variant-of.v2 a specification
;; of a sorting function. The idea that all lists of numbers pass
;; the above test case is a *theorem* about the relationship
;; betweeen the specification of the sorting function and its
;; implementation.
;; If a programmer can prove this theorem with a mathematical
;; argument, we say that the function is *correct* with respect
;; to its specification. How to prove functions or programs
;; correct is beyond the scope of HTDP, but a good computer
;; science curriculum shows you in a follow-up course how to
;; construct such proofs.
