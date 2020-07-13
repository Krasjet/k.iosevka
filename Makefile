include config.mk

# Build k.iosevka
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

# Set up environment to build iosevka
setup:
	wget $(IOSEVKA_URL)
	tar xzf v$(IOSEVKA_VERSION).tar.gz
	mv Iosevka-$(IOSEVKA_VERSION) build
	cd build/ && npm install

# SVN is required since it's a pain to let git clone a single directory
# replace svn with
#   git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git nerd
# instead
setup-nerd:
	mkdir -p nerd
	svn checkout $(NERDFONT_SVN)/src/glyphs nerd/src/glyphs
	wget -O nerd/font-patcher $(NERDFONT_GIT)/font-patcher
	chmod +x nerd/font-patcher

# Patch in symbols
patch: nerd/font-patcher out/k.iosevka.term/ttf/
	find out/k.iosevka.term/ttf/ -name '*.ttf' | \
		xargs -n 1 -P 0 ./nerd/font-patcher -c -out ./patched/ 2>/dev/null

# This version will scale wide symbols to be monospace, but I don't like it
patch-mono: nerd/font-patcher out/k.iosevka.term/ttf/
	find out/k.iosevka.term/ttf/ -name '*.ttf' | \
		xargs -n 1 -P 0 ./nerd/font-patcher --mono -c -out ./patched/ 2>/dev/null

# Install patched fonts
install:
	mkdir -p ~/.local/share/fonts/k.iosevka.term/
	cp -Rf ./patched/*.ttf ~/.local/share/fonts/k.iosevka.term/
	mkdir -p ~/.local/share/fonts/k.iosevka/
	cp -Rf ./out/k.iosevka/ttf/*.ttf ~/.local/share/fonts/k.iosevka/
	fc-cache -vf

clean:
	rm -f v$(VERSION).tar.gz
	rm -rf build/dist/

nuke: clean
	rm -rf build/
	rm -rf nerd/
	rm -rf out/
	rm -rf patched/

gen-preview: preview.png preview-italic.png

preview.png: out/k.iosevka/ttf/k-iosevka-regular.ttf gen_preview
	./gen_preview $< $@

preview-italic.png: out/k.iosevka/ttf/k-iosevka-italic.ttf gen_preview
	./gen_preview $< $@

archive:
	tar caf k.iosevka-$(VERSION).tar.gz out/ patched iosevka_license

.PHONY: clean nuke build setup setup-nerd gen-preview install patch patch-mono
