	SUBROUTINE	PRINTMONTH
C
	INTEGER CAL,SYS,LIST
	INTEGER DAYS,DATE,TOPS(128),ID(15,7,7)
	COMMON/IO/CAL,SYS,LIST
	COMMON/ID/ID
	COMMON/MONTH/MONTH
	COMMON/MONTHX/MONTHX(12)
	COMMON/DAYS/DAYS
	COMMON/DATE/DATE
	COMMON/LEAP/LEAP
C
	DATA	(TOPS(I),I=1,128)/'*','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+',
	1'-','-','-','-','-','-','-','-','-','-',
	2'-','-','-','-','-','-','-','+'/
C
C
1	FORMAT(132A1)
C
	DAYS=MONTHX(MONTH)
	IF (MONTH.EQ.2) DAYS=MONTHX(MONTH)+LEAP
	CALL	HEADER
	DATE=1
	DO 10 I=1,6
	CALL	SETWEEK
	IF (I.EQ.6 .AND. ID(1,1,1).EQ.' ') GO TO 12	! SKIP LAST ROW???
	WRITE(CAL,1)(TOPS(J),J=1,128)
10	WRITE(CAL,11)ID
11	FORMAT('*!',1X,15A1,1X,'!',1X,15A1,1X,'!',1X,15A1,1X,'!',
	1 1X,15A1,1X,'!',1X,15A1,1X,'!',1X,15A1,1X,'!',1X,15A1,1X,'!')
12	WRITE(CAL,1)(TOPS(I),I=1,128)
	RETURN
	END
 