ROOT_FILE 		= memoire
SLIDES_DIR		= slides
SLIDES_FILE 	= presentation
LATEX_ENGINE	= lualatex
BACKUP_FILES 	= *~
CLEAN_FILES 	= $(BACKUP_FILES) *-frn.tex *.fls *.acn *.acr *.alg *.aux *.bcf *.bbl *.blg *.dvi *.fdb_latexmk *.glg *.glo *.gls *.idx *.ilg *.ind *.ist *.lof *.log *.lot *.lol *.maf *.mtc *.mtc0 *.nav *.nlo *.out *.pdfsync *.ps *.snm *.synctex.gz *.toc *.vrb *.xdy *.tdo *.run.xml *-blx.bib
DIST_FILES 		= $(ROOT_FILE).pdf $(ROOT_FILE)-frn.pdf

.PHONY: clean distclean tex index frontispiece biber prepare simplethesis thesis

clean:
	echo $(CLEAN_FILES) | xargs $(RM); \
	find . -name '$(BACKUP_FILES)' | xargs $(RM);

distclean: clean
	$(RM) $(DIST_FILES)

tex:
	latexmk -pdf -pdflatex="$(LATEX_ENGINE)" $(ROOT_FILE).tex

slides:
	latexmk -pdf -pdflatex="$(LATEX_ENGINE)" $(SLIDES_DIR)/$(SLIDES_FILE).tex

index:
	makeindex -s classic $(ROOT_FILE)

frontispiece:
	if [ ! -f "$(ROOT_FILE)-frn.pdf" ]; \
	then \
		$(LATEX_ENGINE) $(ROOT_FILE)-frn.tex; \
	fi;

biber:
	biber $(ROOT_FILE)

prepare: tex
	$(MAKE) index
	$(MAKE) biber

simplethesis: prepare
	$(MAKE) tex

thesis: prepare
	$(MAKE) frontispiece
	$(MAKE) tex
