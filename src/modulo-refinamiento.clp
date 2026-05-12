;;; Módulo de refinamiento: ajusta la clasificación respetando restricciones

(defmodule REFINAMIENTO
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate REFINAMIENTO::estado-refinamiento
    (slot completado (type SYMBOL) (default TRUE))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; AJUSTE FINAL RESPETANDO RESTRICCIONES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::aplicar-refinamiento
    (not (estado-refinamiento (completado TRUE)))
    ?u <- (object (is-a Usuario)
                  (name [usuario1])
                  (movilidad_reducida ?mov))
=>
    (printout t crlf "--- Refinamiento completado ---" crlf)

    ;; Si hay movilidad reducida, asegurar que accesibilidad-ok == SI
    (if (eq ?mov TRUE)
        then
        (do-for-all-instances ((?cand CandidatoCiudad)) 
                              (eq (send ?cand get-accesibilidad-ok) PARCIAL)
            (send ?cand put-accesibilidad-ok NO)
            (send ?cand put-grado NO_RECOMENDABLE)
            (send ?cand put-motivo "RESTRICCIÓN: Accesibilidad insuficiente para movilidad reducida")
            (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Sin accesibilidad"))
    )

    (assert (estado-refinamiento (completado TRUE)))
    (focus SALIDA)
)
