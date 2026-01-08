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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IMPRESBOL ³Autor  ³Microsiga             ³ Data ³  11/04/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc.     ³Impressao da Rescisao em modo Grafico. (Localizacao Bolivia)  ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPER140                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³  Chamado  ³  Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³M. Silveira ³19/04/13³TGMYKX		³Corrigido o liquido do termo que agora ³±±
±±³			   ³		³     		³corresponde ao valor gerado na rescisao³±±
±±³M. Silveira ³27/05/13³THDSE5		³Tratamento do campo RA_NOMECMP.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function IMPRESBOL()

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
	Local nBsAgNavidad  := 0
	Local nBsVacacion	:= 0
	Local nBsPrima		:= 0
	Local nHVacacion	:= 0
	Local nCont			:= 0
	Local nAte			:= 6
	Local nLinha		:= 0
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
	Local dDateRetiro	:= ""
	Local dFchaIngr		:= getFchInd()
	Local nAumento		:= 1//1.5//1.449843260188088// 1.21473354
	Local i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oFont08, oFont08n, oFont09, oFont11, oFont10n, oFont28n

	oFont08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	oFont09	:= TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
	oFont11	:= TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
	oFont08n:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	 //Negrito
	oFont10n:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)	 //Negrito
	oFont28n:= TFont():New("Times New Roman",28,28,,.T.,,,,.T.,.F.)    //Negrito

	nEpoca:= SET(5,1910)
	//-- MUDAR ANO PARA 4 DIGITOS
	SET CENTURY ON

	cIdade := AllTrim(Str(Calc_Idade(SRA->RA_DEMISSA, SRA->RA_NASC)))
	//aTempoServico := DateDiffYMD( dFchaIngr/*SRA->RA_ADMISSA*/ , SRA->RA_DEMISSA )

	dDataRef := SRG->RG_DTGERAR
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
	dDateRetiro	:= SRA->RA_DEMISSA

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

	oPrint:say ( INT(0145 * nAumento), 0930, STR0001, oFont28n )	//"FINIQUITO"
	oPrint:line( INT(0375 * nAumento), 0060, INT(0375 * nAumento), nColMax-21 )		//Linha Horizontal
	oPrint:line( INT(0380 * nAumento), 0060, INT(0380 * nAumento), nColMax-21 )		//Linha Horizontal

	oPrint:say ( INT(0400 * nAumento), 0068, STR0002, oFont09 ) 	//"I - DATOS GENERALES"
	oPrint:Box ( INT(0456 * nAumento), 0062, INT(0880 * nAumento), nColMax-21 )    				//Box
	oPrint:say ( INT(0464 * nAumento), 0064, STR0003+/*aInfo[3]*/ TRIM(FWCompanyName()) + " - " + TRIM(FWFilName(FWCodEmp(), SRA->RA_FILIAL)), oFont09 )		//"RAZON SOCIAL O NOMBRE DE LA EMPRESA: "
	oPrint:line ( INT(0456 * nAumento), 1950, INT(0509 * nAumento), 1950)
	oPrint:line ( INT(0456 * nAumento), 2150, INT(0509 * nAumento), 2150)
	oPrint:line( INT(0509 * nAumento), 0062, INT(0509 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( INT(0517 * nAumento), 0064, STR0004+ cActividad, oFont09 )		//"RAMA DE ACTIVIDAD ECONOMICA: "
	oPrint:line ( INT(0509 * nAumento), 0950, INT(0562 * nAumento), 0950)
	oPrint:line ( INT(0509 * nAumento), 1050, INT(0562 * nAumento), 1050)
	oPrint:line ( INT(0509 * nAumento), 1200, INT(0562 * nAumento), 1200)
	oPrint:say ( INT(0517 * nAumento), 1210, STR0005 + /*aInfo[4]*/ AllTrim(UPPER(SM0->M0_ENDENT)), oFont09 )		//"DOMICILIO: "
	oPrint:line( INT(0562 * nAumento), 0062, INT(0562 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( INT(0570 * nAumento), 0064, STR0006+(cNomeFun), oFont09 )    //"NOMBRE DEL TRABAJADOR: "
	oPrint:line ( INT(0562 * nAumento), 1950, INT(0615 * nAumento), 1950)
	oPrint:line ( INT(0562 * nAumento), 2150, INT(0615 * nAumento), 2150)
	oPrint:line( INT(0615 * nAumento), 0062, INT(0615 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say ( INT(0623 * nAumento), 0064, STR0007+;
	(Substr(TrmDesc("SX5","33"+SRA->RA_ESTCIVI,"SX5->X5_DESCSPA"),1,15)), oFont09 )    //"ESTADO CIVIL: "
	oPrint:line ( INT(0615 * nAumento), 0825, INT(0668 * nAumento), 0825)
	oPrint:line ( INT(0615 * nAumento), 0950, INT(0668 * nAumento), 0950)
	oPrint:say  ( INT(0623 * nAumento), 0960, STR0008+cIdade, oFont09 )    //"EDAD:"
	oPrint:line ( INT(0615 * nAumento), 1300, INT(0668 * nAumento), 1300)
	oPrint:line ( INT(0615 * nAumento), 1400, INT(0668 * nAumento), 1400)
	oPrint:say  ( INT(0626 * nAumento), 1418, STR0005+SRA->RA_ENDEREC, oFont09 )    //"DOMICILIO:"
	oPrint:line ( INT(0668 * nAumento), 0062, INT(0668 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say  ( INT(0676 * nAumento), 0064, STR0009+fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC"), oFont09 )//"PROFESION U OCUPACION: "
	oPrint:line ( INT(0668 * nAumento), 1950, INT(0721 * nAumento), 1950)
	oPrint:line ( INT(0668 * nAumento), 2150, INT(0721 * nAumento), 2150)
	oPrint:line ( INT(0721 * nAumento), 0062, INT(0721 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say  ( INT(0729 * nAumento), 0064, STR0010 + TRIM(SRA->RA_CIC) + " " + TRIM(SRA->RA_UFCI), oFont09 )    //"CI: "
	oPrint:line ( INT(0721 * nAumento), 0600, INT(0774 * nAumento), 0600)
	oPrint:say  ( INT(0729 * nAumento), 0610, STR0011+DtoC(dFchaIngr)/*DtoC(SRA->RA_ADMISSA)*/, oFont09 )    //"FECHA DE INGRESO: "
	oPrint:line ( INT(0721 * nAumento), 1400, INT(0774 * nAumento), 1400)
	oPrint:say  ( INT(0729 * nAumento), 1410, STR0012+DtoC(SRA->RA_DEMISSA), oFont09 )    //"FECHA DE RETIRO"
	oPrint:line ( INT(0774 * nAumento), 0062, INT(0774 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:say  ( INT(0782 * nAumento), 0064, STR0013+cCausa, oFont09 )    //"MOTIVO DEL RETIRO: "
	oPrint:line ( INT(0774 * nAumento), 1050, INT(0827* nAumento), 1050)
	oPrint:line ( INT(0774 * nAumento), 1200, INT(0827* nAumento), 1200)
	oPrint:say  ( INT(0782 * nAumento), 1210, STR0014+AllTrim(Str(SRA->RA_SALARIO)), oFont09 )    //"REMUNERACION MENSUAL Bs: "
	oPrint:line ( INT(0774 * nAumento), 2150, INT(0880 * nAumento), 2150)
	oPrint:line ( INT(0827 * nAumento), 0062, INT(0827 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	
	RetHoraVal( "0757", @cHoras, @nValor, @cDesc )
	oPrint:say  ( INT(0835 * nAumento), 0064, STR0015, oFont09 )    //"TIEMPO DE SERVICIO: "
	oPrint:say  ( INT(0835 * nAumento), 0450, /*AllTrim(Str(aTempoServico[1]))*/Transform(Val(cHoras), "999"), oFont09 )
	oPrint:say  ( INT(0835 * nAumento), 0500, STR0016, oFont09 )    //"ANOS"
	RetHoraVal( "0758", @cHoras, @nValor, @cDesc )
	oPrint:say  ( INT(0835 * nAumento), 0650, /*AllTrim(Str(aTempoServico[2]))*/Transform(Val(cHoras), "999"), oFont09 )
	oPrint:say  ( INT(0835 * nAumento), 0700, STR0017, oFont09 )    //"MESES"
	RetHoraVal( "0759", @cHoras, @nValor, @cDesc )
	oPrint:say  ( INT(0835 * nAumento), 0850, /*AllTrim(Str(aTempoServico[3]+1))*/Transform(Val(cHoras), "999"), oFont09 )
	oPrint:say  ( INT(0835 * nAumento), 0900, STR0018, oFont09 )    //"DIAS"
	
	oPrint:line ( INT(0827 * nAumento), 1850, INT(0880 * nAumento), 1850)
	oPrint:line ( INT(0827 * nAumento), 1950, INT(0880 * nAumento), 1950)
	oPrint:line ( INT(0902 * nAumento), 0062, INT(0902 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:line ( INT(0907 * nAumento), 0062, INT(0907 * nAumento), nColMax-21 ) 		   		//Linha Horizontal

	oPrint:say  ( INT(0924* nAumento), 0068, STR0019, oFont09 )		//"II - LIQUIDACION DE LA REMUNERACION PROMEDIO INDEMNIZABEL EN BASE A LOS 3 ULTIMO MESES"
	oPrint:line ( INT(0977* nAumento), 0062, INT(0977 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	oPrint:line ( INT(0982* nAumento), 0062, INT(0982 * nAumento), nColMax-21 ) 		   		//Linha Horizontal
	//oPrint:Box  ( 1004, 0062, 1466, nColMax-21 )    				//Box
	//oPrint:line ( 1004, 0500, 1466, 0500)						//Linhas Verticais
	//oPrint:line ( 1004, 0950, 1466, 0950)
	//oPrint:line ( 1004, 1400, 1466, 1400)
	//oPrint:line ( 1004, 1850, 1466, 1850)
	oPrint:say ( INT(1012 * nAumento), 0064, STR0020, oFont09 )    //"A)MESES"
	oPrint:say ( INT(1012 * nAumento), 2020, STR0021, oFont09 )    //"TOTALES"
	oPrint:line( INT(1057 * nAumento), 0062, INT(1057 * nAumento), nColMax-21 ) 		   	//Linha Horizontal

	If RetHoraVal( "0760", @cHoras, @nValor, @cDesc, @cMesMed )
		If !Empty(cMesMed)
			oPrint:say ( INT(1012 * nAumento), 1600, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		oPrint:say ( INT(1065 * nAumento), 1600, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot3Remun := nValor
		nTotRemuner+= nValor

		RetHoraVal( "0755", @cHoras, @nValor, @cDesc, @cMesMed )
		If !Empty(cMesMed)
			oPrint:say ( INT(1012 * nAumento), 0630, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValorAux:= nValor

		RetHoraVal( "0754", @cHoras, @nValor, @cDesc, @cMesMed )
		nValorAux += nValor
		oPrint:say ( INT(1065 * nAumento), 0650, Transform(nValorAux, "@E 99,999,999.99"), oFont08)
		nTot1Remun := nValorAux
		nTotRemuner+= nValorAux

		RetHoraVal( "0756", @cHoras, @nValor, @cDesc, @cMesMed )
		If !Empty(cMesMed)
			oPrint:say ( INT(1012 * nAumento), 1100, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		oPrint:say ( INT(1065 * nAumento), 1150, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot2Remun := nValor
		nTotRemuner+= nValor
	Else
		RetHoraVal( "0754", @cHoras, @nValor, @cDesc, @cMesMed )
		if(Empty(AllTrim(cMesMed)))
			cMesMed:= SUBSTR(DTOS(MonthSub(dDateRetiro, 3)), 1, 6)
		endIf
		If !Empty(cMesMed)
			cMes1:= cMesMed
			oPrint:say ( INT(1012 * nAumento), 0630, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValor:= getSalMes(SRA->RA_MAT, cMesMed)
		oPrint:say ( INT(1065 * nAumento), 0650, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot1Remun := nValor
		nTotRemuner+= nValor

		RetHoraVal( "0755", @cHoras, @nValor, @cDesc, @cMesMed )
		if(Empty(AllTrim(cMesMed)))
			cMesMed:= SUBSTR(DTOS(MonthSub(dDateRetiro, 2)), 1, 6)
		endIf
		If !Empty(cMesMed)
			cMes2:= cMesMed
			oPrint:say ( INT(1012 * nAumento), 1100, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValor:= getSalMes(SRA->RA_MAT, cMesMed)
		oPrint:say ( INT(1065 * nAumento), 1150, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot2Remun := nValor
		nTotRemuner+= nValor

		RetHoraVal( "0756", @cHoras, @nValor, @cDesc, @cMesMed )
		if(Empty(AllTrim(cMesMed)))
			cMesMed:= SUBSTR(DTOS(MonthSub(dDateRetiro, 1)), 1, 6)
		endIf
		If !Empty(cMesMed)
			cMes3:= cMesMed
			oPrint:say ( INT(1012 * nAumento), 1600, Upper(FDESC_MES(Val(SubsTr(cMesMed,5,2)))), oFont08)
		EndIf
		nValor:= getSalMes(SRA->RA_MAT, cMesMed)
		oPrint:say ( INT(1065 * nAumento), 1600, Transform(nValor, "@E 99,999,999.99"), oFont08)
		nTot3Remun := nValor
		nTotRemuner+= nValor
	Endif

	oPrint:say  ( INT(1065 * nAumento), 0064, STR0022, oFont09 )    //"REMUNERACION MENSUAL"
	oPrint:line ( INT(1057 * nAumento), 0600, INT(1110 * nAumento), 0600)						//Linha Vertical
	oPrint:line ( INT(1057 * nAumento), 1050, INT(1110 * nAumento), 1050) 						//Linha Vertical
	oPrint:line ( INT(1057 * nAumento), 1500, INT(1110 * nAumento), 1500) 						//Linha Vertical
	oPrint:line ( INT(1057 * nAumento), 1950, INT(1110 * nAumento), 1950) 						//Linha Vertical
	oPrint:say  ( INT(1065 * nAumento), 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say  ( INT(1065 * nAumento), 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say  ( INT(1065 * nAumento), 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say  ( INT(1065 * nAumento), 1860, STR0023, oFont09 )    //"Bs"

	oPrint:say ( INT(1065 * nAumento), 2000, Transform(nTotRemuner, "@E 99,999,999.99"), oFont08)
	oPrint:line( INT(1110 * nAumento), 0062, INT(1110 * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:say ( INT(1118 * nAumento), 0064, STR0024, oFont09 )    //"B)OTROS CONCEPTOS"
	oPrint:say ( INT(1156 * nAumento), 0064, STR0025, oFont09 )    //"PERCIBIDOS EN EL MES"
	oPrint:line( INT(1201 * nAumento), 0062, INT(1201 * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	/*oPrint:say ( 1209, 0510, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(1209 * nAumento), 0960, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(1209 * nAumento), 1410, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(1209 * nAumento), 1860, STR0023, oFont09 )    //"Bs"*/

	aPDVal:= getPDs(SRA->RA_MAT, cMes1, cMes2, cMes3)
	nLine:= 1209
	for i:= 1 to Len(aPDVal)
		oPrint:say ( INT(nLine * nAumento), 0510, STR0023, oFont09 )    //"Bs"
		oPrint:say ( INT(nLine * nAumento), 0960, STR0023, oFont09 )    //"Bs"
		oPrint:say ( INT(nLine * nAumento), 1410, STR0023, oFont09 )    //"Bs"
		oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"

		oPrint:say ( INT(nLine * nAumento), 0064, aPDVal[i][NDESC], oFont09 )
		oPrint:say ( INT(nLine * nAumento), 0650, Transform(aPDVal[i][NMES1], "@E 99,999,999.99"), oFont08 )
		nTot1Remun+= aPDVal[i][NMES1]
		oPrint:say ( INT(nLine * nAumento), 1150, Transform(aPDVal[i][NMES2], "@E 99,999,999.99"), oFont08 )
		nTot2Remun+= aPDVal[i][NMES2]
		oPrint:say ( INT(nLine * nAumento), 1600, Transform(aPDVal[i][NMES3], "@E 99,999,999.99"), oFont08 )
		nTot3Remun+= aPDVal[i][NMES3]
		oPrint:say ( INT(nLine * nAumento), 2000, Transform(aPDVal[i][NMES1] + aPDVal[i][NMES2] + aPDVal[i][NMES3], "@E 99,999,999.99"), oFont08 )	//TOTAL
		oPrint:line( INT((nLine + 45) * nAumento), 0062, INT((nLine + 45) * nAumento), nColMax-21 ) 		   	//Linha Horizontal
		nLine+= 53
	next i
	oPrint:line ( INT(1201 * nAumento), 0600, INT((nLine -8) * nAumento), 0600)						//Linha Vertical
	oPrint:line ( INT(1201 * nAumento), 1050, INT((nLine -8) * nAumento), 1050) 						//Linha Vertical
	oPrint:line ( INT(1201 * nAumento), 1500, INT((nLine -8) * nAumento), 1500) 						//Linha Vertical
	oPrint:line ( INT(1201 * nAumento), 1950, INT((nLine -8) * nAumento), 1950) 						//Linha Vertical
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

	oPrint:Box  ( INT(1004 * nAumento), 0062, INT((nLine + 40) * nAumento), nColMax-21 )    				//Box
	oPrint:line ( INT(1004 * nAumento), 0500, INT((nLine + 40) * nAumento), 0500)						//Linhas Verticais
	oPrint:line ( INT(1004 * nAumento), 0950, INT((nLine + 40) * nAumento), 0950)
	oPrint:line ( INT(1004 * nAumento), 1400, INT((nLine + 40) * nAumento), 1400)
	oPrint:line ( INT(1004 * nAumento), 1850, INT((nLine + 40) * nAumento), 1850)

	oPrint:say ( INT(nLine * nAumento), 0064, STR0039, oFont09 )    //"TOTAL Bs"
	oPrint:say ( INT(nLine * nAumento), 0650, Transform(nTot1Remun, "@E 99,999,999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1150, Transform(nTot2Remun, "@E 99,999,999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1600, Transform(nTot3Remun, "@E 99,999,999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nTotRemuner,"@E 99,999,999.99"), oFont08)
	nLine+= 50
	oPrint:line ( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( INT(nLine * nAumento), 1850, INT((nLine + 70) * nAumento), 1850) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), nColMax-21, INT((nLine + 70) * nAumento), nColMax-21) 		//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), nColMax-26, INT((nLine + 70) * nAumento), nColMax-26) 		//Linha Vertical
	nLine+= 17
	oPrint:say ( INT(nLine * nAumento), 0068, STR0027, oFont09 )		//"III - TOTAL REMUNERACION PROMEDIO INDEMNIZABLE (A+B) DIVIDIDO ENTRE 3:"
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	RetHoraVal( "0761", @cHoras, @nValor, @cDesc )
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nValor, "@E 99,999,999.99"), oFont08 )
	nLine+= 53

	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 5
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 22
	oPrint:Box  ( INT(nLine * nAumento), 0062, INT((nLine + 484) * nAumento), nColMax-21 )    			//Box
	oPrint:line ( INT(nLine * nAumento), 1850, INT((nLine + 484) * nAumento), 1850) 						//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1950, INT((nLine + 484) * nAumento), 1950) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0028, oFont09 )		//"C)DESAHUCIO TRES MESES (EN CASO DE RETIRO FORSOZO)"
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	RetHoraVal( "0768", @cHoras, @nValor, @cDesc )
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nValor, "@E 99,999,999.99"), oFont08 )
	nLine+= 52
	nTotBenSocial+= nValor
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line( INT(nLine * nAumento), 0850, INT((nLine + 318) * nAumento), 0850)						//Linha Vertical
	oPrint:line( INT(nLine * nAumento), 0950, INT((nLine + 318) * nAumento), 0950) 						//Linha Vertical
	oPrint:line( INT(nLine * nAumento), 1200, INT((nLine + 318) * nAumento), 1200) 						//Linha Vertical
	oPrint:line( INT(nLine * nAumento), 1375, INT((nLine + 318) * nAumento), 1375) 						//Linha Vertical
	oPrint:line( INT(nLine * nAumento), 1500, INT((nLine + 159) * nAumento), 1500) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0029, oFont09 )    //"D)INDEMNIZACION POR TIEMPO DE TRABAJO:"
	oPrint:say ( INT(nLine * nAumento), 0860, STR0030, oFont09 )    //"DE"
	//-------------------------------------------------------------
	RetHoraVal( "0757", @cHoras, @nValor, @cDesc )
	oPrint:say ( INT(nLine * nAumento), 1000, Transform(Val(cHoras), "999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1210, STR0016, oFont09 )    //"ANOS"
	oPrint:say ( INT(nLine * nAumento), 1385, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 1550, Transform(nValor, "@E 99,999,999.99"), oFont08)
	nTotBenSocial+= nValor
	nTotD123 += nValor

	RetHoraVal( "0759", @cHoras, @nValor, @cDesc )
	nTotD123 += nValor
	RetHoraVal( "0758", @cHoras, @nValor, @cDesc )
	nTotD123 += nValor

	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nTotD123, "@E 99,999,999.99"), oFont08)
	nLine+= 45

	//-------------------------------------------------------------
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0860, STR0030, oFont09 )    //"DE"
	oPrint:say ( INT(nLine * nAumento), 1000, Transform(Val(cHoras), "999.99"), oFont08 )
	oPrint:say ( INT(nLine * nAumento), 1210, STR0017, oFont09 )    //"MESES"
	oPrint:say ( INT(nLine * nAumento), 1385, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 1550, Transform(nValor, "@E 99,999,999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	nTotBenSocial+= nValor
	//-------------------------------------------------------------
	RetHoraVal( "0759", @cHoras, @nValor, @cDesc )
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0860, STR0030, oFont09 )    //"DE"
	oPrint:say ( INT(nLine * nAumento), 1000, Transform(Val(cHoras), "999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1210, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( INT(nLine * nAumento), 1385, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 1550, Transform(nValor, "@E 99,999,999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(0, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	nTotBenSocial+= nValor
	//-------------------------------------------------------------
	oPrint:line ( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( INT(nLine * nAumento), 1675, INT((nLine + 159) * nAumento), 1675) 						//Linha Vertical
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0031, oFont09 )    //"AGUINALDO DE NAVIDAD"
	oPrint:say ( INT(nLine * nAumento), 0860, STR0030, oFont09 )    //"DE"
	RetHoraVal( "0762", @cHoras, @nValor, @cDesc )
	oPrint:say ( INT(nLine * nAumento), 1000, Transform(Val(cHoras), "999.99"), oFont08)
	nBsAgNavidad+= nValor
	oPrint:say ( INT(nLine * nAumento), 1210, STR0032, oFont09 )    //"MESES Y"
	RetHoraVal( "0763", @cHoras, @nValor, @cDesc )
	oPrint:say ( INT(nLine * nAumento), 1500, Transform(Val(cHoras), "999.99"), oFont08)
	nBsAgNavidad+= nValor
	oPrint:say ( INT(nLine * nAumento), 1685, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nBsAgNavidad, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	nTotBenSocial+= nBsAgNavidad
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0033, oFont09 )    //"VACACION"
	oPrint:say ( INT(nLine * nAumento), 0860, STR0030, oFont09 )    //"DE"

	RetHoraVal( "0086", @cHoras, @nValor, @cDesc )  // 764
	oPrint:say ( INT(nLine * nAumento), 1040, Transform(0, "999.99"), oFont08)
	nHVacacion+= Val(cHoras)
	nBsVacacion+= nValor
	oPrint:say ( INT(nLine * nAumento), 1210, STR0032, oFont09 )    //"MESES Y"

	RetHoraVal( "0087", @cHoras, @nValor, @cDesc )  // 765
	nHVacacion+= Val(cHoras)
	nBsVacacion+= nValor
	oPrint:say ( INT(nLine * nAumento), 1500, Transform(nHVacacion, "999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1685, STR0018, oFont09 )    //"DIAS"

	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nBsVacacion, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	nTotBenSocial+= nBsVacacion
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0034, oFont09 )    //"PRIMA LEGAL (SI CORRESPONDE)"
	oPrint:say ( INT(nLine * nAumento), 0860, STR0030, oFont09 )    //"DE"
	RetHoraVal( "0766", @cHoras, @nValor, @cDesc )
	nBsPrima+= nValor
	oPrint:say ( INT(nLine * nAumento), 1040, Transform(Val(cHoras), "999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1210, STR0032, oFont09 )    //"MESES Y"
	RetHoraVal( "0767", @cHoras, @nValor, @cDesc )
	nBsPrima+= nValor
	oPrint:say ( INT(nLine * nAumento), 1500, Transform(Val(cHoras), "999.99"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1685, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nBsPrima, "@E 99,999,999.99"), oFont08)
	nLine+= 45
	nTotBenSocial+= nBsPrima
	oPrint:line ( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 	//Linha Horizontal
	oPrint:line ( INT(nLine * nAumento), 0200, INT((nLine + 53) * nAumento), 0200)	//Linha Vertical
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0035, oFont09 ) 	//"OTROS"
	RetHoraVal( "0084", @cHoras, @nValor, @cDesc )
	nVal:=nValor
	RetHoraVal( "0779", @cHoras, @nValor, @cDesc )
	nVal+=nValor
	//RetHoraVal( "1211", @cHoras, @nValor, @cDesc )
	//nVal+=nValor
	//Proventos da rescisao que nao estao na media dos ultimos 3 meses (ex. Quinquenio Rescisao)
	RetHoraVal( "9999", @cHoras, @nValor, @cDesc )
	nVal+=nValor
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nVal, "@E 99,999,999.99"), ofont08)
	nLine+= 45
	nTotBenSocial+= nVal
	oPrint:line ( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( INT(nLine * nAumento), 0370, INT((nLine + 53) * nAumento), 0370)			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 0750, INT((nLine + 53) * nAumento), 0750)			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1200, INT((nLine + 53) * nAumento), 1200) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1300, INT((nLine + 53) * nAumento), 1300) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1675, INT((nLine + 53) * nAumento), 1675) 			//Linha Vertical
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, "SUELDO MES " + Transform(Year(SRA->RA_DEMISSA),"9999"), oFont08)
	//oPrint:say ( INT(nLine * nAumento), 0200, Transform(Year(SRA->RA_DEMISSA),"9999"), oFont08)
	oPrint:say ( INT(nLine * nAumento), 0500, STR0036, oFont09 )    //"GESTION"
	oPrint:say ( INT(nLine * nAumento), 0800, MesExtenso(Month(SRA->RA_DEMISSA)), oFont08)
	oPrint:say ( INT(nLine * nAumento), 1210, STR0030, oFont09 )    //"DE
	RetHoraVal( "0048", @cHoras, @nValor, @cDesc )
	oPrint:say ( INT(nLine * nAumento), 1450, Transform(Val(cHoras), "999.99"), oFont09)
	oPrint:say ( INT(nLine * nAumento), 1685, STR0018, oFont09 )    //"DIAS"
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nValor, "@E 99,999,999.99"), ofont08)
	nLine+= 50
	nTotBenSocial+= nValor
	oPrint:line ( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( INT(nLine * nAumento), 1950, INT((nLine + 75) * nAumento), 1950) 			//Linha Vertical

	oPrint:line ( INT(nLine * nAumento), nColMax-21, INT((nLine + 70) * nAumento), nColMax-21) 		//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), nColMax-26, INT((nLine + 70) * nAumento), nColMax-26) 		//Linha Vertical
	nLine+= 17

	oPrint:say ( INT(nLine * nAumento), 0068, STR0037, oFont09 )		//"IV. - TOTAL BENEFICIOS SOCIALES: C+D"
	oPrint:say ( INT(nLine * nAumento), 1860, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nTotBenSocial, "@E 99,999,999.99"), oFont08)
	nLine+= 53
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 5
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 22
	oPrint:Box  ( INT(nLine * nAumento), 0062, INT((nLine + 318) * nAumento), nColMax-21 )    	//Box
	oPrint:line ( INT(nLine * nAumento), 0370, INT((nLine + 318) * nAumento), 0370)				//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1050, INT((nLine + 318) * nAumento), 1050) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1200, INT((nLine + 318) * nAumento), 1200) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1675, INT((nLine + 318) * nAumento), 1675) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1950, INT((nLine + 318) * nAumento), 1950) 			//Linha Vertical
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 0064, STR0038, oFont09 )	//"E)DEDUCCIONES:"
	oPrint:say ( INT(nLine * nAumento), 1060, STR0023, oFont09 )    //"Bs"
	nLinha:= nLine
	If !(len(aPdd) < 1)
		If len(aPdd)<= 6
			nAte:= len(aPdd)
		Else
			nAte:= 6
		Endif

		For nCont:=1 to nAte
			oPrint:say ( INT(nLinha * nAumento), 0380, aPdd[nCont][2], oFont08)
			oPrint:say ( INT(nLinha * nAumento), 1300, Transform(aPdd[nCont][3],"@E 99,999,999.99"), oFont08)
			nLinha+=53
			nTotDeduccion+= aPdd[nCont][3]
		Next nCont
		//nLine+= nLinha - 53
	Endif
	nLine+= 45
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 1060, STR0023, oFont09 )    //"Bs"
	nLine+= 45
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 8
	oPrint:say ( INT(nLine * nAumento), 1060, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 1685, STR0039, oFont09 )    //"TOTAL Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nTotDeduccion, "@E 99,999,999.99"), oFont08)
	nLine+= 50
	oPrint:line ( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	oPrint:line ( INT(nLine * nAumento), 1850, INT((nLine + 70) * nAumento), 1850) 			//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), 1855, INT((nLine + 70) * nAumento), 1855) 			//Linha Vertical

	oPrint:line ( INT(nLine * nAumento), nColMax-21, INT((nLine + 70) * nAumento), nColMax-21) 		//Linha Vertical
	oPrint:line ( INT(nLine * nAumento), nColMax-26, INT((nLine + 70) * nAumento), nColMax-26) 		//Linha Vertical
	nLine+= 17

	oPrint:say ( INT(nLine * nAumento), 0064, STR0040, oFont09 )    //"V. IMPORTE LIQUIDO A PAGAR C+D-E="
	oPrint:say ( INT(nLine * nAumento), 1865, STR0023, oFont09 )    //"Bs"
	oPrint:say ( INT(nLine * nAumento), 2000, Transform(nTotBenSocial-nTotDeduccion, "@E 99,999,999.99"), oFont08)
	nLine+= 53
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal
	nLine+= 5
	oPrint:line( INT(nLine * nAumento), 0062, INT(nLine * nAumento), nColMax-21 ) 		   	//Linha Horizontal

	//Cuadros
	/*oPrint:Box ( INT(0020 * nAumento), 0035, INT(3000 * nAumento), nColMax )
	oPrint:Box ( INT(0027 * nAumento), 0045, INT(2988 * nAumento), nColMax-7 )*/
	oPrint:Box ( INT(0020 * nAumento), 0035, INT(2500 * nAumento), nColMax )
	oPrint:Box ( INT(0027 * nAumento), 0045, INT(2493 * nAumento), nColMax-7 )

	oPrint:EndPage()
	oPrint:StartPage()

	/*oPrint:Box ( 0020, 0035, 3000, nColMax )
	oPrint:Box ( 0027, 0045, 2988, nColMax-7 )*/
	oPrint:Box ( INT(0020 * nAumento), 0035, INT(2500 * nAumento), nColMax )
	oPrint:Box ( INT(0027 * nAumento), 0045, INT(2493 * nAumento), nColMax-7 )

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

	oPrint:say ( 0750, 0100, STR0053+" "+aInfo[5], oFont09 )    //"LUGAR Y FECHA"
	oPrint:say ( 0750, 0800, Transform(Day(SRG->RG_DTGERAR),"99"), oFont09)
	oPrint:say ( 0750, 0850, ",", oFont09 )
	oPrint:say ( 0750, 1000, STR0030, oFont09 )    //"DE"
	oPrint:say ( 0750, 1070, MesExtenso(Month(SRG->RG_DTGERAR)), oFont09)
	oPrint:say ( 0750, 1500, STR0030, oFont09 )    //"DE"
	oPrint:say ( 0750, 1570, Transform(Year(SRG->RG_DTGERAR),"9999"), oFont09)
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

		SELECT DISTINCT RV_COD, RV_DESC,
		COALESCE((SELECT RD_VALOR FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_MAT = %exp:cMat% AND RD_PERIODO = %exp:cMes1% AND %notdel%), 0) AS MES1,
		COALESCE((SELECT RD_VALOR FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_MAT = %exp:cMat% AND RD_PERIODO = %exp:cMes2% AND %notdel%), 0) AS MES2,
		COALESCE((SELECT RD_VALOR FROM %table:SRD% WHERE RD_PD = SRD.RD_PD AND RD_MAT = %exp:cMat% AND RD_PERIODO = %exp:cMes3% AND %notdel%), 0) AS MES3
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON SRD.RD_PD = SRV.RV_COD
		WHERE SRV.RV_TIPOCOD = '1'
		AND SRV.RV_CODFOL NOT IN ('1276', '0740', '0739', '0738', '0741', '0031')
		AND SRD.RD_MAT = %exp:cMat%
		AND SRD.RD_PERIODO IN (%exp:cMes1%, %exp:cMes2%, %exp:cMes3%)
		AND SRD.%notdel%
		AND SRV.%notdel%

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

Static Function getSalMes(cMat, cPer)
	Local aArea:= getArea()
	Local nRet:= 0
	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT RD_VALOR
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON SRD.RD_PD = SRV.RV_COD
		WHERE SRV.RV_CODFOL = '0031'
		AND SRD.RD_MAT = %exp:cMat%
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
	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT RD_HORAS
		FROM (
		SELECT RD_HORAS
		FROM %table:SRD% SRD
		JOIN %table:SRV% SRV ON RV_COD = RD_PD
		WHERE RD_ROTEIR = 'QUI'
		AND RV_CODFOL = '1274'
		AND RD_FILIAL = %exp:SRA->RA_FILIAL%
		AND RD_MAT = %exp:SRA->RA_MAT%
		AND SRD.%notdel%
		AND SRV.%notdel%
		UNION ALL
		SELECT RC_HORAS
		FROM %table:SRC% SRC
		JOIN %table:SRV% SRV ON RV_COD = RC_PD
		WHERE RC_ROTEIR = 'QUI'
		AND RV_CODFOL = '1274'
		AND RC_FILIAL = %exp:SRA->RA_FILIAL%
		AND RC_MAT = %exp:SRA->RA_MAT%
		AND SRC.%notdel%
		AND SRV.%notdel%
		) AS A
		WHERE RD_HORAS IS NOT NULL

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		dRet:= YearSum(SRA->RA_ADMISSA, (OrdenConsul)->RD_HORAS)
	endIf

	restArea(aArea)
return dRet
