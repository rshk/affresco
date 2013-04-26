ALL_TARGETS = \
	apple-touch-icon-114-precomposed.png \
	apple-touch-icon-144-precomposed.png \
	apple-touch-icon-57-precomposed.png \
	apple-touch-icon-72-precomposed.png \
	favicon.ico \
	favicon.png
SOURCE_FILE = favicon.svg
INKSCAPE = inkscape
CONVERT = convert

all: $(ALL_TARGETS)

apple-touch-icon-114-precomposed.png: $(SOURCE_FILE)
	$(INKSCAPE) --export-png=$@ --export-area-page -w 114 -h 114 $<

apple-touch-icon-144-precomposed.png: $(SOURCE_FILE)
	$(INKSCAPE) --export-png=$@ --export-area-page -w 144 -h 144 $<

apple-touch-icon-57-precomposed.png: $(SOURCE_FILE)
	 $(INKSCAPE) --export-png=$@ --export-area-page -w 57 -h 57 $<

apple-touch-icon-72-precomposed.png: $(SOURCE_FILE)
	$(INKSCAPE) --export-png=$@ --export-area-page -w 72 -h 72 $<

favicon.ico: favicon.png
	$(CONVERT) $< $@

favicon.png: $(SOURCE_FILE)
	$(INKSCAPE) --export-png=$@ --export-area-page -w 32 -h 32 $<

clean:
	rm $(ALL_TARGETS)
