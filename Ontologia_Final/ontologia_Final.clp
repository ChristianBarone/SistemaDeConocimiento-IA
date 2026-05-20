;;; ---------------------------------------------------------
;;; ontologia_extra.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology ontologia_extra.ttl
;;; :Date 16/05/2026 19:03:57

(defclass Ciudad "Representa les ciutats que es poden visitar a un viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot conectaCon
        (type INSTANCE)
        (create-accessor read-write))
    (multislot tieneAlojamiento
        (type INSTANCE)
        (create-accessor read-write))
    (multislot tienePOI
        (type INSTANCE)
        (create-accessor read-write))
    ; (slot clima_habitual
    ;     (type STRING)
    ;     (create-accessor read-write))
    (slot cluster_tematico
        (type INSTANCE)
        (allowed-classes Tematica)
        (create-accessor read-write))
    (slot nivel_de_vida
        (type FLOAT)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))

    (slot popularidad
        (type INTEGER)
        (range 1 5)
        (default 3)
    (create-accessor read-write))

    ;;; Valoracio per temporada: 1 = molt poc recomanable, 5 = molt recomanable
    (slot valoracion_primavera
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))
    (slot valoracion_verano
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))
    (slot valoracion_otono
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))
    (slot valoracion_invierno
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))
)

(defclass Usuario "Representa l'usuari client que es beneficiara de la planificació del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot recibeViaje
        (type INSTANCE)
        (create-accessor read-write))
    (multislot acompanyants
        (type STRING)
        (create-accessor read-write))
    (slot ciudades_max
        (type INTEGER)
        (create-accessor read-write))
    (slot ciudades_min
        (type INTEGER)
        (create-accessor read-write))
    (slot dias_max
        (type INTEGER)
        (create-accessor read-write))
    (slot dias_min
        (type INTEGER)
        (create-accessor read-write))
    (slot edad
        (type INTEGER)
        (create-accessor read-write))

    ;;; 1 = perfil convencional, 5 = perfil explorador
    (slot explorador
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))

    ;;; 1 = l'estalvi importa poc, 5 = l'estalvi importa molt
    (slot grado_ahorro
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))

    ;;; 1 = la qualitat de l'allotjament importa poc, 5 = importa molt
    (slot prioridad_alojamiento
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))

    ;;; Temporada principal del viatge
    (slot temporada_viaje
        (type SYMBOL)
        (allowed-symbols PRIMAVERA VERANO OTONO INVIERNO)
        (default VERANO)
        (create-accessor read-write))

    (slot motivo_viaje
        (type STRING)
        (create-accessor read-write))

    (slot movilidad_reducida
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))

    (slot nivel_cultural
        (type STRING)
        (create-accessor read-write))

    (slot presupuesto_max
        (type FLOAT)
        (create-accessor read-write))

    (slot transporte_odiado
        (type SYMBOL)
        (allowed-symbols NINGUNO AUTOBUS AVION COCHE_ALQUILER TREN)
        (default NINGUNO)
        (create-accessor read-write))

    (slot transporte_preferido
        (type SYMBOL)
        (allowed-symbols NINGUNO AUTOBUS AVION COCHE_ALQUILER TREN)
        (default NINGUNO)
        (create-accessor read-write))
)

(defclass Viaje "Representa l'objecte del viatge final proposat."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot incluyeCiudad
        (type INSTANCE)
        (create-accessor read-write))
    (multislot incluyePI
        (type INSTANCE)
        (create-accessor read-write))
    (slot tieneTema
        (type INSTANCE)
        (create-accessor read-write))
    (multislot viajaCon
        (type INSTANCE)
        (create-accessor read-write))
    (slot durada_dias
        (type INTEGER)
        (create-accessor read-write))
    (slot precio_total
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Transporte "Descriu el tipus de transport utilitzat per realitzar un desplaçament dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot tieneFin
        (type INSTANCE)
        (create-accessor read-write))
    (slot tieneOrigen
        (type INSTANCE)
        (create-accessor read-write))
    (slot duracion_horas
        (type FLOAT)
        (create-accessor read-write))

    (slot tipo
        (type SYMBOL)
        (allowed-symbols AUTOBUS AVION COCHE_ALQUILER TREN)
        (create-accessor read-write))

    (slot detalles
        (type STRING)
        (create-accessor read-write))

    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO
    (slot accesible
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))

    (slot precio
        (type FLOAT)
        (create-accessor read-write))
)

(defclass PuntoDeInteres "Descriu els diferents punts d'interes que es poden visitar dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)

    (slot tipo
        (type SYMBOL)
        (allowed-symbols MONUMENTO MUSEO RECREATIVO PARQUE)
        (create-accessor read-write))

    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO, PARCIAL
    (slot accesible
        (type SYMBOL)
        (allowed-symbols SI NO PARCIAL)
        (default SI)
        (create-accessor read-write))

    (slot precio_PI
        (type FLOAT)
        (create-accessor read-write))

    ;;; 1 = gens adequat per a nens, 5 = molt adequat
    (slot gaudi_infants
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))

    (slot popularidad
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))

    (slot tematica_adecuada
        (type INSTANCE)
        (allowed-classes Tematica)
        (create-accessor read-write))
)


(defclass Alojamiento "Descriu el tipus d'allotjament utilitzat al viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)

    (slot categoria
        (type SYMBOL)
        (allowed-symbols APARTAMENTO HOSTAL HOTEL)
        (create-accessor read-write))

    (slot nombre
        (type STRING)
        (create-accessor read-write))

    (slot precio_noche
        (type FLOAT)
        (create-accessor read-write))

    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO
    (slot accesible
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))

    ;;; 1 = qualitat molt baixa, 5 = qualitat molt alta
    (slot calidad
        (type INTEGER)
        (range 1 5)
        (default 3)
        (create-accessor read-write))
)

(defclass ViajeCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot incluyeCiudad
        (type INSTANCE)
        (create-accessor read-write))
    (multislot incluyeAlojamiento
        (type INSTANCE)
        (create-accessor read-write))
    (multislot incluyePuntoDeInteres
        (type INSTANCE)
        (create-accessor read-write))
    (slot n_ciudades
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot durada_dias
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot precio_total
        (type FLOAT)
        (default 0.0)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))

    ;;; Desglose de la puntuacion
    (slot ajuste_ahorro
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot ajuste_explorador
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot ajuste_temporada
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot ajuste_alojamiento
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot ajuste_infants
        (type INTEGER)
        (default 0)
        (create-accessor read-write))

    (slot valido
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))
    (slot seleccionado
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))
)

(defclass CandidatoCiudad "Representa com s'adecua una ciutat a les restriccions de l'usuari."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)

    ;;; Ciudad evaluada como candidata para el viaje
    (slot ciudad
        (type INSTANCE)
        (allowed-classes Ciudad)
        (create-accessor read-write))

    ;;; Lista de puntos a favor detectados durante la evaluacion
    (multislot ventajas
        (type STRING)
        (create-accessor read-write))

    ;;; Lista de inconvenientes detectados durante la evaluacion
    (multislot desventajas
        (type STRING)
        (create-accessor read-write))

    ;;; Numero de dias recomendados para permanecer en la ciudad
    (slot durada_estada
        (type INTEGER)
        (create-accessor read-write))

    ;;; Valoracion global del encaje de la ciudad
    (slot grado
        (type SYMBOL)
        (allowed-symbols ALTO MEDIO BAJO)
        (default MEDIO)
        (create-accessor read-write))

    ;;; Explicacion resumida del por que de la valoracion
    (slot motivo
        (type STRING)
        (create-accessor read-write))

    ;;; Indica si la ciudad encaja en el presupuesto del usuario
    (slot presupuesto_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))

    ;;; Indica si la tematica de la ciudad encaja con la preferencia del usuario
    (slot tematica_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))

    ;;; Indica si existe transporte adecuado hacia o desde esta ciudad
    (slot transporte_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))

    ;;; Marca si existe una incompatibilidad fuerte que descarte la ciudad
    (slot incompatibilidad_especifica
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default NO)
        (create-accessor read-write))

    ;;; Ajuste de puntuacion segun si el usuario es mas o menos explorador
    (slot ajuste_explorador
        (type INTEGER)
        (default 0)
        (create-accessor read-write))

    ;;; Ajuste de puntuacion segun la temporada elegida para viajar
    (slot ajuste_temporada
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
)

(defclass AlojamientoCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot alojamiento
        (type INSTANCE)
        (create-accessor read-write))
    (slot accesibilidad_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot precio_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))

    ;;; Ajuste segun calidad y prioridad del usuario
    (slot ajuste_prioridad_alojamiento
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
)

(defclass TransporteCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot transporte
        (type INSTANCE)
        (create-accessor read-write))
    ; (slot categoria ;; PREMIUM, ESTANDARD, BARATO
    ;     (type SYMBOL)
    ;     (create-accessor read-write))
    (slot accesibilidad_ok
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot precio_ok
        (type SYMBOL) ;; SI, NO
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot odiado
        (type SYMBOL) ;; SI, NO
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    ; (slot seleccionado
    ;     (type SYMBOL)
    ;     (default FALSE)
    ;     (create-accessor read-write))
)

(defclass PuntoDeInteresCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot puntodeinteres
        (type INSTANCE)
        (create-accessor read-write))
    (slot accesibilidad_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot precio_ok
        (type SYMBOL)
        (allowed-symbols SI NO)
        (default SI)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))

    ;;; Ajuste por adecuacion para ninos
    (slot ajuste_infants
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
)
