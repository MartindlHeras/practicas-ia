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
;; Codigo heuristica: A2B3D
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_a2b3d
  (:use :common-lisp :conecta4)
  (:export :heuristica :*alias*))
(in-package 2302_P03_a2b3d)
(defvar *alias* 'LosYerbajosDelJavide)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Para esta heuristica, nos hemos basado en el funcionamiento basico del juego.
;; Para ello, hemos ido cogiendo grupos de 4 fichas seguidas en horizontal,
;; vertical, diagonal ascendente y diagonal descendente y guardandolos en
;; 4 variables, una por ficha. Para coger estos grupos hemos practicamente
;; el mismo metodo para todos cambiando los limites de los bucles. Y cada vez
;; que obtenemos un grupo de 4 fichas lo mandamos a evaluar a la funcion
;; secundaria puntuacion-grupo-4.
;;
;; Esta primera funcion es igual para el fichero con codigo FC259.
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
                   (if (eql
                        (obtener-ficha tablero 3 filaCentro) ficha-actual)
                       3
                     0))))
        (loop for columnaV from 0 below (1- (tablero-ancho tablero)) do
              (loop for filaV from 0 to 2 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaV filaV))
                           (ficha2
                            (obtener-ficha
                             tablero columnaV (+ 1 filaV)))
                           (ficha3
                            (obtener-ficha
                             tablero columnaV (+ 2 filaV)))
                           (ficha4
                            (obtener-ficha
                             tablero columnaV (+ 3 filaV))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        (loop for filaH from 0 below (1- (tablero-alto tablero)) do
              (loop for columnaH from 0 to 3 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaH filaH))
                           (ficha2
                            (obtener-ficha
                             tablero (+ 1 columnaH) filaH))
                           (ficha3
                            (obtener-ficha
                             tablero (+ 2 columnaH) filaH))
                           (ficha4
                            (obtener-ficha
                             tablero (+ 3 columnaH) filaH)))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        (loop for filaDD from 3 to 5 do
              (loop for columnaDD from 0 to 3 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaDD filaDD))
                           (ficha2
                            (obtener-ficha
                             tablero (+ 1 columnaDD) (- filaDD 1)))
                           (ficha3
                            (obtener-ficha
                             tablero (+ 2 columnaDD) (- filaDD 2)))
                           (ficha4
                            (obtener-ficha
                             tablero (+ 3 columnaDD) (- filaDD 3))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        (loop for filaDA from 0 to 2 do
              (loop for columnaDA from 0 to 3 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaDA filaDA))
                           (ficha2
                            (obtener-ficha
                             tablero (+ 1 columnaDA) (+ 1 filaDA)))
                           (ficha3
                            (obtener-ficha
                             tablero (+ 2 columnaDA) (+ 2 filaDA)))
                           (ficha4
                            (obtener-ficha
                             tablero (+ 3 columnaDA) (+ 3 filaDA))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        puntuacion))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Esta funcion se encarga de analizar los grupos de 4 fichas le que pasa la
;; funcion principal. La idea es dependiendo de la posicion de las fichas
;; calcular cuan bueno o malo es ese movimiento. Para ello, contamos primero
;; cuantas fichas de cada tipo hay (nuestras, oponente, vacias).
;;
;; Consideramos despues los siguientes 4 casos:
;; 1) Que haya 4 fichas nuestras -> Sumamos 100
;; 2) Que haya 3 fichas nuestras y 1 vacia -> Sumamos 5
;; 3) Que haya 2 fichas nuestras y 2 vacia -> Sumamos 2
;; 4) Que haya 3 fichas del oponente y 1 vacia -> Restamos 4
;;
;; Se puede observar que el fc259 y este son variaciones de la forma de valorar
;; los bloques aunque la base es practicamente la misma.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun puntuacion-grupo-4 (ficha1 ficha2 ficha3 ficha4 ficha-nuestra ficha-oponente)
  (let ((puntuacion 0)
        (total-vacias 0)
        (total-nuestra 0)
        (total-oponente 0))
    (setf total-vacias
      (+ total-vacias
         (cond ((null ficha1)
                1)
               (t 0))
         (cond ((null ficha2)
                1)
               (t 0))
         (cond ((null ficha3)
                1)
               (t 0))
         (cond ((null ficha4)
                1)
               (t 0))))
    (setf total-nuestra
      (+ total-nuestra
         (cond ((eql
                 ficha-nuestra ficha1)
                1)
               (t 0))
         (cond ((eql
                 ficha-nuestra ficha2)
                1)
               (t 0))
         (cond ((eql
                 ficha-nuestra ficha3)
                1)
               (t 0))
         (cond ((eql
                 ficha-nuestra ficha4)
                1)
               (t 0))))
    (setf total-oponente
      (+ total-oponente
         (cond ((eql
                 ficha-oponente ficha1)
                1)
               (t 0))
         (cond ((eql
                 ficha-oponente ficha2)
                1)
               (t 0))
         (cond ((eql
                 ficha-oponente ficha3)
                1)
               (t 0))
         (cond ((eql
                 ficha-oponente ficha4)
                1)
               (t 0))))
    (setf puntuacion
      (+ puntuacion
         (cond ((= total-nuestra 4)
                100)
               ((and
                 (= total-nuestra 3) (= total-vacias 1))
                5)
               ((and
                 (= total-nuestra 2) (= total-vacias 2))
                2)
               (t 0))
         (if (and
              (= total-oponente 3) (= total-vacias 1))
             -4
           0)))
    puntuacion))
