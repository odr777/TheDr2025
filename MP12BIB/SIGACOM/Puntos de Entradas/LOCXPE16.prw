#Include 'Protheus.ch'
#Include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ LocxPe16 ³ Autor ³ TdeP               ³ Fecha³ 30/09/2017  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Punto de Entrada paga validar en OK rutinas LocxNF         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis  ³ LocxPe16( void )                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. o .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MP12BIB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LOCXPE16()
Local _lRet:= .T.

// Incluye SA5 Proveedor vs Productos
/* 
IF alltrim(FunName()) $ "MATA102N" 
	nPosCod  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_COD'     } )
	nPosProveedor  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_FORNECE'     } )
	nPosLoja  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_LOJA'   } )
	SA5->(dbSetOrder(1))
	SA2->(MSSeek(xFilial("SA2")+M->F1_FORNECE+M->F1_LOJA))
	For nX := 1 To LEN(aCols)
		SA5->(dbSetOrder(1))
		If !SA5->(MSSeek(xFilial("SA5")+aCols[nX][nPosProveedor]+aCols[nX][nPosLoja]+aCols[nX][nPosCod]))
			SB1->(MSSeek(xFilial("SB1")+aCols[nX][nPosCod]))
			RecLock("SA5",.T.)
			Replace A5_FILIAL  With xFilial("SA5")	,;
					A5_FORNECE With aCols[nX][nPosProveedor]		,;
					A5_LOJA    With aCols[nX][nPosLoja]	,;
					A5_NOMEFOR With SA2->A2_NOME	,;
					A5_PRODUTO With aCols[nX][nPosCod]		,;
					A5_NOMPROD With SB1->B1_DESC,;
					A5_TIPATU  With "0"
		EndIf
	Next nX
End
*/

//Valida que el Valor registro en Caja Chica sea igual al Valor de la Factura de Entrada
IF alltrim(FunName()) $ "MATA101N" 
	nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
	nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'     } )
	nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
	nPosImp  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_UIMPEXE'     } )
	If upper(M->F1_SERIE)=='CCH'
		nValor:=0
		For nX := 1 To LEN(aCols)
			nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]	 
		Next nX
		IF nValor<> nCxValor 
			Alert('El Valor de la Caja Chica NO es igual a la Factura')
			_lRet:= .F.
		END
		
		//--------------- Actualizamos el Nro de Rendicion por Caja Chica -------------------//
		If !Empty(cCxCaixa)
			IF SELECT('Rendicion') > 0           //Verifica se o alias OC esta aberto
	   			Rendicion->(DbCloseArea())       //Fecha o alias OC
			END
			
			cQuery:= "SELECT COUNT(EU_CAIXA)AS NRO FROM " + RetSqlName('SEU') 
			cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO='10'"
			
			TCQUERY cQuery NEW ALIAS "Rendicion"
			
			If Rendicion->(!EOF()) .AND. Rendicion->(!BOF())
			  IF !EMPTY(Rendicion->NRO)
					cCxRendic:=StrZero(Rendicion->NRO,10,0)  
			  END
			END
		End
	End
End

// Actualiza Excentos (Versión antigua)
/*
IF alltrim(FunName()) $ "MATA101N|MATA102N"
	nValExento:=0
		nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
	nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'     } )
	nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
	nPosImp  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_UIMPEXE'     } )     
	//Obtenemos el Valor Exento                                                                              
	For nX := 1 To LEN(aCols)
		If (POSICIONE('SF4',1,XFILIAL('SF4')+aCols[nX][nPosTes],'F4_LFICM')$"I")
			nValExento := (M->F1_VALBRUT - aCols[nX][nPosTotal]) * GetNewPar("MV_IMPEXE",0.13) 			
			Exit
		End
	Next nX
	//Actualizamos el campo en la SD1
	If nValExento >0
		 For nX := 1 To LEN(aCols)
		 	aCols[nX][nPosImp]:= nValExento
		 Next
	End
End 
*/

Return _lRet

