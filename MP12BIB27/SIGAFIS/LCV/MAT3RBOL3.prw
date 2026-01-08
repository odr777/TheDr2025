#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "MatrBol3.ch"

/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MAT3RBOL3  ³ Autor ³TdeP					³ Data ³ 01.01.19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Impresión de DaVinci-LCV, en base a fuente MATRBOL3		  ³±±
±±³          ³											                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³27.03.2020³Omar Delgadillo³ Corrección en columnas Tipo, Sucursal y	  ³±±
±±³			 ³				 ³ fecha digitación.						  ³±±
±±³			 ³				 ³ Corrección campo Estado NCD - Compras	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function MAT3RBOL3()
	Local oReport := nil
	Local cPerg:= "MTRBO3" //Padr("RELAT001",10)
	Local cTitulo	:= STR0020 + " " + STR0021 + "/" + STR0022
	Local cDescr1	:= STR0030
	Local cNomeProg	:= "MATRBOL3"
	Local aArea		:= getArea()

	Private cAliasLCV	:= "LCV"
	Private cTam		:= "G"
	Private wnRel		:= ""
	Private aReturn		:= {"Zebrado", 1,"Administracao", 2, 2, 1, "", 1}
	Private lEnd		:= .F.
	Private nLastKey	:= 0
	Private m_pag		:= 1

	Private cDesCom 	:= SUBSTR(STR0060,1,10) + CRLF + SUBSTR(STR0060,12,16) + CRLF + SUBSTR(STR0060,29,19)
	Private cDesVen 	:= SUBSTR(STR0062,1,10) + CRLF + SUBSTR(STR0062,12,16) + CRLF + SUBSTR(STR0062,29,19)
	Private cSTR0009 	:= SUBSTR(STR0009,1,8) + CRLF + SUBSTR(STR0009,10,10)
	Private cSTR0055 	:= SUBSTR(STR0055,1,11) + CRLF + SUBSTR(STR0055,13,13)
	Private cSTR0008 	:= SUBSTR(STR0008,1,9) + CRLF + SUBSTR(STR0008,11,12)
	Private cSTR0040 	:= SUBSTR(STR0040,1,6) + CRLF + SUBSTR(STR0040,8,7)
	Private cSTR0011 	:= SUBSTR(STR0011,1,12) + CRLF + SUBSTR(STR0011,14,11)
	Private cSTR0061 	:= SUBSTR(STR0061,1,13) + CRLF + SUBSTR(STR0061,15,13) + CRLF + SUBSTR(STR0061,29,7)
	Private cSTR0012 	:= SUBSTR(STR0012,1,6) + CRLF + SUBSTR(STR0012,8,10) + CRLF + SUBSTR(STR0012,19,9)
	Private cSTR0014 	:= SUBSTR(STR0014,1,12) + CRLF + SUBSTR(STR0014,14,12) + CRLF + SUBSTR(STR0014,27,6)
	Private cSTR0017 	:= SUBSTR(STR0017,1,12) + CRLF + SUBSTR(STR0017,14,12) + CRLF + SUBSTR(STR0017,27,6)
	Private cSTR0018 	:= SUBSTR(STR0018,1,6) + CRLF + SUBSTR(STR0018,8,6)
	Private cSTR0013 	:= SUBSTR(STR0013,1,7) + CRLF + SUBSTR(STR0013,9,6)
	Private cSTR0015 	:= SUBSTR(STR0015,1,9) + CRLF + SUBSTR(STR0015,11,7)
	Private cSTR0010 	:= SUBSTR(STR0010,1,13) + CRLF + SUBSTR(STR0010,15,8)
	Private cSTR0057 	:= SUBSTR(STR0057,1,13) + CRLF + SUBSTR(STR0057,15,12)
	Private cSTR0058 	:= SUBSTR(STR0058,1,10) + CRLF + SUBSTR(STR0058,12,8) + CRLF + SUBSTR(STR0058,21,14)
	Private cSTR0003 	:= SUBSTR(STR0003,1,7) + CRLF + SUBSTR(STR0003,9,8)
	Private cSTR0056 	:= SUBSTR(STR0056,1,10) + CRLF + SUBSTR(STR0056,12,8)

	//Incluo/Altero as perguntas na tabela SX1
	CriaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando disponível no bot?o aç?es relacionadas
	Pergunte(cPerg,.T.)

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
	RestArea(aArea)

Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	//	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	Local nLin		:= 0
	Local nPag		:= 0
	Local nAltPag	:= 0
	Local nLarPag	:= 0
	Local nCpo		:= 0
	Local nPos		:= 0
	Local nEspTot	:= 0
	Local cTitulo	:= ""
	Local cTit		:= ""
	Local cCpoCol    := ""
	Local aTitulo	:= {}
	Local aDados	:= {}
	Local xConteudo := ""

	Private aCposImp	:= {}
	Private aTitDet		:= {}
	Private aCab		:= {}
	Private cLinDet		:= ""
	Private nLinTit		:= 0
	Private nTotFat		:= 0
	Private nTotExp		:= 0
	Private nTotTxz     := 0
	Private nTotIse		:= 0
	Private nTotBas		:= 0
	Private nTotIVA		:= 0
	Private nTotFtOri  := 0
	Private nSubTot  := 0
	Private nDescont  := 0

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	//Omar 20190802
	//Omar 20200327 Corregir nombre de los libros
	If MV_PAR03 == 1 
		oReport := TReport():New(cNome,"Libro de Compras",cNome,{|oReport| ReportPrint(oReport)},"Descriç?o do meu relatório")
	elseif MV_PAR03 == 2
		oReport := TReport():New(cNome,"Libro de Ventas",cNome,{|oReport| ReportPrint(oReport)},"Descriç?o do meu relatório")
	elseif MV_PAR03 == 3
		oReport := TReport():New(cNome,"Libro de Compras (Notas C/D)", cNome,{|oReport| ReportPrint(oReport)},"Descriç?o do meu relatório")
	else
		oReport := TReport():New(cNome,"Libro de Ventas (Notas C/D)", cNome,{|oReport| ReportPrint(oReport)},"Descriç?o do meu relatório")
	endif
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)

	//	TReport():HideParamPage( )
	oReport:ParamReadOnly(.T.)
	//Monstando a primeira seç?o
	//Neste exemplo, a primeira seç?o será composta por duas colunas, código da NCM e sua descriç?o
	//Iremos disponibilizar para esta seç?o apenas a tabela SYD, pois quando voc? for em personalizar
	//e entrar na primeira seç?o, voc? terá todos os outros campos disponíveis, com isso, será
	//permitido a inserç?o dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas voc?
	//terá toda a liberdade de modificá-los via relatorio.
	oSection1:= TRSection():New(oReport, "NCM", {"SYD"}, , .F., .T.)

	If MV_PAR03 == 1 // Compras

		MsgRun(STR0002,STR0001,{|| U_DavinciV("C",MV_PAR06,MV_PAR07)}) //"Preparando as informacoes para o livro de compras"###"Livros fiscais"
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
		TRCell():New(oSection1,"TIPO" ,"","ESP.","@!",01)                //"Especie"
		TRCell():New(oSection1,"NUMSEQ" ,"",STR0036,"@!",08)                //"No"
		//    TRCell():New(oSection1,"EMISSAO","",STR0055,"@!",10)                //"Data da Fatura ou DUE"
		TRCell():New(oSection1,"EMISSAO","",cSTR0055,"@!",12)                //"Data da Fatura ou DUE"
		TRCell():New(oSection1,"NIT","",STR0004,"@!",13)							//"NIT DO FORNECEDOR"
		TRCell():New(oSection1,"RAZSOC","",STR0023,"@!",60)						//"Nome ou Raz?o Social"
		TRCell():New(oSection1,"NFISCAL","",cSTR0056,"@!",18,,,"LEFT")						//"No DA FATURA"
		//    TRCell():New(oSection1,"POLIZA","","STR0007","@!",16)						//"No de DUE"
		TRCell():New(oSection1,"POLIZA","","Nº de DUI","@!",16)						//"No de DUE"
		TRCell():New(oSection1,"NUMAUT","",cSTR0008,"@!",17)						//"Numero DE AUTORIZACAO"
		TRCell():New(oSection1,"VALCONT","@R 999,999,999.99",cSTR0057,"",18)	//"VALOR TOTAL DA COMPRA"
		TRCell():New(oSection1,"EXENTAS","",cSTR0058,"",18)	//"VALOR NAO SUJEITO A CREDITO FISCAL"
		TRCell():New(oSection1,"SUBTOT","@R 999,999,999.99",STR0059,"",18)   //"SUBTOTAL"
		//TRCell():New(oSection1,"DESCONT","",STR0060,"",14)   //"Descontos Bonificaç?es e Abatimentos Obtidos"
		TRCell():New(oSection1,"DESCONT","@R 999,999,999.99",cDesCom,"",18)   //ODR 02/08/2019
		TRCell():New(oSection1,"BASEIMP","@R 999,999,999.99",cSTR0014,"",18)	//"Valor Base para Crédito Fiscal"
		TRCell():New(oSection1,"VALIMP","",cSTR0013,"",18)	   //"Credito Fiscal"
		TRCell():New(oSection1,"CODCTR","",cSTR0015,"",25)						//"CODIGO DE CONTROLE"
		TRCell():New(oSection1,"TIPONF","","TIPO","@!",02)                  //"TIPO DE FATURA"

		IF MV_PAR09 == 1 // IMPRIME SERIE Y NRO DIARIO 
			TRCell():New(oSection1,"FILIAL" ,"","Sucursal","@!",04)                //"Sucursal"
			TRCell():New(oSection1,"DTDIGIT","","Fecha de Digitación","@!",12)     //"Fecha de digitación"
			TRCell():New(oSection1,"SERIE" ,"","Serie","@!",03,/*lPixel*/, {||(cAliasLCV)->SERIE})// Serie
			TRCell():New(oSection1,"NODIA","","Nro.Diario","@!",10,/*lPixel*/, {||(cAliasLCV)->NODIA})//NUMERO DIARIO CONTABILIDAD
		endif

		IF MV_PAR08 == 1 
			TRFunction():New(oSection1:Cell("VALCONT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALCONT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("EXENTAS"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->EXENTAS }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("SUBTOT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->SUBTOT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("DESCONT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->DESCONT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("BASEIMP"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->BASEIMP }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("VALIMP"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALIMP }/*uFormula*/,.F.,.T.) 
		ENDIF
	ElseIf MV_PAR03 == 2  // Vendas

		MsgRun(STR0016,STR0001,{|| U_DavinciV("V",MV_PAR06,MV_PAR07)}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
		TRCell():New(oSection1,"TIPO" ,"","ESP.","@!",01)                //"Especie"
		TRCell():New(oSection1,"NUMSEQ" ,"",STR0036,"@!",08)                //"No"
		TRCell():New(oSection1,"EMISSAO","",cSTR0009,"@!",12)                //"Data da Fatura ou DUE"
		//TRCell():New(oSection1,"NFISCAL","",STR0006,"@!",18,,,"LEFT")                //"No DE FATURA"(No DE FACTURA)
		TRCell():New(oSection1,"NFISCAL","",STR0006,"@!",18,,,"RIGHT")                //"No DE FATURA"(No DE FACTURA)
		TRCell():New(oSection1,"NUMAUT","",cSTR0008,"",17)                 //"NUMERO DE AUTORIZACAO"(No DE AUTORIZACION)
		TRCell():New(oSection1,"STATUSNF","",STR0019,"",6)                //"ESTADO"
		TRCell():New(oSection1,"NIT","",cSTR0040,"",13)                    //"NIT/CI CLIENTE"
		TRCell():New(oSection1,"RAZSOC","",STR0005,"",60)					   //"NOME OU RAZAO SOCIAL"(NOMBRE O RAZON SOCIAL)
		TRCell():New(oSection1,"VALCONT","@R 999,999,999.99",cSTR0010,"",18)   //"VALOR TOTAL DE VENDA"(IMPORTE TOTAL DE VENTA)
		TRCell():New(oSection1,"EXENTAS","@R 999,999,999.99",cSTR0011,"",18)   //"VALOR ICE/ IEHD/ TAXAS"(IMPORTE ICE/ IEHD/ TASAS)
		TRCell():New(oSection1,"EXPORT","@R 999,999,999.99",cSTR0061,"",18)    //"EXPORTACOES E OPERACOES ISENTAS"(EXPORTACIONES Y OPERACIONES EXENTAS)
		TRCell():New(oSection1,"TAXAZERO","@R 999,999,999.99",cSTR0012,"",18)   //"VENDAS GRAVADAS A TAXA ZERO"(VENTAS GRAVADAS A TASA CERO)
		TRCell():New(oSection1,"SUBTOT","@R 999,999,999.99",STR0059,"",18)    //"SUBTOTAL"
		//TRCell():New(oSection1,"DESCONT","",STR0062,"",14)   //"DESCONTOS BONIFICACOES E ABATIMENTOS CONCEDIDOS"(DESCUENTOS BONIFICACIONES Y REBAJAS OTORGADAS)
		TRCell():New(oSection1,"DESCONT","@R 999,999,999.99",cDesVen,"",18)   //ODR 02/08/2019
		TRCell():New(oSection1,"BASEIMP","@R 999,999,999.99",cSTR0017,"",18)   //"VALOR BASE PARA DEBITO FISCAL"(IMPORTE BASE PARA DEBITO FISCAL)
		TRCell():New(oSection1,"VALIMP","@R 999,999,999.99",cSTR0018,"",18)    //"DEBITO FISCAL"(DEBITO FISCAL)
		TRCell():New(oSection1,"CODCTR","",cSTR0015,"",14)						//"CODIGO DE CONTROLE"(CODIGO DE CONTROL)

		IF MV_PAR09 == 1 // IMPRIME SERIE Y NRO DIARIO 
			TRCell():New(oSection1,"FILIAL" ,"","Sucursal","@!",04)            //"Sucursal"
			TRCell():New(oSection1,"SERIE" ,"","Serie","@!",03)                //"Serie"
			// TRCell():New(oSection1,"SERIE" ,"","Serie","@!",03,/*lPixel*/, {||(cAliasLCV)->SERIE})// Serie
			TRCell():New(oSection1,"NODIA","","Nro.Diario","@!",10,/*lPixel*/, {||(cAliasLCV)->NODIA})//NUMERO DIARIO CONTABILIDAD
		endif

		IF MV_PAR08 == 1 
			TRFunction():New(oSection1:Cell("VALCONT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALCONT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("EXENTAS"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->EXENTAS }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("EXPORT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->EXPORT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("TAXAZERO"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->TAXAZERO }/*uFormula*/,.F.,.T.)  
			TRFunction():New(oSection1:Cell("SUBTOT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->SUBTOT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("DESCONT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->DESCONT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("BASEIMP"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->BASEIMP }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("VALIMP"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALIMP }/*uFormula*/,.F.,.T.) 
		ENDIF				
	Else //Compras Deb/Cre e ou Ventas Deb/Cre

		// MV_PAR03==3, es NDC Compras, por tanto genera débito
		MsgRun(STR0016,STR0001,{|| u_DaVinciV(Iif(MV_PAR03==3, "VDC", "CDC"), MV_PAR06, MV_PAR07)}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
				
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
		/* SEGUN LA DOCUMENTACION
		oParent	Objeto	Objeto da classe TRSection que a célula pertence
		cName	Caracter	Nome da célula
		cAlias	Caracter	Tabela utilizada pela célula
		cTitle	Caracter	Título da célula
		cPicture	Caracter	Mascara da célula
		nSize	Numérico	Tamanho da célula
		lPixel
		*/

		//	    TRCell():New(oSection1,"NUMSEQ"  ,20,"","C",STR0036)                   // "No"
		//	    TRCell():New(oSection1,"EMISSAO" ,10,"","D",STR0037)                   // "Data Nota de Crédito/Débito"
		//	    TRCell():New(oSection1,"NFISCAL" ,18,"","C",STR0038)                   // "No Nota de Crédito - Débito"
		//	    TRCell():New(oSection1,"NUMAUT"  ,15,"","C",STR0039)                   // "No DE AUTORIZACAO"

		TRCell():New(oSection1,"TIPO" ,"","ESP.","@!",01)                //"Especie"
		TRCell():New(oSection1,"NUMSEQ"  ,"",STR0036,"",20)                   // Solo para NCD de Compras
		TRCell():New(oSection1,"EMISSAO" ,"",STR0037,"",10)                   // "Data Nota de Crédito/Débito"
		TRCell():New(oSection1,"NFISCAL" ,"",STR0038,"",18)                   // "No Nota de Crédito - Débito"
		TRCell():New(oSection1,"NUMAUT"  ,"",STR0039,"",15)                   // "No DE AUTORIZACAO"

		// TRCell():New(oSection1,"DESCONT","",cDesVen,"",20) PREVIA IMPLEMENTACION
		
		If MV_PAR03==3
			TRCell():New(oSection1,"STATUSNF","",STR0019,"",06)                   // "ESTADO"
			//	        TRCell():New(oSection1,"STATUSNF",06,"","C",STR0019)                   // "ESTADO"
		EndIf
		
		//	    TRCell():New(oSection1,"NIT"     ,13,"","C",Iif(MV_PAR03==3,STR0040,STR0052))      // "NIT/CI Cliente"##"NIT Provedor"
		//	    TRCell():New(oSection1,"RAZSOC"  ,60,"","C",Iif(MV_PAR03==3,STR0041,STR0053))      // "Nombre ou Raz?o Social Cliente"##"Nombre ou Raz?o Social Provedor"
		//	    TRCell():New(oSection1,"VALCONT" ,12,"@R 999,999,999.99","N",STR0042+" "+Iif(MV_PAR03==3,STR0050,STR0051))      // "Valor total da Devoluç?o ou Rescis?o"##"Recebida"##"Efetuada"
		//	    TRCell():New(oSection1,"VALIMP" ,12,"@R 999,999,999.99","N",Iif(MV_PAR03==3,STR0043,STR0054))       // "Crédito Fiscal"##"Debito Fiscal"
		//	    TRCell():New(oSection1,"CODCTR",17,"","C",STR0044)                     // "Código de Controle da Nota de Crédito - Débito"
		//	    TRCell():New(oSection1,"DTNFORI",10,"","D",STR0045)                    // "Data Fatura Original"
		//	    TRCell():New(oSection1,"NFORI",15,"","C",STR0046)                      // "N? Fatura Original"
		//	    TRCell():New(oSection1,"AUTNFORI",15,"","C",STR0047)                    // "N? de Autorizaç?o Fatura Original"
		//	    TRCell():New(oSection1,"VALNFORI",12,"@R 9999999.99","N",STR0048)      // "Valor Total Fatura Original"
		TRCell():New(oSection1,"NIT"     ,"",Iif(MV_PAR03==3,STR0040,STR0052),"",13)      // "NIT/CI Cliente"##"NIT Provedor"
		TRCell():New(oSection1,"RAZSOC"  ,"",Iif(MV_PAR03==3,STR0041,STR0053),"",60)      // "Nombre ou Raz?o Social Cliente"##"Nombre ou Raz?o Social Provedor"
		//		TRCell():New(oSection1,"VALCONT" ,"",STR0042+" "+Iif(MV_PAR03==3,STR0050,STR0051),"@R 999,999,999.99",12)      // "Valor total da Devoluç?o ou Rescis?o"##"Recebida"##"Efetuada"
		//		TRCell():New(oSection1,"VALIMP"  ,"",Iif(MV_PAR03==3,STR0043,STR0054),"@R 999,999,999.99",12)       // "Crédito Fiscal"##"Debito Fiscal"
		TRCell():New(oSection1,"VALCONT" ,"",STR0042+" "+Iif(MV_PAR03==3,STR0050,STR0051),"",12)      // "Valor total da Devoluç?o ou Rescis?o"##"Recebida"##"Efetuada"
		TRCell():New(oSection1,"VALIMP"  ,"",Iif(MV_PAR03==3,STR0043,STR0054),"",12)       // "Crédito Fiscal"##"Debito Fiscal" NTP QUITANDO LAYOUT
		TRCell():New(oSection1,"CODCTR"  ,"",STR0044,"",17)                     // "Código de Controle da Nota de Crédito - Débito"
		TRCell():New(oSection1,"DTNFORI" ,"",STR0045,"",10)                    // "Data Fatura Original"
		TRCell():New(oSection1,"NFORI"   ,"",STR0046,"",18)                      // "N? Fatura Original"
		TRCell():New(oSection1,"AUTNFORI","",STR0047,"",15)                    // "N? de Autorizaç?o Fatura Original"
		//		TRCell():New(oSection1,"VALNFORI","",STR0048,"@R 9999999.99",12)      // "Valor Total Fatura Original"
		TRCell():New(oSection1,"VALNFORI","",STR0048,"",12)      // "Valor Total Fatura Original"	

		IF MV_PAR08 == 1 
			TRFunction():New(oSection1:Cell("VALCONT"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALCONT }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("VALIMP"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALIMP }/*uFormula*/,.F.,.T.) 
			TRFunction():New(oSection1:Cell("VALNFORI"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,{|| (cAliasLCV)->VALNFORI }/*uFormula*/,.F.,.T.) 
		ENDIF
		IF MV_PAR09 == 1 // IMPRIME SERIE Y NRO DIARIO 
			TRCell():New(oSection1,"FILIAL" ,"","Sucursal","@!",04)            //"Sucursal"
			TRCell():New(oSection1,"SERIE" ,"","Serie","@!",03,/*lPixel*/, {||(cAliasLCV)->SERIE})// Serie
			// TRCell():New(oSection1,"SERIE" ,"","Serie","@!",03)                //"Serie"
			TRCell():New(oSection1,"NODIA","","Nro.Diario","@!",14,/*lPixel*/, {||(cAliasLCV)->NODIA})//NUMERO DIARIO CONTABILIDAD
		endif
		//
	Endif

	//A segunda seç?o, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, voc? poderia incluir os campos da tabela
	//SYD.Semelhante a seç?o 1, defino o titulo e tamanho das colunas

	oReport:SetTotalInLine(.F.)

	//Aqui, farei uma quebra  por seç?o
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")
Return(oReport)

static function asigVal(nTotBas)

return nTotBas


Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	//

	Local nLin		:= 0
	Local nPag		:= 0
	Local nAltPag	:= 0
	Local nLarPag	:= 0
	Local nCpo		:= 0
	Local nPos		:= 0
	Local nEspTot	:= 0
	Local cTitulo	:= ""
	Local cTit		:= ""
	Local cCpoCol    := ""
	Local aTitulo	:= {}
	Local aDados	:= {}
	Local xConteudo := ""

	Private aCposImp	:= {}
	Private aTitDet		:= {}
	Private aCab		:= {}
	Private cLinDet		:= ""
	Private nLinTit		:= 0
	Private nTotFat		:= 0
	Private nTotExp		:= 0
	Private nTotTxz     := 0
	Private nTotIse		:= 0
	Private nTotBas		:= 0
	Private nTotIVA		:= 0
	Private nTotFtOri  := 0
	Private nSubTot  := 0
	Private nDescont  := 0

	//		If oReport:Cancel()
	//			Exit
	//		EndIf

	//inicializo a primeira seç?o
	oSection1:Init()

	oReport:IncMeter()

	//		cNcm 	:= TRBNCM-&gt;YD_TEC
	//		IncProc("Imprimindo NCM "+alltrim(TRBNCM-&gt;YD_TEC))

	// Nahim otro reporte
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	?Executa a rotina DaVinci() para geracao das informacoes ?
	?fiscais                                                 ?
	?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/

	If MV_PAR03 == 1 // Compras
		//MsgRun(STR0002,STR0001,{|| DaVinci("C")}) //"Preparando as informacoes para o livro de compras"###"Livros fiscais"
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
		//Aadd(aCposImp,{"TIPO",01,"","C",STR0003})                  //"ESPECIE"
		Aadd(aCposImp,{"NUMSEQ" ,06,"","C",STR0036})                //"No"
		//    Aadd(aCposImp,{"EMISSAO",10,"","D",STR0055})                //"Data da Fatura ou DUE"
		Aadd(aCposImp,{"EMISSAO",10,"","D","Fecha de la factura o DUI"})                //"Data da Fatura ou DUE"
		Aadd(aCposImp,{"NIT",13,"","C",STR0004})							//"NIT DO FORNECEDOR"
		Aadd(aCposImp,{"RAZSOC",60,"","C",STR0023})						//"Nome ou Raz?o Social"
		Aadd(aCposImp,{"NFISCAL",18,"","C",STR0056})						//"No DA FATURA"
		Aadd(aCposImp,{"POLIZA",16,"","C",STR0007})						//"No de DUE"
		Aadd(aCposImp,{"NUMAUT",15,"","C",STR0008})						//"Numero DE AUTORIZACAO"
		Aadd(aCposImp,{"VALCONT",14,"@R 999,999,999.99","N",STR0057})	//"VALOR TOTAL DA COMPRA"
		Aadd(aCposImp,{"EXENTAS",14,"@R 999,999,999.99","N",STR0058})	//"VALOR NAO SUJEITO A CREDITO FISCAL"
		Aadd(aCposImp,{"SUBTOT",14,"@R 999,999,999.99","N",STR0059})   //"SUBTOTAL"
		Aadd(aCposImp,{"DESCONT",14,"@R 999,999,999.99","N",STR0060})   //"Descontos Bonificaç?es e Abatimentos Obtidos"
		Aadd(aCposImp,{"BASEIMP",14,"@R 999,999,999.99","N",STR0014})	//"Valor Base para Crédito Fiscal"
		Aadd(aCposImp,{"VALIMP",14,"@R 999,999,999.99","N",STR0013})	   //"Credito Fiscal"
		Aadd(aCposImp,{"CODCTR",14,"","C",STR0015})						//"CODIGO DE CONTROLE"
		Aadd(aCposImp,{"TIPONF",01,"","C",STR0003})                  //"TIPO DE FATURA"
		
		// Personalizados Para Cliente
		Aadd(aCposImp,{"FILIAL" ,04,"","C","SUCURSAL"})                //"Sucursal"
		Aadd(aCposImp,{"DTDIGIT",10,"","D","Fecha de Digitación"})                //"Fecha de digitación"
		// Aadd(aCposImp,{"NODIA",10,"","D","NODIA"})                //"Fecha de digitación"
		Aadd(aCposImp,{"SERIE" ,03,"","C","SERIE"})
		Aadd(aCposImp,{"NODIA" ,10,"","C","NODIA"})

	ElseIf MV_PAR03 == 2  // Vendas

		//    MsgRun(STR0016,STR0001,{|| DaVinci("V")}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */

		// ODR 17/10/2019 adicioné esta línea
		//Aadd(aCposImp,{"TIPO" ,01,"","C","TIPO"})                //"Especie"

		Aadd(aCposImp,{"NUMSEQ" ,06,"","C",STR0036})                //"No"
		Aadd(aCposImp,{"EMISSAO",10,"","D",STR0009})                //"DATA FATURA"(FECHA FACTURA)
		Aadd(aCposImp,{"NFISCAL",18,"","C",STR0006})                //"No DE FATURA"(No DE FACTURA)
		Aadd(aCposImp,{"NUMAUT",15,"","C",STR0008})                 //"NUMERO DE AUTORIZACAO"(No DE AUTORIZACION)
		Aadd(aCposImp,{"STATUSNF",9,"","C",STR0019})                //"ESTADO"
		Aadd(aCposImp,{"NIT",13,"","C",STR0040})                    //"NIT/CI CLIENTE"
		Aadd(aCposImp,{"RAZSOC",60,"","C",STR0005})					   //"NOME OU RAZAO SOCIAL"(NOMBRE O RAZON SOCIAL)
		Aadd(aCposImp,{"VALCONT",14,"@R 999,999,999.99","N",STR0010})   //"VALOR TOTAL DE VENDA"(IMPORTE TOTAL DE VENTA)
		Aadd(aCposImp,{"EXENTAS",14,"@R 999,999,999.99","N",STR0011})   //"VALOR ICE/ IEHD/ TAXAS"(IMPORTE ICE/ IEHD/ TASAS)
		Aadd(aCposImp,{"EXPORT",14,"@R 999,999,999.99","N",STR0061})    //"EXPORTACOES E OPERACOES ISENTAS"(EXPORTACIONES Y OPERACIONES EXENTAS)
		Aadd(aCposImp,{"TAXAZERO",14,"@R 999,999,999.99","N",STR0012})   //"VENDAS GRAVADAS A TAXA ZERO"(VENTAS GRAVADAS A TASA CERO)
		Aadd(aCposImp,{"SUBTOT",14,"@R 999,999,999.99","N",STR0059})    //"SUBTOTAL"
		Aadd(aCposImp,{"DESCONT",14,"@R 999,999,999.99","N",STR0062})   //"DESCONTOS BONIFICACOES E ABATIMENTOS CONCEDIDOS"(DESCUENTOS BONIFICACIONES Y REBAJAS OTORGADAS)
		Aadd(aCposImp,{"BASEIMP",14,"@R 999,999,999.99","N",STR0017})   //"VALOR BASE PARA DEBITO FISCAL"(IMPORTE BASE PARA DEBITO FISCAL)
		Aadd(aCposImp,{"VALIMP",14,"@R 999,999,999.99","N",STR0018})    //"DEBITO FISCAL"(DEBITO FISCAL)
		Aadd(aCposImp,{"CODCTR",14,"","C",STR0015})						//"CODIGO DE CONTROLE"(CODIGO DE CONTROL)

		// Personalizados Para Cliente
		Aadd(aCposImp,{"FILIAL" ,04,"","C","SUCURSAL"})            //"Sucursal"
		Aadd(aCposImp,{"SERIE" ,03,"","C","SERIE"})
		Aadd(aCposImp,{"NODIA" ,10,"","C","NODIA"})

	Else //Compras Deb/Cre e ou Ventas Deb/Cre

		//    MsgRun(STR0016,STR0001,{|| DaVinci(Iif(MV_PAR03==3,"CDC","VDC"))}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
		/*
		Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */


		Aadd(aCposImp,{"NUMSEQ"  ,06,"","C",STR0036})                   // "No"

		Aadd(aCposImp,{"EMISSAO" ,10,"","D",STR0037})                   // "Data Nota de Crédito/Débito"
		Aadd(aCposImp,{"NFISCAL" ,18,"","C",STR0038})                   // "No Nota de Crédito - Débito"
		Aadd(aCposImp,{"NUMAUT"  ,15,"","C",STR0039})                   // "No DE AUTORIZACAO"
		If MV_PAR03==3 
			Aadd(aCposImp,{"STATUSNF",06,"","C",STR0019})                   // "ESTADO"
		EndIf
		Aadd(aCposImp,{"NIT"     ,13,"","C",Iif(MV_PAR03==3,STR0040,STR0052)})      // "NIT/CI Cliente"##"NIT Provedor"
		Aadd(aCposImp,{"RAZSOC"  ,60,"","C",Iif(MV_PAR03==3,STR0041,STR0053)})      // "Nombre ou Raz?o Social Cliente"##"Nombre ou Raz?o Social Provedor"
		Aadd(aCposImp,{"VALCONT" ,14,"","N",STR0042+" "+Iif(MV_PAR03==3,STR0050,STR0051)})      // "Valor total da Devoluç?o ou Rescis?o"##"Recebida"##"Efetuada"
		Aadd(aCposImp,{"VALIMP" ,14,"","N",Iif(MV_PAR03==3,STR0043,STR0054)})       // "Crédito Fiscal"##"Debito Fiscal"
		Aadd(aCposImp,{"CODCTR",17,"","C",STR0044})                     // "Código de Controle da Nota de Crédito - Débito"
		Aadd(aCposImp,{"DTNFORI",10,"","D",STR0045})                    // "Data Fatura Original"
		Aadd(aCposImp,{"NFORI",18,"","C",STR0046})                      // "N? Fatura Original"
		Aadd(aCposImp,{"AUTNFORI",15,"","C",STR0047})                    // "N? de Autorizaç?o Fatura Original"
		Aadd(aCposImp,{"VALNFORI",14,"","N",STR0048})      // "Valor Total Fatura Original"
		
		// Personalizados Para Cliente
		Aadd(aCposImp,{"FILIAL" ,04,"","C","SUCURSAL"})            //"Sucursal"
		Aadd(aCposImp,{"SERIE" ,03,"","C","SERIE"})

	Endif
	/*
	cria a linha de detalhe com a distribuicao dos campos para uso da funcao FmtLin() */
	For nCpo := 1 To Len(aCposImp)
		If nCpo > 1
			cLinDet += " "
		Endif
		cLinDet += Replicate("#",aCposImp[nCpo,2])
	Next
	/*
	Cria array com os cabecalhos dos campos, distribuindo as palavras ("quebrando o titulo") em linhas para que o titulo do campo caiba no espaco
	que foi reservado para esse campo*/
	(cAliasLCV)->(DbGoTop())
	nLarPag := Len(cLinDet)
	nAltPag := 62
	nLinTit := 0
	aTitDet := {}
	For nCpo := 1 To Len(aCposImp)
		cTitulo := Upper(AllTrim(aCposImp[nCpo,5]))
		aTitulo := {}
		While !Empty(cTitulo)
			cTit := AllTrim(Substr(cTitulo,1,aCposImp[nCpo,2]))
			nPos := aCposImp[nCpo,2]
			If !Empty(Substr(cTitulo,aCposImp[nCpo,2] + 1,1))
				While nPos > 0 .And. !Empty(Substr(cTitulo,nPos,1))
					nPos--
				Enddo
				If nPos > 0
					cTit := Substr(cTitulo,1,nPos - 1)
				Else
					nPos := aCposImp[nCpo,2]
				Endif
			Endif
			//Os campos numericos sao "jogados" para a direita
			If aCposImp[nCpo,4] == "N"
				cTit := PadL(cTit,aCposImp[nCpo,2])
			Endif
			Aadd(aTitulo,cTit)
			cTitulo := LTrim(Substr(cTitulo,nPos + 1))
		Enddo
		nLinTit := Max(nLinTit,Len(aTitulo))
		Aadd(aTitDet,aTitulo)
	Next
	//
	nTotFat	:= 0
	nTotIC	:= 0
	nTotIse	:= 0
	nTotBas	:= 0
	nTotIVA   := 0
	nTotFtOri := 0
	nTotExp   := 0
	nTotTxz   := 0

	// alert("Mucho Antes... ")
	//SetRegua((cAliasLCV)->(RecCount()))
	While !((cAliasLCV)->(Eof())) .And. !lEnd
		/*
		Impressao do cabecalho do livro */
		nPag++
		//	nLin := BOL3Cabec(nPag)
		/*
		Impressao do detalhe do livro */
		nPos := 0
		// alert("Antes... ")
		While !((cAliasLCV)->(Eof())) .And. !lEnd
			// alert("Despues... ")
			aDados := {}
			For nCpo := 1 To Len(aCposImp)

				cCpoCol   := aCposImp[nCpo,1]
				xConteudo := Iif(MV_PAR03>2 .and. cCpoCol=="VALCONT" .and. !Empty((cAliasLCV)->BASEIMP),(cAliasLCV)->BASEIMP,(cAliasLCV)->(FieldGet(FieldPos(aCposImp[nCpo,1]))))

				/*If Empty(aCposImp[nCpo,3])
				Aadd(aDados,PadR(Iif(AllTrim((cAliasLCV)->STATUSNF)<>"V" .and. cCpoCol$"VALCONT|VALIMP",0,xConteudo),aCposImp[nCpo,2]))
				Else
				Aadd(aDados,Transform(Iif(AllTrim((cAliasLCV)->STATUSNF)<>"V" .and. cCpoCol$"VALCONT|VALIMP",0,xConteudo),aCposImp[nCpo,3]))
				Endif*/
				If Empty(aCposImp[nCpo,3])
					Aadd(aDados,PadR(Iif(AllTrim((cAliasLCV)->STATUSNF)<>"V" .and. AllTrim((cAliasLCV)->STATUSNF)<>"C" .and. cCpoCol$"VALCONT|VALIMP",0,xConteudo),aCposImp[nCpo,2]))
				Else
					Aadd(aDados,Transform(Iif(AllTrim((cAliasLCV)->STATUSNF)<>"V" .and. AllTrim((cAliasLCV)->STATUSNF)<>"C" .and. cCpoCol$"VALCONT|VALIMP",0,xConteudo),aCposImp[nCpo,3]))
				Endif
			Next

			// Omar 23/10/2019
			DO CASE				
				CASE MV_PAR03 == 1	// compra
					oSection1:Cell("TIPO"):SetValue(1)
					
				CASE MV_PAR03 == 2	// venta
					oSection1:Cell("TIPO"):SetValue(3)

				CASE MV_PAR03 == 3	// Notas Crédito/Débito - Compras
					oSection1:Cell("TIPO"):SetValue(2)
				
				CASE MV_PAR03 == 4	// Notas Crédito/Débito - Ventas
					oSection1:Cell("TIPO"):SetValue(7)
			ENDCASE

			oSection1:Cell(aCposImp[1,1]):SetValue(aDados[1])
			oSection1:Cell(aCposImp[2,1]):SetValue(aDados[2])
			oSection1:Cell(aCposImp[3,1]):SetValue(aDados[3])
			oSection1:Cell(aCposImp[4,1]):SetValue(aDados[4])
			oSection1:Cell(aCposImp[5,1]):SetValue(aDados[5])
			oSection1:Cell(aCposImp[6,1]):SetValue(aDados[6])
			oSection1:Cell(aCposImp[7,1]):SetValue(aDados[7])
			oSection1:Cell(aCposImp[8,1]):SetValue(aDados[8])
			oSection1:Cell(aCposImp[9,1]):SetValue(aDados[9])
			oSection1:Cell(aCposImp[10,1]):SetValue(aDados[10])
			oSection1:Cell(aCposImp[11,1]):SetValue(aDados[11])
			oSection1:Cell(aCposImp[12,1]):SetValue(aDados[12])
			oSection1:Cell(aCposImp[13,1]):SetValue(aDados[13])
			
			If MV_PAR03 == 1 // si es compras tiene 15 columnas 
				oSection1:Cell(aCposImp[14,1]):SetValue(aDados[14])
				oSection1:Cell(aCposImp[15,1]):SetValue(aDados[15])
			Endif

			If MV_PAR03 == 2  // si es ventas tiene 16 columnas
				oSection1:Cell(aCposImp[14,1]):SetValue(aDados[14])
				oSection1:Cell(aCposImp[15,1]):SetValue(aDados[15])
				oSection1:Cell(aCposImp[16,1]):SetValue(aDados[16])				
			Endif

			IF MV_PAR09 == 1 // IMPRIME SERIE Y NRO DIARIO 
				If MV_PAR03 == 1 // si es compras tiene 15 columnas 
					oSection1:Cell(aCposImp[16,1]):SetValue(aDados[16])
					oSection1:Cell(aCposImp[17,1]):SetValue(aDados[17])
					oSection1:Cell(aCposImp[18,1]):SetValue(aDados[18])
					oSection1:Cell(aCposImp[19,1]):SetValue(aDados[19])
				elseif MV_PAR03 == 2
					oSection1:Cell(aCposImp[17,1]):SetValue(aDados[17])
					oSection1:Cell(aCposImp[18,1]):SetValue(aDados[18])
					oSection1:Cell(aCposImp[19,1]):SetValue(aDados[19])
				else
					oSection1:Cell(aCposImp[14,1]):SetValue(aDados[14])
					oSection1:Cell(aCposImp[15,1]):SetValue(aDados[15])
					oSection1:Cell(aCposImp[16,1]):SetValue(aDados[16])
				Endif
			ENDIF

			If AllTrim((cAliasLCV)->STATUSNF) == "V"
				nTotFat += Iif(MV_PAR03>2 .and. !Empty((cAliasLCV)->BASEIMP),(cAliasLCV)->BASEIMP,(cAliasLCV)->VALCONT)

				If MV_PAR03 == 2
					nTotExp += (cAliasLCV)->EXPORT
					nTotTxz += (cAliasLCV)->TAXAZERO
				EndIf

				nTotIse += (cAliasLCV)->EXENTAS
				nTotBas += (cAliasLCV)->BASEIMP
				nTotIVA += (cAliasLCV)->VALIMP
				nTotFtOri+= (cAliasLCV)->VALNFORI
				nSubTot  += (cAliasLCV)->SUBTOT
				nDescont += (cAliasLCV)->DESCONT

			Endif
			If lEnd
				(cAliasLCV)->(DbGoBottom())
			Endif
			oSection1:Printline() // imprime linea.
			(cAliasLCV)->(DbSkip())
			//		IncRegua()
		Enddo
	Enddo
	If Select(cAliasLCV) > 0
		DbSelectArea(cAliasLCV)
		DbCloseArea()
	Endif
	If lEnd
		cTit := Upper(AllTrim(STR0032))
		nPos := (nLarPag - Len(cTit)) / 2
		@PRow() + 2,nPos PSay cTit
	Endif
	//
	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnRel)
	Endif


	oSection1:Finish()

Return()



Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","Data inicial ?       ","¿Fecha inicial ?     ","Initial Date ?       ","MV_CH0","D",08,0,0,"G","","","","","MV_PAR01","","")
	xPutSX1(cPerg,"02","Data final ?         ","¿Fecha final ?       ","Final Date ?         ","MV_CH0","D",08,0,0,"G","","","","","MV_PAR02","","")
	xPutSX1(cPerg,"03","Livro ?              ","¿Libro ?             ","Book ?               ","MV_CH0","N",01,0,4,"C","","","","","MV_PAR03","Compra","Compras","Purchases","","Vendas","Ventas","Sales","NCD-Compra","NCD-Compras","NCD-Purchases","NCD-Vendas","NCD-Ventas","NCD-Sales")
	xPutSX1(cPerg,"04","C.I. ?               ","¿C.I. ?              ","C.I. ?               ","MV_CH0","C",20,0,0,"G","","","","","MV_PAR04","","")
	xPutSX1(cPerg,"05","Responsavel ?        ","¿Responsable ?       ","Responsible ?        ","MV_CH0","C",55,0,0,"G","","","","","MV_PAR05","","")
	xPutSX1(cPerg,"06","Sucursal Inicial     ","Sucursal Inicial     ","Sucursal Inicial     ","MV_CH0","C",04,0,0,"G","","SM0","","","MV_PAR06","","")
	xPutSX1(cPerg,"07","Sucursal Final       ","Sucursal Final       ","Sucursal Final       ","MV_CH0","C",04,0,0,"G","","SM0","","","MV_PAR07","","")
	xPutSX1(cPerg,"08","Imprime totales?     ","Imprime totales?     ","Imprime totales?     ","MV_CHB","N",01,0,0,"C","","","","","MV_PAR08","SI","SI","SI","","NO","NO","NO")
	xPutSX1(cPerg,"09","Columnas Adicionales?","Columnas Adicionales?","Columnas Adicionales?","MV_CHB","N",01,0,0,"C","","","","","MV_PAR08","SI","SI","SI","","NO","NO","NO")
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
