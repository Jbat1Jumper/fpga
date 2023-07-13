out := _out
cache := $(out)/.cache
mkdir = @mkdir -p $(dir $@)

presentacion: $(out)/presentacion.pdf

$(out)/%.pdf: %.md mystyle.tex
	$(mkdir)
	pandoc -s --dpi=300 --slide-level 2 --toc --include-in-header=./mystyle.tex -t beamer -o $@ $<

-include $(cache)/index.d
