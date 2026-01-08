#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ getInPed ³ Autor ³ Widen Gonzales					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Dispara Observacion Factura Credito + Fecha Vencimiento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ObsCondP(cCondpag,cFechaEmi)
	Local cResp:=""
	Local i
	Local FechaCred:=""
	cDiasCred := POSICIONE("SE4",1,XFILIAL("SE4")+cCondpag,"E4_COND")
	cTipoCond := SE4->E4_TIPO	
	If cTipoCond =='1'  
		if cDiasCred <> '0' // Diferente de al contado
			cResp:= "FACTURA  AL CRÉDITO - VCTO. " + dToC( DaySum(cFechaEmi, val(cDiasCred)))	
		endif
	ElseIf cTipoCond=='7'
		aDiasCred := StrTokArr( cDiasCred, "," )
		For i:=2 to len(aDiasCred)
			if aDiasCred[i]<>'0'
				
				if i-1 < MONTH (cFechaEmi)
					FechaCred= ALLTRIM(aDiasCred[i]) + '/' + StrZero(i-1,2) + '/' + cvaltochar(YEAR(cFechaEmi)+1)		
				Else
					FechaCred= ALLTRIM(aDiasCred[i]) + '/' + StrZero(i-1,2) + '/' + cvaltochar(YEAR(cFechaEmi))
				ENDIF 
				cResp:= "FACTURA  AL CRÉDITO - VCTO. " + FechaCred 	
			EndIF
		NEXT i
	ENDIF

RETURN cResp
