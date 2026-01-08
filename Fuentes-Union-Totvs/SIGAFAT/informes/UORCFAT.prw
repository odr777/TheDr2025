#Include "RwMake.ch"
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RPPRE01  ºAutor  ³TdeP       º                  		  º±±
±±           ³  UORCFAT  ºModificado  ³Denar Terrazas  º Date 03/04/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de Proforma de Venta                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB	                                          		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UORCFAT()

	Private cPerg	:= "IMPRE"

	ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO

	//GraContPert()

	If funname() == 'MATA415'
		Pergunte(cPerg,.F.)
		mv_par01 := SCJ->CJ_EMISSAO
		mv_par02 := SCJ->CJ_EMISSAO
		mv_par03 := SCJ->CJ_CLIENTE
		mv_par04 := SCJ->CJ_CLIENTE
		mv_par05 := SCJ->CJ_NUM
		mv_par06 := SCJ->CJ_NUM
	Else
		Pergunte(cPerg,.T.)
	Endif

	Processa({|| fImpPres()},"Impresion (1) de aPRs ","Imprimindo aPRs...")

Return

Static Function fImpPres()

	Local lPrint	:= .f.
	Local nVias		:= 1
	Local nLin		:= 00.0
	Local cQuery
	Local consulta
	Local nTotal    := 00.0
	Local nDesc    := 00.0
	Local nRecargo := 00.0
	Local aDtHr		:= {}
	Local _aEtiq :={}
	Private nPag	:= 1

	Private tCJ_NUM := ""
	Private tA1_COD := ""
	Private tA1_LOJA := ""
	Private tA1_NOME := ""
	Private tA1_END := ""
	Private tA1_TEL := ""
	Private tCJ_EMISSAO := ""
	Private tCJ_UVEND := ""
	Private tA1_CGC := ""
	Private tCJ_MOEDA := ""
	Private tE4_DESCRI := ""
	Private tCJ_DESC1 := ""

	private valorBonificacion := 0.0
	private cBonusTes  := SuperGetMv("MV_BONUSTS")
	private nTes
	private nDescPor := 0.0
	private txmoeda
	private cFilal
	private nDesInd := 0  //porcentaje indemnizacion

	//Private tCJ_UTPOENT := ""
	//Private tCJ_ULUGENT := ""
	//Private tCJ_UOBSERV := ""
	//Private tCJ_USRREG := ""
	//Private nImpIteCli := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define as fontes a serem utilizadas na impressao                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFont09T  := TFont():New("Times New Roman",09,09,,.f.)
	oFont10T  := TFont():New("Times New Roman",10,10,,.f.)
	oFont12T  := TFont():New("Times New Roman",12,12,,.f.)
	oFont14T  := TFont():New("Times New Roman",14,14,,.f.)
	oFont16T  := TFont():New("Times New Roman",16,16,,.f.)
	oFont18T  := TFont():New("Times New Roman",18,18,,.f.)

	oFont10TN  := TFont():New("Times New Roman",10,10,,.t.)
	oFont12TN  := TFont():New("Times New Roman",12,12,,.t.)
	oFont14TN  := TFont():New("Times New Roman",14,14,,.t.)
	oFont16TN  := TFont():New("Times New Roman",16,16,,.t.)
	oFont18TN  := TFont():New("Times New Roman",18,18,,.t.)

	oFont10C  := TFont():New("Courier New",09,09,,.f.)
	oFont12C  := TFont():New("Courier New",12,12,,.f.)
	oFont14C  := TFont():New("Courier New",14,14,,.f.)
	oFont16C  := TFont():New("Courier New",16,16,,.f.)
	oFont18C  := TFont():New("Courier New",18,18,,.f.)

	oFont09CN  := TFont():New("Courier New",09,09,,.t.)
	oFont10CN  := TFont():New("Courier New",10,10,,.t.)
	oFont12CN  := TFont():New("Courier New",12,12,,.t.)
	oFont14CN  := TFont():New("Courier New",14,14,,.t.)
	oFont16CN  := TFont():New("Courier New",16,16,,.t.)
	oFont18CN  := TFont():New("Courier New",18,18,,.t.,,,,,.t.)
	oFont20CN  := TFont():New("Courier New",20,20,,.t.)
	oFont22CN  := TFont():New("Courier New",22,22,,.t.)
	oFont24CN  := TFont():New("Courier New",24,24,,.t.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia o uso da classe ...                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:= TMSPrinter():New("Proforma")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define pagina no formato paisagem ...        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:SetPortrait()
	oPrn:SetPaperSize(1)

	oPrn:Setup()

	cQuery := "SELECT CJ_FILIAL,CJ_TXMOEDA,CJ_EMISSAO,CJ_NUM,A1_COD,CJ_PDESCAB,CJ_UNOMCLI A1_NOME,A1_ENDCOB,A1_TEL,A1_CGC,A1_CGC A1_UNITCLI,CASE WHEN CJ_STATUS='A' THEN 'APROBADO' ELSE 'PENDIENTE' END CJ_STATUS,"
	cQuery += " CASE WHEN CJ_MOEDA=1 then 'BOLIVIANOS' ELSE 'DOLARES' END CJ_MOEDA,CK_PEDCLI,CK_PRODUTO,CK_DESCRI,B1_DESC,CK_UM,CK_QTDVEN,CJ_FRETE,CJ_DESPESA,CJ_SEGURO,"
	cQuery += " CK_PRUNIT CK_PRCVEN,CK_PRUNIT*CK_QTDVEN PRU_QTD, CK_VALOR,CK_OBS,CJ_VALIDA,CK_ENTREG,CK_VALDESC,CJ_DESC1,CK_ITEM,CK_ITECLI,CK_TES,CJ_UVEND,A1_LOJA,A1_UNOMFAC,E4_DESCRI,CJ_MOEDA CJMOEDA  "
	cQuery += " ,(SELECT ROUND((DSCTO/TOTAL) * 100.00,2) PDESC FROM (SELECT SUM(CK_VALOR) + SUM(CK_VALDESC) TOTAL, SUM(CK_VALDESC) DSCTO FROM "+RetSqlName("SCK")+" SCK1 "
	cQuery += " WHERE CK_NUM=SCJ.CJ_NUM AND CK_CLIENTE=SCJ.CJ_CLIENTE AND SCK1.D_E_L_E_T_!='*') A ) CJ_PDESC "
	cQuery += " FROM "+RetSqlName("SCJ")+" SCJ "
	cQuery += " INNER JOIN "+RetSqlName("SCK")+" SCK On CJ_FILIAL=CK_FILIAL and CJ_NUM=CK_NUM AND CJ_LOJA=CK_LOJA  AND CJ_CLIENTE =CK_CLIENTE "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 On CK_PRODUTO=B1_COD "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 On CJ_CLIENTE=A1_COD  AND A1_LOJA=CJ_LOJA and SA1.D_E_L_E_T_<>'*' "
	cQuery += " INNER JOIN " + RetSqlName("SE4") + " SE4 on E4_CODIGO=CJ_CONDPAG "
	cQuery += " WHERE CJ_FILIAL = '"+xFilial("SCJ")+"'" + " AND "
	cQuery += " A1_FILIAL = '"+xFilial("SA1")+"'" + " AND "
	cQuery += " CK_FILIAL = '"+xFilial("SCK")+"'" + " AND "
	cQuery += " CJ_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND A1_COD BETWEEN '"+mv_par03+"' AND '"+trim(mv_par04)+"'"
	cQuery += " AND CJ_NUM BETWEEN '"+mv_par05+"' AND '"+trim(mv_par06)+"'"
	cQuery += " AND SCK.D_E_L_E_T_<>'*' AND SB1.D_E_L_E_T_<>'*' "
	cQuery += " ORDER BY CJ_NUM,CK_ITEM"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//MemoWrite("ImpPresee.txt",cQuery)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³ Caso area de trabalho estiver aberta, fecha... ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	If !Empty(Select("CJPE"))
		dbSelectArea("CJPE")
		dbCloseArea()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³ Executa query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	TcQuery cQuery New Alias "CJPE"
	dbSelectArea("CJPE")
	dbGoTop()

	nLindet := 06.2
	nPag := 1
	cNroProforma:=""
	nMoneda:=0
	dfecha:=""
	cFilal := CJPE->CJ_FILIAL
	nPdesc := CJPE->CJ_PDESC
	nDesInd := CJPE->CJ_PDESCAB / 100
	While !EOF()
		nMoneda:= CJPE->CJMOEDA
		dfecha:= CJPE->CJ_EMISSAO

		If nPag == 1 .and. CJPE->CJ_NUM <> cNroProforma .and.cNroProforma==""
			cNroProforma := CJPE->CJ_NUM

			tCJ_NUM	:= CJPE->CJ_NUM
			tA1_COD := CJPE->A1_COD
			tA1_LOJA := CJPE->A1_LOJA
			tA1_NOME := CJPE->A1_NOME
			tA1_END	:= CJPE->A1_ENDCOB
			tA1_TEL	:= CJPE->A1_TEL
			tCJ_EMISSAO := CJPE->CJ_EMISSAO
			tCJ_UVEND := CJPE->CJ_UVEND
			tA1_CGC	:= CJPE->A1_CGC
			tCJ_MOEDA := CJPE->CJ_MOEDA
			tE4_DESCRI := CJPE->E4_DESCRI
			tCJ_DESC1 := IF(CJPE->CJ_DESC1<>0,CJPE->CJ_DESC1,CJPE->CJ_PDESC)

			oPrn:StartPage()
		ElseIf CJPE->CJ_NUM <> cNroProforma
			cNroProforma := CJPE->CJ_NUM

			nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha,nDesInd,nPdesc)
			fImpNota(nLindet)
			nPag++
			oPrn:EndPage()

			tCJ_NUM	:= CJPE->CJ_NUM
			tA1_COD := CJPE->A1_COD
			tA1_LOJA := CJPE->A1_LOJA
			tA1_NOME := CJPE->A1_NOME
			tA1_END	:= CJPE->A1_END
			tA1_TEL	:= CJPE->A1_TEL
			tCJ_EMISSAO :=CJPE->CJ_EMISSAO
			tCJ_UVEND := CJPE->CJ_UVEND
			tA1_CGC	:= CJPE->A1_CGC
			tCJ_MOEDA := CJPE->CJ_MOEDA
			tE4_DESCRI := CJPE->E4_DESCRI
			tCJ_DESC1 := IF(CJPE->CJ_DESC1<>0,CJPE->CJ_DESC1,CJPE->CJ_PDESC)

			oPrn:StartPage()
			nLin := 01.0
			nLin := fImpCabec(nLin)
			nLindet := 06.2
			nTotal    := 00.0
			nDesc    := 00.0
			nRecargo := 00.0
		EndIf

		IF nLindet == 06.2 .AND. nPag == 1
			nLin := 01.0
			nLin := fImpCabec(nLin)
		EndIf

		nLinha := MlCount(B1_DESC,40)

		nLinha2 := " "
		nLindet := fImpItem(nLindet)

		nDesc := nDesc + (CJPE->PRU_QTD - CJPE->CK_VALOR) // CJPE->CK_VALDESC
		nRecargo:=(CJPE->CJ_FRETE+CJPE->CJ_DESPESA+CJPE->CJ_SEGURO)
		txmoeda := CJPE->CJ_TXMOEDA

		nTes := CJPE->CK_TES
		if( nTes != cBonusTes)
			nTotal:=nTotal + CJPE->PRU_QTD
		else
			valorBonificacion  +=  CJPE->PRU_QTD
			nDescPor += CJPE->CK_VALDESC
		endif

		If nLindet > 23
			fImpPiePag()
			nPag+=1
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := 01.0
			nLin := fImpCabec(nLin)
			nLindet := 06.2
		Endif
		dbSkip()

	Enddo

	nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha,nDesInd,nPdesc)

	fImpNota(nLindet)

	oPrn:EndPage()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se visualiza ou imprime ...         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPrint

		While lPrint
			nDef := Aviso("Impressão de Presupuesto", "Confirma Impressão da Presupuesto?", {"Preview","Setup","Cancela","Ok"},,)
			If nDef == 1
				oPrn:Preview()
			ElseIf nDef == 2
				oPrn:Setup()
			ElseIf nDef == 3
				Return
			ElseIf nDef == 4
				lPrint := .f.
			EndIf
		End
		oPrn:Print()
	Else
		oPrn:Preview()
	EndIf

	CJPE->(dbCloseArea())

RETURN

Static Function fImpItem(nLin)
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), CJPE->CK_ITEM, oFont10C)

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.8), CJPE->CK_PRODUTO, oFont10C)

	oPrn:Say( Tpix(nLin+01.5), Tpix(04.5), CJPE->CK_DESCRI, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.5), CJPE->CK_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.7),Transform(CJPE->CK_QTDVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.2),Transform(CJPE->CK_PRCVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.6), Transform(CJPE->PRU_QTD,"@A 999,999,999.99"), oFont10C)

	If Len(AllTrim(CJPE->CK_OBS)) > 0
		nLin := nLin+00.3
		oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Left(CJPE->CK_OBS,45), oFont10C)
	EndIf
	If Len(AllTrim(CJPE->CK_OBS)) > 45
		nLin := nLin+00.3
		oPrn:Say( Tpix(nLin+01.5), Tpix(04.3), Right(CJPE->CK_OBS,35), oFont10C)
	EndIf

Return(nLin+00.3)

Static Function TPix(nTam,cBorder,cTipo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconta area nao imprimivel (Lexmark Optra T) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cBorder == "lb"			// Left Border
		nTam := nTam - 0.40
	ElseIf cBorder == "tb" 		// Top Border
		nTam := nTam - 0.60
	EndIf

	nPix := nTam * 120

Return(nPix)

Static Function fImpCabec(nLin)

	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabecera ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	local diasfin :=0
	local diasini :=0
	local direccion:=""
	local tel:=""

	//diasfin:=DateDiffDay(CTOD(CJ_VALIDA),CTOD(CJ_EMISSAO))  //substr(CJ_VALIDA,8,2)

	If SM0->(Eof())
		SM0->( MsSeek( cEmpAnt + cFilal , .T. ))
	Endif

	tel:= SM0->M0_TEL
	direccion:=SM0->M0_ENDENT
	//	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "CIMA SRL", oFont14CN)
	oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), "PRESUPUESTO DE VENTA", oFont18CN)

	cFLogo := GetSrvProfString("Startpath","") + "lgmid.png"
	oPrn:SayBitmap(Tpix(nLin+00.2), Tpix(01.0), cFLogo,200,150)

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), "Sucursal: " + upper(SM0->M0_FILIAL), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+01.5), Tpix(14.0), "Numero: " + tCJ_NUM								 			, oFont10CN)
	oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "Dirección: " + upper(SM0->M0_ENDENT), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.0), Tpix(14.0), "Fecha: " + upper(ffechalarga(tCJ_EMISSAO)), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.5), Tpix(01.0), "Teléfono: " + upper(SM0->M0_TEL), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.5), Tpix(14.0), "NIT: " + tA1_CGC, oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Cliente: "+ tA1_COD +'/'+ tA1_LOJA +' - '+ upper(ALLTRIM(tA1_NOME)), oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(14.0), "Moneda: " + tCJ_MOEDA, oFont10CN)
	oPrn:Say( Tpix(nLin+03.5), Tpix(01.0), "Dirección cliente: " + upper(tA1_END), oFont10CN)
	oPrn:Say( Tpix(nLin+03.5), Tpix(14.0), "Impresión: "+ dtoc(ddatabase) +' '+ TIME(), oFont10CN)
	oPrn:Say( Tpix(nLin+04.0), Tpix(01.0), "Teléfono cliente: " + tA1_TEL, oFont10CN)
	oPrn:Say( Tpix(nLin+04.0), Tpix(14.0), "Vendedor: " + upper(LTRIM(cUserName)) , oFont10CN)
	oPrn:Say( Tpix(nLin+04.5), Tpix(01.0), "Proforma Valida hasta el: " + upper(ffechalarga(dtos( stod(CJ_VALIDA) ))) 			, oFont10CN)  //NT
	oPrn:Say( Tpix(nLin+05.0), Tpix(01.0), "Forma de Pago: " + alltrim(tE4_DESCRI), oFont10CN)

	//	oPrn:Say( Tpix(nLin+05.0), Tpix(01.0), "Lugar de Entrega: " + alltrim(tCJ_ULUGENT), oFont09CN)
	//	oPrn:Say( Tpix(nLin+05.5), Tpix(01.0), "Observación: " + alltrim(tCJ_UOBSERV), oFont09CN)

	oPrn:Say( Tpix(nLin+05.7), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(01.0), "IT.", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(01.8), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(04.3), "DESCRIPCION", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(12.4), "UNID.", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(13.5), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(16.1), "PRECIO", oFont10C)
	oPrn:Say( Tpix(nLin+06.1), Tpix(18.6), "TOTAL", oFont10C)
	oPrn:Say( Tpix(nLin+06.13), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)

Return(nLin+10.8)

Static Function fImpTotales(nLin,total,desc,recargo,nMoneda,dfecha,nDesInde,nDestot)

	local valorImporteBS
	local nDescuento := 0.0

	nSubtotal  := total
	nDescuento := desc + valorBonificacion
	nDescuento  = nDescuento - nDescPor
	nTotGral   := Round(nSubtotal+nDescuento,2)

	nDesInd := (nSubtotal- (nSubtotal * (nDestot/100)))  * nDesInde //descuento indemnizacion VALOR

	nDescuento := desc + valorBonificacion + nDesInd
	nDescuento  = round(nDescuento - nDescPor,2)
	nTotGral   := Round(nSubtotal-nDescuento,2)

	If nMoneda == 1

		oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)

		oPrn:Say( Tpix(nLin+01.5), Tpix(13.3), "SUBTOTAL  Bs. :" ,oFont10C)
		oPrn:Say( Tpix(nLin+01.5), Tpix(17.3), FmtoValor(total,14,2) ,oFont10C,,,,1)
		oPrn:Say( Tpix(nLin+01.9), Tpix(13.3), "DESCUENTOS  Bs. :",oFont10C)
		oPrn:Say( Tpix(nLin+01.9), Tpix(17.3), FmtoValor(nDescuento,14,2) ,oFont10C,,,,1)
		oPrn:Say( Tpix(nLin+02.3), Tpix(13.3), "TOTAL Bs. :",oFont10C)
		oPrn:Say( Tpix(nLin+02.3), Tpix(17.3), FmtoValor(nTotGral,14,2) ,oFont10C,,,,1)

		oPrn:Say( Tpix(nLin+02.3), Tpix(01.0), "Son: "+ Extenso(nTotGral,.F.,1) +" BOLIVIANOS." ,oFont10C)

	elseIF nMoneda == 2

		valorImporteBS := FmtoValor( ROUND(xMoeda(nTotGral+recargo,nMoneda,1,stod(dfecha),4),2),14,2)

		oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)

		oPrn:Say( Tpix(nLin+01.5), Tpix(15.3), "SUBTOTAL  $us. :" ,oFont10C)
		oPrn:Say( Tpix(nLin+01.5), Tpix(19.2), FmtoValor(nSubtotal,14,2) ,oFont10C,,,,1)

		oPrn:Say( Tpix(nLin+01.9), Tpix(15.3), "DESCUENTOS  $us. :",oFont10C)
		oPrn:Say( Tpix(nLin+01.9), Tpix(19.2), FmtoValor(nDescuento,14,2) ,oFont10C,,,,1)
		oPrn:Say( Tpix(nLin+02.3), Tpix(15.3), "TOTAL $us. :",oFont10C)
		oPrn:Say( Tpix(nLin+02.3), Tpix(19.2), FmtoValor(nTotGral,14,2) ,oFont10C,,,,1)
		oPrn:Say( Tpix(nLin+02.7), Tpix(15.3), "TOTAL Bs. :",oFont10C)
		oPrn:Say( Tpix(nLin+02.7), Tpix(19.2), valorImporteBS ,oFont10C,,,,1)

		oPrn:Say( Tpix(nLin+02.7), Tpix(01.0), "Son: "+Extenso(nTotGral,.F.,1)+" DOLARES." ,oFont10C)
		oPrn:Say( Tpix(nLin+03.1), Tpix(01.0), "TC:  " + AllTrim(TRANSFORM(txmoeda,"@E 9,999,999,999.99")) , oFont10C)

	endif

Return(nLin+03.1)

Static Function fImpNota(nLin)
	If nLin > 26
		fImpPiePag()
		nPag+=1
		oPrn:EndPage()
		oPrn:StartPage()
		nLin := 01.0
		nLin := fImpCabec(nLin)
		nLin := 06.2
	Else
		nLin := nLin - 2.8
	Endif

	oPrn:Say( Tpix(nLin+3.0), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
	//oPrn:Say( Tpix(nLin+3.5), Tpix(01.0), PADC("IMPORTANTE",130), oFont10C)
	oPrn:Say( Tpix(nLin+5.0), Tpix(5.0), "_____________________", oFont12C)
	oPrn:Say( Tpix(nLin+5.4), Tpix(5.3), "edv.: "+ cUserName  , oFont10C)
	oPrn:Say( Tpix(nLin+5.0), Tpix(12.5),"_____________________", oFont12C)
	oPrn:Say( Tpix(nLin+5.4), Tpix(12.5), "sr(s):"+ ALLTRIM(tA1_NOME) , oFont10C)

	oPrn:Say( Tpix(nLin+6.0), Tpix(1.0), "Productos en stock sujetos a rotación.", oFont12CN)
	oPrn:Say( Tpix(nLin+6.4), Tpix(1.0), "Precios con Factura", oFont12CN)
	oPrn:Say( Tpix(nLin+6.8), Tpix(1.0), "Los pagos con cheques a nombre de: UNION CENTRO VETERINARIO SRL", oFont12CN)

	if SM0->M0_CODFIL = "0100"
		oPrn:Say( Tpix(nLin+7.2), Tpix(1.0), "Los depósitos en : Bco. UNION Cta.Cte Bs 1-6407767, Cta.Cte $us 2-6407793", oFont12CN)
	else
		oPrn:Say( Tpix(nLin+7.2), Tpix(1.0), "Los depósitos en : Bco. Ganadero Cta.Cte Bs 1041-125497, Cta.Cte $us 1042-125509", oFont12CN)
	endif

	//	  oPrn:Say( Tpix(nLin+6.6), Tpix(1.0), ":", oFont10C)
	//    oPrn:Say( Tpix(nLin+5.0), Tpix(4.0), "DEPOSITO EN CUENTA BANCARIA Y EL DEPOSITANTE DEBE SER EL MISMO DE LA FACTURA." , oFont10C)
	//    oPrn:Say( Tpix(nLin+5.5), Tpix(4.0), AllTrim(GetNewPar("MV_UBCODES","")), oFont10C)
	//    oPrn:Say( Tpix(nLin+6.0), Tpix(4.0), AllTrim(GetNewPar("MV_UBCOBOL","")), oFont10C)
	//    oPrn:Say( Tpix(nLin+6.0), Tpix(10.0), AllTrim(GetNewPar("MV_UBCODOL","")), oFont10C)
	//    oPrn:Say( Tpix(nLin+6.5), Tpix(4.0), AllTrim(GetNewPar("MV_UBCODE2","")), oFont10C)
	//    oPrn:Say( Tpix(nLin+7.0), Tpix(4.0), AllTrim(GetNewPar("MV_UBCOBO2","")), oFont10C)
	//    oPrn:Say( Tpix(nLin+7.0), Tpix(10.0), AllTrim(GetNewPar("MV_UBCODO2","")), oFont10C)
	//    oPrn:Say( Tpix(nLin+7.2), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
	//    oPrn:Say( Tpix(nLin+7.7), Tpix(01.0), "LA EMPRESA NO SE HACE RESPONSABLE POR LOS DAÑOS CAUSADOS EN EL TRANSPORTE" , oFont10C)
	//    oPrn:Say( Tpix(nLin+8.2), Tpix(01.0), "" , oFont10C)

	fImpPiePag()
Return

Static Function fImpPiePag()
	oPrn:Say( Tpix(26.3), Tpix(01.0), "__________________________________________________________________________________________________________________________"	, oFont12C)
	//	oPrn:Say( Tpix(25.7), Tpix(01.0),PADC("Contacto: " + AllTrim(tCJ_USRREG) + "   |   E-Mail: " + UsrRetMail(cCodUser(tCJ_USRREG)),140), oFont10C)
	//	oPrn:Say( Tpix(26.0), Tpix(01.0), PADC("Av.Viedma No 51 Z/Cementerio General - Telfs: 3 3326174 / 3 3331447 / 3 3364244 - Fax: 3 3368672",100), oFont10C)
	oPrn:Say( Tpix(27.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ValidPerg ºAutor  ³ Walter Alvarez ³  04/11/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{"01","De Fecha de Emisión     :","mv_ch1","D",08,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"02","A Fecha de Emisión      :","mv_ch2","D",08,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"03","De Cliente              :","mv_ch3","C",6,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,"SA1",""})
	aAdd(aRegs,{"04","A Cliente               :","mv_ch4","C",6,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,"SA1",""})
	aAdd(aRegs,{"05","De Presupuesto          :","mv_ch5","C",6,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"SCJ",""})
	aAdd(aRegs,{"06","A Presupuesto           :","mv_ch6","C",6,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"SCJ",""})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		dbSeek(cPerg+aRegs[i][1])
		If !Found()
			RecLock("SX1",!Found())
			SX1->X1_GRUPO    := cPerg
			SX1->X1_ORDEM    := aRegs[i][01]
			SX1->X1_PERSPA   := aRegs[i][02]
			SX1->X1_VARIAVL  := aRegs[i][03]
			SX1->X1_TIPO     := aRegs[i][04]
			SX1->X1_TAMANHO  := aRegs[i][05]
			SX1->X1_DECIMAL  := aRegs[i][06]
			SX1->X1_PRESEL   := aRegs[i][07]
			SX1->X1_GSC      := aRegs[i][08]
			SX1->X1_VAR01    := aRegs[i][09]
			SX1->X1_DEF01    := aRegs[i][10]
			SX1->X1_DEF02    := aRegs[i][11]
			SX1->X1_DEF03    := aRegs[i][12]
			SX1->X1_DEF04    := aRegs[i][13]
			SX1->X1_F3       := aRegs[i][14]
			SX1->X1_VALID    := aRegs[i][15]

			MsUnlock()
		Endif
	Next

	Return

Return

Static Function ffechalarga(sfechacorta)

	//20101105

	Local sFechalarga:=""
	Local descmes := ""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,0,4)

	if smes=="01"
		descmes :="Enero"
	endif
	if smes=="02"
		descmes :="Febrero"
	endif
	if smes=="03"
		descmes :="Marzo"
	endif
	if smes=="04"
		descmes :="Abril"
	endif
	if smes=="05"
		descmes :="Mayo"
	endif
	if smes=="06"
		descmes :="Junio"
	endif
	if smes=="07"
		descmes :="Julio"
	endif
	if smes=="08"
		descmes :="Agosto"
	endif
	if smes=="09"
		descmes :="Septiembre"
	endif
	if smes=="10"
		descmes :="Octubre"
	endif
	if smes=="11"
		descmes :="Noviembre"
	endif
	if smes=="12"
		descmes :="Diciembre"
	endif

	sFechalarga := sdia + " de " + descmes + " de " + sano

Return(sFechalarga)

Static Function diferencia(sfechafin,sfechaini)

	//20101105

	Local diasdia:=0
	Local diasmes:=0
	Local diasano:=0
	Local sdiafin:=val(substr(sfechafin,7,2))
	Local smesfin:=val(substr(sfechafin,5,2))
	Local sanofin:=val(substr(sfechafin,0,4))

	Local sdiaini:=val(substr(sfechaini,7,2))
	Local smesini:=val(substr(sfechaini,5,2))
	Local sanoini:=val(substr(sfechaini,0,4))

	if sdiafin>=sdiaini
		diasdia:=sdiafin-sdiaini
	else
		diasdia := (30+sdiafin)-sdiaini
		smesfin:=smesfin-1
	endif

	if smesfin<smesini
		diasmes:=((smesfin+12)-smesini)*30
	else
		diasmes := (smesfin-smesini)*30
	endif

	diferencia:=diasdia + diasmes

Return(diferencia)

Static Function cCodUser(cNomeUser)
	Local _IdUsuario:= ""
	/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±³  ³ PswOrder(nOrder): seta a ordem de pesquisa   ³±±
	±±³  ³ nOrder -> 1: ID;                             ³±±
	±±³  ³           2: nome;                           ³±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
	PswOrder(2)
	If pswseek(cNomeUser,.t.)
		_aUser      := PswRet(1)
		_IdUsuario  := _aUser[1][1]      // Código de usuario
	Endif

Return(_IdUsuario)

Static Function GraContPert()
	SX1->(DbSetOrder(1))
	SX1->(DbGoTop())
	cPerg := PADR("IMPRE",10)
	/*If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
	Reclock("SX1",.F.)
	SX1->X1_CNT01 := SCJ->CJ_FILIAL       //Variable publica con sucursal en uso
	SX1->(MsUnlock())
	End
	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
	Reclock("SX1",.F.)
	SX1->X1_CNT01 := SCJ->CJ_FILIAL          //Variable publica con sucursal en uso
	SX1->(MsUnlock())
	End        */

	If SX1->(DbSeek(cPerg+"01"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := dtoc(SCJ->CJ_EMISSAO)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(cPerg+"02"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := dtoc(SCJ->CJ_EMISSAO)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(cPerg+"03"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SCJ->CJ_CLIENTE       //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(cPerg+"04"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SCJ->CJ_CLIENTE       //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+"05"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SCJ->CJ_NUM        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(cPerg+"06"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SCJ->CJ_NUM        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
Return

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 9,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal
