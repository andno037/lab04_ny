(define (make-agent name desc)
  (let ((current-place #f)(items '()))
    (define (move-to! self new-place)
     (if current-place (ask current-place 'delete-agent! name)) 
     (set! current-place new-place)
     (ask current-place 'add-agent! self))
     
    
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
        ((eq? msg 'place) (lambda (self) current-place))
        ((eq? msg 'add-item!) add-item)
        ((eq? msg 'get-item) get-item)
        ((eq? msg 'items) (lambda (self) items))
        ((eq? msg 'remove-item!) remove-item)
        
        ((eq? msg 'place_nice) (lambda (self) (ask current-place 'name) ))
        ((eq? msg 'move-to!) move-to!)))
    self))