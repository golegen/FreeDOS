#
# WATCOM.MAK - kernel copiler options for WATCOM C 11.0c
#

# Use these for WATCOM 11.0c
COMPILERPATH=$(WATCOM)
COMPILERBIN=$(WATCOM)\binw
CC=$(COMPILERBIN)\wcl
INCLUDEPATH=$(COMPILERPATH)\H
INCLUDE=$(COMPILERPATH)\h 
EDPATH=$(COMPILERPATH)\EDDAT

!if $(XCPU) != 186
!if $(XCPU) != 386
TARGETOPT=-0
!endif
!endif

LIBPATH=$(COMPILERPATH)\lib286
LIBUTIL=$(COMPILERBIN)\wlib 
LIBPLUS=
LIBTERM=

CFLAGST=-zp=1 -mt -os -s -we -e=3 -w=2
CFLAGSC=-zp=1 -mc -os -s -we -e=3 -w=2

TARGET=KWC

# used for building the library

CLIB=$(COMPILERPATH)\lib286\dos\clibm.lib

# we use our own ones, which override these ones when linking.
#  

MATH_EXTRACT=*i4d *i4m
MATH_INSERT= +i4d +i4m


#
# heavy stuff - building  
#
# -e=<num>      set limit on number of error messages
# -ms           small memory model (small code/small data)
# -j            change char default from unsigned to signed   
#-nc=<id>      set code class name
#-nd=<id>      set data segment name
#-nm=<file>    set module name
#-nt=<id>      set name of text segment  
# -g=<id>       set code group name
# -os           -> favor code size over execution time in optimizations
# -s            remove stack overflow checks  
# -w=<num>      set warning level number 
# -we           treat all warnings as errors   
# -ze           enable extensions (i.e., near, far, export, etc.)
# -zl           remove default library information
# -zp=<num>     pack structure members with alignment {1,2,4,8,16}
# -zq           operate quietly
#
# -3		optimization for 386 - given in CONFIG.MAK, not here
#

ALLCFLAGS=-I..\hdr $(TARGETOPT) $(ALLCFLAGS) -zq -os -s -e=5 -j -zl -zp=1 -we
INITCFLAGS=$(ALLCFLAGS) -nt=INIT_TEXT -nc=INIT -nd=I -g=I_GROUP
CFLAGS=$(ALLCFLAGS) -nt=HMA_TEXT -nc=HMA -g=HGROUP
INITPATCH=..\utils\patchobj __U4D=_IU4D __U4M=_IU4M

