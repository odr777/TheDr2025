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
ฑฑบPrograma  ณMigraSE1  บAutor  ณEdson  		 บFecha ณ  30/05/2019     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa Importa็ใo de lista de precio				  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia\Inesco                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function Importexc()
	Private oDlg			
	Private oModel  := FWModelActive()
	Private oView := FWViewActive()
//	oView:SetModel( oModel )
//	oModel := FWLoadModel( oModel)
	//alert(FUNNAME())
	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importaci๓n de Remisiones/OwnerShip")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar uno o mas "
	@ 018,018 Say "productos de una lista de precio desde un archivo *.csv"
	//.xlsx

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImportar  บAutor  ณEdson 		         บFecha ณ  27/05/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11.3                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importar()
		
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
	Local cCposCab		:= "DA1_ITEM|DA1_CODTAB|DA1_CODPRO|DA1_PRCVEN"
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
	
	oModelGrid := oModel:GetModel( "DA1DETAIL" ) // obtener el modelo del grid
	nTotLin := oModelGrid:Length( .F. ) // obtenes el TOTAL de lineas del grid

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

	cExtens += "*.csv"
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

								if alltrim(cCampo) == "DA1_PRCVEN"
									//	xValor := Transform( xValor, "@E 9.999.999,9999")
									//									ALERT(xValor)
									xValor := Val(xValor)
								else
									if xValor $ ","
										xValor := StrTran( cString, ",", "." )
									else
										xValor := Val(xValor)
									endif
								endif

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
						
//				nPosItem   := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "DA1_ITEM"   })
//				nPosCodtab := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "DA1_CODTAB" })
				nPosCodpro := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "DA1_CODPRO" })
				nPosPrcven := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "DA1_PRCVEN" })
				nPosMoeda := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) ==  "DA1_MOEDA" })

				//cxLlave	 := aTotCabs[nX,nPosDocu] + aTotCabs[nX,nPosSeri] +aTotCabs[nX,nPosForn] +aTotCabs[nX,nPosLoja]

				cxFilial	:= xFilial("DA1")
//				cxItem	    := If(nPosItem   > 0	,aTotCabs[nX,nPosItem][2]	, ""	)
//				cxCodtab	:= If(nPosCodtab > 0	,aTotCabs[nX,nPosCodtab][2]	, "   "	)
				cxCodpro	:= If(nPosCodpro > 0	,aTotCabs[nX,nPosCodpro][2]	, ""	)
				cxPrecio	:= If(nPosPrcven > 0	,aTotCabs[nX,nPosPrcven][2]	, " "	)
				cxMoneda	:= If(nPosMoeda > 0	,aTotCabs[nX,nPosMoeda][2]	, " "	)
				nxTxMoeda	:= 1
				/*If nxMoeda <> 1
				nxTxMoeda	:= If(nPosTxMo > 0	,aTotCabs[nX,nPosTxMo][2]	,	RecMoeda(dDataBase,nxMoeda))
				Endif*/

				/*
				*
				Verificando se existe a remisใo
				*
				*/


				/*DbSelectArea("DA1")
				DA1->(DbSetOrder(2))
				If DA1->(DbSeek(xFilial("DA1")+cxCodpro+cxCodtab+cxItem))
				RecLock('DA1',.F.)	//Modificando el item Grabado por el Disparador
				DA1->DA1_PRCVEN	:= cxPrecio
				DA1->(MsUnlock())
				else
				RecLock('DA1',.T.)	//Modificando el item Grabado por el Disparador
				DA1->DA1_PRCVEN	:= nPrecio
				DA1->(MsUnlock())
				Endif*/
				impArcExcel(cxCodpro,cxPrecio,cxMoneda,nX)

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
	oView:Refresh() // haces un refresh a la VIEW
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

static Function impArcExcel(codigoPro, cxPrecio,nPosMoeda, nX)

//	local oModel := Model	
	local oModelGrid 
//	oModel := FWModelActive()
	local nLin 
	//oModelGrid := oModel:GetModel( "FLYDETAIL" ) // obtener el modelo del grid
	// Retorna o total de linhas, incluindo as deletadas.*
	local lEncontro := .F.
	oModelGrid := oModel:GetModel( "DA1DETAIL" ) // obtener el modelo del grid
	nTotLin := oModelGrid:Length( .F. ) // obtenes el TOTAL de lineas del grid
	/*
	For nLin := 1 To nTotLin

		oModelGrid:SetLine( nLin  ) // le das el total

		If !oModelGrid:IsDeleted( nLin ) // si es que NO estแ borrada
			if (oModelGrid:getvalue("DA1_CODPRO") == codigoPro )// comprobar)
				oModelGrid:SetValue("DA1_PRCVEN",  cxPrecio )    // modificas el VALOR
				lEncontro := .T.				
			EndIf
		EndIf		
	Next*/
	
	if oModelGrid:SeekLine({{"DA1_CODPRO",codigoPro}})
//		codigoPro
		oModelGrid:SetValue("DA1_PRCVEN",  cxPrecio )
	else
//	if !lEncontro
		oModelGrid:AddLine() // AGREGAS UNA LINEA
		oModelGrid:SetLine( nTotLin++ )
		oModelGrid:SetValue("DA1_CODPRO",  codigoPro )    // modificas el VALOR
		oModelGrid:SetValue("DA1_MOEDA",  nPosMoeda )    // modificas el VALOR
		oModelGrid:SetValue("DA1_PRCVEN",  cxPrecio )    // modificas el VALOR
	endif
	// importar en si
	/*oModelGrid:AddLine() // AGREGAS UNA LINEA
	oModelGrid:SetLine( nLin++ ) // TE VAS A ESA LINEA
	oModelGrid:SetValue("DA1_PRCVEN", 23 )   // agregas segun la columna el valor deseado*/
	//aAdd(bLoadGrd,{0,{1, ddatabase, 12, 12,12,12,12}})
	nTotLin++
	oModelGrid:SetLine( 1 )


return