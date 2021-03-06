
record!class spline ( integer knots; numeric array xf, yf; 
			r!p(point) pList );	! pList is a Kluge;
procedure relax( numeric array B );
begin	integer i, lc,uc, lr,mr,ur;
integer line,const;
	define for!i(l,u)="for i_ l step 1 until u do";

	procedure remove( integer col, baseLine, change );
	begin	numeric mult;
	mult_ B[ change, col ] / B[ baseLine, col ];
	B[ change, col ]_ 0;
	for!i(col+1,ur) B[change,i]_ B[change,i] - mult * B[baseLine,i];
	end;

	procedure final( integer index );
	begin	numeric mult;
	mult_ 1/B[index,index]; B[index,index]_ 0;
	B[index,index]_ 1;
	for!i(uc+1,ur) B[index,i]_ B[index,i] * mult;
	end;
integer lastColumn; 

lc_ arrinfo(b,1); uc_ mr_ arrinfo(b,2);
lr_ arrinfo(b,3); ur_ arrinfo(b,4);

for line_ lc step 1 until uc-2 do remove( line, line, line+1 );
remove( uc-2, uc-2, uc );
remove( uc-1, uc-1, uc ); final(uc);
for line_ uc-1 step -1 until lc+1 
   do begin remove( line+1, line+1, line ); final(line); end;
remove( lc+2, lc+2, lc ); final(lc);
end;
numeric procedure beta3( numeric tau );
begin	numeric sum;
	integer j;
	preset!with 1,4,6,4,1; own integer array binomial4plus2[-2:2];
sum_ 0;
for j_-2 step 1 until 2
   do if tau<j
	 then sum_ sum + binomial4plus2[j] * (j-tau) ^ 3
			* (if j land 1 then -1 else 1);
return(sum/6);	! 6=3!;
end;
numeric procedure funct3( numeric time; numeric array ai );
begin	numeric result;
	integer index, knots;
knots_ arrinfo(ai,2)-1;
result_ 0;
time_ time * knots;
for index_ -1 step 1 until knots+1
   do if ai[index] and index-2 < time < 2+index
	 then result_ result + ai[index] * beta3(time-index);
return(result);
end;
procedure multout( numeric array coeff, matrix );
begin	integer l,u, row, col;
	numeric array result[l_arrinfo(coeff,1) : u_arrinfo(coeff,2)];
	numeric temp;
if arrinfo(matrix,3) leq l < u leq arrinfo(matrix,4)
and arrinfo(matrix,1) =  l < u  =  arrinfo(matrix,2)
 then begin
	for row_ l step 1 until u
	   do begin
		temp_ 0;
		for col_ l step 1 until u 
		   do temp_ temp + matrix[row,col] * coeff[col];
		result[row]_ temp;
	      end;
	arrtran( coeff, result );
      end
 else usererr(0,1,"You bastard");
end;
record!class splineMatrix (integer knots; numeric array a; 
				r!p(splineMatrix) link );
r!p(splineMatrix) got;

r!p(splineMatrix) procedure findMatrix( integer knots );
begin	r!p(splineMatrix) result;

if result_ got
 then do if splineMatrix:knots[result] = knots then return(result)
	until null!record = result_ splineMatrix:link[result];

result_ new!record(splineMatrix);
splineMatrix:knots[result]_ knots;
splineMatrix:link[result]_ got;

  begin	integer inv,i;
	numeric safe array matrix[ -1:knots+1, -1:knots+1+knots+3 ];
    inv_ knots+1+2;
    arrclr(matrix); 
    for i_ 0 step 1 until knots
	do begin 
	    matrix[i,i-1]_1; matrix[i,i]_4; matrix[i,i+1]_1; 
	    matrix[i,inv+i]_ 6;
	   end;
    matrix[-1,inv-1]_ 6; matrix[knots+1,inv+knots+1]_ 6;
    matrix[-1,-1]_-knots * 3; matrix[-1,1]_knots * 3;
    matrix[knots+1,knots-1]_-knots * 3; 
    matrix[knots+1,knots+1]_knots * 3;
    relax(matrix);
    arrblt( matrix[-1,-1], matrix[-1,inv-1], arrinfo(matrix,0) );
	! get inverse;
    memory[location( splineMatrix:a[result] )] 
	swap memory[location( matrix )];
    got_ result;
  end;
return(result);
end;
r!p(spline) procedure makeSpline( integer knots; r!p(point) pList );
begin	integer i, segs;
	numeric array x.c, y.c [-1 : knots ];
	r!p(splineMatrix) thisSize;
	r!p(point) back, back2;
	r!p(spline) result; 
segs_ knots-1;
result_ new!record(spline);
spline:pList[result]_ plist;
spline:knots[result]_ knots;
thisSize_ findMatrix( segs );
back_ back2_ null!record;
if knots > 1
 then begin
	x.c[-1]_( point:x[point:link[pList]] - point:x[pList] ) / segs;
	y.c[-1]_( point:y[point:link[pList]] - point:y[pList] ) / segs;
      end
 else x.c[-1]_ y.c[-1]_ 1;	! or any other slope;
for i_ 0 step 1 until segs
   do begin x.c[i]_ point:x[pList]; y.c[i]_ point:y[pList]; 
	back2_ back; back_ pList; pList_ point:link[pList];
      end;
if pList then usererr(knots,3,"Bad knot count");
if knots > 1
 then begin
	x.c[knots]_ ( point:x[back] - point:x[back2] ) / segs;
	y.c[knots]_ ( point:y[back] - point:y[back2] ) / segs;
      end
 else x.c[knots]_ y.c[knots]_ 1;	! or any other slope;
multout(x.c, splineMatrix:a[thisSize] );
multout(y.c, splineMatrix:a[thisSize] );
memory[location( spline:xf[result] )] swap memory[location( x.c )];
memory[location( spline:yf[result] )] swap memory[location( y.c )];
return(result);
end;
procedure useSpline(integer numPoints; r!p(spline) spl; procedure plot);
begin	r!p(point) kluge;
	numeric time, timeInc, x, y;
timeInc_ (time_1)/numPoints;
for time_ 0 step timeInc until 1
   do plot( 	x_ funct3( time, spline:xf[spl] ),
		y_ funct3( time, spline:yf[spl] )	); 
end;

  