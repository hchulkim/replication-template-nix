################################
# Makefile for analysis report
#
# Maintainer: HK
################################

## Directory vars (usually only these need changing)
inputdir = input/
outputdir = output/
figsdir = output/figures/
tabsdir = output/tables/
slidsdir = output/slides/
papdir = output/paper/

## Headline build
all: $(tabsdir)example_output.csv

## example 
$(tabsdir)example_output.csv: src/lorem.R
	Rscript src/lorem.R

## Draw the Makefile DAG
## Requires: https://github.com/lindenb/makefile2graph
dag: makefile-dag.png
makefile-dag.png: Makefile
	make -Bnd all | make2graph | dot -Tpng -Gdpi=300 -o makefile-dag.png

clean:
	rm -f $(inputdir)* $(figsdir)* $(papdir)* $(slidsdir)* $(papdir)*
	
## Helpers
.PHONY: all clean
