;;; ---------------------------------------------------------
;;; ontologia_test1.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology ontologia_test1.ttl
;;; :Date 06/05/2026 12:35:53

(defmodule MAIN (export defclass ?ALL))

(defclass Alojamiento "Descriu el tipus d'allotjament utilitzat al viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot categoria
        (type STRING)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
        (create-accessor read-write))
    (multislot precio_noche
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Apartamento
    (is-a Alojamiento)
    (role concrete)
    (pattern-match reactive)
)

(defclass Hostal
    (is-a Alojamiento)
    (role concrete)
    (pattern-match reactive)
)

(defclass Hotel
    (is-a Alojamiento)
    (role concrete)
    (pattern-match reactive)
)

(defclass PuntoDeInteres "Descriu els diferents punts d'interes que es poden visitar dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Monumento
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Museo
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Ocio
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Parque
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Transporte "Descriu el tipus de transport utilitzat per realitzar un desplaçament dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot duracion_horas
        (type FLOAT)
        (create-accessor read-write))
    (multislot medio
        (type STRING)
        (create-accessor read-write))
    (multislot precio
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Autobus
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass Avion
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass CocheAlquiler
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass Tren
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass TematicaViaje "Constitueix la tematica del viatge, especificada pel client"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Aventura
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

(defclass Cultural
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

(defclass Descanso
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

(defclass Romantico
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

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
    (multislot clima_habitual
        (type STRING)
        (create-accessor read-write))
    (multislot cluster_tematico
        (type STRING)
        (create-accessor read-write))
    (multislot nivel_de_vida
        (type FLOAT)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
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
    (multislot ciudades_max
        (type INTEGER)
        (create-accessor read-write))
    (multislot ciudades_min
        (type INTEGER)
        (create-accessor read-write))
    (multislot dias_max
        (type INTEGER)
        (create-accessor read-write))
    (multislot dias_min
        (type INTEGER)
        (create-accessor read-write))
    (multislot edad
        (type INTEGER)
        (create-accessor read-write))
    (multislot explorador
        (type INTEGER)
        (create-accessor read-write))
    (multislot motivo_viaje
        (type STRING)
        (create-accessor read-write))
    (multislot movilidad_reducida
        (type SYMBOL)
        (create-accessor read-write))
    (multislot nivel_cultural
        (type STRING)
        (create-accessor read-write))
    (multislot presupuesto_max
        (type FLOAT)
        (create-accessor read-write))
    (multislot transporte_odiado
        (type STRING)
        (create-accessor read-write))
)

(defclass Viaje "Representa l'objecte del viatge final proposat."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot incluyeCiudad
        (type INSTANCE)
        (create-accessor read-write))
)

(definstances instances
    ([Barcelona] of Ciudad
         (conectaCon  [Madrid] [Paris])
         (tieneAlojamiento  [HotelW_Bcn] [HostalGotic_Bcn] [AptoEixample_Bcn])
         (tienePOI  [SagradaFamilia_Bcn] [ParqueGuell_Bcn] [MuseoPicasso_Bcn])
         (clima_habitual  "Templado")
         (cluster_tematico  "Mediterranea")
         (nivel_de_vida  1.1)
         (nombre  "Barcelona")
    )

    ([Madrid] of Ciudad
         (conectaCon  [Barcelona] [Berlin])
         (tieneAlojamiento  [HotelRitz_Mad] [HostalSol_Mad] [AptoRetiro_Mad])
         (tienePOI  [MuseoPrado_Mad] [ParqueRetiro_Mad] [PalacioReal_Mad])
         (clima_habitual  "Templado")
         (cluster_tematico  "Metropolis")
         (nivel_de_vida  1.0)
         (nombre  "Madrid")
    )

    ([Paris] of Ciudad
         (conectaCon  [Barcelona] [Niza] [Roma])
         (tieneAlojamiento  [HotelRitz_Paris] [HostalMontmartre_Paris] [AptoMarais_Paris])
         (tienePOI  [TorreEiffel_Paris] [MuseoLouvre_Paris] [ArcoTriunfo_Paris])
         (clima_habitual  "Templado")
         (cluster_tematico  "Metropolis")
         (nivel_de_vida  1.4)
         (nombre  "Paris")
    )

    ([Niza] of Ciudad
         (conectaCon  [Paris] [Florencia])
         (tieneAlojamiento  [HotelNegresco_Niz] [HostalVieux_Niz] [AptoPromenade_Niz])
         (tienePOI  [PaseoIngleses_Niz] [ParqueColline_Niz] [MuseoMatisse_Niz])
         (clima_habitual  "Calido")
         (cluster_tematico  "Costa")
         (nivel_de_vida  1.2)
         (nombre  "Niza")
    )

    ([Roma] of Ciudad
         (conectaCon  [Paris] [Florencia])
         (tieneAlojamiento  [HotelEden_Roma] [HostalTrastevere_Roma] [AptoVaticano_Roma])
         (tienePOI  [Coliseo_Roma] [VillaBorghese_Roma] [MuseosVaticanos_Roma])
         (clima_habitual  "Templado")
         (cluster_tematico  "Historica")
         (nivel_de_vida  1.2)
         (nombre  "Roma")
    )

    ([Florencia] of Ciudad
         (conectaCon  [Roma] [Niza] [Munich])
         (tieneAlojamiento  [HotelBrunelleschi_Flo] [HostalArno_Flo] [AptoDuomo_Flo])
         (tienePOI  [Duomo_Flo] [JardinBoboli_Flo] [GaleriaUffizi_Flo])
         (clima_habitual  "Templado")
         (cluster_tematico  "Artistica")
         (nivel_de_vida  1.1)
         (nombre  "Florencia")
    )

    ([Berlin] of Ciudad
         (conectaCon  [Madrid] [Munich])
         (tieneAlojamiento  [HotelAdlon_Ber] [HostalMitte_Ber] [AptoKreuzberg_Ber])
         (tienePOI  [PuertaBrandeburgo_Ber] [Tiergarten_Ber] [MuseoPergamo_Ber])
         (clima_habitual  "Frio")
         (cluster_tematico  "Cultura Urb")
         (nivel_de_vida  1.3)
         (nombre  "Berlin")
    )

    ([Munich] of Ciudad
         (conectaCon  [Berlin] [Florencia])
         (tieneAlojamiento  [HotelBayerischer_Mun] [HostalIsar_Mun] [AptoMarienplatz_Mun])
         (tienePOI  [Ayuntamiento_Mun] [EnglishGarden_Mun] [MuseoBMW_Mun])
         (clima_habitual  "Frio")
         (cluster_tematico  "Tradicional")
         (nivel_de_vida  1.4)
         (nombre  "Munich")
    )

    ([HotelW_Bcn] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel W")
         (precio_noche  250.0)
    )

    ([HostalGotic_Bcn] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Hostal Gotic")
         (precio_noche  40.0)
    )

    ([AptoEixample_Bcn] of Apartamento
         (categoria  "Estandar")
         (nombre  "Apto Eixample")
         (precio_noche  85.0)
    )

    ([HotelRitz_Mad] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Ritz")
         (precio_noche  300.0)
    )

    ([HostalSol_Mad] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Hostal Sol")
         (precio_noche  35.0)
    )

    ([AptoRetiro_Mad] of Apartamento
         (categoria  "Premium")
         (nombre  "Apto Retiro")
         (precio_noche  100.0)
    )

    ([HotelRitz_Paris] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Ritz Paris")
         (precio_noche  400.0)
    )

    ([HostalMontmartre_Paris] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Montmartre Inn")
         (precio_noche  60.0)
    )

    ([AptoMarais_Paris] of Apartamento
         (categoria  "Estandar")
         (nombre  "Marais Studio")
         (precio_noche  110.0)
    )

    ([HotelNegresco_Niz] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Negresco")
         (precio_noche  280.0)
    )

    ([HostalVieux_Niz] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Vieux Nice Hostel")
         (precio_noche  45.0)
    )

    ([AptoPromenade_Niz] of Apartamento
         (categoria  "Estandar")
         (nombre  "Promenade Apto")
         (precio_noche  95.0)
    )

    ([HotelEden_Roma] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Eden")
         (precio_noche  320.0)
    )

    ([HostalTrastevere_Roma] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Trastevere Hostel")
         (precio_noche  50.0)
    )

    ([AptoVaticano_Roma] of Apartamento
         (categoria  "Estandar")
         (nombre  "Vatican Flat")
         (precio_noche  90.0)
    )

    ([HotelBrunelleschi_Flo] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Brunelleschi")
         (precio_noche  290.0)
    )

    ([HostalArno_Flo] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Arno Hostel")
         (precio_noche  40.0)
    )

    ([AptoDuomo_Flo] of Apartamento
         (categoria  "Premium")
         (nombre  "Duomo View Flat")
         (precio_noche  120.0)
    )

    ([HotelAdlon_Ber] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Adlon")
         (precio_noche  350.0)
    )

    ([HostalMitte_Ber] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Mitte Hostel")
         (precio_noche  55.0)
    )

    ([AptoKreuzberg_Ber] of Apartamento
         (categoria  "Estandar")
         (nombre  "Kreuzberg Loft")
         (precio_noche  80.0)
    )

    ([HotelBayerischer_Mun] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Bayerischer Hof")
         (precio_noche  330.0)
    )

    ([HostalIsar_Mun] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Isar Hostel")
         (precio_noche  45.0)
    )

    ([AptoMarienplatz_Mun] of Apartamento
         (categoria  "Premium")
         (nombre  "Marienplatz Flat")
         (precio_noche  110.0)
    )

    ([SagradaFamilia_Bcn] of Monumento
    )

    ([ParqueGuell_Bcn] of Parque
    )

    ([MuseoPicasso_Bcn] of Museo
    )

    ([MuseoPrado_Mad] of Museo
    )

    ([ParqueRetiro_Mad] of Parque
    )

    ([PalacioReal_Mad] of Monumento
    )

    ([TorreEiffel_Paris] of Monumento
    )

    ([MuseoLouvre_Paris] of Museo
    )

    ([ArcoTriunfo_Paris] of Monumento
    )

    ([PaseoIngleses_Niz] of Ocio
    )

    ([ParqueColline_Niz] of Parque
    )

    ([MuseoMatisse_Niz] of Museo
    )

    ([Coliseo_Roma] of Monumento
    )

    ([VillaBorghese_Roma] of Parque
    )

    ([MuseosVaticanos_Roma] of Museo
    )

    ([Duomo_Flo] of Monumento
    )

    ([JardinBoboli_Flo] of Parque
    )

    ([GaleriaUffizi_Flo] of Museo
    )

    ([PuertaBrandeburgo_Ber] of Monumento
    )

    ([Tiergarten_Ber] of Parque
    )

    ([MuseoPergamo_Ber] of Museo
    )

    ([Ayuntamiento_Mun] of Monumento
    )

    ([EnglishGarden_Mun] of Parque
    )

    ([MuseoBMW_Mun] of Museo
    )

)
