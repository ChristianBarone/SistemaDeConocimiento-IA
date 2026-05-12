;;; test-completo.clp
;;; Prueba del flujo completo sin entrada interactiva

(defmodule MAIN (export ?ALL))

(load "ontologia.clp")
(load "modulo-preguntas.clp")
(load "modulo-abstraccion.clp")
(load "modulo-heuristica.clp")
(load "modulo-refinamiento.clp")
(load "modulo-salida.clp")

;;; Usuario de prueba - sin pasar por PREGUNTAS
(deffacts MAIN::usuario-test
    (entrada-completada)
)

(definstances MAIN::test-user
    ([usuario1] of Usuario
        (nombre_usuario     "TestUser")
        (motivo_viaje       "Vacaciones")
        (acompanyants       "Pareja")
        (presupuesto_max    1500.0)
        (dias_min           4)
        (dias_max           7)
        (ciudades_min       2)
        (ciudades_max       3)
        (nivel_cultural     "Medio")
        (explorador         3)
        (movilidad_reducida FALSE)
        (transporte_odiado  "Ninguno")
    )
)

;;; Ejecutar el sistema
(reset)
(printout t "=== INICIANDO FLUJO COMPLETO ===" crlf crlf)
(run)
(printout t crlf "=== FIN DEL FLUJO ===" crlf)
