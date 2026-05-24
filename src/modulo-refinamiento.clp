;;; Modulo de refinamiento:
;;;   - aplica el ajuste final de restricciones
;;;   - genera viajes candidatos válidos a partir de CandidatoCiudad
;;;   - puntúa cada viaje
;;;   - elige el mejor
;;;   - deja marcada la solucion para que SALIDA la imprima

(defmodule REFINAMIENTO
    (import MAIN ?ALL)
    (import HEURISTICA ?ALL)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CONTROL DEL MODULO
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

(deffunction REFINAMIENTO::valor-aptitud-alojamiento (?apt)
   (if (eq ?apt ALTA) then (return 3))
   (if (eq ?apt MEDIA) then (return 2))
   (if (eq ?apt BAJA) then (return 1))
   (return 0)
)

(deffunction REFINAMIENTO::aptitud-de-alojamiento (?aloj)
   (bind ?cands
      (find-all-instances ((?cand AlojamientoCandidato))
         (eq (send ?cand get-alojamiento) ?aloj)))
   (if (> (length$ ?cands) 0)
      then
         (return (send (nth$ 1 ?cands) get-aptitud_alojamiento))
      else
         (return MEDIA))
)

(deffunction REFINAMIENTO::mejor-alojamiento (?ciu)
   (bind ?lista (send ?ciu get-tieneAlojamiento))
   (if (= (length$ ?lista) 0) then (return FALSE))

   (bind ?mov_red (send [usuario1] get-movilidad_reducida))  ; <<< NUEVO
   (bind ?mejor FALSE)
   (bind ?mejorApt -1)
   (bind ?precioMejor 999999.0)

   (loop-for-count (?i 1 (length$ ?lista)) do
      (bind ?a (nth$ ?i ?lista))
      (if (instance-existp ?a)
         then
            ; <<< NUEVO: si hay movilidad reducida, solo considerar accesibles
            (if (and (eq ?mov_red TRUE)
                     (neq (send ?a get-accesible) SI))
               then
                  ; saltar este alojamiento
               else
                  (bind ?apt (REFINAMIENTO::valor-aptitud-alojamiento
                              (REFINAMIENTO::aptitud-de-alojamiento ?a)))
                  (bind ?p_raw (send ?a get-precio_noche))
                  (bind ?p (if (numberp ?p_raw) then (float ?p_raw) else 999999.0))

                  (if (or (> ?apt ?mejorApt)
                          (and (= ?apt ?mejorApt) (< ?p ?precioMejor)))
                     then
                        (bind ?mejor ?a)
                        (bind ?mejorApt ?apt)
                        (bind ?precioMejor ?p)))))
   (return ?mejor)
)

(deffunction REFINAMIENTO::puntos-prioridad-alojamiento (?ciu)
   (bind ?aloj (REFINAMIENTO::mejor-alojamiento ?ciu))
   
   (if (eq ?aloj FALSE)
      then
         (return -15))

   (bind ?apt (REFINAMIENTO::aptitud-de-alojamiento ?aloj))
   (bind ?prio (send [usuario1] get-prioridad_alojamiento))

   (if (>= ?prio 4)
      then
         (if (eq ?apt ALTA) then (return 12))
         (if (eq ?apt MEDIA) then (return -3))
         (if (eq ?apt BAJA) then (return -18))
         (return 0))

   (if (<= ?prio 2)
      then
         (if (eq ?apt ALTA) then (return 3))
         (if (eq ?apt MEDIA) then (return 0))
         (if (eq ?apt BAJA) then (return -2))
         (return 0))

   (if (eq ?apt ALTA) then (return 6))
   (if (eq ?apt MEDIA) then (return 0))
   (if (eq ?apt BAJA) then (return -8))
   (return 0)
)

(deffunction REFINAMIENTO::min-total-por-ciudades (?nCiudades)
   (return (* ?nCiudades (send [usuario1] get-ciudad_dias_min)))
)

(deffunction REFINAMIENTO::max-total-por-ciudades (?nCiudades)
   (return (* ?nCiudades (send [usuario1] get-ciudad_dias_max)))
)

(deffunction REFINAMIENTO::dias-objetivo-viaje (?nCiudades)
   (bind ?diasMinViaje (send [usuario1] get-dias_min))
   (bind ?diasMaxViaje (send [usuario1] get-dias_max))
   (bind ?diasMinCiudades (REFINAMIENTO::min-total-por-ciudades ?nCiudades))
   (bind ?diasMaxCiudades (REFINAMIENTO::max-total-por-ciudades ?nCiudades))

   (bind ?minFactible (max ?diasMinViaje ?diasMinCiudades))
   (bind ?maxFactible (min ?diasMaxViaje ?diasMaxCiudades))

   (if (> ?minFactible ?maxFactible)
      then (return FALSE))

   (return ?maxFactible)
)

(deffunction REFINAMIENTO::dias-en-parada (?diasTotales ?nCiudades ?posicion)
   (bind ?base (div ?diasTotales ?nCiudades))
   (bind ?resto (- ?diasTotales (* ?base ?nCiudades)))
   (if (<= ?posicion ?resto)
      then (return (+ ?base 1))
      else (return ?base))
)

(deffunction REFINAMIENTO::coste-ciudad (?ciu ?diasPorCiudad)
   (bind ?aloj (REFINAMIENTO::mejor-alojamiento ?ciu))
   (if (eq ?aloj FALSE)
      then
         (return 999999.0))

   (bind ?precioAloj (float (send ?aloj get-precio_noche)))
   (bind ?nv_raw (send ?ciu get-nivel_de_vida))
   (bind ?nivelVida (if (numberp ?nv_raw) then (float ?nv_raw) else 1.0))

   (return (+ (* (float ?diasPorCiudad) ?precioAloj)
              (* 25.0 ?nivelVida)))
)

(deffunction REFINAMIENTO::coste-viaje (?ciudades)
   (bind ?n (length$ ?ciudades))
   (if (= ?n 0) then (return 0.0))

   (bind ?diasTotales (REFINAMIENTO::dias-objetivo-viaje ?n))
   (if (eq ?diasTotales FALSE) then (return 999999.0))

   (bind ?total 0.0)
   (loop-for-count (?i 1 ?n)
      do
      (bind ?ciu (nth$ ?i ?ciudades))
      (bind ?diasParada (REFINAMIENTO::dias-en-parada ?diasTotales ?n ?i))
      (bind ?total (+ ?total (REFINAMIENTO::coste-ciudad ?ciu ?diasParada)))
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
    (printout t "  DEBUG VIAJE: Intentando conectar " ?origen " con " ?destino crlf)
    (printout t "   Normalizados a: " ?norm-origen " -> " ?norm-destino crlf)

    ;; Buscamos las instancias de transporte
    (bind ?transportes (find-all-instances ((?t Transporte)) TRUE))
    (printout t "   [Ontologia] Transportes totales encontrados: " (length$ ?transportes) crlf)

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
                (printout t "       Evaluando " (instance-name ?t) " | Origen ontologia: " ?ori-slot " | Destino ontologia: " ?des-slot crlf)
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
                (printout t " CONEXION ENCONTRADA EXTRAVAGANTE! Usando: " (instance-name ?t) crlf)
                (return TRUE))
        )
    )
    (printout t "  No hay ruta directa entre estas dos ciudades." crlf)
    (return FALSE)
)

(deffunction REFINAMIENTO::buscar-transporte-entre (?origen ?destino)
   (bind ?prohibido (send [usuario1] get-transporte_odiado))
   (bind ?norm-origen (REFINAMIENTO::normalizar-nombre ?origen))
   (bind ?norm-destino (REFINAMIENTO::normalizar-nombre ?destino))
   (bind ?transportes (find-all-instances ((?t Transporte)) TRUE))

   (loop-for-count (?i 1 (length$ ?transportes))
      do
      (bind ?t (nth$ ?i ?transportes))

      (if (not (and (neq ?prohibido nil)
                    (neq ?prohibido Ninguno)
                    (eq (send ?t get-tipo) ?prohibido)))
         then
         (bind ?ori-slot (send ?t get-tieneOrigen))
         (bind ?des-slot (send ?t get-tieneFin))

         (bind ?lista-ori (if (multifieldp ?ori-slot) then ?ori-slot else (create$ ?ori-slot)))
         (bind ?lista-des (if (multifieldp ?des-slot) then ?des-slot else (create$ ?des-slot)))

         (bind ?ori-ok FALSE)
         (loop-for-count (?j 1 (length$ ?lista-ori))
            do
            (if (eq (REFINAMIENTO::normalizar-nombre (nth$ ?j ?lista-ori)) ?norm-origen)
               then
               (bind ?ori-ok TRUE)
               (break))
         )

         (bind ?des-ok FALSE)
         (loop-for-count (?j 1 (length$ ?lista-des))
            do
            (if (eq (REFINAMIENTO::normalizar-nombre (nth$ ?j ?lista-des)) ?norm-destino)
               then
               (bind ?des-ok TRUE)
               (break))
         )

         (if (and ?ori-ok ?des-ok)
            then (return ?t))
      )
   )

   (return FALSE)
)

(deffunction REFINAMIENTO::bonus-transporte-favorito (?transporte)
   (if (eq ?transporte FALSE) then (return 0))

   (bind ?pref (send [usuario1] get-transporte_preferido))
   (if (or (eq ?pref nil) (eq ?pref Ninguno))
      then (return 0))

   (if (eq (send ?transporte get-tipo) ?pref)
      then (return 20)
      else (return 0))
)

(deffunction REFINAMIENTO::penalizacion-trayecto-largo (?transporte)
   (if (eq ?transporte FALSE) then (return 0))

   (bind ?h (send ?transporte get-duracion_horas))

   (if (<= ?h 2) then (return 0))
   (if (<= ?h 4) then (return 5))
   (if (<= ?h 6) then (return 12))
   (if (<= ?h 9) then (return 20))
   (return 35)
)

(deffunction REFINAMIENTO::puntos-grado (?g)
    (if (eq ?g MUY_RECOMENDABLE) then (return 150))
    (if (eq ?g RECOMENDABLE) then (return 80))
    (if (eq ?g ADECUADO) then (return 40))
    (if (eq ?g POCO_ADECUADO) then (return -25))
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

    (bind ?score (+ ?score (REFINAMIENTO::puntos-grado (send ?cand get-grado))))
    (bind ?score (+ ?score (REFINAMIENTO::puntos-tematica (send ?cand get-tematica_ok))))
    (bind ?score (+ ?score (REFINAMIENTO::puntos-presupuesto (send ?cand get-presupuesto_ok))))
    (bind ?score (+ ?score (REFINAMIENTO::puntos-accesibilidad (send ?cand get-accesibilidad_ok))))

    (if (eq (send ?cand get-transporte_ok) SI)
        then (bind ?score (+ ?score 10))
        else (bind ?score (- ?score 40)))

    (bind ?score (+ ?score (* 3 (length$ (send ?cand get-ventajas)))))
    (bind ?score (- ?score (* 4 (length$ (send ?cand get-desventajas)))))

    ; ajuste explorador de ciudad
    (bind ?score (+ ?score (send ?cand get-ajuste_explorador)))

    (return ?score)
)

(deffunction REFINAMIENTO::puntos-explorador-pois-ciudad (?ciu)
   (bind ?total 0)
   (bind ?pois (send ?ciu get-tienePOI))

   (loop-for-count (?i 1 (length$ ?pois)) do
      (bind ?poi (nth$ ?i ?pois))

      (bind ?cand-list
         (find-all-instances ((?pc PuntoDeInteresCandidato))
            (eq (send ?pc get-puntodeinteres) ?poi)))

      (if (> (length$ ?cand-list) 0)
         then
            (bind ?pc (nth$ 1 ?cand-list))
            (bind ?total (+ ?total (send ?pc get-ajuste_explorador))))
   )

   (if (> ?total 6) then (return 6))
   (if (< ?total -6) then (return -6))
   (return ?total)
)

(deffunction REFINAMIENTO::puntos-viaje (?ciudades)
   (bind ?score 0)
   (bind ?n (length$ ?ciudades))
   (bind ?diasTotales (REFINAMIENTO::dias-objetivo-viaje ?n))

   (if (eq ?diasTotales FALSE) then (return -9999))

   (loop-for-count (?i 1 ?n)
      do
      (bind ?ciu (nth$ ?i ?ciudades))
      (bind ?cand-list
         (find-all-instances ((?cand CandidatoCiudad))
            (eq (send ?cand get-ciudad) ?ciu)))

      (if (> (length$ ?cand-list) 0)
         then
            (bind ?cand (nth$ 1 ?cand-list))
            (bind ?diasParada (REFINAMIENTO::dias-en-parada ?diasTotales ?n ?i))

            (bind ?score
               (+ ?score
                  (* (REFINAMIENTO::puntos-candidato-ciudad ?cand)
                     ?diasParada)))

            (bind ?score
               (+ ?score
                  (REFINAMIENTO::puntos-explorador-pois-ciudad ?ciu)))
      )
   )

   (if (> ?n (send [usuario1] get-ciudades_min))
      then (bind ?score (+ ?score 15)))

   (if (= ?n (send [usuario1] get-ciudades_max))
      then (bind ?score (+ ?score 5)))

   (if (> ?n 1) then
      (loop-for-count (?i 2 ?n)
         do
         (bind ?ori (nth$ (- ?i 1) ?ciudades))
         (bind ?des (nth$ ?i ?ciudades))
         (bind ?t (REFINAMIENTO::buscar-transporte-entre ?ori ?des))

         (if (neq ?t FALSE)
            then
               (bind ?score (+ ?score (REFINAMIENTO::bonus-transporte-favorito ?t)))
               (bind ?score (- ?score (REFINAMIENTO::penalizacion-trayecto-largo ?t))))
      )
   )

   (bind ?coste (REFINAMIENTO::coste-viaje ?ciudades))
   (bind ?presMax (float (send [usuario1] get-presupuesto_max)))

   (if (> ?coste ?presMax)
      then (bind ?score (- ?score 200))
      else
         (if (> ?coste (* 0.9 ?presMax))
            then (bind ?score (- ?score 10))
            else (bind ?score (+ ?score 10)))
   )

   (return ?score)
)

(deffunction REFINAMIENTO::viaje-valido (?ciudades)
   (bind ?n (length$ ?ciudades))
   (bind ?dias (REFINAMIENTO::dias-objetivo-viaje ?n))
   (bind ?precio (REFINAMIENTO::coste-viaje ?ciudades))

   (if (< ?n (send [usuario1] get-ciudades_min)) then (return FALSE))
   (if (> ?n (send [usuario1] get-ciudades_max)) then (return FALSE))
   (if (eq ?dias FALSE) then (return FALSE))
   (if (> ?precio (float (send [usuario1] get-presupuesto_max))) then (return FALSE))

   (loop-for-count (?i 1 ?n)
    do
    (bind ?ciu (nth$ ?i ?ciudades))

    (if (eq (REFINAMIENTO::mejor-alojamiento ?ciu) FALSE)
        then
            (return FALSE))

    (bind ?diasParada (REFINAMIENTO::dias-en-parada ?dias ?n ?i))
    (if (< ?diasParada (send [usuario1] get-ciudad_dias_min)) then (return FALSE))
    (if (> ?diasParada (send [usuario1] get-ciudad_dias_max)) then (return FALSE))
    )

   (if (> ?n 1) then
      (loop-for-count (?i 2 ?n)
         do
         (bind ?ori (nth$ (- ?i 1) ?ciudades))
         (bind ?des (nth$ ?i ?ciudades))
         (if (not (REFINAMIENTO::hay-transporte-permitido ?ori ?des))
            then (return FALSE))
      )
   )

   (return TRUE)
)

(deffunction REFINAMIENTO::mejores-pois-ciudad (?ciu)
   (bind ?res (create$))
   (bind ?pois (send ?ciu get-tienePOI))

   (loop-for-count (?i 1 (length$ ?pois)) do
      (bind ?poi (nth$ ?i ?pois))

      (bind ?cand-list
         (find-all-instances ((?pc PuntoDeInteresCandidato))
            (eq (send ?pc get-puntodeinteres) ?poi)))

      (if (> (length$ ?cand-list) 0)
         then
            (bind ?pc (nth$ 1 ?cand-list))
            (if (eq (send ?pc get-accesibilidad_ok) SI)
               then
                  (bind ?res (create$ ?res ?poi))))
   )

   (return ?res)
)

(deffunction REFINAMIENTO::lista-pois-viaje ($?ciudades)
   (bind ?res (create$))

   (loop-for-count (?i 1 (length$ ?ciudades)) do
      (bind ?ciu (nth$ ?i ?ciudades))
      (bind ?pois-ciu (REFINAMIENTO::mejores-pois-ciudad ?ciu))
      (bind ?res (create$ ?res ?pois-ciu))
   )

   (return ?res)
)

(deffunction REFINAMIENTO::crear-instancia-viaje-candidato ($?ciudades)
   (bind ?n (length$ ?ciudades))
   (bind ?dias (REFINAMIENTO::dias-objetivo-viaje ?n))
   (bind ?precio (REFINAMIENTO::coste-viaje ?ciudades))
   (bind ?puntos (REFINAMIENTO::puntos-viaje ?ciudades))
   (bind ?valid (if (REFINAMIENTO::viaje-valido ?ciudades) then TRUE else FALSE))
   (bind ?alojs (REFINAMIENTO::lista-alojamientos ?ciudades))
   (bind ?pois (REFINAMIENTO::lista-pois-viaje ?ciudades))

   (printout t "INTENTANDO " ?ciudades " Ciudades: " ?n " Coste: " ?precio " Valido? " ?valid crlf)

   (return
    (make-instance (gensym) of ViajeCandidato
        (incluyeCiudad ?ciudades)
        (incluyeAlojamiento ?alojs)
        (incluyePuntoDeInteres ?pois)
        (n_ciudades ?n)
        (durada_dias ?dias)
        (precio_total ?precio)
        (puntuacion ?puntos)
        (valido ?valid)
        (seleccionado FALSE)
    )
   )
)

(deffunction REFINAMIENTO::coste-minimo-candidato (?cand)
   (bind ?ciu (send ?cand get-ciudad))
   (bind ?d_raw (send ?cand get-durada_estada))
   (bind ?dias (if (numberp ?d_raw) then (max 1 ?d_raw) else 1))

   (bind ?aloj (REFINAMIENTO::mejor-alojamiento ?ciu))
   (if (eq ?aloj FALSE)
      then
         (return 999999.0))

   (bind ?precioAloj (float (send ?aloj get-precio_noche)))
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
   (bind ?mov_red (send [usuario1] get-movilidad_reducida))  ; <<< NUEVO

   (if (or (eq ?g NO_RECOMENDABLE)
           (eq ?p NO)
           (eq ?t NO)
           (and (eq ?mov_red TRUE) (eq ?a NO))  ; <<< solo si movilidad reducida
           (> ?coste ?presMax))
      then (return TRUE)
      else (return FALSE))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. AJUSTE FINAL DE RESTRICCIONES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule REFINAMIENTO::aplicar-ajustes-finales
    (declare (salience 100))
    (not (estado-refinamiento (fase AJUSTES_APLICADOS)))
=>
    (printout t crlf "--- Refinamiento completado ---" crlf)

    (if (eq (send [usuario1] get-movilidad_reducida) TRUE)
        then
            (do-for-all-instances ((?cand CandidatoCiudad))
                (eq (send ?cand get-accesibilidad_ok) PARCIAL)
                (send ?cand put-accesibilidad_ok NO)
                ; <<< ELIMINADO: (send ?cand put-grado NO_RECOMENDABLE)
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
                    (grado MUY_RECOMENDABLE | RECOMENDABLE | ADECUADO))
   (test (not (candidato-descartable ?cand)))
   (not (viaje-base-creado (ciudad ?ciu)))
=>
   (crear-instancia-viaje-candidato (create$ ?ciu))
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
                    (grado MUY_RECOMENDABLE | RECOMENDABLE | ADECUADO))
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

(deffunction REFINAMIENTO::comparten-ciudad (?lista1 ?lista2)
   (loop-for-count (?i 1 (length$ ?lista1)) do
      (if (neq (member$ (nth$ ?i ?lista1) ?lista2) FALSE)
         then
            (return TRUE))
   )
   (return FALSE)
)

(defrule REFINAMIENTO::elegir-primer-viaje
   (declare (salience -10))
   (estado-refinamiento (fase AJUSTES_APLICADOS))
   ?f <- (viajes-restantes-por-elegir 2)

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
   (assert (viaje-seleccionado (id ?trip) (ranking 1)))

   (bind ?ciudades (send ?trip get-incluyeCiudad))
   (if (instance-existp viaje-final-1) then (unmake-instance viaje-final-1))
   (make-instance viaje-final-1 of Viaje
      (incluyeCiudad ?ciudades)
      (durada_dias (send ?trip get-durada_dias))
      (precio_total (float (send ?trip get-precio_total))))

   (retract ?f)
   (assert (viajes-restantes-por-elegir 1))
)

(defrule REFINAMIENTO::invalidar-viajes-solapados-con-primero
   (declare (salience -9))
   (estado-refinamiento (fase AJUSTES_APLICADOS))
   (viaje-seleccionado (id ?trip1) (ranking 1))

   ?trip <- (object (is-a ViajeCandidato)
                    (valido TRUE)
                    (seleccionado FALSE)
                    (incluyeCiudad $?ciudadesTrip))

   (test (REFINAMIENTO::comparten-ciudad
             (create$ ?ciudadesTrip)
             (create$ (send ?trip1 get-incluyeCiudad))))
=>
   (send ?trip put-valido FALSE)
)

(defrule REFINAMIENTO::elegir-segundo-viaje
   (declare (salience -10))
   (estado-refinamiento (fase AJUSTES_APLICADOS))
   ?f <- (viajes-restantes-por-elegir 1)

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
   (assert (viaje-seleccionado (id ?trip) (ranking 2)))

   (bind ?ciudades (send ?trip get-incluyeCiudad))
   (if (instance-existp viaje-final-2) then (unmake-instance viaje-final-2))
   (make-instance viaje-final-2 of Viaje
      (incluyeCiudad ?ciudades)
      (durada_dias (send ?trip get-durada_dias))
      (precio_total (float (send ?trip get-precio_total))))

   (retract ?f)
   (assert (viajes-restantes-por-elegir 0))
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