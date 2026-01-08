#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#include "Topconn.ch"
#Include "FileIO.ch"

#Define ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImportBo  บAutor  ณErick etcheverry 	  Fecha ณ  29/01/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa Importa็ใo de bonificacion		             	  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia\union                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ImportBo()
	Private oDlg

	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importaci๓n de bonificacion")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar una o mas "
	@ 018,018 Say "bonificaciones desde un archivo *.csv"

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImportar  บAutor  ณEDUAR ANDIA   		 บFecha ณ  23/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importar
	Local cTabla		:= ""
	Local cStrCpos		:= ""
	Local nX			:= 1
	Local cTitulo1  	:= "Seleccione Archivo"
	Local cExtens   	:= "Archivo | "
	Local cFile 		:= ""
	Local aArchi		:= {}
	Local cLinea		:= ""
	Local cCampo		:= ""
	Local cNumPed		:= ""
	Local cNumAux		:= ""
	Local cCposCab		:= "F1_DOC|F1_SERIE|F1_FORNECE|F1_LOJA|F1_EMISSAO|F1_MOEDA|F1_TXMOEDA|D1_COD|D1_QUANT|D1_VUNIT|D1_TOTAL|D1_TES|D1_LOCAL"
	Local lFirst		:= .T.
	Local lGrabCab		:= .T.
	Local aValores		:= {}
	Local aCpos			:= {}
	Local cHoraIni		:= Time()
	Local cProxReg		:= ""
	Local cFileLog		:= ""
	Local cDirLog		:= ""
	Local cPath			:= ""
	Local lError		:= .F.
	Local nCantReg		:= 0
	Local lFin			:= .F.
	Local aArray		:= {}
	Local aTotCabs		:= {}
	Local aItArray		:= {}
	Local xValor
	Local cxDoc			:= ""
	Local aCabec		:= {}
	Local aItem			:= {}
	Local aLinha		:= {}

	Private lMSHelpAuto := .T. //.F. // Para nao mostrar os erro na tela
	Private lMSErroAuto := .F. //.F. // Inicializa como falso, se voltar verdadeiro e' que deu erro

	/***
	* _________________________________________________________
	* cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
	* ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
	* <ExpC1> - Expressao de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diret๓rio inicial se necessแrio
	* <ExpL1> - .F. botใo salvar - .T. botใo abrir
	* <ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)
	*/

	cExtens += "*.CSV"
	cFile := cGetFile(cExtens,cTitulo1,,,.T.)

	If File( cFile )

		AutoGrLog( "Fecha Inicio.......: " + DToC(MsDate()) )
		AutoGrLog( "Hora Inicio........: " + Time() )
		AutoGrLog( "Environment........: " + GetEnvServer() )
		AutoGrLog( "Archivo............: " + Alltrim( Lower( cFile ) ) )
		AutoGrLog( " " )

		FT_FUse(cFile)
		FT_FGotop()

		cLinea	:= FT_FREADLN()
		aCpos	:= Str2Array(cLinea,';')

		//AddCampoOblg()

		FT_FSkip()

		While (!FT_FEof() .And. !lFin)

			cLinea		:= FT_FREADLN()
			aValores	:= Str2Array(cLinea,';')
			nCantReg++

			DbSelectArea("SX3")
			DbSetOrder(2)
			For nX := 1 To Len(aValores)
				cCampo := AllTrim(aCpos[nX])

				If SX3->(DbSeek(cCampo))
					xValor 	:= UPPER(AllTrim(aValores[nX]))

					If !lError
						lError	:= Len(xValor) > SX3->X3_TAMANHO
						If lError
							AutoGrLog( aValores[1] + " - Linea Nro: "+cValToChar(nCantReg)+". El valor del campo "+cCampo+" Excede el tamano del diccionario." )
							Exit
						Else
							Do Case
								Case SX3->X3_TIPO == "N"
								xValor := Val(xValor)
								Case SX3->X3_TIPO == "D"
								xValor := CTOD(xValor)
								Case SX3->X3_TIPO == "C"
								xValor := PADR(xValor,TamSX3(SX3->X3_CAMPO)[1])
							EndCase

							aAdd(aArray,{cCampo,xValor,NIL})
						EndIf
					EndIF
				Else
					lFin := .T.
					AutoGrLog( "El campo " + cCampo + " no se encuentra en el diccionario de datos." )
					Exit
				EndIf

			Next nX

			If lError
				aArray  := {}
				FT_FSkip()
				Loop
			EndIf

			If lFin
				Loop
			EndIf

			/*
			**
			*/

			aAdd(aTotCabs,aArray)
			aArray 	:= {}

			FT_FSkip()
		EndDo

		If !lError
			For nX := 1 To Len(aTotCabs)
				lMSErroAuto := .F.

				nPosBr := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_FILIAL" }) /* branch */
				nPosRule := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_CODREG" }) /* rule code */
				nPosDesc := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_DESCRI" }) /* description */
				nPosProd := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_CODPRO" }) /* product */
				nPosQuant := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_QUANT" }) /* quantity */
				nPosBonus := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_TPRGBN" }) /* type bonus */
				nPosTime := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_TPHORA" }) /* time type */
				nPosStT := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_HORADE" }) /* initial hour */
				nPosEndT := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_HORATE" }) /* final hour */
				nPosDate := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_DATDE" }) /* init. dt */

				cxBranch	:= If(nPosBr	> 0	,aTotCabs[nX,nPosBr][2]		, xFilial("ACQ")	)
				cxRule		:= If(nPosRule	> 0	,aTotCabs[nX,nPosRule][2]	, GETSX8NUM("ACQ","ACQ_CODREG")	)
				cxDesc		:= If(nPosDesc	> 0	,aTotCabs[nX,nPosDesc][2]	, ""	)
				cxProd		:= If(nPosProd 	> 0	,aTotCabs[nX,nPosProd][2]	, ""	)
				nxQuant		:= If(nPosQuant > 0	,aTotCabs[nX,nPosQuant][2]	, 1	)
				nxBonus		:= If(nPosBonus > 0	,aTotCabs[nX,nPosBonus][2]	, 1	)
				nxTime		:= If(nPosTime 	> 0	,aTotCabs[nX,nPosTime][2]	, 1	)
				cxStT		:= If(nPosStT 	> 0	,aTotCabs[nX,nPosStT][2]	, "00:00"	)
				cxEndT		:= If(nPosEndT 	> 0	,aTotCabs[nX,nPosEndT][2]	, "23:59"	)
				dxDate		:= If(nPosDate 	> 0	,aTotCabs[nX,nPosDate][2]	, ddatabase	)

				aCabecalho := { ;
				{ "ACQ_FILIAL" , cxBranch, NIL},;
				{ "ACQ_CODREG" , cxRule , NIL},;
				{ "ACQ_DESCRI" , cxDesc , NIL},;
				{ "ACQ_CODPRO" , cxProd , NIL},;
				{ "ACQ_QUANT"  , nxQuant , NIL},;
				{ "ACQ_TPRGBN" , nxBonus , NIL},;
				{ "ACQ_TPHORA" , nxTime , NIL},;
				{ "ACQ_HORADE" , cxStT , NIL},;
				{ "ACQ_HORATE" , cxEndT , NIL},;
				{ "ACQ_DATDE"  , dxDate , NIL};
				}

				aLinha 	:= {}

				While   nX <= Len(aTotCabs) .AND. cxBranch == xFilial("ACQ")	.AND. cxDesc == aTotCabs[nX,nPosDesc][2]	;
				.AND. cxProd  == aTotCabs[nX,nPosProd][2]

					aItens := {}

					nPosProdit := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACR_CODPRO" })
					nPosQuan := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACR_LOTE" })

					cxProdit		:= If(nPosProd 	> 0	,aTotCabs[nX,nPosProdit][2]	, ""	)
					nxQuant		:= If(nPosQuan 	> 0	,aTotCabs[nX,nPosQuan][2]	, 1	)

					aAdd(aItens,{"ACR_ITEM" , StrZero(nX,3,0), NIL})
					aAdd(aItens,{"ACR_CODPRO" , cxProdit, NIL})
					aAdd(aItens,{"ACR_LOTE" , nxQuant, NIL})

					nX++

					aAdd(aLinha ,aItens)

					If nX > Len(aTotCabs)
						Exit
					Endif

				EndDo

				nX--

				MSExecAuto({|X,Y,Z| FATA090(X,Y,Z)}, aCabecalho, aLinha, 3)

				If lMSErroAuto
					RollBackSx8()
					DisarmTransaction()
					MostraErro()
				Else
					AutoGrLog( " - reglas realizadas: " + cxRule )
				EndIf
			Next nX
		EndIf
	EndIf

	AutoGrLog( "  " )
	AutoGrLog( "Fecha Fin...........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Fin............: " + Time() )
	AutoGrLog( "Registros Procesados: " + cValToChar(nCantReg) )

	cFileLog := NomeAutoLog()

	If cFileLog <> ""
		nX := 1
		While .T.
			If File( Lower( cDirLog + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) ) // El directorio debe estar creado en el servidor bajo DATA
				nX++
				If nX == 999
					Exit
				EndIf
				Loop
			Else
				Exit
			EndIf
		EndDo
		__CopyFile( cPath + Alltrim( cFileLog ), Lower( cDirLog + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
		MostraErro(cPath,cFileLog)
		FErase( cFileLog )
	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunciขn     ณ          ณ Autor ณ                     ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescripciขn ณ                                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso        ณ                                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Str2Array(cString,cSep)
	Local 	aReturn := { }		,;
	cAux    := cString	,;
	nPos    := 0

	While At( cSep, cAux ) > 0
		nPos  := At( cSep, cAux )
		cVal  := SubStr( cAux, 1, nPos-1 )
		Aadd( aReturn,  cVal )
		cAux  := SubStr( cAux, nPos+1 )
	EndDo

	Aadd(aReturn,cAux)
Return(aReturn)
