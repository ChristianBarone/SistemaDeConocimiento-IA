(defmodule MAIN (export ?ALL))

(load "ontologia.clp")
(load "instancias.clp")
(load "modulo-preguntas.clp")


;;; Ejecución
(reset)
(focus PREGUNTAS)
(run)
(exit)