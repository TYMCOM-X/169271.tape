COMMENT SPECIFIES ORDER OF REL FILES IN SAIL LIBRARY
NAM,9
ALL,HEAD,!GOGXL
HDR,GOGXL
	LOR,LUP,KNT,COD,USC
HDR,STRSER.WID
	PRN,SCC,SBK,BRK
HDR,IOSER
	LIN,TTY,OPN,STS,NUM,LOK,OUT,INP,WRD,THR,CLS,MTP,TMP
HDR,STRSER.WID
	CAT,SUB,EQU,PNT,PTC,CVS,CVD,SCN,ABK,CVC,CVL,CVF,DVF
HDR,IOSER
	TBB,PTY,SIM,CHN,FIL,FLS
HDR,GOGXL
	POW,SGC,COR
HDR,STRSER.WID
	DM5
HED,SAIHED,HEAD
	HED
END

HDRFIL is created from HEAD and part of GOGXL.  It contains all
	index and bit and AC declarations, as well as the macros
	which are used in the library.  All comments and blank
	lines are squeezed out.  It is not created unless some
	need for it is exhibited.
DOHEAD is created if needed to create the HEAD entry in the library,
	an INTERNALed symbol table of the user-table things.
SCISS.SAI reads this file to get its instructions.  To read the
	above stuff, consider an example:  If SAIPTC is to be
	compiled, From IOSER will be extracted the code for PTC,
	named SAIPTC.FAI.  This will be assembled with HDRFIL to
	get SAIPTC.REL.  If the first file is not HDRFIL, no extrac-
	tion will be performed.


 