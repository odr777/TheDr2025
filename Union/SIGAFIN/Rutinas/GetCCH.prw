#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³GetCCH    ºAuthor ³TdeP                º Date ³  24/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que cambia automaticamente Datos(Valor,Beneficiarioº±±
±±º          ³ Nro. de Rendicion)  de la Caja Chica, al momento de hacer  º±±
±±º          ³ la rendición desde la Factura de Entrada					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetCCH()
Local nValor := 0

If Upper(Funname())== 'MATA101N'
	If !Empty(cCxCaixa)
	
		IF SELECT('Rendicion') > 0           //Verifica se o alias OC esta aberto
	   		Rendicion->(DbCloseArea())       //Fecha o alias OC
		END
			
		IF SELECT('Duplicado') > 0           //Verifica se o alias OC esta aberto
	   		Duplicado->(DbCloseArea())       //Fecha o alias OC
		END
			
		cQuery:= "SELECT ISNULL(MAX(EU_NRREND),0) AS NRO FROM " + RetSqlName('SEU') 
		cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO='00'"
		cQuery+= " AND EU_FILIAL='" + XFILIAL('SEU')+ "'"
		TCQUERY cQuery NEW ALIAS "Rendicion"
			
		If Rendicion->(!EOF()) .AND. Rendicion->(!BOF())
			IF !EMPTY(Rendicion->NRO)				
				cCxRendic:=StrZero(val(Rendicion->NRO),10,0)	
					 
				cQuery := "SELECT TOP 1 * FROM " + RetSqlName('SEU') 
				cQuery += " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO IN ('00','10') "
				cQuery += " AND EU_FILIAL='" + XFILIAL('SEU')+ "' ORDER BY R_E_C_N_O_ DESC"
					  
				TCQUERY cQuery NEW ALIAS "Duplicado"
					  
				If Duplicado->(!EOF()) .AND. Duplicado->(!BOF())							
					If Duplicado->EU_TIPO == '10' 
						cCxRendic:=StrZero(Val(cCxRendic) + 1,10,0)
					EndIf
				Else
					cCxRendic:=StrZero(Val(cCxRendic) + 1,10,0)
			 	Endif
			ENDIF
		EndIf
			
		//NT 30/09/2017 Valida que el Valor registro en Caja Chica sea igual al Valor de la Factura de Entrada
						
		If AllTrim(Upper(M->F1_SERIE)) $ GetNewPar("MV_XSERCCH","CCH")
			nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'    } )
			nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'	} )
			nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'} )				
			nValor		:= 0
					
			For nX := 1 To LEN(aCols)
				If !aCols[n,Len(aHeader)+1]
					If 	SF4->(FieldPos("F4_XCCH")) > 0				
						If GETADVFVAL("SF4","F4_XCCH",xFilial("SF4")+aCols[nX][nPosTes],1,"N")=="S"								
							nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]
						Endif
					Endif
				Endif	 
			Next nX
			nCxValor := nValor
		Endif
				
		/*
		If nValor <> nCxValor
			Alert('El Valor de la Caja Chica NO es igual a la Factura, se ajustó en la Caja Chica')
			nCxValor := nValor 
		EndIf
		*/
	
		//NT 30/09/2017		nCxValor := M->F1_VALBRUT
		//cCxBenef	:= POSICIONE('SET',1,XFILIAL('SET')+cCxCaixa,'ET_NOME')
		
		If !Empty(M->F1_FORNECE)
			cCxBenef := POSICIONE("SA2",1,xFilial("SA2")+M->F1_FORNECE+M->F1_LOJA,"A2_NOME")
			cCxBenef := SubStr(cCxBenef,1,TamSX3("EU_BENEF")[1])
		Endif
		
		If !Empty(M->F1_XOBS)
			cCxHistor := PadR(M->F1_XOBS,TamSX3("EU_HISTOR")[1])
		EndIf
		
	EndIf
Endif

Return .T.
