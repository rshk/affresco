## Makefile for Affresco

## Build directory
BUILD_DIR := build

## Programs
SCSS := scss --compass
UGLIFYJS := ./node_modules/.bin/uglifyjs
JSHINT := ./node_modules/.bin/jshint
NODE := node
PHANTOMJS := phantomjs

## All your targets are belong to us!
ALL_TARGETS := affresco_css run_jshint affresco_js

## === Configuration for CSS files =============================================

## Common dependencies for all the CSS
AFFRESCO_CSS_COMMON := \
	misc/css-copyright-note.txt \
	scss/variables.scss scss/mixins.scss

## affresco.css
AFFRESCO_CSS := $(BUILD_DIR)/css/affresco.css
AFFRESCO_CSS_MIN := $(BUILD_DIR)/css/affresco.min.css
AFFRESCO_CSS_SOURCES := \
	scss/accordion.scss \
	scss/alerts.scss \
	scss/breadcrumbs.scss \
	scss/button-groups.scss \
	scss/buttons.scss \
	scss/carousel.scss \
	scss/close.scss \
	scss/code.scss \
	scss/component-animations.scss \
	scss/dropdowns.scss \
	scss/forms.scss \
	scss/grid.scss \
	scss/hero-unit.scss \
	scss/labels-badges.scss \
	scss/layouts.scss \
	scss/media.scss \
	scss/mixins.scss \
	scss/modals.scss \
	scss/navbar.scss \
	scss/navs.scss \
	scss/pager.scss \
	scss/pagination.scss \
	scss/popovers.scss \
	scss/progress-bars.scss \
	scss/reset.scss \
	scss/scaffolding.scss \
	scss/sprites.scss \
	scss/tables.scss \
	scss/thumbnails.scss \
	scss/tooltip.scss \
	scss/type.scss \
	scss/utilities.scss \
	scss/variables.scss \
	scss/wells.scss
AFFRESCO_CSS_FILES :=
AFFRESCO_CSS_FILES_MIN = $(patsubst %.css,%.min.css,$(AFFRESCO_CSS_FILES))

## affresco-responsive.css
AFFRESCO_RESPONSIVE_CSS := $(BUILD_DIR)/css/affresco-responsive.css
AFFRESCO_RESPONSIVE_CSS_MIN := $(BUILD_DIR)/css/affresco-responsive.min.css
AFFRESCO_RESPONSIVE_CSS_SOURCES := \
	scss/responsive-1200px-min.scss \
	scss/responsive-767px-max.scss \
	scss/responsive-768px-979px.scss \
	scss/responsive-navbar.scss \
	scss/responsive-utilities.scss
AFFRESCO_RESPONSIVE_CSS_FILES :=
AFFRESCO_RESPONSIVE_CSS_FILES_MIN = $(patsubst %.css,%.min.css,$(AFFRESCO_RESPONSIVE_CSS_FILES))

## === Configuration for JS files ==============================================

AFFRESCO_JS_COMMON := misc/js-copyright-note.txt

AFFRESCO_JS := $(BUILD_DIR)/js/affresco.js
AFFRESCO_JS_MIN := $(BUILD_DIR)/js/affresco.min.js
AFFRESCO_JS_SOURCES := \
	js/bootstrap-affix.js \
	js/bootstrap-alert.js \
	js/bootstrap-button.js \
	js/bootstrap-carousel.js \
	js/bootstrap-collapse.js \
	js/bootstrap-dropdown.js \
	js/bootstrap-modal.js \
	js/bootstrap-popover.js \
	js/bootstrap-scrollspy.js \
	js/bootstrap-tab.js \
	js/bootstrap-tooltip.js \
	js/bootstrap-transition.js \
	js/bootstrap-typeahead.js
AFFRESCO_JS_FILES :=
AFFRESCO_JS_FILES_MIN = $(patsubst %.js,%.min.js,$(AFFRESCO_JS_FILES))

## === More configuration ======================================================
DISTRIB_TMP := .tmp
DISTRIB_DIR := affresco
DISTRIB_ZIP := docs/assets/affresco.zip
DISTRIB_TARBALL := docs/assets/affresco.tar.gz
DATE = $(shell date +%I:%M%p)
CONFIG_FILE := .config.mk


## Prepare the configuration, Kconfig-style
include configure.mk


all: library docs

clean: clean-library clean-docs clean-archives

library: library-dirs $(ALL_TARGETS)

library-dirs:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/css
	mkdir -p $(BUILD_DIR)/js

affresco_css: library-dirs \
	$(AFFRESCO_CSS) $(AFFRESCO_CSS_MIN) \
	$(AFFRESCO_RESPONSIVE_CSS) $(AFFRESCO_RESPONSIVE_CSS_MIN) \
	$(AFFRESCO_CSS_FILES) $(AFFRESCO_CSS_FILES_MIN) \
	$(AFFRESCO_RESPONSIVE_CSS_FILES) $(AFFRESCO_RESPONSIVE_CSS_FILES_MIN)

affresco_js: library-dirs $(AFFRESCO_JS) $(AFFRESCO_JS_MIN) \
	$(AFFRESCO_JS_FILES) $(AFFRESCO_JS_FILES_MIN)

$(AFFRESCO_CSS): $(AFFRESCO_CSS_COMMON) $(AFFRESCO_CSS_SOURCES)
	cat $(AFFRESCO_CSS_COMMON) \
		$(AFFRESCO_CSS_SOURCES) \
		| $(SCSS) -s > $@

$(AFFRESCO_RESPONSIVE_CSS): $(AFFRESCO_CSS_COMMON) \
	$(AFFRESCO_RESPONSIVE_CSS_SOURCES)
	cat $(AFFRESCO_CSS_COMMON) \
		$(AFFRESCO_RESPONSIVE_CSS_SOURCES) \
		| $(SCSS) -s > $@

$(AFFRESCO_CSS_FILES): $(BUILD_DIR)/css/%.css: scss/%.scss
	cat $(AFFRESCO_CSS_COMMON) $< | $(SCSS) -s > $@

$(AFFRESCO_RESPONSIVE_CSS_FILES): $(BUILD_DIR)/css/%.css: scss/%.scss
	cat $(AFFRESCO_CSS_COMMON) $< | $(SCSS) -s > $@

run_jshint:
	$(JSHINT) js/*.js --config js/.jshintrc
	$(JSHINT) js/tests/unit/*.js --config js/.jshintrc

$(AFFRESCO_JS): $(AFFRESCO_JS_COMMON) $(AFFRESCO_JS_SOURCES)
	cat $(AFFRESCO_JS_COMMON) $(AFFRESCO_JS_SOURCES) > $@

$(AFFRESCO_JS_FILES): $(BUILD_DIR)/js/%.js: js/%.js
	cat $(AFFRESCO_JS_COMMON) $< > $@

%.min.css: %.css
	$(SCSS) -tcompressed $< > $@

%.min.js: %.js
	$(UGLIFYJS) -nc $< > $@

clean-library:
	rm -rf $(BUILD_DIR)

love:
	@echo "Peace and love for y'all folks! ♥♥♥"

docs: library
	$(NODE) docs/build
	$(SCSS) docs/assets/scss/docs.scss > docs/assets/css/docs.css
	cp -t docs/assets/css/ $(BUILD_DIR)/css/*.css
	if [ -n  "$(AFFRESCO_JS)" ] || [ -n "$(AFFRESCO_JS_MIN)" ]; then \
		cp -t docs/assets/js/ $(AFFRESCO_JS) $(AFFRESCO_JS_MIN); \
	fi
	if [ -n  "$(AFFRESCO_JS_FILES)" ] || [ -n "$(AFFRESCO_JS_FILES_MIN)" ]; then \
		cp -t docs/assets/js/ $(AFFRESCO_JS_FILES) $(AFFRESCO_JS_FILES_MIN); \
	fi
	cp -t docs/assets/js/ js/tests/vendor/jquery.js

clean-docs:
	@echo "Removing the docs"


archives: $(DISTRIB_ZIP) $(DISTRIB_TARBALL)

clean-archives:
	rm -f $(DISTRIB_ZIP) $(DISTRIB_TARBALL)
	rm -rf $(DISTRIB_DIR)

$(DISTRIB_DIR): $(AFFRESCO_CSS) $(AFFRESCO_CSS_MIN) $(AFFRESCO_JS) $(AFFRESCO_JS_MIN)
	mkdir -p $(DISTRIB_TMP)/$(DISTRIB_DIR)
	mkdir -p $(DISTRIB_TMP)/$(DISTRIB_DIR)/css
	mkdir -p $(DISTRIB_TMP)/$(DISTRIB_DIR)/js
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR) CHANGELOG.md LICENSE README.md
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR)/css/ $(AFFRESCO_CSS) $(AFFRESCO_CSS_MIN)
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR)/js/ $(AFFRESCO_JS) $(AFFRESCO_JS_MIN)


$(DISTRIB_ZIP): library $(DISTRIB_DIR)
	rm -f $@
	cd $(DISTRIB_TMP) && zip -r $(DISTRIB_DIR).zip $(DISTRIB_DIR)
	mv $(DISTRIB_TMP)/$(DISTRIB_DIR).zip $@

$(DISTRIB_TARBALL): library $(DISTRIB_DIR)
	rm -f $@
	cd $(DISTRIB_TMP) && tar czvf $(DISTRIB_DIR).tar.gz $(DISTRIB_DIR)
	mv $(DISTRIB_TMP)/$(DISTRIB_DIR).tar.gz $@



#
# RUN JSHINT & QUNIT TESTS IN PHANTOMJS
#

test:
	$(JSHINT) js/*.js --config js/.jshintrc
	$(JSHINT) js/tests/unit/*.js --config js/.jshintrc
	$(NODE) js/tests/server.js &
	$(PHANTOMJS) js/tests/phantom.js "http://localhost:3000/js/tests"
	kill -9 `cat js/tests/pid.txt`
	rm js/tests/pid.txt


#
# MAKE FOR GH-PAGES 4 FAT & MDO ONLY (O_O  )
#

# gh-pages: library docs
# 	rm -f docs/assets/bootstrap.zip
# 	zip -r docs/assets/bootstrap.zip bootstrap
# 	rm -r bootstrap
# 	rm -f ../bootstrap-gh-pages/assets/bootstrap.zip
# 	node docs/build production
# 	cp -r docs/* ../bootstrap-gh-pages

#
# WATCH LESS FILES
# todo: use inotifywait if watchr not available?
#

watch:
	@echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: docs watch gh-pages library affresco_css affresco_js
