(defmodule MAIN (export ?ALL))

;(load "ontologia_v2.clp")
;(load "instancias_v2.clp")
;(load "modulo-preguntas.clp")
;(load "modulo-abstraccion.clp")
;(load "modulo-heuristica.clp")
;(load "modulo-refinamiento.clp")
;(load "modulo-salida.clp")


;(reset)
(defrule flujo-principal
   (declare (salience 10))
   =>
   (focus PREGUNTAS)
)
;(run)
