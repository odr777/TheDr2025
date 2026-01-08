#Include "Protheus.ch"
#Include "Topconn.ch"
#DEFINE CRLF Chr(13)+Chr(10)

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
Local _lRet  	:= .T.
Local nValor 	:= 0
Local nPosTes	:= 0
Local nPosCta	:= 0
Local nPosCc	:= 0
Local nPosRateio:= 0
Local nPosItem	:= 0
Local aItCC		:= {}
Local cItCC		:= ""

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Centro de Custo Obrigatorio 							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(FunName()) $ "MATA101N" 
	nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == "D1_TES"    } )
	nPosCta  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == "D1_CONTA"  } )
	nPosCc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == "D1_CC"   	} )
	nPosRateio  := Ascan( aHeader, { |x| Alltrim( x[2] ) == "D1_RATEIO"	} )
	nPosItem    := Ascan( aHeader, { |x| Alltrim( x[2] ) == "D1_ITEM"	} )
	
	For nX := 1 To Len(aCols)
		If !aCols[n,Len(aHeader)+1]
			
			If GetNewPar("MV_XOBRGCC",.T.)
				If aCols[nX][nPosRateio]=="1"	//Item com Reteio CC
					If Len(aRatCC) > 0
						
						For nRt := 1 To Len(aRatCC)
							If aRatCC[nRt][1]== aCols[nX][nPosItem]
								aItCC := aRatCC[nRt][2]
								
								For nIt := 1 To Len(aItCC)
									cItCC := aItCC[nIt][3]
									If Empty(cItCC)
										_lRet := .F.
										Aviso("AVISO -LOCXPE16","Falta digitar el Centro de Costo / Item: " +aCols[nX][nPosItem]+CRLF+"Prorrateo Item: "+aItCC[nIt][1],{"OK"})
										Exit
									Endif
								Next nIt
							Endif
						Next nRt
						//_lRet := .T.
					Endif
				Else
					If Empty(aCols[nX][nPosCc])
						_lRet := .F.
						Aviso("AVISO -LOCXPE16","Falta digitar el Centro de Costo / Item: " +aCols[nX][nPosItem],{"OK"})
						Exit
					Endif
				Endif
			Endif
		Endif
	Next nX
	
	//Aviso("Array > aRatCC",u_zArrToTxt(aRatCC, .T.),{"Ok"},,,,,.T.)
	//Return(.F.)//<--------------------------
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida que el Valor registro en Caja Chica sea igual al 	³
//³ Valor de la Factura de Entrada                   			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Alltrim(FunName()) $ "MATA101N" 
	nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
	nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'   } )
	nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC' } )
  //nPosImp  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_UIMPEXE' } )
	
	If AllTrim(Upper(M->F1_SERIE)) $ GetNewPar("MV_XSERCCH","CCH")
		nValor:= 0
		For nX := 1 To LEN(aCols)
			
			If 	SF4->(FieldPos("F4_XCCH")) > 0				
				If GETADVFVAL("SF4","F4_XCCH",xFilial("SF4")+aCols[nX][nPosTes],1,"N")=="S"				
					nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]
				Endif
			Else
				nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]
			Endif
			
		Next nX
		
		If nValor<> nCxValor 
			Alert("El Valor de la Caja Chica NO es igual a la Factura")
			_lRet:= .F.
		EndIf
		
		//--------------- Actualizamos el Nro de Rendicion por Caja Chica -------------------//
		/*
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
		*/
	End
End

Return _lRet

//+---------------------------------------------------------------------+
//|Valida la Tes Utilizada en Factura de Entrada para Caja Chica 		|
//+---------------------------------------------------------------------+
User Function ValItCx
Local lRet := .T.

If AllTrim(Upper(M->F1_SERIE)) $ GetNewPar("MV_XSERCCH","CCH")		
	
	If 	SF4->(FieldPos("F4_XCCH")) > 0
		lRet := GETADVFVAL("SF4","F4_XCCH",xFilial("SF4")+M->D1_TES,1,"N")=="S"
	
		If !lRet
			If Aviso("MENSAJE","La TES utilizada no es de Caja Chica, desea continuar?",{"Si","No"})==1
				Aviso("MENSAJE","Este Ítem generará una CXP",{"Ok"})
				lRet := .T.
			Else
				lRet := .F.
			Endif
		Endif
	Endif
Endif
Return(lRet)