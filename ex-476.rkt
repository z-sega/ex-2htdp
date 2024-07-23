;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-476) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-476
;; Finite State Machines poses a problem concerning
;; finite state machines and strings but immediately defers
;; to this chapter because the solution calls for
;; generative recursion. You have now acquired the design
;; knowledge needed to tackle the problem.
;;
;; Design the function fsm-match. It consumes the data
;; representation of a finite state machine and a string.
;; It produces #true if the sequence of characters in the
;; string causes the finite state machine to transition
;; from an initial state to a final state.
;;
;; Since this problem is about the design of recursive
;; functions, we provide the essential data definition
;; and a data example:

(define-struct transition [current key next])
(define-struct fsm [initial transitions final])

;; An FSM is a structure:
;;   (make-fsm FSM-State [List-of 1Transition] FSM-State)
;;
;; A 1Transition is a structure:
;;   (make-transition FSM-State 1String FSM-State)
;;
;; An FSM-State is a String.

(define fsm-a-bc*-d
  (make-fsm "AA"
            (list (make-transition "AA" "a" "BC")
                  (make-transition "BC" "b" "BC")
                  (make-transition "BC" "c" "BC")
                  (make-transition "BC" "d" "DD"))
            "DD"))


(define fsm-a-d
  (make-fsm "AA"
            (list (make-transition "AA" "a" "DD"))
            "DD"))

;; The data example corresponds to the regular expression
;; a (b|c)* d. As mentioned in ex-109, "acbd", "ad", and
;; "abcd" are examples of acceptable strings; "da", "aa",
;; or "d" do not match.
;;
;; Hint:
;; Design the necessary auxiliary function locally to the
;; fsm-match? function. In this context, represent the
;; problem as a pair of parameters: the current state of
;; the finite state machine and the remaining list of
;; 1Strings.

;; FSM String -> Boolean
;; does an-fsm recognize the given string
;; how:
;; checks that an-fsm starts with the first 1s in a-string
;; then recursively checks that each subsequent 1s in
;; (rest (explode a-string)) matches the next subsequent
;; transitions in an-fsm
;; termination:
;; terminates when some corresponding 1s does not match
;; the current state 
(check-expect (fsm-match? fsm-a-d "a") #t)
(check-expect (fsm-match? fsm-a-bc*-d "ad") #t)
(check-expect (fsm-match? fsm-a-bc*-d "abcd") #t)
(check-expect (fsm-match? fsm-a-bc*-d "acbd") #t)
(check-expect (fsm-match? fsm-a-bc*-d "da") #f)
(check-expect (fsm-match? fsm-a-bc*-d "aa") #f)
(check-expect (fsm-match? fsm-a-bc*-d "d") #f)
(check-expect (fsm-match? fsm-a-bc*-d "acbb") #f)

(define (fsm-match? an-fsm a-string)
  (local ((define 1s* (explode a-string))
          (define next
            (next-state an-fsm
                        (fsm-initial an-fsm)
                        (first 1s*)))
             
          ;; FSM-State String -> Boolean
          ;; check an-fsm transitions if the current
          ;; state is matched by the corresponding
          ;; first 1s in 1s*
          (define (rest-match? state 1s*)
            (cond
              [(empty? 1s*)
               (string=? state (fsm-final an-fsm))]
              [else
               (local ((define next
                         (next-state an-fsm
                                     state
                                     (first 1s*))))
                 (and (string? next)
                      (rest-match? next
                                   (rest 1s*))))])))
    (and (string? next)
         (rest-match? next (rest 1s*)))))
         

;; FSM FSM-State 1String -> [Maybe FSM-State]
;; computes the next FSM-State from an-fsm, state and 1s
;; or #false
(check-expect (next-state fsm-a-bc*-d "AA" "a") "BC")
(check-expect (next-state fsm-a-bc*-d "BC" "b") "BC")
(check-expect (next-state fsm-a-bc*-d "BC" "c") "BC")
(check-expect (next-state fsm-a-bc*-d "BC" "d") "DD")
(check-expect (next-state fsm-a-bc*-d "AA" "e") #false)

(define (next-state an-fsm state 1s)
  (local ((define transitions (fsm-transitions an-fsm)))
    (foldr
     (lambda (t rst)
       (if (and
            (string=? 1s (transition-key t))
            (string=? (transition-current t) state))
           (transition-next t)
           rst))
     #false
     transitions)))
