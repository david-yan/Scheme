; Some utility functions that you may find useful.
(define (apply-to-all proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
            (apply-to-all proc (cdr items)))))

(define (cons-all first rests)
  (apply-to-all (lambda (rest) (cons first rest)) rests))

(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cddr x) (cdr (cdr x)))
(define (cadar x) (car (cdr (car x))))

; Problem 18
;; Turns a list of pairs into a pair of lists
(define (zip pairs)
  (cond 
    ((null? pairs) (list nil nil))
    (else 
      (cons (apply-to-all (lambda (x) (car x)) pairs) (cons (apply-to-all (lambda (x) (car (cdr x))) pairs) nil)))))

(zip '((1 2) (3 4) (5 6)))
; expect ((1 3 5) (2 4 6))
(zip '((1 2)))
; expect ((1) (2))
(zip '())
; expect (() ())

; Problem 19

(define (partitions total part maximum)
  (cond
    ((= total 0) (list nil))
    ((or (< total 0) (<= part 0) (and (< maximum 0) (not (= part 1)))) nil)
    (else 
      (define first (cons-all part (partitions (- total part) part (- part 2))))
      (if (= part maximum) (define second (partitions total (- part 1) (- part 1)))
        (define second (partitions total maximum maximum)))
      (append first second))))

;; List all ways to partition TOTAL without using consecutive numbers.
(define (list-partitions total)
  (partitions total total total)
  )

; For these two tests, any permutation of the right answer will be accepted.
(list-partitions 5)
; expect ((5) (4 1) (3 1 1) (1 1 1 1 1))
(list-partitions 7)
; expect ((7) (6 1) (5 2) (5 1 1) (4 1 1 1) (3 3 1) (3 1 1 1 1) (1 1 1 1 1 1 1))

; Problem 20
;; Returns a function that takes in an expression and checks if it is the special
;; form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (analyze expr)
  (cond ((atom? expr)
         expr
         )
        ((quoted? expr)
         expr
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
           (cons form (cons params (analyze body)))
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
         (define formals (car (zip values)))
         (define args (car (cdr (zip values))))
         (cons (cons 'lambda (cons formals (analyze body))) (analyze args))
           ))
        (else
         (apply-to-all analyze expr)
          )
         )))

(analyze 1)
; expect 1
(analyze 'a)
; expect a
(analyze '(+ 1 2))
; expect (+ 1 2)

;; Quoted expressions remain the same
(analyze '(quote (let ((a 1) (b 2)) (+ a b))))
; expect (quote (let ((a 1) (b 2)) (+ a b)))

;; Lambda parameters not affected, but body affected
(analyze '(lambda (let a b) (+ let a b)))
; expect (lambda (let a b) (+ let a b))
(analyze '(lambda (x) a (let ((a x)) a)))
; expect (lambda (x) a ((lambda (a) a) x))

(analyze '(let ((a 1)
                (b 2))
            (+ a b)))
; expect ((lambda (a b) (+ a b)) 1 2)
(analyze '(let ((a (let ((a 2)) a))
                (b 2))
            (+ a b)))
; expect ((lambda (a b) (+ a b)) ((lambda (a) a) 2) 2)
(analyze '(let ((a 1))
            (let ((b a))
              b)))
; expect ((lambda (a) ((lambda (b) b) a)) 1)
(analyze '(+ 1 (let ((a 1)) a)))
; expect (+ 1 ((lambda (a) a) 1))


;; Problem 21 (optional)
;; Draw the hax image using turtle graphics.
(define (hax d k)
  'YOUR-CODE-HERE
  nil)

