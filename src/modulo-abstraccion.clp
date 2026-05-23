(defmodule ABSTRACCION
    (import MAIN ?ALL)
    (import PREGUNTAS ?ALL)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1A. NIVEL DE PRESUPUESTO POR DÍA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI presupuesto/dias_max > 200 ENTONCES nivel-presupuesto = LUJO
(defrule ABSTRACCION::presupuesto-lujo
    (declare (salience 10))
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (> (/ (send ?u get-presupuesto_max)
                (send ?u get-dias_max)) 200))
=>
    (assert (nivel-presupuesto LUJO))
)

; SI presupuesto/dias_max entre 100-200 ENTONCES nivel-presupuesto = ALTO
(defrule ABSTRACCION::presupuesto-alto
    (declare (salience 10))
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (> (/ (send ?u get-presupuesto_max)
                     (send ?u get-dias_max)) 100)
               (<= (/ (send ?u get-presupuesto_max)
                      (send ?u get-dias_max)) 200)))
=>
    (assert (nivel-presupuesto ALTO))
)

; SI presupuesto/dias_max entre 50-100 ENTONCES nivel-presupuesto = MEDIO
(defrule ABSTRACCION::presupuesto-medio
    (declare (salience 10))
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (> (/ (send ?u get-presupuesto_max)
                     (send ?u get-dias_max)) 50)
               (<= (/ (send ?u get-presupuesto_max)
                      (send ?u get-dias_max)) 100)))
=>
    (assert (nivel-presupuesto MEDIO))
)

; SI presupuesto/dias_max <= 50 ENTONCES nivel-presupuesto = BAJO
(defrule ABSTRACCION::presupuesto-bajo
    (declare (salience 10))
    (entrada-completada)
    (not (nivel-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (<= (/ (send ?u get-presupuesto_max)
                 (send ?u get-dias_max)) 50))
=>
    (assert (nivel-presupuesto BAJO))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1B. EXIGENCIA DE AHORRO Y CALIDAD DE ALOJAMIENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI grado_ahorro >= 4 y prioridad_alojamiento <= 3 ENTONCES perfil-presupuesto = MOCHILERO
(defrule ABSTRACCION::perfil-mochilero
    (declare (salience 9))
    (entrada-completada)
    (not (perfil-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (>= (send ?u get-grado_ahorro) 4)
               (<= (send ?u get-prioridad_alojamiento) 3)))
=>
    ; Bajamos precio para ahorrar
    (bind ?valor-ajuste -10)
    (send ?u put-ajuste_ahorro ?valor-ajuste)
    (assert (perfil-presupuesto MOCHILERO))
)

; SI grado_ahorro >= 3 y prioridad_alojamiento >= 4 ENTONCES perfil-presupuesto = EXIGENTE
(defrule ABSTRACCION::perfil-exigente
    (declare (salience 9))
    (entrada-completada)
    (not (perfil-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (>= (send ?u get-grado_ahorro) 3)
               (>= (send ?u get-prioridad_alojamiento) 4)))
=>
    ; Subimos precio alojamiento porque estaremos en un sitio barato
    (bind ?valor-ajuste 15)
    (send ?u put-ajuste_ahorro ?valor-ajuste)
    (assert (perfil-presupuesto EXIGENTE))
)

; SI grado_ahorro <= 2 y prioridad_alojamiento >= 4 ENTONCES perfil-presupuesto = PREMIUM
(defrule ABSTRACCION::perfil-premium
    (declare (salience 9))
    (entrada-completada)
    (not (perfil-presupuesto ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (<= (send ?u get-grado_ahorro) 2)
               (>= (send ?u get-prioridad_alojamiento) 4)))
=>
    ; Subimos precio alojamiento pero no le importa gastar
    (bind ?valor-ajuste 15)
    (send ?u put-ajuste_ahorro ?valor-ajuste)
    (assert (perfil-presupuesto PREMIUM))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. TEMÁTICA DEL VIAJE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI motivo = Bodas Y acompaniantes = Pareja → Romantico
(defrule ABSTRACCION::tematica-romantica
    (declare (salience 10))
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (send ?u get-motivo_viaje) "Bodas"))
    (test (eq (nth$ 1 (send ?u get-acompanyants)) "Pareja"))
=>
    (assert (tematica-deducida Romantico))
)

; SI motivo = Fin_De_Curso → Aventura (independiente del grupo)
(defrule ABSTRACCION::tematica-aventura
    (declare (salience 10))
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (send ?u get-motivo_viaje) "Fin_De_Curso"))
=>
    (assert (tematica-deducida Aventura))
)

; SI motivo = Negocios → Cultural
(defrule ABSTRACCION::tematica-cultural-negocios
    (declare (salience 10))
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (send ?u get-motivo_viaje) "Negocios"))
=>
    (assert (tematica-deducida Cultural))
)

; SI motivo = Vacaciones Y acompaniantes = Familia_Con_Ninos → Familiar
(defrule ABSTRACCION::tematica-familiar
    (declare (salience 10))
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (send ?u get-motivo_viaje) "Vacaciones"))
    (test (eq (nth$ 1 (send ?u get-acompanyants)) "Familia_Con_Ninos"))
=>
    (assert (tematica-deducida Familiar))
)

; SI motivo = Vacaciones Y acompaniantes = Amigos → Ocio
(defrule ABSTRACCION::tematica-ocio
    (declare (salience 10))
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (send ?u get-motivo_viaje) "Vacaciones"))
    (test (eq (nth$ 1 (send ?u get-acompanyants)) "Amigos"))
=>
    (assert (tematica-deducida Ocio))
)

; SI motivo = Vacaciones Y acompaniantes = Solo/Pareja → Descanso
(defrule ABSTRACCION::tematica-descanso
    (declare (salience 10))
    (entrada-completada)
    (not (tematica-deducida ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (eq (send ?u get-motivo_viaje) "Vacaciones"))
    (test (member$ (nth$ 1 (send ?u get-acompanyants)) (create$ "Solo" "Pareja")))
=>
    (assert (tematica-deducida Descanso))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. PERFIL DE VIAJERO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI explorador >= 4 Y nivel_cultural = Alto → Explorador_Cultural
(defrule ABSTRACCION::perfil-explorador-cultural
    (declare (salience 10))
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (>= (send ?u get-explorador) 4))
    (test (eq (send ?u get-nivel_cultural) "Alto"))
=>
    (assert (perfil-viajero Explorador_Cultural))
)

; SI explorador >= 4 Y nivel_cultural != Alto → Aventurero
(defrule ABSTRACCION::perfil-aventurero
    (declare (salience 10))
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (>= (send ?u get-explorador) 4))
    (test (neq (send ?u get-nivel_cultural) "Alto"))
=>
    (assert (perfil-viajero Aventurero))
)

; SI explorador entre 2-3 Y nivel_cultural = Alto → Turista_Cultural
(defrule ABSTRACCION::perfil-turista-cultural
    (declare (salience 10))
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (>= (send ?u get-explorador) 2)
               (<= (send ?u get-explorador) 3)))
    (test (eq (send ?u get-nivel_cultural) "Alto"))
=>
    (assert (perfil-viajero Turista_Cultural))
)

; SI explorador <= 1 → Turista_Estandar
(defrule ABSTRACCION::perfil-estandar
    (declare (salience 10))
    (entrada-completada)
    (not (perfil-viajero ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (<= (send ?u get-explorador) 1))
=>
    (assert (perfil-viajero Turista_Estandar))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. DURACIÓN DEL VIAJE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI dias_max <= 3 → viaje Corto
(defrule ABSTRACCION::duracion-corta
    (declare (salience 10))
    (entrada-completada)
    (not (duracion-viaje ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (<= (send ?u get-dias_max) 3))
=>
    (assert (duracion-viaje Corto))
)

; SI dias_max entre 4-7 → viaje Medio
(defrule ABSTRACCION::duracion-media
    (declare (salience 10))
    (entrada-completada)
    (not (duracion-viaje ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (and (>= (send ?u get-dias_max) 4)
               (<= (send ?u get-dias_max) 7)))
=>
    (assert (duracion-viaje Medio))
)

; SI dias_max > 7 → viaje Largo
(defrule ABSTRACCION::duracion-larga
    (declare (salience 10))
    (entrada-completada)
    (not (duracion-viaje ?))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (> (send ?u get-dias_max) 7))
=>
    (assert (duracion-viaje Largo))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. CARACTERÍSTICAS DE CIUDADES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Si popularidad < 3 entonces popularidad = BAJA
(defrule ABSTRACCION::popularidad-baja
    (declare (salience 10))
    (entrada-completada)
    (not (ciudad-popularidad ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (popularidad ?p))
    (test (< ?p 3))
=>
    (assert (ciudad-popularidad BAJA))
)

; Si popularidad = 3 entonces popularidad = MEDIA
(defrule ABSTRACCION::popularidad-media
    (declare (salience 10))
    (entrada-completada)
    (not (ciudad-popularidad ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (popularidad 3))
=>
    (assert (ciudad-popularidad MEDIA))
)

; Si popularidad > 3 entonces popularidad = ALTA
(defrule ABSTRACCION::popularidad-alta
    (declare (salience 10))
    (entrada-completada)
    (not (ciudad-popularidad ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (popularidad ?p))
    (test (> ?p 3))
=>
    (assert (ciudad-popularidad ALTA))
)

(defrule ABSTRACCION::primavera-baja
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-primavera ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_primavera ?v))
    (test (< ?v 3))
=>
    (assert (ciudad-primavera BAJA))
)

(defrule ABSTRACCION::primavera-media
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-primavera ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_primavera 3))
=>
    (assert (ciudad-primavera MEDIA))
)

(defrule ABSTRACCION::primavera-alta
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-primavera ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_primavera ?v))
    (test (> ?v 3))
=>
    (assert (ciudad-primavera ALTA))
)

(defrule ABSTRACCION::verano-baja
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-verano ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_verano ?v))
    (test (< ?v 3))
=>
    (assert (ciudad-verano BAJA))
)

(defrule ABSTRACCION::verano-media
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-verano ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_verano 3))
=>
    (assert (ciudad-verano MEDIA))
)

(defrule ABSTRACCION::verano-alta
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-verano ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_verano ?v))
    (test (> ?v 3))
=>
    (assert (ciudad-verano ALTA))
)

(defrule ABSTRACCION::otono-baja
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-otono ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_otono ?v))
    (test (< ?v 3))
=>
    (assert (ciudad-otono BAJA))
)

(defrule ABSTRACCION::otono-media
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-otono ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_otono 3))
=>
    (assert (ciudad-otono MEDIA))
)

(defrule ABSTRACCION::otono-alta
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-otono ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_otono ?v))
    (test (> ?v 3))
=>
    (assert (ciudad-otono ALTA))
)

(defrule ABSTRACCION::invierno-baja
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-invierno ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_invierno ?v))
    (test (< ?v 3))
=>
    (assert (ciudad-invierno BAJA))
)

(defrule ABSTRACCION::invierno-media
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-invierno ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_invierno 3))
=>
    (assert (ciudad-invierno MEDIA))
)

(defrule ABSTRACCION::invierno-alta
    (declare (salience 9))
    (entrada-completada)
    (not (ciudad-invierno ?)
    ?c <- (object (is-a Ciudad) (name [ciudad1]) (valoracion_invierno ?v))
    (test (> ?v 3))
=>
    (assert (ciudad-invierno ALTA))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 6. REGLAS POR DEFECTO (salience -5)
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

(defrule ABSTRACCION::perfil-presupuesto-defecto
    (declare (salience -5))
    (entrada-completada)
    (not (perfil-presupuesto ?))
=>
    (assert (perfil-presupuesto EQUILIBRADO))
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
    (nivel-presupuesto ?pres)
    (perfil-viajero ?perf)
    (duracion-viaje ?dur)
=>
    (printout t "--- Abstraccion completada ---" crlf)
    (printout t "  Tematica:    " ?tem  crlf)
    (printout t "  Presupuesto: " ?pres crlf)
    (printout t "  Perfil:      " ?perf crlf)
    (printout t "  Duracion:    " ?dur  crlf crlf)
    (focus HEURISTICA)
)
