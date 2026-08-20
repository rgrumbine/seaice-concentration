#Robert Grumbine 5 Aug 2026

include ../makeall.mk

LIBS = ${W3EMC_LIBd} ${BUFR_LIB4} ${BACIO_LIB4}

OBJS=		amsr3.o amsr3out.o
CMD =		seaice_amsr3bufr

all:		$(CMD)

$(CMD):		$(OBJS)
	$(FC) $(FLDFLAGS) -o $(@) $(OBJS) $(LIBS)

