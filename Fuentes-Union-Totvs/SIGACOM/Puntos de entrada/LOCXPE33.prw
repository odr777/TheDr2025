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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function LOCXPE33()

	Local aArea := GetArea()
	Local aCposNF := ParamIxb[1]
	Local nTipo := ParamIxb[2]
	Local aDetalles := {}
	Local nNuevoElem := 0
	Local nPosCpo := 0

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
		AADD(aDetalles,{"F2_UCOBS"  ,  .T.      ,.F.      ,.F.   })
	Endif
	If nTipo == 64 //Transferencia entre Sucursales - Salida
		AADD(aDetalles,{"F1_UCOBS"  ,  .T.      ,.F.      ,.F.   })
	endif
	If nTipo == 07 //Nota de Crédito Proveedor
		AADD(aDetalles,{"F2_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
	End

	If nTipo == 09 //Nota Débito Proveedor (NDP)
		AADD(aDetalles,{"F1_XOBS"     ,  .T.      ,.F.      ,.F.   })
	EndIf

	If nTipo == 04 //Nota Crédito Cliente (NCC)		
		AADD(aDetalles,{"F1_UOBSDEV"  ,  .T.      ,.F.      ,.F.   })
		// Aviso("query",U_zArrToTxt(aCposNF,,),{"si"})
		// Aviso("query",U_zArrToTxt(aDetalles,,),{"si"})
		
	EndIf

	If nTipo == 01 //Factura de Venta
		IF FUNNAME() $ "MATA467N"

			AADD(aDetalles,{"F2_EMISSAO"   ,  .T.      ,.F.      ,.F.   })

		ENDIF
	EndIf

	If nTipo == 60 .or. nTipo = 14 //Remito de Entrada o Conocimiento de Flete
		/*AADD(aDetalles,{"F1_UALMACE"  ,  .T.      ,.T.      ,.F.   })
		AADD(aDetalles,{"F1_SERIE"  ,  .T.      ,.T.      ,.F.   })*/
		//      AADD(aDetalles,{"F1_UCORREL"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		//     AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End

	if  nTipo == 13 //Gastos de Importación
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		//	  AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End

	If nTipo == 10 .or. nTipo == 13 //Factura de Entrada
		//AADD(aDetalles,{"F1_UNOMBRE"  ,  .T.      ,.F.      ,.F.   })
		//AADD(aDetalles,{"F1_UNIT"  ,  .T.      ,.F.      ,.F.   })
		//AADD(aDetalles,{"F1_SERIE"  ,  .T.      ,.T.      ,.F.   })
		//AADD(aDetalles,{"F1_UDESCON"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		//	AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
		AADD(aDetalles,{"F1_XOBS"     ,  .T.      ,.F.      ,.F.   })
	End

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
	if nTipo == 1
		nPosCom := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_COMPANH"})
		if nPosCom>0
			ADel(aCposNF,nPosCom)// Quita el campo
			ASize(aCposNF,Len(aCposNF)-1)
		endif
		nPosLojCo := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_LOJCOMP"})
		IF nPosLojCo>0
			ADel(aCposNF,nPosLojCo) 								   // Quita el campo
			ASize(aCposNF,Len(aCposNF)-1)
		ENDIF
		nPosPass := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_PASSAGE"})
		IF nPosPass>0
			ADel(aCposNF,nPosPass) 								   // Quita el campo
			ASize(aCposNF,Len(aCposNF)-1)
		ENDIF
		nPosDtPass := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_DTPASSA"})
		IF nPosDtPass>0
			ADel(aCposNF,nPosDtPass) 								   // Quita el campo
			ASize(aCposNF,Len(aCposNF)-1)
		ENDIF

		if lInclui
			if funname() $ "MATA467N"
				nPosEmis := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_EMISSAO"})
				aCposNF[nPosEmis][6] := ""
			ENDIF
		ENDIF
	endif

	If nTipo == 13 .OR. nTipo == 14 //Gastos de Importación | Frete
		nPosSeri := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F1_SERIE"})
		If nPosSeri > 0
			cVld 	:=	aCposNF[nPosSeri,6]
			//cVld 	+=	IIf(!Empty(cVld)," .AND. ","") +"M->F1_SERIE <> 'REM'"
			cVld 	+=	IIf(!Empty(cVld)," .AND. ","") +"U_ValSerFat()"
			aCposNF[nPosSeri,6] := cVld
		Endif
	Endif

Return( aCposNF )
User Function ValSerFat
	Local lRet := .T.

	lRet := M->F1_SERIE <> 'REM'
	If !lRet
		Aviso("LOCXPE33 - AVISO","No esta permitido utilizar la Serie REM en Factura de Entrada: Gasto Import./Flete",{"OK"})
	Endif

Return(lRet)
