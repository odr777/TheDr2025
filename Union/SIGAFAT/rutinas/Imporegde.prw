#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#include "Topconn.ch"
#Include "FileIO.ch"

#Define ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImportBo  ºAutor  ³Nahim Terrazas		  Fecha ³  13/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa Importação de Regla de descuento	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\union                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function imporegde()
	Private oDlg

	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importación de Regla de descuento")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar una o mas "
	@ 018,018 Say "Reglas de descuento desde un archivo *.csv"

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered
Return


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
	//	Local cCposCab		:= " 	F1_DOC|F1_SERIE|F1_FORNECE|F1_LOJA|F1_EMISSAO|F1_MOEDA|F1_TXMOEDA|D1_COD|D1_QUANT|D1_VUNIT|D1_TOTAL|D1_TES|D1_LOCAL"
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
	* ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	* <ExpC1> - Expressao de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diretório inicial se necessário
	* <ExpL1> - .F. botão salvar - .T. botão abrir
	* <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
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
						if SX3->X3_TIPO <> "D"
							lError	:= Len(xValor) > SX3->X3_TAMANHO
						endif
						If lError
							AutoGrLog( aValores[nx] + " - Linea Nro: "+cValToChar(nCantReg)+". El valor del campo "+cCampo+" Excede el tamano del diccionario." )
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

				nFilCod := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_FILIAL" }) /* rule code */
				nCodTab := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_CODREG" }) /* rule code */
				nPosDesc := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_DESCRI" }) /* description */
				nDatdesde := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_DATDE" }) /* product */
				nDataAte := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_DATATE" }) /* quantity */
				nHoradesde := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_HORADE" }) /* product */
				nHoraAte := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_HORAATE" }) /* quantity */
				nPosCnpago := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_CONDPG" }) /* type bonus */
				nPosDepTab := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_CODTAB" }) /* time type */
				grupoVenta := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_GRPVEN" }) /* initial hour */
				nPosEndT := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_PERDES" }) /* final hour */
				nPosPerLim := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_MOEDA" }) /* init. dt */

				cxBranch	:= If(nFilCod	> 0	,aTotCabs[nX,nFilCod][2]		, xFilial("ACO"))
				cListaPrc	:= If(nCodTab	> 0	,aTotCabs[nX,nCodTab][2]	, GETSX8NUM("ACO","ACP_CODREG")	)
				cxDesc		:= If(nPosDesc	> 0	,aTotCabs[nX,nPosDesc][2]	, ""	)
				dDtadesde	:= If(nDatdesde > 0	,aTotCabs[nX,nDatdesde][2]	, ddatabase	)
				nDatAte		:= If(nDataAte 	 > 0	,aTotCabs[nX,nDataAte][2]	, ddatabase	)
				cCondPago	:= If(nPosCnpago > 0	,aTotCabs[nX,nPosCnpago][2]	,"")
				cDepTap		:= If(nPosDepTab > 0	,aTotCabs[nX,nPosDepTab][2]	, ""	)
				cxStT		:= If(grupoVenta > 0    ,cvaltochar(aTotCabs[nX,grupoVenta][2]), "2"	)
				nxEndT		:= If(nPosEndT 	> 0	,aTotCabs[nX,nPosEndT][2]	, 0	)
				nPerlim		:= If(nPosPerLim 	> 0	,aTotCabs[nX,nPosPerLim][2]	, 2	)

				aCabecalho := { ;
					{ "ACO_FILIAL" , cxBranch , NIL},;
					{ "ACO_CODREG" , cListaPrc , NIL},;
					{ "ACO_DESCRI" , cxDesc , NIL},;
					{ "ACO_DATDE" , dDtadesde , NIL},;
					{ "ACO_DATATE"  , nDatAte , NIL},;
					{ "ACO_CONDPG" , cCondPago , NIL},;
					{ "ACO_CODTAB" , cDepTap , NIL},;
					{ "ACO_GRPVEN" , cxStT , NIL},;
					{ "ACO_PERDES" , nxEndT , NIL},;
					{ "ACO_MOEDA"  , nPerlim , NIL};
					}

				aLinha 	:= {}

				While   nX <= Len(aTotCabs) .AND. cListaPrc == aTotCabs[nX,nCodTab][2]
					//				.AND. cxProd  == aTotCabs[nX,nPosProd][2]*/

					aItens := {}

					nCodProdto := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACP_CODPRO" })
					nPERDES := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACP_PERDES" })
					//					nPrecioVta := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "DA1_PRCVEN" })

					cxProdit		:= If(nCodProdto 	> 0	,aTotCabs[nX,nCodProdto][2]	, ""	)

					aAdd(aItens,{"ACP_ITEM" , StrZero(nX,3,0), NIL})
					aAdd(aItens,{"ACP_CODPRO" , cxProdit, NIL})
					if nxEndT == 0 // sólo si es igual a cero debería considerar
						aAdd(aItens,{"ACP_PERDES" , If(nPERDES 	> 0	,aTotCabs[nX,nPERDES][2]	,0), NIL})
					endif
					//					aAdd(aItens,{"ACP_PRCVEN" , nPreco, NIL})

					nX++

					aAdd(aLinha ,aItens)

					If nX > Len(aTotCabs)
						Exit
					Endif

				EndDo

				nX--

				//				MSExecAuto({|X,Y,Z| FATA080(X,Y,Z)}, aCabecalho, aLinha, 3)
				FATA080(aCabecalho,aLinha,3)

				If lMSErroAuto
					RollBackSx8()
					DisarmTransaction()
					MostraErro()
				Else
					AutoGrLog( " - Listas incluidas: " + cListaPrc )
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
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funci¢n     ³          ³ Autor ³                     ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descripci¢n ³                                                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso        ³                                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
