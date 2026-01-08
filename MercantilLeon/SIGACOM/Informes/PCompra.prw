#Include "PROTHEUS.CH"
#Define DMPAPER_LETTER 1
// Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOMPRA   ºAutor  ³Edwar Andia     	 º Data ³  30/12/2015º ±±
±±ºPrograma  ³PCOMPRA   ºAutor  ³Nahim Terrazas      º Data ³  15/02/2016º ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ informe de Pedido de Compra						          º±±
±±ºDesc.     ³ Nahim inclusion de lotes         						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\Mercantil Leon Srl                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PCompra
	Local cString  		:= "SC7"        // Alias do arquivo principal (Base)
	Local cDesc1   		:= "Este Informe tiene como Objetivo"
	Local cDesc2   		:= "Imprimir las Ordenes de compra"
	Local cDesc3   		:= "del proveedor."
	Local aPerAberto	:= {}
	Local aPerFechado	:= {}
	Local aPerTodos		:= {}
	Local cSavAlias,nSavRec,nSavOrdem
	Local cQuery 		:= ""
	Private nNroPag 	:= 0
	Private nNroLin 	:= 0
	Private nNroCol 	:= 120
	Private nTamCar 	:= 15   //Tamaño del Caracter (Cantidad de Pixeles por Caracter)
	Private NTotalGs 	:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Private(Basicas)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aReturn  := {"A rayas", 1,"Administracion", 1, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
	Private nLastKey := 0
	Private cPerg    := "M120PC"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Utilizadas na funcao IMPR                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private Titulo  := "Informe Pedido de compra ML"
	Private nTamanho:= "P"
	Private cMes	:= ""

	//Objetos p/ Impresssao Grafica
	Private oFont08, oFont08n, oFont10, oFont10n, oFont11, oFont11n
	Private oPrint

	oFont08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	oFont08n	:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)		//Negrito
	oFont10		:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont10n	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)     //negrito
	oFont11		:= TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
	oFont11n	:= TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)		//negrito
	oFont12		:= TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
	oFont12n	:= TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)		//negrito
	oFontSTit	:= TFont():New("Courier New",14,14,,.F.,,,,.T.,.F.)
	oFontSTitn	:= TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)		//negrito
	oFontTit	:= TFont():New("Courier New",17,17,,.F.,,,,.T.,.F.)
	oFontTitn	:= TFont():New("Courier New",17,17,,.T.,,,,.T.,.F.)		//negrito

	AjustaSx1()

	Pergunte("M120PC",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Asignando los parámetros cuando se esté imprimiendo desde el Browser de Pedido - Botón: Imprimir ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IsInCallStack("A120Impri")
		mv_par01 := SC7->C7_NUM
		mv_par02 := SC7->C7_NUM
		mv_par03 := SC7->C7_EMISSAO
		mv_par04 := SC7->C7_EMISSAO
		mv_par05 := SC7->C7_FORNECE
		mv_par06 := SC7->C7_FORNECE
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnRel:= "PCOMPRA"            //Nome Default do relatorio em Disco
	wnRel:= SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,nTamanho)

	If nLastKey = 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Return
	Endif

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                       ³
	³ mv_par01        //  ¿Tipo Movimiento?					   	 ³
	³ mv_par02        //  ¿Documento?					         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carregando variaveis mv_par?? para Variaveis do Sistema.   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/

	cIniPc		:= mv_par01
	cFimPc		:= mv_par02
	dIniEmi		:= mv_par03
	dFimEmi		:= mv_par04
	cIniProv	:= mv_par05
	cFinProv	:= mv_par06

	oPrint 	:= TMSPrinter():New("Pedido de compra")
	oPrint:SetPortrait()
	//oPrint:SetLandscape()
	oPrint:Setup()
	//oPrint:SetPaperSize(9)
	oPrint:SetPaperSize( DMPAPER_LETTER )

	RptStatus({|lEnd| ImpPC(lEnd,WnRel,cString,aPerAberto,aPerFechado)})
	oPrint:Preview()  		//Visualiza impressao grafica antes de imprimir

Return

/* -------------------------------------------------------------------------------------------------------- */
Static Function ImpPC(lEnd,WnRel,cString,aPerAberto,aPerFechado)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables de Acesso del Usuario                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aSomaVerba[14,2]
	Local nReg 			:= 0
	Local nTotRegPrc	:= 0
	Private nCodSeq		:= 0    	//N. sequencial
	Private nCol	  	:= 80
	Private cMainTmp	:= ""
	Private cNumDoCa	:= ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CAMBIAR EL ANO PARA 4 DIGITOS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SET CENTURY ON

	Begin Sequence
		#IFDEF TOP
		
		//QUERY PARA RETORNAR EL TOTAL DE REGISTROS
		cMainTmp	:= GetNextAlias()
		nTotRegPrc += 0

		cQuery  :=	"SELECT * "
		cQuery  +=	" FROM " + RetSqlName('SC7') + " SC7 "
		cQuery  +=	" WHERE D_E_L_E_T_ <> '*' AND C7_FILIAL = '" + xFilial("SC7") + "'"
		cQuery  +=	" AND C7_NUM BETWEEN '" + cIniPC + "' AND '" + cFimPC + "'"
		cQuery  +=	" AND C7_EMISSAO BETWEEN '" +	DTOS(dIniEmi) + "' AND '" + DTOS(dFimEmi) + "'"
		cQuery  +=	" AND C7_FORNECE BETWEEN '" + cIniProv + "' AND '" + cFinProv + "'"
		cQuery  +=	" ORDER BY C7_FILIAL, C7_NUM, C7_FORNECE ASC"
		//Aviso("",cQuery,{"Ok"},,,,,.T.)

		cQuery := ChangeQuery(cQuery)
		If Select(cMainTmp) > 0  //En uso
			cMainTmp->(DbCloseArea())
		Endif
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cMainTmp, .F., .T.)
		DbSelectArea(cMainTmp)
		DbGoTop()
		#ENDIF
		SetRegua(nTotRegPrc)

		While (cMainTmp)->( !Eof() )// .And. &cInicio <= cFim )
			IncRegua()

			If lEnd
				@Prow()+1,0 PSAY cCancel
				Exit
			Endif

			oPrint:EndPage()
			fCabecalho( nTotRegPrc )

			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial("SC7")+(cMainTmp)->C7_NUM)

			cNumDoCa := (cMainTmp)->C7_NUM
			cxTotal	 := (cMainTmp)->C7_TOTAL
			cxMemo	 := SC7->C7_UOBSPC
			nCodSeq	 := 0	//Reiniciando el Seq por cada documento

			While (cMainTmp)->( !Eof() ) .And. cNumDoCa==(cMainTmp)->C7_NUM
				nCodSeq++
				fImprime(aSomaVerba)
				(cMainTmp)->( DBSKIP() )
				//Exit
				nReg++
				If nReg > 80
					oPrint:Say(nNroLin+40,1700,"Continua en la proxima página -->",oFont08n) // Continua na Proxima pagina ....
					oPrint:EndPage()
					nReg := 0
					fCabecalho( nTotRegPrc )
				EndIf
				if nNroLin > 2910
					oPrint:Say(nNroLin+40,1700,"Continua en la proxima página -->",oFont08n) // Continua na Proxima pagina ....
					oPrint:EndPage()
					fCabecalho( nTotRegPrc )
				endif
			EndDo

			nNroLin += 60
			oPrint:Line(nNroLin,0120,nNroLin,2280)

			nNroLin += 20
			oPrint:Say(nNroLin,1700+20,"TOTAL: ",oFont08n)

			MaFisEnd()
			R111FIniPC(cNumDoCa)
			nTotMerc := MaFisRet(,"NF_VALMERC")

			/*
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial("SC7")+(cMainTmp)->C7_NUM)
			nTotMerc := MaFisRet(,"NF_TOTAL")
			*/
			nTotMerc := Transform(nTotMerc,'@A 9,999,999,999.99')
			oPrint:Say(nNroLin,1970+20, nTotMerc,oFont08n)

			nNroLin += 40
			oPrint:Line(nNroLin,0120,nNroLin,2280)

			nNroLin := 2938 //2968
			oPrint:Say(nNroLin,0120, "OBSERVACIONES: ",oFont08n)
			nNroLin := 3000
			oPrint:Line(nNroLin,0120,nNroLin,2280)

			cObs1Memo := MemoLine(cxMemo,,1)
			cObs2Memo := MemoLine(cxMemo,,2)
			cObs3Memo := MemoLine(cxMemo,,3)

			nNroLin += 30;	oPrint:Say(nNroLin,0120,cObs1Memo,oFont08n)
			nNroLin += 30;	oPrint:Say(nNroLin,0120,cObs2Memo,oFont08n)
			nNroLin += 30;	oPrint:Say(nNroLin,0120,cObs3Memo,oFont08n)

			fRodape()
			oPrint:EndPage()
		Enddo
	End Sequence
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encabezado                       							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCabecalho(nTotRegPrc)
	nNroPag++
	nNroCol 	:= 120
	cFLogo 		:= GetSrvProfString("Startpath","") + "lgrl01.bmp"
	oPrint:StartPage()
	nNroLin 	:= 60
	oPrint:SayBitmap(nNroLin,nNroCol,cFLogo,110,110)
	nNroLin += 60;	oPrint:Say(nNroLin,0850,"PEDIDO DE COMPRA"		,oFontTitn)
	nNroLin += 60;	oPrint:Say(nNroLin,0120,"MERCANTIL LEON SRL"	,oFont08n)
	nNroLin	+= 80;	oPrint:Say(nNroLin,0120,"Proveedor "	,oFont08n)			//"Proveedor: "
	cNombre := Posicione("SA2", 1, xFilial("SA2") + (cMainTmp)->C7_FORNECE, "A2_NOME")
	cNombre := AllTrim(SubStr(cNombre,1,40))
	oPrint:Say(nNroLin,450,"  : " + cNombre,oFont08n)
	oPrint:Say(nNroLin,1600,"Numero de Pedido "	,oFont08n)		//"Num de Pedido: "
	oPrint:Say(nNroLin,1900,"  : " + (cMainTmp)->C7_NUM,oFont08n)

	nNroLin	+= 50;	oPrint:Say(nNroLin,0120,"Condición de Pago "	,oFont08n)	//"Condición de Pago: "
	cCondPg := Posicione("SE4", 1, xFilial("SE4") + (cMainTmp)->C7_COND, "E4_DESCRI")
	cCondPg := AllTrim(SubStr(cCondPg,1,30))
	oPrint:Say(nNroLin,450,"  : " + cCondPg,oFont08n)
	oPrint:Say(nNroLin,1600,"Fecha "	,oFont08n)					//"Fecha: "
	oPrint:Say(nNroLin,1900,"  : " + DTOC(STOD((cMainTmp)->C7_EMISSAO)),oFont08n)

	nNroLin	+= 50;	oPrint:Say(nNroLin,0120,"Condición de Entrega ",oFont08n)	//"Condición de Entrega: "
	cCondEntg := AllTrim(SubStr((cMainTmp)->C7_UCONENT,1,40))
	oPrint:Say(nNroLin,450,"  : " + cCondEntg,oFont08n)
	oPrint:Say(nNroLin,1600,"Moneda "	,oFont08n)					//"Moneda: "
	//cxDescMoed := SuperGetMv("MV_MOEDA"+AllTrim(Str((cMainTmp)->C7_MOEDA,2)))
	If (cMainTmp)->C7_MOEDA > 0
		cxDescMoed := GetMv("MV_MOEDA"+AllTrim(CValToChar((cMainTmp)->C7_MOEDA,2)))
	Else
		cxDescMoed := " "
	EndIf
	oPrint:Say(nNroLin,1900,"  : " + cxDescMoed,oFont08n)
	nNroLin	+= 50;	oPrint:Say(nNroLin,0120,"Comprador ",oFont08n)			//"Comprador: "
	//cxUsr := UsrFullName( RetCodUsr() ) //Nome de User Logado
	//cxUsr := FWLeUserlg((cMainTmp)->C7_USERLGI,1)
	//cxUsr := UsrRetName(SUBSTR(EMBARALHA((cMainTmp)->C7_USERLGI,1),3,6 ) )	//Usuario
	cxUsr := UsrFullName(SUBSTR(EMBARALHA((cMainTmp)->C7_USERLGI,1),3,6 ) ) 	//Nome de Usuario
	cxUsr := Alltrim(SubStr(cxUsr,1,30))
	oPrint:Say(nNroLin,450,"  : " + cxUsr,oFont08n)
	oPrint:Say(nNroLin,1600,"Solicitud de compra "	,oFont08n)	//"Solicitud de compra: "
	oPrint:Say(nNroLin,1900,"  : " + (cMainTmp)->C7_NUMSC,oFont08n)

	nNroLin	+= 50;	oPrint:Say(nNroLin,0120,"Plazo de Entrega ",oFont08n)		//"Plazo de entrega: "
	cPrzEnt := Alltrim(SubStr((cMainTmp)->C7_UPLZENT,1,40))
	oPrint:Say(nNroLin,450,"  : " + cPrzEnt,oFont08n)

	nNroLin	+= 50;	oPrint:Say(nNroLin,0120,"Oferta Proveedor ",oFont08n)		//"Oferta Proveedor: "
	cOferta := Alltrim(SubStr((cMainTmp)->C7_UOFERTA,1,40))
	oPrint:Say(nNroLin,450,"  : " + cOferta,oFont08n)

	nNroLin	+= 50;	oPrint:Say(nNroLin,0120,"Contacto Proveedor "	,oFont08n)			//"Contacto: "
	oPrint:Say(nNroLin,450,"  : " + Posicione("SA2",1,xFilial("SA2")+(cMainTmp)->C7_FORNECE+ (cMainTmp)->C7_LOJA,"A2_CONTATO"),oFont08n)

	//nNroLin += 120
	//oPrint:Box(nNroLin,nNroCol,nNroLin+70,nNroCol+2040)
	//oPrint:Box(nNroLin,nNroCol,nNroLin+100,nNroCol+2200)

	nNroLin += 80
	//oPrint:Box(nNroLin,nNroCol,nNroLin+35,nNroCol+2160)
	oPrint:Box(nNroLin,nNroCol,nNroLin+35,2280)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ -------------------- DETALLE ----------------------------    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nNroLin += 05
	oPrint:Say (nNroLin,nNroCol,"Item",oFont08)				//Tam C 4 	- "Item"
	nNroCol += (nTamCar*5)

	oPrint:Say (nNroLin,nNroCol,"Codigo",oFont08) 			//Tam C 15	- "Código"
	nNroCol += (nTamCar*16)

	oPrint:Say (nNroLin,nNroCol,"Cod.Fabricante",oFont08) 	//Tam C 15- "Cod.Proveedor"
	nNroCol += (nTamCar*18)

	oPrint:Say (nNroLin,nNroCol,"Descripcion",oFont08) 		//Tam C 40 - "Descripción"
	nNroCol += (nTamCar*46)

	oPrint:say (nNroLin,nNroCol,"UM",oFont08) 				//Tam N 02 - "UM"
	nNroCol += (nTamCar*4)

	oPrint:say (nNroLin,nNroCol+80,"Cantidad",oFont08) 		//Tam C 03 - "Cant."
	nNroCol += (nTamCar*16)

	oPrint:Say (nNroLin,nNroCol+16,"Precio Unitario",oFont08) 		//Tam N 05 - "Prc.Unit"
	nNroCol += (nTamCar*18)

	oPrint:Say (nNroLin,nNroCol+84,"Precio Total",oFont08) 		//Tam N 05 - "Total"
	nNroCol += (nTamCar*16)
Return Nil

/* -------------------------------------------------------------------------------------------------------- */
Static Function fImprime(aSomaVerbas)
	Local cCodSeq	:= Str(nCodSeq,4)
	Local nTamProd	:= 0

	//Impressao de Dados Linha 1
	If nCodSeq == 1
		nNroLin += 60
	Else
		nNroLin += 40
	Endif
	IF(nNroLin > 2900)
	EndIf
	nNroCol := 120
	oPrint:say (nNroLin,nNroCol,cCodSeq,oFont08)  						//Tam C 04
	nNroCol += (nTamCar*5)

	oPrint:say (nNroLin,nNroCol,Alltrim((cMainTmp)->C7_PRODUTO),oFont08)//Tam C 15
	nNroCol += (nTamCar*16)

	cxCodProv := Posicione("SB1",1,xFilial("SB1")+(cMainTmp)->C7_PRODUTO, "B1_UCODFAB")
	oPrint:Say (nNroLin,nNroCol,cxCodProv,oFont08)						//Tam C 15
	nNroCol += (nTamCar*18)

	nTamProd := Len(AllTrim((cMainTmp)->C7_UESPECI))
	cDescrip := SubString((cMainTmp)->C7_UESPECI,1,40)
	oPrint:Say (nNroLin,nNroCol,cDescrip,oFont08) 						//Tam C 40
	nNroCol += (nTamCar*46)

	oPrint:Say (nNroLin,nNroCol,Alltrim((cMainTmp)->C7_UM),oFont08) 	//Tam C 02
	nNroCol += (nTamCar*4)

	oPrint:Say (nNroLin,nNroCol,Transform((cMainTmp)->C7_QUANT,'@A 99,999,999.99'),oFont08) //Tam N 14
	nNroCol += (nTamCar*16)

	oPrint:Say (nNroLin,nNroCol,Transform((cMainTmp)->C7_PRECO,'@A 99,999,999.99999'),oFont08) //Tam N 14
	nNroCol += (nTamCar*18)

	oPrint:Say (nNroLin,nNroCol+20,Transform((cMainTmp)->C7_TOTAL,'@A 9,999,999,999.99'),oFont08) //Tam N 14
	nNroCol += (nTamCar*16)

	nNroCol := (120 + (nTamCar*5) + (nTamCar*16) + (nTamCar*18))

	If nTamProd > 40	//Imprimiendo la 2da Linea de la Descripción del Producto
		nNroLin += 40
		cDescrip := SubString((cMainTmp)->C7_UESPECI,41,40)
		oPrint:Say(nNroLin,nNroCol,cDescrip,oFont08) 						//Tam C 40
	Endif

	If LEN(AllTrim((cMainTmp)->C7_UESPEC2)) > 0	//Imprimiendo la 2da Descripción del Producto
		nNroLin += 40
		oPrint:Say(nNroLin,nNroCol,Left((cMainTmp)->C7_UESPEC2,40),oFont08) 						//Tam C 40
	Endif
	If LEN(AllTrim((cMainTmp)->C7_UESPEC2)) > 40	//Imprimiendo la 2da Linea de la 2da Descripción del Producto
		nNroLin += 40
		oPrint:Say(nNroLin,nNroCol,Right((cMainTmp)->C7_UESPEC2,40),oFont08) 						//Tam C 40
	Endif

	// Nahim 15/02/2016: bloque adicionado para imprimir Lote
	if TYPE("C7_ULOTE")!="U"
		If !Empty(C7_ULOTE)	//Imprimiendo el lote
			nNroLin += 40
			oPrint:Say(nNroLin,nNroCol,Alltrim((cMainTmp)->C7_ULOTE),oFont08) 						//Tam C 40
		Endif
	endif
	// Nahim fin bloque

Return Nil

/* -------------------------------------------------------------------------------------------------------- */

Static Function fRodape()
	nNroLin += 40
	oPrint:Line(nNroLin,0120,nNroLin,2280)
	cxRodape := "AV VIEDMA No 51 Z/CEMENTERIO GENERAL - SANTA CRUZ-BOLIVIA - TELF: (+591) 3 3326174 / 3 3331447 / 3 3364244 - FAX: 3 3368672"
	nNroLin += 60
	oPrint:Say(nNroLin,0230,cxRodape,oFont08n)

Return Nil

/* -------------------------------------------------------------------------------------------------------- */
Static Function AjustaSx1()
	Local aArea 	:= GetArea()
	Local aRegs 	:= {}
	Local i			:= 0
	Local cPerg 	:= PADR(cPerg,10)

	SX1->( dbSetOrder(1))
	aAdd(aRegs,{"01","De Pedido? 	:","mv_ch1","C",06	,0,0,"G","mv_par01",""       ,""        ,""        ,""     ,"SC7" 	,""})
	aAdd(aRegs,{"02","A Pedido?  	:","mv_ch2","C",06	,0,0,"G","mv_par02",""       ,""        ,""        ,""     ,"SC7" 	,""})
	aAdd(aRegs,{"03","De Fecha?     :","mv_ch3","D",08	,0,0,"G","mv_par03",""       ,""        ,""        ,""     ,""   	,""})
	aAdd(aRegs,{"04","A Fecha?      :","mv_ch4","D",08	,0,0,"G","mv_par04",""       ,""        ,""        ,""     ,""   	,""})
	aAdd(aRegs,{"05","De Proveedor? :","mv_ch5","C",06	,0,0,"G","mv_par05",""       ,""        ,""        ,""     ,"SA2" 	,""})
	aAdd(aRegs,{"06","A Proveedor? 	:","mv_ch6","C",06	,0,0,"G","mv_par06",""       ,""        ,""        ,""     ,"SA2" 	,""})

	DbSelectArea("SX1")
	DbSetOrder(1)
	For i:=1 to Len(aRegs)
		DbSeek(cPerg+aRegs[i][1])
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
			SX1->X1_DEFSPA1  := aRegs[i][10]
			SX1->X1_DEFSPA2  := aRegs[i][11]
			SX1->X1_DEFSPA3  := aRegs[i][12]
			SX1->X1_DEFSPA4  := aRegs[i][13]
			SX1->X1_F3       := aRegs[i][14]
			SX1->X1_VALID    := aRegs[i][15]
			MsUnlock()
		Endif
	Next i

	RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R111FIniPC³ Autor ³ Edson Maricate        ³ Data ³20/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa as funcoes Fiscais com o Pedido de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R110FIniPC(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Numero do Pedido                                  ³±±
±±³          ³ ExpC2 := Item do Pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110,MATR120,Fluxo de Caixa                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R111FIniPC(cPedido,cItem,cSequen,cFiltro)
	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local cValid	:= ""
	Local nPosRef	:= 0
	Local nItem		:= 0
	Local cItemDe	:= IIf(cItem==Nil,'',cItem)
	Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
	Local cRefCols	:= ''
	DEFAULT cSequen	:= ""
	DEFAULT cFiltro	:= ""

	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
		MaFisEnd()
		MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
		While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
		SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

			// Nao processar os Impostos se o item possuir residuo eliminado
			If &cFiltro
				dbSelectArea('SC7')
				dbSkip()
				Loop
			EndIf

			// Inicia a Carga do item nas funcoes MATXFIS
			nItem++
			MaFisIniLoad(nItem)
			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek('SC7')
			While !EOF() .AND. (X3_ARQUIVO == 'SC7')
				cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
				cValid	:= StrTran(cValid,"'",'"')
				If "MAFISREF" $ cValid
					nPosRef  := AT('MAFISREF("',cValid) + 10
					cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
					// Carrega os valores direto do SC7.
					MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
				EndIf
				dbSkip()
			End
			MaFisEndLoad(nItem,2)
			dbSelectArea('SC7')
			dbSkip()
		End
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return .T.
