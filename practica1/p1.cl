;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Santiago Valderrabano Zamorano santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno martin.delasheras@estudiante.uam.es
;; Pareja 4
;; Grupo 230
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; producto-escalar-rec (x y)
;;; Calcula el producto escalar de dos vectores
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT: x: vector, representado como una lista
;;;        y: vector, representado como una lista
;;; OUTPUT: producto escalar de x e y
;;;

(defun producto-escalar-rec (x y)
  (if (or (null x) (null y))
    0
    (+ (* (first x) (first y)) (producto-escalar-rec (rest x) (rest y))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cosine-distance (x y)
;;; Aplica la formula de distancia coseno dados numerador y denominador
;;; de la fórmula
;;;
;;; INPUT:  x: numerador
;;;         y: denominador
;;; OUTPUT: distancia coseno entre x e y
;;;

(defun cosine-distance (x y)
    (- 1 (/ x y))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cosine-distance-rec (x y)
;;; Calcula la distancia coseno de un vector de forma recursiva
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT: x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;; OUTPUT: distancia coseno entre x e y
;;;

(defun cosine-distance-rec (x y)
  (if (= 0 (* (producto-escalar-rec x x) (producto-escalar-rec y y)))
    nil
    (cosine-distance (producto-escalar-rec x y) (* (sqrt (producto-escalar-rec x x)) (sqrt (producto-escalar-rec y y)))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cosine-distance-mapcar
;;; Calcula la distancia coseno de un vector usando mapcar
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT:  x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;; OUTPUT: distancia coseno entre x e y
;;;
(defun cosine-distance-mapcar (x y)
  (if (= 0 (* (apply #'+ (mapcar #'* x x)) (apply #'+ (mapcar #'* y y))))
    nil
    (cosine-distance (apply #'+ (mapcar #'* x y)) (* (sqrt (apply #'+ (mapcar #'* x x))) (sqrt (apply #'+ (mapcar #'* y y))))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; order-list-cosine-distance
;;; Inserta en orden segun la semejanza un vector en una lista
;;; INPUT:  reference: vector de referencia para la semejanza
;;;         vector: vector a insertar
;;;         lst-of-vectors: lista de vectores donde se va a insertar el nuevo
;;; OUTPUT: Lista de vectores con el nuevo dentro
;;;

(defun insert-ordered-cosine-distance (reference vector lst-of-vectors)
  (cond ((null vector)
         lst-of-vectors)
        ((null lst-of-vectors)
         (cons vector lst-of-vectors))
        ((< (cosine-distance-mapcar reference vector) (cosine-distance-mapcar reference (first lst-of-vectors)))
         (cons vector lst-of-vectors))
        (t
         (cons (first lst-of-vectors) (insert-ordered-cosine-distance reference vector (rest lst-of-vectors)))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; order-vectors-cosine-distance-rec
;;; Parte recursiva de order-vectors-cosine-distance-rec
;;; INPUT:  vector: vector que representa a una categoria,
;;;                 representado como una lista
;;;         lst-of-vectors vector de vectores
;;;         confidence-level: Nivel de confianza (parametro opcional)
;;; OUTPUT: Vectores cuya semejanza con respecto a la
;;;         categoria es superior al nivel de confianza ,
;;;         ordenados
;;;

(defun order-vectors-cosine-distance-rec (vector lst-of-vectors &optional (confidence-level 0))
  (cond ((null lst-of-vectors)
         nil)
        (t
         (insert-ordered-cosine-distance vector (first lst-of-vectors) (order-vectors-cosine-distance-rec vector (rest lst-of-vectors) confidence-level))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; order-vectors-cosine-distance
;;; Devuelve aquellos vectores similares a una categoria
;;; INPUT:  vector: vector que representa a una categoria,
;;;                 representado como una lista
;;;         lst-of-vectors vector de vectores
;;;         confidence-level: Nivel de confianza (parametro opcional)
;;; OUTPUT: Vectores cuya semejanza con respecto a la
;;;         categoria es superior al nivel de confianza ,
;;;         ordenados
;;;

(defun order-vectors-cosine-distance (vector lst-of-vectors &optional (confidence-level 0))
  (order-vectors-cosine-distance-rec vector
                                     (remove-if (lambda (v) (< (- 1 confidence-level) (cosine-distance-mapcar vector v))) lst-of-vectors)
                                     confidence-level)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-category (categories text distance-measure)
;;; Clasifica al texto en su categoria
;;;
;;; INPUT : categories: vector de vectores, representado como
;;;                     una lista de listas
;;;         texts:      vector
;;;         distance-measure: funcion de distancia
;;; OUTPUT: Par formado por el vector que identifica la categoria
;;;         de menor distancia , junto con el valor de dicha distanciaNUMBER
;;;

(defun get-category (categories text distance-measure minimum)
  (cond ((null categories)
         (list (first (first minimum)) (second minimum)))
        (t
         (if (< (funcall distance-measure text (first categories)) (second minimum))
           (get-category (rest categories) text distance-measure (list (first categories) (funcall distance-measure text (first categories))))
          (get-category (rest categories) text distance-measure minimum))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-vectors-category (categories vectors distance-measure)
;;; Clasifica a los textos en categorias .
;;;
;;; INPUT : categories: vector de vectores, representado como
;;;                     una lista de listas
;;;         texts:      vector de vectores, representado como
;;;                     una lista de listas
;;;         distance-measure: funcion de distancia
;;; OUTPUT: Pares formados por el vector que identifica la categoria
;;;         de menor distancia , junto con el valor de dicha distancia
;;;
;;; (get-vectors-category '((1 43 23 12) (2 33 54 24)) '((1 3 22 134) (2 43 26 58)) #'cosine-distance-mapcar)

(defun get-vectors-category (categories texts distance-measure)
  (cond ((null texts)
         nil)
        (t
         (cons (get-category (rest categories) (first texts) distance-measure (list (first categories) (funcall distance-measure (first texts) (first categories)))) (get-vectors-category categories (rest texts) distance-measure))))
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; newton
;;; Estima el cero de una funcion mediante Newton-Raphson
;;;
;;; INPUT : f: funcion cuyo cero se desea encontrar
;;;         df: derivada de f
;;;         max-iter: maximo numero de iteraciones
;;;         x0: estimacion inicial del cero (semilla)
;;;         tol: tolerancia para convergencia (parametro opcional)
;;; OUTPUT: estimacion del cero de f o NIL si no converge
;;;
;;; (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda(x) (- (* x (- (* x 3) 4)) 11)) 20 3.0)

(defun newton (f df max-iter x0 &optional (tol 0.001))
  (cond ((= max-iter 0)
         nil)
        ((< (abs (funcall f x0)) tol)
         x0)
        (t
         (newton f df (- max-iter 1) (- x0 (/ (funcall f x0) (funcall df x0))) tol)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; one-root-newton
;;; Prueba con distintas semillas iniciales hasta que Newton
;;; converge
;;;
;;; INPUT: f : funcion de la que se desea encontrar un cero
;;;        df : derivada de f
;;;        max-iter : maximo numero de iteraciones
;;;        semillas : semillas con las que invocar a Newton
;;;        tol : tolerancia para convergencia ( parametro opcional )
;;;
;;; OUTPUT: el primer cero de f que se encuentre , o NIL si se diverge
;;;          para todas las semillas
;;;

(defun one-root-newton (f df max-iter semillas &optional (tol 0.001))
  (cond ((null semillas)
         nil)
        ((null (newton f df max-iter (first semillas) tol))
         (one-root-newton f df max-iter (rest semillas) tol))
        (t
         (newton f df max-iter (first semillas) tol)))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; all-roots-newton
;;; Prueba con distintas semillas iniciales y devuelve las raices
;;; encontradas por Newton para dichas semillas
;;;
;;; INPUT: f: funcion de la que se desea encontrar un cero
;;;        df: derivada de f
;;;        max-iter: maximo numero de iteraciones
;;;        semillas: semillas con las que invocar a Newton
;;;        tol : tolerancia para convergencia ( parametro opcional )
;;;
;;; OUTPUT: las raices que se encuentren para cada semilla o nil
;;;          si para esa semilla el metodo no converge
;;;

(defun all-roots-newton (f df max-iter semillas &optional ( tol 0.001))
  (cond ((null semillas)
         nil)
        (t
         (cons (newton f df max-iter (first semillas) tol) (all-roots-newton f df max-iter (rest semillas) tol))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; list-not-nil-roots-newton
;;; Elimina los nil de all-roots-newton
;;;
;;; INPUT: f: funcion de la que se desea encontrar un cero
;;;        df: derivada de f
;;;        max-iter: maximo numero de iteraciones
;;;        semillas: semillas con las que invocar a Newton
;;;        tol : tolerancia para convergencia ( parametro opcional )
;;;
;;; OUTPUT: las raices que se encuentren para cada semilla
;;;

(defun list-not-nil-roots-newton (f df max-iter semillas &optional ( tol 0.001))
   (mapcan #'(lambda (x) (if (null x) nil (list x))) (all-roots-newton f df max-iter semillas tol))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-elt-lst
;;; Combina un elemento dado con todos los elementos de una lista
;;;
;;; INPUT: elem: elemento a combinar
;;;        lst: lista con la que se quiere combinar el elemento
;;;
;;; OUTPUT: lista con las combinacion del elemento con cada uno de
;;;         los de la lista

(defun combine-elt-lst (elt lst)
  (mapcar #'(lambda (x) (list elt x)) lst)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-lst-lst
;;; Calcula el producto cartesiano de dos listas
;;;
;;; INPUT: lst1: primera lista
;;;        lst2: segunda lista
;;;
;;; OUTPUT: producto cartesiano de las dos listas

(defun combine-lst-lst (lst1 lst2)
  (if (null lst1)
    nil
      (append (combine-elt-lst (first lst1) lst2) (combine-lst-lst (rest lst1) lst2)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-list-of-lsts
;;; Calcula todas las posibles disposiciones de elementos
;;; pertenecientes a N listas de forma que en cada disposicion
;;; aparezca unicamente un elemento de cada lista
;;;
;;; INPUT: lstolsts: lista de listas
;;;
;;; OUTPUT: lista con todas las posibles combinaciones de elementos

(defun combine-list-of-lsts (lstolsts)
  (if (null lstolsts)
    (list nil)
    (combine-lst-lst-cons (first lstolsts) (combine-list-of-lsts (rest lstolsts))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-elt-lst-cons
;;; Combina un elemento dado con todos los elementos de una lista usando cons
;;;
;;; INPUT: elem: elemento a combinar
;;;        lst: lista con la que se quiere combinar el elemento
;;;
;;; OUTPUT: lista con las combinacion del elemento con cada uno de los
;;;         de la lista


(defun combine-elt-lst-cons (elt lst)
  (mapcar #'(lambda (x) (cons elt x)) lst)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-lst-lst-cons
;;; Calcula el producto cartesiano de dos listas usando cons
;;;
;;; INPUT: lst1: primera lista
;;;        lst2: segunda lista
;;;
;;; OUTPUT: producto cartesiano de las dos listas

(defun combine-lst-lst-cons (lst1 lst2)
(if (null lst1)
  nil
    (append (combine-elt-lst-cons (first lst1) lst2) (combine-lst-lst-cons (rest lst1) lst2)))
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; defino operadores logicos
(defconstant +bicond+ '<=>)
(defconstant +cond+   '=>)
(defconstant +and+    '^)
(defconstant +or+     'v)
(defconstant +not+    '!)

;; definiciones de valores de verdad, conectores y atomos
(defun truth-value-p (x)
  (or (eql x T) (eql x NIL)))

(defun unary-connector-p (x)
  (eql x +not+))

(defun binary-connector-p (x)
  (or (eql x +bicond+)
      (eql x +cond+)))

(defun n-ary-connector-p (x)
  (or (eql x +and+)
      (eql x +or+)))

(defun bicond-connector-p (x)
  (eql x +bicond+))

(defun cond-connector-p (x)
    (eql x +cond+))

(defun connector-p (x)
  (or (unary-connector-p  x)
      (binary-connector-p x)
      (n-ary-connector-p  x)))

(defun positive-literal-p (x)
  (and (atom x)
       (not (truth-value-p x))
       (not (connector-p x))))

(defun negative-literal-p (x)
  (and (listp x)
       (eql +not+ (first x))
       (null (rest (rest x)))
       (positive-literal-p (second x))))

(defun literal-p (x)
  (or (positive-literal-p x)
      (negative-literal-p x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-neg-and
;;; Recibe una expresion y niega sus términos.s
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es ! ^
;;; OUTPUT : fbf - Lista con los argumentos atomicos negados
;;;

(defun evaluar-neg-and (fbf)
  (if (null (rest fbf))
    (list (list +not+ (first fbf)))
    (append (list (list +not+ (first fbf))) (evaluar-neg-and (rest fbf)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-neg-or
;;; Recibe una expresion y niega sus términos
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es ! v
;;; OUTPUT : fbf - Lista con los argumentos atomicos negados
;;;

(defun evaluar-neg-or (fbf)
  (if (null (rest fbf))
    (list (list +not+ (first fbf)))
    (append (list (list +not+ (first fbf))) (evaluar-neg-or (rest fbf)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-n-ary-neg
;;; Recibe una expresion y evalua a que función
;;; mandar el resto de la fbf dependiendo del
;;; conector que preceda
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar
;;; OUTPUT : fbf - Lista con los argumentos atomicos
;;;

(defun evaluar-n-ary-neg (fbf)
  (cond ((eql (first fbf) +or+)
    (append (list +and+) (evaluar-neg-or (rest fbf))))
   ((eql (first fbf) +and+)
    (append (list +or+) (evaluar-neg-and (rest fbf)))))
   nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-neg-cond
;;; Recibe una expresion y la niega sabiendo que el conector que la
;;  precedia era ! =>
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es ! =>
;;; OUTPUT : fbf - Lista con la fbf negada
;;;

(defun evaluar-neg-cond (fbf)
(if (null fbf)
  nil
  (list +and+ (list +not+ (second fbf)) (first fbf))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-neg-bicond
;;; Recibe una expresion y la niega sabiendo que el conector que la
;;  precedia era ! <=>
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es ! <=>
;;; OUTPUT : fbf - Lista con la fbf negada
;;;

(defun evaluar-neg-bicond (fbf)
  (list +or+ (evaluar-neg-cond fbf) (evaluar-neg-cond (list (second fbf) (first fbf)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-not
;;; Recibe una expresion y la evalua
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es ! y evalua a que funcion la tiene que
;;;                mandar dependiendo del siguiente conector.
;;; OUTPUT : list - Lista con la fbf negada
;;;

(defun evaluar-not (fbf)
  (cond ((unary-connector-p (first fbf))
         (rest fbf))
    ((n-ary-connector-p (first fbf))
         (evaluar-n-ary-neg fbf))
    ((bicond-connector-p (first fbf))
         (evaluar-neg-bicond (rest fbf)))
    ((cond-connector-p (first fbf))
         (evaluar-neg-cond (rest fbf)))
    (t
     (list +not+ (first fbf)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-cond
;;; Recibe una expresion y la evalua
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es =>
;;; OUTPUT : fbf - Lista con la expresion con solo conectores n-arios
;;;          NIL  - En caso de que los elementos sean vacios o NIL
;;;

(defun evaluar-cond (fbf)
  (if (null fbf)
    nil)
  (list +or+ (list +not+ (first fbf)) (second fbf)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar-bicond
;;; Recibe una expresion y la evalua
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar cuyo primer
;;;                conector es <=>
;;; OUTPUT : fbf - Lista con la expresion con solo conectores n-arios
;;;

(defun evaluar-bicond (fbf)
  (list +and+ (evaluar-cond fbf) (evaluar-cond (list (second fbf) (first fbf)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; evaluar
;;; Recibe una expresion y la evalua
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar
;;; OUTPUT : fbf - Lista la formula bien formada con solo conectores
;;;                 n-arios.
;;;

(defun evaluar (fbf)
  (cond ((literal-p fbf)
         fbf)
    ((unary-connector-p (first fbf))  ;; !(expresion)
      (evaluar (evaluar-not (second fbf))))
    ((bicond-connector-p (first fbf))           ;; Bicond
      (evaluar (evaluar-bicond (rest fbf))))
    ((cond-connector-p (first fbf))            ;; Cond
      (evaluar (evaluar-cond (rest fbf))))
    ((or (literal-p (first fbf)) (n-ary-connector-p (first fbf)))
     (cons (first fbf) (mapcar #'(lambda(x) (evaluar x)) (rest fbf))))
    (t
     fbf))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; contradiccion-literales
;;;
;;; Recibe 2 elementos de tipo literal y determina si se contradicen
;;; o no.
;;;
;;; INPUT  : x - Literal
;;;          y - literal
;;; OUTPUT : T -  Si se contradicen
;;;          nil - Si no se contradicen
;;;

(defun contradiccion-literales (x y)
  (if (positive-literal-p x)
      (if (positive-literal-p y)
        nil
        (equal x (second y)))
      (if (negative-literal-p y)
        nil
        (equal (second x) y))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; contradiccion
;;;
;;; Recibe una lista con los literales de una rama y los va comparando
;;; haciendo uso de la función contradiccion-literales y si encuentra
;;; alguna contradiccion devuelve nil, en otro caso devuelve T
;;;
;;; INPUT  : fbf - Lista de atomos a analizar
;;; OUTPUT : T   - Si no encuentra una contradiccion
;;;          N   - Si encuentra alguna contradiccion
;;;

(defun contradiccion (fbf)
    (if (null (rest fbf))
       T
      (if (find T (mapcar #'(lambda (x) (contradiccion-literales x (first fbf))) (rest fbf)))
        nil
        (contradiccion (rest fbf))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; comparar
;;;
;;; Recibe la lista de las listas de cada una de las rama y a partir
;;; de mandar cada rama a contradiccion, decide si el arbol es SAT o
;;; UNSAT
;;;
;;; INPUT  : fbf - Lista de listas de cada rama
;;; OUTPUT : T   - FBF es SAT
;;;          N   - FBF es UNSAT
;;;

(defun comparar (fbf)
  (if (literal-p (first fbf))
         (if (null (rest fbf))
           T
           (contradiccion fbf))
       (or (comparar (first fbf)) (comparar (rest fbf)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; truth-tree-aux
;;;
;;; Recibe una expresion y construye su arbol de verdad dividiendolo en
;;; ramas las cuales devuelve en forma de lista para ser analizadas.
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar.
;;;          ramas - lista de ramas
;;; OUTPUT : lista - Lista que contiene cada lista de cada rama.
;;;

(defun truth-tree-aux (ramas fbf)
  (cond ((eql +and+ fbf)
         ramas)
        ((literal-p fbf)
          (if (null ramas)
            (list fbf)
            (append ramas (list fbf))))
        ((eql +or+ (first fbf))
         (mapcar #'(lambda(x) (truth-tree-aux ramas x)) (rest fbf)))
        ((eql +and+ (first fbf))
         (if (null (second fbf))
           ramas
           (truth-tree-aux (truth-tree-aux ramas (second fbf)) (append (list +and+) (cddr fbf)))))
        (t
          fbf)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; truth-tree
;;; Recibe una expresion y construye su arbol de verdad para
;;; determinar si es SAT o UNSAT
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar.
;;; OUTPUT : T   - FBF es SAT
;;;          N   - FBF es UNSAT
;;;
(defun truth-tree (fbf)
  (comparar (truth-tree-aux '() (evaluar fbf)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; shortest-path-improved
;;; Version de busqueda en anchura que no entra en recursion
;;; infinita cuando el grafo tiene ciclos
;;; INPUT:   end: nodo final
;;;          queue: cola de nodos por explorar
;;;          net: grafo
;;; OUTPUT: camino mas corto entre dos nodos
;;;         nil si no lo encuentra

(defun bfs-improved (end queue net)
  )

(defun shortest-path-improved (end queue net)
  )
