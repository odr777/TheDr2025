/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  A261TOK	  ºAutor  ³ERICK ETCHEVERRY ºFecha ³   23/11/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA TRANS MOD 2	 	 	 	 	   			      	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A261TOK()
	Local bSw		:= .T.
	aArea			:= GetArea()

	///valida para que no pongan fecha mayores a hoy
	/*if dA261Data > ddatabase  ///variable privada de la fecha
		MsgInfo ("Fecha de la transaccion no puede ser mayor a hoy")
		return .f.
	endif*/

	If ( FunName() == "MATA261")
			bSw	:= vldprdDis()
	EndIf

	RestArea(aArea)
Return bSw

Static Function vldprdDis()
	Local nI		:= 1
	Local nICntSd3	:= 0
	Local nIPrdSd3	:= 0
	Local nIDptSd3	:= 0
	Local nDim		:= Len(aCols) + 1
	Local lProd		:= .T.

	nICntSd3		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_QUANT" 	})
	nIPrdSd3		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD" 	})
	nIDptSd3		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL" 	})
	nProdDest  		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D3_COD"	    },nIPrdSd3+1)

	While  ( ( nI < nDim ) .And.  ( lProd == .T. )  )

		if nProdDest > 0
			lProd	:= iif(AllTrim(aCols[nI][nIPrdSd3]) == AllTrim(aCols[nI][nProdDest]),.t.,.f.)

            If ( lProd == .F. )
                MsgInfo ("Producto origen debe ser igual al producto destino" + " Linea: " + cValtochar(nI))
                exit
            endif

		endif

		nI 	:= nI + 1
        
	EndDo

Return lProd
