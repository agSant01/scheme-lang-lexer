; arithmetic operations
(+ 2 #x4f)

; define/assign variables
(define var1 #b0)
(define foo 3)

; define funcs
(define (square x)
    (* x x))

; dummy fun for testing booleans
(define (trueOrFalse val)
    (if val #t #f)
)

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
(format "AbsFunc result: ~s=~a" (abs -4) (abs -4))

; list
(define boo (list 9 3 5))
(println boo)
(sort boo <) ; output: (4 5 9)
(length (list 3 #o4)) ; output: 2

; code and data
(define x (list 1 2 3)) 
(car x) ; gives the first element
(cdr x) ; gives back the other things

(println "")
(println "Cons examples")
(cons "a" "b")
(cons (cons 5 6) 7) ; creates pairs
(define test (list 3 4 5))

; testing comlex numbers
(define complex1 +4-5i)

(define complex3 -24+2i)

; testing the complex numbers of diferenc bases
(define complexOctal #o-24+2i)
(define complexD #d-24+2i)
(define complexBin #b010-001i)
(define complexHex #x-24+2i)

(define float 2.0)
(define signedFloat -2.0)

(define <yupThisIsAnIdentifier>> "Incluiding the '>' and '>>'")

(define decWithExpPositive 42462e-32)
(define decWithExpNegative -42462e-32)

(#o4 "item2" #b0011100 #x32fa)

; testing vectors
#(#f #t 78)

; abbreviation test
(define lisstOfAbbs (list '* `3523 '))

`(list ,(+ 1 2) 4)
(let ((name 'a)) `(list ,name ',name))
`#(10 5 ,(sqrt 4) ,@(map sqrt '(16 9)) 8)
