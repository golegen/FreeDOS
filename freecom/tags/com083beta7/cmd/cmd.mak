.AUTODEPEND

CFG = TCCDOS.CFG
CFG_DEPENDENCIES = cmd.mak

#		*Translator Definitions*
##>> Modify this file with your local settings
!include "..\config.mak"


all: $(CFG) cmds.lib

#		*Implicit Rules*
.c.obj:
  $(CC) -c {$< }
.asm.obj:
	$(NASM) $(NASMFLAGS) -f obj $<

cmds.lib : $(CFG) alias.obj \
	beep.obj \
	break.obj \
	call.obj \
	cdd.obj \
	chdir.obj \
	cls.obj \
	copy.obj \
	ctty.obj \
	date.obj \
	del.obj \
	dir.obj \
	dirs.obj \
	doskey.obj \
	echo.obj \
	exit.obj \
	fddebug.obj \
	for.obj \
	goto.obj \
	history.obj \
	if.obj \
	memory.obj \
	mkdir.obj \
	path.obj \
	pause.obj \
	popd.obj \
	prompt.obj \
	pushd.obj \
	rem.obj \
	ren.obj \
	rmdir.obj \
	set.obj \
	shift.obj \
	time.obj \
	truename.obj \
	type.obj \
	verify.obj \
	which.obj 
	if exist cmds.lib $(TLIB) cmds.lib /c @&&|
+-alias.obj &
+-beep.obj &
+-break.obj &
+-call.obj &
+-cdd.obj &
+-chdir.obj &
+-cls.obj &
+-copy.obj &
+-ctty.obj &
+-date.obj &
+-del.obj &
+-dir.obj &
+-dirs.obj &
+-doskey.obj &
+-echo.obj &
+-exit.obj &
+-fddebug.obj &
+-for.obj &
+-goto.obj &
+-history.obj &
+-if.obj &
+-memory.obj &
+-mkdir.obj &
+-path.obj &
+-pause.obj &
+-popd.obj &
+-prompt.obj &
+-pushd.obj &
+-rem.obj &
+-ren.obj &
+-rmdir.obj &
+-set.obj &
+-shift.obj &
+-time.obj &
+-truename.obj &
+-type.obj &
+-verify.obj &
+-which.obj
| , cmds.lst 
	if not exist cmds.lib $(TLIB) cmds.lib /c @&&|
+alias.obj &
+beep.obj &
+break.obj &
+call.obj &
+cdd.obj &
+chdir.obj &
+cls.obj &
+copy.obj &
+ctty.obj &
+date.obj &
+del.obj &
+dir.obj &
+dirs.obj &
+doskey.obj &
+echo.obj &
+exit.obj &
+fddebug.obj &
+for.obj &
+goto.obj &
+history.obj &
+if.obj &
+memory.obj &
+mkdir.obj &
+path.obj &
+pause.obj &
+popd.obj &
+prompt.obj &
+pushd.obj &
+rem.obj &
+ren.obj &
+rmdir.obj &
+set.obj &
+shift.obj &
+time.obj &
+truename.obj &
+type.obj &
+verify.obj &
+which.obj
| , cmds.lst 

