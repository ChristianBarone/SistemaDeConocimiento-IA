;;; Módulo de abstracción: deriva características del Usuario
;;; Usa hechos auxiliares en lugar de modificar la ontología

(defmodule ABSTRACCION
    (import MAIN ?ALL)
    (import PREGUNTAS ?ALL)   
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. NIVEL DE PRESUPUESTO POR DÍA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI presupuesto/dias_max > 200 ENTONCES nivel-presupuesto = LUJO
(defrule ABSTRACCION::presupuesto-lujo
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (> (/ (nth$ 1 (send ?u get-presupuesto_max))
               (nth$ 1 (send ?u get-dias_max))) 200))
=>
    (assert (nivel-presupuesto LUJO))
)

; SI presupuesto/dias_max entre 100-200 ENTONCES nivel-presupuesto = ALTO
(defrule ABSTRACCION::presupuesto-alto
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (> (/ (nth$ 1 (send ?u get-presupuesto_max))
                    (nth$ 1 (send ?u get-dias_max))) 100)
               (<= (/ (nth$ 1 (send ?u get-presupuesto_max))
                      (nth$ 1 (send ?u get-dias_max))) 200)))
=>
    (assert (nivel-presupuesto ALTO))
)

; SI presupuesto/dias_max entre 50-100 ENTONCES nivel-presupuesto = MEDIO
(defrule ABSTRACCION::presupuesto-medio
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (> (/ (nth$ 1 (send ?u get-presupuesto_max))
                    (nth$ 1 (send ?u get-dias_max))) 50)
               (<= (/ (nth$ 1 (send ?u get-presupuesto_max))
                      (nth$ 1 (send ?u get-dias_max))) 100)))
=>
    (assert (nivel-presupuesto MEDIO))
)

; SI presupuesto/dias_max <= 50 ENTONCES nivel-presupuesto = BAJO
(defrule ABSTRACCION::presupuesto-bajo
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (<= (/ (nth$ 1 (send ?u get-presupuesto_max))
               (nth$ 1 (send ?u get-dias_max))) 50))
=>
    (assert (nivel-presupuesto BAJO))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. TEMÁTICA DEL VIAJE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI motivo = Bodas Y acompaniantes = Pareja → Romantico
(defrule ABSTRACCION::tematica-romantica
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (nth$ 1 (send ?u get-motivo_viaje)) "Bodas"))
    (test (eq (nth$ 1 (send ?u get-acompanyants)) "Pareja"))
=>
    (assert (tematica-deducida Romantico))
)

; SI motivo = Fin_De_Curso → Aventura (independiente del grupo)
(defrule ABSTRACCION::tematica-aventura
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (nth$ 1 (send ?u get-motivo_viaje)) "Fin_De_Curso"))
=>
    (assert (tematica-deducida Aventura))
)

; SI motivo = Negocios → Cultural (ciudades con oferta cultural/empresarial)
(defrule ABSTRACCION::tematica-cultural-negocios
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (nth$ 1 (send ?u get-motivo_viaje)) "Negocios"))
=>
    (assert (tematica-deducida Cultural))
)

; SI motivo = Vacaciones Y acompaniantes = Familia_Con_Ninos → Familiar
(defrule ABSTRACCION::tematica-familiar
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (nth$ 1 (send ?u get-motivo_viaje)) "Vacaciones"))
    (test (eq (nth$ 1 (send ?u get-acompanyants)) "Familia_Con_Ninos"))
=>
    (assert (tematica-deducida Familiar))
)

; SI motivo = Vacaciones Y acompaniantes = Amigos → Ocio
(defrule ABSTRACCION::tematica-ocio
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (nth$ 1 (send ?u get-motivo_viaje)) "Vacaciones"))
    (test (eq (nth$ 1 (send ?u get-acompanyants)) "Amigos"))
=>
    (assert (tematica-deducida Ocio))
)

; SI motivo = Vacaciones Y acompaniantes = Solo/Pareja → Descanso
(defrule ABSTRACCION::tematica-descanso
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (nth$ 1 (send ?u get-motivo_viaje)) "Vacaciones"))
    (test (member$ (nth$ 1 (send ?u get-acompanyants)) (create$ "Solo" "Pareja")))
=>
    (assert (tematica-deducida Descanso))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. PERFIL DE VIAJERO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI explorador >= 4 Y nivel_cultural = Alto → Explorador_Cultural
(defrule ABSTRACCION::perfil-explorador-cultural
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (>= (nth$ 1 (send ?u get-explorador)) 4))
    (test (eq (nth$ 1 (send ?u get-nivel_cultural)) "Alto"))
=>
    (assert (perfil-viajero Explorador_Cultural))
)

; SI explorador >= 4 Y nivel_cultural != Alto → Aventurero
(defrule ABSTRACCION::perfil-aventurero
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (>= (nth$ 1 (send ?u get-explorador)) 4))
    (test (neq (nth$ 1 (send ?u get-nivel_cultural)) "Alto"))
=>
    (assert (perfil-viajero Aventurero))
)

; SI explorador entre 2-3 Y nivel_cultural = Alto → Turista_Cultural
(defrule ABSTRACCION::perfil-turista-cultural
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (>= (nth$ 1 (send ?u get-explorador)) 2)
               (<= (nth$ 1 (send ?u get-explorador)) 3)))
    (test (eq (nth$ 1 (send ?u get-nivel_cultural)) "Alto"))
=>
    (assert (perfil-viajero Turista_Cultural))
)

; SI explorador <= 2 → Turista_Estandar
(defrule ABSTRACCION::perfil-estandar
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (<= (nth$ 1 (send ?u get-explorador)) 2))
=>
    (assert (perfil-viajero Turista_Estandar))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. DURACIÓN DEL VIAJE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI dias_max <= 3 → viaje Corto
(defrule ABSTRACCION::duracion-corta
    (entrada-completada)
    (not (duracion-viaje ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (<= (nth$ 1 (send ?u get-dias_max)) 3))
=>
    (assert (duracion-viaje Corto))
)

; SI dias_max entre 4-7 → viaje Medio
(defrule ABSTRACCION::duracion-media
    (entrada-completada)
    (not (duracion-viaje ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (>= (nth$ 1 (send ?u get-dias_max)) 4)
               (<= (nth$ 1 (send ?u get-dias_max)) 7)))
=>
    (assert (duracion-viaje Medio))
)

; SI dias_max > 7 → viaje Largo
(defrule ABSTRACCION::duracion-larga
    (entrada-completada)
    (not (duracion-viaje ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (> (nth$ 1 (send ?u get-dias_max)) 7))
=>
    (assert (duracion-viaje Largo))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. REGLAS POR DEFECTO (salience -5)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule ABSTRACCION::tematica-defecto
    (declare (salience -5))
    (entrada-completada)
    (not (tematica-deducida ?))
=>
    (assert (tematica-deducida Cultural))
)

(defrule ABSTRACCION::presupuesto-defecto
    (declare (salience -5))
    (entrada-completada)
    (not (nivel-presupuesto ?))
=>
    (assert (nivel-presupuesto MEDIO))
)

(defrule ABSTRACCION::perfil-defecto
    (declare (salience -5))
    (entrada-completada)
    (not (perfil-viajero ?))
=>
    (assert (perfil-viajero Turista_Estandar))
)

(defrule ABSTRACCION::duracion-defecto
    (declare (salience -5))
    (entrada-completada)
    (not (duracion-viaje ?))
=>
    (assert (duracion-viaje Medio))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 6. RESUMEN Y TRANSICIÓN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule ABSTRACCION::pasar-a-heuristica
    (declare (salience -10))
    (tematica-deducida ?tem)
    (nivel-presupuesto  ?pres)
    (perfil-viajero     ?perf)
    (duracion-viaje     ?dur)
=>
    (printout t "--- Abstraccion completada ---" crlf)
    (printout t "  Tematica:    " ?tem  crlf)
    (printout t "  Presupuesto: " ?pres crlf)
    (printout t "  Perfil:      " ?perf crlf)
    (printout t "  Duracion:    " ?dur  crlf crlf)
    (focus HEURISTICA)
)