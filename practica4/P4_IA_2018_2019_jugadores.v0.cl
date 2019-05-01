(use-package 'conecta4)

(declaim #+sbcl(sb-ext:muffle-conditions style-warning))

;; -------------------------------------------------------------------------------
;; Funciones de evaluación
;; -------------------------------------------------------------------------------

(defun f-eval-bueno (estado)
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion-actual 0)
            (puntuacion-oponente 0))
        (loop for columna from 0 below (tablero-ancho tablero) do
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-actual columna fila))
                     (izq (contar-izquierda tablero ficha-actual columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
                (setf puntuacion-actual
                  (+ puntuacion-actual
                     (cond ((= abajo 0) 0)
                           ((= abajo 1) 10)
                           ((= abajo 2) 100)
                           ((= abajo 3) 1000)
                           (t 0))
                     (cond ((= der 0) 0)
                           ((= der 1) 10)
                           ((= der 2) 100)
                           ((= der 3) 1000)
                           (t 0))
                     (cond ((= izq 0) 0)
                           ((= izq 1) 10)
                           ((= izq 2) 100)
                           ((= izq 3) 1000)
                           (t 0))
                     (cond ((= abajo-izq 0) 0)
                           ((= abajo-izq 1) 10)
                           ((= abajo-izq 2) 100)
                           ((= abajo-izq 3) 1000)
                           (t 0)))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-oponente columna fila))
                     (der (contar-derecha tablero ficha-oponente columna fila))
                     (izq (contar-izquierda tablero ficha-oponente columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
                (setf puntuacion-oponente
                  (+ puntuacion-oponente
                     (cond ((= abajo 0) 0)
                           ((= abajo 1) 10)
                           ((= abajo 2) 100)
                           ((= abajo 3) 1000)
                           (t 0))
                     (cond ((= der 0) 0)
                           ((= der 1) 10)
                           ((= der 2) 100)
                           ((= der 3) 1000)
                           (t 0))
                     (cond ((= izq 0) 0)
                           ((= izq 1) 10)
                           ((= izq 2) 100)
                           ((= izq 3) 1000)
                           (t 0))
                     (cond ((= abajo-izq 0) 0)
                           ((= abajo-izq 1) 10)
                           ((= abajo-izq 2) 100)
                           ((= abajo-izq 3) 1000)
                           (t 0))))))
        (- puntuacion-actual puntuacion-oponente)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FICHERO ab29a ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun f-eval-ab29a (estado)
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion-actual 0)
            (puntuacion-oponente 0))
        (loop for columna from 0 below (tablero-ancho tablero) do
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-actual columna fila))
                     (arriba (contar-arriba tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-actual columna fila))
                     (izq (contar-izquierda tablero ficha-actual columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila))
                     (horizontal (+ der izq))
                     (vertical (+ abajo arriba))
                     (diag-des (+ abajo-izq arriba-der))
                     (diag-asc (+ abajo-der arriba-izq)))
                (setf puntuacion-actual
                  (+ puntuacion-actual
                    (cond ((= vertical 0) 0)
                          ((= vertical 1) 100)
                          ((= vertical 2) 1000)
                          ((= vertical 3) 2000)
                          (t 0))
                    (cond ((= horizontal 0) 0)
                          ((= horizontal 1) 100)
                          ((= horizontal 2) 1000)
                          ((= horizontal 3) 2000)
                          (t 0))
                    (cond ((= diag-des 0) 0)
                          ((= diag-des 1) 100)
                          ((= diag-des 2) 1000)
                          ((= diag-des 3) 3000)
                          (t 0))
                    (cond ((= diag-asc 0) 0)
                          ((= diag-asc 1) 100)
                          ((= diag-asc 2) 1000)
                          ((= diag-asc 3) 3000)
                          (t 0)))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-oponente columna fila))
                     (arriba (contar-arriba tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-oponente columna fila))
                     (izq (contar-izquierda tablero ficha-oponente columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila))
                     (horizontal (+ der izq))
                     (vertical (+ abajo arriba))
                     (diag-des (+ abajo-izq arriba-der))
                     (diag-asc (+ abajo-der arriba-izq)))
                (setf puntuacion-oponente
                  (+ puntuacion-oponente
                    (cond ((= vertical 0) 0)
                          ((= vertical 1) 20)
                          ((= vertical 2) 200)
                          ((= vertical 3) 7000)
                          (t 0))
                    (cond ((= horizontal 0) 0)
                          ((= horizontal 1) 20)
                          ((= horizontal 2) 200)
                          ((= horizontal 3) 7000)
                          (t 0))
                    (cond ((= diag-des 0) 0)
                          ((= diag-des 1) 20)
                          ((= diag-des 2) 200)
                          ((= diag-des 3) 7000)
                          (t 0))
                    (cond ((= diag-asc 0) 0)
                          ((= diag-asc 1) 20)
                          ((= diag-asc 2) 200)
                          ((= diag-asc 3) 7000)
                          (t 0))))))
        (- puntuacion-actual puntuacion-oponente)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FICHERO fc259 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun f-eval-fc259 (estado)
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion-actual 0))
        (let* ((centro (altura-columna tablero 3))
               (columna2 (altura-columna tablero 2))
               (columna4 (altura-columna tablero 4)))
          (setf puntuacion-actual
            (cond ((< centro 5)
                   (+ centro (/ +val-max+ 2)))
                   ((if (< columna2 4)
                        (if (> columna2 0)
                              (+ columna2 (/ +val-max+ 4))
                              (if (< columna4 4)
                                    (if (> columna4 0)
                                          (+ columna4 (/ +val-max+ 4))
                                          0)))))
                   (t 0))))
        puntuacion-actual))))

(defun contar-columna (tablero ficha-actual ficha-oponente columna fila)
  (if (or (not (dentro-del-tablero-p tablero columna fila))
          (and (not (eql (obtener-ficha tablero columna fila) ficha-actual))
               (not (eql (obtener-ficha tablero columna fila) ficha-oponente))))
      0
    (1+ (contar-columna tablero ficha-actual ficha-oponente columna (1+ fila)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FICHERO a2b3d ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun f-eval-a2b3d (estado)
  ; current player standpoint
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
  (if (juego-terminado-p estado)
      (let ((ganador (ganador estado)))
        (cond ((not ganador) 0)
              ((eql ganador ficha-actual) +val-max+)
              (t +val-min+)))
    (let ((puntuacion 0)
          (horizontal 0)
          (vertical 0)
          (diagonal-desc 0)
          (diagonal-asc 0)
          (centro (contar-columna tablero ficha-actual ficha-oponente 3 0)))
    (loop for filaH from 0 below (tablero-alto tablero) do
      (loop for columnaH from 0 to 3 do
        (setf horizontal
              (+ horizontal
                (contar-grupo4-horizontal tablero ficha-actual ficha-oponente filaH columnaH)))))
    (loop for columnaV from 0 below (tablero-ancho tablero) do
      (loop for filaV from 0 to 2 do
       (setf vertical
             (+ vertical
                (contar-grupo4-vertical tablero ficha-actual ficha-oponente filaV columnaV)))))
    (loop for filaDD from 5 to 3 do
      (loop for columnaDD from 0 to 3 do
        (setf diagonal-desc
             (+ diagonal-desc
                (contar-grupo4-diagonal-desc tablero ficha-actual ficha-oponente filaDD columnaDD)))))
    (loop for filaDA from 0 to 2 do
      (loop for columnaDA from 0 to 3 do
        (setf diagonal-asc
              (+ diagonal-asc
                (contar-grupo4-diagonal-asc tablero ficha-actual ficha-oponente filaDA columnaDA)))))
    (setf puntuacion
      (+ puntuacion
         (* centro 3)
         horizontal
         vertical
         diagonal-desc))
      puntuacion))))

(defun contar-grupo4-vertical (tablero ficha-actual ficha-oponente fila columna)
  (let ((grupo-size 4)
        (total 0)
        (total-oponente 0)
        (total-vacias 0))
  (loop for filaN from fila below (+ grupo-size fila) do
    (cond ((eql (obtener-ficha tablero columna filaN) ficha-actual)
           (+ total 1))
          ((eql (obtener-ficha tablero columna filaN) ficha-oponente)
           (+ total-oponente 1))
          (t (+ total-vacias 1))))
  (cond ((eql total 4) 100)
        ((and (eql total 3) (eql total-vacias 1)) 5)
        ((and (eql total 2) (eql total-vacias 2)) 2)
        ((and (eql total-oponente 3) (eql total-vacias 1)) -4)
        (t 0))))

(defun contar-grupo4-horizontal (tablero ficha-actual ficha-oponente fila columna)
  (let ((grupo-size 4)
        (total 0)
        (total-oponente 0)
        (total-vacias 0))
  (loop for columnaN from columna below (+ grupo-size columna) do
    (cond ((eql (obtener-ficha tablero columnaN fila) ficha-actual)
           (+ total 1))
          ((eql (obtener-ficha tablero columnaN fila) ficha-oponente)
           (+ total-oponente 1))
          (t (+ total-vacias 1))))
  (cond ((eql total 4) 100)
        ((and (eql total 3) (eql total-vacias 1)) 5)
        ((and (eql total 2) (eql total-vacias 2)) 2)
        ((and (eql total-oponente 3) (eql total-vacias 1)) -4)
        (t 0))))

(defun contar-grupo4-diagonal-desc (tablero ficha-actual ficha-oponente fila columna)
  (let ((grupo-size 4)
        (total 0)
        (total-oponente 0)
        (total-vacias 0))
    (loop for columnaN from columna below (+ grupo-size columna) do
      (cond ((eql (obtener-ficha tablero columnaN fila) ficha-actual)
             (+ total 1))
        ((eql (obtener-ficha tablero columnaN fila) ficha-oponente)
         (+ total-oponente 1))
        (t (+ total-vacias 1)))
        (- fila 1))
    (cond ((eql total 4) 100)
      ((and (eql total 3) (eql total-vacias 1)) 5)
      ((and (eql total 2) (eql total-vacias 2)) 2)
      ((and (eql total-oponente 3) (eql total-vacias 1)) -4)
      (t 0))))

(defun contar-grupo4-diagonal-asc (tablero ficha-actual ficha-oponente fila columna)
  (let ((grupo-size 4)
        (total 0)
        (total-oponente 0)
        (total-vacias 0))
    (loop for columnaN from columna below (+ grupo-size columna) do
      (cond ((eql (obtener-ficha tablero columnaN fila) ficha-actual)
             (+ total 1))
        ((eql (obtener-ficha tablero columnaN fila) ficha-oponente)
         (+ total-oponente 1))
        (t (+ total-vacias 1)))
      (+ fila 1))
    (cond ((eql total 4) 100)
      ((and (eql total 3) (eql total-vacias 1)) 5)
      ((and (eql total 2) (eql total-vacias 2)) 2)
      ((and (eql total-oponente 3) (eql total-vacias 1)) -4)
      (t 0))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun heuristica8 (estado)
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
   (ficha-actual (estado-turno estado))
   (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
  (let ((ganador (ganador estado)))
    (cond ((not ganador) 0)
  	((eql ganador ficha-actual) +val-max+)
  	(t +val-min+)))
      (let ((puntuacion 0))
  ;Contamos las fichas en la columna central
  (loop for fila from 0 below (1- (tablero-alto tablero)) do
    (setf puntuacion
          (+ puntuacion
             (if (eql (obtener-ficha tablero 3 fila) ficha-actual)
                 3 0))))
  ;Contamos el numero de bloques horizontales ganadores
  (loop for fila from 0 below (1- (tablero-alto tablero)) do
    (loop for columna from 0 to 3 do
      (let* ((b1 (obtener-ficha tablero columna fila))
             (b2 (obtener-ficha tablero (+ columna 1) fila))
             (b3 (obtener-ficha tablero (+ columna 2) fila))
             (b4 (obtener-ficha tablero (+ columna 3) fila)))
        (setf puntuacion
              (+ puntuacion
                 (evaluarBloque b1 b2 b3 b4 ficha-actual ficha-oponente))))))
   ;Contamos el numero de bloques horizontales ganadores
   (loop for columna from 0 below (1- (tablero-ancho tablero)) do
     (loop for fila from 0 to 2 do
       (let* ((b1 (obtener-ficha tablero columna fila))
              (b2 (obtener-ficha tablero columna (+ 1 fila)))
              (b3 (obtener-ficha tablero columna (+ 2 fila)))
              (b4 (obtener-ficha tablero columna (+ 3 fila))))
         (setf puntuacion
               (+ puntuacion
                  (evaluarBloque b1 b2 b3 b4 ficha-actual ficha-oponente))))))
    ;Contamos el numero de diagonales ascendentes
    (loop for fila from 0 to 2 do
      (loop for columna from 0 to 3 do
        (let* ((b1 (obtener-ficha tablero columna fila))
               (b2 (obtener-ficha tablero (+ 1 columna) (+ 1 fila)))
               (b3 (obtener-ficha tablero (+ 2 columna) (+ 2 fila)))
               (b4 (obtener-ficha tablero (+ 3 columna) (+ 3 fila))))
         (setf puntuacion
               (+ puntuacion
                  (evaluarBloque b1 b2 b3 b4 ficha-actual ficha-oponente))))))

    ;Contamos el numero de diagonales descendentes
    (loop for fila from 3 to 5 do
      (loop for columna from 0 to 3 do
        (let* ((b1 (obtener-ficha tablero columna fila))
               (b2 (obtener-ficha tablero (+ 1 columna) (- fila 1)))
               (b3 (obtener-ficha tablero (+ 2 columna) (- fila 2)))
               (b4 (obtener-ficha tablero (+ 3 columna) (- fila 3))))
         (setf puntuacion
               (+ puntuacion
                  (evaluarBloque b1 b2 b3 b4 ficha-actual ficha-oponente))))))
        puntuacion))))

(defun evaluarBloque (b1 b2 b3 b4 ficha-actual ficha-oponente)
  (let ((fichasNuestras 0)
        (fichasVacias 0)
        (fichasRival 0)
        (score 0))
    (setf fichasNuestras
          (+ fichasNuestras
             (cond ((eql b1 ficha-actual) 1)
                   (t 0))
             (cond ((eql b2 ficha-actual) 1)
                   (t 0))
             (cond ((eql b3 ficha-actual) 1)
                   (t 0))
             (cond ((eql b4 ficha-actual) 1)
                   (t 0))
             ))
     (setf fichasRival
           (+ fichasRival
              (cond ((eql b1 ficha-oponente) 1)
                    (t 0))
              (cond ((eql b2 ficha-oponente) 1)
                    (t 0))
              (cond ((eql b3 ficha-oponente) 1)
                    (t 0))
              (cond ((eql b4 ficha-oponente) 1)
                    (t 0))
              ))
      (setf fichasVacias
            (+ fichasVacias
               (cond ((NULL b1) 1)
                     (t 0))
               (cond ((NULL b2) 1)
                     (t 0))
               (cond ((NULL b3) 1)
                     (t 0))
               (cond ((NULL b4) 1)
                     (t 0))
               ))
      (setf score
            (+ score
               (cond ((= fichasNuestras 4) 100)
                     ((and (= fichasNuestras 3) (= fichasVacias 1)) 5)
                     ((and (= fichasNuestras 2) (= fichasVacias 2)) 2)
                     (t 0))
               (if (and (= fichasRival 3) (= fichasVacias 1))
                    -4 0)))
    score))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRUEBA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun prueba1 (estado)
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion-actual 0)
            (puntuacion-oponente 0))
        (loop for columna from 0 below (tablero-ancho tablero) do
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-actual columna fila))
                     (arriba (contar-arriba tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-actual columna fila))
                     (izq (contar-izquierda tablero ficha-actual columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila))
                     (horizontal (+ der izq))
                     (vertical (+ abajo arriba))
                     (diag-des (+ abajo-izq arriba-der))
                     (diag-asc (+ abajo-der arriba-izq)))
                (setf puntuacion-actual
                  (+ puntuacion-actual
                    (cond ((= vertical 0) 0)
                          ((= vertical 1) 20)
                          ((= vertical 2) 500)
                          ((= vertical 3) 3000)
                          (t 0))
                    (cond ((= horizontal 0) 0)
                          ((= horizontal 1) 20)
                          ((= horizontal 2) 500)
                          ((= horizontal 3) 3000)
                          (t 0))
                    (cond ((= diag-des 0) 0)
                          ((= diag-des 1) 20)
                          ((= diag-des 2) 500)
                          ((= diag-des 3) 3000)
                          (t 0))
                    (cond ((= diag-asc 0) 0)
                          ((= diag-asc 1) 20)
                          ((= diag-asc 2) 500)
                          ((= diag-asc 3) 3000)
                          (t 0)))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-oponente columna fila))
                     (arriba (contar-arriba tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-oponente columna fila))
                     (izq (contar-izquierda tablero ficha-oponente columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila))
                     (horizontal (+ der izq))
                     (vertical (+ abajo arriba))
                     (diag-des (+ abajo-izq arriba-der))
                     (diag-asc (+ abajo-der arriba-izq)))
                (setf puntuacion-oponente
                  (+ puntuacion-oponente
                    (cond ((= vertical 0) 0)
                          ((= vertical 1) 20)
                          ((= vertical 2) 200)
                          ((= vertical 3) 7000)
                          (t 0))
                    (cond ((= horizontal 0) 0)
                          ((= horizontal 1) 20)
                          ((= horizontal 2) 200)
                          ((= horizontal 3) 7000)
                          (t 0))
                    (cond ((= diag-des 0) 0)
                          ((= diag-des 1) 20)
                          ((= diag-des 2) 200)
                          ((= diag-des 3) 7000)
                          (t 0))
                    (cond ((= diag-asc 0) 0)
                          ((= diag-asc 1) 20)
                          ((= diag-asc 2) 200)
                          ((= diag-asc 3) 7000)
                          (t 0))))))
        (- puntuacion-actual puntuacion-oponente)))))


(defun yerbajos (estado)
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion 0))

        ; MIRAMOS CUANTAS FICHAS TENEMOS EN EL LA COLUMNA CENTRAL.
        ; POR CADA FICHA NUESTRA, SUMAMOS 3PTS A LA PUNTUACION.
        (loop for filaCentro from 0 below (1- (tablero-alto tablero)) do
              (setf puntuacion
                (+ puntuacion
                   (if (eql (obtener-ficha tablero 3 filaCentro) ficha-actual)
                       3
                     0))))

        ; FORMAMOS GRUPOS DE 4 FICHAS POR CADA COLUMNA.
        ; EN TOTAL SE FORMAN 3 GRUPOS DE 4 POR COLUMNA.
        ; A CONTINUACION LOS MANDAMOS A EVALUAR A puntuacion-grupos
        (loop for columnaV from 0 below (1- (tablero-ancho tablero)) do
              (loop for filaV from 0 to 2 do
                    (let* ((grupo1 (obtener-ficha tablero columnaV filaV))
                           (grupo2 (obtener-ficha tablero columnaV (+ 1 filaV)))
                           (grupo3 (obtener-ficha tablero columnaV (+ 2 filaV)))
                           (grupo4 (obtener-ficha tablero columnaV (+ 3 filaV))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupos
                            grupo1 grupo2 grupo3 grupo4 ficha-actual ficha-oponente))))))

        ; FORMAMOS GRUPOS DE 4 FICHAS POR CADA FILA.
        ; EN TOTAL SE FORMAN 4 GRUPOS DE 4 POR FILA.
        ; A CONTINUACION LOS MANDAMOS A EVALUAR A puntuacion-grupos
        (loop for filaH from 0 below (1- (tablero-alto tablero)) do
              (loop for columnaH from 0 to 3 do
                    (let* ((grupo1 (obtener-ficha tablero columnaH filaH))
                           (grupo2 (obtener-ficha tablero (+ 1 columnaH) filaH))
                           (grupo3 (obtener-ficha tablero (+ 2 columnaH) filaH))
                           (grupo4 (obtener-ficha tablero (+ 3 columnaH) filaH)))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupos
                            grupo1 grupo2 grupo3 grupo4 ficha-actual ficha-oponente))))))

        ; FORMAMOS TODOS LOS POSBILES GRUPOS DE 4 EN DIAGONAL DESCENDENTE
        ; LOS MANDAMOS A EVALUAR A puntuacion-grupos
        (loop for filaDD from 3 to 5 do
          (loop for columnaDD from 0 to 3 do
            (let* ((grupo1 (obtener-ficha tablero columnaDD filaDD))
                   (grupo2 (obtener-ficha tablero (+ 1 columnaDD) (- filaDD 1)))
                   (grupo3 (obtener-ficha tablero (+ 2 columnaDD) (- filaDD 2)))
                   (grupo4 (obtener-ficha tablero (+ 3 columnaDD) (- filaDD 3))))
              (setf puntuacion
                    (+ puntuacion
                       (puntuacion-grupos
                        grupo1 grupo2 grupo3 grupo4 ficha-actual ficha-oponente))))))

        ; FORMAMOS TODOS LOS POSBILES GRUPOS DE 4 EN DIAGONAL ASCENDENTE
        ; LOS MANDAMOS A EVALUAR A puntuacion-grupos
        (loop for filaDA from 0 to 2 do
              (loop for columnaDA from 0 to 3 do
                    (let* ((grupo1 (obtener-ficha tablero columnaDA filaDA))
                           (grupo2 (obtener-ficha tablero (+ 1 columnaDA) (+ 1 filaDA)))
                           (grupo3 (obtener-ficha tablero (+ 2 columnaDA) (+ 2 filaDA)))
                           (grupo4 (obtener-ficha tablero (+ 3 columnaDA) (+ 3 filaDA))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupos
                            grupo1 grupo2 grupo3 grupo4 ficha-actual ficha-oponente))))))
        puntuacion))))

(defun puntuacion-grupos (grupo1 grupo2 grupo3 grupo4 ficha-nuestra ficha-op)
  (let ((puntuacion 0)
        (total-nuestra 0)
        (total-oponente 0)
        (total-vacias 0))
    (setf total-nuestra
      (+ total-nuestra
         (cond ((eql ficha-nuestra grupo1) 1)
               (t 0))
         (cond ((eql ficha-nuestra grupo2) 1)
               (t 0))
         (cond ((eql ficha-nuestra grupo3) 1)
               (t 0))
         (cond ((eql ficha-nuestra grupo4) 1)
               (t 0))))
    (setf total-oponente
      (+ total-oponente
         (cond ((eql ficha-op grupo1) 1)
               (t 0))
         (cond ((eql ficha-op grupo2) 1)
               (t 0))
         (cond ((eql ficha-op grupo3) 1)
               (t 0))
         (cond ((eql ficha-op grupo4) 1)
               (t 0))))
    (setf total-vacias
      (+ total-vacias
         (cond ((null grupo1) 1)
               (t 0))
         (cond ((null grupo2) 1)
               (t 0))
         (cond ((null grupo3) 1)
               (t 0))
         (cond ((null grupo4) 1)
               (t 0))))
    (setf puntuacion
      (+ puntuacion
         (cond ((= total-nuestra 4) 100)
               ((and (= total-nuestra 3) (= total-vacias 1)) 50)
               ((and (= total-nuestra 2) (= total-vacias 2)) 50)
               (t 0))
         (if (and (= total-oponente 3) (= total-vacias 1))
             -4 0)))
    puntuacion))


;; -------------------------------------------------------------------------------
;; Jugadores
;; -------------------------------------------------------------------------------

(defvar *jugador-aleatorio* (make-jugador :nombre 'Jugador-aleatorio
                                          :f-jugador #'f-jugador-aleatorio
                                          :f-eval  #'f-eval-aleatoria))

(defvar *jugador-bueno* (make-jugador :nombre 'Jugador-bueno
                                      :f-jugador #'f-jugador-negamax
                                      :f-eval  #'f-eval-bueno))

(defvar *jugador-humano* (make-jugador :nombre 'Jugador-humano
                                       :f-jugador #'f-jugador-humano
                                       :f-eval  #'f-no-eval))

(defvar *jugador-ab29a* (make-jugador :nombre 'jugador-ab29a
                                      :f-jugador #'f-jugador-negamax
                                      :f-eval  #'f-eval-ab29a))

(defvar *jugador-fc259* (make-jugador :nombre 'jugador-fc259
                                       :f-jugador #'f-jugador-negamax
                                       :f-eval  #'f-eval-fc259))

(defvar *jugador-a2b3d* (make-jugador :nombre 'jugador-a2b3d
                                       :f-jugador #'f-jugador-negamax
                                       :f-eval  #'f-eval-a2b3d))

(defvar *jugador-sorto* (make-jugador :nombre 'jugador-sorto
                                      :f-jugador #'f-jugador-negamax
                                      :f-eval  #'heuristica8))

(defvar *jugador-yerbajos* (make-jugador :nombre 'jugador-yerbajos
                                      :f-jugador #'f-jugador-negamax
                                      :f-eval  #'yerbajos))

;; -------------------------------------------------------------------------------
;; Algunas partidas de ejemplo:
;; -------------------------------------------------------------------------------

(setf *verbose* t)
;
;(print (partida *jugador-aleatorio* *jugador-aleatorio*))
;(print (partida *jugador-aleatorio* *jugador-bueno* 4))
;(print (partida *jugador-bueno* *jugador-aleatorio* 4))
;(print (partida *jugador-bueno* *jugador-bueno* 4))
;(print (partida *jugador-humano* *jugador-humano*))
;(print (partida *jugador-humano* *jugador-aleatorio* 4))
;(print (partida *jugador-humano* *jugador-bueno* 4))
;(print (partida *jugador-aleatorio* *jugador-humano*))
;(print (partida *jugador-aleatorio* *jugador-burro*))
(print (partida *jugador-sorto* *jugador-yerbajos*))
;
; (defun entrenador (jugador1 jugador2 victorias derrotas empates)
;   (let (x (ganador (partida jugador1 jugador2)))
;     (cond ((not ganadorP) (1+ empates))
;       ((eql ganadorP 0) (1+ victorias))
;       (t (1+ derrotas)))
;     (setf resultado (make-array '(3)))
;     (setf (aref resultado 0) victorias)
;     (setf (aref resultado 1) derrotas)
;     (setf (aref resultado 2) empates))
;   reultado)
;
; (print (entrenador *jugador-sorto* *jugador-sorto* 0 0 0))
;
;
;
; (defun entrenador (jugador1 jugador2 total)
;   (let ((ganador (partida jugador1 jugador2)))
;     (setf total
;           (+ total
;              (cond ((eql ganador 0) 1)
;                    (t 0)))))
;   total)
;
; (defun entrenar (total)
;     (loop for i from 0 to 100 do
;     (setf total
;        (+ total
;           (entrenador *jugador-sorto* *jugador-yerbajos* 0))))
;   total)
;
; (print (entenar 0))
;(print (estado-turno (partida *jugador-sorto* *jugador-yerbajos*)))
