;;; test_abstraccion.clp — prueba aislada del módulo ABSTRACCION

;;; 1. Carga los módulos necesarios
(load "ontologia.clp")
(load "modulo-preguntas.clp")   ; necesario para importar (entrada-completada)
(load "modulo-abstraccion.clp")

;;; 2. Usuario de prueba hardcodeado — no pasa por PREGUNTAS
(deffacts MAIN::usuario-test
    (entrada-completada)          ; simula que PREGUNTAS ya terminó
)

(definstances MAIN::instancia-test
    ([usuario1] of Usuario
        (motivo_viaje   "Vacaciones")
        (acompanyants   "Amigos")
        (presupuesto_max 1400.0)
        (dias_min       5)
        (dias_max       7)
        (ciudades_min   2)
        (ciudades_max   3)
        (nivel_cultural "Medio")
        (explorador     4)
        (movilidad_reducida FALSE)
        (transporte_odiado "ninguno")
    )
)

;;; 3. Arranca en ABSTRACCION directamente
(defrule MAIN::iniciar
    (declare (salience 1000))
=>
    (focus ABSTRACCION)
)