	PROGRAM BIGCAL
!
!	CALENDAR PROGRAM -- FOR PRODUCING A LARGE CALENDAR
!
!  **	BY CARL A. BALTRUNAS	OCTOBER 1975	Version %1
!
!			Revision History
!
!	%Version /WHO	When		What was done
!	---------------------------------------------
!	%1 (1)	/CAB	JAN 1979	! READ SYSTEM DATE FILE
!
!	%1 (2)	/CAB	FEB 1979	! BETTER USE OF ENCODE/DECODE
!					! MORE INTERACTION WITH USER
!					! BETTER DATE FILE HANDLING
!
!  **	%2 (3)	/CAB	MAY 1979	! READS MULTI DATE-INPUT FILES
!
!	%2 (4)	/CAB	MAY 1979	! ACCEPTS MON-YEAR ==> MON-YEAR
!
!	%2 (5)	/CAB	Nov 1979	! Fix future date problem
!					! which would not accept
!					! current year.
!
!	%2 (6)	/CAB	Feb 1980	! Make sure end year is
!					! after Start year.
!
!	%2 (7)	/CAB	Feb 1980	! Correct single months or
!					! range of months starting
!					! after FEB during a LEAP
!					! year to remember to add the
!					! extra day (if there is one)
!
!	%2 (10)	/CAB	Feb 1980	! Change ERSATZ device to PUB
!					! for appointment files
!
!  **	%3 (11)	/CAB	Mar 1980	! Add appointment file formats
!					! every and Nth (including -Nth)
!					! occurrance of a day during one
!					! or every month
!
!	%3 (12) /CAB	May 1980	! Rewrite portions of some routines
!					! for efficiency, small bugs etc.
!
!	%3 (13)	/CAB	May 1980	! Add appointment file format
!					! for cyclical events beginning
!					! and ending on or about a certain
!					! date or event
!
!	%3 (14)	/CAB	May 1980	! Change meaning of LINE number to
!					! center the text if it is Negative
!					! and allow lines < -7 to mean -0
!					! and fix lines > 7 to be 0.


	IMPLICIT INTEGER (A-Z)

	Integer Gregor			! Function Gregor(Day,Mon,Year)
	Integer Leapyr			! Function Leapyr(Year)

	INTEGER CAL,SYS,LIST
	INTEGER DAY,GDAY,FDAY
	INTEGER IY,MON,YEAR,MONEND,IYEAR
	COMMON/IO/CAL,SYS,LIST
	COMMON/MONTHX/MONTHX(12)
	COMMON/MADD/MADD(12)		! SOURCE IN DATES.FOR
	COMMON/DAY/DAY/GDAY/GDAY/FDAY/FDAY
	COMMON/MONTH/MONTH
	COMMON/IYEAR/IYEAR,YEAR
	COMMON/JDAY/JDAY/LEAP/LEAP

	DATA CAL,SYS,LIST/1,2,3/
	DATA (MONTHX(I),I=1,12)/31,28,31,30,31,30,31,31,30,31,30,31/
	OPEN(unit=CAL,device='dsk',access='seqout',file='BIGCAL.DAT')
	CALL GETYR(IY,MON,YEAR,MONEND)		! Read Start/Stop Month,Year

	DO 10 IYEAR = IY,YEAR			! LOOP ONCE OR MORE

	LEAP = LEAPYR(IYEAR)			![12] Remember if a leap year
	GDAY = Gregor(1,1,Iyear)		![12] Find January 1st
	FDAY = GDAY - (GDAY / 7) * 7		! First Day of the Year
	IF (FDAY .LE. 0) FDAY = 7		! Change 0-6 into (1-7)

	MONTH = MON				! Use a real month variable
	IF (MON.EQ.0) MON = 1			! IF 0 THEN START WITH 1
	IF (MONEND .EQ.0) MONEND  = 12		!    AND FOLLOW THROUGH 12

	IF (IY.EQ.YEAR) GO TO 5			! AND IF SAME YEARS SKIP
	IF (IYEAR.GT.IY) MON = 1		!    IF NOT FIRST, BEGIN AT JAN
	IF (IYEAR.EQ.IY) MONSAV = MONEND	!  ELSE SAVE END THE FIRST TIME
	IF (IYEAR.LT.YEAR) MONEND = 12		!    IF NOT LAST YEAR MAKE 12
	IF (IYEAR.EQ.YEAR) MONEND = MONSAV	!    IF LAST YEAR... USE VALUE

5	JDAY = MADD(MON) + 1			! JULIAN DATE = 1ST OF MONTH
	IF (MON .GT. 2) JDAY = JDAY + LEAP	!        PLUS 1 IF LEAP YEAR

	DAY = GDAY + MADD(MON)			! Add in any month offset
	IF (MON .GT. 2) DAY = DAY + LEAP	!     don't forget leap years
	DAY = DAY - (DAY / 7) * 7		! Figure as a day of the week
	IF (DAY .LE. 0) DAY = 7			! Convert 0-6 into 1-7

	CALL DATES				! Read in the appointments?

D	TYPE 6,MON,MONEND
D6	FORMAT(1X,'DO 10 MONTH=',I2,',',I2)
	DO 10 MONTH=MON,MONEND,1		! SETUP FOR A YEAR OF 12
10	CALL PRINTM				! PRINT A MONTH
	END
   