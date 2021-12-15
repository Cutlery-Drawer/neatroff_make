# Neatroff top-level Makefile

# Neatroff base directory
BASE = $(PWD)

# Subcomponent directories
BDIR = $(BASE)
DDIR = $(BASE)/devutf
FDIR = $(BASE)/fonts
MDIR = $(BASE)/tmac
MAN  = $(BASE)/share/man

INSTALL = install
MKDIR = mkdir -p -m 755

all: help

help:
	@echo "Neatroff top-level makefile"
	@echo
	@echo "   init        Initialise Git repositories and fonts"
	@echo "   init_fa     Initialise for Farsi"
	@echo "   neat        Compile the programs and generate the fonts"
	@echo "   pull        Update Git repositories (git pull)"
	@echo "   clean       Remove the generated files"
	@echo "   install     Install Neatroff in $(BASE)"
	@echo "   vars        Display directory variables"
	@echo

vars:
	@echo "Directory variables"
	@echo
	@echo "   Base        \$$BASE = $(BASE)"
	@echo "   Binaries    \$$BDIR = $(BDIR)"
	@echo "   Device      \$$DDIR = $(DDIR)"
	@echo "   Fonts       \$$FDIR = $(FDIR)"
	@echo "   Macros      \$$MDIR = $(MDIR)"
	@echo "   Man pages   \$$MAN  = $(MAN)"
	@echo

init:
	@echo "Cloning Git repositories"
	@test -d neatroff || git clone git://github.com/aligrudi/neatroff.git
	@test -d neatpost || git clone git://github.com/aligrudi/neatpost.git
	@test -d neatmkfn || git clone git://github.com/aligrudi/neatmkfn.git
	@test -d neateqn || git clone git://github.com/aligrudi/neateqn.git
	@test -d neatrefer || git clone git://github.com/aligrudi/neatrefer.git
	@test -d troff || git clone -b neat git://repo.or.cz/troff.git
	@echo "Downloading fonts"
	@cd fonts && $(MAKE) fonts

init_fa: init
	@cd fonts && $(MAKE) farsi-fonts

pull:
	cd neatroff && git pull
	cd neatpost && git pull
	cd neatmkfn && git pull
	cd neateqn && git pull
	cd neatrefer && git pull
	cd troff && git pull
	git pull

comp:
	@echo "Compiling programs"
	@cd neatroff && $(MAKE) FDIR="$(FDIR)" MDIR="$(MDIR)"
	@cd neatpost && $(MAKE) FDIR="$(FDIR)" MDIR="$(MDIR)"
	@cd neateqn && $(MAKE)
	@cd neatmkfn && $(MAKE)
	@cd neatrefer && $(MAKE)
	@cd troff/pic && $(MAKE)
	@cd troff/tbl && $(MAKE)
	@cd soin && $(MAKE)
	@cd shape && $(MAKE)

neat: comp
	@echo "Generating font descriptions"
	@cd neatmkfn && ./gen.sh "$(PWD)/fonts" "$(PWD)/devutf" >/dev/null

install:
	@echo "Copying binaries to $(BDIR)"
	@$(MKDIR) "$(BDIR)/neatroff"
	@$(MKDIR) "$(BDIR)/neatpost"
	@$(MKDIR) "$(BDIR)/neateqn"
	@$(MKDIR) "$(BDIR)/neatmkfn"
	@$(MKDIR) "$(BDIR)/neatrefer"
	@$(MKDIR) "$(BDIR)/troff/pic"
	@$(MKDIR) "$(BDIR)/troff/tbl"
	@$(MKDIR) "$(BDIR)/soin"
	@$(MKDIR) "$(BDIR)/shape"
	@$(INSTALL) neatroff/roff "$(BDIR)/neatroff/"
	@$(INSTALL) neatpost/post "$(BDIR)/neatpost/"
	@$(INSTALL) neatpost/pdf "$(BDIR)/neatpost/"
	@$(INSTALL) neateqn/eqn "$(BDIR)/neateqn/"
	@$(INSTALL) neatmkfn/mkfn "$(BDIR)/neatmkfn/"
	@$(INSTALL) neatrefer/refer "$(BDIR)/neatrefer/"
	@$(INSTALL) soin/soin "$(BDIR)/soin/"
	@$(INSTALL) shape/shape "$(BDIR)/shape/"
	@$(INSTALL) troff/pic/pic "$(BDIR)/troff/pic/"
	@$(INSTALL) troff/tbl/tbl "$(BDIR)/troff/tbl/"
	@echo "Copying manual pages to $(MAN)"
	@$(MKDIR) "$(MAN)/man1"
	@$(INSTALL) man/neateqn.1 "$(MAN)/man1"
	@$(INSTALL) man/neatmkfn.1 "$(MAN)/man1"
	@$(INSTALL) man/neatpost.1 "$(MAN)/man1"
	@$(INSTALL) man/neatrefer.1 "$(MAN)/man1"
	@$(INSTALL) man/neatroff.1 "$(MAN)/man1"
	@echo "Copying macros to $(MDIR)"
	@$(MKDIR) "$(MDIR)"
	@cp -r tmac/* "$(MDIR)/"
	@chmod -R 644 "$(MDIR)"
	@chmod 755 "$(MDIR)"
	@find "$(MDIR)" -type d -exec chmod 755 {} \;
	@echo "Copying devutf device to $(DDIR)"
	@$(MKDIR) "$(DDIR)"
	@cp devutf/* "$(DDIR)"
	@chmod 644 "$(DDIR)"/*
	@echo "Copying fonts to $(FDIR)"
	@$(MKDIR) "$(FDIR)"
	@cp fonts/*.afm fonts/*.pfb fonts/*.t1 fonts/*.ttf "$(FDIR)/"
	@chmod 644 "$(FDIR)"/*
	@echo "Updating fontpath in font descriptions"
	@for f in "$(DDIR)"/*; do sed "/^fontpath /s=$(FDIR)=$(DDIR)=" <"$$f" >.fd.tmp; mv .fd.tmp "$$f"; done
	@echo "Updating paths in man pages"
	@cd "$(MAN)/man1" && for f in *.1; do sed "\
		s|\(^\.ds /D \).*|\1$(DDIR)|; \
		s|\(^\.ds /F \).*|\1$(FDIR)|; \
		s|\(^\.ds /M \).*|\1$(MDIR)|; \
	" <"$$f" >.tmp; mv .tmp "$$f"; \
	done

clean:
	@cd fonts && $(MAKE) clean
	@cd neatroff && $(MAKE) clean
	@cd neatpost && $(MAKE) clean
	@cd neateqn && $(MAKE) clean
	@cd neatmkfn && $(MAKE) clean
	@cd neatrefer && $(MAKE) clean
	@cd troff/tbl && $(MAKE) clean
	@cd troff/pic && $(MAKE) clean
	@cd soin && $(MAKE) clean
	@test ! -d shape || (cd shape && $(MAKE) clean)
	@rm -rf devutf
