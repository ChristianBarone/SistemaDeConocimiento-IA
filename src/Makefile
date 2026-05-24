# ============================================================
# Makefile per executar el sistema expert de viatges en CLIPS
# Ús:
#   make                     -> execució normal (amb preguntes)
#   make test-estandard      -> prova d'un cas estàndard
#   make test-restrtrans     -> prova restricció de transport
#   make test-accessibilitat -> prova d'accessibilitat
#   make test-explorador     -> prova d'usuari explorador
#   make test-nens           -> prova de família amb nens
#   make test-impossibilitat -> prova de requisits impossibles
#   make shell               -> shell interactiva amb tot carregat
#   make zip                 -> crea un arxiu .zip amb tot el projecte
#   make clean               -> esborra fitxers temporals
# ============================================================

CLIPS = clips

LOADS = loads.txt

SRCS = main.clp \
       ontologia_Final.clp \
       instancias_Ciudad.clp \
       instancias_Alojamiento.clp \
       instancias_PDI.clp \
       instancias_Transporte.clp \
       modulo-preguntas.clp \
       modulo-abstraccion.clp \
       modulo-heuristica.clp \
       modulo-refinamiento.clp \
       modulo-salida.clp

# ------------------------------------------------------------
# Target per defecte: execució normal amb preguntes
# ------------------------------------------------------------
.PHONY: run
run: run.clp
	@echo "============================================"
	@echo "  Iniciant sistema expert de viatges..."
	@echo "============================================"
	$(CLIPS) -f $(LOADS) -f2 run.clp

run.clp:
	@echo "(run)" > run.clp

# ------------------------------------------------------------
# Proves automàtiques
# ------------------------------------------------------------
.PHONY: test-estandard
test-estandard:
	@echo "============================================"
	@echo "  Prova 1: Cas Estàndard"
	@echo "============================================"
	$(CLIPS) -f prova1-estandard.clp

.PHONY: test-restrtrans
test-restrtrans:
	@echo "============================================"
	@echo "  Prova 2: Restricció de transport"
	@echo "============================================"
	$(CLIPS) -f prova2-restrtrans.clp

.PHONY: test-accessibilitat
test-accessibilitat:
	@echo "============================================"
	@echo "  Prova 3: Accessibilitat (mobilitat reduida)"
	@echo "============================================"
	$(CLIPS) -f prova3-accessibilitat.clp

.PHONY: test-explorador
test-explorador:
	@echo "============================================"
	@echo "  Prova 4: Explorador"
	@echo "============================================"
	$(CLIPS) -f prova4-explorador.clp

.PHONY: test-nens
test-nens:
	@echo "============================================"
	@echo "  Prova 5: Família amb nens"
	@echo "============================================"
	$(CLIPS) -f prova5-nens.clp

.PHONY: test-impossibilitat
test-impossibilitat:
	@echo "============================================"
	@echo "  Prova 6: Impossibilitat"
	@echo "============================================"
	$(CLIPS) -f prova6-impossibilitat.clp

# ------------------------------------------------------------
# Shell interactiva amb tot carregat
# ------------------------------------------------------------
.PHONY: shell
shell:
	@echo "Shell CLIPS. Escriu (run) per iniciar, (exit) per sortir."
	$(CLIPS) -f $(LOADS)

# ------------------------------------------------------------
# Comprimir projecte
# ------------------------------------------------------------
.PHONY: zip
zip:
	@echo "Creant l'arxiu zip de tota la carpeta..."
	@zip -r src.zip . -x "*.zip"
	@echo "Arxiu src.zip creat amb èxit."

# ------------------------------------------------------------
# Neteja
# ------------------------------------------------------------
.PHONY: clean
clean:
	@rm -f run.clp *.zip
	@echo "Neteja completada."

# ------------------------------------------------------------
# Ajuda
# ------------------------------------------------------------
.PHONY: help
help:
	@echo ""
	@echo "  make                     Execucio normal amb preguntes interactives"
	@echo "  make test-estandard      Prova d'un cas estàndard (prova1)"
	@echo "  make test-restrtrans     Prova d'usuari amb restricció de transport (prova2)"
	@echo "  make test-accessibilitat Prova d'accessibilitat per mobilitat reduida (prova3)"
	@echo "  make test-explorador     Prova d'usuari explorador (prova4)"
	@echo "  make test-nens           Prova d'una família amb nens (prova5)"
	@echo "  make test-impossibilitat Prova on els requisits són impossibles (prova6)"
	@echo "  make zip                 Crea un arxiu projecte_viatges.zip amb tota la carpeta"
	@echo "  make clean               Esborra fitxers temporals"
	@echo ""
	@echo "  Si CLIPS no es troba, edita la variable CLIPS= al principi"
	@echo ""