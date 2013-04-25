## Makefile for Affresco

BUILD_DIR = build
AFFRESCO_CSS = \
	$(BUILD_DIR)/css/affresco.css \
	$(BUILD_DIR)/css/affresco-responsive.css
AFFRESCO_MIN_CSS = \
	$(BUILD_DIR)/css/affresco.min.css \
	$(BUILD_DIR)/css/affresco-responsive.min.css
AFFRESCO_JS = $(BUILD_DIR)/js/affresco.js
AFFRESCO_MIN_JS = $(BUILD_DIR)/js/affresco.min.js
AFFRESCO_JS_SOURCES = \
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
DISTRIB_TMP = .tmp
DISTRIB_DIR = affresco
DISTRIB_ZIP = docs/assets/affresco.zip
DISTRIB_TARBALL = docs/assets/affresco.tar.gz
DATE=$(shell date +%I:%M%p)


SCSS = scss --compass
UGLIFYJS = ./node_modules/.bin/uglifyjs
JSHINT = ./node_modules/.bin/jshint
NODE = node
PHANTOMJS = phantomjs


all: library docs

clean: clean-library clean-docs

library: library-dirs affresco_css run_jshint affresco_js

library-dirs:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/css
	mkdir -p $(BUILD_DIR)/js

affresco_css: library-dirs $(AFFRESCO_CSS) $(AFFRESCO_MIN_CSS)

affresco_js: library-dirs $(AFFRESCO_JS) $(AFFRESCO_MIN_JS)

$(AFFRESCO_CSS): $(BUILD_DIR)/css/%.css: scss/%.scss
	$(SCSS) $< > $@

$(AFFRESCO_MIN_CSS): %.min.css: %.css
	$(SCSS) -tcompressed $< > $@

run_jshint:
	$(JSHINT) js/*.js --config js/.jshintrc
	$(JSHINT) js/tests/unit/*.js --config js/.jshintrc

$(AFFRESCO_JS): misc/js-copyright-note.txt $(AFFRESCO_JS_SOURCES)
	cat misc/js-copyright-note.txt > $@
	cat $(AFFRESCO_JS_SOURCES) >> $@

%.min.js: %.js
	$(UGLIFYJS) -nc $< > $@

clean-library:
	rm -rf $(BUILD_DIR)

docs: library
	$(NODE) docs/build
	cp -t docs/assets/css/ $(BUILD_DIR)/css/*.css
	cp -t docs/assets/js/ js/*.js
	cp -t docs/assets/js/ js/tests/vendor/jquery.js

clean-docs:
	@echo "Removing the docs"


archives: $(DISTRIB_ZIP) $(DISTRIB_TARBALL)

clean-archives:
	rm -f $(DISTRIB_ZIP) $(DISTRIB_TARBALL)
	rm -rf $(DISTRIB_DIR)

$(DISTRIB_DIR):
	mkdir -p $(DISTRIB_TMP)/$(DISTRIB_DIR)
	mkdir -p $(DISTRIB_TMP)/$(DISTRIB_DIR)/css
	mkdir -p $(DISTRIB_TMP)/$(DISTRIB_DIR)/js
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR) CHANGELOG.md LICENSE README.md
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR)/css/ $(AFFRESCO_CSS)
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR)/css/ $(AFFRESCO_MIN_CSS)
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR)/js/ $(AFFRESCO_JS)
	cp -t $(DISTRIB_TMP)/$(DISTRIB_DIR)/js/ $(AFFRESCO_MIN_JS)

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
# todo: use intotifywait if watchr not available?
#

watch:
	@echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: docs watch gh-pages library affresco_css affresco_js
