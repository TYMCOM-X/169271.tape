File 1)	DSK:CFIO.SLO	created: 0937 29-APR-82
File 2)	DSK:CFIO.SLO[3,222635]	created: 1714 16-FEB-82

1)29	FM2:	D[AR] ALU[D+Q+1] DEST[Q] SHORT $
1)			;Add the two exponents
****
2)29	FM2:	D[AR] ALU[D+Q] CARRY DEST[Q] SHORT $
2)			;Add the two exponents
**************
1)30	;Note the reason for both reads before first store:
****
2)30		ACSEL[AC+1] D[MEM] DEST[AC MA] SPEC[MA_PC] JUMP[MAIN1] CYLEN[FIXM+1] $
2)			;Put it in the second AC and start next instruction
2)	;(DMOVN continued)
2)	DMOVN2:	D[MA] ALU[D+1] DEST[MA] NORM $	;Fetch second word
2)		FIXM1 $	;Complete fetch
2)		ACSEL[AC+1] D[MEM] ALU[0-D] DEST[AC MA] SPEC[ MA_PC] CYLEN[FIXM+1] $
2)			;Negate low order word and put it in the second AC
**************
1)30		ACSEL[AC] ALU[Q] DEST[AC] NORM $	;Store first AC
1)		ACSEL[AC+1] D[MEM] DEST[AC MA] SPEC[MA_PC] CYLEN[FIXM+1] 
1)			JUMP[MAIN1] $
1)			;store second AC and start next instruction
1)	;(DMOVN continued)
1)	DMOVN2:	D[MA] ALU[D+1] DEST[MA] NORM $	;Fetch second word
1)		FIXM1 $	;Complete fetch
1)		ACSEL[AC+1] D[MEM] ALU[0-D] DEST[AC] NORM $
1)			;Negate low order word and put it in the second AC
1)		ACSEL[AC+1] D[MASK 1] ROT[35.] ALU[-D&AC] DEST[AC MA] 
1)			SPEC[MA_PC] CYLEN[FIXM+1] COND[OBUS=0] LBJUMP[DMOVN3] $
1)			;Clear stupid bit 0.  If the low order part is 0, 
****
2)30		ACSEL[AC+1] D[MASK 1] ROT[35.] ALU[-D&AC] DEST[AC]
2)				COND[-OBUS=0] JUMP[MAIN1] NORM $
2)			;Clear stupid bit 0.
2)			;If the low order part is non-zero, we're done
2)		ACSEL[AC] ALU[AC+1] DEST[AC] SPEC[CRYOV] JUMP[MAIN1] C550 $
2)			;Increment high order word and we're finally done.
2)	;(DMOVEM continued)
2)		.PAIR
2)	DMOVM2:	CYLEN[MEMSTO] ACSEL[AC] D[MEM] DEST[AC] NORM $
2)			;Write it also in the AC
2)		CYLEN[MEMSTO] D[MA] ALU[D+1] DEST[MA] $
2)			;Setup to write second word
2)		ACSEL[AC+1] ALU[AC] DEST[MEMSTO] MEMST $
2)			;Write secord word.
2)	;(DMOVNM continued)
2)	DMVNM2:	ACSEL[AC+1] ALU[0-AC] DEST[Q] SHORT $
2)			;Negate low order word.
2)		ACSEL[AC+1] D[MASK 1] ROT[35.] ALU[-D&Q] DEST[Q]
2)				COND[-OBUS=0] JUMP[DMVNM4] NORM $
2)			;Clear stupid bit 0.
**************
1)30			;really associated with SPEC[MA_PC])
1)			;*** Is FIXM+1 really the right thing???
1)	.pair
1)	DMOVN3:	ACSEL[AC] ALU[Q] DEST[AC] JUMP[MAIN1] NORM $
File 1)	DSK:CFIO.SLO	created: 0937 29-APR-82
File 2)	DSK:CFIO.SLO[3,222635]	created: 1714 16-FEB-82

1)		ACSEL[AC] ALU[Q+1] DEST[AC] SPEC[CRYOV] JUMP[MAIN1] NORM $
1)			;Increment high order word and we're finally done.
****
2)30		D[AR] ALU[AC+1] DEST[AR STRT-WRT] SPEC[CRYOV]
2)			COND[-MA-AC] JUMP[DMVNM5] NORM $
2)			;Increment high order word and start first store
2)	DMVNM3:	ACSEL[MA] D[MEM] DEST[AC] JUMP[DMVNM5] $
2)			;Store is to an AC, write into 2901.
2)	DMVNM4:	DEST[STRT-WRT] COND[MA-AC] JUMP[DMVNM3] $
2)			;Start first store.  Jump if to an AC
2)	DMVNM5:	D[MA] ALU[D+1] DEST[MA] NORM $
2)			;Finish write.  Note that due to FIXM2, we don't have to
**************
1)31		.PAIR
1)	DMOVM2:	ACSEL[AC+1] ALU[AC] DEST[AR HOLD] COND[MA-AC] LBJUMP[DMOVMA2] $
1)		;that was the case that first destination was an AC
1)		CYLEN[MEMSTO] ACSEL[MA] D[MEM] DEST[AC] NORM $
1)	...		;Write it also in the AC
1)		;here we are writing into an AC (at least for the first word)
1)		ACSEL[AC] ALU[AC] DEST[AR] SHORT $	;get both words before
1)		ACSEL[AC+1] ALU[AC] DEST[Q] SHORT $	;attempting store
1)	STORE.ARQ.MEMAC:
1)		ACSEL[MA] D[AR] DEST[AC] SHORT $	;store first word -an AC
1)		D[MA] ALU[D+1] DEST[MA] $	;Setup second write address
1)		D[Q] DEST[MEMSTO] MEMST $	;Write second word.
1)	;(DMOVNM continued)
1)	DMVNM2:	ACSEL[AC+1] ALU[0-AC] DEST[Q] SHORT $	;Negate low order word.
1)		ACSEL[AC+1] D[MASK 1] ROT[35.] ALU[-D&Q] DEST[Q]
1)				COND[-OBUS=0] JUMP[DMVNM4] NORM $
1)			;Clear stupid bit 0.
****
2)30		ALU[Q] DEST[MEMSTO] MEMST $
2)			;Do final write (low order word into (E+1))
**************
1)31		D[AR] ALU[D+1] DEST[AR STRT-WRT] SPEC[CRYOV]
1)			COND[-MA-AC] LBJUMP[DMVNM3] NORM $
1)			;Increment high order word and start first store
1)	DMVNM4:	D[AR] DEST[STRT-WRT] COND[-MA-AC] LBJUMP[DMVNM3] $
1)			;Start first store.  Jump if to an AC
1)	.pair
1)	DMVNM3:	ACSEL[MA] D[MEM] DEST[AC] $ ;Store is to an AC, write into 2901.
1)		D[MA] ALU[D+1] DEST[MA] NORM $
1)			;Finish write.  Note that due to FIXM2, we don't have to
1)			;worry about map faults.  Prepare for second write
1)		ALU[Q] DEST[MEMSTO] MEMST $
1)			;Do final write (low order word into (E+1))
1)	];.new DMOVNM code
1)	;KAFIX (Opcode 247) continued
1)	;Positive number to fix
1)	KAFIXP:	D[IR] ROT[27.] MASK[9.] DEST[Q] COND[-OBUS=0] PUSHJ[FIXER] $
****
2)30	KAFIXP:	D[IR] ROT[27.] MASK[9.] DEST[Q] COND[-OBUS=0] PUSHJ[FIXER] $
**************
1)33		.USE[AREA350]
File 1)	DSK:CFIO.SLO	created: 0937 29-APR-82
File 2)	DSK:CFIO.SLO[3,222635]	created: 1714 16-FEB-82

1)	DADD1:	;continuation of DADD (High word in AR).
1)		D[MA] ALU[D+1] DEST[MA] NORM $ ;start fetch of lo order word
1)		FIXM1 $				;wait for it
1)		D[CONST 1] ROT[35. - 0] ACSEL[AC+1] ALU[-D&AC] DEST[Q] NORM $
1)						;clear sign bit in lo order ac
1)		D[MEM] MASK[35.] ALU[Q+D] DEST[Q]
1)			COND[OBUS<0] C550 JUMP[DADD.CARRY] $
1)			;add c(e+1) without sign to c(ac+1) without sign
1)			; result in Q. jump if carry into hi order word.
1)		D[AR] ACSEL[AC] ALU[AC+D] DEST[AC] SPEC[CRYOV]
1)		   COND[OBUS<0] C550 LBJUMP[DARITH.G] $
1)		;add hi order words -no carry. Leave with AC+1 := sign + Q[1:35]
1)	DADD.CARRY:
1)		D[AR] ACSEL[AC] ALU[AC+D+1] DEST[AC] SPEC[CRYOV]
1)		   COND[OBUS<0] C550 LBJUMP[DARITH.G] $
1)		;add hi order words -carry. Leave with AC+1 := sign + Q[1:35]
1)	DARITH.G: ;exit from long integer operations. set AC := sign | Q[1:35]
1)		  ;invoked by COND[result_negative] LBJUMP[DARITH.G]
1)		D[CONST 1] ROT[35. - 0] ACSEL[AC+1] ALU[-D&Q] DEST[AC MA] 
1)			SPEC[MA_PC] JUMP[MAIN1] NORM $
1)			;result is positive so clear sign bit in lo order word
1)		D[CONST 1] ROT[35. - 0] ACSEL[AC+1] ALU[DORQ] DEST[AC MA] 
1)			SPEC[MA_PC] JUMP[MAIN1] NORM $
1)			;result is negative so set sign bit in lo order word
1)		.USE[OTHER]
1)	DSUB1:	;continuation of DSUB (High word in AR).
1)		D[MA] ALU[D+1] DEST[MA] NORM $ ;start fetch of lo order word
1)		FIXM1 $				;wait for it
1)		D[CONST 1] ROT[35. - 0] ACSEL[AC+1] ALU[-D&AC] DEST[Q] NORM $
1)						;clear sign bit in lo order ac
1)		D[MEM] MASK[35.] ALU[Q-D] DEST[Q]
1)			COND[OBUS<0] C550 JUMP[DSUB.BORROW] $
1)			;subtract c(e+1) without sign from c(ac+1) without sign
1)			; result in Q. jump if borrow from hi order word.
1)		D[AR] ACSEL[AC] ALU[AC-D] DEST[AC] SPEC[CRYOV]
1)			COND[OBUS<0] C550 LBJUMP[DARITH.G] $
1)		;subtract hi order words -no borrow. 
1)		;Leave with AC+1 := sign + Q[1:35]
1)	DSUB.BORROW:
1)		D[AR] ACSEL[AC] ALU[AC-D-1] DEST[AC] SPEC[CRYOV]
1)		   COND[OBUS<0] C550 LBJUMP[DARITH.G]
1)		;subtract hi order words -borrow. 
1)		;Leave with AC+1 := sign + Q[1:35]
1)34		.USE[OTHER]
1)	DSUB1:	;continuation of DSUB (High word in AR).
1)		D[MA] ALU[D+1] DEST[MA] NORM $
1)			;START FETCH OF LO ORDER WORD
****
2)32	.DEFINE DARITH [OP]
2)	[	D[MA] ALU[D+1] DEST[MA] NORM $
2)			;START FETCH OF LO ORDER WORD
**************
1)34		D[MEM] MASK[35.] ACSEL[AC+1] ALU[AC-D] DEST[AC]
1)		   COND[-OBUS<0] C550 JUMP[. + 2] $
File 1)	DSK:CFIO.SLO	created: 0937 29-APR-82
File 2)	DSK:CFIO.SLO[3,222635]	created: 1714 16-FEB-82

****
2)32		D[MEM] MASK[35.] ACSEL[AC+1] ALU[ OP ] DEST[AC]
2)		   COND[-OBUS<0] C550 JUMP[. + 2] $
**************
1)34		D[AR] ACSEL[AC] ALU[AC-D] DEST[AC] SPEC[CRYOV]
1)		   COND[OBUS<0] C550 JUMP[. + 2] $
****
2)32		D[AR] ACSEL[AC] ALU[ OP ] DEST[AC] SPEC[CRYOV]
2)		   COND[OBUS<0] C550 JUMP[. + 2] $
**************
1)35	.REPEAT TYMNET [.DEFINE FOOLIST[] [ LIST ] ]
****
2)32		.USE[AREA350]
2)	DADD1:	DARITH[AC+D]
2)		.USE[OTHER]
2)	DSUB1:	DARITH[AC-D]
2)	];.REPEAT KL
2)34	.REPEAT TYMNET [.DEFINE FOOLIST[] [ LIST ] ]
**************
    