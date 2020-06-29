include config.mk

build: build/private-build-plans.toml
	cd build/ && \
	npm run build -- contents::k-iosevka && \
	npm run build -- contents::k-iosevka-term
	mkdir -p out/
	rm -rf out/*
	cp -Rf ./build/dist/k-iosevka out/k.iosevka
	cp -Rf ./build/dist/k-iosevka-term out/k.iosevka.term

build/private-build-plans.toml: k.iosevka.toml
	cp $< $@

setup:
	wget $(IOSEVKA_URL)
	tar xzf v$(IOSEVKA_VERSION).tar.gz
	mv Iosevka-$(IOSEVKA_VERSION) build
	cd build/ && npm install

# SVN is required since it's a pain to let git clone a single directory
setup-nerd:
	mkdir -p nerd
	svn checkout $(NERDFONT_SVN)/src/glyphs nerd/src/glyphs
	wget -O nerd/font-patcher $(NERDFONT_GIT)/font-patcher
	chmod +x nerd/font-patcher

patch: nerd/font-patcher out/k.iosevka.term/ttf/
	find out/k.iosevka.term/ttf/ -name '*.ttf' | xargs -n 1 -P 0 ./nerd/font-patcher -c -out ./patched/ 2>/dev/null

patch-mono: nerd/font-patcher out/k.iosevka.term/ttf/
	find out/k.iosevka.term/ttf/ -name '*.ttf' | xargs -n 1 -P 0 ./nerd/font-patcher --mono -c -out ./patched/ 2>/dev/null

install:
	mkdir -p ~/.local/share/fonts/k.iosevka.term/
	cp -Rf ./patched/*.ttf ~/.local/share/fonts/k.iosevka.term/
	fc-cache -vf

clean:
	rm -f v$(VERSION).tar.gz
	rm -rf build/dist/

nuke: clean
	rm -rf build/
	rm -rf nerd/

gen-preview: preview.png preview-italic.png

preview.png: out/k.iosevka/ttf/k-iosevka-regular.ttf
	./gen_preview $< $@

preview-italic.png: out/k.iosevka/ttf/k-iosevka-italic.ttf
	./gen_preview $< $@


.PHONY: clean nuke build setup setup-nerd gen-preview install patch patch-mono
