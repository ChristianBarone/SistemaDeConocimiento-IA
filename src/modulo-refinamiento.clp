;;; Módulo de refinamiento:
;;;   - aplica el ajuste final de restricciones
;;;   - genera viajes candidatos válidos a partir de CandidatoCiudad
;;;   - puntúa cada viaje
;;;   - elige el mejor
;;;   - deja marcada la solución para que SALIDA la imprima

(defmodule REFINAMIENTO
    (import MAIN ?ALL)
    (import HEURISTICA ?ALL)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CONTROL DEL MÓDULO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate REFINAMIENTO::estado-refinamiento
    (slot fase (type SYMBOL))
)

(deftemplate REFINAMIENTO::viaje-base-creado
    (slot ciudad (type INSTANCE))
)

(deftemplate REFINAMIENTO::expansion-creada
    (slot viaje (type INSTANCE))
    (slot ciudad (type INSTANCE))
)

(deftemplate REFINAMIENTO::viaje-seleccionado
    (slot id (type INSTANCE))
    (slot ranking (type INTEGER))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FUNCIONES AUXILIARES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction REFINAMIENTO::ciudad-en-lista (?ciu $?lista)
    (return (neq (member$ ?ciu ?lista) FALSE))
)

(deffunction REFINAMIENTO::ultimo-elemento ($?lista)
    (if (= (length$ ?lista) 0)
        then
            (return FALSE)
        else
            (return (nth$ (length$ ?lista) ?lista)))
)

(deffunction REFINAMIENTO::mejor-alojamiento (?ciu)
    (bind ?lista (send ?ciu get-tieneAlojamiento))
    (if (= (length$ ?lista) 0)
        then
            (return FALSE))

    (bind ?mejor FALSE)
    (bind ?precioMejor 999999.0)

    (loop-for-count (?i 1 (length$ ?lista)) do
        (bind ?a (nth$ ?i ?lista))
        (if (instance-existp ?a)
            then
                (bind ?p_raw (send ?a get-precio_noche))
                ;; Comprobamos si el precio es un número válido
                (if (numberp ?p_raw)
                    then
                        (bind ?p (float ?p_raw))
                        (if (< ?p ?precioMejor)
                            then
                                (bind ?mejor ?a)
                                (bind ?precioMejor ?p)))
        )
    )
    (return ?mejor)
)

(deffunction REFINAMIENTO::dias-objetivo-viaje (?nCiudades)
    (bind ?dmin (send [usuario1] get-dias_min))
    (bind ?dmax (send [usuario1] get-dias_max))
    (bind ?cmax (send [usuario1] get-ciudades_max))

    (bind ?base (max 1 (integer (/ ?dmax (max 1 ?cmax)))))
    (bind ?diasEstimados (* ?nCiudades ?base))

    (if (< ?diasEstimados ?dmin)
        then (bind ?diasEstimados ?dmin))
    (if (> ?diasEstimados ?dmax)
        then (bind ?diasEstimados ?dmax))

    (return ?diasEstimados)
)

(deffunction REFINAMIENTO::coste-ciudad (?ciu ?diasPorCiudad)
    (bind ?aloj (mejor-alojamiento ?ciu))
    (bind ?precioAloj
        (if (eq ?aloj FALSE)
            then 0.0
            else (float (send ?aloj get-precio_noche))))

    (bind ?nv_raw (send ?ciu get-nivel_de_vida))
    (bind ?nivelVida (if (numberp ?nv_raw) then (float ?nv_raw) else 1.0))

    (return (+ (* (float ?diasPorCiudad) ?precioAloj)
               (* 25.0 ?nivelVida)))
)

(deffunction REFINAMIENTO::coste-viaje ($?ciudades)
    (bind ?n (length$ ?ciudades))
    (if (= ?n 0)
        then
            (return 0.0))

    (bind ?diasTotales (dias-objetivo-viaje ?n))
    (bind ?diasPorCiudad (max 1 (integer (/ ?diasTotales ?n))))
    (bind ?total 0.0)

    (loop-for-count (?i 1 ?n) do
        (bind ?ciu (nth$ ?i ?ciudades))
        (bind ?total (+ ?total (coste-ciudad ?ciu ?diasPorCiudad)))
    )

    (return ?total)
)

(deffunction REFINAMIENTO::lista-alojamientos ($?ciudades)
    (bind ?res (create$))
    (loop-for-count (?i 1 (length$ ?ciudades)) do
        (bind ?ciu (nth$ ?i ?ciudades))
        (bind ?a (mejor-alojamiento ?ciu))
        (if (neq ?a FALSE)
            then
                (bind ?res (create$ ?res ?a)))
    )
    (return ?res)
)

(deffunction REFINAMIENTO::normalizar-nombre (?valor)
    (bind ?str (str-cat ?valor))
    (if (and (str-index "[" ?str) (str-index "]" ?str))
        then
            (bind ?str (sub-string (+ (str-index "[" ?str) 1) (- (str-index "]" ?str) 1) ?str)))
    (if (str-index "::" ?str)
        then
            (bind ?str (sub-string (+ (str-index "::" ?str) 2) (length$ ?str) ?str)))
    (return (upcase ?str))
)

(deffunction REFINAMIENTO::hay-transporte-permitido (?origen ?destino)
    (bind ?prohibido (send [usuario1] get-transporte_odiado))
    (bind ?norm-origen (REFINAMIENTO::normalizar-nombre ?origen))
    (bind ?norm-destino (REFINAMIENTO::normalizar-nombre ?destino))

    (printout t "--------------------------------------------------------" crlf)
    (printout t "🔍 DEBUG VIAJE: Intentando conectar " ?origen " con " ?destino crlf)
    (printout t "   Normalizados a: " ?norm-origen " -> " ?norm-destino crlf)

    ;; Buscamos las instancias de transporte
    (bind ?transportes (find-all-instances ((?t Transporte)) TRUE))
    (printout t "   [Ontología] Transportes totales encontrados: " (length$ ?transportes) crlf)

    (loop-for-count (?i 1 (length$ ?transportes)) do
        (bind ?t (nth$ ?i ?transportes))

        (if (not (and (neq ?prohibido "")
                      (neq ?prohibido "Ninguno")
                      (eq (send ?t get-tipo) ?prohibido)))
         then
            (bind ?ori-slot (send ?t get-tieneOrigen))
            (bind ?des-slot (send ?t get-tieneFin))

            (bind ?lista-ori (if (multifieldp ?ori-slot) then ?ori-slot else (create$ ?ori-slot)))
            (bind ?lista-des (if (multifieldp ?des-slot) then ?des-slot else (create$ ?des-slot)))

            ;; Imprimimos los primeros 3 transportes para ver qué estructura interna tienen
            (if (<= ?i 3) then
                (printout t "   ↳ Evaluando " (instance-name ?t) " | Origen ontología: " ?ori-slot " | Destino ontología: " ?des-slot crlf)
            )

            (bind ?ori-ok FALSE)
            (loop-for-count (?j 1 (length$ ?lista-ori)) do
                (if (eq (REFINAMIENTO::normalizar-nombre (nth$ ?j ?lista-ori)) ?norm-origen)
                    then (bind ?ori-ok TRUE) (break)))

            (bind ?des-ok FALSE)
            (loop-for-count (?j 1 (length$ ?lista-des)) do
                (if (eq (REFINAMIENTO::normalizar-nombre (nth$ ?j ?lista-des)) ?norm-destino)
                    then (bind ?des-ok TRUE) (break)))

            (if (and ?ori-ok ?des-ok)
                then
                (printout t "   ✅ ¡CONEXIÓN ENCONTRADA EXTRAVAGANTE! Usando: " (instance-name ?t) crlf)
                (return TRUE))
        )
    )
    (printout t "   ❌ No hay ruta directa entre estas dos ciudades." crlf)
    (return FALSE)
)

(deffunction REFINAMIENTO::puntos-grado (?g)
    (if (eq ?g MUY_RECOMENDABLE) then (return 60))
    (if (eq ?g ADECUADO) then (return 35))
    (if (eq ?g PARCIALMENTE_ADECUADO) then (return 12))
    (return -100)
)

(deffunction REFINAMIENTO::puntos-tematica (?t)
    (if (eq ?t SI) then (return 20))
    (if (eq ?t PARCIAL) then (return 8))
    (return -25)
)

(deffunction REFINAMIENTO::puntos-presupuesto (?p)
    (if (eq ?p SI) then (return 15))
    (if (eq ?p PARCIAL) then (return 5))
    (return -40)
)

(deffunction REFINAMIENTO::puntos-accesibilidad (?a)
    (if (eq ?a SI) then (return 10))
    (if (eq ?a PARCIAL) then (return 3))
    (return -30)
)

(deffunction REFINAMIENTO::puntos-candidato-ciudad (?cand)
    (bind ?score 0)

    (bind ?score (+ ?score (puntos-grado (send ?cand get-grado))))
    (bind ?score (+ ?score (puntos-tematica (send ?cand get-tematica_ok))))
    (bind ?score (+ ?score (puntos-presupuesto (send ?cand get-presupuesto_ok))))
    (bind ?score (+ ?score (puntos-accesibilidad (send ?cand get-accesibilidad_ok))))

    (if (eq (send ?cand get-transporte_ok) SI)
        then (bind ?score (+ ?score 10))
        else (bind ?score (- ?score 40)))

    (bind ?score (+ ?score (* 3 (length$ (send ?cand get-ventajas)))))
    (bind ?score (- ?score (* 4 (length$ (send ?cand get-desventajas)))))

    (return ?score)
)

(deffunction REFINAMIENTO::puntos-viaje ($?ciudades)
    (bind ?score 0)
    (bind ?n (length$ ?ciudades))

    (loop-for-count (?i 1 ?n) do
        (bind ?ciu (nth$ ?i ?ciudades))
        (bind ?cand-list
            (find-all-instances ((?cand CandidatoCiudad))
                (eq (send ?cand get-ciudad) ?ciu)))

        (if (> (length$ ?cand-list) 0)
            then
                (bind ?cand (nth$ 1 ?cand-list))
                (bind ?score (+ ?score (puntos-candidato-ciudad ?cand))))
    )

    ; bonus por viajes más completos dentro del rango del usuario
    (if (>= ?n (send [usuario1] get-ciudades_min))
        then (bind ?score (+ ?score 15)))

    (if (= ?n (send [usuario1] get-ciudades_max))
        then (bind ?score (+ ?score 5)))

    ; bonus por enlaces válidos entre ciudades
    (if (> ?n 1)
        then
            (loop-for-count (?i 2 ?n) do
                (bind ?ori (nth$ (- ?i 1) ?ciudades))
                (bind ?des (nth$ ?i ?ciudades))
                (if (hay-transporte-permitido ?ori ?des)
                    then (bind ?score (+ ?score 8))
                    else (bind ?score (- ?score 50))))
    )

    ; penalización si se acerca demasiado al presupuesto máximo
    (bind ?coste (coste-viaje ?ciudades))
    (bind ?presMax (float (send [usuario1] get-presupuesto_max)))
    (if (> ?coste ?presMax)
        then
            (bind ?score (- ?score 200))
        else
            (if (> ?coste (* 0.9 ?presMax))
                then (bind ?score (- ?score 10))
                else (bind ?score (+ ?score 10))))

    (return ?score)
)

(deffunction REFINAMIENTO::viaje-valido ($?ciudades)
    (bind ?n (length$ ?ciudades))
    (bind ?dias (dias-objetivo-viaje ?n))
    (bind ?precio (coste-viaje ?ciudades))

    (if (< ?n (send [usuario1] get-ciudades_min))
        then (return FALSE))
    (if (> ?n (send [usuario1] get-ciudades_max))
        then (return FALSE))
    (if (< ?dias (send [usuario1] get-dias_min))
        then (return FALSE))
    (if (> ?dias (send [usuario1] get-dias_max))
        then (return FALSE))
    (if (> ?precio (float (send [usuario1] get-presupuesto_max)))
        then (return FALSE))

    ; comprobar conectividad entre ciudades consecutivas
    (if (> ?n 1)
        then
            (loop-for-count (?i 2 ?n) do
                (bind ?ori (nth$ (- ?i 1) ?ciudades))
                (bind ?des (nth$ ?i ?ciudades))
                (if (not (hay-transporte-permitido ?ori ?des))
                    then (return FALSE)))
    )

    (return TRUE)
)

(deffunction REFINAMIENTO::crear-instancia-viaje-candidato ($?ciudades)
    (bind ?n (length$ ?ciudades))
    (bind ?dias (dias-objetivo-viaje ?n))
    (bind ?precio (coste-viaje ?ciudades))
    (bind ?puntos (puntos-viaje ?ciudades))
    (bind ?valid (if (viaje-valido ?ciudades) then TRUE else FALSE))
    (bind ?alojs (lista-alojamientos ?ciudades))

    (printout t "🔍 INTENTANDO: " ?ciudades " | Ciudades: " ?n " | Coste: " ?precio " | Valido? " ?valid crlf)

    (return
        (make-instance (gensym*) of ViajeCandidato
            (incluyeCiudad ?ciudades)
            (incluyeAlojamiento ?alojs)
            (n_ciudades ?n)
            (durada_dias ?dias)
            (precio_total ?precio)
            (puntuacion ?puntos)
            (valido ?valid)
            (seleccionado FALSE)))
)

(deffunction REFINAMIENTO::coste-minimo-candidato (?cand)
   (bind ?ciu (send ?cand get-ciudad))
   (bind ?d_raw (send ?cand get-durada_estada))
   (bind ?dias (if (numberp ?d_raw) then (max 1 ?d_raw) else 1))

   (bind ?aloj (mejor-alojamiento ?ciu))
   (bind ?precioAloj
      (if (eq ?aloj FALSE)
         then 0.0
         else (float (send ?aloj get-precio_noche))))

   (bind ?nv_raw (send ?ciu get-nivel_de_vida))
   (bind ?nivelVida (if (numberp ?nv_raw) then (float ?nv_raw) else 1.0))

   (return (+ (* (float ?dias) ?precioAloj)
              (* 25.0 ?nivelVida)))
)

(deffunction REFINAMIENTO::candidato-descartable (?cand)
   (bind ?g (send ?cand get-grado))
   (bind ?p (send ?cand get-presupuesto_ok))
   (bind ?t (send ?cand get-transporte_ok))
   (bind ?a (send ?cand get-accesibilidad_ok))
   (bind ?coste (coste-minimo-candidato ?cand))
   (bind ?presMax (float (send [usuario1] get-presupuesto_max)))

   (if (or (eq ?g NO_RECOMENDABLE)
           (eq ?p NO)
           (eq ?t NO)
           (eq ?a NO)
           (> ?coste ?presMax))
      then
         (return TRUE)
      else
         (return FALSE))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. AJUSTE FINAL DE RESTRICCIONES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::aplicar-ajustes-finales
    (declare (salience 100))
    (not (estado-refinamiento (fase AJUSTES_APLICADOS)))
=>
    (printout t crlf "--- Refinamiento completado ---" crlf)

    ; si hay movilidad reducida, PARCIAL deja de ser aceptable
    (if (eq (send [usuario1] get-movilidad_reducida) TRUE)
        then
            (do-for-all-instances ((?cand CandidatoCiudad))
                (eq (send ?cand get-accesibilidad_ok) PARCIAL)
                (send ?cand put-accesibilidad_ok NO)
                (send ?cand put-grado NO_RECOMENDABLE)
                (send ?cand put-motivo
                      "RESTRICCION: Accesibilidad insuficiente para movilidad reducida")))

    (assert (viajes-restantes-por-elegir 2))
    (assert (estado-refinamiento (fase AJUSTES_APLICADOS)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. GENERAR VIAJES BASE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::crear-viajes-base
   (declare (salience 80))
   (estado-refinamiento (fase AJUSTES_APLICADOS))
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?ciu)
                    (grado MUY_RECOMENDABLE | ADECUADO))
   (test (not (candidato-descartable ?cand)))
   (not (viaje-base-creado (ciudad ?ciu)))
=>
   (crear-instancia-viaje-candidato ?ciu)
   (assert (viaje-base-creado (ciudad ?ciu))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. EXPANDIR VIAJES CANDIDATOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::expandir-viajes
   (declare (salience 60))
   (estado-refinamiento (fase AJUSTES_APLICADOS))
    ?trip <- (object (is-a ViajeCandidato)
                    (incluyeCiudad $?ciudades)
                    (n_ciudades ?n)
                    (precio_total ?p))
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?nuevaCiudad)
                    (grado MUY_RECOMENDABLE | ADECUADO))
   (test (not (candidato-descartable ?cand)))
   (test (< ?n (send [usuario1] get-ciudades_max)))
   (test (not (ciudad-en-lista ?nuevaCiudad ?ciudades)))
   (test (hay-transporte-permitido (ultimo-elemento ?ciudades) ?nuevaCiudad))
   (test (<= (+ ?p (coste-minimo-candidato ?cand))
             (float (send [usuario1] get-presupuesto_max))))
   (not (expansion-creada (viaje ?trip) (ciudad ?nuevaCiudad)))
=>
   (crear-instancia-viaje-candidato (create$ ?ciudades ?nuevaCiudad))
   (assert (expansion-creada (viaje ?trip) (ciudad ?nuevaCiudad))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. ELEGIR EL MEJOR VIAJE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::elegir-mejores-viajes
    (declare (salience -10))
    (estado-refinamiento (fase AJUSTES_APLICADOS))
    ?f <- (viajes-restantes-por-elegir ?restantes&:(> ?restantes 0))

    ?trip <- (object (is-a ViajeCandidato)
                     (valido TRUE)
                     (seleccionado FALSE)
                     (puntuacion ?p))

    (not (object (is-a ViajeCandidato)
                 (valido TRUE)
                 (seleccionado FALSE)
                 (puntuacion ?p2&:(> ?p2 ?p))))
=>
    (send ?trip put-seleccionado TRUE)
    (bind ?rank (- 3 ?restantes)) ;; Calcula 1 para el primero, 2 para el segundo
    (assert (viaje-seleccionado (id ?trip) (ranking ?rank)))

    (bind ?ciudades (send ?trip get-incluyeCiudad))
    (bind ?nombre-viaje (sym-cat viaje-final- ?rank))
    (if (instance-existp ?nombre-viaje) then (unmake-instance ?nombre-viaje))
    (make-instance ?nombre-viaje of Viaje
        (incluyeCiudad ?ciudades)
        (durada_dias (send ?trip get-durada_dias))
        (precio_total (float (send ?trip get-precio_total))))

    (retract ?f)
    (assert (viajes-restantes-por-elegir (- ?restantes 1)))
)

(defrule REFINAMIENTO::finalizar-seleccion-viajes-insuficientes
    (declare (salience -15))
    (estado-refinamiento (fase AJUSTES_APLICADOS))
    ?f <- (viajes-restantes-por-elegir ?restantes&:(> ?restantes 0))
    (not (object (is-a ViajeCandidato) (valido TRUE) (seleccionado FALSE)))
=>
    (retract ?f)
    (assert (viajes-restantes-por-elegir 0))
)

(defrule REFINAMIENTO::pasar-a-salida
    (declare (salience -20))
    (estado-refinamiento (fase AJUSTES_APLICADOS))
    (viajes-restantes-por-elegir 0)
    (viaje-seleccionado (ranking 1))
    (not (estado-refinamiento (fase COMPLETADO)))
=>
    (assert (estado-refinamiento (fase COMPLETADO)))
    (focus SALIDA)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. MOSTRAR RESUMEN DEL REFINAMIENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::mostrar-viaje-elegido
    (declare (salience -20))
    ?sel <- (viaje-seleccionado (id ?trip))
    (not (estado-refinamiento (fase COMPLETADO)))
=>
    (printout t crlf "Viaje seleccionado tras refinamiento:" crlf)
    (printout t "  Ciudades : " (send ?trip get-incluyeCiudad) crlf)
    (printout t "  nCiudades: " (send ?trip get-n_ciudades) crlf)
    (printout t "  Duracion : " (send ?trip get-durada_dias) " dias" crlf)
    (printout t "  Coste    : " (integer (send ?trip get-precio_total)) " EUR" crlf)
    (printout t "  Puntuacion: " (send ?trip get-puntuacion) crlf crlf)

    (assert (estado-refinamiento (fase COMPLETADO)))
    (focus SALIDA)
)

(defrule REFINAMIENTO::sin-soluciones-validas
    (declare (salience -25))
    (estado-refinamiento (fase AJUSTES_APLICADOS))
    (not (estado-refinamiento (fase COMPLETADO)))
    (not (viaje-seleccionado (ranking 1)))
=>
    (printout t crlf "No se ha podido construir ningun viaje valido con las restricciones actuales." crlf crlf)
    (assert (estado-refinamiento (fase COMPLETADO)))
    (focus SALIDA)
)