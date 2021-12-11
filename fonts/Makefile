# Font packages
URW_URL = https://github.com/ArtifexSoftware/urw-base35-fonts/archive/20170801.1.tar.gz
AMS_URL = http://www.ams.org/arc/tex/amsfonts.zip
IR_URL  = http://fs.rudi.ir/irfonts.tar.gz
B_URL   = http://fs.rudi.ir/bfonts.tar.gz


# Install everything
all: fonts farsi-fonts

# Install Ghostscript and AMS/Computer Modern fonts
fonts: urw-fonts ams-fonts

# Install Farsi fonts
farsi-fonts: irfonts bfonts


# Tasks for asset retrieval
GET = echo "Fetching $@"; wget --no-config -nv -cO
urw-base35.tar.gz:; $(GET) $@ "$(URW_URL)"
amsfonts.zip:;      $(GET) $@ "$(AMS_URL)"
irfonts.tar.gz:;    $(GET) $@ "$(IR_URL)"
bfonts.tar.gz:;     $(GET) $@ "$(B_URL)"


# Tasks for unpackaging assets
UNTAR = echo "Unpacking $?"; tar xzf
UNZIP = echo "Unzipping $?"; unzip
STAMP = rm -rf "$@" && touch $@

ams-fonts: amsfonts.zip
	test -d $@ || mkdir $@
	$(UNZIP) -Cjqd $@ $? \
		'fonts/afm/public/amsfonts/cm/*.afm' \
		'fonts/type1/public/amsfonts/cm/*.pfb'
	for x in $@/*; do \
		chmod 0644 $$x; \
		mv $$x `basename "$${x%.*}" | tr a-z A-Z`."$${x##*.}"; \
	done
	$(STAMP)

urw-fonts: urw-base35.tar.gz
	$(UNTAR) $?
	mv urw-base35*/fonts/*.t1 .
	mv urw-base35*/fonts/*.afm .
	rm -rf urw-base35*/
	$(STAMP)

irfonts: irfonts.tar.gz
	$(UNTAR) $?
	mv $@/*.ttf .
	$(STAMP)

bfonts: bfonts.tar.gz
	$(UNTAR) $?
	mv $@/*.ttf .
	$(STAMP)


# Tasks related to artefact/asset removal
OBJS = urw-base35.tar.gz amsfonts.zip irfonts.tar.gz bfonts.tar.gz
PKGS = ams-fonts urw-fonts irfonts bfonts

# Remove stamps and font packages
clean:
	rm -rf $(OBJS) $(PKGS)

# As above, but remove extracted fonts as well
clobber: clean
	rm -f *.afm *.pfb *.t1 *.ttf

.PHONY: clean clobber
.SECONDARY: $(OBJS)
.SILENT: $(OBJS) $(PKGS)
