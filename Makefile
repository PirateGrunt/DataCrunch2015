####################
# Makefile
####################

GATHER_DIR  = ./gather
COOK_DIR = ./cook
ANALYZE_DIR = ./analyze
PUBLISH_DIR = ./publish

GATHER_SOURCE = $(wildcard ./gather/*.Rmd)
GATHERED = $(GATHER_SOURCE:.Rmd=.html)

COOK_SOURCE = $(wildcard ./cook/*.Rmd)
COOKED = $(COOK_SOURCE:.Rmd=.html)

ANALYZE_SOURCE = $(wildcard ./analyze/*.Rmd)
ANALYZED = $(ANALYZE_SOURCE:.Rmd=.html)

PUBLISH_SOURCE = $(wildcard ./publish/*.Rmd)
PUBLISHED = $(PUBLISH_SOURCE:.Rmd=.html)

KNIT = Rscript -e "require(rmarkdown); render('$<')"
PUBLISH = Rscript -e "require(rmarkdown); render('$<', output_dir = '../published')"

#########################
## Build recipes
#########################

all: $(GATHERED) $(COOKED) $(ANALYZED) $(PUBLISHED)

cooked: $(COOKED) $(ANALYZED) $(PUBLISHED)

#########################
## Gather
#########################

$(GATHER_DIR)/%.html:$(GATHER_DIR)/%.Rmd
	$(KNIT)

#########################
# Cook
#########################

$(COOK_DIR)/%.html:$(COOK_DIR)/%.Rmd $(GATHER_OUT)
	$(KNIT)

#########################
# Analyze
#########################

$(ANALYZE_DIR)/%.html:$(ANALYZE_DIR)/%.Rmd $(COOK_OUT)
	$(KNIT)

#########################
# Publish
#########################

$(PUBLISH_DIR)/%.html:$(PUBLISH_DIR)/%.Rmd $(ANALYZE_OUT)
	$(PUBLISH)

clean:
	rm -fv $(GATHERED)
	rm -fv $(COOKED)
	rm -fv $(ANALYZED)
	rm -fv $(PUBLISHED)

cleanCooked:
	rm -fv $(COOKED)
	rm -fv $(ANALYZED)
	rm -fv $(PUBLISHED)
