#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RPPRE01  ºAutor  ³	Nahim Terrazas/EET  	 º 15/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion ³Impresion de Proforma de Venta con inclusión de lote       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil LEÓN SRL      			                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PEDVENPDF(aPRs)
	PRIVATE cPerg   := "PEDVPDF"   // elija el Nombre de la pregunta
	
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	Processa({|| fImpPres(aPRs)},"Impressão (1) de aPRs ","Imprimindo aPRs...")

Return

Static Function fImpPres(aPRs)

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

	cQuery := "SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_FECENT,C5_CONDPAG,C5_DESC1,C5_UNOMCLI,C5_UNITCLI,C5_ULUGENT,"
	cQuery += "C5_UTPOENT,C5_UNUCOCL,C5_INCISS,C5_DOCGER,C5_PBRUTO,C5_TRANSP,C5_COTACAO,C5_UOBSERV,C5_USRREG,A3_NOME,"
	cQuery += "C6_ENTREG,C6_ITEM,B1_UCODFAB,C6_PRODUTO,C6_LOCAL,NNR_DESCRI,NNR_UDIREC,C6_UM, C6_QTDVEN,C6_PRCVEN,C6_VALOR, C6_LOTECTL,"
	cQuery += "A1_NOME,A1_CGC,A1_END,C6_DESCRI,C6_UESPECI ,C5_TXMOEDA,C5_MOEDA,E4_DESCRI,A1_COD,A1_LOJA,C5_VEND1,B1_DESC "
	cQuery += " ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO FROM "+RetSqlName("SC6")+" SC61 "
	cQuery += " WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC "
	cQuery += "FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL AND C5_CLIENTE = C6_CLI AND SC6.D_E_L_E_T_=' ' "
	cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD=C5_CLIENTE AND A1_LOJA = C5_LOJACLI and SA1.D_E_L_E_T_<>'*' "
	cQuery += "LEFT JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD=C5_VEND1 AND SA3.D_E_L_E_T_<>'*'"
	cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_=' ' "
	cQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 ON E4_CODIGO=C5_CONDPAG AND SE4.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"' "
	cQuery += "INNER JOIN " + RetSqlName("NNR") + " NNR ON NNR_CODIGO=C6_LOCAL AND NNR.D_E_L_E_T_<>'*' "
	cQuery += " WHERE C5_FILIAL = '"+trim(XFILIAL("SC5"))+"' "
	cQuery += " AND SC5.D_E_L_E_T_=' '  "
	cQuery += " AND C5_USUFACT = '"+ MV_PAR01 +"' ORDER BY C5_NUM,C6_ITEM "
	//IMP IM2 IM3
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
		nMoneda:=TRB->C5_MOEDA
		dfecha:= TRB->C5_EMISSAO
		If nPag == 1 .and. TRB->C5_NUM <> cNroProforma .and.cNroProforma==""
			cNroProforma := TRB->C5_NUM
			oPrn:StartPage()
		elseif TRB->C5_NUM <> cNroProforma
			cNroProforma := TRB->C5_NUM

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

		nTotal:=nTotal+TRB->C6_VALOR

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
	//oPrn:Say( Tpix(26.0), Tpix(02.0),"query : " + consulta, oFont12C)



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

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), TRB->C6_ITEM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.5), TRB->C6_PRODUTO, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(03.8), Left(TRB->C6_UESPECI,50), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.5), TRB->C6_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.7),Transform(TRB->C6_QTDVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.1),Transform(TRB->C6_PRCVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.5), Transform(TRB->C6_VALOR,"@A 999,999,999.99"), oFont10C)
	If Len(AllTrim(TRB->C6_UESPECI)) > 50
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),Right(TRB->C6_UESPECI,30), oFont10C)
		nLin:= nLin+00.3
	EndIf
	cDesc2 := POSICIONE("SB1",1,XFILIAL("SB1")+TRB->C6_PRODUTO,"B1_UESPEC2")
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
	If !Empty(TRB->C6_LOTECTL)
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),TRB->C6_LOTECTL, oFont10C)
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
	local diasfin :=0
	local diasini :=0
	local direccion:=""
	local tel:=""

//diasfin:=DateDiffDay(CTOD(CJ_VALIDA),CTOD(CJ_EMISSAO))  //substr(CJ_VALIDA,8,2)
	local cConsTemp := getNextAlias()
	If SM0->(Eof())
		SM0->( MsSeek( cEmpAnt + TRB->C5_FILIAL , .T. ))
	Endif

	tel:= SM0->M0_TEL
	direccion:=SM0->M0_ENDENT
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "MERCANTIL LEON SRL", oFont14CN)
//oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), "NOTA DE VENTA", oFont18CN)      
	oPrn:Say( Tpix(nLin+00.5), Tpix(08.0), if(TRB->C5_INCISS=="N" .AND. TRB->C5_DOCGER<>'3',"NOTA DE ENTREGA FUTURA","NOTA DE VENTA"), oFont18CN)
	oPrn:Say( Tpix(nLin+01.4), Tpix(01.0), "Sucursal: "+ SM0->M0_FILIAL, oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+01.4), Tpix(14.0), "Numero: "+TRB->C5_NUM, oFont10CN)
	oPrn:Say( Tpix(nLin+01.8), Tpix(01.0), "Cliente: "+ TRB->A1_COD +'/'+ TRB->A1_LOJA +' - '+ ALLTRIM(TRB->A1_NOME), oFont10CN)
	oPrn:Say( Tpix(nLin+01.8), Tpix(14.0), "Fecha: "+ ffechalarga(TRB->C5_EMISSAO), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.2), Tpix(01.0), "Direccion: "+TRB->A1_END, oFont10CN)
	oPrn:Say( Tpix(nLin+02.2), Tpix(14.0), "NIT: "+iif(!empty(TRB->C5_UNITCLI),AllTrim(str(TRB->C5_UNITCLI)),AllTrim(TRB->A1_CGC)), oFont10CN)
//oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Telefono: "+A1_TEL, oFont10CN)

	oPrn:Say( Tpix(nLin+02.6), Tpix(01.0), "Vendedor: " + LTRIM(GetAdvFval('SA3',"A3_NOME",xFilial('SA3') + TRB->C5_VEND1 ,1,"" )) 			, oFont10CN)
	oPrn:Say( Tpix(nLin+02.6), Tpix(14.0), "Moneda: "+GetMV("MV_MOEDA"+Alltrim(STR(TRB->C5_MOEDA)))							 			, oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Forma de Pago: " + alltrim(TRB->E4_DESCRI), oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(14.0), "Impresión: "+ dtoc(ddatabase) +' '+ TIME()								 			, oFont10CN)

	oPrn:Say( Tpix(nLin+03.4), Tpix(01.0), "Deposito de Entrega: " + TRB->C6_LOCAL + " - " + alltrim(TRB->NNR_DESCRI) 			, oFont10CN)
	oPrn:Say( Tpix(nLin+03.4), Tpix(14.0), "PM: " +  IF(TRB->C5_DESC1<>0,TRANSFORM(TRB->C5_DESC1,"@A 99.99"),TRANSFORM(TRB->C5_PDESC,"@A 99.99")) + "%"	, oFont10CN)
	oPrn:Say( Tpix(nLin+03.8), Tpix(01.0), "Dir.Deposito: " +  ALLTRIM(TRB->NNR_UDIREC), oFont10CN)
	oPrn:Say( Tpix(nLin+03.8), Tpix(14.0), "Doc.Gen: "+ if(TRB->C5_DOCGER=="1","Factura",if(TRB->C5_DOCGER=="2","Remito","Ent.Futura")) , oFont10CN) // Nahim Terrazas 16/09/2019 Indica que es
	oPrn:Say( Tpix(nLin+04.2), Tpix(01.0), "Lugar de Entrega: " +  ALLTRIM(TRB->C5_ULUGENT), oFont09CN)
	oPrn:Say( Tpix(nLin+04.6), Tpix(01.0), "Observación: " + alltrim(TRB->C5_UOBSERV), oFont09CN)
	oPrn:Say( Tpix(nLin+05.0), Tpix(01.0), "Tipo: "+ if(TRB->C5_INCISS=="N","Entrega Futura","Normal") , oFont10CN) // Nahim Terrazas 16/09/2019 Si es un pedido normal o Entrega futura.

// Nahim Busca si tiene anuladas 2019/10/15
	BeginSql alias cConsTemp
	SELECT D2_DOC,D2_SERIE,D2_PEDIDO,D2_EMISSAO FROM %table:SD2% SD2
	JOIN %table:SF3% SF3 ON D2_DOC = F3_NFISCAL AND D2_SERIE 
	LIKE F3_SERIE AND F3_DTCANC <> '' AND SF3.D_E_L_E_T_ = ' '
	AND F3_FILIAL = D2_FILIAL
	WHERE SD2.D_E_L_E_T_ LIKE '*'
	AND D2_PEDIDO = %exp:TRB->C5_NUM%
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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSx1(cPerg,"01","Campo verifica?","Campo verifica?","Campo verifica?",         "mv_ch1","C",15,0,0,"G",""," ","","","mv_par01",""       ,""            ,""        ,""     ,"","")

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
