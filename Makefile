BIBTEX=Literatur.bib
INPUTS=$(wildcard ??-*.latex)
SOURCES=LiteOS.latex
TARGETS=$(shell echo ${SOURCES} | sed -e 's/.latex/.pdf/g')
# SUBDIRS=Praesentation/
SUBDIRS=

all: ${TARGETS}
	make clean
	for d in $(SUBDIRS); do \
		cd $$d && make; \
	done

%.pdf: %.latex ${INPUTS} ${BIBTEX}
	pdflatex $< $@ && ( [ ! -f "${BIBTEX}" ] || bibtex $(shell basename $< .latex) ) && pdflatex $< $@ >/dev/null && pdflatex $< $@ >/dev/null

clean:
	for f in ${SOURCES}; do \
		for s in aux bbl blg brf lof lol lot log nav out snm toc vrb; do \
			rm -f `basename $$f | sed -e "s/.latex/.$$s/g"`; \
		done \
	done
	for d in ${SUBDIRS}; do \
		cd $$d && make clean; \
	done

distclean: clean
	rm -f ${TARGETS}
	for d in ${SUBDIRS}; do \
		cd $$d && make distclean; \
	done

todo:
	grep -C 1 "TODO" ${BIBTEX} ${INPUTS} ${SOURCES}

