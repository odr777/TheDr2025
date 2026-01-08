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
±±ºPrograma  ³ImportBo  ºAutor  ³Denar Terrazas		  Fecha ³  24/05/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa Importación de Reglas de descuento	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \ Mercantil León                                   º±±
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
	Local nX			:= 1
	Local cTitulo1  	:= "Seleccione Archivo"
	Local cExtens   	:= "Archivo | "
	Local cFile 		:= ""
	Local cLinea		:= ""
	Local cCampo		:= ""
	Local aValores		:= {}
	Local aCpos			:= {}
	Local cFileLog		:= ""
	Local cDirLog		:= ""
	Local cPath			:= ""
	Local lError		:= .F.
	Local nCantReg		:= 0
	Local lFin			:= .F.
	Local aArray		:= {}
	Local aTotCabs		:= {}
	Local xValor
	// Local aCabec		:= {}
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

		FT_FSkip()
		FT_FSkip()

		cLinea	:= FT_FREADLN()
		aCpos	:= Str2Array(cLinea,';')

		FT_FSkip()

		While (!FT_FEof() .And. !lFin)

			cLinea	:= FT_FREADLN()
			aValores:= Str2Array(cLinea,';')
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

			aAdd(aTotCabs,aArray)
			aArray 	:= {}

			FT_FSkip()
		EndDo

		If !lError
			For nX := 1 To Len(aTotCabs)
				lMSErroAuto := .F.

				nFilCod		:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_FILIAL" }) /* rule branch code */
				nCodTab		:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_CODREG" }) /* rule code */
				nPosDesc	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_DESCRI" }) /* Description */
				nClCode		:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_CODCLI" }) /* Client code */
				nClStore	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_LOJA" }) /* client store */
				nDatdesde	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_DATDE" }) /* Initial date */
				nDataAte	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_DATATE" }) /* Final Date */
				nHoraDe		:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_HORADE" }) /* Initial time */
				nHoraAte	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_HORATE" }) /* Final time */
				nPosMoeda	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACO_MOEDA" }) /* Currency */

				cxBranch	:= If(nFilCod	> 0, aTotCabs[nX,nFilCod][2]	, xFilial("ACO") )
				cListaPrc	:= If(nCodTab	> 0, aTotCabs[nX,nCodTab][2]	, GETSX8NUM("ACO","ACO_CODREG") )
				cxDesc		:= If(nPosDesc	> 0, aTotCabs[nX,nPosDesc][2]	, "" )
				cClCode		:= If(nClCode	> 0, aTotCabs[nX,nClCode][2]	, "" )
				cClStore	:= If(nClStore	> 0, aTotCabs[nX,nClStore][2]	, "" )
				dDtadesde	:= If(nDatdesde > 0, aTotCabs[nX,nDatdesde][2]	, ddatabase )
				nDatAte		:= If(nDataAte 	> 0, aTotCabs[nX,nDataAte][2]	, CTOD("  /  /    ") )
				cHoraDe		:= If(nHoraDe	> 0, aTotCabs[nX,nHoraDe][2]	, "00:00" )
				cHoraAte	:= If(nHoraAte	> 0, aTotCabs[nX,nHoraAte][2]	, "23:59" )
				nXMoeda		:= If(nPosMoeda > 0, aTotCabs[nX,nPosMoeda][2]	, 1	)

				aCabecalho := { ;
					{ "ACO_FILIAL"	, cxBranch	, NIL},;
					{ "ACO_CODREG"	, cListaPrc	, NIL},;
					{ "ACO_DESCRI"	, cxDesc	, NIL},;
					{ "ACO_CODCLI"	, cClCode	, NIL},;
					{ "ACO_LOJA"	, cClStore	, NIL},;
					{ "ACO_DATDE"	, dDtadesde	, NIL},;
					{ "ACO_DATATE"	, nDatAte	, NIL},;
					{ "ACO_HORADE"	, cHoraDe	, NIL},;
					{ "ACO_HORATE"	, cHoraAte	, NIL},;
					{ "ACO_MOEDA"	, nXMoeda	, NIL};
					}

				aLinha 	:= {}

				While   nX <= Len(aTotCabs) .AND. cListaPrc == aTotCabs[nX,nCodTab][2]

					aItens := {}

					nCodProdto	:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACP_CODPRO" })
					nPERDES		:= aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACP_PERDES" })

					cXProduct	:= If( nCodProdto > 0, aTotCabs[nX,nCodProdto][2], "" )
					cXPerdes	:= If( nPERDES > 0, aTotCabs[nX,nPERDES][2], 0 )

					aAdd(aItens,{"ACP_ITEM" , StrZero(nX,3,0), NIL})
					aAdd(aItens,{"ACP_CODPRO" , cXProduct, NIL})
					aAdd(aItens,{"ACP_PERDES" , cXPerdes, NIL})

					nX++

					aAdd(aLinha ,aItens)

					If nX > Len(aTotCabs)
						Exit
					Endif

				EndDo

				nX--

				// MSExecAuto({|X,Y,Z| FATA080(X,Y,Z)}, aCabecalho, aLinha, 3)
				Begin Transaction

					lExistACO:= IIF( Empty(TRIM(GetAdvFVal("ACO", "ACO_CODREG", cxBranch + cListaPrc,1,""))), .F., .T. ) //ACO_FILIAL+ACO_CODREG

					If(lExistACO)//Si existe la borra
						FATA080(aCabecalho,aLinha,5)//3=Incluir;4=Modificar;5=Borrar
					EndIf

					FATA080(aCabecalho,aLinha,3)//3=Incluir;4=Modificar;5=Borrar

					If lMSErroAuto
						RollBackSx8()
						DisarmTransaction()//Rollback
						MostraErro()
					Else
						AutoGrLog( " - Listas incluidas: " + cListaPrc )
						AutoGrLog( " " )
					EndIf

				End Transaction

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
