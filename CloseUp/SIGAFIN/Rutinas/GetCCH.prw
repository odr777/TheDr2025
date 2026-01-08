#Include 'Protheus.ch'
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
					 
					  cQuery:= "SELECT TOP 1 * FROM " + RetSqlName('SEU') 
					  cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO IN ('00','10') "
					  cQuery +=" AND EU_FILIAL='" + XFILIAL('SEU')+ "' ORDER BY R_E_C_N_O_ DESC"
					  
					  TCQUERY cQuery NEW ALIAS "Duplicado"
					  
					   If Duplicado->(!EOF()) .AND. Duplicado->(!BOF())					
							
							If Duplicado->EU_TIPO == '10' 
								cCxRendic:=StrZero(Val(cCxRendic) + 1,10,0)
							END  
							
						ELSE
							cCxRendic:=StrZero(Val(cCxRendic) + 1,10,0)
				 		End
						
			  END
			END
			
			//NT 30/09/2017 Valida que el Valor registro en Caja Chica sea igual al Valor de la Factura de Entrada
			IF alltrim(FunName()) $ "MATA101N" .AND. upper(M->F1_SERIE)=='CCH' 
				nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
				nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'     } )
				nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
				nPosImp  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_UIMPEXE'     } )
					nValor:=0
					For nX := 1 To LEN(aCols)
						nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]	 
					Next nX
					
					If nValor <> nCxValor 
			//			Alert('El Valor de la Caja Chica NO es igual a la Factura, se ajustó en la Caja Chica')
						nCxValor := nValor 
					EndIf
			EndIf

//NT 30/09/2017		nCxValor:=M->F1_VALBRUT
		cCxBenef:=POSICIONE('SET',1,XFILIAL('SET')+cCxCaixa,'ET_NOME')
	End
	
End

Return .T.
