#lang racket

; arithmetic operations
(+ 2 4)

; define/assign variables
(define var1 3)
(define foo 3)

; define funcs
(define (square x)
    (* x x))

;; using the func
(square 4) ; output: 4^2 = 16
(+ (square 2) (square 3)) ; output: 2^2 + 3^2 = 4 + 9 = 13

; flow control
(define (abs x)
    (if (< x 0) 
        (- x) ; if
        x     ; else
    ))
;; calling abs
(format "AbsFunc result: ~s=~a" '(abs -4) (abs -4))

; list
(define boo (list 9 3 5))
(println boo)
(sort boo <) ; output: (4 5 9)
(length (list 3 4)) ; output: 2

; code and data
(define x (list 1 2 3)) 
(car x) ; gives the first element
(cdr x) ; gives back the other things

(println "")
(println "Cons examples")
(cons "a" "b")
(cons (cons 5 6) 7) ; creates pairs

(define p (cons 1 2))
(car p)
(cdr p)
;; lists are pairs  

(cons 2 null)
(cons 1 (cons 2 null))

;; in lisp/scheme a `list` is a chain of pairs in which the last element is `null`
;; list = (cons 1 (cons 2 cons (3 null)))

;; cdr gives the second item in the pair which is a list in on itself because it ends up with NULL

;; cons sticks things together
;; car gives yu the "head"
;; cdr gives you the "tail"
;; func fact: named after registers of the IBM arquitecure in the 80s something


;; (cadddr v)
;; returns (car (cdr (cdr (cdr v))))
;; in simpler terms this gives the 4th item in the list

; weird recursion
(define (sum vs)
    (if (= 1 (length vs)) 
        (car vs) ; if
        (+  (car vs) ; else: recurse and sum
            (sum (cdr vs))
        ) ; end else
    ) ; end if
) ; end func

(sum (list 2 3))

; meta functions
(define (double value)
    (* 2 value))

(define (apply-twice fn value) 
    (fn (fn value)))

(format "Apply Twice: ~a" (apply-twice double 2)) ; output: 8
;; this is because double is applied twice

(map double (list 3 4 5)) ; output (6, 8, 10)

; weird code as data
(define s (list '+ 4 7))
(println s)

(define ns (make-base-namespace)) ;; required so eval can work form here, namespaces https://docs.racket-lang.org/guide/eval.html
(eval s ns)

(define (switchop a) (cons '* (cdr a)))
(define s2 (switchop s))
(eval s2 ns)


; Cool Stuff
;; Quoting 
'(* 3 6) ;  manipulate this later as code or data
'(foo (bar "a" 3))

;; better names | Valid
; equal?
; boom!
; a*b
; vo-ordinates
; <10
; +

; (define (+ x y) 5)
; (+ 2 2) ; output: 5
;; that is valid

;; duck typing (generics)
(sort (list 5 4 3 2 1) <)
(sort (list "abc" "a" "ab") string<?)

;; lambdas & closures
(map
    (lambda (x) (+ x 1))
    (list 1 2 3)) ; output: (2 3 4)

;; closures
(define (counter)
    (define c 0)                ; body of counter and creation of c
    (lambda ()                  ; return of counter & no inputs to lambda
            (set! c (+ c 1))    ; body
            c                   ; return
    )
)
(define a (counter))
(a)
(a)
(a)

;; metaprogramming
(define (times-n n)
    (lambda (x) (* n x)))
(define times3 (times-n 3))
(define (trpl lst)
    (map times3 lst))


(trpl (list 1 2 3))
(times3 4)
((times-n 3) 4)

; data from functions
(define (mcons a b)
    (lambda (cmd)
            (if (equal? cmd "car")
                a
                b)))

(define (mcar pair)
    (pair "car"))

(define (mcdr pair)
    (pair "cdr"))

(define foo1 (mcons 1 2))
(mcar foo1)
(mcdr foo1)

;; numbers from functions
(define n0 (lambda () null))
(define (minc x) (lambda () x))
(define (mdec x) (x))

(define n1 (minc n0))
(define n2 (minc n1))
(define n3 (minc n2))
(define n4 (minc n3))
(define n5 (minc n4))

(define (mzero? x) (null? (x)))

(define (mequal? x y)
    (cond
        ((mzero? x) (mzero? y))
        ((mzero? y) (mzero? x))
        (else (mequal? (mdec x) (mdec y)))))

(mequal? n1 n0)
(mequal? n1 n1)

(define (m+ x y)
        (if (mzero? y)
            x
            (m+ (minc x) (mdec y)))
)
(mequal? (m+ n0 n2) n2)
(mequal? (m+ n2 n3) n5)
(mequal? (m+ n0 n2) n3)

(let (x y)
    (4))