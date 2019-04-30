
(defun prueba2 (estado)

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
        (+ horizontal (contar-grupo4-horizontal tablero ficha-actual ficha-oponente filaH columnaH))))
    (loop for columnaV from 0 below (tablero-ancho tablero) do
      (loop for filaV from 0 to 2 do
       (+ vertical (contar-grupo4-vertical tablero ficha-actual ficha-oponente filaV columnaV))))
    (loop for filaDD from 5 to 3 do
      (loop for columnaDD from 0 to 3 do
        (+ diagonal-desc (contar-grupo4-diagonal-desc tablero ficha-actual ficha-oponente filaDD columnaDD))))
    (loop for filaDA from 0 to 2 do
      (loop for columnaDA from 0 to 3 do
        (+ diagonal-asc (contar-grupo4-diagonal-asc tablero ficha-actual ficha-oponente filaDA columnaDA))))
    (setf puntuacion
      (+ puntuacion
         (* centro 3)
         horizontal
         vertical
         diagonal-desc))
      puntuacion))))


(defun contar-columna (tablero ficha-actual ficha-oponente columna fila)
  (if (or (not (dentro-del-tablero-p tablero columna fila))
          (and (not (eql (obtener-ficha tablero columna fila) ficha-actual))
               (not (eql (obtener-ficha tablero columna fila) ficha-oponente))))
      0
    (1+ (contar-columna tablero ficha-actual ficha-oponente columna (1+ fila)))))

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
