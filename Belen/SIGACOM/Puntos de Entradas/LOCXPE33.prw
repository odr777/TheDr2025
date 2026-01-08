#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE33  ºAuthor ³Nain Terrazas      º Date ³  28/09/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Define  campos de que deben ser visuales u oblitariorios   ³±±
±±³          ³ conforme la rutina ejecutada. Ej: MATA102N Campo Almacen como³±±
±±³          ³ visual..                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß+-ßßßßß
*/

User Function LOCXPE33()
Local aArea 	 := GetArea()
Local aCposNF 	 := ParamIxb[1]
Local nTipo 	 := ParamIxb[2]
Local aDetalles  := {}
Local nNuevoElem := 0
Local nPosCpo	 := 0
Local nL

	If nTipo == 54 //Transferencia entre Sucursales - Salida
		if lInclui
			nPosSeri := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_SERIE"})
			nPosLoj  := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_LOJA"})
			nPosLfi  := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_FILDEST"})
			aCposNF[nPosSeri,16] := ""
			aCposNF[nPosSeri,6] := ""
			aCposNF[nPosLfi,6] := StrTran( aCposNF[nPosLfi,6], ".AND. LocXVal('F2_LOJA')", " " )
			aCposNF[nPosLoj,6] := StrTran( aCposNF[nPosLoj,6], ".And. LocXVal('F2_LOJA')", " " )
		endif
		AADD(aDetalles,{"F2_HAWB"  ,  .T.      ,.F.      ,.F.   })
	End

	If nTipo == 07 //Nota de Crédito Proveedor
		AADD(aDetalles,{"F2_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
	End

	//If nTipo == 50 //Remito de Venta

	//Endif

	If nTipo == 60 .or. nTipo = 14 //Remito de Entrada o Conocimiento de Flete
		/*
		AADD(aDetalles,{"F1_UALMACE"	,  .T.      ,.T.      ,.F.   })
		AADD(aDetalles,{"F1_SERIE"  	,  .T.      ,.T.      ,.F.   })		
		AADD(aDetalles,{"F1_UCORREL"  	,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_USRREG "  	,  .T.      ,.F.      ,.T.   })
		*/
		AADD(aDetalles,{"F1_UPOLIZA"  	,  .T.      ,.F.      ,.F.   })		
	Endif

/*	if  nTipo == 13 //Gastos de Importación
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		//	  AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End
*/

	If nTipo == 10 .or. nTipo == 13 //Factura de Entrada
		//aCposNF[3][11] := "Posicione('SA2',1,xFilial('SA2')+M->F1_FORNECE+M->F1_LOJA,cP1+ 'NREDUZ')" // modificando para NOMBRE FANTASIA NAHIM 07/08/2019
		//aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_SERIE"})	
		
		aCposNF[aScan(aCposNF,{|x| AllTrim(x[2]) == "cNome"})][11] := "Posicione('SA2',1,xFilial('SA2')+M->F1_FORNECE+M->F1_LOJA,cP1+ 'NREDUZ')" // modificando para NOMBRE FANTASIA NAHIM 07/08/2019
		AADD(aDetalles,{"F1_XOBS "  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UNOMBRE"	,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UNIT"  		,  .T.      ,.F.      ,.F.   })
		//AADD(aDetalles,{"F1_SERIE"  	,  .T.      ,.T.      ,.F.   })
		//AADD(aDetalles,{"F1_UDESCON"  ,  .T.      ,.F.      ,.F.   })
		//AADD(aDetalles,{"F1_UPOLIZA"  	,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UHAWB"  	,  .T.      ,.F.      ,.F.   })
		//AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
		
		nPosDoc := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_DOC"})
		aCposNF[nPosDoc,6] := StrTran( aCposNF[nPosDoc,6], ".AND. LocxValNum()", " " )
		
		nPosDt := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_EMISSAO"})
		SX3->(MsSeek("F1_EMISSAO"))		
		aCposNF[nPosDt,6] := LocX3Valid()
		//aCposNF[nPosDt,6] := StrTran( LocX3Valid(), ".And. LocX3Valid()", " " )
	End

	If nTipo == 1 //Factura de salida
		AADD(aDetalles,{"F2_UNOMCLI"  ,  .T.      ,.T.      ,.F.   }) // 1= campo - 2=? - 3=obligatorio - 4=deshabilita
		AADD(aDetalles,{"F2_UNITCLI"  ,  .T.      ,.T.      ,.F.   })		
	Endif

	For nL := 1 To Len(aDetalles)
		If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0

			aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
			If Len(aCposNF[nPosCpo]) == 16
				//aIns(aCposNF[nPosCpo],17)
				SX3->(DbSetOrder(2))
				SX3->(DbSeek(AllTrim(aDetalles[nL][1])))
				aCposNF[nPosCpo] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
			EndIf
			aCposNF[nPosCpo][17] := If(aDetalles[nL][4],".F.",".T.")   // Desabilita el campo
			If !aDetalles[nL][2]
				ADel(aCposNF,nPosCpo) 								   // Quita el campo
				ASize(aCposNF,Len(aCposNF)-1)                          // Ajusta Array
			EndIf
		Else
			DbSelectArea("SX3")
			DbSetOrder(2)
			If DbSeek( aDetalles[nL][1] )
				nNuevoElem := Len(aCposNF)+1
				aCposNF := aSize(aCposNF,nNuevoElem)
				aIns(aCposNF,nNuevoElem)
				aCposNF[nNuevoElem] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
			EndIf
		EndIf

	Next nL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida que no Digiten la Serie REM en Facturas de Entrada  	³
	//³ Gasto de Import./Flete - EDUAR ANDIA 05/09/2016			   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nTipo == 13 .OR. nTipo == 14 //Gastos de Importación | Frete
		nPosSeri := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_SERIE"})
		If nPosSeri > 0
			cVld 	:=	aCposNF[nPosSeri,6]
			//cVld 	+=	IIf(!Empty(cVld)," .AND. ","") +"M->F1_SERIE <> 'REM'"
			cVld 	+=	IIf(!Empty(cVld)," .AND. ","") +"U_ValSerFat()"
			aCposNF[nPosSeri,6] := cVld
		Endif
	Endif
RestArea(aArea)
Return( aCposNF )

User Function ValSerFat
	Local lRet := .T.

	lRet := M->F1_SERIE <> 'REM'
	If !lRet
		Aviso("LOCXPE33 - AVISO","No está permitido utilizar la Serie REM en Factura de Entrada: Gasto Import./Flete",{"OK"})
	Endif

Return(lRet)
