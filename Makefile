include config.mk

build: build/private-build-plans.toml
	cd build/ && \
	npm run build -- woff2::k-iosevka && \
	npm run build -- woff2::k-iosevka-term
	mkdir out/
	cp -r ./build/dist/k-iosevka out/k.iosevka
	cp -r ./build/dist/k-iosevka-term out/k.iosevka.term

preview.png: out/k.iosevka/ttf/k-iosevka-regular.ttf
	./gen_preview $< $@

preview-italic.png: out/k.iosevka/ttf/k-iosevka-italic.ttf
	./gen_preview $< $@

build/private-build-plans.toml: k.iosevka.toml
	cp k.iosevka.toml $@

setup:
	wget $(ARCHIVE_URL)
	tar xzf v$(VERSION).tar.gz
	mv Iosevka-$(VERSION) build
	cd build/ && npm install

clean:
	rm -f v$(VERSION).tar.gz
	rm -rf build/dist/

nuke: clean
	rm -rf build/

.PHONY: clean nuke build setup all
