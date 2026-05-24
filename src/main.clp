(defmodule MAIN (export ?ALL))

;(load "ontologia_v3.clp")
;(load "instancias_v3.clp")
;(load "modulo-preguntas.clp")
;(load "modulo-abstraccion.clp")
;(load "modulo-heuristica.clp")
;(load "modulo-refinamiento.clp")
;(load "modulo-salida.clp")


;(reset)
; (defrule prova
;     (declare (salience 200))
;     (object (is-a Ciudad) (tieneAlojamiento ?lista))
; =>
;     (bind ?aloj (
;     (printout t "nomre = " ?aloj " precio = " (send ?aloj get-precio_noche) crlf)
; )
; (defrule prova2
;     (declare (salience 300))
;     (object (is-a Alojamiento) (name ?aloj))
; =>
;     (printout t "nomre = " (send ?aloj get-nombre) " precio = " (send ?aloj get-precio_noche) crlf)
; )
; (defrule prova3
;     (declare (salience 300))
;     (object (is-a Ciudad) (name ?ciu))
; =>
;     (printout t "nomre = " (send ?ciu get-nombre) " precio = " (send ?ciu get-nivel_vida) crlf)
; )

(defrule flujo-principal
   (declare (salience 10))
   =>
   (focus PREGUNTAS)
)
;(run)
