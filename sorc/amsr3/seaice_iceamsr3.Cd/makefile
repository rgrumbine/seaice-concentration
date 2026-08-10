#Robert Grumbine 5 Aug 2026

include ../makeall.mk

LIBS = ${W3EMC_LIBd} ${BACIO_LIB4}

OBJS = seaice_iceamsr3.o

seaice_iceamsr3 :  $(OBJS)
	$(CPPLD) $(CPPLDFLAGS) $(OBJS) -o $(@) $(MMAB_LIBF4) 

