;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-431) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-431
;; Answer the four key questions for the bundle problem
;; and the first three questions for the quick-sort<
;; problem. How many instances of generate-problem are
;; needed?
;;
;; Q: What is a trivially solvable problem?
;; A--bundle: A trivially solvable problem is if
;; s in (bundle s n) is empty.
;;
;; A--quick-sort<: There are two trivially solvable
;; problems: when l in (quick-sort< l) is empty and
;; when l is a single element list, because a single
;; element list is already sorted.
;; 
;; Q: How are trivial problems solved?
;; A--bundle: The solution is if s is empty then return
;; an empty list.
;;
;; A--quick-sort<: When a list is empty then the
;; solution is an empty list, and when it is a single
;; element list then the solution is the same list
;; because a single element list is already sorted.
;;
;; Q: How does the algorithm generate new problems that
;; are more easily solvable than the original one? Is
;; there one new problem that we generate or are there
;; several?
;; A--bundle: The algorithm splits the problem into
;; chunks of n. There is one new problem and it is
;; handled in (bundle (drop s n) n).
;;
;; A--quick-sort<: The algorithm splits the problem
;; into 2 around the pivot. There's the pivot which is
;; the first element in the list, then part-1 which is
;; all elements smaller than the pivot on a sublist
;; (because of the of the direction of the sort) and
;; finally part-2 which is all elements larger than the
;; pivot on another sublist. The algorithm them combines
;; the smaller list, a list containing the pivot
;; (and all elements in the list equal to the pivot),
;; and the larger list together using the append
;; function.
;; 
;; Q: Is the solution of the given problem the same as
;; the solution of (one of) the new problems? Or,
;; do we need to combine the solutions to create a
;; solution for the original problem? And, if so, do
;; we need anything from the original problem data?
;; A--bundle: No the solution of the new problem is not
;; the same. The solution needs to be combined in a list
;; using cons. The only thing needed from the original
;; problem is the original list.
