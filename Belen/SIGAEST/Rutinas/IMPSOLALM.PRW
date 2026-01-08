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
ฑฑบPrograma  ณIMPORTSOLALM  บAutor  ณNahim Terrazas	  Fecha ณ  16/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa Solicitudes al almac้n			             	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia\BELEN					                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPSOLALM()
	Private oDlg

	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importaci๓n de Solicitudes al almac้n")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar solicitudes al almac้n"
	@ 018,018 Say "desde un archivo *.csv"

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
		//		ALERT(cLinea)
		aCpos	:= Str2Array(cLinea,';')

		//AddCampoOblg()

		FT_FSkip()

		//		alert("nuevo")
		//		ALERT(FT_FEof())
		//		ALERT(lFin)
		While (!FT_FEof() .And. !lFin)
			//			alert("entra")
			cLinea		:= FT_FREADLN()
			aValores	:= Str2Array(cLinea,';')
			nCantReg++

			//			DbSelectArea("SX3")
			//			DbSetOrder(2)
			For nX := 1 To Len(aValores)
				cCampo := AllTrim(aCpos[nX])
				//				If SX3->(DbSeek(cCampo))
				//									xValor 	:= UPPER(AllTrim(aValores[nX]))
				//
				//					If !lError
				//						lError	:= Len(xValor) > SX3->X3_TAMANHO
				//						If lError
				//							AutoGrLog( aValores[1] + " - Linea Nro: "+cValToChar(nCantReg)+". El valor del campo "+cCampo+" Excede el tamano del diccionario." )
				//							Exit
				//						Else
				//				alert(cCampo)
				//				alert(aValores[NX])
				Do Case
					Case cCampo == "DISP"
					xValor := Val(aValores[NX])
					aAdd(aArray,{"CP_QUANT",xValor,NIL})
					Case cCampo == "COMPONENTE"
					xValor := ALLTRIM(aValores[NX])
					aAdd(aArray,{"CP_PRODUTO",xValor,NIL})
					Case cCampo == "ALM_ESTANDAR"
					xValor := ALLTRIM(aValores[NX])
					aAdd(aArray,{"CP_LOCAL",xValor,NIL})
					Case cCampo == "ORDEN_PRODUCCION"
					xValor := ALLTRIM(aValores[NX])
					aAdd(aArray,{"CP_OP",xValor,NIL})
					Case cCampo == "FECHA"
					xValor := CTOD(aValores[NX])
					aAdd(aArray,{"CP_EMISSAO",xValor,NIL})
				EndCase

				//				aAdd(aArray,{cCampo,xValor,NIL})

				//						EndIf
				//					EndIF
				//				Else
				//					lFin := .T.
				//					AutoGrLog( "El campo " + cCampo + " no se encuentra en el diccionario de datos." )
				//					Exit
				//				EndIf

			Next nX

			If lError
				aArray  := {}
				FT_FSkip()
				Loop
			EndIf

			If lFin
				Loop
			EndIf

			**
			*/

			aAdd(aTotCabs,aArray)
			aArray 	:= {}

			FT_FSkip()
		EndDo
		dbSelectArea( 'SB1' )
		SB1->( dbSetOrder( 1 ) )

		dbSelectArea( 'SCP' )
		SCP->( dbSetOrder( 1 ) )
		If !lError
			For nX := 1 To Len(aTotCabs)
				//				alert("entra:" + cvaltochar(nX))
				lMSErroAuto := .F.

				nPospr := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "CP_PRODUTO" }) /* branch */
				nPosQuant := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "CP_QUANT" }) /* rule code */
				nPosAlc := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "CP_LOCAL" }) /* description */
				nPosOrPr := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "CP_OP" }) /* product */
				nPosFecha := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "CP_EMISSAO" }) /* type bonus */
				//				nPosQuant := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_QUANT" }) /* quantity */
				//				nPosTime := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_TPHORA" }) /* time type */
				//				nPosStT := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_HORADE" }) /* initial hour */
				//				nPosEndT := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_HORATE" }) /* final hour */
				//				nPosDate := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACQ_DATDE" }) /* init. dt */

				nQUanSol	:= aTotCabs[nX,nPosQuant][2]
				cAlmcen		:= aTotCabs[nX,nPosAlc][2]
				cxProd		:= aTotCabs[nX,nPosOrPr][2]
				dFechaSA	:= If(nPosFecha > 0	,aTotCabs[nX,nPosFecha][2]	, DDATABASE	)
				cNumero := GetSx8Num( 'SCP', 'CP_NUM' )

				//				aCabecalho := { ;
				//				{ "CP_PRODUTO" , cProducto, NIL},;
				//				{ "CP_QUANT" , nQUanSol , NIL},;
				//				{ "CP_LOCAL" , cxDesc , NIL},;
				//				{ "CP_OP" , cxProd , NIL};
				//				}

				if nQUanSol < 0 // la cantidad solicitada tiene ser menor a 0 porque signfica que falta Nahim 16/03/2020
//					aCabecalho := { ;
//					{ "CP_NUM" , cNumero, NIL},;
//					{"CP_SOLICIT"	, cUserName						, Nil},;
//					{ "CP_EMISSAO" ,dFechaSA , NIL},;
//					}
					aCabecalho := {{"CP_NUM",cNumero, NIL},{"CP_SOLICIT", cUserName, Nil},{ "CP_EMISSAO" ,dFechaSA,NIL}}

					aLinha 	:= {}
					nItem := 1
					While   nX <= Len(aTotCabs) .and. aTotCabs[nX,nPosQuant][2] < 0 .AND. cAlmcen == aTotCabs[nX,nPosAlc][2] .AND.  cxProd  == aTotCabs[nX,nPosOrPr][2] // producci๓n y almacen iguales

						aItens := {}

						cProducto	:= aTotCabs[nX,nPospr][2] // producto a solicitar
						nQuantSoli := ceiling( abs(aTotCabs[nX,nPosQuant][2])) // cCantidad Solcitdad
						//						nPosOrPrit := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACR_CODPRO" })
						//						nPosQuan := aScan(aTotCabs[nX],{|x| Upper(AllTrim(x[1])) == "ACR_LOTE" })

						//						dFechaSA		:= If(nPosOrPr 	> 0	,aTotCabs[nX,nPosOrPrit][2]	, ""	)
						//						nxQuant		:= If(nPosQuan 	> 0	,aTotCabs[nX,nPosQuan][2]	, 1	)
						Aadd(aItens,{"CP_ITEM" 		,StrZero(nItem,2),} )
						aAdd(aItens,{"CP_PRODUTO" 	,cProducto,})
						aAdd(aItens,{"CP_QUANT" 	,nQuantSoli ,})
						aAdd(aItens,{"CP_LOCAL" 	,cAlmcen,})
//						Aadd(aItens , 	{ {"CP_ITEM" 	, padl(nItem,2,"0")           				  , },;
//										  {"CP_PRODUTO"	, cCodProd									, },;
//										  {"CP_QUANT"	, nQuant				   					, },;
//										  {"CP_DATPRF"	, ddatabase+2								, },;
//										  {"CP_OBS"		, 'REQ.AGLUTINADA POR OP '+Dtoc(dDataBase)	, },;
//										  {"CP_CC"		, cCodCC									, },;
//										  {"CP_LOCAL"	, cLocal				  	  				, } } )
//							nItem++					
						nX++
						nItem++
						aAdd(aLinha ,aItens)

						If nX > Len(aTotCabs)
							Exit
						Endif

						//						nX--
					EndDo

					nX--
					// ALERT ARRAY
//					Aviso("Array CABECERA",u_zArrToTxt(aCabecalho, .T.),{"Ok"},,,,,.T.)
//					Aviso("Array LINHA",u_zArrToTxt(aLinha, .T.),{"Ok"},,,,,.T.)
					MSExecAuto({|X,Y,Z| MATA105(X,Y,Z)}, aCabecalho, aLinha, 3)
//					MATA105(aCabecalho,aLinha,3)//}, , aLinha, 3)

					If lMSErroAuto
						RollBackSx8()
						DisarmTransaction()
						MostraErro()
					Else
						AutoGrLog( " Solicitud Realizada: " + cNumero )
					EndIf
				endif // SำLO AVANZA SI tiene cantidad < 0
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
