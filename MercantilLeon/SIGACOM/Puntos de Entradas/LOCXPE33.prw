#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE33  ºAuthor ³Jorge Saavedra           º Date ³  12/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Define  campos de que deben ser visuales o obligados       ³±±
±±³          ³ conforme la rutina ejecutada. Ej: MATA102N Campo Almacen como³±±
±±³          ³ visual..                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ BASE BOLIVIA                                                    º±±
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
	Local nL := 0

	iF nTipo == 64 //Transferencia entre Sucursales - Entrada
		AADD(aDetalles,{"F1_UNROREC"  , .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UOBSERV"  , .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End

	If nTipo == 54 //Transferencia entre Sucursales - Salida
		AADD(aDetalles,{"F2_UNROREC"  , .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_UOBSERV"  , .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_USRREG "  ,  .T.      ,.F.      ,.T.   })

		nPosEmis2 := Ascan(aCposNF,{|x| x[2] == "F2_EMISSAO" })

		IF nPosEmis2 > 0
			aCposNF[nPosEmis2][17] := ".T."    /// (SetVar('F2_EMISSAO') .And. !aCfgNf[3] .Or. M->F2_EMISSAO == dDataBase) .And. LocXVal('F2_EMISSAO')
			aCposNF[nPosEmis2][6] := " "
		endif
	End

	If nTipo == 07 //Nota de Crédito Proveedor
		AADD(aDetalles,{"F2_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
	End

	If nTipo == 60 .or. nTipo = 14 //Remito de Entrada o Conocimiento de Flete
		AADD(aDetalles,{"F1_UCORREL"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End

	if  nTipo == 13 //Gastos de Importación
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End

	If nTipo == 10 .or. nTipo == 13 //Factura de Entrada
		AADD(aDetalles,{"F1_UNOMBRE"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UNIT"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_UPOLIZA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_USRREG "  ,  .T.      ,.F.      ,.T.   })
	End

	For nL := 1 To Len(aDetalles)
		If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0

			aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
			If Len(aCposNF[nPosCpo]) == 16
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

	RestArea( aArea )

Return( aCposNF )


User Function ValSerFat
	Local lRet := .T.

	lRet := M->F1_SERIE <> 'REM'
	If !lRet
		Aviso("LOCXPE33 - AVISO","No está permitido utilizar la Serie REM en Factura de Entrada: Gasto Import./Flete",{"OK"})
	Endif

Return(lRet)
