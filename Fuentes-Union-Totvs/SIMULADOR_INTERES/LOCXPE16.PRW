#INCLUDE 'PROTHEUS.CH'

#Define SnTipo 1 

/*
=============================================================================
|PROGRAMA:	LOCXPE16	|	FECHA:	05/07/2017 	|	AUTOR:	Ignacio Ascurra	|
-----------------------------------------------------------------------------
|DESCRIPCIÓN: PUNTO DE ENTRADA TUDO OK DE LOCXNF                            |
=============================================================================
*/

User function LOCXPE16()

Local aArea		:= GetArea()
Local aAreaSF2	:= SF2->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSFP	:= SFP->(GetArea())
Local lRet		:= .T.
Local lDSASTK3	:= ExistBlock("DSASTK03")
Local lDSASTK7	:= ExistBlock("DSASTK07")
Local lDSAST11	:= ExistBlock("DSASTK11")
Local lDsValTX	:= ExistBlock("DSVALTX")
Local nX 		:= 0
Local nPedido	:= Space(0)
Local nItemPC	:= Space(0)

//ADV: VARIABLES TDEP
Local _lRet  	:= .T.
Local nValor 	:= 0
Local nPosTes	:= 0
Local nPosCta	:= 0
Local nPosCc	:= 0
Local nPosRateio:= 0
Local nPosItem	:= 0
Local aItCC		:= {}
Local cItCC		:= ""
Local nIt :=0

// ************************ //
// *** REMITO DE VENTAS *** //
// ************************ //
If IsInCallStack("MATA462N")
	If lRet .AND. lDSASTK3
		lRet := ExecBlock( "DSASTK3T", .F., .F.)
	EndIf
EndIf

// ******************************** //
// *** REMITO DE TRANSFERENCIAS *** //
// ******************************** //
If IsInCallStack("MATA462TN")
	If lRet .AND. lDSASTK7
		lRet := ExecBlock( "DSASTK7T", .F., .F.)
	EndIf
EndIf

If funname() == "MATA101N"
	//Alexei 20200702 Validacion de diferencia de taas de cambio
	If lDsValTX .and. lRet
		lRet := ExecBlock( "DSVALTX",.F.,.F.)
	EndIf
	If lRet
		For nX := 1 To Len(aCols)
			If lRet .AND. !aCols[nX,Len(aHeader)+1]
				_cTes := GdFieldGet("D1_TES",Nx)
				
				If lRet .AND. posicione("SF4",1,Xfilial("SF4") + _cTes , "F4_DUPLIC") == "S"  .And. Type("cCxCaixa")!="U" .And. Type("nCxValor")!="U" .And. !Empty(cCxCaixa) .And. !Empty(nCxValor)
					MsgStop("El TES indicado corresponde a caja chica pero se informo Un Tipo de entrada que genera financiero","VerIfique")
					lRet := .F.
				EndIf
			EndIf
		Next
	EndIf
	// Validaciones relacionadas a la descripcion adicional
	IF lDSAST11 .AND. lRet
		lRet := u_DSAST11T()
	EndIF
EndIf

If FunName() == "MATA465N" .AND. (Left( cEspecie,3)='NDC') 

	lRet := U_DSVFIS01()

    If lRet 
		lRet := U_DSVFIS02('C')
	EndIf

	If lRet
		dbSelectArea("SFP")
		dbSetOrder(1)
		dbSeek(xFilial("SFP") + cFilAnt + M->F2_SERIE)
		If Empty(SFP->FP_NFEEX) .and. !Empty(SFP->FP_CAI)
			For nX := 1 To Len(aCols)
				If !aTail(aCols[nX])
					If Posicione("NNR",1,xFilial("NNR") + GdFieldGet("D2_LOCAL",nX),"NNR_XTIPO") != "C"
						Aviso("Atención","Esta serie solo se puede usar con Titulos Por Cuenta y Orden",{"Ok"},2)
						lRet := .F.
						Exit
					EndIf
				EndIf
			Next nX
		EndIf
	EndIf

EndIf 

If FunName() == "MATA465N" .AND. (Left( cEspecie,3)='NCC') 

	lRet := U_DSVFIS01()

	If lRet
		If !Empty(M->F1_XNROSOL)
			lRet := U_DSEF302T()	// Validaciones relacionadas a Solicitudes de Notas de Crédito (DSEFA302.prw)
		Else
			If !GetMV('DS_NCCRON',.F.,.F.) 
				Aviso ("Autorizacion NCC","Debe informar la Solicitud de Nota de Crédito",{"OK"},2)
				lRet := .F.
			EndIf
		EndIf
	EndIf

	If lRet
		lRet := U_DSVFIS02('NC')
	EndIf

	If lRet
		dbSelectArea("SFP")
		dbSetOrder(1)
		dbSeek(xFilial("SFP") + cFilAnt + M->F1_SERIE)
		If Empty(SFP->FP_NFEEX) .and. !Empty(SFP->FP_CAI)
			For nX := 1 To Len(aCols)
				If !aTail(aCols[nX])
					If Posicione("NNR",1,xFilial("NNR") + GdFieldGet("D1_LOCAL",nX),"NNR_XTIPO") != "C"
						Aviso("Atención","Esta serie solo se puede usar con Titulos Por Cuenta y Orden",{"Ok"},2)
						lRet := .F.
						Exit
					EndIf
				EndIf
			Next nX
		EndIf
	EndIf
EndIf

If lRet .And. aCfgNF[SnTipo] == 60	// Remito de entrada
	//Alexei 20200702 VAlidación de tasa de cambio
	If lDsValTX .and. lRet
		lRet := ExecBlock( "DSVALTX",.F.,.F.)
	EndIf

	//Alexei 20200521 Validacion de REmito con Orden de Compra
	If lRet .and. (FunName() == "MATA102N" .and. cEspecie = "RCN")
		nPedido := aScan( aHeader, { |x| Alltrim(x[2]) == "D1_PEDIDO"})
		nItemPC := aScan( aHeader, { |x| Alltrim(x[2]) == "D1_ITEMPC"})
		For nX := 1 To Len(aCols)
			If (Empty(aCols[nX][nPedido]) .Or. Empty(aCols[nX][nItemPC])) .and. !aCols[nX][Len(aCols[nX])] 
				Aviso("Atención","No se puede cargar Remito sin Orden de Compra asociado " + Chr(13) + Chr(10) +;
					"Por favor revisen Item " + aCols[nX][nItem] + " del Remito.",{"Ok"},2)
			EndIf
			lRet := .F.
		Next nX
	EndIf
	//Hasta aqui Alexei 20200521 VAlidacion de REmito con Orden de Compra

	// A. Perret (05/08/20): validación de depósitos desestimada.
	// If lRet
		// lRet := U_DSEF301S("TOK")
	// EndIf
	// ----------------------------------------------------------

	//Alexei 20200708 Validacion de Modo de Entrega
	If lRet .and. (M->F1_XMODENT == '3' .or. Empty(M->F1_XMODENT))
		Aviso ("Modo de Retiro","Campo Modo de Entrega no está Definido",{"OK"},2)
		lRet := .F.	
	EndIf
EndIf

//---------------------------
// Especifico de Cupos
// Validacion de datos
//---------------------------
If lRet .And. ExistBlock("VLOCXCUP")
	lRet := ExecBlock( "VLOCXCUP", .F., .F.)
EndIf

	IF IsInCallStack("MATA102N")
		// Validaciones relacionadas a la descripcion adicional
		IF lDSAST11 .AND. lRet
			lRet := u_DSAST11T()
		EndIF
	EndIF

// agregdo para validar condicion de pago en documentos de diferencia de cambio a pagar
If  Funname() == "MATA466N" .and. ExistBlock("DSVLDIFP")
	lRet := ExecBlock( "DSVLDIFP", .F., .F.)

EndIf
RestArea(aAreaSFP)
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aArea)


//ADV: FUENTES TDEP
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
		
		
	End
End




Return(lRet)


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
