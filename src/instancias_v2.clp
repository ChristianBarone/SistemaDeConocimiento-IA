(definstances instances
     ([tema-aventura]  of Aventura)
     ([tema-cultural]  of Cultural)
     ([tema-descanso]  of Descanso)
     ([tema-romantico] of Romantico)
     ([tema-familiar]  of Familiar)
     ([tema-ocio]      of Ocio)

    ([AptoDuomo_Flo] of Apartamento
         (categoria  "Premium")
         (nombre  "Duomo View Flat")
         (precio_noche  120.0)
    )

    ([AptoEixample_Bcn] of Apartamento
         (categoria  "Estandar")
         (nombre  "Apto Eixample")
         (precio_noche  85.0)
    )

    ([AptoKreuzberg_Ber] of Apartamento
         (categoria  "Estandar")
         (nombre  "Kreuzberg Loft")
         (precio_noche  80.0)
    )

    ([AptoMarais_Paris] of Apartamento
         (categoria  "Estandar")
         (nombre  "Marais Studio")
         (precio_noche  110.0)
    )

    ([AptoMarienplatz_Mun] of Apartamento
         (categoria  "Premium")
         (nombre  "Marienplatz Flat")
         (precio_noche  110.0)
    )

    ([AptoPromenade_Niz] of Apartamento
         (categoria  "Estandar")
         (nombre  "Promenade Apto")
         (precio_noche  95.0)
    )

    ([AptoRetiro_Mad] of Apartamento
         (categoria  "Premium")
         (nombre  "Apto Retiro")
         (precio_noche  100.0)
    )

    ([AptoVaticano_Roma] of Apartamento
         (categoria  "Estandar")
         (nombre  "Vatican Flat")
         (precio_noche  90.0)
    )

    ([ArcoTriunfo_Paris] of Monumento
    )

    ([Avion_Bcn_Par] of Avion
         (tieneFin  [Paris])
         (tieneOrigen  [Barcelona])
         (duracion_horas  2.5)
         (medio  "Avion")
         (precio  100)
    )

    ([Avion_Mad_Ber] of Avion
         (tieneFin  [Berlin])
         (tieneOrigen  [Madrid])
         (duracion_horas  2.5)
         (medio  "Avion")
         (precio  100.0)
    )

    ([Avion_Par_Rom] of Avion
         (tieneFin  [Roma])
         (tieneOrigen  [Paris])
         (duracion_horas  2.0)
         (medio  "Avion")
         (precio  90.0)
    )

    ([Ayuntamiento_Mun] of Monumento
    )

    ([Barcelona] of Ciudad
         (conectaCon  [Madrid] [Paris])
         (tieneAlojamiento  [AptoEixample_Bcn] [HostalGotic_Bcn] [HotelW_Bcn])
         (tienePOI  [MuseoPicasso_Bcn] [ParqueGuell_Bcn] [SagradaFamilia_Bcn])
         (clima_habitual  "Templado")
         (cluster_tematico  Ocio)
         (nivel_de_vida  1.1)
         (nombre  "Barcelona")
    )

    ([Berlin] of Ciudad
         (conectaCon  [Madrid] [Munich])
         (tieneAlojamiento  [AptoKreuzberg_Ber] [HostalMitte_Ber] [HotelAdlon_Ber])
         (tienePOI  [MuseoPergamo_Ber] [PuertaBrandeburgo_Ber] [Tiergarten_Ber])
         (clima_habitual  "Frio")
         (cluster_tematico  Cultural)
         (nivel_de_vida  1.3)
         (nombre  "Berlin")
    )

    ([Coliseo_Roma] of Monumento
    )

    ([Duomo_Flo] of Monumento
    )

    ([EnglishGarden_Mun] of Parque
    )

    ([Florencia] of Ciudad
         (conectaCon  [Munich] [Niza] [Roma])
         (tieneAlojamiento  [AptoDuomo_Flo] [HostalArno_Flo] [HotelBrunelleschi_Flo])
         (tienePOI  [Duomo_Flo] [GaleriaUffizi_Flo] [JardinBoboli_Flo])
         (clima_habitual  "Templado")
         (cluster_tematico  Romantico)
         (nivel_de_vida  1.1)
         (nombre  "Florencia")
    )

    ([GaleriaUffizi_Flo] of Museo
    )

    ([HostalArno_Flo] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Arno Hostel")
         (precio_noche  40.0)
    )

    ([HostalGotic_Bcn] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Hostal Gotic")
         (precio_noche  40.0)
    )

    ([HostalIsar_Mun] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Isar Hostel")
         (precio_noche  45.0)
    )

    ([HostalMitte_Ber] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Mitte Hostel")
         (precio_noche  55.0)
    )

    ([HostalMontmartre_Paris] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Montmartre Inn")
         (precio_noche  60.0)
    )

    ([HostalSol_Mad] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Hostal Sol")
         (precio_noche  35.0)
    )

    ([HostalTrastevere_Roma] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Trastevere Hostel")
         (precio_noche  50.0)
    )

    ([HostalVieux_Niz] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Vieux Nice Hostel")
         (precio_noche  45.0)
    )

    ([HotelAdlon_Ber] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Adlon")
         (precio_noche  350.0)
    )

    ([HotelBayerischer_Mun] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Bayerischer Hof")
         (precio_noche  330.0)
    )

    ([HotelBrunelleschi_Flo] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Brunelleschi")
         (precio_noche  290.0)
    )

    ([HotelEden_Roma] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Eden")
         (precio_noche  320.0)
    )

    ([HotelNegresco_Niz] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Negresco")
         (precio_noche  280.0)
    )

    ([HotelRitz_Mad] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Ritz")
         (precio_noche  300.0)
    )

    ([HotelRitz_Paris] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Ritz Paris")
         (precio_noche  400.0)
    )

    ([HotelW_Bcn] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel W")
         (precio_noche  250.0)
    )

    ([JardinBoboli_Flo] of Parque
    )

    ([Madrid] of Ciudad
         (conectaCon  [Barcelona] [Berlin])
         (tieneAlojamiento  [AptoRetiro_Mad] [HostalSol_Mad] [HotelRitz_Mad])
         (tienePOI  [MuseoPrado_Mad] [PalacioReal_Mad] [ParqueRetiro_Mad])
         (clima_habitual  "Templado")
         (cluster_tematico  Ocio)
         (nivel_de_vida  1.0)
         (nombre  "Madrid")
    )

    ([Munich] of Ciudad
         (conectaCon  [Berlin] [Florencia])
         (tieneAlojamiento  [AptoMarienplatz_Mun] [HostalIsar_Mun] [HotelBayerischer_Mun])
         (tienePOI  [Ayuntamiento_Mun] [EnglishGarden_Mun] [MuseoBMW_Mun])
         (clima_habitual  "Frio")
         (cluster_tematico  Cultural)
         (nivel_de_vida  1.4)
         (nombre  "Munich")
    )

    ([MuseoBMW_Mun] of Museo
    )

    ([MuseoLouvre_Paris] of Museo
    )

    ([MuseoMatisse_Niz] of Museo
    )

    ([MuseoPergamo_Ber] of Museo
    )

    ([MuseoPicasso_Bcn] of Museo
    )

    ([MuseoPrado_Mad] of Museo
    )

    ([MuseosVaticanos_Roma] of Museo
    )

    ([Niza] of Ciudad
         (conectaCon  [Florencia] [Paris])
         (tieneAlojamiento  [AptoPromenade_Niz] [HostalVieux_Niz] [HotelNegresco_Niz])
         (tienePOI  [MuseoMatisse_Niz] [ParqueColline_Niz] [PaseoIngleses_Niz])
         (clima_habitual  "Calido")
         (cluster_tematico  Descanso)
         (nivel_de_vida  1.2)
         (nombre  "Niza")
    )

    ([PalacioReal_Mad] of Monumento
    )

    ([Paris] of Ciudad
         (conectaCon  [Barcelona] [Niza] [Roma])
         (tieneAlojamiento  [AptoMarais_Paris] [HostalMontmartre_Paris] [HotelRitz_Paris])
         (tienePOI  [ArcoTriunfo_Paris] [MuseoLouvre_Paris] [TorreEiffel_Paris])
         (clima_habitual  "Templado")
         (cluster_tematico  Romantico)
         (nivel_de_vida  1.4)
         (nombre  "Paris")
    )

    ([ParqueColline_Niz] of Parque
    )

    ([ParqueGuell_Bcn] of Parque
    )

    ([ParqueRetiro_Mad] of Parque
    )

    ([PaseoIngleses_Niz] of Ocio
    )

    ([PuertaBrandeburgo_Ber] of Monumento
    )

    ([Roma] of Ciudad
         (conectaCon  [Florencia] [Paris])
         (tieneAlojamiento  [AptoVaticano_Roma] [HostalTrastevere_Roma] [HotelEden_Roma])
         (tienePOI  [Coliseo_Roma] [MuseosVaticanos_Roma] [VillaBorghese_Roma])
         (clima_habitual  "Templado")
         (cluster_tematico  Cultural)
         (nivel_de_vida  1.2)
         (nombre  "Roma")
    )

    ([SagradaFamilia_Bcn] of Monumento
    )

    ([Tiergarten_Ber] of Parque
    )

    ([TorreEiffel_Paris] of Monumento
    )

    ([Tren_Bcn_Mad] of Tren
         (tieneFin  [Madrid])
         (tieneOrigen  [Barcelona])
         (duracion_horas  2.5)
         (medio  "AVE")
         (precio  35.0)
    )

    ([Tren_Bcn_Par] of Tren
         (tieneFin  [Paris])
         (tieneOrigen  [Barcelona])
         (duracion_horas  6.5)
         (medio  "Tren")
         (precio  60)
    )

    ([Tren_Ber_Mun] of Tren
         (tieneFin  [Munich])
         (tieneOrigen  [Berlin])
         (duracion_horas  4.5)
         (medio  "Tren")
         (precio  55.0)
    )

    ([Tren_Flo_Mun] of Tren
         (tieneFin  [Munich])
         (tieneOrigen  [Florencia])
         (duracion_horas  4.0)
         (medio  "Tren")
         (precio  65.0)
    )

    ([Tren_Mad_Ber] of Tren
         (tieneFin  [Berlin])
         (tieneOrigen  [Madrid])
         (duracion_horas  10.0)
         (medio  "Tren")
         (precio  90.0)
    )

    ([Tren_Niz_Flo] of Tren
         (tieneFin  [Florencia])
         (tieneOrigen  [Niza])
         (duracion_horas  3.5)
         (medio  "Tren")
         (precio  45.0)
    )

    ([Tren_Par_Niz] of Tren
         (tieneFin  [Niza])
         (tieneOrigen  [Paris])
         (duracion_horas  5.5)
         (medio  "Tren")
         (precio  50.0)
    )

    ([Tren_Rom_Flo] of Tren
         (tieneFin  [Florencia])
         (tieneOrigen  [Roma])
         (duracion_horas  1.5)
         (medio  "Tren")
         (precio  40.0)
    )

    ([VillaBorghese_Roma] of Parque
    )


    ([AptoCanales_Ams] of Apartamento
         (categoria  "Estandar")
         (nombre  "Canal View Studio")
         (precio_noche  105.0)
    )

    ([AptoJordaan_Ams] of Apartamento
         (categoria  "Premium")
         (nombre  "Jordaan Loft")
         (precio_noche  125.0)
    )

    ([HostalCentral_Ams] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Central Amsterdam")
         (precio_noche  50.0)
    )

    ([HostalWest_Ams] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "West Side Hostel")
         (precio_noche  65.0)
    )

    ([HotelAmsterdam_Ams] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Waldorf Astoria Amsterdam")
         (precio_noche  360.0)
    )

    ([Museo_Van_Gogh_Ams] of Museo
    )

    ([Anne_Frank_Ams] of Monumento
    )

    ([Vondelpark_Ams] of Parque
    )

    ([CasasCanales_Ams] of Ocio
    )

    ([Amsterdam] of Ciudad
         (conectaCon  [Berlin] [Paris] [Bruselas] [Niza])
         (tieneAlojamiento  [AptoCanales_Ams] [AptoJordaan_Ams] [HostalCentral_Ams] [HostalWest_Ams] [HotelAmsterdam_Ams])
         (tienePOI  [Museo_Van_Gogh_Ams] [Anne_Frank_Ams] [Vondelpark_Ams] [CasasCanales_Ams])
         (clima_habitual  "Frio")
         (cluster_tematico  Descanso)
         (nivel_de_vida  1.3)
         (nombre  "Amsterdam")
    )

    ([AptoRialto_Ven] of Apartamento
         (categoria  "Premium")
         (nombre  "Rialto Romantic Flat")
         (precio_noche  140.0)
    )

    ([AptoSanMarco_Ven] of Apartamento
         (categoria  "Premium")
         (nombre  "San Marco Suite")
         (precio_noche  130.0)
    )

    ([HostalCannareggio_Ven] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Cannaregio Inn")
         (precio_noche  75.0)
    )

    ([HostalGhetto_Ven] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Ghetto Hostel")
         (precio_noche  55.0)
    )

    ([HotelDanieli_Ven] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Danieli")
         (precio_noche  380.0)
    )

    ([BasilicaSanMarco_Ven] of Monumento
    )

    ([PalazoDucal_Ven] of Monumento
    )

    ([MuseoCorrer_Ven] of Museo
    )

    ([PaseoGondolas_Ven] of Ocio
    )

    ([Venecia] of Ciudad
         (conectaCon  [Roma] [Florencia] [Viena])
         (tieneAlojamiento  [AptoRialto_Ven] [AptoSanMarco_Ven] [HostalCannareggio_Ven] [HostalGhetto_Ven] [HotelDanieli_Ven])
         (tienePOI  [BasilicaSanMarco_Ven] [PalazoDucal_Ven] [MuseoCorrer_Ven] [PaseoGondolas_Ven])
         (clima_habitual  "Templado")
         (cluster_tematico  Romantico)
         (nivel_de_vida  1.4)
         (nombre  "Venecia")
    )

    ([AptoOpera_Vie] of Apartamento
         (categoria  "Premium")
         (nombre  "Opera House Flat")
         (precio_noche  115.0)
    )

    ([AptoInnerstadt_Vie] of Apartamento
         (categoria  "Estandar")
         (nombre  "Innerstadt Studio")
         (precio_noche  95.0)
    )

    ([HostalFreyung_Vie] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Freyung Hostel")
         (precio_noche  60.0)
    )

    ([HostalWieden_Vie] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Wieden Budget")
         (precio_noche  45.0)
    )

    ([HotelSacher_Vie] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Sacher")
         (precio_noche  340.0)
    )

    ([OperaViena_Vie] of Monumento
    )

    ([PalacioSchoenbrunn_Vie] of Monumento
    )

    ([MuseoArteHistoria_Vie] of Museo
    )

    ([Prater_Vie] of Parque
    )

    ([Viena] of Ciudad
         (conectaCon  [Munich] [Berlin] [Praga] [Venecia])
         (tieneAlojamiento  [AptoOpera_Vie] [AptoInnerstadt_Vie] [HostalFreyung_Vie] [HostalWieden_Vie] [HotelSacher_Vie])
         (tienePOI  [OperaViena_Vie] [PalacioSchoenbrunn_Vie] [MuseoArteHistoria_Vie] [Prater_Vie])
         (clima_habitual  "Frio")
         (cluster_tematico  Cultural)
         (nivel_de_vida  1.3)
         (nombre  "Viena")
    )

    ([AptoViejaPlaza_Pra] of Apartamento
         (categoria  "Estandar")
         (nombre  "Old Town Square Apto")
         (precio_noche  90.0)
    )

    ([AptoDeiusDecisis_Pra] of Apartamento
         (categoria  "Premium")
         (nombre  "Deiusdeckis Flat")
         (precio_noche  105.0)
    )

    ([HostalMalaStraña_Pra] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Mala Strana Hostel")
         (precio_noche  35.0)
    )

    ([HostalVieja_Pra] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Old Town Inn")
         (precio_noche  50.0)
    )

    ([HotelParizian_Pra] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Parizian")
         (precio_noche  310.0)
    )

    ([CastilloPraga_Pra] of Monumento
    )

    ([PuenteCarlos_Pra] of Monumento
    )

    ([Orloj_Pra] of Monumento
    )

    ([MuseoJudioPraga_Pra] of Museo
    )

    ([Praga] of Ciudad
         (conectaCon  [Viena] [Berlin])
         (tieneAlojamiento  [AptoViejaPlaza_Pra] [AptoDeiusDecisis_Pra] [HostalMalaStraña_Pra] [HostalVieja_Pra] [HotelParizian_Pra])
         (tienePOI  [CastilloPraga_Pra] [PuenteCarlos_Pra] [Orloj_Pra] [MuseoJudioPraga_Pra])
         (clima_habitual  "Frio")
         (cluster_tematico  Familiar)
         (nivel_de_vida  0.9)
         (nombre  "Praga")
    )

    ([AptoSablon_Bru] of Apartamento
         (categoria  "Estandar")
         (nombre  "Sablon District Apto")
         (precio_noche  95.0)
    )

    ([AptoCentral_Bru] of Apartamento
         (categoria  "Premium")
         (nombre  "Central Brussels Flat")
         (precio_noche  120.0)
    )

    ([HostalUxelles_Bru] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Ixelles Hostel")
         (precio_noche  45.0)
    )

    ([HostalEuropeos_Bru] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Europeos Inn")
         (precio_noche  60.0)
    )

    ([HotelPlazaMayor_Bru] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Plaza Mayor")
         (precio_noche  330.0)
    )

    ([GranPlaza_Bru] of Monumento
    )

    ([AtomioBruselas_Bru] of Monumento
    )

    ([MuseoArtistEBruselas_Bru] of Museo
    )

    ([MercadoChocolate_Bru] of Ocio
    )

    ([Bruselas] of Ciudad
         (conectaCon  [Amsterdam] [Paris])
         (tieneAlojamiento  [AptoSablon_Bru] [AptoCentral_Bru] [HostalUxelles_Bru] [HostalEuropeos_Bru] [HotelPlazaMayor_Bru])
         (tienePOI  [GranPlaza_Bru] [AtomioBruselas_Bru] [MuseoArtistEBruselas_Bru] [MercadoChocolate_Bru])
         (clima_habitual  "Frio")
         (cluster_tematico  Aventura)
         (nivel_de_vida  1.1)
         (nombre  "Bruselas")
    )

    ([AptoTemplebar_Dub] of Apartamento
         (categoria  "Estandar")
         (nombre  "Temple Bar Apto")
         (precio_noche  100.0)
    )

    ([AptoGeorgiana_Dub] of Apartamento
         (categoria  "Premium")
         (nombre  "Georgian Square Flat")
         (precio_noche  118.0)
    )

    ([HostalSouthside_Dub] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Southside Hostel")
         (precio_noche  40.0)
    )

    ([HostalNorthside_Dub] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Northside Inn")
         (precio_noche  55.0)
    )

    ([HotelMorrison_Dub] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Morrison Hotel")
         (precio_noche  320.0)
    )

    ([TrinityCollege_Dub] of Monumento
    )

    ([CastilloDublin_Dub] of Monumento
    )

    ([MuseoArqueologia_Dub] of Museo
    )

    ([TempleBar_Dub] of Ocio
    )

    ([Dublin] of Ciudad
         (conectaCon  [Paris])
         (tieneAlojamiento  [AptoTemplebar_Dub] [AptoGeorgiana_Dub] [HostalSouthside_Dub] [HostalNorthside_Dub] [HotelMorrison_Dub])
         (tienePOI  [TrinityCollege_Dub] [CastilloDublin_Dub] [MuseoArqueologia_Dub] [TempleBar_Dub])
         (clima_habitual  "Frio")
         (cluster_tematico  Familiar)
         (nivel_de_vida  1.0)
         (nombre  "Dublin")
    )

    ([Avion_Ams_Ber] of Avion
         (tieneFin  [Berlin])
         (tieneOrigen  [Amsterdam])
         (duracion_horas  1.5)
         (medio  "Avion")
         (precio  80.0)
    )

    ([Avion_Ams_Ber] of Avion
         (tieneFin  [Niza])
         (tieneOrigen  [Amsterdam])
         (duracion_horas  2.5)
         (medio  "Avion")
         (precio  100.0)
    )

    ([Avion_Par_Ams] of Avion
         (tieneFin  [Amsterdam])
         (tieneOrigen  [Paris])
         (duracion_horas  1.5)
         (medio  "Avion")
         (precio  85.0)
    )

    ([Avion_Vie_Ber] of Avion
         (tieneFin  [Berlin])
         (tieneOrigen  [Viena])
         (duracion_horas  2.0)
         (medio  "Avion")
         (precio  95.0)
    )

    ([Avion_Ven_Rom] of Avion
         (tieneFin  [Roma])
         (tieneOrigen  [Venecia])
         (duracion_horas  1.0)
         (medio  "Avion")
         (precio  70.0)
    )

    ([Avion_Pra_Vie] of Avion
         (tieneFin  [Viena])
         (tieneOrigen  [Praga])
         (duracion_horas  1.5)
         (medio  "Avion")
         (precio  60.0)
    )

    ([Avion_Par_Dub] of Avion
         (tieneFin  [Dublin])
         (tieneOrigen  [Paris])
         (duracion_horas  2.5)
         (medio  "Avion")
         (precio  120.0)
    )

    ([Tren_Ams_Ber] of Tren
         (tieneFin  [Berlin])
         (tieneOrigen  [Amsterdam])
         (duracion_horas  7.0)
         (medio  "Tren")
         (precio  75.0)
    )

    ([Tren_Par_Ams] of Tren
         (tieneFin  [Amsterdam])
         (tieneOrigen  [Paris])
         (duracion_horas  3.5)
         (medio  "Tren")
         (precio  65.0)
    )

    ([Tren_Ber_Pra] of Tren
         (tieneFin  [Praga])
         (tieneOrigen  [Berlin])
         (duracion_horas  4.5)
         (medio  "Tren")
         (precio  55.0)
    )

    ([Tren_Pra_Vie] of Tren
         (tieneFin  [Viena])
         (tieneOrigen  [Praga])
         (duracion_horas  4.0)
         (medio  "Tren")
         (precio  45.0)
    )

    ([Tren_Vie_Mun] of Tren
         (tieneFin  [Munich])
         (tieneOrigen  [Viena])
         (duracion_horas  3.5)
         (medio  "Tren")
         (precio  50.0)
    )

    ([Tren_Ven_Flo] of Tren
         (tieneFin  [Florencia])
         (tieneOrigen  [Venecia])
         (duracion_horas  2.0)
         (medio  "Tren")
         (precio  30.0)
    )

    ([Tren_Ven_Rom] of Tren
         (tieneFin  [Roma])
         (tieneOrigen  [Venecia])
         (duracion_horas  5.0)
         (medio  "Tren")
         (precio  60.0)
    )

    ([Tren_Ams_Bru] of Tren
         (tieneFin  [Bruselas])
         (tieneOrigen  [Amsterdam])
         (duracion_horas  2.0)
         (medio  "Tren")
         (precio  35.0)
    )

    ([Tren_Bru_Par] of Tren
         (tieneFin  [Paris])
         (tieneOrigen  [Bruselas])
         (duracion_horas  2.5)
         (medio  "Tren")
         (precio  40.0)
    )

)
