#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Colunas
#Define COL_SERIE  0015
#Define COL_NUMERO  0040
#Define COL_TDA  0130
#Define COL_VENCTO  0170
#Define COL_VALOR	0220
#Define COL_MONEDA	0270
#Define COL_IMPORTE 0340
#Define COL_BANCO 0310
#Define COL_AGENCIA 0350
#Define COL_COBRADO 0410
#Define COL_SALDO 0480

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RECIBOCOBR  ºAutor  ³ERICK ETCHEVERRY º Date 19/05/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Reporte de cobranzas, anticipos y compensaciones            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                          	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RECIBOCOBR()
	LOCAL cString		:= "SD3"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Recibos de cobranza"
	LOCAL cDesc1	    := "Relatorio Recibos de cobranza"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	Local cObse := ""
	Private nValMer := 0
	Private nValGas := 0
	Private nTxMoe := 0
	Private nValDUA := 0
	PRIVATE nomeProg 	:= "RECIBOCOBR"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontDetn  := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,016,016,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	PRIVATE cPerg   := "COBRECC"   // elija el Nombre de la pregunta

	CriaSX1(cPerg)

	If funname() == 'FINA087A'
		Pergunte(cPerg,.F.)
	Else
		Pergunte(cPerg,.T.)
	Endif

	Processa({ |lEnd| MOVD3CONF("Impresion de cobros")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'movinterno'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zCobrecc_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)
	oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local nTotal := 0
	Local lRetCF := .f.
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 745
	Private nColIni   := 010
	Private nColFin   := 570
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private nSubBruto := 0
	Private nSubIva := 0
	Private nSubNeto := 0
	Private nSubBrutoDesp := 0
	Private nSubIvaDesp := 0
	Private nSubNetoDesp := 0
	Private nSubBrutoIns := 0
	Private nSubIvaIns := 0
	Private nSubNetoIns := 0
	Private nSubBrutoIns := 0
	Private nSubIvaIns := 0
	Private nSubNetoIns := 0
	Private nSubBrutoFle := 0
	Private nSubIvaFle := 0
	Private nSubNetoFle := 0
	Private nSubBrutoOtr := 0
	Private nSubIvaOtr := 0
	Private nSubNetoOtr := 0
	Private nTotBru := 0
	Private nTotIva := 0
	Private nTotNet := 0
	Private FECHADIA
	Private TCDOLAR
	Private TCUFV
	Private TCEURO
	Private SALDO
	Private TOTALE
	Private TOTALBS
	Private TASA
	Private NITCL
	Private NOMCL
	Private cUSERLGI	:= ""

	getCabec()

	if ! VW_DBA->(EoF())

		While ! VW_DBA->(EoF())

			If nLinAtu + nTamLin > nLinFin
				fImpRod()//
				fImpCab()
			else
				fImpCab()
			EndIf

			getTitulos(VW_DBA->EL_RECIBO,VW_DBA->EL_SERIE)
			//Tributo
			if ! VW_TITA->(EoF())

				oPrint:SayAlign(nLinAtu, COL_SERIE, iif(VW_TITA->EL_TIPO == 'RA',"TITULOS COMPENSADOS", "EN CONCEPTO DE PAGO POR LOS SIGUIENTES TITULOS"),     oFontDet, 0250, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
				oPrint:SayAlign(nLinAtu, COL_SERIE, "SERIE",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_NUMERO, "NUMERO" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_TDA, "TDA" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu,COL_VENCTO,  "VENCTO" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_VALOR, "VALOR" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_MONEDA, "MONEDA" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_IMPORTE, "IMPORTE $US" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_COBRADO, "VALOR COBRADO $US" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_SALDO, "SALDO $US" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinAtu += nTamLin
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)

				While ! VW_TITA->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					///DATOS A CARGAR
					if(VAL(VW_TITA->EL_MOEDA) == 1 )	// Si es Bs.
						nImpDolar:= (VW_TITA->VALOR / VW_TITA->EL_TXMOE02)	//Se convierte a Dolar
						nValCDol:= (VW_TITA->VALORCOB / VW_TITA->EL_TXMOE02)	//Se convierte a Dolar
						nSaldDol:= (VW_TITA->E1_SALDO / VW_TITA->EL_TXMOE02)	//Se convierte a Dolar
					else
						nImpDolar:= VW_TITA->VALOR
						nValCDol:= VW_TITA->VALORCOB
						nSaldDol:= VW_TITA->E1_SALDO
					endIf
					cFechaVto		:= 		alltrim(VW_TITA->EL_DTVCTO)
					cAnho			:= 		SubStr(cFechaVto, 1,4 )
					cMes			:= 		SubStr(cFechaVto, 5,2 )
					cDia			:= 		SubStr(cFechaVto, 7,2 )
					cFechaVto		:= 		cDia + "/" + cMes + "/" + cAnho
					SERIE			:= AllTrim(VW_TITA->EL_PREFIXO)
					NUMERO 		:= AllTrim(VW_TITA->EL_NUMERO)
					TIENDA		:= AllTrim(VW_TITA->EL_LOJORIG)
					VENCTO		:= AllTrim(cFechaVto)
					VALORE			:= VW_TITA->VALOR
					MONEDA		:= GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(VAL(VW_TITA->EL_MOEDA))))
					IMPORTESUS	:= nImpDolar
					VALORCOBE		:= nValCDol
					SALDiO			:= nSaldDol

					//verticales

					oPrint:SayAlign(nLinAtu, COL_SERIE, SERIE,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NUMERO, NUMERO ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_TDA, TIENDA,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu,COL_VENCTO,  VENCTO ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_VALOR,ALLTRIM(TRANSFORM(VALORE,"@E 999,999,999.99")) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_MONEDA, MONEDA ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_IMPORTE, ALLTRIM(TRANSFORM(IMPORTESUS,"@E 999,999,999.99")) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_COBRADO,ALLTRIM(TRANSFORM(VALORCOBE,"@E 999,999,999.99")) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_SALDO,ALLTRIM(TRANSFORM(SALDiO,"@E 999,999,999.99")) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nLinAtu += nTamLin

					VW_TITA->(DbSkip())
				enddo

				nLinAtu += (nTamLin * 2)
				nLinAtu += nTamLin
				nLinAtu += nTamLin
			Endif

			//acaba tributo
			getRas(VW_DBA->EL_RECIBO,VW_DBA->EL_SERIE)

			oPrint:SayAlign(nLinAtu, COL_SERIE, "EN CONCEPTO DE RECIBO ANTICIPADO DE TITULOS",     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			nLinAtu += nTamLin
			oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)

			oPrint:SayAlign(nLinAtu, COL_SERIE, "SERIE",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_NUMERO, "NUMERO" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_VALOR, "VALOR" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_MONEDA, "MONEDA" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COBRADO, "VALOR COBRADO $US" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += nTamLin
			oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
			//Despacho
			if ! VW_DESP->(EoF())

				While ! VW_DESP->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					if(VAL(VW_DESP->EL_MOEDA) == 1 )	// Si es Bs.
						nVaalCDol:= (VW_DESP->VALORCOB / VW_DESP->EL_TXMOE02)	//Se convierte a Dolar
					else
						nVaalCDol:= VW_DESP->VALORCOB
					endIf

					SERIE			:= AllTrim(VW_DESP->EL_PREFIXO)
					NUMERO 		:= AllTrim(VW_DESP->EL_NUMERO)
					VALORE			:= VW_DESP->VALOR
					MONEDA		:= GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(VAL(VW_DESP->EL_MOEDA))))
					VALORCOBE		:= nVaalCDol

					//verticales

					oPrint:SayAlign(nLinAtu, COL_SERIE, SERIE,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NUMERO, NUMERO ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_VALOR,ALLTRIM(TRANSFORM(VALORE,"@E 999,999,999.99")) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_MONEDA, MONEDA ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_COBRADO,ALLTRIM(TRANSFORM(VALORCOBE,"@E 999,999,999.99")) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nLinAtu += nTamLin
					VW_DESP->(DbSkip())
				enddo

			Endif

			nLinAtu += (nTamLin * 2)
			oPrint:SayAlign(nLinAtu, COL_IMPORTE, "Totales:",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SALDO, "$US",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SALDO + 30, ALLTRIM(TRANSFORM(TOTALE,"@E 999,999,999.99")) ,     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			nLinAtu += (nTamLin * 2)
			oPrint:SayAlign(nLinAtu, COL_IMPORTE, "T/C:",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_IMPORTE+30, ALLTRIM(TRANSFORM(TASA,"@E 999,999,999.99")) ,     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)///TASA
			oPrint:SayAlign(nLinAtu, COL_SALDO , "Bs.",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SALDO + 30 ,ALLTRIM(TRANSFORM(TOTALBS,"@E 999,999,999.99")),     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)

			//acaba tributo
			getPagos(VW_DBA->EL_RECIBO,VW_DBA->EL_SERIE)
			//Despacho
			if ! VW_MED->(EoF())

				oPrint:SayAlign(nLinAtu, COL_SERIE, "MEDIO DE PAGO",     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)

				oPrint:SayAlign(nLinAtu, COL_SERIE, "VL",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_NUMERO, "NUMERO" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_VALOR, "VALOR" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu,COL_MONEDA,  "MONEDA" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_BANCO, "BANCO" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_AGENCIA, "AGENCIA" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_VENCTO, "SUCURSAL" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_COBRADO, "CUENTA" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_SALDO, "FECHA" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
				While ! VW_MED->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					cFecha	:= 		alltrim(VW_MED->EL_DTDIGIT)
					cAnho	:= 		SubStr(cFecha, 1,4 )
					cMes	:= 		SubStr(cFecha, 5,2 )
					cDia	:= 		SubStr(cFecha, 7,2 )
					cFecha	:= 		cDia + "/" + cMes + "/" + cAnho
					VL		:= AllTrim(VW_MED->EL_TIPO)
					NUMERO 	:= AllTrim(VW_MED->EL_NUMERO)
					VALORE		:= VW_MED->EL_VALOR
					MONEDA	:= GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(VAL(VW_MED->EL_MOEDA))))
					BANCO		:= AllTrim(VW_MED->EL_BANCO)
					SUCURSAL	:= AllTrim(VW_MED->EL_FILIAL)
					CUENTA	:= AllTrim(VW_MED->EL_CONTA)
					FECHA		:= AllTrim(cFecha)

					oPrint:SayAlign(nLinAtu, COL_SERIE, VL,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NUMERO, NUMERO ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_VALOR, ALLTRIM(TRANSFORM(VALORE,"@E 999,999,999.99"))  ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_MONEDA, MONEDA ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_BANCO, BANCO ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_AGENCIA, AllTrim(VW_MED->EL_AGENCIA) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_VENCTO, SUCURSAL ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_COBRADO, CUENTA ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_SALDO, FECHA ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nLinAtu += nTamLin

					VW_MED->(DbSkip())
				enddo

				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)

			Endif

			nLinAtu += nTamLin
			oPrint:SayAlign(nLinAtu, COL_SERIE, "Tasas al: ",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SERIE + 50, FECHADIA,     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)///FECHADIA
			oPrint:SayAlign(nLinAtu, COL_TDA, "$US: ",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_TDA + 40, ALLTRIM(TRANSFORM(TCDOLAR,"@E 999,999,999.99")),     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)//TCDOLAR
			oPrint:SayAlign(nLinAtu, COL_VALOR, "UFV: ",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_VALOR + 30,  ALLTRIM(TRANSFORM(TCUFV,"@E 999,999,999.99")),     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)//TCUFV
			oPrint:SayAlign(nLinAtu, COL_MONEDA, "E: ",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_MONEDA + 40, ALLTRIM(TRANSFORM(TCEURO,"@E 999,999,999.99")) ,     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)//TCEURO
			oPrint:SayAlign(nLinAtu, COL_SALDO, "Saldo $US: ",     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SALDO + 55,ALLTRIM(TRANSFORM(SALDO,"@E 999,999,999.99")),     oFontDet, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)//SALDO

			VW_MED->(DbCloseArea())
			VW_DESP->(DbCloseArea())
			VW_TITA->(DbCloseArea())

			VW_DBA->(DbSkip())

			nLinAtu += nTamLin
			If nLinAtu <= nLinFin
				fImpRod(.t.,nLinAtu)
			EndIf
		enddo
	else
		Aviso("Mensaje","No hay reporte para exhibir",{'ok'},,,,,.t.)
		VW_DBA->(DbCloseArea())
		RestArea(aArea)
		return
	endif
	//Se ainda tiver linhas sobrando na página, imprime o rodapé final

	VW_DBA->(DbCloseArea())

	//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab()
	Local cTexto   := ""
	Local nLinCab  := 050
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "logo_union.bmp"
	Local nTotal := 0

	/*if(VAL(VW_DBA->EL_MOEDA) == 1 )	// Si es Bs.
	nTotal:= (VW_DBA->TOTAL / VW_DBA->EL_TXMOE02)	//Se convierte a Dolar
	else*/
	nTotal := VW_DBA->TOTAL
	//endIf

	nMoeda:= 2	//2= Dolar
	cMoeda:= "DÓLARES"
	cFechaDia:= alltrim(VW_DBA->EL_DTDIGIT)
	cAnho:= SubStr(cFechaDia, 1,4 )
	cMes:= 	SubStr(cFechaDia, 5,2 )
	cDia:= 	SubStr(cFechaDia, 7,2 )
	cFechaDia:= cDia + "/" + cMes + "/" + cAnho
	auxCancel := alltrim(VW_DBA->EL_CANCEL)
	if(auxCancel == 'T')
		nCancel := "ANULADO"
	else
		nCancel := " "
	end
	nTC_SUS	:= Posicione("SM2", 1, alltrim(VW_DBA->EL_DTDIGIT), "SM2->M2_MOEDA2")
	nTC_UFV	:= Posicione("SM2", 1, alltrim(VW_DBA->EL_DTDIGIT), "SM2->M2_MOEDA4")
	nTC_EURO:= Posicione("SM2", 1, alltrim(VW_DBA->EL_DTDIGIT), "SM2->M2_MOEDA3")
	DIREMPR	:= AllTrim(UPPER(SM0->M0_ENDENT))
	TELEMPR	:= AllTrim(UPPER(SM0->M0_CIDENT)) + " - Bolivia/ Telf:" + AllTrim(SM0->M0_TEL)
	IMPRESION:= DTOC(DATE()) + " " + SUBSTR(TIME(), 1, 2) + ":" + SUBSTR(TIME(), 4, 2)
	CANCEL:= nCancel
	FECHADIA:= AllTrim(cFechaDia)
	CODCL	:= AllTrim(VW_DBA->A1_COD) + " - " + alltrim(VW_DBA->A1_LOJA)
	NOMBRECL := AllTrim(VW_DBA->A1_NOME)
	LOCALIDAD:= AllTrim(Posicione("SA1", 1, VW_DBA->A1_FILIAL + VW_DBA->A1_COD, "SA1->A1_MUN")) //edson 11.10.2019
	DIRECCION:= AllTrim(Posicione("SA1", 1, VW_DBA->A1_FILIAL + VW_DBA->A1_COD, "SA1->A1_END")) //edson 11.10.2019
	NIT	:= AllTrim(VW_DBA->A1_UNITFAC)
	RECIBO:= AllTrim(VW_DBA->EL_RECIBO) + " / " + AllTrim(VW_DBA->EL_SERIE)
	TASA	:= VW_DBA->EL_TXMOE02
	TOTALE	:= ROUND(nTotal, 2)
	TOTALDESC := AllTrim(Extenso( ROUND(nTotal, 2),.f.,nMoeda,,"2",.t.,.t.)) + " " + cMoeda
	TOTALBS	:= (nTotal * VW_DBA->EL_TXMOE02)
	NOMCL := AllTrim(VW_DBA->A1_NOME)
	NITCL := AllTrim(VW_DBA->A1_UNITFAC)
	cUSERLGI := UsrFullName(SUBSTR(EMBARALHA(VW_DBA->EL_USERLGI,1),3,6 ) )	//EDUAR 30/06/2020

	TCDOLAR	:= nTC_SUS
	TCUFV	:= nTC_UFV
	TCEURO:= nTC_EURO
	USUARIO := allTrim(subStr(cUsuario,7,15))
	SALDO:= getSaldo(VW_DBA->A1_FILIAL, VW_DBA->A1_COD, STOD(VW_DBA->EL_DTDIGIT))

	oPrint:StartPage()

	oPrint:SayBitmap(030,10, cFLogo,070,060)

	//Cabeçalho
	cTexto := "RECIBO DE COBRANZA"
	oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 20, , PAD_CENTER, 0)

	oPrint:SayAlign(nLinCab, COL_COBRADO, "Recibo Nro:",     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO+070, RECIBO,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_COBRADO, "Fecha:",     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO+070, FECHADIA,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, nColMeio - 10, CANCEL, oFontTitt, 240, 20, , , 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO, "Impresion:",     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO+070,IMPRESION,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	//Cabeçalho das colunas
	nLinCab += nTamLin ///DIRECCION
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_SERIE, DIREMPR,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += nTamLin ///TELEFONO
	oPrint:SayAlign(nLinCab, COL_SERIE, TELEMPR,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin
	nLinCab += nTamLin
	oPrint:Line(nLinCab, nColIni, nLinCab, nColFin, CLR_BLACK)
	oPrint:SayAlign(nLinCab, COL_SERIE, "Recibimos de los señores: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SERIE + 110, NOMBRECL ,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//nomcli

	oPrint:SayAlign(nLinCab, COL_COBRADO, "Cliente: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO + 70, CODCL,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//CODCLI
	nLinCab += (nTamLin * 1.2)
	oPrint:SayAlign(nLinCab, COL_SERIE, "Direccion: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SERIE + 46, DIRECCION ,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//nomcli

	oPrint:SayAlign(nLinCab, COL_MONEDA-10, "Localidad: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_MONEDA + 37, LOCALIDAD ,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//CODCLI

	oPrint:SayAlign(nLinCab, COL_COBRADO, "Nit: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO + 70, NIT ,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//NIT
	nLinCab += (nTamLin * 1.2)
	oPrint:SayAlign(nLinCab, COL_SERIE, "La suma de: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SERIE + 55, TOTALDESC ,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//nomcli

	oPrint:SayAlign(nLinCab, COL_COBRADO, "$US: ",     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COBRADO + 70, ALLTRIM(TRANSFORM(TOTALE,"@E 999,999,999.99")) ,     oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)//$SUS
	nLinCab += (nTamLin * 1.2)

	oPrint:Line(nLinCab, nColIni, nLinCab, nColFin, CLR_BLACK)

	nLinCab += nTamLin
	nLinCab += nTamLin
	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(lTot,nLinFir)//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Linha Separatória
	//oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_GRAY)

	if lTot
		nLinFir += 60
		oPrint:Line(nLinFir, nColIni, nLinFir, COL_VENCTO, CLR_BLACK)
		oPrint:Line(nLinFir, COL_COBRADO, nLinFir, nColFin, CLR_BLACK)
		oPrint:SayAlign(nLinFir, COL_NUMERO+10, "Recibí Conforme", oFontDet, 240, 20, , PAD_LEFT, 0)
		oPrint:SayAlign(nLinFir, COL_COBRADO +50, "Entregue Conforme", oFontDet, 240, 20, , PAD_LEFT, 0)
		nLinFir += 7
		//oPrint:SayAlign(nLinFir, COL_NUMERO+10, allTrim(subStr(cUsuario,7,15)), oFontDet, 240, 20, , PAD_LEFT, 0)
		oPrint:SayAlign(nLinFir, COL_NUMERO+10, cUSERLGI, oFontDet, 240, 20, , PAD_LEFT, 0)		//EDUAR 30/06/2020
		oPrint:SayAlign(nLinFir, COL_COBRADO+20 , NOMCL, oFontDet, 240, 20, , PAD_LEFT, 0)
		nLinFir += 7
		oPrint:SayAlign(nLinFir, COL_COBRADO+20 , "NIT: ", oFontDet, 240, 20, , PAD_LEFT, 0)
		oPrint:SayAlign(nLinFir, COL_COBRADO +40, NITCL, oFontDet, 240, 20, , PAD_LEFT, 0)

	endif

	nLinRod += 20
	//Dados da Esquerda e Direita
	cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
	cTextoDir := "Página " + cValToChar(nPagAtu)

	//Imprimindo os textos
	oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_BLACK)
	oPrint:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)

	//Finalizando a página e somando mais um
	oPrint:EndPage()
	nPagAtu++
Return

static function getCabec() //obtiene la cabecera del cobro
	Local cQuery	:= ""

	If Select("VW_DBA") > 0
		VW_DBA->(dbCloseArea())
	Endif

	/*SELECT EL_DTDIGIT,A1_FILIAL, A1_COD, A1_LOJA, A1_NOME,A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, SUM(EL_VALOR) TOTAL ,EL_CANCEL  FROM SEL010 SEL  LEFT JOIN SA1010 SA1  ON EL_CLIORIG = A1_COD AND EL_LOJORIG = A1_LOJA	AND SA1.D_E_L_E_T <> '*'  WHERE EL_RECIBO BETWEEN '000015' AND '000015'  AND EL_SERIE BETWEEN 'CMP' AND 'CMP'  AND EL_BANCO <> '   '  AND SEL.D_E_L_E_T = ' ' AND EL_FILIAL = '0105'  GROUP BY EL_DTDIGIT,A1_FILIAL, A1_COD, A1_LOJA, A1_NOME,A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, EL_CANCEL */

	cQuery := "	SELECT EL_DTDIGIT,A1_FILIAL, A1_COD, A1_LOJA, A1_NOME,A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_TXMOE02, SUM( CASE EL_MOEDA WHEN '1' THEN EL_VALOR/EL_TXMOE02 WHEN '01' THEN EL_VALOR/EL_TXMOE02 ELSE EL_VALOR END  ) TOTAL ,EL_CANCEL ,MAX(EL_USERLGI) EL_USERLGI"
	cQuery += " FROM " + RetSqlName("SEL") + " SEL "
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += " ON EL_CLIORIG = A1_COD AND EL_LOJORIG = A1_LOJA	AND SA1.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE EL_RECIBO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND EL_SERIE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += " AND (EL_TIPODOC IN ('CH ','TF ','EF ','CD ','CC ') OR EL_TIPODOC IN ('TB ') AND EL_TIPO in ('NCC')) "
	cQuery += " AND SEL.D_E_L_E_T_ = ' ' AND EL_FILIAL = '" + xfilial("SEL") + "' "
	cQuery += " GROUP BY EL_DTDIGIT,A1_FILIAL, A1_COD, A1_LOJA, A1_NOME,A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_TXMOE02, EL_CANCEL "
	cQuery += " ORDER BY EL_RECIBO, EL_SERIE "

	TCQuery cQuery New Alias "VW_DBA"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getTitulos(cRecb,cSeris)
	Local cQuery	:= ""

	If Select("VW_TITA") > 0
		VW_TITA->(dbCloseArea())
	Endif

	/*SELECT EL_PREFIXO, EL_NUMERO, EL_LOJORIG,EL_DTVCTO, E1_VALOR VALOR, EL_MOEDA, EL_TXMOE02, EL_VALOR VALORCOB, E1_SALDO
	FROM SEL010 SEL
	JOIN SE1010 SE1 ON E1_PREFIXO = EL_PREFIXO AND E1_NUM = EL_NUMERO AND E1_PARCELA = EL_PARCELA AND E1_TIPO = EL_TIPO
	JOIN SE5010 SE5 ON E5_FILIAL = EL_FILIAL AND E5_ORDREC = EL_RECIBO AND E5_SERREC = EL_SERIE AND E5_CLIFOR = EL_CLIORIG AND E5_LOJA = EL_LOJORIG
	AND E5_PREFIXO = EL_PREFIXO AND E5_NUMERO = EL_NUMERO AND E5_PARCELA = EL_PARCELA AND E5_TIPO = EL_TIPO
	WHERE EL_FILIAL = '0105'
	AND EL_BANCO = '   '
	AND EL_RECIBO BETWEEN '000090' AND '000090'
	AND EL_SERIE BETWEEN 'A' AND 'A'
	AND EL_TIPODOC = 'TB'
	AND EL_TIPODOC <> 'RA '
	AND (SE5.E5_SITUACA <> 'C' OR (SE5.E5_SITUACA = 'C' AND SEL.EL_CANCEL = 'T'))
	AND SEL.D_E_L_E_T_ <> '*'
	AND SE1.D_E_L_E_T_ <> '*'
	AND SE5.D_E_L_E_T_ <> '*'*/

	cQuery := "	SELECT EL_PREFIXO, EL_NUMERO, EL_TIPO, EL_LOJORIG,EL_DTVCTO, E1_VALOR VALOR, EL_MOEDA, EL_TXMOE02, EL_VALOR VALORCOB, E1_SALDO "
	cQuery += " FROM " + RetSqlName("SEL") + " SEL "
	cQuery += " JOIN " + RetSqlName("SE1") + " SE1 "
	cQuery += " ON E1_PREFIXO = EL_PREFIXO AND E1_NUM = EL_NUMERO AND E1_PARCELA = EL_PARCELA AND E1_TIPO = EL_TIPO AND SE1.D_E_L_E_T_ <> '*'"
	cQuery += " JOIN " + RetSqlName("SE5") + " SE5 "
	cQuery += "	ON E5_FILIAL = EL_FILIAL AND E5_ORDREC = EL_RECIBO AND E5_SERREC = EL_SERIE AND E5_CLIFOR = EL_CLIORIG AND E5_LOJA = EL_LOJORIG "
	cQuery += " AND E5_PREFIXO = EL_PREFIXO AND E5_MOTBX <> 'DAC' AND E5_NUMERO = EL_NUMERO AND E5_PARCELA = EL_PARCELA AND E5_TIPO = EL_TIPO AND SE5.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE EL_FILIAL = '" + xfilial("SEL") + "' "
	cQuery += " AND EL_BANCO = '   ' "
	cQuery += " AND EL_TIPODOC = 'TB' "
	cQuery += " AND EL_TIPODOC <> 'RA ' "
	cQuery += " AND EL_RECIBO BETWEEN '" + cRecb + "' AND '" + cRecb + "' "
	cQuery += " AND EL_SERIE BETWEEN '" + cSeris + "' AND '" + cSeris + "' "
	cQuery += " AND (SE5.E5_SITUACA <> 'C' OR (SE5.E5_SITUACA = 'C' AND SEL.EL_CANCEL = 'T')) "
	cQuery += " AND SEL.D_E_L_E_T_ <> '*' ORDER BY SEL.R_E_C_N_O_"

	TCQuery cQuery New Alias "VW_TITA"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getRAS(cRecb,cSeris)
	Local cQuery	:= ""

	If Select("VW_DESP") > 0
		VW_DESP->(dbCloseArea())
	Endif
	/*
	SELECT EL_PREFIXO, EL_NUMERO, E1_VALOR VALOR, EL_MOEDA, EL_TXMOE02, EL_VALOR VALORCOB
	FROM SEL010 SEL
	JOIN SE1010 SE1 ON E1_PREFIXO = EL_PREFIXO AND E1_NUM = EL_NUMERO AND E1_PARCELA = EL_PARCELA AND E1_TIPO = EL_TIPO
	AND SEL.EL_CLIORIG = SE1.E1_CLIENTE AND SEL.EL_LOJORIG = SE1.E1_LOJA
	WHERE EL_FILIAL = '0105'
	AND EL_BANCO = '   '
	AND EL_RECIBO BETWEEN '000090' AND '000090'
	AND EL_SERIE BETWEEN 'A  ' AND 'A  '
	AND EL_TIPO = 'RA '
	AND EL_TIPODOC = 'RA '
	AND SEL.D_E_L_E_T_ <> '*'
	AND SE1.D_E_L_E_T_ <> '*'*/

	cQuery := "	SELECT EL_PREFIXO, EL_NUMERO, E1_VALOR VALOR, EL_MOEDA, EL_TXMOE02, EL_VALOR VALORCOB "
	cQuery += " FROM " + RetSqlName("SEL") + " SEL "
	cQuery += " JOIN " + RetSqlName("SE1") + " SE1 "
	cQuery += " ON E1_PREFIXO = EL_PREFIXO AND E1_NUM = EL_NUMERO AND E1_PARCELA = EL_PARCELA AND E1_TIPO = EL_TIPO "
	cQuery += " AND SEL.EL_CLIORIG = SE1.E1_CLIENTE AND SEL.EL_LOJORIG = SE1.E1_LOJA AND SE1.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE EL_FILIAL = '" + xfilial("SEL") + "' "
	cQuery += " AND EL_BANCO = '   ' "
	cQuery += " AND EL_RECIBO BETWEEN '" + cRecb + "' AND '" + cRecb + "' "
	cQuery += " AND EL_SERIE BETWEEN '" + cSeris + "' AND '" + cSeris + "' "
	cQuery += " AND EL_TIPO = 'RA ' "
	cQuery += " AND EL_TIPODOC = 'RA ' "
	cQuery += " AND SEL.D_E_L_E_T_ <> '*' "

	TCQuery cQuery New Alias "VW_DESP"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getPagos(cRecb,cSeris)
	Local cQuery	:= ""

	If Select("VW_MED") > 0
		VW_MED->(dbCloseArea())
	Endif

	/*
	SELECT EL_TIPO, EL_NUMERO, EL_VALOR, EL_MOEDA,EL_BANCO, EL_FILIAL, EL_CONTA, EL_DTDIGIT
	FROM SEL010 SEL
	WHERE EL_FILIAL = '0105'
	AND EL_RECIBO BETWEEN '000090' AND '000090'
	AND EL_SERIE BETWEEN 'A  ' AND 'A  '
	AND EL_BANCO <> '   '
	AND SEL.D_E_L_E_T_ <> '*'
	*/

	cQuery := "	SELECT EL_TIPO, EL_NUMERO, EL_VALOR, EL_AGENCIA, EL_MOEDA,EL_BANCO, EL_FILIAL, EL_CONTA, EL_DTDIGIT "
	cQuery += " FROM " + RetSqlName("SEL") + " SEL "
	cQuery += " WHERE EL_FILIAL = '" + xfilial("SEL") + "' "
	cQuery += " AND EL_BANCO <> '   ' "
	cQuery += " AND EL_RECIBO BETWEEN '" + cRecb + "' AND '" + cRecb + "' "
	cQuery += " AND EL_SERIE BETWEEN '" + cSeris + "' AND '" + cSeris + "' "
	cQuery += " AND SEL.D_E_L_E_T_ <> '*' "

	TCQuery cQuery New Alias "VW_MED"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

Static Function getSaldo(cSucCli, cCodCli, dDigit)
	Local aArea			:= getArea()
	Local nRet			:= 0
	Local OrdenConsul	:= GetNextAlias()
	Local nMoedaLocal	:= 1 //Moneda local
	Local nMoeda		:= 2 //Dolar
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT SUM(A1_SALDUP) SALDOP
		FROM %table:SA1% SA1
		WHERE A1_FILIAL = %exp:cSucCli%
		AND A1_COD = %exp:cCodCli%
		AND SA1.%notdel%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= xMoeda((OrdenConsul)->SALDOP, nMoedaLocal, nMoeda, dDigit)
	endIf
	DbCloseArea(OrdenConsul)
	restArea(aArea)
return nRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿De Recibo?"	, "¿De Recibo?"	,"¿De Recibo?"	,"MV_CH2","C",06,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Recibo?" 	, "¿A Recibo?"	,"¿A Recibo?"	,"MV_CH2","C",06,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Serie?" 	, "¿De Serie?"	,"¿De Serie?"	,"MV_CH2","C",03,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Serie?" 		, "¿A Serie?"	,"¿A Serie?"	,"MV_CH2","C",03,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

return

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
