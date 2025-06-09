#Robert Grumbine 27 May 2016

include ../makeall.mk

#Should be no changes below this point---------------------------------
seaice_blend : blend.o
	$(CPPLD) $(CPPLDFLAGS) $< $(MMAB_LIBF4) -o $(@)
