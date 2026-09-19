# nonstopmode + halt-on-error: without these pdflatex stops at an interactive
# prompt on error, which in CI just hangs until the runner gives up.
LATEXFLAGS = -interaction=nonstopmode -halt-on-error

all: electrical.pdf

%.pdf: %.tex $(wildcard *.sty)
	pdflatex $(LATEXFLAGS) $<
	pdflatex $(LATEXFLAGS) $<

clean:
	rm -f *.aux *.log *.nav *.out *.pdf *.snm *.toc

.PHONY: all clean
