BIGCAL.COM ;DIR (DMS) comment file
BIGCAL.EXE ;Runnable Calendar program
CENTER.FOR ;subroutine to CENTER the headings (Days of the weeks)
CLEARL.FOR ;subroutine to clear the print-line
GETNAM.FOR ;subroutine to read a NAME,NUMBER in any order
HEADER.FOR ;subroutine to print the monthly headers
MATCH .FOR ;subroutine to check for a match
PRINTM.FOR ;subroutine to PRINT out an entire MONTH
LEAPYR.FOR ;subroutine to determine 0 or 1 for LEAP year
GREGOR.FOR ;subroutine to determine an absolute Gregorian date 1-n
GETYR .FOR ;subroutine to get the start/stop dates
BIGCAL.CMD ;Command file for building the program
BIGDEB.CMD ;Command file for debugging the program
SETDAY.FOR ;subroutine to set the message-text line into the INF array
BIGCAL.FOR ;main program source
SETWEE.FOR ;subroutine to setup a week of date info at a time
DATES .FOR ;subroutine to process the appointment-event files
BIGCAL.DOC ;DOCUMENTATION
BIGCAL.RND ;DOCUMENTATION source file
BIGCAL.INF ;demonstration date-appointment file
   