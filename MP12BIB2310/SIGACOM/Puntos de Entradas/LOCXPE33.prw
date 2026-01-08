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

	If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
		Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
	ENDIF


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

	If nTipo == 01 //Factura de Venta
		IF FUNNAME() $ "MATA467N"
			AADD(aDetalles,{"F2_XTIPDOC"   ,  .T.      ,.F.      ,.F.   }) // 1= campo - 2=? - 3=obligatorio - 4=deshabilita
			AADD(aDetalles,{"F2_UNITCLI"   ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XCLDOCI"   ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_UNOME"   ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XEMAIL"   ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_EMISSAO"   ,  .T.      ,.F.      ,.F.   })
		ENDIF
	EndIf


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

	If alltrim(UPPER(FUNNAME())) $ "MATA467N" //remito de salida

		if lInclui

			if Type("cxSeriex")<>"U" //la variable existe borramos
				cxSeriex := NIL
				FreeObj(cxSeriex)
			endif

			if Type("cNumFac")<>"U" //la variable existe borramos
				cNumFac := NIL
				FreeObj(cNumFac)
			endif

			public cxSeriex := getSerieFac()
			public cNumFac := ""

			nPosSeri := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_SERIE"})
			nPosLoj  := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_LOJA"})
			nPosDoc  := aScan(aCposNF,{|x| Upper(AllTrim(x[2])) == "F2_DOC"})

			If nPosSeri > 0 .AND. nPosLoj > 0 .AND. nPosDoc > 0
				aCposNF[nPosSeri,16] := ""
				aCposNF[nPosSeri,6] := ""
				aCposNF[nPosLoj,6] := StrTran( aCposNF[nPosLoj,6], ".And. LocXVal('F2_LOJA')", " " )

				cVld 	:=	"U_ValSeFat()"
				aCposNF[nPosSeri,06] := cVld	//Validación de Usuario
				aCposNF[nPosSeri][11]:= "cxSeriex" //asignar valor

				cNumFac = ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"01"+ cxSeriex,"X5_DESCRI"))

				aCposNF[nPosDoc][11]:= "cNumFac" //asignar valor

			Endif
		endif

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

/*VALIDA REMITO DE SALIDA SERIE*/
User Function ValSeFat
	Local lRet := .F.

	if ExistCpo("SX5","01"+M->F2_SERIE) ////existe la serie

		if getSerieFac() == M->F2_SERIE
			lRet := .t.
		else
			//alert("Serie incorrecta para esta sucursal")
			//M->F2_SERIE := getSerieFac()
		endif
	else
		//M->F2_SERIE := getSerieFac()
	endif
Return(lRet)

static Function getSerieFac()  ///aca podemos personalizar por sucursal y con parametro
	Local cxFillal	:= XFilial("SF2")

	cxSerie = SuperGetMV("MV_USERFAC",.F.,'F01')
	//cxSerie = "F01"
	/*Do Case
		Case cxFillal == "101"
			cxSerie:="R01"
		Case cxFillal == "102"
			cxSerie:="R02"
		Case cxFillal == "103"
			cxSerie:="R03"
		Case cxFillal == "104"
			cxSerie:="R04"
		Case cxFillal == "105"
			cxSerie:="R05"
		Case cxFillal == "106"
			cxSerie:="R06"
		Case cxFillal == "107"
			cxSerie:="R07"
		Case cxFillal == "108"
			cxSerie:="R08"
		Case cxFillal == "109"
			cxSerie:="R09"
		Case cxFillal == "110"
			cxSerie:="R10"
		Case cxFillal == "111"
			cxSerie:="R11"
		Case cxFillal == "112"
			cxSerie:="R12"
		Case cxFillal == "113"
			cxSerie:="R13"
		Case cxFillal == "114"
			cxSerie:="R14"
		Case cxFillal == "115"
			cxSerie:="R15"
		Case cxFillal == "201"
			cxSerie:="R16"
		Case cxFillal == "202"
			cxSerie:="R17"
		Case cxFillal == "203"
			cxSerie:="R18"
		Case cxFillal == "204"
			cxSerie:="R19"
		Case cxFillal == "205"
			cxSerie:="R20"
		Case cxFillal == "206"
			cxSerie:="R21"
		Case cxFillal == "207"
			cxSerie:="R22"
		Case cxFillal == "208"
			cxSerie:="R23"
		Case cxFillal == "209"
			cxSerie:="R24"
		Case cxFillal == "210"
			cxSerie:="R25"
		Case cxFillal == "211"
			cxSerie:="R26"
		Case cxFillal == "212"
			cxSerie:="R27"
		Case cxFillal == "213"
			cxSerie:="R28"
		Case cxFillal == "302"
			cxSerie:="R29"
		Case cxFillal == "303"
			cxSerie:="R30"
		Case cxFillal == "304"
			cxSerie:="R31"
		Case cxFillal == "305"
			cxSerie:="R32"
		Case cxFillal == "306"
			cxSerie:="R33"
		Case cxFillal == "307"
			cxSerie:="R34"
		Case cxFillal == "308"
			cxSerie:="R35"
		Case cxFillal == "309"
			cxSerie:="R36"
		Case cxFillal == "310"
			cxSerie:="R37"
		Case cxFillal == "311"
			cxSerie:="R38"
		Case cxFillal == "312"
			cxSerie:="R39"
		Case cxFillal == "401"
			cxSerie:="R40"
		Case cxFillal == "402"
			cxSerie:="R41"
		Case cxFillal == "501"
			cxSerie:="R42"
		Case cxFillal == "502"
			cxSerie:="R43"
		Case cxFillal == "601"
			cxSerie:="R44"
		Case cxFillal == "602"
			cxSerie:="R45"
		Case cxFillal == "603"
			cxSerie:="R46"
		Case cxFillal == "701"
			cxSerie:="R47"
		Case cxFillal == "702"
			cxSerie:="R48"
		Case cxFillal == "703"
			cxSerie:="R49"
		Case cxFillal == "704"
			cxSerie:="R50"
		Case cxFillal == "801"
			cxSerie:="R51"
		Case cxFillal == "802"
			cxSerie:="R52"
		Case cxFillal == "901"
			cxSerie:="R53"
		Case cxFillal == "902"
			cxSerie:="R54"
		Case cxFillal == "903"
			cxSerie:="R55"
		OtherWise
			cxSerie:= "R"
	End Case*/

Return cxSerie
