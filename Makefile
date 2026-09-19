all: electrical.pdf

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.aux *.log *.nav *.out *.pdf *.snm *.toc
