#Include "RwMake.ch"
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RPPRE01  ºAutor  ³	Nahim Terrazas			 º 15/02/16   º±±
±±									Denar Terrazas			 º 20/03/17   º±±
±±									Edson Mamani			 º 27/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion ³Impresion de Proforma de Venta con inclusión de lote       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Belen SRL			      			                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pfergunta4 do SX1                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PEDVEN(aPRs)

	Private cPerg	:= "NOPED"
	Private nValDesc1
	Private nValDesc2
	Private nValTotQuant // Nahim agregando total cantidad
	Private nDescEsp // Nahim agregando Descuento especial
	ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO

	GraContPert()

	If funname() == 'MATA410'
		Pergunte(cPerg,.F.)
	Else
		Pergunte(cPerg,.T.)
	Endif

	If aPRs == Nil
		If Pergunte(cPerg,.t.)
			Processa({|| fImpPres(aPRs)},"Impressão (1) de aPRs ","Imprimindo aPRs...")
		Else
			Return
		Endif
	Else
		Processa({|| fImpPres(aPRs)},"Impressão (2) de aPRs ","Imprimindo aPRs...")
	Endif

Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

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

	oFont08C  := TFont():New("Courier New",08.8,08.8,,.f.)
	oFont09C  := TFont():New("Courier New",09,09,,.f.)
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
	oPrn:= TMSPrinter():New("NOTA")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define pagina no formato paisagem ...        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:SetPortrait()

	oPrn:Setup()

	cQuery := "SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_FECENT,C5_CONDPAG,C5_DESC1,C5_DESC4,C5_DESCONT,C5_UNOMCLI,C5_UNITCLI,C5_ULUGENT,C5_UOBSERV,"
	cQuery += "C5_PBRUTO,C5_TRANSP,C5_COTACAO,C5_USRREG,A3_NOME, B1_PESO, C6_PRUNIT ,"
	cQuery += "C6_ENTREG,C6_ITEM,C6_PRODUTO,C6_LOCAL,NNR_DESCRI,C6_UM, C6_QTDVEN,C6_PRCVEN,C6_VALOR, C6_LOTECTL,"
	cQuery += "A1_NOME,A1_CGC,A1_END,B1_DESC C6_UESPECI,C5_TXMOEDA,C5_MOEDA,E4_DESCRI,A1_COD,A1_LOJA,C5_VEND1,B1_DESC "
	cQuery += " ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO FROM "+RetSqlName("SC6")+" SC61 "
	cQuery += " WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC "
	cQuery += "FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL and SC6.D_E_L_E_T_ <> '*'  "
	cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD=C5_CLIENTE AND A1_LOJA = C5_LOJACLI and SA1.D_E_L_E_T_<>'*' "
	cQuery += "LEFT JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD=C5_VEND1 "
	cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=C6_PRODUTO and SB1.D_E_L_E_T_ <> '*' "
	cQuery += "INNER JOIN " + RetSqlName("SE4") + " SE4 ON E4_CODIGO=C5_CONDPAG and SE4.D_E_L_E_T_ <> '*'"
	cQuery += "INNER JOIN " + RetSqlName("NNR") + " NNR ON NNR_CODIGO=C6_LOCAL and C5_FILIAL = NNR_FILIAL AND NNR.D_E_L_E_T_<>'*' "
	cQuery += " WHERE C5_FILIAL BETWEEN '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
	cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND C5_NUM BETWEEN '"+trim(mv_par05)+"' AND '"+trim(mv_par06)+"'"
	cQuery += " AND SC5.D_E_L_E_T_=' ' AND SC6.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"' "
	cQuery += " AND SB1.D_E_L_E_T_=' ' order by C6_ITEM "

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	  aviso("",cQuery,{'ok'},,,,,.t.)

	//	Aviso("PEdido ",cQuery,{'ok'},,,,,.t.) // NTP Prueba

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
	nPrecio := 0.0
	nTotalPrecio := 0.0
	nPeso:=0.0
	nValTotQuant := 0.0
	nSumPeso:=0.0
	nauxPrecio:=0.0
	nDesc1:=0.0
	nDesc4:=0.0
	While !EOF()
		nMoneda:=C5_MOEDA
		dfecha:= C5_EMISSAO
//		// Nahim Ajustes
//		if C5_PDESC <> 0 // si hay desscuento por ITEM
//			nValDesc1 :=  C5_PDESC// Ntp 16/04/2019
//		else // Si no hay descuento por item va a tomar el del PEdido 1
//			nValDesc1 :=  C5_DESC1//Ntp 16/04/2019
//		endif		
////			nValDesc1 +=  C5_DESC1//Ntp 16/04/2019
//		nValDesc2 := C5_DESC4
//		// Nahim Ajustes

		// Nahim Ajustes
		if C5_PDESC <> 0 // si hay desscuento por ITEM
			nValDesc2 :=  C5_PDESC// Ntp 16/04/2019
		else // Si no hay descuento por item va a tomar el del PEdido 1
			nValDesc2 :=  C5_DESC4//Ntp 16/04/2019
		endif		
//			nValDesc1 +=  C5_DESC1//Ntp 16/04/2019
		nValDesc1 := C5_DESC1
		nDescEsp := C5_DESCONT
		// Nahim Ajustes
		
		nPeso := B1_PESO
		nPrecio := C6_PRUNIT
		nauxPrecio := (nPrecio*C6_QTDVEN)
		nTotalPrecio := nTotalPrecio + nauxPrecio		
		nSumPeso := nSumPeso + nPeso
		nValTotQuant += C6_QTDVEN
		If nPag == 1 .and. C5_NUM <> cNroProforma .and.cNroProforma==""
			cNroProforma :=C5_NUM
			oPrn:StartPage()
		elseif C5_NUM <> cNroProforma
			cNroProforma :=C5_NUM

			nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha,nSumPeso,nTotalPrecio)
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
		nLinha := MlCount(B1_DESC,40)

		nLinha2 := " "//MlCount(_cProcedencia,20)
		nLindet := fImpItem(nLindet,nPrecio,nauxPrecio)

		nTotal := nTotal + C6_VALOR

		//oPrn:Say( Tpix(25.4), Tpix(01.0),PADC("Contacto: " + AllTrim(CJ_USRREG) + "   |   E-Mail: " + UsrRetMail(cCodUser(CJ_USRREG)),115), oFont10C)
		oPrn:Say( Tpix(25.5), Tpix(01.0), "_______________________________________________________________________________________________________________"	, oFont12C)
		oPrn:Say( Tpix(26.0), Tpix(01.0), PADC(SM0->M0_ENDENT,100), oFont10C)
		// oPrn:Say( Tpix(26.0), Tpix(01.0), PADC("Av. Isabel la Católica #81A , Esq. C/ Romulo Gomez - Teléfono: 3 3599930",100), oFont10C) Nahim Terrazas

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
		dbSkip()

		//oPrn:EndPage()
	End //aqui termina el while
	
	if(nTotalPrecio > 0.0)
//		nDesc4 := fdescuento2(nValDesc1,nValDesc2,nTotalPrecio)
//		nDesc1 := ((nTotalPrecio * nValDesc1)/100)
		nDesc4 := ((nTotalPrecio * nValDesc2)/100)
		nDesc1 := fdescuento2(nValDesc2,nValDesc1,nTotalPrecio)
	Endif
	if nDescEsp > 0
		nTotal = nTotal - nDescEsp
	endif
	//oPrn:Say( Tpix(nLindet+2.8), Tpix(01.0), "NOTA.- AL MOMENTO DE HACER SU COMPRA POR FAVOR EXIGIR SU FACTURA", oFont10C)
	nLindet := fImpTotales(nLindet+0.5,nTotal,nDesc,nRecargo,nMoneda,dFecha,nSumPeso,nTotalPrecio)
//	oPrn:Say( Tpix(nLindet), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
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

static Function fdescuento2(desc1 ,desc2, totalPrecio)

	private ncascada := (totalPrecio * desc1)/100
	private ntotalaux := totalPrecio - ncascada
	private ntotaldesc2 :=  (ntotalaux * desc2)/100
	
return (ntotaldesc2)


Static Function fImpItemCab(nLin)

	// ARTICULO	NOMBRE	PROCEDENCIA	UNIDAD	CANTIDAD	PRECIO	MONTO

	oPrn:Say( Tpix(nLin+00.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "IT", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.5), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(05.8), "DESCRIPCION", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(11.9), "UNID.", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(13.5), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(16.1), "PRECIO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(18.6), "IMPORTE", oFont10C)
	oPrn:Say( Tpix(nLin+00.7), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)

Return(nLin+03.0)

Static Function fImpItem(nLin,nPrecio,nPrecioImporte)

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), C6_ITEM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(01.5), C6_PRODUTO, oFont08C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(05.8), Left(C6_UESPECI,50), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.0), C6_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(12.7),Transform(C6_QTDVEN,"@A 99,999,999.99"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.1),Transform(nPrecio,"@A 99,999,999.99"), oFont10C)
	//oPrn:Say( Tpix(nLin+01.5), Tpix(17.5), Transform(C6_VALOR,"@A 999,999,999.99"), oFont10C) //edson
	oPrn:Say( Tpix(nLin+01.5), Tpix(17.5), Transform(nPrecioImporte,"@A 999,999,999.99"), oFont10C)
	If Len(AllTrim(C6_UESPECI)) > 50
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),Right(C6_UESPECI,30), oFont10C)
		nLin:= nLin+00.3
	EndIf
	/*cDesc2 := POSICIONE("SB1",1,XFILIAL("SB1")+C6_PRODUTO,"B1_UESPEC2")
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
	EndIf*/
	// Adicion Lote
	If !Empty(C6_LOTECTL)
		oPrn:Say( Tpix(nLin+01.8), Tpix(03.8),C6_LOTECTL, oFont10C)
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

	If SM0->(Eof())
		SM0->( MsSeek( cEmpAnt + SC5->C5_FILIAL , .T. ))
	Endif

	cFlogo := GetSrvProfString("Startpath","") + "Logo.jpg"
	//oPrn:SayBitmap(90,120, cFlogo,200,200)
	oPrn:SayBitmap(90,120, cFlogo,300,200) //nahim

	tel:= SM0->M0_TEL
	direccion:=SM0->M0_ENDENT

	//oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), SM0->M0_FILIAL, oFont14CN)
	oPrn:Say( Tpix(nLin+00.5), Tpix(09.0), "PEDIDO", oFont18CN)
	oPrn:Say( Tpix(nLin+01.4), Tpix(01.0), "Sucursal: "+ SM0->M0_FILIAL, oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+01.4), Tpix(14.0), "Número: "+C5_NUM, oFont10CN)
	oPrn:Say( Tpix(nLin+01.8), Tpix(01.0), "Cliente: "+ A1_COD +'/'+ A1_LOJA +' - '+ ALLTRIM(C5_UNOMCLI), oFont10CN)
	oPrn:Say( Tpix(nLin+01.8), Tpix(14.0), "NIT: "+iif(!empty(C5_UNITCLI),AllTrim(C5_UNITCLI),AllTrim(A1_CGC)), oFont10CN)
	oPrn:Say( Tpix(nLin+02.2), Tpix(14.0), "Fecha: "+ ffechalarga(C5_EMISSAO), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+02.2), Tpix(01.0), "Forma de Pago: " + alltrim(E4_DESCRI), oFont10CN)
	
	
	//oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Telefono: "+A1_TEL, oFont10CN)

	oPrn:Say( Tpix(nLin+02.6), Tpix(01.0), "Vendedor: " + LTRIM(GetAdvFval('SA3',"A3_NOME",xFilial('SA3') + C5_VEND1 ,1,"" )) 			, oFont10CN)
	oPrn:Say( Tpix(nLin+02.6), Tpix(14.0), "Moneda: "+GetMV("MV_MOEDA"+Alltrim(STR(C5_MOEDA)))							 			, oFont10CN)
	oPrn:Say( Tpix(nLin+03.0), Tpix(01.0), "Dirección: "+A1_END, oFont10CN)
	//oPrn:Say( Tpix(nLin+03.0), Tpix(14.0), ""+ dtoc(ddatabase) +' '+ TIME(), oFont10CN) // edson 27/03/2019

	oPrn:Say( Tpix(nLin+03.4), Tpix(01.0), "Depósito de Entrega: " + C6_LOCAL + " - " + alltrim(NNR_DESCRI) 			, oFont10CN)
	//oPrn:Say( Tpix(nLin+03.4), Tpix(14.0), "PM: " +  IF(C5_DESC1<>0,TRANSFORM(C5_DESC1,"@A 99.99"),TRANSFORM(C5_PDESC,"@A 99.99")) + "%"	, oFont10CN)
	//oPrn:Say( Tpix(nLin+03.8), Tpix(01.0), "Dir.Deposito: " +  ALLTRIM(NNR_UDIREC), oFont10CN)
	oPrn:Say( Tpix(nLin+03.8), Tpix(01.0), "Lugar de Entrega: " +  ALLTRIM(C5_ULUGENT), oFont09CN)
	oPrn:Say( Tpix(nLin+04.6), Tpix(01.0), "Observación: " + alltrim(C5_UOBSERV), oFont09CN)

Return(nLin+05.4)

Static Function fImpTotales(nLin,total,desc,recargo,nMoneda,dfecha,nSumPeso,nTotalPrecio)
	
    // nahim descuento para cuadrar
	nTotDes :=  round(nDescEsp,2) +  round(nDesc1,2) + round(nDesc4,2) // sumo el descuento
	if nTotDes <> 0 .and. (nTotalPrecio - nTotDes) <> round(total+recargo,2) // verifico si existe diferencia en el descuento vs el final
		if nValDesc2 > 0
			nDesc4 += nTotalPrecio   - nTotDes - round(total+recargo,2)// restando la diferencia
		elseif nValDesc1 > 0
			nDesc1 += nTotalPrecio - nTotDes - round(total+recargo,2) // restando la diferencia		
		else // si es que sólo tiene descuento especial
			nDescEsp += nTotalPrecio - nTotDes - round(total+recargo,2) // restando la diferencia	
		endif
	endif
	// termina ajuste
	
	oPrn:Say( Tpix(nLin+01.0), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(13.0), "TOTAL  Bs.                :" +  Transform(nTotalPrecio,"@A 999,999,999.99"), oFont10C)
	if(nValDesc2 > 0)		
		oPrn:Say( Tpix(nLin+02.0), Tpix(13.0), "Descuento Producto  "+ cValtochar(alltrim(Transform(nValDesc2,"@A 999,999,999.99")))+"% :"+ Transform(round(nDesc4,2),"@A 999,999,999.99"),oFont10C) // Nahim adicionando
	end if
	if(nValDesc1 > 0)
		oPrn:Say( Tpix(nLin+02.5), Tpix(13.0), "Otros Descuentos    "+ cValtochar(alltrim(Transform(nValDesc1,"@A 999,999,999.99")))+"% :"+  Transform(round(nDesc1,2),"@A 999,999,999.99"),oFont10C) // Nahim adicionando
	end if	
	if(nDescEsp > 0) // nahim agregando descuento especial
		nLin+= 0.5
		oPrn:Say( Tpix(nLin+02.5), Tpix(13.0), "Descuentos Especiales   "+ "  :"+  Transform( round(nDescEsp,2),"@A 999,999,999.99"),oFont10C) // Nahim adicionando
	end if	
	oPrn:Say( Tpix(nLin+02.5), Tpix(01.0), "________________________________________________________________________________________________________________"	, oFont12C)
	
	oPrn:Say( Tpix(nLin+02.0), Tpix(01.0), "Cantidad Total  :" +  Transform(nValTotQuant,"@A 999,999,999.99") , oFont10C) // Nahim adicionando
	oPrn:Say( Tpix(nLin+02.5), Tpix(01.0), "Peso Total      :" +  Transform(nSumPeso,"@A 999,999,999.99") , oFont10C) // Edson adicionando
	oPrn:Say( Tpix(nLin+03.0), Tpix(13.0), "TOTAL PEDIDO Bs.          :" +  Transform(round(xmoeda(total+recargo,nMoneda,1,stod(dfecha),4),2),"@A 999,999,999.99") , oFont10C) // Edson adicionando
	oPrn:Say( Tpix(nLin+03.5), Tpix(13.0), "TOTAL $us.                :" +  Transform(round(xmoeda(total+recargo,nMoneda,2,stod(dfecha),4),2),"@A 999,999,999.99"), oFont10C)
	//oPrn:Say( Tpix(nLin+05.0), Tpix(03.0), "Elaborado por"															, oFont10C)
	//oPrn:Say( Tpix(nLin+05.0), Tpix(07.0), "Vendedor Externo"															, oFont10C)
	//oPrn:Say( Tpix(nLin+05.0), Tpix(8.5), "VoBo"															, oFont10C)
	//oPrn:Say( Tpix(nLin+05.0), Tpix(13.0), "Recibido Por"															, oFont10C)
	//oPrn:Say( Tpix(nLin+04.3), Tpix(03.0), cUserName																, oFont10C)
	//oPrn:Say( Tpix(nLin+04.5), Tpix(03.0), "_____________"															, oFont10C)
	//oPrn:Say( Tpix(nLin+04.5), Tpix(07.0), "________________"															, oFont10C)
	//oPrn:Say( Tpix(nLin+04.5), Tpix(8.0), "_____________"															, oFont10C)
	//oPrn:Say( Tpix(nLin+04.5), Tpix(13.0), "_____________"															, oFont10C)

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
	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SC5->C5_CLIENTE        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SC5->C5_CLIENTE        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SC5->C5_NUM        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := SC5->C5_NUM        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

Return