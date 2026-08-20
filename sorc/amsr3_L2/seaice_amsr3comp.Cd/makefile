#Robert Grumbine 11 Aug 2016

include ../makeall.mk

#Should be no changes below this point---------------------------------

all : seaice_amsr3comp

seaice_amsr3comp: amsr3comp.o
	$(CPPLD) $(MMAB_LIBF4) $< $(CPPLDFLAGS) -o $(@)
