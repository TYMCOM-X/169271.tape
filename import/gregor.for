	Integer Function Gregor(Day,Mon,Year)	![12] Written for the revision
	Implicit Integer (A-Z)

	Integer Day			! Day of month
	Integer Mon			! Month of year
	Integer Year			! Gregorian Year

	Integer Leap			! Leap year flag
	Integer Madd(12)		! Month additions table
	Integer Mmax(12)		! Month maximums table

	Common /Mmax/Mmax		! Defined elsewhere
	Common /Madd/Madd		! Defined elsewhere




	Gregor = -1			! Simple Error flag
	If (Year .LT. 1) Return		! No illegal years allowed
	If (Year .GT. 1999) Return	! Not yet working for year > this

	If (Mon.LT.1 .or. Mon.GT.12) Return	! Bad Month?

	Leap = Leapyr(Year)		! Set a flag for leap years
	Leaper = 0			! Get the Leper.
	If (Mon .EQ. 2) Leaper = Leap	! Add of leap months
	If (Day .GT. Mmax(Mon)+Leaper) Return	! Too many days in the month?
!
!	Pre =	Years      +  Leap/4    - No Leap/100  + Leap/400     + Monday
!
	Pre = (Year-1)*365 + (Year-1)/4 - (Year-1)/100 + (Year-1)/400 + 1
	If (Mon .LT. 3) Leap = 0	! Forget Leap year if Jan or Feb
	Gregor = Day + Madd(Mon) + Leap + Pre
D	Type 1000,Gregor,day,mon,year
D1000	Format(1x,'G:',i10,' Day=',i5,'  Mon=',i5,'  Year=',i5)
	Return
	End
   