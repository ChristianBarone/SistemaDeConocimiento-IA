; (defmodule MAIN (export ?ALL))

; (load "ontologia_v2.clp")
; (load "instancias_v2.clp")
; (load "modulo-preguntas.clp")
; (load "modulo-abstraccion.clp")
; (load "modulo-heuristica.clp")

(defrule flujo-principal
   (declare (salience 10))
   =>
   (focus PREGUNTAS ABSTRACCION HEURISTICA REFINAMIENTO SALIDA)
)
