50	 k0=36
60	 REM SUBR allocate
70	 GOSUB 510
80	PRINT "How many data points: "
90	INPUT k2
100	IF k2 < 1 GOTO 9999
110	IF k2 > k0 GOTO 80
120	FOR i=1 TO k2
130	    PRINT "Point "; i
140	    INPUT p(i,0), p(i,1)
150	    NEXT i
160	REM SUBR makespline
170	GOSUB 2250
180	PRINT "How many Curve points: "
190	INPUT i
191 if i <> -1 goto 200
192 for i=1 to k1
193  print i;" X:"; c(0,i*4+3); c(0,i*4+2); c(0,i*4+1); c(0,i*4+0)
194  print i;" Y:"; c(1,i*4+3); c(1,i*4+2); c(1,i*4+1); c(1,i*4+0)
195  next i
196 for i=0 to k3
197  print "  p"; i; ": ("; p(i,0); ","; p(i,1); ")"
198  next i
199 goto 180
200	IF i < 1 GOTO 80
210	REM SUBR useSpline
220	GOSUB 1010
230	GOTO 180
240	
250	REM procedure plotXY (X,Y)
300	PRINT " ("; x; ", "; y; ")"
310	RETURN
500	
510	REM procedure allocate(k0)
650	DIM c( 1, 147 )
660	REM DIM c(1,k0*4+3): cubic eqtns
750	DIM w( 37 )
760	REM DIM w( k0+1 ): workspace 
790	DIM v( 37, 37 )
800	REM DIM v(k0+1,k0+1): B-S matrix
840	DIM p( 37, 1 )
850	REM DIM p(k0+1,1): points&slopes
930	RETURN
950	
960	REM procedure docubic(c,k4,i,t0->x)
970	x=((c(k4,i *4+3)*t0+ c(k4,i *4+2))*t0+ c(k4,i *4+1))*t0+ c(k4,i *4+0)
980	RETURN
990	
1010	REM procedure useSpline(i,k1,c)
1070	 t4= k1 / i
1110	for i= 1 to k1
1130	  for t0= 0.0 to 1.0 by t4
1150		k4= 1
1160		 REM SUBR doCubic
1170		 GOSUB 960
1180		  y= x
1200		k4= 0
1210		 REM GOSUB doCubic
1220		 GOSUB 960
1230		REM SUBR plotXY
1240		GOSUB 250
1250	      next t0
1260	  next i
1270	RETURN
1280	
1300	REM procedure nCoeff(k4,k3,k1,p,v->c)
1390	for j= 0 to k3
1400		x= 0
1410		for i= 0 to k3 
1420		   x=x+ v(j,i) * p(i,k4)
1430		   next i
1440		w(j)= x
1450	      next j
1460	for j= 1 to k1
1470	    c(k4,j *4+3)= (- w(j-1) +3 * w(j) -3 * w(j+1) + w(j+2))/6
1480	    c(k4,j *4+2)= (3*w(j-1) -6 * w(j) +3 * w(j+1))/6
1490	    c(k4,j *4+1)=(-3*w(j-1)	      +3 * w(j+1))/6
1500	    c(k4,j *4+0)=(   w(j-1) +4 * w(j)  +   w(j+1))/6
1510	    next j
1520	RETURN
1530	
1550	REM procedure nMatrix(k1,k2,k3->v)
1770	for j= 0 to k3
1780	    for i= 0 to k3
1790		v(j,i)= 0
1800		next i
1810	    next j
1820	for i= 2 to k2
1830	    v(i,i)= 6
1840	    next i
1880	v(0,0)= 2 / k1
1890	v(k3, k3)= 2 / k1
1900	v(1,1)= 3 
1910	v(1,0)= 1 / k1 
1920	w(1)= 2
1930	t1= 1 / 2
1950	for j= 2 to k2
1960	  for i=0 to k3
1970	    v(j,i)=v(j,i)-t1*v(j-1,i)
1980	    next i
1990	  w(j)= 4 - t1
2000	  t1= 1 / w(j)
2010	  next j
2030	 j= k3
2040	t1= 1 / w(k1)
2050	t2= t1 / w(k2) 
2060	t3= 1 / (1 - t2)
2080	for i=0 to k3
2090	  v(j,i)=(v(j,i)+v(k1,i)*t1-v(k2,i)*t2)*t3
2100	  next i
2120	for j= k2 to 1 by -1
2130	  t1= 1 / w(j)
2140	  for i= 0 to k3
2150	    v(j,i)=(v(j,i)-v(j+1,i))*t1
2160	    next i
2170	  next j
2190	for i= 0 to k3
2200	    v(0,i)= v(2,i) - v(0,i)
2210	    next i
2220	RETURN
2230	
2250	REM makeSpline (k2,p -> k1,k3,c)
2310	k1= k2-1
2315	k3= k2+1
2440	for i= 0 to 1 
2450	  p(0,i)= (p(2,i) - p(1,i)) / k1
2460	  p(k3,i)=(p(k2,i)-p(k1,i)) / k1
2470	  next i
2500	REM SUBR nMatrix
2510	GOSUB 1550
2550	 k4=0
2560	  REM SUBR nCoefficients
2570	  GOSUB 1300
2590	 k4=1
2600	  REM SUBR nCoefficients
2610	  GOSUB 1300
2630	RETURN
9999	END
  