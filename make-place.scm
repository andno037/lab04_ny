(define (make-place name desc)
  
  (define (delete-an-element! element queue)
  
  (define (skräp? låda)
    (equal? element (mcar låda)))
  
  (let ((denna (mcar queue))
               (ej-ändrad? #t))
    
    (define (iter)
      (cond
        ((and (empty-queue? queue) ej-ändrad?) (error "FUCK YOU queue är tom: " queue))
        ((empty-queue? queue) (display "Ojdå, nu tog listan slut!"))
        ((singelton? queue) 
         (if(skräp? denna)
            (delete-queue! queue)
            (if ej-ändrad?
               (error "Du måste ha skrivit fel eller något, " element " fanns inte med i " queue "!!!"))))
        ((null? (mcdr denna)) (if ej-ändrad?
                                 (error "Elementet fanns troligen inte. Tough luck. -> " queue)
                                 (set-mcdr! queue denna)))
        ((skräp? (mcar queue)) (set-mcar! queue (mcdr denna)) (set! denna (mcdr denna)) (set! ej-ändrad? #f) (iter))
        ((skräp? (mcdr denna)) (set-mcdr! denna (mcdr(mcdr denna))) (set! ej-ändrad? #f) (iter))
        (else (set! denna (mcdr denna)) (iter))))
    (iter)))
;;_______________________________________hitta  
  (define (hitta namn lista)
    ;;(display namn)
    (cond
      ((eq? lista '{}) #f)
      ((eq? (ask (mcar lista)'name)namn)(mcar lista))
      (else (hitta namn (mcdr lista)))))
  ;;___________________________________________for-m
  (define (for-m procedur lista)
 (if(not (eq? lista '{}))
     (begin 
       (procedur (mcar lista)) 
       (for-m procedur (mcdr lista)))))
  ;;--------------------------------------------------
  
  
  ;;-----------------------------------------------make-place 
  (let ( (queue (make-queue)) (exits '()) (items '()) )  
  ;;--------------------------add-neighbhor
    (define add-neighbour-s
      (lambda (self exit target)
          (cond
            ((eq? exit 'up) (set! up target))
            ((eq? exit 'left) (set! left target))
            ((eq? exit 'right) (set! right target))
            ((eq? exit 'down) (set! down target))
            (else (error "FEL! Det går inte!")))))
   ;;--------------------------hej det är nytt
    (define (add-neighbour self exit target)
      (set! exits (cons (cons exit target  ) exits))
      )
    
    ;;-------------------------get-neighbour
    (define get-neighbour-s
      (lambda (self exit)
          (cond
            ((eq? exit 'up) up)
            ((eq? exit 'left) left)
            ((eq? exit 'right) right)
            ((eq? exit 'down) down)
            (else (error "FEL! Det går inte!")))))
    ;;-----------------------------hej det är också nytt
    (define (get-neighbour self exit)
      (if (assq exit exits) (cdr (assq exit exits)) #f))
    
    (define (add-item self tag item)
      (set! items (cons (cons tag item  ) items)))
    
    (define (get-item self tag)
      (if (assq tag items) (cdr (assq tag items)) #f))
    
    (define (remove-item self tag)
     (set! items (filter (lambda (arg) (not(eq? (car arg) tag))) items))
      )
    
    
    (define (self msg)
      (cond
        ((eq? msg 'name) (lambda (self) name))
        ((eq? msg 'description) (lambda (self) desc))
        ((eq? msg 'add-agent!) (lambda (self . value) (insert-queue! (car value) queue)))
        ((eq? msg 'get-agent) (lambda (self . value) (hitta  (car value) (mcar queue))))
        ((eq? msg 'exits) (lambda (self) exits))
        ((eq? msg 'exits_nice) (lambda (self) (display "Du kan gå åt dessa håll: \n")(for-each (lambda (args) (printf "~a ~n" (car args) )) exits)))	
        ((eq? msg 'get-neighbour) get-neighbour)
        ((eq? msg 'add-neighbour) add-neighbour)
        ((eq? msg 'add-item!) add-item)
        ((eq? msg 'get-item) get-item)
        ((eq? msg 'items) (lambda (self) items))
        ((eq? msg 'remove-item!) remove-item)
        ((eq? msg 'delete-agent!_ob) (lambda (self . value) (delete-an-element! (car value) queue)))
        ((eq? msg 'delete-agent!) (lambda (self . value) (delete-an-element! (ask self 'get-agent(car value)) queue)))
        ((eq? msg 'agents) (lambda (self)  (mcar queue)))
        ((eq? msg 'agents_nice) (lambda (self)  (for-m (lambda (agent)(display(ask agent 'name)) (newline)) (mcar queue))))
    ))self))
  
