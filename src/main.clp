(defmodule MAIN
    (export ?ALL)
)

(load "ontologia.clp")
(load "instancias.clp")
(load "modulo-preguntas.clp")
(load "modulo-abstraccion.clp")
(load "modulo-heuristica.clp")
(load "modulo-refinamiento.clp")
(load "modulo-salida.clp")


;;; Ejecución
(reset)
(focus PREGUNTAS)
(run)
(exit)