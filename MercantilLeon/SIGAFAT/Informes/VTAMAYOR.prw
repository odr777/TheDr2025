#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  VTAMAYOR  ºAutor  ³	Denar Terrazas      	 º 26/09/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion ³Impresion de Venta mayorista      						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil LEÓN SRL      			                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VTAMAYOR(aPRs)

	Private cPerg	:= "VTAMAYOR"

	ValidPerg()	// CARGAMOS LAS PREGUNTAS POR CODIGO

	If funname() == 'MATA467N'//Rutina "Facturaciones"
		GraContPert()
	Endif

	If aPRs == Nil
		If Pergunte(cPerg,.T.)
			Processa({|| fImpPres(aPRs)},"Impresión Venta Mayorista","Imprimiendo...")
		Else
			Return
		Endif
	Else
		Processa({|| fImpPres(aPRs)},"Impresión Venta Mayorista","Imprimiendo...")
	Endif

Return

Static Function fImpPres(aPRs)

	Local lPrint	:= .f.
	Local nLin		:= 00.0
	Local cQuery
	Local nTotal	:= 00.0
	Local nDesc		:= 00.0
	Local nRecargo	:= 00.0
	Private nPag	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as fontes a serem utilizadas na impressao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia o uso da classe ...                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:= TMSPrinter():New("Proforma")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define pagina no formato paisagem ...        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:SetPortrait()

	oPrn:Setup()

	cQuery := " SELECT DISTINCT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO,F2_COND,F2_UNOMCLI,F2_UNITCLI,'' C5_ULUGENT,"
	cQuery += " '' F2_XOBSERV,F2_USRREG,A3_NOME,"
	cQuery += " D2_ITEM,B1_UCODFAB,D2_COD,D2_LOCAL,NNR_DESCRI,NNR_UDIREC,D2_UM, D2_QUANT,D2_PRCVEN,D2_TOTAL, D2_LOTECTL,"
	cQuery += " A1_NOME,A1_CGC,A1_END,D2_UESPEC2,F2_TXMOEDA,F2_MOEDA,E4_DESCRI,A1_COD,A1_LOJA,F2_VEND1,B1_DESC,"
	cQuery += " (SELECT (DSCTO/TOTAL) * 100.00 PDESC FROM (SELECT SUM(D2_TOTAL) + SUM(D2_DESCON) TOTAL, SUM(D2_DESCON) DSCTO FROM " + RetSqlName("SD2") + " SD21 (NOLOCK)"
	cQuery += " WHERE D2_DOC=SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D2_CLIENTE = SF2.F2_CLIENTE AND D2_LOJA = SF2.F2_LOJA AND SD21.D_E_L_E_T_ = ' ') A ) C5_PDESC "
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 (NOLOCK)"
	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 (NOLOCK) ON F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA"
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA and SA1.D_E_L_E_T_=' '"
	cQuery += " LEFT JOIN " + RetSqlName("SA3") + " SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON B1_COD = D2_COD"
	cQuery += " INNER JOIN " + RetSqlName("SE4") + " SE4 (NOLOCK) ON E4_CODIGO = F2_COND AND SE4.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN " + RetSqlName("NNR") + " NNR (NOLOCK) ON NNR_CODIGO = D2_LOCAL AND NNR.D_E_L_E_T_=' '"
	cQuery += " WHERE F2_FILIAL BETWEEN '"+TRIM(XFILIAL("SF2"))+"' AND '"+TRIM(XFILIAL("SF2"))+"'"
	cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQuery += " AND F2_DOC BETWEEN '"+TRIM(MV_PAR03)+"' AND '"+TRIM(MV_PAR04)+"'"
	cQuery += " AND F2_SERIE BETWEEN '"+TRIM(MV_PAR05)+"' AND '"+TRIM(MV_PAR06)+"'"
	cQuery += " AND SF2.D_E_L_E_T_=' ' AND SD2.D_E_L_E_T_=' ' AND E4_FILIAL='"+ XFILIAL('SE4') +"' "
	cQuery += " AND SB1.D_E_L_E_T_=' '"
	cQuery += " ORDER BY D2_ITEM"

	If __CUSERID = '000000'
		Aviso("",cQuery,{'ok'},,,,,.t.)
	endif

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aviso("",cQuery,{'ok'},,,,,.t.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³ Caso area de trabalho estiver aberta, fecha... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	If !Empty(Select("TRB"))
		dbSelectArea("TRB")
		dbCloseArea()
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³ Executa query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	TcQuery cQuery New Alias "TRB"
	dbSelectArea("TRB")
	dbGoTop()

	nLindet := 06.1
	nPag := 1
	cNroProforma:=""
	nMoneda:=0
	dfecha:=""
	While !TRB->(Eof())
		// ALERT("ENTRA")
		nMoneda:=TRB->F2_MOEDA
		dfecha:= TRB->F2_EMISSAO
		If nPag == 1 .and. TRB->F2_DOC <> cNroProforma .and.cNroProforma==""
			cNroProforma := TRB->F2_DOC
			oPrn:StartPage()
		elseif TRB->F2_DOC <> cNroProforma
			cNroProforma := TRB->F2_DOC

			nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)
			nPag++
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := 01.0
			nLin := fImpCabec(nLin)
			oPrn:Say( Tpix(26.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
			nLindet := 06.1
			nTotal    := 00.0
			nDesc    := 00.0
			nRecargo := 00.0
		end

		IF nLindet == 06.1 .AND. nPag == 1
			nLin := 01.0
			nLin := fImpCabec(nLin)
		ENDIF
		nLindetcab := 06.1
		nLindetcab := fImpItemCab(nLindetcab)
		//	YA_DESCR
		nLinha := MlCount(TRB->B1_DESC,40)

		nLinha2 := " "//MlCount(_cProcedencia,20)
		nLindet := fImpItem(nLindet)

		nTotal:=nTotal+TRB->D2_TOTAL

		//oPrn:Say( Tpix(25.4), Tpix(01.0),PADC("Contacto: " + AllTrim(CJ_USRREG) + "   |   E-Mail: " + UsrRetMail(cCodUser(CJ_USRREG)),115), oFont10C)
		oPrn:Say( Tpix(25.5), Tpix(01.0), "_______________________________________________________________________________________________________________"	, oFont12C)
		oPrn:Say( Tpix(26.0), Tpix(01.0), PADC("Av.Viedma No 51 Z/Cementerio General - Telfs: 3 3326174 / 3 3331447 / 3 3364244 - Fax: 3 3368672",100), oFont10C)
		oPrn:Say( Tpix(26.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
		If nLindet > 22
			nPag+=1
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := 01.0
			nLin := fImpCabec(nLin)
			oPrn:Say( Tpix(26.0), Tpix(18.0), "Página : "+Transform(nPag,"999"), oFont10C)
			nLindet := 06.1
		Endif
		TRB->(dbSkip())

		//oPrn:EndPage()
	End
	//oPrn:Say( Tpix(nLindet+2.8), Tpix(01.0), "NOTA.- AL MOMENTO DE HACER SU COMPRA POR FAVOR EXIGIR SU FACTURA", oFont10C)
	oPrn:Say( Tpix(nLindet+3.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
	nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha)



	oPrn:EndPage()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se visualiza ou imprime ...         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPrint

		While lPrint
			nDef := Aviso("Impressão de Pedido de Venta", "Confirma Impressão da Pedido?", {"Preview","Setup","Cancela","Ok"},,)
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

	TRB->(dbCloseArea())


RETURN


Static Function fImpItemCab(nLin)

// ARTICULO	NOMBRE	PROCEDENCIA	UNIDAD	CANTIDAD	PRECIO	MONTO

	oPrn:Say( Tpix(nLin+00.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "IT", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.5), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(03.8), "DESCRIPCION", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(12.4), "UNID.", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(13.5), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(16.1), "PRECIO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(18.6), "IMPORTE", oFont10C)
	oPrn:Say( Tpix(nLin+00.7), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)

Return(nLin+03.0)

Static Function fImpItem(nLin)

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), TRB->D2_ITEM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.5), TRB->D2_COD, oFont10C)
	cDescEsp1:= GetAdvFval('SB1',"B1_ESPECIF",xFilial('SB1') + TRB->D2_COD ,1,"")
	oPrn:Say( Tpix(nLin+01.5), Tpix(03.8), Left(cDescEsp1,50), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.5), TRB->D2_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.7),Transform(TRB->D2_QUANT,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.1),Transform(TRB->D2_PRCVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.5), Transform(TRB->D2_TOTAL,"@A 999,999,999.99"), oFont10C)
	If Len(AllTrim(cDescEsp1)) > 50
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),Right(cDescEsp1,30), oFont10C)
		nLin:= nLin+00.3
	EndIf
	cDesc2 := POSICIONE("SB1",1,XFILIAL("SB1")+TRB->D2_COD,"B1_UESPEC2")
	If !Empty(cDesc2)
		If Len(AllTrim(cDesc2)) > 50
			oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),Left(cDesc2,50), oFont10C)
			nLin:= nLin+00.3
			oPrn:Say( Tpix(nLin+01.8), Tpix(03.8), Right(cDesc2,30), oFont10C)
			nLin:= nLin+00.3
		Else
			oPrn:Say( Tpix(nLin+01.8), Tpix(03.8), Left(cDesc2,50), oFont10C)
			nLin:= nLin+00.3
		EndIf
	EndIf
// Adicion Lote
	If !Empty(TRB->D2_LOTECTL)
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),TRB->D2_LOTECTL, oFont10C)
		nLin:= nLin+00.3
	endif

	nLin:= nLin+00.3

Return(nLin)

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
	local direccion:=""
	local tel:=""

//diasfin:=DateDiffDay(CTOD(CJ_VALIDA),CTOD(CJ_EMISSAO))  //substr(CJ_VALIDA,8,2)
	local cConsTemp := getNextAlias()
	If SM0->(Eof())
		SM0->( MsSeek( cEmpAnt + TRB->F2_FILIAL , .T. ))
	Endif

	tel:= SM0->M0_TEL
	direccion:=SM0->M0_ENDENT
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "MERCANTIL LEON SRL", oFont14CN)
//oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), "NOTA DE VENTA", oFont18CN)      
	oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), "VENTA MAYORISTA", oFont18CN)
	oPrn:Say( Tpix(nLin+01.4), Tpix(01.0), "Sucursal: "+ SM0->M0_FILIAL, oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+01.4), Tpix(14.0), "Numero: "+TRB->F2_SERIE + "/" + TRB->F2_DOC, oFont10CN)
	oPrn:Say( Tpix(nLin+01.8), Tpix(01.0), "Cliente: "+ ALLTRIM(TRB->A1_COD) + ALLTRIM(TRB->A1_LOJA) +' - '+ ALLTRIM(TRB->A1_NOME), oFont10CN)
	oPrn:Say( Tpix(nLin+01.8), Tpix(14.0), "Fecha: "+ ffechalarga(TRB->F2_EMISSAO), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.2), Tpix(01.0), "Direccion: "+TRB->A1_END, oFont10CN)
	//oPrn:Say( Tpix(nLin+02.2), Tpix(14.0), "NIT: "+iif(!empty(TRB->F2_UNITCLI),AllTrim(TRB->F2_UNITCLI),AllTrim(TRB->A1_CGC)), oFont10CN)
//oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Telefono: "+A1_TEL, oFont10CN)

	oPrn:Say( Tpix(nLin+02.6), Tpix(01.0), "Vendedor: " + LTRIM(GetAdvFval('SA3',"A3_NOME",xFilial('SA3') + TRB->F2_VEND1 ,1,"" )) 			, oFont10CN)
	oPrn:Say( Tpix(nLin+02.6), Tpix(14.0), "Moneda: "+GetMV("MV_MOEDA"+Alltrim(STR(TRB->F2_MOEDA)))							 			, oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Forma de Pago: " + alltrim(TRB->E4_DESCRI), oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(14.0), "Impresión: "+ dtoc(ddatabase) +' '+ TIME()								 			, oFont10CN)

	oPrn:Say( Tpix(nLin+03.4), Tpix(01.0), "Deposito de Entrega: " + TRB->D2_LOCAL + " - " + alltrim(TRB->NNR_DESCRI) 			, oFont10CN)
	oPrn:Say( Tpix(nLin+03.8), Tpix(01.0), "Dir.Deposito: " +  ALLTRIM(TRB->NNR_UDIREC), oFont10CN)
	oPrn:Say( Tpix(nLin+04.2), Tpix(01.0), "Lugar de Entrega: " +  ALLTRIM(TRB->C5_ULUGENT), oFont09CN)
	oPrn:Say( Tpix(nLin+04.6), Tpix(01.0), "Observación: " + alltrim(TRB->F2_XOBSERV), oFont09CN)
	oPrn:Say( Tpix(nLin+05.0), Tpix(01.0), "Tipo: Normal", oFont10CN)

// Nahim Busca si tiene anuladas 2019/10/15
	BeginSql alias cConsTemp
	SELECT D2_DOC,D2_SERIE,D2_PEDIDO,D2_EMISSAO FROM %table:SD2% SD2
	JOIN %table:SF3% SF3 ON D2_DOC = F3_NFISCAL AND D2_SERIE 
	LIKE F3_SERIE AND F3_DTCANC <> '' AND SF3.D_E_L_E_T_ = ' '
	AND F3_FILIAL = D2_FILIAL
	WHERE SD2.D_E_L_E_T_ LIKE '*'
	AND D2_SERIE = %exp:TRB->F2_SERIE%
	AND D2_DOC = %exp:TRB->F2_DOC%
	AND SD2.D2_ESPECIE LIKE 'NF'
	GROUP BY D2_DOC,D2_SERIE,D2_PEDIDO,D2_EMISSAO
	EndSql
//cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL
	dbSelectArea( cConsTemp )
	if (cConsTemp)->(!EOF())
		oPrn:Say( Tpix(nLin+05.0), Tpix(14.0), "Factura Anulada: " + alltrim((cConsTemp)->D2_DOC + " - " + (cConsTemp)->D2_SERIE), oFont09CN)
		// tiene anulada entonces imprime
	endif

Return(nLin+05.4)


Static Function fImpTotales(nLin,total,desc,recargo,nMoneda,dfecha)

	oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)

	oPrn:Say( Tpix(nLin+01.5), Tpix(15.6), "TOTAL  Bs.:" +  Transform(round(xmoeda(total+recargo,nMoneda,1,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
	oPrn:Say( Tpix(nLin+02.0), Tpix(15.6), "TOTAL $us.:" +  Transform(round(xmoeda(total+recargo,nMoneda,2,stod(dfecha),4),2),"@A 999,999,999.99")												, oFont10C)
	oPrn:Say( Tpix(nLin+05.0), Tpix(03.0), "Elaborado por"															, oFont10C)
//oPrn:Say( Tpix(nLin+05.0), Tpix(07.0), "Vendedor Externo"															, oFont10C)
	oPrn:Say( Tpix(nLin+05.0), Tpix(8.5), "VoBo"															, oFont10C)
	oPrn:Say( Tpix(nLin+05.0), Tpix(13.0), "Recibido Por"															, oFont10C)
	oPrn:Say( Tpix(nLin+04.5), Tpix(03.0), "_____________"															, oFont10C)
//oPrn:Say( Tpix(nLin+04.5), Tpix(07.0), "________________"															, oFont10C)
	oPrn:Say( Tpix(nLin+04.5), Tpix(8.0), "_____________"															, oFont10C)
	oPrn:Say( Tpix(nLin+04.5), Tpix(13.0), "_____________"															, oFont10C)


Return(nLin+06.0)







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

	Local aRegs := {}
	Local i

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)


	aAdd(aRegs,{"01","De Fecha de Emisión     :","mv_ch1","D",08,0,0,"G","MV_PAR01",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"02","A Fecha de Emisión      :","mv_ch2","D",08,0,0,"G","MV_PAR02",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"03","De Documento            :","mv_ch3","C",13,0,0,"G","MV_PAR03",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"04","A Documento             :","mv_ch4","C",13,0,0,"G","MV_PAR04",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"05","De Serie                :","mv_ch5","C",03,0,0,"G","MV_PAR05",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"06","A Serie                 :","mv_ch6","C",03,0,0,"G","MV_PAR06",""       ,""            ,""        ,""     ,"",""})

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
	Local sdiafin:=val(substr(sfechafin,7,2))
	Local smesfin:=val(substr(sfechafin,5,2))

	Local sdiaini:=val(substr(sfechaini,7,2))
	Local smesini:=val(substr(sfechaini,5,2))

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

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SF2->F2_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SF2->F2_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
	End
                                   
	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF2->F2_DOC        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
	End
  
	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF2->F2_DOC        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF2->F2_SERIE        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(2)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF2->F2_SERIE        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
	End
Return

