#include "rwmake.ch"
#include "Topconn.ch"
#DEFINE DETAILBOTTOM 2600 //2050

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ORDPAGO   ³ Autor ³ ERICK ETCHEVERRY      ³Fecha ³14/07/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Layout de Orden de pago                          		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Layout de Orden de pago cushman 	                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³         Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³ Http://www.e-cuantica.com.ar                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION ORDPAGO(lesPDF, lJob)
	PRIVATE aCHLis := {} //Array con cheques para controlar desborde de cantidad de items - Ariel - 09/09/02
	PRIVATE aRets  := {} //Array con Retenciones
	PRIVATE aImp   := {}
	PRIVATE nCHAdLis := 0 // Cantidad de items que no son cheques para decidir si genera lista o no - Ariel - 09/09/02
	PRIVATE nCHValor1 := 0 // Importe de la lista de cheques en pesos.  - Ariel - 09/09/02
	PRIVATE nCHValor2 := 0 // Importe de la lista de cheques en dolares. - Ariel - 09/09/02
	PRIVATE lPrinted   := .f., ;
		nPesopal   := 0, ;
		cMon       := Space( 0 ), ;
		aExtenso1   := {}, ;
		aExtenso2   := {}, ;
		nCotiza    := 0, ;
		nLineSer   := 0, ;
		LPASOI := .F.,;
		LPASOS := .F.,;
		LPASOB := .F.,;
		LPASOG := .F.,;
		RETALIQ:= 0    //USEK
	PRIVATE nroOPAct := "" // Nahim guardo Nro ordPag.
	PRIVATE lPpago := .F. // Nahim guardo si es pago.

	/////////////////////////////////////////////////////////////////////////
	//GRA PDF
	// INICIO - Agregado para la generación de PDF
	Private lGenPDF := lesPDF
	Private lesJob	:= lJob
	Private cEspPDF	:= ""
	Private cSerPDF	:= ""
	Private cDocPDF	:= ""

	Private lTOGEN3P := Existblock("TOGEN3PRI")	// Genero el objeto para la generacion de PDF.
	Private lTOGEN3M := Existblock("TOGEN3MOV")	// Muevo el archivo PDF al directorio seleccionado.
	Private lTOGEN3B := Existblock("TOGEN3BAR")	// Muevo el archivo PDF al directorio seleccionado.

	Private lAuto	:= .F.
	Private nTotalSum := 0 // suma del total Nahim 24/05/2021
	Private cGlosaCab := "" // desc. Cabecera Nahim 24/05/2021

	IF ValType(lGenPDF) == "U"
		lGenPDF := .F.
	EndIF

	IF ValType(lesJob) == "U"
		lesJob := .F.
	EndIF

	// FIN - Agregado para la generación de PDF
	////////////////////////////////////////////////////////////////////////
	ValidPerg()

	///Pregunta si generara pdf
	//Si no imprime
	IF lesPDF

		SelectComp()
	Else
		if FUNNAME() == 'FINA085A' // IMPRESIÓN desde Orden de pago

			Pergunte( "ORDPAG", .F. )
			MV_PAR01 := aRegOrPag[1][1]
			MV_PAR02 := aRegOrPag[1][1]

			RptStatus( { || SelectComp() } )
//			EndIf
		ELSE
			If Pergunte( "ORDPAG", .T. )
				RptStatus( { || SelectComp() } )
			EndIf
		endif
	EndIF

RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION SelectComp()

	PRIVATE nLine    := 0, ;
		aPedBloq := Array( 0 )

	PRIVATE oPrn

	IF !lGenPDF	// NUEVO
		oPrn := TMSPrinter():New()
		oPrn:Setup()
		oPrn:SetPortrait()
		oPrn:SetPaperSize(9)
	EndIF

	IF lGenPDF
		MV_PAR01 := EK_ORDPAGO
		MV_PAR02 := EK_ORDPAGO
		ConOut("Genera PDF - MV_PAR01: " + cValToChar(MV_PAR01))
	Else
		ConOut("No Genera PDF - MV_PAR01: " + cValToChar(MV_PAR01))
	EndIF


	IF SELECT('SE2') > 0           //Verifica se o alias OC esta aberto
		SE2->(Dbgotop())       //Fecha o alias OC
		SE2->(DbCloseArea())       //Fecha o alias OC
	END
	DbSelectArea( "SA2" )
	DbSetOrder( 1 )
	DbSelectArea( "SE2" )
	DbSetOrder( 1 )
	DbSelectArea( "SA6" )
	DbSetOrder( 1 )
	DbSelectArea( "SED" )
	DbSetOrder( 1 )
	DbSelectArea( "SYA" )
	DbSetOrder( 1 )
	DbSelectArea( "SEK" )
	DbSetOrder( 1 )

	DbSelectArea( "SEK" )
	DbSeek( xFilial("SEK") + mv_par01, .t. )

	While !Eof() .and. EK_FILIAL+EK_ORDPAGO >= xFilial('SEK')+MV_PAR01 .AND. EK_FILIAL+EK_ORDPAGO <= xFilial('SEK')+MV_PAR02
		IF lGenPDF	// Genero el objeto para imprimir
			cEspPDF:= SEK->EK_FILIAL
			cSerPDF:= SEK->EK_ORDPAGO
			cDocPDF:= "OP"

			IF lTOGEN3P
				IF lesJob
					ConOut("TOGEN3PRI: Genero el objeto NF-ND - Es JOB")
				Else
					ConOut("TOGEN3PRI: Genero el objeto NF-ND - No es JOB")
				EndIF
				oPrn := ExecBlock("TOGEN3PRI",.F.,.F.,{ cEspPDF, cSerPDF, cDocPDF, lesJob })
			Else
				ConOut("No tiene compilado TOGEN3PRI")
			EndIF

		EndIF
		PrintComp()
		DbSelectArea( "SEK" )
		DbSkip()
	ENDDO

	IF !lGenPDF	// NUEVO
		oPrn:PreView()
	else
		oPrn:Print()
	EndIF

	IF lGenPDF
		IF !lesJob
			IF lTOGEN3M

				oPrn := ExecBlock("TOGEN3MOV",.F.,.F.,{ cEspPDF, cSerPDF, cDocPDF })
			EndIF
		EndIF
	EndIF

	IF lesJob
		FreeObj(oPrn)
		oPrn := Nil
	EndIF

	IF lGenPDF .AND. !lesJob
		// Borro los archivos PDF que pueden quedar.
		u_TOGEN3DEL()
	EndIF


	Ms_Flush()

RETURN

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintComp()

	PRIVATE cProvincia := Space( 0 ), ;
		cProvCMS  := "", ;
		cSitIVA   := "", ;
		aDriver   := ReadDriver(), ;
		nTotVal1  := 0, ;
		nTotVal2  := 0, ;
		nLine     := 0, ;
		nImpComp  := 0, ;
		nSalComp1 := 0, ;
		nSalComp2 := 0, ;
		nPagoAnt1 := 0, ;
		nPagoAnt2 := 0, ;
		cMoneda   := Space( 0 )

	IF !lGenPDF
		PRIVATE oFont    := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. ), ;
			oFont3   := TFont():New( "Arial"            ,, 12,, .t.,,,,    , .f. ), ;
			oFont5   := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. ), ;
			oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
			oFont8b  := TFont():New( "Arial"            ,,  8,, .t.,,,, .t., .f. ), ;
			oFont8s  := TFont():New( "Courier New"      ,,  8,, .f.,,,,    , .f. ), ;   //SERGIO -> PARA IMPRIMIR CORRECTAMENTE LAS COLUMNAS
		oFont12b := TFont():New( "Times New Roman"  ,, 12,, .t.,,,,    , .f. ), ;
			oFont12  := TFont():New( "Times New Roman"  ,, 12,, .f.,,,,    , .f. ), ;
			oFont14b := TFont():New( "Times New Roman"  ,, 14,, .t.,,,,    , .f. ), ;
			oFont14  := TFont():New( "Times New Roman"  ,, 14,, .f.,,,,    , .f. ), ;
			oFont20  := TFont():New( "Times New Roman"  ,, 20,, .t.,,,,    , .f. ), ;
			oFont18b := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .f. ), ;
			oFont18  := TFont():New( "Times New Roman"  ,, 18,, .f.,,,,    , .f. ), ;
			oFont18i := TFont():New( "Times New Roman"  ,, 18,, .f.,,,, .t., .f. ), ;
			oFont11  := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .t. ), ;
			oFont6   := TFont():New( "HAETTENSCHWEILLER",, 10,, .t.,,,,    , .f. ), ;
			oFont30  := TFont():New( "Bauhaus Lt Bt"    ,, 10,, .t.,,,,    , .f. ), ;
			oFont31  := TFont():New( "Arial"            ,,  8,, .t.,,,,    , .f. )
	else//pdf
		PRIVATE oFont    := TFont():New( "Arial"            ,, 13,, .f.,,,,    , .f. ), ;
			oFont3   := TFont():New( "Arial"            ,, 15,, .t.,,,,    , .f. ), ;
			oFont5   := TFont():New( "Arial"            ,, 13,, .t.,,,,    , .f. ), ;
			oFont8   := TFont():New( "Arial"            ,,  11,, .f.,,,,    , .f. ), ;
			oFont8b  := TFont():New( "Arial"            ,,  11,, .t.,,,, .t., .f. ), ;
			oFont8s  := TFont():New( "Courier New"      ,,  11,, .f.,,,,    , .f. ), ;   //SERGIO -> PARA IMPRIMIR CORRECTAMENTE LAS COLUMNAS
		oFont12b := TFont():New( "Times New Roman"  ,, 15,, .t.,,,,    , .f. ), ;
			oFont12  := TFont():New( "Times New Roman"  ,, 15,, .f.,,,,    , .f. ), ;
			oFont14b := TFont():New( "Times New Roman"  ,, 17,, .t.,,,,    , .f. ), ;
			oFont14  := TFont():New( "Times New Roman"  ,, 17,, .f.,,,,    , .f. ), ;
			oFont20  := TFont():New( "Times New Roman"  ,, 23,, .t.,,,,    , .f. ), ;
			oFont18b := TFont():New( "Times New Roman"  ,, 21,, .t.,,,,    , .f. ), ;
			oFont18  := TFont():New( "Times New Roman"  ,, 21,, .f.,,,,    , .f. ), ;
			oFont18i := TFont():New( "Times New Roman"  ,, 21,, .f.,,,, .t., .f. ), ;
			oFont11  := TFont():New( "Times New Roman"  ,, 21,, .t.,,,,    , .t. ), ;
			oFont6   := TFont():New( "HAETTENSCHWEILLER",, 13,, .t.,,,,    , .f. ), ;
			oFont30  := TFont():New( "Bauhaus Lt Bt"    ,, 13,, .t.,,,,    , .f. ), ;
			oFont31  := TFont():New( "Arial"            ,,  11,, .t.,,,,    , .f. )

	endif

	DbSelectArea( "SA2" )
	DbSeek( xFilial( "SA2" ) + SEK->EK_FORNECE + SEK->EK_LOJA )

	DbSelectArea( "SYA" )
	DbSeek( xFilial( "SYA" ) + SA2->A2_PAIS )

	DbSelectArea( "SEK" )

	IF !EMPTY( Tabela( "12", SA2->A2_EST )  )
		cProvincia := Tabela( "12", SA2->A2_EST )
	ELSE
		MsgStop( "En el Proveedor " + SA2->A2_COD + " " + SA2->A2_LOJA +",  se encuentra vacio el campo CIUDAD", "Verifique" )
	ENDIF

	cProvCMS   := "SANTA CRUZ"

	IF !EMPTY( SA2->A2_TIPO )

	ELSE
		MsgStop( "En el Proveedor " + SA2->A2_COD + " " + SA2->A2_LOJA +",  se encuentra vacio el campo TIPO", "Verifique" )
	ENDIF

	aCHLis := {} //Array con cheques para controlar desborde de cantidad de items - Ariel - 09/09/02
	aRets  := {}
	aImp   := {}
	nCHAdLis := 0 // Cantidad de items que no son cheques para decidir si genera lista o no - Ariel - 09/09/02
	nCHValor1 := 0 // Importe de la lista de cheques en pesos.  - Ariel - 09/09/02
	nCHValor2 := 0 // Importe de la lista de cheques en dolares. - Ariel - 09/09/02

	PrintHead("R")
	PrintItem()
	PrintFoot()

RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintHead(cPagTipo)
	Local aEmp 			:= U_SM0Cab(cEmpAnt,cFilAnt)
	Local _nX


	IF !lPrinted
		lPrinted := .t.
	ELSE
		oPrn:StartPage()
	ENDIF
	IF lGenPDF
		oPrn:StartPage()
	EndIF

	nLine := 50

	//oPrn:Say( nLine, 0100, " ", oFont, 100 )

	IF .T.

		nLine += 10

		//cFLogo := GetSrvProfString("Startpath","") + "Logo.png"
		//cFLogo := GetSrvProfString("Startpath","") + "Logo.png"

		//oPrn:SayBitmap( nLine+50, 0100, AllTrim( cFLogo ) , 500, 400 )

		oPrn:SayBitmap(0040,0090,aEmp[01][02],0500,0200 )

		nLine += 10

		nLine += 100
		nLine -= 100


		nLine += 10


	ELSE
		oPrn:Box( nLine, 0050, nLine + 470, 2300 )
		nLine += 10
		oPrn:Box( nLine, 1100, nLine + 120, 1250 )
		oPrn:Say( nLine + 130, 0100, AllTrim( SM0->M0_NOMECOM ), oFont31, 100 )
		oPrn:Say( nLine + 170, 0100, AllTrim( SM0->M0_ENDCOB ) + " - " + AllTrim( SM0->M0_CIDCOB ), oFont31, 100 )
		oPrn:Say( nLine + 210, 0100, "(" +  AllTrim( SM0->M0_CEPCOB ) + ") " + cProvCMS + " - Tel.: " + SM0->M0_TEL, oFont31, 100 )
		oPrn:Say( nLine + 250, 0100, "C.U.I.T. " + AllTrim( SM0->M0_CGC ) + " - Responsable Inscripto" , oFont31, 100 )
	ENDIF
	// verifica orden de pago completamente
	if isCompPago()
		oPrn:Say( nLine, 1050, "ORDEN DE PAGO", oFont14b, 100 )
	else
		oPrn:Say( nLine, 800, "COMPROBANTE DE COMPENSACIÓN", oFont14b, 100 )
	endif
	nLine += 140

	oPrn:Say( nLine, 1650, "COMPROBANTE :", oFont8B, 100 )
	oPrn:Say( nLine, 2000,  SEK->EK_ORDPAGO, oFont12b, 100 )
	nLine += 80

	oPrn:Say( nLine, 1050, "MONEDA :", oFont8B, 100 )
	oPrn:Say( nLine, 1200, iif(SEK->EK_MOEDA == "1","BOLIVIANOS","DOLARES") , oFont30, 100 )

	oPrn:Say( nLine, 1650, "FECHA :", oFont8B, 100 )
	oPrn:Say( nLine, 2000, DToC( SEK->EK_DTDIGIT ), oFont30, 100 )
	nLine += 100
	if !empty(SEK->EK_NODIA)
		oPrn:Say( nLine, 1650, "CTB No. :", oFont8B, 100 )
		oPrn:Say( nLine, 2000, SEK->EK_NODIA, oFont30, 100 )
	endif
	nLine += 100

	oPrn:Say( nLine, 1650, "T.C :", oFont8B, 100 )
	oPrn:Say( nLine, 2000, CVALTOCHAR( SEK->EK_TXMOE02 ), oFont30, 100 )


	IF SEK->EK_CANCEL
		oPrn:Say( nLine, 1600, "*** A N U L A D O *** ", oFont14b, 100 )
	ENDIF

	// If cPagTipo != 'L'
	oPrn:Box( nLine + 120, 0050, nLine + 400, 2300 )
	// ENDIF
	nLine += 170

	If .t.// cPagTipo != 'L'

		oPrn:Say( nLine, 0100, "Beneficiario:   ", oFont, 100 )

		oPrn:Say( nLine, 0330, AllTrim( SA2->A2_NOME ) + " (" + AllTrim( SA2->A2_COD ) + ")", oFont, 100 )

		cxmod := iif(SEK->EK_MOEDA == "1","BOLIVIANOS","DOLARES")
		// Nahim Monto
		if nTotalSum == 0
			nTotalSum = SEK->EK_VALOR
		endif

		// nLine += 50
		// oPrn:Say( nLine, 0330, "LA SUMA DE: " + CVALTOCHAR(nTotalSum) + "   " + ALLTRIM(Extenso(nTotalSum,.F.,1))+" "+cxmod, oFont, 100 )
		// oPrn:Say( nLine, 0330, "LA SUMA DE: " + CVALTOCHAR(SEK->EK_VALOR) + "   " + ALLTRIM(Extenso(SEK->EK_VALOR,.F.,1))+" "+cxmod, oFont, 100 )
		nLine += 50

		cHist := SEK->EK_UGLOSA  //GetAdvFVal("SEK","EK_UGLOSA",xFilial("SEK")+SEK->EK_ORDPAGO+"",1,"")
		// MemoLine(cHist, 6, 1, 2, .f.)
		if empty(cHist)
			cHist :=  GetAdvFVal("SEK","EK_UGLOSA",xFilial("SEK")+SEK->EK_ORDPAGO+"PA",1,"")
		endif
		if !empty(cHist)
			cHist :=  "Glosa: " + cHist
			cGlosaCab := cHist
		endif
		_nLinhas := MlCount(cGlosaCab,90,,.T.)
		For _nX := 1 To _nLinhas
			If(!Empty(memoline(cGlosaCab,90,_nX,,.T.)))
				// if _nX ==
				oPrn:Say(nLine,0100,memoline(cGlosaCab,90,_nX,,.T.), oFont, 100 )
				nLine+=50
			ENDIF
			//	++li
		Next _nX
		// _nLinhas := MlCount(cHist,90,,.T.)
		// For _nX := 1 To _nLinhas
		// 	If(!Empty(memoline(cHist,90,_nX,,.T.)))
		// 		// if _nX ==
		// 		oPrn:Say(nLine,0100,memoline(cHist,90,_nX,,.T.), oFont, 100 )
		// 		nLine+=50
		// 	ENDIF
		// 	//	++li
		// Next _nX

		//EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ

		// oPrn:Say( nLine, 0100, "GLOSA: " + Alltrim( cHist ) , oFont, 100 )

		nLine += 50
		IF AllTrim(SEK->EK_TIPO)='CH'
			oPrn:Say( nLine, 0100, "CH Girado a:   ", oFont, 100 )
			oPrn:Say( nLine, 0330, AllTrim( SEK->EK_UNOMPCH ), oFont, 100 )
		ENDIF
		nLine += 50

		oPrn:Box( nLine , 0050, nLine + 1, 2300 )

		nPesopal := nLine
		nLine += 20
		nLineSer := nLine
		nLine += 50
	EndIf

	If cPagTipo != "L"
		//oPrn:Say( nLine, 0055, "Aplicado al pago de los comprobantes", oFont5, 100 )
		oPrn:Say( nLine, 0055, "Aplicado al pago de los titulos", oFont5, 100 )
	EndIf

	nLine += 50

	// If cPagTipo != "L"

	nLine += 5

	//oPrn:Say( nLine, 0100, "Comprobante", oFont8b, 100 )
	oPrn:Say( nLine, 0100, "Titulos", oFont8b, 100 )
	oPrn:Say( nLine, 0455, "Emision", oFont8b, 100 )
	oPrn:Say( nLine, 1130, "Importe Orig.", oFont8b, 100 )
	oPrn:Say( nLine, 2055, "Importe Aplic.", oFont8b, 100 )


	nLine += 55//nLine += 100

	// EndIf

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintItem( cPagTipo )

	Local nBaseImpo := 0
	LOCAL Z
	LOCAL NS

	LOCAL cNroRec    := SEK->EK_FILIAL + SEK->EK_ORDPAGO, ;
		nRecSEK      := RecNo(), ;
		nLeftPanel    := nLine, ;
		lHistSer         := .f., ;
		nFactu           := 0, ;
		cHistoryOp   := Space(0) //Sergio
	cDescon  := Space(0)
	ntipoc := 1
	LPASOI := .F. //fas
	LPASOS := .F. //fas
	LPASOB := .F. //fas
	LPASOG := .F. //fas

	WHILE ( SEK->EK_FILIAL + SEK->EK_ORDPAGO ) == cNroRec

		IF SEK->EK_TIPODOC == "TB"
			If nLine >= DETAILBOTTOM
				oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
				oPrn:EndPage()
				PrintHead("L")
			EndIf

			SE2->( DbSeek( xFilial("SE2") + SEK->EK_PREFIXO + SEK->EK_NUM + SEK->EK_PARCELA + SEK->EK_TIPO + SEK->EK_FORNECE + SEK->EK_LOJA, .F. ) )
			//sólo belen porque es 18

			IF alltrim(SEK->EK_TIPO) == "NF" .and. SEK->EK_MOEDA <> "1" .AND. NTIPOC == 1
				ntipoc := (SEK->EK_VLMOED1/SEK->EK_VALOR)
			Endif

			//Sergio
			IF SE2->E2_TIPO $ "NF -FT " .AND. ALLTRIM( SE2->E2_ORIGEM ) == "FINA050"
				IF nFactu == 0 .AND. !EMPTY( SE2->E2_HIST )
					cHistoryOp := UPPER( ALLTRIM( SE2->E2_HIST ) )
					nFactu     := nFactu + 1
					lHistSer   := .t.
				ELSE
					lHistSer := .f.
				ENDIF
			ENDIF
			//Sergio
//			oPrn:Say( nLine, 0100, Left(SEK->EK_NUM, 4 ) + "-" + Right( SEK->EK_NUM, 8 ), oFont8, 100 ) Nahim Imprime el nro
			oPrn:Say( nLine, 0100, SEK->EK_NUM, oFont8, 100 )
			oPrn:Say( nLine, 0455, DToC( SE2->E2_EMISSAO ), oFont8, 100 )
			oPrn:Say( nLine, 1000, PADL( Iif(SE2->E2_MOEDA == 1," Bs. "," U$S ") + AllTrim( TransForm( (SE2->E2_VALOR*TraeSigno(SE2->E2_TIPO)),PesqPict("SEK","EK_VALOR"))),20," "),oFont8s,100)
			oPrn:Say( nLine, 1950, PADL( Iif(SE2->E2_MOEDA == 1," Bs. "," U$S ") + AllTrim( TransForm( (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO)),PesqPict("SEK","EK_VALOR"))),20," "),oFont8s,100)

			nLine += 50

			nImpComp := nImpComp + SE2->E2_VALOR

			If SE2->E2_MOEDA == 2
				nSalComp2 := nSalComp2 + (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO))
			Else
				nSalComp1 := nSalComp1 + (SEK->EK_VALOR*TraeSigno(SE2->E2_TIPO))
			EndIf

		ENDIF

		DbSkip()

	ENDDO

	DbGoTo( nRecSEK )

	//Seryo
	If nLine >= DETAILBOTTOM - 100
		oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
		oPrn:EndPage()
		PrintHead("L")
	EndIf
	nLine := nline//nLeftPanel
	nLine += 50
	oPrn:Say( nLine, 0055, "Valores Entregados", oFont5, 100 )
	nLine += 50
	oPrn:Say( nLine, 0100, "Banco", oFont8b, 100 )
	oPrn:Say( nLine, 0455, "Cuenta", oFont8b, 100 )
	//oPrn:Say( nLine, 1130, "Numero", oFont8b, 100 )
	oPrn:Say( nLine, 1130, "Comprobante", oFont8b, 100 )
	oPrn:Say( nLine, 2055, "Importe", oFont8b, 100 )
	nLine += 50

	WHILE ( SEK->EK_FILIAL + SEK->EK_ORDPAGO ) == cNroRec

		If nLine >= DETAILBOTTOM - 100
			oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
			oPrn:EndPage()
			PrintHead("L")
		EndIf

		IF SEK->EK_TIPODOC $ "CP-CT-RG-RI-RB"

			IF Val( SEK->EK_MOEDA ) = 1
				cMoneda := "Bs."
			ELSEIF Val( SEK->EK_MOEDA ) = 2
				cMoneda := "U$S"
			ENDIF

			IF VAL( SEK->EK_MOEDA ) <> 1 .AND. NTIPOC == 1
				ntipoc := (SEK->EK_VLMOED1/SEK->EK_VALOR)
			Endif

			SA6->( dbSeek( xFilial( "SA6" ) + SEK->EK_BANCO + SEK->EK_AGENCIA + SEK->EK_CONTA, .F. ) )
			cDescBco := SA6->A6_NOME
			cDescBco := cDescBco + Space( 20 - Len( cDescBco ) )
			cDescBco := Left( cDescBco, 20 )

			IF SEK->EK_TIPODOC == "CP" .or. SEK->EK_TIPODOC == "CT"

				If SEK->EK_TIPODOC == "CP"
					dbSelectArea( "SEF" )
					dbSetOrder( 3 )
					dbSeek( xFilial( "SEF" ) + SEK->EK_PREFIXO + SEK->EK_NUM + SEK->EK_PARCELA, .F. )

					dbSelectArea( "SEK" )
				EndIf

				If SEF->( Found() )
					AADD( aCHLis, { cDescBco, DToC( SEK->EK_VENCTO ), SEK->EK_CONTA, SEK->EK_NUM, cMoneda + " " + AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ) } )
				Else
					AADD( aCHLis, { cDescBco, DToC( SEK->EK_VENCTO ), SEK->EK_CONTA, SEK->EK_NUM, cMoneda + " " + AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ) } )
				EndIf

				If Val( SEK->EK_MOEDA ) = 2
					nCHValor2 += SEK->EK_VALOR
				Else
					nCHValor1 += SEK->EK_VALOR
				EndIf

			ELSEIF SEK->EK_TIPODOC == "EF"

				oPrn:Say( nLine, 0100, "E F E C T I V O", oFont8, 100 )
				oPrn:Say( nLine, 1985, PADL( cMoneda + " " + AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )

				nLine += 50
				nCHAdLis += 1

			ELSEIF SEK->EK_TIPODOC == "TF"

				oPrn:Say( nLine, 0100, "T R A N S F E R E N C I A", oFont8, 100 )
				oPrn:Say( nLine, 1985, PADL( cMoneda + " " + AllTrim( TransForm( SEK->EK_VALOR, PesqPict( "SEK", "EK_VALOR" ) ) ), 15, " " ), oFont8s, 100 )

				nLine += 50
				nCHAdLis += 1

			ELSEIF SEK->EK_TIPODOC == "RG"  .and. SEK->EK_TIPO = "IV-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0) .AND. !LPASOI   // Se agregó   "SEK->EK_VALOR< 0" para las retenciones de NCP.
				BuscaRet(SEK->EK_ORDPAGO,'I')
			ELSEIF SEK->EK_TIPODOC == "RG" .and. SEK->EK_TIPO = "GN-" .and.  (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0) .AND. !LPASOG  // Se agregó   "SEK->EK_VALOR< 0" para las retenciones de NCP.
				BuscaRet(SEK->EK_ORDPAGO,'G')
			ELSEIF SEK->EK_TIPODOC == "RG" .and. SEK->EK_TIPO = "IB-" .and. (SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0) .AND. !LPASOB   // Se agregó   "SEK->EK_VALOR< 0" para las retenciones de NCP.
				BuscaRet(SEK->EK_ORDPAGO,'B')
			ELSEIF SEK->EK_TIPODOC == "RG"  .and. SEK->EK_TIPO = "SU-" .and.(SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0) .AND. !LPASOS   // Se agregó   "SEK->EK_VALOR< 0" para las retenciones de NCP.
				BuscaRet(SEK->EK_ORDPAGO,'S')
			ELSEIF SEK->EK_TIPODOC == "RG"  .and. SEK->EK_TIPO = "SL-" .and.(SEK->EK_VALOR > 0 .or. SEK->EK_VALOR< 0) .AND. !LPASOS   // Se agregó   "SEK->EK_VALOR< 0" para las retenciones de NCP.
				BuscaRet(SEK->EK_ORDPAGO,'L')
			ENDIF

			If Val( SEK->EK_MOEDA ) = 2
				nTotVal2 := nTotVal2 + SEK->EK_VALOR
			Else
				nTotVal1 := nTotVal1 + SEK->EK_VALOR
			EndIf

		ELSEIF SEK->EK_TIPODOC == "PA"

			If Val( SEK->EK_MOEDA ) = 2
				nPagoAnt2 += SEK->EK_VALOR
			Else
				nPagoAnt1 += SEK->EK_VALOR
			EndIf

		ENDIF

		DbSkip()

	ENDDO

	DbSkip( -1 )

	For z := 1 To Len( aCHLis )
		If nLine >= DETAILBOTTOM - 100
			oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
			oPrn:EndPage()
			PrintHead("L")
		EndIf

		oPrn:Say( nLine, 0100, aCHLis[z][1], oFont8, 100 )

		oPrn:Say( nLine, 0455, aCHLis[z][3], oFont8, 100 )
		oPrn:Say( nLine, 1130, aCHLis[z][4], oFont8, 100 )
		oPrn:Say( nLine, 1950, PADL( aCHLis[z][5], 20, " " ), oFont8s, 100 )
		nLine += 50
	Next z

	If nLine >= DETAILBOTTOM - 100
		oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
		oPrn:EndPage()
		PrintHead("L")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄf
	//³Modifico : Mariano C.  fecha : 06-02-07                           ³
	//³desc : antes de colocar titulo de retenciones verifica que exista ³
	//³al menos una para imprimir.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄf

	if Len( aRets ) > 0
		nLine += 50
		oPrn:Say( nLine, 0055, "Retenciones", oFont5, 100 )
		nLine += 50
		oPrn:Say( nLine, 0100, "Tipo", oFont8b, 100 )
		oPrn:Say( nLine, 0700, "Nro Comprob.", oFont8b, 100 )
		oPrn:Say( nLine, 1130, "Base Imponible", oFont8b, 100 )
		oPrn:Say( nLine, 2055, "Importe", oFont8b, 100 )
		nLine += 50
	endif
	For nS := 1 To Len( aRets )
		If nLine >= DETAILBOTTOM - 100
			oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
			oPrn:EndPage()
			PrintHead("L")
		EndIf
		oPrn:Say( nLine, 0100, aRets[nS][1]				, oFont8, 100 )          // RETENCION
		oPrn:Say( nLine, 0700, aRets[nS][2]				, oFont8, 100 )          // NRO COMPROB.
		oPrn:Say( nLine, 1050, aRets[nS][3]				, oFont8s, 100 )         // BASE IMPONIBLE
		oPrn:Say( nLine, 1950, cmoneda+" " +aRets[nS][4], oFont8s, 100 )         // RETENCION
		nLine += 50
	Next nS

	If nLine > DETAILBOTTOM - 100
		oPrn:Say( nLine + 60, 0100, "Continua en la siguiente hoja", oFont5, 100 )
		oPrn:EndPage()
		PrintHead("L")
	EndIf

	nLine := DETAILBOTTOM - 100

	oPrn:Say( nLine, 0100, Extenso(nTotVal1 + ( nTotVal2 * nTipoc ),.F.,1,'SON BOLIVIANOS','Esp',.T.), oFont8, 100 )

	nLine := DETAILBOTTOM

	oPrn:Box( nLine, 0050, nLine + 100, 1125 )
	oPrn:Box( nLine, 0455, nLine + 100, 0790 ) //PESOS
	oPrn:Box( nLine, 0790, nLine + 100, 1125 ) //DOLARES

	nLine += 30

	oPrn:Say( nLine, 0080, "COMPROB. APLICADOS", oFont8b, 100 )
	oPrn:Say( nLine, 0458, " Bs. " + PADR( AllTrim( TransForm( nSalComp1, PesqPict( "SEK", "EK_VALOR" ) ) ), 18, " " ), oFont8s, 100 )
	oPrn:Say( nLine, 0793, " U$S " + PADR( AllTrim( TransForm( nSalComp2, PesqPict( "SEK", "EK_VALOR" ) ) ), 16, " " ), oFont8s, 100 )

	nLine += 50

	oPrn:Box( nLine, 0050, nLine + 100, 1125 )
	oPrn:Box( nLine, 0455, nLine + 100, 0790 ) //PESOS
	oPrn:Box( nLine, 0790, nLine + 100, 1125 ) //DOLARES
	oPrn:Box( nLine, 1125, nLine + 100, 2300 )
	oPrn:Box( nLine, 1590, nLine + 100, 1950 ) //PESOS
	oPrn:Box( nLine, 1950, nLine + 100, 2300 ) //DOLARES
	nLine += 30

	oPrn:Say( nLine, 0080, "PAGOS ANTICIPADOS", oFont8b, 100 )
	oPrn:Say( nLine, 0458, " Bs. " + PADR( AllTrim( TransForm( nPagoAnt1, PesqPict( "SEK", "EK_VALOR" ) ) ), 18, " " ), oFont8s, 100 )
	oPrn:Say( nLine, 0793, " U$S " + PADR( AllTrim( TransForm( nPagoAnt2, PesqPict( "SEK", "EK_VALOR" ) ) ), 16, " " ), oFont8s, 100 )
	oPrn:Say( nLine, 1146, "TOTAL ORDEN DE PAGO", oFont5, 100 )


	oPrn:Say( nLine, 1593, " Bs. " + PADR( AllTrim( TransForm( nTotVal1, PesqPict( "SEK", "EK_VALOR" ) ) ), 20, " " ), oFont5, 100 )


	oPrn:Say( nLine, 1953, " U$S " + PADR( AllTrim( TransForm( nTotVal2, PesqPict( "SEK", "EK_VALOR" ) ) ), 17, " " ), oFont5, 100 )


	nLine += 50

	oPrn:Box( nLine, 0050, nLine + 100, 1125 )
	oPrn:Box( nLine, 0455, nLine + 100, 0790 ) //PESOS
	oPrn:Box( nLine, 0790, nLine + 100, 2300 ) //DOLARES

	nLine += 30
	oPrn:Say( nLine, 0080, "TIPO DE CAMBIO", oFont8b, 100 )
	oPrn:Say( nLine, 0550,  PADR( AllTrim( TransForm( SEK->EK_TXMOE02, PesqPict( "SEK", "EK_VALOR" ) ) ), 18, " " ), oFont8s, 100 )

	nLine += 050
	oPrn:Box( nLine, 0050, nLine + 340, 1125 )
	oPrn:Box( nLine, 1125, nLine + 340, 2300 )
	nLine += 30
	oPrn:Say( nLine, 0400, "RECIBI CONFORME", oFont5, 100 )

	nLine += 200

	oPrn:Say( nLine, 0150, Replicate( "-", 25 ), oFont8b, 100 )
	oPrn:Say( nLine, 0500, Replicate( "-", 55 ), oFont8b, 100 )

	oPrn:Say( nLine, 1150, Replicate( "-", 30 ), oFont8b, 100 )
	oPrn:Say( nLine, 1600, Replicate( "-", 30 ), oFont8b, 100 )
	oPrn:Say( nLine, 2000, Replicate( "-", 30 ), oFont8b, 100 )

	nLine += 40
	oPrn:Say( nLine, 0150, PadC( "FIRMA", 25, " " ), oFont8b, 100 )
	oPrn:Say( nLine, 0560, PadC( "ACLARACION", 25, " " ), oFont8b, 100 )

	oPrn:Say( nLine, 1180, "ELABORADO"		, oFont8b, 100 )
	oPrn:Say( nLine, 1630, "REVISADO"		, oFont8b, 100 )
	oPrn:Say( nLine, 2050, "AUTORIZADO"		, oFont8b, 100 )

	nLine += 100

	oPrn:Say( nLine, 2050, cusername , oFont8b, 100 )


	nLine += 200

	IF cMoneda == "$"
		cMon := "A"
	ELSEIF cMoneda == "U$S"
		cMon := "D"
	ENDIF

RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintFoot()

	oPrn:EndPage()


RETURN NIL

/*-------------------------------------------------------------------------------------------------------*/
Static Function ValidPerg()

	LOCAL aVldSX1  := GetArea()
	LOCAL aCposSX1 := {}
	LOCAL aPergs   := {}
	LOCAL cPerg    := PADR("ORDPAG",10)
	local nx
	local nj

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
		"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
		"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
		"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
		"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
		"X1_F3","X1_GRPSXG"}

	aAdd(aPergs,{'Desde Ord.Pag.','Desde Ord.Pag.','Desde Ord.Pag.','mv_ch1','C', 6, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SEKOP',''})
	aAdd(aPergs,{'Hasta Ord.Pag.','Hasta Ord.Pag.','Hasta Ord.Pag.','mv_ch2','C', 6, 0, 1, 'G', '', 'mv_par02','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SEKOP',''})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		If !(dbSeek(cPerg+StrZero(nx,2)))
			RecLock("SX1",.T.)
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with StrZero(nx,2)
			for nj:=1 to Len(aCposSX1)
				FieldPut(FieldPos(ALLTRIM(aCposSX1[nJ])),aPergs[nx][nj])
			next nj
			MsUnlock()
		Endif
	Next

	RestArea( aVldSX1 )

Return
//----------------------------------------------------------------------------
// Funcion para traer el signo de los documentos Cancelados

Static Function TraeSigno( cTipo )
	Local aArea := GetArea(),;
		nRet  := 1

	DbSelectAreA( 'SES' )
	DbSetOrder(1)
	If DbSeek( xFilial( ) + cTipo )
		If ES_SINAL == '-'
			nRet  := -1
		EndIf
	EndIf

	RestArea( aArea )

Return( nRet )

Static Function BUSCARET( ORDPAGO, TIPO )

	Local aArea__ := GetArea()
	Local aAreaSFE__ := SFE->( GetArea() )
	Local cQuery
	Local cQueryali //usek
	Local cIMP

	If TIPO == 'I'
		cIMP := 'I.V.A.'
		LPASOI := .T.
	ElseIf TIPO == 'B'
		cIMP := 'INGRESOS BRUTOS'
		LPASOB := .T.
	ElseIf TIPO == 'G'
		cIMP := 'GANANCIAS'
		LPASOG := .T.
	ElseIf TIPO == 'S'
		cIMP := 'S.U.S.S.'
		LPASOS := .T.
	ElseIf TIPO == 'L'
		cIMP := 'SERVICIOS LIMPIEZA '
		LPASOS := .T.
	EndIf

	cQuery := "SELECT FE_NROCERT AS NRO, FE_RETENC AS RETENC, FE_VALBASE AS VALBASE, FE_ALIQ AS ALIQ FROM " + RETSQLNAME('SFE') + " "
	cQuery +=" WHERE FE_FILIAL= '" + xFilial('SFE') + "' AND FE_ORDPAGO= '" + ORDPAGO + "' AND FE_TIPO= '" + TIPO + "' "
	cQuery +=" AND D_E_L_E_T_ <> '*' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMSFE',.T.,.T.)

	Dbselectarea("TMSFE")
	Dbgotop()
	While !EoF()

		AADD( aRets, { "RETENCION "+ cIMP,NRO,	PADL(AllTrim( TransForm( VALBASE,	PesqPict( "SFE", "FE_VALBASE" ) ) )	,15,""),;
			PADL(AllTrim( TransForm( RETENC, 	PesqPict( "SFE", "FE_RETENC" ) ) )	,15,"")} )

		DbSkip()

	EndDo
	DbClosearea()
	RestArea( aAreaSFE__ )
	RestArea( aArea__ )
RETURN()


/*
Nahim 29/03/2021
Pregunta si es pago o compensacion
true  - Es pago
false - Es Compensación
*/
static function isCompPago()
	if nroOPAct == SEK->EK_ORDPAGO
		return lPpago
	else
		nroOPAct := SEK->EK_ORDPAGO
	ENDIF

	aPagSek := GetArea()
	lPago := .F. // pago
	nOrdPago :=  SEK->EK_ORDPAGO// Orden de pago
	While SEK->(!Eof()) .AND. SEK->(EK_FILIAL+EK_ORDPAGO) == xFilial("SEK")+nOrdPago
		// alert(SEL->EL_TIPODOC)
		// alert(SEL->EL_NUMERO)
		// FWSFUsrGrps(__cUserID)
		// if (ALLTRIM(SEK->EK_TIPO) $ 'NCC|PA' .AND. SEK->EK_TIPODOC == 'TB') //COMPENSACIÓN y el usuario no está en grupo compensador
		// 	// alert("Usuario no pertenece al grupo de compensación de pago. Favor contactar al área de TI.")
		// 	lPago := .F.
		// endif
		if (SEK->EK_TIPODOC == 'CP' .AND. ALLTRIM(SEK->EK_TIPO) $ 'EF|TF|CH') //NO ES COMPENSACION (es pago) y el usuario no está en grupo Pagos
			lPago := .T.
			lPpago := .T.
		endif
		SEK->(DbSkip())
	EndDo
	RestArea(aPagSek)
return lPago

