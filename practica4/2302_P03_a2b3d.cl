;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Santiago Valderrabano Zamorano santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno martin.delasheras@estudiante.uam.es
;; Pareja 3
;; Grupo 2302
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_a2b3d ; se declara un paquete con el grupo, la pareja y
                                   ; el código
         (:use :common-lisp :conecta4)  ; el paquete usa common-lisp y conecta4
         (:export :heuristica :*alias*)) ; exporta la función de evaluación y un alias
(in-package 2302_P03_a2b3d)
(defvar *alias* 'Neto&Gleto) ; alias que aparece en el ranking


(defun heuristica (estado)
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
         (arriba (contar-arriba tablero ficha-oponente columna fila))
         (horizontal (contar-horizontal tablero ficha-actual columna fila))
         (vertical (contar-vertical tablero ficha-actual columna fila))
         (der (contar-derecha tablero ficha-actual columna fila))
         (izq (contar-izquierda tablero ficha-actual columna fila))
         (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
         (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
         (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
         (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
    (setf puntuacion-actual
          (+ puntuacion-actual
       (cond ((= abajo 0) 0)
             ((= abajo 1) 15)
             ((= abajo 2) 200)
             ((= abajo 3) 2000))
       (cond ((= arriba 0) 0)
             ((= arriba 1) 15)
             ((= arriba 2) 200)
             ((= arriba 3) 2000))
       (cond ((= horizontal 0) 0)
             ((= horizontal 1) 15)
             ((= horizontal 2) 200)
             ((= horizontal 3) 2000))
       (cond ((= vertical 0) 0)
             ((= vertical 1) 15)
             ((= vertical 2) 200)
             ((= vertical 3) 2000))
       (cond ((= der 0) 0)
             ((= der 1) 15)
             ((= der 2) 200)
             ((= der 3) 2000))
       (cond ((= izq 0) 0)
             ((= izq 1) 15)
             ((= izq 2) 200)
             ((= izq 3) 2000))
       (cond ((= abajo-izq 0) 0)
             ((= abajo-izq 1) 15)
             ((= abajo-izq 2) 200)
             ((= abajo-izq 3) 2000))
       (cond ((= abajo-der 0) 0)
             ((= abajo-der 1) 15)
             ((= abajo-der 2) 200)
             ((= abajo-der 3) 2000))
       (cond ((= arriba-der 0) 0)
             ((= arriba-der 1) 15)
             ((= arriba-der 2) 200)
             ((= arriba-der 3) 2000))
       (cond ((= arriba-izq 0) 0)
             ((= arriba-izq 1) 15)
             ((= arriba-izq 2) 200)
             ((= arriba-izq 3) 2000)))))
        (let* ((altura (altura-columna tablero columna))
         (fila (1- altura))
         (abajo (contar-abajo tablero ficha-oponente columna fila))
         (arriba (contar-arriba tablero ficha-oponente columna fila))
         (horizontal (contar-horizontal tablero ficha-actual columna fila))
         (vertical (contar-vertical tablero ficha-actual columna fila))
         (der (contar-derecha tablero ficha-oponente columna fila))
         (izq (contar-izquierda tablero ficha-oponente columna fila))
         (diag-des (contar-diagonal-descendente tablero ficha-oponente columna fila))
         (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
         (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
         (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
         (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
    (setf puntuacion-oponente
          (+ puntuacion-oponente
       (cond ((= abajo 0) 0)
             ((= abajo 1) 15)
             ((= abajo 2) 200)
             ((= abajo 3) 1900))
       (cond ((= arriba 0) 0)
             ((= arriba 1) 15)
             ((= arriba 2) 200)
             ((= arriba 3) 1900))
       (cond ((= horizontal 0) 0)
             ((= horizontal 1) 15)
             ((= horizontal 2) 200)
             ((= horizontal 3) 1900))
       (cond ((= vertical 0) 0)
             ((= vertical 1) 15)
             ((= vertical 2) 200)
             ((= vertical 3) 1900))
       (cond ((= der 0) 0)
             ((= der 1) 15)
             ((= der 2) 200)
             ((= der 3) 1900))
       (cond ((= izq 0) 0)
             ((= izq 1) 15)
             ((= izq 2) 200)
             ((= izq 3) 1900))
       (cond ((= diag-des 0) 0)
             ((= diag-des 1) 20)
             ((= diag-des 2) 500)
             ((= diag-des 3) 2000))
       (cond ((= abajo-izq 0) 0)
             ((= abajo-izq 1) 15)
             ((= abajo-izq 2) 200)
             ((= abajo-izq 3) 1900))
       (cond ((= abajo-der 0) 0)
             ((= abajo-der 1) 15)
             ((= abajo-der 2) 200)
             ((= abajo-der 3) 1900))
       (cond ((= arriba-der 0) 0)
             ((= arriba-der 1) 15)
             ((= arriba-der 2) 200)
             ((= arriba-der 3) 1900))
       (cond ((= arriba-izq 0) 0)
             ((= arriba-izq 1) 15)
             ((= arriba-izq 2) 200)
             ((= arriba-izq 3) 1900))))))
  (- puntuacion-actual puntuacion-oponente)))))
