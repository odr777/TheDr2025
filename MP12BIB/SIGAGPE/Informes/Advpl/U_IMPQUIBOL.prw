#INCLUDE "Protheus.CH"
#INCLUDE "IMPRESBOL.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "topConn.ch"
#DEFINE   nColMax	2350
#DEFINE   nLinMax  2900
#DEFINE   NDESC  1
#DEFINE   NMES1  2
#DEFINE   NMES2  3
#DEFINE   NMES3  4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPQUIBOL ºAutor  ³Ricardo Berti         º Data ³  20/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do QUINQUENIO -  modo Grafico. (Localizacao Bolivia)º±±
±±º          ³Obs.: SRA deve estar posicionado.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPER145                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function IMPQUIBOL()

	Local cFileLogo1	:= ""
	Local cFileLogo2	:= ""
	Local cNomeFun		:= ""
	Local cStartPath	:= GetSrvProfString("Startpath","")
	Local cHoras	    := " "
	Local nValor		:= 0
	Local cDesc			:= ""
	Local cMesMed		:= ""
	Local nTotDeduccion := 0
	Local cIdade        := ""
	Local aTempoServico := {}
	Local cActividad    := ""
	Local nTotRemuner	:= 0
	Local nTot1Remun 	:= 0
	Local nTot2Remun 	:= 0
	Local nTot3Remun 	:= 0
	Local nTotBenSocial	:= 0
	Local nTotD123	 	:= 0
	Local nValorAux		:= 0
	Local cMes1			:= ""
	Local cMes2			:= ""
	Local cMes3			:= ""
	Local aPDVal		:= {}
	Local nLine			:= 0
	Local aTabS007		:= {}
	Local nQuiPg		:= getQuiPg()
	Local dImpresion	//Creada para la fecha de impresion del informe

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oFont07, oFont07n, oFont08, oFont08n, oFont09, oFont11, oFont10n, oFont28n

	oFont07	:= TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.)
	oFont08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	oFont09	:= TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
	oFont11	:= TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
	oFont07n:= TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)	 //Negrito
	oFont08n:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	 //Negrito
	oFont10n:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)	 //Negrito
	oFont28n:= TFont():New("Times New Roman",28,28,,.T.,,,,.T.,.F.)    //Negrito

	nEpoca:= SET(5,1910)
	//-- MUDAR ANO PARA 4 DIGITOS
	SET CENTURY ON

	cIdade := AllTrim(Str(Calc_Idade(dDtPagoQui, SRA->RA_NASC)))
	aTempoServico := DateDiffYMD( SRA->RA_ADMISSA , SRA->RA_DEMISSA )

	dDataRef := dDtPagoQui
	fCarrTab ( @aTabS007, "S007", dDataRef, .T.)
	cActividad := aTabS007[1][9]

	//	If Type("cActividad") == "U"
	//		cActividad := ""
	//	EndIf

	oPrint:StartPage() 			//Inicia uma nova pagina
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FINIQUITO                                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oPrint:Box ( 0020, 0035, 2650, nColMax )
	//oPrint:Box ( 0027, 0045, 2638, nColMax-7 )

	cFileLogo1 	:= cStartPath+ "BOL_140A.BMP"	// Logo: ESTADO PLURINACIONAL DE BOLIVIA
	cFileLogo2 	:= cStartPath+ "BOL_140C.BMP"	// Logo: MINISTERIO DE TRABAJO EMPLEO Y PREVISION SOCIAL

	cNomeFun := If( !Empty(SRA->RA_NOMECMP), SRA->RA_NOMECMP, SRA->RA_NOME )

	If File( cFileLogo1 )
		oPrint:SayBitmap(050,225, cFileLogo1,255,220)
	EndIf
	If File( cFileLogo2 )
		oPrint:SayBitmap(050,1875, cFileLogo2,235,220)
	EndIf

	oPrint:say(272,120,"ESTADO PLURINACIONAL DE",oFont08n)
	oPrint:say(305,270,"BOLIVIA",oFont08n)

	oPrint:say(275,1810,"MINISTERIO DE TRABAJO,",oFont08n)
	oPrint:say(305,1780,"EMPLEO Y PREVISION SOCIAL",oFont08n)

	oPrint:say ( 0145, 0930, "QUINQUENIO", oFont28n )	//"FINIQUITO"
	oPrint:line( 0375, 0060, 0375, nColMax-21 )		//Linha Horizontal
	oPrint:line( 0380, 0060, 0380, nColMax-21 )		//Linha Horizontal

	oPrint:say ( 0400, 0068, STR0002, oFont09 ) 	//"I - DATOS GENERALES"
	oPrint:Box ( 0456, 0062, 0880, nColMax-21 )    				//Box
	oPrint:say ( 0464, 0064, STR0003+/*aInfo[3]*/ TRIM(FWCompanyName()) + " - " + TRIM(FWFilName(FWCodEmp(), SRA->RA_FILIAL)), oFont09 )		//"RAZON SOCIAL O NOMBRE DE LA EMPRESA: "
	oPrint:line ( 0456, 1950, 0509, 1950)
	oPrint:line ( 0456, 2150, 0509, 2150)
	oPrint:line( 0509, 0062, 0509, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0517, 0064, STR0004+ cActividad, oFont09 )		//"RAMA DE ACTIVIDAD ECONOMICA: "
	oPrint:line ( 0509, 0950, 0562, 0950)
	oPrint:line ( 0509, 1050, 0562, 1050)
	oPrint:line ( 0509, 1200, 0562, 1200)
	oPrint:say ( 0517, 1210, STR0005 /*aInfo[4]*/ /*AllTrim(UPPER(SM0->M0_ENDCOB))*/, oFont07 )		//"DOMICILIO: "
	oPrint:say ( 0517, 1410, AllTrim(UPPER(SM0->M0_ENDENT)), oFont07 )
	oPrint:line( 0562, 0062, 0562, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0570, 0064, STR0006+(cNomeFun), oFont09 )    //"NOMBRE DEL TRABAJADOR: "
	oPrint:line ( 0562, 1950, 0615, 1950)
	oPrint:line ( 0562, 2150, 0615, 2150)
	oPrint:line( 0615, 0062, 0615, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0623, 0064, STR0007+;
	(Substr(TrmDesc("SX5","33"+SRA->RA_ESTCIVI,"SX5->X5_DESCSPA"),1,15)), oFont09 )    //"ESTADO CIVIL: "
	oPrint:line ( 0615, 0825, 0668, 0825)
	oPrint:line ( 0615, 0950, 0668, 0950)
	oPrint:say ( 0623, 0960, STR0008+cIdade, oFont09 )    //"EDAD:"
	oPrint:line ( 0615, 1300, 0668, 1300)
	oPrint:line ( 0615, 1400, 0668, 1400)
	oPrint:say ( 0626, 1418, STR0005+SRA->RA_ENDEREC, oFont09 )    //"DOMICILIO:"
	oPrint:line( 0668, 0062, 0668, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0676, 0064, STR0009+fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC"), oFont09 )//"PROFESION U OCUPACION: "
	oPrint:line ( 0668, 1950, 0721, 1950)
	oPrint:line ( 0668, 2150, 0721, 2150)
	oPrint:line( 0721, 0062, 0721, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0729, 0064, STR0010 + TRIM(SRA->RA_CIC) + " " + TRIM(SRA->RA_UFCI), oFont09 )    //"CI: "
	oPrint:line ( 0721, 0600, 0774, 0600)
	oPrint:say ( 0729, 0610, STR0011+DtoC(SRA->RA_ADMISSA), oFont09 )    //"FECHA DE INGRESO: "
	oPrint:line ( 0721, 1400, 0774, 1400)
	oPrint:say ( 0729, 1410, /*STR0012*/"DESDE EL: " + DtoC(getFchInd()) + " HASTA EL: " + DtoC(DaySub(YearSum(getFchInd(), nQuiPg), 1)), oFont09 )    //"FECHA DE RETIRO"
	oPrint:line( 0774, 0062, 0774, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0782, 0064, "PAGO DE INDEMNIZACION: "+"PAGO "+cCausa+". "+"QUINQUENIO", oFont09 )    //STR0013 "PAGO DE INDEMNIZACION: " ## STR0075"PAGO "##"QUINQUENIO" STR0001
	oPrint:line ( 0774, 1050, 0827, 1050)
	oPrint:line ( 0774, 1200, 0827, 1200)
	oPrint:say ( 0782, 1210, STR0014+AllTrim(Str(SRA->RA_SALARIO)), oFont09 )    //"REMUNERACION MENSUAL Bs: "
	oPrint:line ( 0774, 2150, 0880, 2150)
	oPrint:line( 0827, 0062, 0827, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( 0835, 0064, STR0015, oFont09 )    //"TIEMPO DE SERVICIO: "
	oPrint:say ( 0835, 0450, AllTrim(Str(nQuiPg)), oFont09 )
	oPrint:say ( 0835, 0500, STR0016, oFont09 )    //"ANOS"
	oPrint:say ( 0835, 0650, AllTrim(Str(0)), oFont09 )
	oPrint:say ( 0835, 0700, STR0017, oFont09 )    //"MESES"
	oPrint:say ( 0835, 0850, AllTrim(Str(0)), oFont09 )
	oPrint:say ( 0835, 0900, STR0018, oFont09 )    //"DIAS"
	oPrint:line ( 0827, 1850, 0880, 1850)
	oPrint:line ( 0827, 1950, 0880, 1950)
	oPrint:line( 0902, 0062, 0902, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:line( 0907, 0062, 0907, nColMax-21 ) 		   		//Linha Horizontal

	oPrint:say ( 0924, 0068, STR0019, oFont09 )		//"II - LIQUIDACION DE LA REMUNERACION PROMEDIO INDEMNIZABEL EN BASE A LOS 3 ULTIMO MESES"
	oPrint:line( 0977, 0062, 0977, nColMax-21 ) 		   		//Linha Horizontal
	oPrint:line( 0982, 0062, 0982, nColMax-21 ) 		   		//Linha Horizontal
	//oPrint:Box ( 1004, 0062, 1466, nColMax-21 )    				//Box
	//oPrint:line ( 1004, 0500, 1466, 0500)						//Linhas Verticais
	//oPrint:line ( 1004, 0950, 1466, 0950)
	//oPrint:line ( 1004, 1400, 1466, 1400)
	//oPrint:line ( 1004, 1850, 1466, 1850)
	oPrint:say ( 1012, 0064, STR0020, oFont09 )    //"A)MESES"
	oPrint:say ( 1012, 2020, STR0021, oFont09 )    //"TOTALES"
	oPrint:line( 1057, 0062, 1057, nColMax-21 ) 		   	//Linha Horizontal

	If RetHoraVal( "0760", @cHoras, @nValor, @cDesc, @cMesMed )
		If !Empty(cMesMed)
			oPrint:say ( 1012, 1600, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		oPrint:say ( 1065, 1600, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot3Remun := nValor
		nTotRemuner+= nValor

		RetHoraVal( "0755", @cHoras, @nValor, @cDesc, @cMesMed )
		If !Empty(cMesMed)
			oPrint:say ( 1012, 0630, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValorAux:= nValor

		RetHoraVal( "0754", @cHoras, @nValor, @cDesc, @cMesMed )
		nValorAux += nValor
		oPrint:say ( 1065, 0650, Transform(nValorAux, "@E 99,999,999.99"), oFont08)
		nTot1Remun := nValorAux
		nTotRemuner+= nValorAux

		RetHoraVal( "0756", @cHoras, @nValor, @cDesc, @cMesMed )
		If !Empty(cMesMed)
			oPrint:say ( 1012, 1100, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		oPrint:say ( 1065, 1150, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot2Remun := nValor
		nTotRemuner+= nValor
	Else
		RetHoraVal( "0754", @cHoras, @nValor, @cDesc, @cMesMed )
		cMesMed:= SUBSTR(DTOS(MonthSub(dDtPagoQui, 3)), 1, 6)
		If !Empty(cMesMed)
			cMes1:= cMesMed
			oPrint:say ( 1012, 0630, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValor:= getSalMes(cMesMed)
		oPrint:say ( 1065, 0650, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot1Remun := nValor
		nTotRemuner+= nValor

		RetHoraVal( "0755", @cHoras, @nValor, @cDesc, @cMesMed )
		cMesMed:= SUBSTR(DTOS(MonthSub(dDtPagoQui, 2)), 1, 6)
		If !Empty(cMesMed)
			cMes2:= cMesMed
			oPrint:say ( 1012, 1100, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValor:= getSalMes(cMesMed)
		oPrint:say ( 1065, 1150, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot2Remun := nValor
		nTotRemuner+= nValor

		RetHoraVal( "0756", @cHoras, @nValor, @cDesc, @cMesMed )
		cMesMed:= SUBSTR(DTOS(MonthSub(dDtPagoQui, 1)), 1, 6)
		If !Empty(cMesMed)
			cMes3:= cMesMed
			oPrint:say ( 1012, 1600, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValor:= getSalMes(cMesMed)
		oPrint:say ( 1065, 1600, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot3Remun := nValor
		nTotRemuner+= nValor
	Endif

	oPrint:say ( 1065, 0064, STR0022, oFont09 )    //"REMUNERACION MENSUAL"
	oPrint:line ( 1057, 0600, 1110, 0600)						//Linha Vertical
	oPrint:line ( 1057, 1050, 1110, 1050) 						//Linha Vertical
	oPrint:line ( 1057, 1500, 1110, 1500) 						//Linha Vertical
	oPrint:line ( 1057, 1950, 1110, 1950) 						//Linha Vertical
	oPrint:say ( 1065, 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1065, 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1065, 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1065, 1860, STR0023, oFont09 )    //"Bs"

	oPrint:say ( 1065, 2000, Transform(nTotRemuner, "@E 99,999,999.99"), oFont08)
	oPrint:line( 1110, 0062, 1110, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:say ( 1118, 0064, STR0024, oFont09 )    //"B)OTROS CONCEPTOS"
	oPrint:say ( 1156, 0064, STR0025, oFont09 )    //"PERCIBIDOS EN EL MES"
	oPrint:line( 1201, 0062, 1201, nColMax-21 ) 		   	//Linha Horizontal
	/*oPrint:say ( 1209, 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1209, 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1209, 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1209, 1860, STR0023, oFont09 )    //"Bs"*/
	//DENAR
	aPDVal:= getPDs(SRA->RA_MAT, cMes1, cMes2, cMes3)
	if(SUBSTR(cMes1, 5, 2) $ '02|03|04')//Si el mes 1 está en alguno de los periodos de retroactivo(FEB,MAR,ABR)
		aPDRet:= getPdRET(SRA->RA_FILIAL, SRA->RA_MAT, cMes1, cMes2, cMes3)
		for i:= 1 to Len(aPDRet)
			AADD(aPDVal, aPDRet[i])
		next i
	EndIf
	nLine:= 1209
	for i:= 1 to Len(aPDVal)
		oPrint:say ( nLine, 0510, STR0023, oFont09 )    //"Bs"
		oPrint:say ( nLine, 0960, STR0023, oFont09 )    //"Bs"
		oPrint:say ( nLine, 1410, STR0023, oFont09 )    //"Bs"
		oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"

		oPrint:say ( nLine, 0064, aPDVal[i][NDESC], oFont09 )
		oPrint:say ( nLine, 0650, Transform(aPDVal[i][NMES1], "@E 99,999,999.99"), oFont08 )
		nTot1Remun+= aPDVal[i][NMES1]
		oPrint:say ( nLine, 1150, Transform(aPDVal[i][NMES2], "@E 99,999,999.99"), oFont08 )
		nTot2Remun+= aPDVal[i][NMES2]
		oPrint:say ( nLine, 1600, Transform(aPDVal[i][NMES3], "@E 99,999,999.99"), oFont08 )
		nTot3Remun+= aPDVal[i][NMES3]
		oPrint:say ( nLine, 2000, Transform(aPDVal[i][NMES1] + aPDVal[i][NMES2] + aPDVal[i][NMES3], "@E 99,999,999.99"), oFont08 )	//TOTAL
		oPrint:line( nLine + 45, 0062, nLine + 45, nColMax-21 ) 		   	//Linha Horizontal
		nLine+= 53
	next i
	oPrint:line ( 1201, 0600, nLine -8, 0600)						//Linha Vertical
	oPrint:line ( 1201, 1050, nLine -8, 1050) 						//Linha Vertical
	oPrint:line ( 1201, 1500, nLine -8, 1500) 						//Linha Vertical
	oPrint:line ( 1201, 1950, nLine -8, 1950) 						//Linha Vertical
	nTotRemuner:= nTot1Remun + nTot2Remun + nTot3Remun

	/*
	oPrint:line ( 1201, 0600, 1413, 0600)						//Linha Vertical
	oPrint:line ( 1201, 1050, 1413, 1050) 						//Linha Vertical
	oPrint:line ( 1201, 1500, 1413, 1500) 						//Linha Vertical
	oPrint:line ( 1201, 1950, 1413, 1950) 						//Linha Vertical
	oPrint:line( 1254, 0062, 1254, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:say ( 1262, 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1262, 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1262, 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1262, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:line( 1307, 0062, 1307, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:say ( 1315, 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1315, 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1315, 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1315, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:line( 1360, 0062, 1360, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:say ( 1368, 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1368, 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1368, 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say ( 1368, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:line( 1413, 0062, 1413, nColMax-21 ) 		   	//Linha Horizontal
	*/

	oPrint:Box ( 1004, 0062, nLine + 40, nColMax-21 )    				//Box
	oPrint:line ( 1004, 0500, nLine + 40, 0500)						//Linhas Verticais
	oPrint:line ( 1004, 0950, nLine + 40, 0950)
	oPrint:line ( 1004, 1400, nLine + 40, 1400)
	oPrint:line ( 1004, 1850, nLine + 40, 1850)

	oPrint:say ( nLine, 0064, STR0039, oFont09 )    //"TOTAL Bs"
	oPrint:say ( nLine, 0650, Transform(nTot1Remun, "@E 99,999,999.99"), oFont08)
	oPrint:say ( nLine, 1150, Transform(nTot2Remun, "@E 99,999,999.99"), oFont08)
	oPrint:say ( nLine, 1600, Transform(nTot3Remun, "@E 99,999,999.99"), oFont08)
	oPrint:say ( nLine, 2000, Transform(nTotRemuner,"@E 99,999,999.99"), oFont08)
	nLine+= 50
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( nLine, 1850, nLine + 70, 1850) 						//Linha Vertical
	oPrint:line ( nLine, nColMax-21, nLine + 70, nColMax-21) 						//Linha Vertical
	oPrint:line ( nLine, nColMax-26, nLine + 70, nColMax-26) 						//Linha Vertical
	nLine+= 17
	oPrint:say ( nLine, 0068, STR0027, oFont09 )		//"III - TOTAL REMUNERACION PROMEDIO INDEMNIZABLE (A+B) DIVIDIDO ENTRE 3:"
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	//RetHoraVal( "1273", @cHoras, @nValor, @cDesc )
	oPrint:say ( nLine, 2000, Transform(nTotRemuner/3, "@E 99,999,999.99"), oFont08 )
	nLine+= 53

	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 5
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 22
	oPrint:Box ( nLine, 0062, nLine + 484, nColMax-21 )    			//Box
	oPrint:line ( nLine, 1850, nLine + 484, 1850) 						//Linha Vertical
	oPrint:line ( nLine, 1950, nLine + 484, 1950) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0028, oFont09 )		//"C)DESAHUCIO TRES MESES (EN CASO DE RETIRO FORSOZO)"
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(0, "@E 99,999,999.99"), oFont08 )
	nLine+= 52
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( nLine, 0850, nLine + 318, 0850)						//Linha Vertical
	oPrint:line( nLine, 0950, nLine + 318, 0950) 						//Linha Vertical
	oPrint:line( nLine, 1200, nLine + 318, 1200) 						//Linha Vertical
	oPrint:line( nLine, 1375, nLine + 318, 1375) 						//Linha Vertical
	oPrint:line( nLine, 1500, nLine + 159, 1500) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0029, oFont09 )    //"D)INDEMNIZACION POR TIEMPO DE TRABAJO:"
	oPrint:say ( nLine, 0860, STR0030, oFont09 )    //"DE"
	//-------------------------------------------------------------
	RetHoraVal( "1274", @cHoras, @nValor, @cDesc )
	oPrint:say ( nLine, 1000, Transform(Val(cHoras), "999.99"), oFont08)
	oPrint:say ( nLine, 1210, STR0016, oFont09 )    //"ANOS"
	oPrint:say ( nLine, 1385, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 1550, Transform(nValor, "@E 99,999,999.99"), oFont08)
	nTotBenSocial+= nValor
	nTotD123 += nValor

	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(nTotD123, "@E 99,999,999.99"), oFont08)
	nLine+= 45

	//-------------------------------------------------------------
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 0860, STR0030, oFont09 )    //"DE"
	oPrint:say ( nLine, 1000, Transform(0, "999.99"), oFont08 )
	oPrint:say ( nLine, 1210, STR0017, oFont09 )    //"MESES"
	oPrint:say ( nLine, 1385, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 1550, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	//-------------------------------------------------------------
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 0860, STR0030, oFont09 )    //"DE"
	oPrint:say ( nLine, 1000, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1210, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( nLine, 1385, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 1550, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	//-------------------------------------------------------------
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( nLine, 1675, nLine + 159, 1675) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0031, oFont09 )    //"AGUINALDO DE NAVIDAD"
	oPrint:say ( nLine, 0860, STR0030, oFont09 )    //"DE"
	oPrint:say ( nLine, 1000, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1210, STR0032, oFont09 )    //"MESES Y"
	oPrint:say ( nLine, 1500, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1685, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0033, oFont09 )    //"VACACION"
	oPrint:say ( nLine, 0860, STR0030, oFont09 )    //"DE"

	oPrint:say ( nLine, 1040, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1210, STR0032, oFont09 )    //"MESES Y"

	oPrint:say ( nLine, 1500, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1685, STR0018, oFont09 )    //"DIAS"

	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0034, oFont09 )    //"PRIMA LEGAL (SI CORRESPONDE)"
	oPrint:say ( nLine, 0860, STR0030, oFont09 )    //"DE"
	oPrint:say ( nLine, 1040, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1210, STR0032, oFont09 )    //"MESES Y"
	oPrint:say ( nLine, 1500, Transform(0, "999.99"), oFont08)
	oPrint:say ( nLine, 1685, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 	//Linha Horizontal
	oPrint:line ( nLine, 0200, nLine + 53, 0200)			//Linha Vertical
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0035, oFont09 ) 	//"OTROS"
	RetHoraVal( "1275", @cHoras, @nValor, @cDesc )
	nVal:=nValor
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(nVal, "@E 99,999,999.99"), ofont08)
	nLine+= 45
	nTotBenSocial+= nVal
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( nLine, 0370, nLine + 53, 0370)				//Linha Vertical
	oPrint:line ( nLine, 0750, nLine + 53, 0750)						//Linha Vertical
	oPrint:line ( nLine, 1200, nLine + 53, 1200) 						//Linha Vertical
	oPrint:line ( nLine, 1300, nLine + 53, 1300) 						//Linha Vertical
	oPrint:line ( nLine, 1675, nLine + 53, 1675) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( nLine, 0200, Transform(Year(SRA->RA_DEMISSA),"9999"), oFont08)
	oPrint:say ( nLine, 0500, STR0036, oFont09 )    //"GESTION"
	oPrint:say (nLine, 0800, MesExtenso(Month(SRA->RA_DEMISSA)), oFont08)
	oPrint:say ( nLine, 1210, STR0030, oFont09 )    //"DE
	oPrint:say ( nLine, 1450, Transform(0, "999.99"), oFont09)
	oPrint:say ( nLine, 1685, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(0, "@E 99,999,999.99"), ofont08)
	nLine+= 50
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( nLine, 1950, nLine + 75, 1950) 						//Linha Vertical
	nLine+= 17

	oPrint:say ( nLine, 0068, STR0037, oFont09 )		//"IV. - TOTAL BENEFICIOS SOCIALES: C+D"
	oPrint:say ( nLine, 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(nTotBenSocial, "@E 99,999,999.99"), oFont08)
	nLine+= 53
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 5
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 22
	oPrint:Box ( nLine, 0062, nLine + 318, nColMax-21 )    			//Box
	oPrint:line ( nLine, 0370, nLine + 318, 0370)						//Linha Vertical
	oPrint:line ( nLine, 1050, nLine + 318, 1050) 						//Linha Vertical
	oPrint:line ( nLine, 1200, nLine + 318, 1200) 						//Linha Vertical
	oPrint:line ( nLine, 1675, nLine + 318, 1675) 						//Linha Vertical
	oPrint:line ( nLine, 1950, nLine + 318, 1950) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( nLine, 0064, STR0038, oFont09 )		//"E)DEDUCCIONES:"
	oPrint:say ( nLine, 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( nLine, 1060, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 1685, STR0039, oFont09 )    //"TOTAL Bs"
	oPrint:say ( nLine, 2000, Transform(nTotDeduccion, "@E 99,999,999.99"), oFont08)
	nLine+= 50
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( nLine, 1850, nLine + 70, 1850) 						//Linha Vertical
	oPrint:line ( nLine, 1855, nLine + 70, 1855) 						//Linha Vertical
	nLine+= 17

	oPrint:say ( nLine, 0064, STR0040, oFont09 )    //"V. IMPORTE LIQUIDO A PAGAR C+D-E="
	oPrint:say ( nLine, 1865, STR0023, oFont09 )    //"Bs"
	oPrint:say ( nLine, 2000, Transform(nTotBenSocial-nTotDeduccion, "@E 99,999,999.99"), oFont08)
	nLine+= 53
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 5
	oPrint:line( nLine, 0062, nLine, nColMax-21 ) 		   	//Linha Horizontal

	//Cuadros
	oPrint:Box ( 0020, 0035, 3000, nColMax )
	oPrint:Box ( 0027, 0045, 2988, nColMax-7 )

	oPrint:EndPage()
	oPrint:StartPage()

	oPrint:Box ( 0020, 0035, 3000, nColMax )
	oPrint:Box ( 0027, 0045, 2988, nColMax-7 )

	oPrint:say ( 0100, 0100, STR0041, oFont09 )    //"FORMA DE PAGO"
	oPrint:say ( 0100, 0400, STR0042, oFont09 )    //"EFECTIVO   (     )"
	oPrint:say ( 0100, 0800, STR0043, oFont09 )    //"CHEQUE   (     )"

	If nPagTipo == 1
		oPrint:say ( 0100, 0660, "X", oFont09 )
		oPrint:say ( 0100, 1200, STR0044, oFont09 )    //"Nº"
		oPrint:say ( 0100, 1700, STR0045, oFont09 )    //"C/BANCO"
	Else
		oPrint:say ( 0100, 1010, "X", oFont09 )
		oPrint:say ( 0100, 1200, STR0044+cNCheque, oFont09 )    //"Nº"
		oPrint:say ( 0100, 1700, STR0045+cNomeBanco, oFont09 )    //"C/BANCO"
	Endif

	oPrint:say ( 0150, 0100, STR0046, oFont09 )    //"IMPORTE DE LA SUMA CANCELADA"
	oPrint:say ( 0195, 0100, Extenso(nTotBenSocial-nTotDeduccion,.F.,1," ","2",.T.,.T.,.F.,"3")+STR0074, oFont08)
	oPrint:say ( 0200, 0100, "...........................................................................................................", oFont09 )
	oPrint:say ( 0240, 0100, "...........................................................................................................", oFont09 )

	oPrint:line( 0280, 0072, 0280, nColMax-36 ) 		   	//Linha Horizontal
	oPrint:line( 0285, 0072, 0285, nColMax-36 ) 		   	//Linha Horizontal

	oPrint:say ( 0350, 0150, STR0047, oFont09 )    //"YO"
	oPrint:say ( 0350, 0250, (cNomeFun), oFont09 )
	oPrint:say ( 0500, 0150, STR0048, oFont09 )    //"MAYOR DE EDAD, CON C.I. Nº"
	oPrint:say ( 0500, 0700, (SRA->RA_CIC) + " " + TRIM(SRA->RA_UFCI), oFont09 )
	oPrint:say ( 0500, 1050, STR0049, oFont09 )    //"DECLARO QUE EN LA FECHA RECIBO A MI ENTERA SATISFACCIÓN EL "
	oPrint:say ( 0550, 0150, STR0050+;
		Transform(nTotBenSocial-nTotDeduccion, "@E 99,999,999.99") , oFont09 )    //"IMPORTE DE Bs."
	oPrint:say ( 0550, 0800, STR0051, oFont09 )    //"POR CONCEPTO DE LA LIQUIDACION DE MIS BENEFICIOS SOCIALES, DE CONFORMIDAD"
	oPrint:say ( 0600, 0150, STR0052, oFont09 )    //"CON LA LEY GENERAL DEL TRABAJO, SU DECRETO REGLAMENTANTARIO Y DISPOSICIONES CONEXAS."

	If(VALTYPE(MV_PAR15) <> "U")
		If(!EMPTY(MV_PAR15))
			dImpresion:= MV_PAR15
		Else
			cAlertMsg := "Por favor revise la pregunta 'Fecha de Impresión' en los parámetros." + CRLF
			cAlertMsg += "En caso de no existir la pregunta, por favor contacte con el administrador del sistema para crearla."
			alert(cAlertMsg)
		EndIf
	Else
		alert("Por favor contacte con el administrador del sistema para crear la pregunta 'Fecha de Impresión'")
	EndIf

	if( (VALTYPE(dImpresion) <> "D") .OR. EMPTY(dImpresion) )
		dImpresion:= dDtPagoQui
	EndIf

	oPrint:say ( 0750, 0100, STR0053+" "+aInfo[5], oFont09 )    //"LUGAR Y FECHA"
	oPrint:say ( 0750, 0800, ",", oFont09 )
	oPrint:say ( 0750, 0850, Transform(Day(dImpresion),"99"), oFont09)
	oPrint:say ( 0750, 1000, STR0030, oFont09 )    //"DE"
	oPrint:say ( 0750, 1070, MesExtenso(Month(dImpresion)), oFont09)
	oPrint:say ( 0750, 1500, STR0030, oFont09 )    //"DE"
	oPrint:say ( 0750, 1570, Transform(Year(dImpresion),"9999"), oFont09)
	oPrint:say ( 0750, 1800, ".", oFont09 )

	oPrint:say ( 1000, 0100, "............................................", oFont09 )
	oPrint:say ( 1000, 1400, "............................................", oFont09 )
	oPrint:say ( 1050, 0400, STR0054, oFont09 )    //"INTERESADO"
	oPrint:say ( 1050, 1650, STR0055, oFont09 )    //"APODERADOS LEGALES"
	oPrint:say ( 1200, 0100, "............................................", oFont09 )
	oPrint:say ( 1200, 1400, "............................................", oFont09 )
	oPrint:say ( 1250, 0200, STR0056, oFont09 )    //"Vo. Bo. MINISTERIO DE TRABAJO"
	oPrint:say ( 1250, 1750, STR0057, oFont09 )    //"SELLO"

	oPrint:line( 1375, 0072, 1375, nColMax-36 ) 		   	//Linha Horizontal
	oPrint:line( 1380, 0072, 1380, nColMax-36 ) 		   	//Linha Horizontal

	oPrint:say ( 1500, 1000, STR0058, oFont11 )    //"INSTRUCCIONES"
	oPrint:say ( 1600, 0200, STR0059, oFont11 )    //"1. En todos los casos en los cuales proceda el pago de benefícios sociales y que no"
	oPrint:say ( 1650, 0200, STR0060, oFont11 )    //"estén comprendidos en el despido por las causales en el Art. 16 de la  Ley  General"
	oPrint:say ( 1700, 0200, STR0061, oFont11 )    //"del Trabajo y el Art. 9 de su Reglamento, el Finiquito de contrato se suscribirá en"
	oPrint:say ( 1750, 0200, STR0062, oFont11 )    //"el presente FORMULARIO."
	oPrint:say ( 1800, 0200, STR0063, oFont11 )    //"2. Los señores Directores, Jefes Departamentales e Inspectores  Regionales, son los"
	oPrint:say ( 1850, 0200, STR0064, oFont11 )    //"únicos funcionarios facultados para revisar y refrendar todo Finiquito de  contrato"
	oPrint:say ( 1900, 0200, STR0065, oFont11 )    //"de Trabajo, concuya intervención alcanzará la correspondiente eficacia jurídica, en"
	oPrint:say ( 1950, 0200, STR0066, oFont11 )    //"aplicación del Art. 22 de la Ley General del Trabajo."
	oPrint:say ( 2000, 0200, STR0067, oFont11 )    //"La  intervención  de  cualquer  otro   funcionario  del  Ministerio  de  Trabajo  y"
	oPrint:say ( 2050, 0200, STR0068, oFont11 )    //"Microempresa carecerá de toda validez legal."
	oPrint:say ( 2100, 0200, STR0069, oFont11 )    //"3. Las  partes  intervinientes  en  la  suscripción del presente FINIQUITO, deberán"
	oPrint:say ( 2150, 0200, STR0070, oFont11 )    //"acreditar suidentidad personal con los documentos señalados por ley."
	oPrint:say ( 2200, 0200, STR0071, oFont11 )    //"4. Este  Formulario  no  constituye  Ley entre partes por su carácter esencialmente"
	oPrint:say ( 2250, 0200, STR0072, oFont11 )    //"revisable, porlo  tanto las  cifras en el contenidas no causan estado ni revisen el"
	oPrint:say ( 2300, 0200, STR0073, oFont11 )    //"sello de cosa juzgada"

	oPrint:EndPage()

	Set(5,nEpoca)
	If nTdata > 8
		SET CENTURY ON
	Else
		SET CENTURY OFF
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³rethoravalºAutor  ³Erika Kanamori      º Data ³  01/16/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna hora e valor correspondente ao identificador de cal-º±±
±±º          ³culo informado em cIdCalc, baseados nas informacoes em aBol.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RetHoraVal(cIdCalc, cHoras, nValor, cDesc, cMesMed)

	Local nAux
	Local nQtdLan
	Local lAux := .F.
	/* aBol:= { [x][1]- nº do identificador de calculo
	[x][2]- descricao
	[x][3]- horas
	[x][4]- valor }
	[x][5]- AAAAMM usado para media indeniz.}	*/

	cHoras	:= " "
	nValor	:= 0
	cDesc 	:= ""
	cMesMed := ""

	nQtdLan := Len(aBol)

	For nAux:=1 To nQtdLan
		If aBol[nAux][1] == cIdCalc
			cDesc	+= aBol[nAux][2]
			cHoras	+= aBol[nAux][3]
			nValor	+= aBol[nAux][4]
			cMesMed	:= If( ValType(aBol[nAux][5]) == "C", aBol[nAux][5] , "" ) // AAAAMM
			lAux	:= .T.
			nAux	:= If( aBol[nAux][1] # "9999", nQtdLan, nAux ) //No codigo 9999 sera agrupado proventos gerados somente na rescisao
		Endif
	Next nAux

Return lAux

Static Function getPDs(cMat, cMes1, cMes2, cMes3)
	Local aArea:= getArea()
	Local aRet:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RV_COD, RV_DESC, SUM(MES1) AS MES1, SUM(MES2) AS MES2, SUM(MES3) AS MES3
		FROM
		(
		SELECT DISTINCT RV_COD, RV_DESC,
		COALESCE((SELECT SUM(RD_VALOR) FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_MAT = %exp:cMat% AND RD_PERIODO = %exp:cMes1% AND RD_ROTEIR = 'FOL' AND %notdel%), 0) AS MES1,
		COALESCE((SELECT SUM(RD_VALOR) FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_MAT = %exp:cMat% AND RD_PERIODO = %exp:cMes2% AND RD_ROTEIR = 'FOL' AND %notdel%), 0) AS MES2,
		COALESCE((SELECT SUM(RD_VALOR) FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_MAT = %exp:cMat% AND RD_PERIODO = %exp:cMes3% AND RD_ROTEIR = 'FOL' AND %notdel%), 0) AS MES3
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON SRD.RD_PD = SRV.RV_COD
		WHERE SRV.RV_TIPOCOD = '1'
		AND SRV.RV_CODFOL NOT IN ('1276', '0740', '0739', '0738', '0741', '0031', '0006', '0024')
		AND SRD.RD_MAT = %exp:cMat%
		AND SRD.RD_PERIODO IN (%exp:cMes1%, %exp:cMes2%, %exp:cMes3%)
		AND SRD.%notdel%
		AND SRV.%notdel%
		) A
		GROUP BY RV_COD, RV_DESC

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while ( (OrdenConsul)->(!Eof()))
			aDados:={}
			AADD(aDados, (OrdenConsul)->RV_DESC)
			AADD(aDados, (OrdenConsul)->MES1)
			AADD(aDados, (OrdenConsul)->MES2)
			AADD(aDados, (OrdenConsul)->MES3)
			AADD(aRet, aDados)
			(OrdenConsul)->(dbSkip())
		End
	endIf

	restArea(aArea)
return aRet

/**
* @author: Denar Terrazas Parada
* @since: 01/06/2021
* @description: Funcion que obtiene los conceptos de ingreso de los retroactivos para imprimirlos, 
*/
Static Function getPdRET(cSuc, cMat, cMes1, cMes2, cMes3)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	Local cPerRET		:= SUBSTR(cMes3, 1, 4) + "05"//PERIODO DE MAYO(RETROACTIVO)
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RV_COD, RV_DESC, SUM(FEB) AS FEB, SUM(MAR) AS MAR, SUM(ABR) AS ABR
		FROM
		(
		SELECT DISTINCT RV_COD, RV_DESC,
		COALESCE((SELECT SUM(RC_VALOR) FROM %table:SRC% WHERE RC_PD = SRC.RC_PD AND RC_FILIAL = %exp:cSuc% AND RC_MAT = %exp:cMat% AND RC_ROTEIR = 'RE2' AND RC_PERIODO = %exp:cPerRET%  AND %notdel%), 0) AS FEB,
		COALESCE((SELECT SUM(RC_VALOR) FROM %table:SRC% WHERE RC_PD = SRC.RC_PD AND RC_FILIAL = %exp:cSuc% AND RC_MAT = %exp:cMat% AND RC_ROTEIR = 'RE3' AND RC_PERIODO = %exp:cPerRET%  AND %notdel%), 0) AS MAR,
		COALESCE((SELECT SUM(RC_VALOR) FROM %table:SRC% WHERE RC_PD = SRC.RC_PD AND RC_FILIAL = %exp:cSuc% AND RC_MAT = %exp:cMat% AND RC_ROTEIR = 'RE4' AND RC_PERIODO = %exp:cPerRET%  AND %notdel%), 0) AS ABR
		FROM %table:SRC% SRC
		JOIN %table:SRV% SRV ON SRC.RC_PD = SRV.RV_COD
		WHERE SRC.RC_FILIAL = %exp:cSuc%
		AND SRC.RC_MAT = %exp:cMat%
		AND SRC.RC_PERIODO = %exp:cPerRET% 
		AND RV_TIPOCOD = '1'
		AND SRC.RC_ROTEIR IN ('RE2', 'RE3', 'RE4')
		AND SRC.%notdel%
		AND SRV.%notdel%
		UNION
		SELECT DISTINCT RV_COD, RV_DESC,
		COALESCE((SELECT SUM(RD_VALOR) FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_FILIAL = %exp:cSuc% AND RD_MAT = %exp:cMat% AND RD_ROTEIR = 'RE2' AND RD_PERIODO = %exp:cPerRET%  AND %notdel%), 0) AS FEB,
		COALESCE((SELECT SUM(RD_VALOR) FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_FILIAL = %exp:cSuc% AND RD_MAT = %exp:cMat% AND RD_ROTEIR = 'RE3' AND RD_PERIODO = %exp:cPerRET%  AND %notdel%), 0) AS MAR,
		COALESCE((SELECT SUM(RD_VALOR) FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_FILIAL = %exp:cSuc% AND RD_MAT = %exp:cMat% AND RD_ROTEIR = 'RE4' AND RD_PERIODO = %exp:cPerRET%  AND %notdel%), 0) AS ABR
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON SRD.RD_PD = SRV.RV_COD
		WHERE SRD.RD_FILIAL = %exp:cSuc%
		AND SRD.RD_MAT = %exp:cMat%
		AND SRD.RD_PERIODO = %exp:cPerRET% 
		AND RV_TIPOCOD = '1'
		AND SRD.RD_ROTEIR IN ('RE2', 'RE3', 'RE4')
		AND SRD.%notdel%
		AND SRV.%notdel%
		) A
		GROUP BY RV_COD, RV_DESC

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while ( (OrdenConsul)->(!Eof()))
			aDados:={}
			AADD(aDados, "RETR. " + (OrdenConsul)->RV_DESC)

			If(SUBSTR(cMes1, 5, 2) == "02")//Si el primer mes es febrero
				AADD(aDados, (OrdenConsul)->FEB)
				AADD(aDados, (OrdenConsul)->MAR)
				AADD(aDados, (OrdenConsul)->ABR)
			ElseIf(SUBSTR(cMes1, 5, 2) == "03")//Si el primer mes es marzo
				AADD(aDados, (OrdenConsul)->MAR)
				AADD(aDados, (OrdenConsul)->ABR)
				AADD(aDados, 0)
			Else
				AADD(aDados, (OrdenConsul)->ABR)
				AADD(aDados, 0)
				AADD(aDados, 0)
			EndIf
			AADD(aRet, aDados)
			(OrdenConsul)->(dbSkip())
		End
	endIf

	restArea(aArea)
return aRet

Static Function getSalMes(cPer)
	Local aArea:= getArea()
	Local nRet:= 0
	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT RD_VALOR
		FROM SRD010 SRD
		JOIN SRV010 SRV ON SRD.RD_PD = SRV.RV_COD
		WHERE SRV.RV_CODFOL = '0031'
		AND SRD.RD_FILIAL = %exp:SRA->RA_FILIAL%
		AND SRD.RD_MAT = %exp:SRA->RA_MAT%
		AND SRD.RD_PERIODO = %exp:cPer%
		AND SRD.%notdel%
		AND SRV.%notdel%

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= (OrdenConsul)->RD_VALOR
	endIf

	restArea(aArea)
return nRet

/**
* @author: Denar Terrazas Parada
* @since: 08/26/2019
* @description: Funcion que devuelve la fecha de ingreso sumado los años de los quinquenios pagados
*/
Static Function getFchInd()
	Local aArea:= getArea()
	Local dRet:= SRA->RA_ADMISSA
	Local cPeriodo:= SUBSTR(DTOS(dDtPagoQui), 1, 6)
	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT SUM(RD_HORAS) RD_HORAS
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON RV_COD = RD_PD
		WHERE RD_ROTEIR = 'QUI'
		AND RV_CODFOL = '1274'
		AND RD_FILIAL = %exp:SRA->RA_FILIAL%
		AND RD_MAT = %exp:SRA->RA_MAT%
		AND RD_PERIODO < %exp:cPeriodo%
		AND SRD.%notdel%
		AND SRV.%notdel%

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		dRet:= YearSum(SRA->RA_ADMISSA, (OrdenConsul)->RD_HORAS)
	endIf

	restArea(aArea)
return dRet

/**
* @author: Denar Terrazas Parada
* @since: 08/26/2019
* @description: Funcion que devuelve la cantidad de años pagados en el quinquenio
*/
Static Function getQuiPg()
	Local aArea:= getArea()
	Local nRet:= 0
	Local cPeriodo:= SUBSTR(DTOS(dDtPagoQui), 1, 6)
	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT RD_HORAS
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON RV_COD = RD_PD
		WHERE RD_ROTEIR = 'QUI'
		AND RV_CODFOL = '1274'
		AND RD_FILIAL = %exp:SRA->RA_FILIAL%
		AND RD_MAT = %exp:SRA->RA_MAT%
		AND RD_PERIODO = %exp:cPeriodo%
		AND SRD.%notdel%
		AND SRV.%notdel%
		UNION
		SELECT RC_HORAS
		FROM %table:SRC% SRC
		JOIN %table:SRV% SRV ON RV_COD = RC_PD
		WHERE RC_ROTEIR = 'QUI'
		AND RV_CODFOL = '1274'
		AND RC_FILIAL = %exp:SRA->RA_FILIAL%
		AND RC_MAT = %exp:SRA->RA_MAT%
		AND RC_PERIODO = %exp:cPeriodo%
		AND SRC.%notdel%
		AND SRV.%notdel%

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= (OrdenConsul)->RD_HORAS
	endIf
	restArea(aArea)
return nRet
