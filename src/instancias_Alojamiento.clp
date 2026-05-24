;crear-viajes-base
;(send [AptoVaticano_Roma] get-nombre)
(definstances instancias-alojamiento

; =================================================================
; AMSTERDAM
; =================================================================
([AptoCanales_Ams] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Canales")
   (precio_noche 77.5)
   (accesible SI)
   (calidad 4)
)

([HostalJordaan_Ams] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Jordaan")
   (precio_noche 44.4)
   (accesible SI)
   (calidad 3)
)

([HotelMuseo_Ams] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Museo")
   (precio_noche 147.5)
   (accesible SI)
   (calidad 4)
)

([HotelAmstel_Ams] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Amstel")
   (precio_noche 210.0)
   (accesible SI)
   (calidad 5)
)

([AptoJordaan_Ams] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Jordaan")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalCentral_Ams] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Central")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalWest_Ams] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal West")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelAmsterdam_Ams] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Amsterdam")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; BARCELONA
; =================================================================
([AptoEixample_Bcn] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Eixample")
   (precio_noche 66.5)
   (accesible SI)
   (calidad 4)
)

([HostalBorn_Bcn] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Born")
   (precio_noche 38.8)
   (accesible SI)
   (calidad 3)
)

([HotelGracia_Bcn] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Gracia")
   (precio_noche 128.5)
   (accesible SI)
   (calidad 4)
)

([HotelBarceloneta_Bcn] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Barceloneta")
   (precio_noche 180.0)
   (accesible SI)
   (calidad 5)
)

([HostalGotic_Bcn] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Gotic")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelW_Bcn] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel W")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; BERGEN
; =================================================================
([AptoBryggen_Ber] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Bryggen")
   (precio_noche 89.5)
   (accesible SI)
   (calidad 4)
)

([HostalFiordo_Ber] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Fiordo")
   (precio_noche 41.6)
   (accesible PARCIAL)
   (calidad 2)
)

([HotelCentro_Ber] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Centro")
   (precio_noche 114.4)
   (accesible SI)
   (calidad 3)
)

([HotelFloyen_Ber] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Floyen")
   (precio_noche 225.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; COPENHAGUE
; =================================================================
([AptoNyhavn_Cop] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Nyhavn")
   (precio_noche 86.0)
   (accesible SI)
   (calidad 4)
)

([HostalCentro_Cop] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Centro")
   (precio_noche 39.2)
   (accesible SI)
   (calidad 3)
)

([HotelTivoli_Cop] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Tivoli")
   (precio_noche 165.0)
   (accesible SI)
   (calidad 4)
)

([HotelNorro_Cop] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Norro")
   (precio_noche 240.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; DUBLÍN
; =================================================================
([AptoTemplebar_Dub] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento TempleBar")
   (precio_noche 73.0)
   (accesible SI)
   (calidad 3)
)

([HostalGeorgian_Dub] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Georgian")
   (precio_noche 30.0)
   (accesible SI)
   (calidad 3)
)

([HotelLiffey_Dub] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Liffey")
   (precio_noche 95.0)
   (accesible SI)
   (calidad 4)
)

([HotelDocklands_Dub] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Docklands")
   (precio_noche 180.0)
   (accesible SI)
   (calidad 5)
)

([AptoGeorgiana_Dub] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Georgiana")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalSouthside_Dub] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Southside")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalNorthside_Dub] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Northside")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelMorrison_Dub] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Morrison")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; FLORENCIA
; =================================================================
([AptoDuomo_Flo] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Duomo")
   (precio_noche 66.5)
   (accesible SI)
   (calidad 4)
)

([HostalArno_Flo] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Arno")
   (precio_noche 38.8)
   (accesible SI)
   (calidad 3)
)

([HotelUffizi_Flo] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Uffizi")
   (precio_noche 128.5)
   (accesible SI)
   (calidad 4)
)

([HotelOltrarno_Flo] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Oltrarno")
   (precio_noche 180.0)
   (accesible SI)
   (calidad 5)
)

([HotelBrunelleschi_Flo] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Brunelleschi")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; FUNCHAL
; =================================================================
([AptoMadeira_Fun] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Madeira")
   (precio_noche 50.0)
   (accesible SI)
   (calidad 4)
)

([HostalMarina_Fun] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Marina")
   (precio_noche 32.0)
   (accesible SI)
   (calidad 3)
)

([HotelLido_Fun] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Lido")
   (precio_noche 103.0)
   (accesible SI)
   (calidad 4)
)

([HotelJardin_Fun] of Alojamiento
   (categoria HOTEL)
   (nombre "Resort Jardin")
   (precio_noche 170.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; INNSBRUCK
; =================================================================
([AptoAlpen_Inn] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Alpen")
   (precio_noche 72.0)
   (accesible SI)
   (calidad 4)
)

([HostalAltstadt_Inn] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Altstadt")
   (precio_noche 38.4)
   (accesible SI)
   (calidad 2)
)

([HotelNordkette_Inn] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Nordkette")
   (precio_noche 105.6)
   (accesible SI)
   (calidad 3)
)

([HotelInn_Inn] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Inn")
   (precio_noche 195.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; LJUBLJANA
; =================================================================
([AptoCentro_Lju] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Centro")
   (precio_noche 50.0)
   (accesible SI)
   (calidad 3)
)

([HostalRio_Lju] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Rio")
   (precio_noche 30.4)
   (accesible SI)
   (calidad 2)
)

([HotelCastillo_Lju] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Castillo")
   (precio_noche 100.0)
   (accesible SI)
   (calidad 4)
)

([HotelTivoli_Lju] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Tivoli")
   (precio_noche 135.0)
   (accesible SI)
   (calidad 4)
)

; =================================================================
; MADRID
; =================================================================
([AptoRetiro_Mad] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Retiro")
   (precio_noche 73.0)
   (accesible SI)
   (calidad 3)
)

([HostalSol_Mad] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Sol")
   (precio_noche 30.0)
   (accesible SI)
   (calidad 3)
)

([HotelMalasana_Mad] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Malasana")
   (precio_noche 95.0)
   (accesible SI)
   (calidad 4)
)

([HotelLetras_Mad] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Letras")
   (precio_noche 180.0)
   (accesible SI)
   (calidad 5)
)

([HotelRitz_Mad] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Ritz")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; MÚNICH
; =================================================================
([AptoMarienplatz_Mun] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Marienplatz")
   (precio_noche 95.0)
   (accesible SI)
   (calidad 4)
)

([HostalIsar_Mun] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Isar")
   (precio_noche 41.2)
   (accesible SI)
   (calidad 3)
)

([HotelSchwabing_Mun] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Schwabing")
   (precio_noche 133.0)
   (accesible SI)
   (calidad 4)
)

([HotelAltstadt_Mun] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Altstadt")
   (precio_noche 240.0)
   (accesible SI)
   (calidad 5)
)

([HotelBayerischer_Mun] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Bayerischer")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; NIZA
; =================================================================
([AptoPromenade_Niz] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Promenade")
   (precio_noche 60.0)
   (accesible SI)
   (calidad 4)
)

([HostalVieuxNice_Niz] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal VieuxNice")
   (precio_noche 41.6)
   (accesible SI)
   (calidad 3)
)

([HotelGaribaldi_Niz] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Garibaldi")
   (precio_noche 146.0)
   (accesible SI)
   (calidad 4)
)

([HotelPuerto_Niz] of Alojamiento
   (categoria HOTEL)
   (nombre "Resort Puerto")
   (precio_noche 204.0)
   (accesible SI)
   (calidad 5)
)

([HostalVieux_Niz] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Vieux")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelNegresco_Niz] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Negresco")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; OPORTO
; =================================================================
([AptoRibeira_Opo] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Ribeira")
   (precio_noche 67.5)
   (accesible SI)
   (calidad 3)
)

([HostalAliados_Opo] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Aliados")
   (precio_noche 27.2)
   (accesible SI)
   (calidad 2)
)

([HotelCedofeita_Opo] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Cedofeita")
   (precio_noche 85.5)
   (accesible SI)
   (calidad 4)
)

([HotelGaia_Opo] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Gaia")
   (precio_noche 165.0)
   (accesible SI)
   (calidad 4)
)

; =================================================================
; PARÍS
; =================================================================
([AptoMarais_Par] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Marais")
   (precio_noche 92.0)
   (accesible SI)
   (calidad 4)
)

([HostalMontmartre_Par] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Montmartre")
   (precio_noche 39.2)
   (accesible SI)
   (calidad 3)
)

([HotelLatin_Par] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Latin")
   (precio_noche 173.0)
   (accesible SI)
   (calidad 4)
)

([HotelSaintGermain_Par] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel SaintGermain")
   (precio_noche 225.0)
   (accesible SI)
   (calidad 5)
)

([AptoMarais_Paris] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Marais Paris")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalMontmartre_Paris] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Montmartre Paris")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelRitz_Paris] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Ritz Paris")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; PRAGA
; =================================================================
([AptoPlazaVieja_Pra] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento PlazaVieja")
   (precio_noche 64.5)
   (accesible SI)
   (calidad 3)
)

([HostalMalaStrana_Pra] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal MalaStrana")
   (precio_noche 25.2)
   (accesible SI)
   (calidad 2)
)

([HotelCastillo_Pra] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Castillo")
   (precio_noche 125.5)
   (accesible SI)
   (calidad 4)
)

([HotelVltava_Pra] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Vltava")
   (precio_noche 150.0)
   (accesible SI)
   (calidad 4)
)

([AptoViejaPlaza_Pra] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Vieja Plaza")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([AptoDeiusDecisis_Pra] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Deius Decisis")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalMalaStraña_Pra] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Mala Strana")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalVieja_Pra] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Vieja")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelParizian_Pra] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Parizian")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; ROMA
; =================================================================
([AptoVaticano_Roma] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Vaticano")
   (precio_noche 78.0)
   (accesible SI)
   (calidad 4)
)

([HostalTrastevere_Roma] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Trastevere")
   (precio_noche 41.6)
   (accesible SI)
   (calidad 3)
)

([HotelNavona_Roma] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Navona")
   (precio_noche 146.0)
   (accesible SI)
   (calidad 4)
)

([HotelMonti_Roma] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Monti")
   (precio_noche 180.0)
   (accesible SI)
   (calidad 5)
)

([HotelEden_Roma] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Eden")
   (precio_noche 500.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; SALZBURGO
; =================================================================
([AptoMozart_Sal] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Mozart")
   (precio_noche 72.0)
   (accesible SI)
   (calidad 4)
)

([HostalAltstadt_Sal] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Altstadt")
   (precio_noche 38.4)
   (accesible SI)
   (calidad 2)
)

([HotelMirabell_Sal] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Mirabell")
   (precio_noche 105.6)
   (accesible SI)
   (calidad 3)
)

([HotelAlpes_Sal] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Alpes")
   (precio_noche 195.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; VALENCIA
; =================================================================
([AptoCarmen_Val] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Carmen")
   (precio_noche 45.0)
   (accesible SI)
   (calidad 4)
)

([HostalRuzafa_Val] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Ruzafa")
   (precio_noche 31.2)
   (accesible SI)
   (calidad 2)
)

([HotelTuria_Val] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Turia")
   (precio_noche 101.5)
   (accesible SI)
   (calidad 4)
)

([HotelMalvarrosa_Val] of Alojamiento
   (categoria HOTEL)
   (nombre "Resort Malvarrosa")
   (precio_noche 153.0)
   (accesible SI)
   (calidad 5)
)

; =================================================================
; VENECIA
; =================================================================
([AptoRialto_Ven] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Rialto")
   (precio_noche 77.0)
   (accesible SI)
   (calidad 4)
)

([HostalSanMarco_Ven] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal SanMarco")
   (precio_noche 43.2)
   (accesible SI)
   (calidad 3)
)

([HotelLaguna_Ven] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Laguna")
   (precio_noche 141.0)
   (accesible SI)
   (calidad 4)
)

([HotelCannaregio_Ven] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Cannaregio")
   (precio_noche 255.0)
   (accesible SI)
   (calidad 5)
)

([AptoSanMarco_Ven] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento San Marco")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalCannareggio_Ven] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Cannareggio")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalGhetto_Ven] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Ghetto")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelDanieli_Ven] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Danieli")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

; =================================================================
; VIENA
; =================================================================
([AptoOpera_Vie] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Opera")
   (precio_noche 86.5)
   (accesible SI)
   (calidad 4)
)

([HostalInnereStadt_Vie] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal InnereStadt")
   (precio_noche 36.4)
   (accesible SI)
   (calidad 3)
)

([HotelBelvedere_Vie] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Belvedere")
   (precio_noche 163.5)
   (accesible SI)
   (calidad 4)
)

([HotelDanubio_Vie] of Alojamiento
   (categoria HOTEL)
   (nombre "Grand Hotel Danubio")
   (precio_noche 210.0)
   (accesible SI)
   (calidad 5)
)

([AptoInnerstadt_Vie] of Alojamiento
   (categoria APARTAMENTO)
   (nombre "Apartamento Innerstadt")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalFreyung_Vie] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Freyung")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HostalWieden_Vie] of Alojamiento
   (categoria HOSTAL)
   (nombre "Hostal Wieden")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)

([HotelSacher_Vie] of Alojamiento
   (categoria HOTEL)
   (nombre "Hotel Sacher")
   (precio_noche 0.0)
   (accesible SI)
   (calidad 1)
)
)
