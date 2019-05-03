;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRACTICA 4 INTELIGENCIA ARTIFICIAL
;;
;; AUTORES:
;; Santiago Valderrabano Zamorano --> santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno     --> martin.delasheras@estudiante.uam.es
;;
;; Grupo 2302
;; Pareja 3
;;
;; Codigo heuristica: FC259
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_fc259
  (:use :common-lisp :conecta4)
  (:export :heuristica :*alias*))
(in-package 2302_P03_fc259)
(defvar *alias* 'ComoLaYerbaHastaQueReviento)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Para esta heuristica, nos hemos basado en el funcionamiento basico del juego.
;; Para ello, hemos ido cogiendo grupos de 4 fichas seguidas en horizontal,
;; vertical, diagonal ascendente y diagonal descendente y guardandolos en
;; 4 variables, una por ficha. Para coger estos grupos hemos practicamente
;; el mismo metodo para todos cambiando los limites de los bucles
;;
;; Para esta segunda parte hemos hecho uso de una
;; funcion auxiliar llamada puntuacion-grupo-4.
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
        (loop for filaCentro from 0 below (1- (tablero-alto tablero)) do
              (setf puntuacion
                (+ puntuacion
                   (if (eql (obtener-ficha tablero 3 filaCentro) ficha-actual)
                       3
                     0))))
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
             (if (eql ficha-nuestra grupo1)
               1
               0)
             (if (eql ficha-nuestra grupo2)
               1
               0)
             (if (eql ficha-nuestra grupo3)
               1
               0)
             (if (eql ficha-nuestra grupo4)
               1
               0)))
    (setf total-oponente
          (+ total-oponente
             (if (eql ficha-op grupo1)
               1
               0)
             (if (eql ficha-op grupo2)
               1
               0)
             (if (eql ficha-op grupo3)
               1
               0)
             (if (eql ficha-op grupo4)
               1
               0)))
    (setf total-vacias
          (+ total-vacias
             (if (null grupo1)
               1
               0)
             (if (null grupo2)
               1
               0)
             (if (null grupo3)
               1
               0)
             (if (null grupo4)
               1
               0)))
    (setf puntuacion
          (+ puntuacion
             (if (and (> total-nuestra 0) (> total-oponente 0))
               (if (and (= total-nuestra 2) (= total-oponente 2))
                 6
                 11)
               (if (> total-nuestra 0)
                 (* (* total-nuestra total-nuestra)(/ 50 0.75))
                 (if (> total-oponente 0)
                   (* (* (/ total-oponente 4) (/ 100 0.75)) -1)
                   0)))))
    puntuacion))
