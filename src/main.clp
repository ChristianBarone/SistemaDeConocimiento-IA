(defmodule MAIN
    (export ?ALL)
)

(defrule flujo-principal
   (declare (salience 10))
   =>
   (focus PREGUNTAS ABSTRACCION HEURISTICA REFINAMIENTO SALIDA)
)