# Font packages
URW_URL = https://github.com/ArtifexSoftware/urw-base35-fonts/archive/20170801.1.tar.gz
AMS_URL = http://www.ams.org/arc/tex/amsfonts.zip
IR_URL  = http://fs.rudi.ir/irfonts.tar.gz
B_URL   = http://fs.rudi.ir/bfonts.tar.gz

# Files used to determine which packages have been downloaded and extracted
URW     = URWGothic-Book.t1
AMS     = CMR8.pfb
IR      = IRNazanin.ttf
B       = BLotus.ttf


# Install everything
all: fonts farsi-fonts

# Install Computer Modern and URW-Core35 fonts
fonts: urw-fonts ams-fonts

# Install Farsi fonts
farsi-fonts: irfonts bfonts


# Tasks for asset retrieval
GET = echo "Fetching $@"; wget --no-config --no-check-certificate -nv -cO
urw-base35.tar.gz:; $(GET) $@ "$(URW_URL)"
amsfonts.zip:;      $(GET) $@ "$(AMS_URL)"
irfonts.tar.gz:;    $(GET) $@ "$(IR_URL)"
bfonts.tar.gz:;     $(GET) $@ "$(B_URL)"


# Tasks for unpackaging assets
UNTAR = echo "Unpacking $?"; tar xzf
UNZIP = echo "Unzipping $?"; unzip

ams-fonts: $(AMS)
$(AMS): amsfonts.zip
	@test -d ams || mkdir ams
	@$(UNZIP) -Cjqd ams $? \
		'fonts/afm/public/amsfonts/cm/*.afm' \
		'fonts/type1/public/amsfonts/cm/*.pfb'
	@for x in ams/*; do \
		chmod 0644 "$$x"; \
		touch -r $? "$$x"; \
		mv "$$x" `basename "$${x%.*}" | tr a-z A-Z`."$${x##*.}"; \
	done
	@rm -rf ams

urw-fonts: $(URW)
$(URW): urw-base35.tar.gz
	@$(UNTAR) $?
	@for i in \
		urw-base35*/fonts/*.t1 \
		urw-base35*/fonts/*.afm \
	; do \
		touch -r $? "$$i"; \
		mv "$$i" .; \
	done
	@rm -rf urw-base35*/

irfonts: $(IR)
$(IR): irfonts.tar.gz
	@$(UNTAR) $?
	@touch -r $? irfonts/*.ttf
	@mv irfonts/*.ttf .
	@rm -rf irfonts*/

bfonts: $(B)
$(B): bfonts.tar.gz
	@$(UNTAR) $?
	@touch -r $? bfonts/*.ttf
	@mv bfonts/*.ttf .
	@rm -rf bfonts*/


# Tasks related to artefact/asset removal
OBJS = urw-base35.tar.gz amsfonts.zip irfonts.tar.gz bfonts.tar.gz

# Remove downloaded packages and extracted fonts
clean:
	rm -rf $(OBJS) *.afm *.pfb *.t1 *.ttf

.PHONY: clean
.SECONDARY: $(OBJS)
.SILENT: $(OBJS)
