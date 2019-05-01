;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Santiago Valderrabano Zamorano santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno martin.delasheras@estudiante.uam.es
;; Pareja 3
;; Grupo 2302
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_fc259 ; se declara un paquete con el grupo, la pareja y
  ; el código
  (:use :common-lisp :conecta4)  ; el paquete usa common-lisp y conecta4
  (:export :heuristica :*alias*)) ; exporta la función de evaluación y un alias
(in-package 2302_P03_fc259)
(defvar *alias* 'ComoLaYerbaHastaQueReviento) ; alias que aparece en el ranking

(defun heuristica (estado)
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
