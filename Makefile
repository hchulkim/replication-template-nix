################################
# Makefile for analysis report
#
# Maintainer: HK
################################

## Directory vars
codedir   = code/
builddir  = code/build/
analysdir = code/analysis/
datadir   = data/
outputdir = output/

## Headline build
all: $(outputdir)01_example/tables/example_output.csv

## Example: build step -> analysis step
$(outputdir)01_example/tables/example_output.csv: $(analysdir)01_example/lorem.R
	Rscript $(analysdir)01_example/lorem.R

## Unit tests for shared helpers in R/
test:
	Rscript -e 'testthat::test_dir("tests/testthat", stop_on_failure = TRUE)'

## Draw the Makefile DAG
## Requires: https://github.com/lindenb/makefile2graph
dag: makefile-dag.png
makefile-dag.png: Makefile
	make -Bnd all | make2graph | dot -Tpng -Gdpi=300 -o makefile-dag.png

clean:
	rm -f $(outputdir)*/tables/* $(outputdir)*/figures/*

## Helpers
.PHONY: all clean dag test
