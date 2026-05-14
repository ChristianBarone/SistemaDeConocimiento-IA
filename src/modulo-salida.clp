(defmodule SALIDA
    (import MAIN ?ALL)
    (import REFINAMIENTO ?ALL)
    (export ?ALL)
)

;;; ========================================
;;; GENERACIÓN DEL VIAJE PERSONALIZADO
;;; ========================================

;; Plantilla para controlar las ciudades seleccionadas
(defclass Ciudad-seleccionada
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot ciudad (type INSTANCE))
    (slot alojamiento (type INSTANCE))
    (slot posicion (type INTEGER))
    (slot dias_estada (type INTEGER))
    (slot precio (type FLOAT))
)

;; Per a guardar totes les ciutats seleccionades
(defclass Ciudades-seleccionadas
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot ciudades (type INSTANCE) (create-accessor read-write))
    (slot nDias (type INTEGER) (default 0) (create-accessor read-write))
    (slot nCiudades (type INTEGER) (default 0) (create-accessor read-write))
    (slot precioTotal (type FLOAT))
)

(deffunction anyadir_ciudad "Para cuando añadimos una ciudad al recorrido"
    ;((?c Ciudad) (?a Alojamiento) (?cs Ciudades-seleccionadas))
    (?c ?a ?cs)

    ;; Llamamos directamente a usuario1, la unica instancia que tenemos de Usuario
    (bind ?nCitiesNow (send ?cs get-nCiudades))
    (bind ?nDaysNow (send ?cs get-nDias))
    ;; Hacemos que los valores sean aleatorios para poder hacer >1 viaje -> Mejorar: tener en cuenta preferencias, no aleatorio total
    ;; Representa quantos días creemos en esta llamada que le faltan al viaje
    ;; y en función de eso asignaremos más o menos días a la ciudad visitada
    (bind ?nDaysLeft (max 0 (- ?nDaysNow (random (send [usuario1] get-dias_min) (send [usuario1] get-dias_max)))))
    ;; Miramos cuantas ciudades nos quedan por añadir de la misma forma
    (bind ?nCitiesLeft (max 0 (- ?nCitiesNow (random (send [usuario1] get-ciudades_min) (send [usuario1] get-ciudades_max)))))
    (bind ?nDaysAdded (if (neq ?nCitiesLeft 0) then (/ ?nDaysLeft ?nCitiesLeft) else 0)) 
    (bind ?nCitiesAfter (+ 1 ?nCitiesNow))
        ; precio total = nº días allí * precio diario
        ; precio diario = precio alojamiento + precio extra
        ; precio extra = 25 * nivel_de_vida  (arbitrario. incluye comida y regalos) -> Mejorar: precio PI
    (bind ?preu (+ (* ?nDaysAdded (send ?a get-precio_noche)) (* 25 (send ?c get-nivel_de_vida))))
    (bind ?newCity (make-instance (sym-cat "Ciudad-" ?nCitiesAfter) of Ciudad-seleccionada
        (ciudad ?c) (alojamiento ?a) ;mirar a
        (posicion ?nCitiesAfter) (dias_estada ?nDaysAdded)
        (precio ?preu)
    ))
    ;; insertar en una posición superior a la cantidad de elementos pone el nuevo al final de la lista
    (slot-insert$ ?cs ciudades (+ 4 ?nCitiesNow) ?newCity)
    (send ?cs put-nDias (+ ?nDaysAdded ?nDaysNow))
    (send ?cs put-nCiudades ?nCitiesAfter)
    (send ?cs put-preciototal (+ (send ?cs get-preciototal) ?preu))
)

(deffunction seleccionada "Para saber si ya hemos cogido una ciudad en el viaje"
    ; ((?c Ciudad) (?cs Ciudades-seleccionadas))
    (?c ?cs)
    ;; devuelve cierto sii ?cs ya ha seleccionado la ciudad
    (bind ?result (> (length$ (find-all-instances ((?cSel Ciudad-seleccionada)) (= (send ?cSel get-ciudad) ?c))) 0))
    (printout t "Mirando si seleccionada -> " ?result crlf)    
    (return ?result)
    )

;(deffunction transportes-de-a "
(deffunction llegamos-desde "Dadas ciudad, conjunto de ciudades i usuaro,
                            dice si podemos llegar a la ciudad desde la última ciudad visitada sin usar el transporte odiado"
    ; ((?ciu Ciudad) (?u Usuario) (?cs Ciudades-seleccionadas))
    (?ciu ?u ?cs)
    (bind ?prohibido (send ?u get-transporte_odiado))
    (bind ?nCities (send ?cs get-nCiudades))
    (if (< ?nCities 1) then (return TRUE)) ;; Asumimos que des del origen se llega a todos los lados
    (bind ?lastCity (nth$ ?nCities (send ?cs get-ciudades)))
    ;; Mejorar -> ns com comparar l'String prohibido amb el nom de les sub-classes
    (return (> (length$ (find-all-instances ((?trans Transporte)) (and (neq (send ?trans get-medio) ?prohibido)
                                                                       (= (send ?trans get-tieneFin) ?ciu)
                                                                       (= (send ?trans get-tieneOrigen) ?lastCity))))
                0)
    )
    )

;; Regla 1: Mostrar cabecera
(defrule SALIDA::mostrar-cabecera
    (declare (salience 100))
    (not (cabecera-mostrada))
=>
    (assert (cabecera-mostrada TRUE))
    (printout t crlf "==========================================" crlf)
    (printout t "       TU ITINERARIO PERSONALIZADO" crlf)
    (printout t "==========================================" crlf crlf)
    (make-instance ciudades of Ciudades-seleccionadas) ;; unica instancia que tendremos
)

;; Regla 2: Seleccionar ciudades válidas (sin restricciones violadas)
;; Preferencia: MUY_RECOMENDABLE > ADECUADO > PARCIALMENTE_ADECUADO
(defrule SALIDA::seleccionar-ciudades-muy-recomendable
    (declare (salience 90))
    ?cand <- (object (is-a CandidatoCiudad) 
                     (ciudad ?ciu) 
                     (grado MUY_RECOMENDABLE))
    ;; Miramos que todavia la podemos cojer
    ?cs <- (object (is-a Ciudades-seleccionadas))
    (not (seleccionada ?ciu ?cs))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (< (send ?cs get-nCiudades) (send ?u get-ciudades_max)))

    ;; Miramos si podemos llegar des de la anterior sin usar transporte odiado
    ;(llegamos-desde ?ciu ?u ?cs)
=>
    (printout t "--- Seleccionamos " (send ?ciu get-nombre) crlf)
    ;; Extraemos la lista de hoteles de la ciudad (slot tieneAlojamiento)
    (bind ?lista-hoteles (send ?ciu get-tieneAlojamiento))
    ;; Seleccionamos el primer hotel de la lista si existe -> Mejorar: sistema de seleccion
    (bind ?hotel-elegido [ninguno])
    (if (> (length$ ?lista-hoteles) 0) 
        then (bind ?hotel-elegido (nth$ 1 ?lista-hoteles)))

    (anyadir_ciudad ?ciu ?hotel-elegido ?cs)
)

;; Regla 3: Seleccionar ciudades con menor grado (Adecuado o Parcial)
(defrule SALIDA::seleccionar-ciudades-restantes
    (declare (salience 90))
    ?cand <- (object (is-a CandidatoCiudad) 
                     (ciudad ?ciu) 
                     (grado ADECUADO | PARCIALMENTE_ADECUADO))
    ;; Miramos que todavia la podemos cojer
    ?cs <- (object (is-a Ciudades-seleccionadas))
    (test (not (seleccionada ?ciu ?cs)))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (< (send ?cs get-nCiudades) (send ?u get-ciudades_max)))

    ;; Miramos si podemos llegar des de la anterior sin usar transporte odiado
    ;(llegamos-desde ?ciu ?u ?cs)
=>
    (printout t "--- Seleccionamos no adecuadamente " (send ?ciu get-nombre) crlf)
    ;; Extraemos la lista de hoteles de la ciudad (slot tieneAlojamiento)
    (bind ?lista-hoteles (send ?ciu get-tieneAlojamiento))
    
    ;; Seleccionamos el primer hotel de la lista si existe -> Mejorar: sistema de seleccion
    (bind ?hotel-elegido [ninguno])
    (if (> (length$ ?lista-hoteles) 0) 
        then (bind ?hotel-elegido (nth$ 1 ?lista-hoteles)))

    (anyadir_ciudad ?ciu ?hotel-elegido ?cs)
)


;; -------------------------------
;; Mostramos salida por pantalla

(deffunction SALIDA::mostrar-parada
    ; ((?c Ciudad-seleccionada) (?pos INTEGER))
    (?c ?pos)
    ;; 1. Obtener nombre del Hotel
    (bind ?nomCiudad (send ?c get-nombre))
    (bind ?pos (send ?c get-posicion))
    (bind ?aloj (send ?c get-alojamiento))
    (bind ?nombreHotel "Sin hotel asignado")
    (if (neq ?aloj [ninguno])
        then (bind ?nombreHotel (send ?aloj get-nombre)))

    ;; 2. Impresión por pantalla
    (printout t "PARADA " ?pos ": " ?nomCiudad crlf)
    (printout t "  * HOTEL: " ?nombreHotel crlf)
    
    ;; 3. Mostrar Puntos de Interés (POI)
    (bind ?obj-ciu (send ?c get-ciudad))
    (bind ?pois (send ?obj-ciu get-tienePOI))
    ;; Mejorar -> no recomenar-ho tot
    (if (> (length$ ?pois) 0) then
        (printout t "  * VISITAS RECOMENDADAS: ")
        (foreach ?p ?pois (printout t (instance-name ?p) " "))
        (printout t crlf))
        
    (printout t "------------------------------------------" crlf)
)

(deffunction SALIDA::mostrar-trayecto
    ; ((?cOri Ciudad-seleccionada) (?cDest Ciudad-seleccionada) (?odio STRING))
    (?cOri ?cDest ?odio)
    ;; retornem el primer que no odii i que les connecti -> Mejorar
    (bind ?transporte (nth$ 1 (find-all-instances ((?trans Transporte)) (and (neq (send ?trans get-medio) ?odio)
                                                                        (= (send ?trans get-tieneFin) ?cDest)
                                                                        (= (send ?trans get-tieneOrigen) ?cOri)))))
    (bind ?medio (send ?transporte get-medio)) ;; Mejorar -> que imprima el nombre del trayecto
    (printout t "  * TRANSPORTE RECOMENDADO: " ?medio crlf)
)

(defrule SALIDA::acabar
    (declare (salience 85)) ;; mismo que para las restantes para añadir aleatoriedad
    ?cs <- (object (is-a Ciudades-seleccionadas))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (>= (send ?cs get-nDias) (send ?u get-dias_min)))
=>
    (assert (acabado))
    (printout t "Acabado" crlf))

(defrule SALIDA::mostrar-viaje
    (declare (salience 80))
    (acabado)
    ?cs <- (object (is-a Ciudades-seleccionadas))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (bind ?cities (send ?cs get-ciudades))
    (bind ?nCities (send ?cs get-nCiudades))
    (bind ?odio (send ?u get-transporte_odiado))
    (mostrar-parada (nth$ 1 ?cities) 1) ;; asumimos que como minimo tenemos una ciudad
    (loop-for-count (?i 2 ?nCities) do
        (mostrar-trayecto (nth$ (- ?i 1) ?cities) (nth$ ?i ?cities) ?odio)
        (mostrar-parada (nth$ ?i ?cities) ?i)
    )
)

;; Regla 5: Mostrar resumen final
(defrule SALIDA::mostrar-resumen-final
    (declare (salience -100))
    (cabecera-mostrada)
    (not (resumen-mostrado))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    ?cs <- (object (is-a Ciudades-seleccionadas))
=>
    (bind ?numCiudades (send ?cs get-nCiudades))
    (bind ?numDias (send ?cs get-nDias))
    (bind ?precioTotal (send ?cs get-precioTotal))
    ; (bind ?diasMin (send ?u get-dias_min))
    ; (bind ?diasMax (send ?u get-dias_max))
    ; (bind ?presupuestoMax (send ?u get-presupuesto_max))
    
    (printout t crlf "==========================================" crlf)
    (printout t "           RESUMEN DE TU VIAJE" crlf)
    (printout t "==========================================" crlf)
    (printout t "Ciudades:        " ?numCiudades crlf)
    ;(printout t "Duración:        " ?diasMin "-" ?diasMax " días" crlf)
    (printout t "Duración:        " ?numDias " días" crlf)
    ;(printout t "Presupuesto max: " ?presupuestoMax "€" crlf)
    (printout t "Presupuesto: " ?precioTotal "€" crlf)
    (printout t "==========================================" crlf crlf)
    
    (assert (resumen-mostrado TRUE))
)
