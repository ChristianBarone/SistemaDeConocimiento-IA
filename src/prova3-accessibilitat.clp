(defmodule MAIN (export ?ALL))

(load "ontologia_Final.clp")
(load "instancias_Ciudad.clp")
(load "instancias_Alojamiento.clp")
(load "instancias_PDI.clp")
(load "instancias_Transporte.clp")
(load "modulo-preguntas.clp")
(load "modulo-abstraccion.clp")
(load "modulo-heuristica.clp")
(load "modulo-refinamiento.clp")
(load "modulo-salida.clp")

;;; definstances crea [usuario1] durant el (reset),
;;; abans que cap regla s'executi

(deffacts PREGUNTAS::usuario-test
    (entrada-completada)
)

(definstances MAIN::test-accesibilidad

    ([usuario1] of Usuario
        (motivo_viaje          "Vacaciones")
        (acompanyants          "Pareja")
        (temporada_viaje       PRIMAVERA)
        (presupuesto_max       3000.0)
        (dias_min              5)
        (dias_max              10)
        (grado_ahorro          2)
        (prioridad_alojamiento 3)
        (ciudades_min          1)
        (ciudades_max          3)
        (ciudad_dias_min       2)
        (ciudad_dias_max       5)
        (nivel_cultural        "Alto")
        (explorador            3)
        (movilidad_reducida    SI)
        (transporte_odiado     NINGUNO)
        (transporte_preferido  AVION)
    )
)

(defrule MAIN::iniciar-test
    (declare (salience 9999))
    (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "=== CASO DE PRUEBA: MOVILIDAD REDUCIDA ===" crlf)
    (printout t "Presupuesto: 3000 EUR | Dias: 5-10 | Ciudades: 1-3" crlf)
    (printout t "Temporada: PRIMAVERA | Movilidad reducida: SI" crlf crlf)
    (focus ABSTRACCION)
)

(reset)
(run)