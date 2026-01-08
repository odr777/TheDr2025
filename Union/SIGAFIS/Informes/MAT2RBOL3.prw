#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "MatrBol3.ch"

User Function MAT2RBOL3()
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
//	AjustaSX1(cPerg)	
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
	If MV_PAR03 == 1 //Omar 20190802
		oReport := TReport():New(cNome,"Libro de Compras",cNome,{|oReport| ReportPrint(oReport)},"Descriç?o do meu relatório")
	else
		oReport := TReport():New(cNome,"Libro de Ventas",cNome,{|oReport| ReportPrint(oReport)},"Descriç?o do meu relatório")
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
//	TRCell():New(oSection1,"nit"		,"NAHIM","nit"	,"@!",40)
	//	TRCell():New(oSection1,"YD_DESC_P"  ,"TRBNCM","DESCRICAO"	,"@!",200)
	
	
If MV_PAR03 == 1 // Compras

    MsgRun(STR0002,STR0001,{|| U_DavinciV("C",MV_PAR06,MV_PAR07)}) //"Preparando as informacoes para o livro de compras"###"Livros fiscais"
	/*  
    Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
    TRCell():New(oSection1,"TIPO" ,"NAHIM","TIPO","@R 9",02)                //"No"
    TRCell():New(oSection1,"NUMSEQ" ,"NAHIM",STR0036,"@!",08)                //"No"
//    TRCell():New(oSection1,"EMISSAO","",STR0055,"@!",10)                //"Data da Fatura ou DUE"  
    TRCell():New(oSection1,"EMISSAO","",cSTR0055,"@!",12)                //"Data da Fatura ou DUE"  
    TRCell():New(oSection1,"NIT","",STR0004,"@!",13)							//"NIT DO FORNECEDOR"
    TRCell():New(oSection1,"RAZSOC","",STR0023,"@!",60)						//"Nome ou Raz?o Social"   
    TRCell():New(oSection1,"NFISCAL","",cSTR0056,"@!",18,,,"LEFT")						//"No DA FATURA"
//    TRCell():New(oSection1,"POLIZA","","STR0007","@!",16)						//"No de DUE"
    TRCell():New(oSection1,"POLIZA","","Nº de DUI","@!",16)						//"No de DUE"
    TRCell():New(oSection1,"NUMAUT","",cSTR0008,"@!",17)						//"Numero DE AUTORIZACAO"  
    TRCell():New(oSection1,"VALCONT","",cSTR0057,"",12)	//"VALOR TOTAL DA COMPRA"
    TRCell():New(oSection1,"EXENTAS","",cSTR0058,"",12)	//"VALOR NAO SUJEITO A CREDITO FISCAL"
    TRCell():New(oSection1,"SUBTOT","",STR0059,"",12)   //"SUBTOTAL"
    //TRCell():New(oSection1,"DESCONT","",STR0060,"",14)   //"Descontos Bonificaç?es e Abatimentos Obtidos"  
    TRCell():New(oSection1,"DESCONT","",cDesCom,"",14)   //ODR 02/08/2019
    TRCell():New(oSection1,"BASEIMP","",cSTR0014,"",12)	//"Valor Base para Crédito Fiscal" 
    TRCell():New(oSection1,"VALIMP","",cSTR0013,"",12)	   //"Credito Fiscal"    
    TRCell():New(oSection1,"CODCTR","",cSTR0015,"@!",17)						//"CODIGO DE CONTROLE"
    TRCell():New(oSection1,"TIPONF","",cSTR0003,"@!",7)                  //"TIPO DE FATURA"

ElseIf MV_PAR03 == 2  // Vendas

    MsgRun(STR0016,STR0001,{|| U_DavinciV("V",MV_PAR06,MV_PAR07)}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
	/*  
	Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
    TRCell():New(oSection1,"TIPO" ,"NAHIM","TIPO","@R 1",02)                //"No"
    TRCell():New(oSection1,"NUMSEQ" ,"NAHIM",STR0036,"@!",08)                //"No"
    TRCell():New(oSection1,"EMISSAO","",cSTR0009,"@!",12)                //"Data da Fatura ou DUE"  
    TRCell():New(oSection1,"NFISCAL","",STR0006,"@!",18,,,"LEFT")                //"No DE FATURA"(No DE FACTURA)
    TRCell():New(oSection1,"NUMAUT","",cSTR0008,"",17)                 //"NUMERO DE AUTORIZACAO"(No DE AUTORIZACION)
    TRCell():New(oSection1,"STATUSNF","",STR0019,"",6)                //"ESTADO"
    TRCell():New(oSection1,"NIT","",cSTR0040,"",13)                    //"NIT/CI CLIENTE" 
    TRCell():New(oSection1,"RAZSOC","",STR0005,"",60)					   //"NOME OU RAZAO SOCIAL"(NOMBRE O RAZON SOCIAL)
    TRCell():New(oSection1,"VALCONT","",cSTR0010,"",12)   //"VALOR TOTAL DE VENDA"(IMPORTE TOTAL DE VENTA)
    TRCell():New(oSection1,"EXENTAS","",cSTR0011,"",12)   //"VALOR ICE/ IEHD/ TAXAS"(IMPORTE ICE/ IEHD/ TASAS)
    TRCell():New(oSection1,"EXPORT","",cSTR0061,"",15)    //"EXPORTACOES E OPERACOES ISENTAS"(EXPORTACIONES Y OPERACIONES EXENTAS)
    TRCell():New(oSection1,"TAXAZERO","",cSTR0012,"",12)   //"VENDAS GRAVADAS A TAXA ZERO"(VENTAS GRAVADAS A TASA CERO)
    TRCell():New(oSection1,"SUBTOT","",STR0059,"",12)    //"SUBTOTAL"
    //TRCell():New(oSection1,"DESCONT","",STR0062,"",14)   //"DESCONTOS BONIFICACOES E ABATIMENTOS CONCEDIDOS"(DESCUENTOS BONIFICACIONES Y REBAJAS OTORGADAS)
    TRCell():New(oSection1,"DESCONT","",cDesVen,"",14)   //ODR 02/08/2019
    TRCell():New(oSection1,"BASEIMP","",cSTR0017,"",12)   //"VALOR BASE PARA DEBITO FISCAL"(IMPORTE BASE PARA DEBITO FISCAL)
    TRCell():New(oSection1,"VALIMP","",cSTR0018,"",12)    //"DEBITO FISCAL"(DEBITO FISCAL)
    TRCell():New(oSection1,"CODCTR","",cSTR0015,"",14)						//"CODIGO DE CONTROLE"(CODIGO DE CONTROL)

Else //Compras Deb/Cre e ou Ventas Deb/Cre

    MsgRun(STR0016,STR0001,{|| DaVinci(Iif(MV_PAR03==3,"CDC","VDC"))}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
    /*  
    Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */

    TRCell():New(oSection1,"NUMSEQ"  ,06,"","C",STR0036)                   // "No"
    TRCell():New(oSection1,"EMISSAO" ,10,"","D",STR0037)                   // "Data Nota de Crédito/Débito"   
    TRCell():New(oSection1,"NFISCAL" ,18,"","C",STR0038)                   // "No Nota de Crédito - Débito"
    TRCell():New(oSection1,"NUMAUT"  ,15,"","C",STR0039)                   // "No DE AUTORIZACAO"
    
    If MV_PAR03==3
        TRCell():New(oSection1,"STATUSNF",06,"","C",STR0019)                   // "ESTADO"
    EndIf        

    TRCell():New(oSection1,"NIT"     ,13,"","C",Iif(MV_PAR03==3,STR0040,STR0052))      // "NIT/CI Cliente"##"NIT Provedor"
    TRCell():New(oSection1,"RAZSOC"  ,60,"","C",Iif(MV_PAR03==3,STR0041,STR0053))      // "Nombre ou Raz?o Social Cliente"##"Nombre ou Raz?o Social Provedor" 
    TRCell():New(oSection1,"VALCONT" ,12,"@R 9999999.99","N",STR0042+" "+Iif(MV_PAR03==3,STR0050,STR0051))      // "Valor total da Devoluç?o ou Rescis?o"##"Recebida"##"Efetuada"    
    TRCell():New(oSection1,"VALIMP" ,12,"@R 9999999.99","N",Iif(MV_PAR03==3,STR0043,STR0054))       // "Crédito Fiscal"##"Debito Fiscal"
    TRCell():New(oSection1,"CODCTR",17,"","C",STR0044)                     // "Código de Controle da Nota de Crédito - Débito"
    TRCell():New(oSection1,"DTNFORI",10,"","D",STR0045)                    // "Data Fatura Original"
    TRCell():New(oSection1,"NFORI",15,"","C",STR0046)                      // "N? Fatura Original"
    TRCell():New(oSection1,"AUTNFORI",15,"","C",STR0047)                    // "N? de Autorizaç?o Fatura Original"
    TRCell():New(oSection1,"VALNFORI",12,"@R 9999999.99","N",STR0048)      // "Valor Total Fatura Original"


Endif


	
	
	//A segunda seç?o, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, voc? poderia incluir os campos da tabela
	//SYD.Semelhante a seç?o 1, defino o titulo e tamanho das colunas
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seç?o
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

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

//


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
    Aadd(aCposImp,{"NUMSEQ" ,06,"","C",STR0036})                //"No"
//    Aadd(aCposImp,{"EMISSAO",10,"","D",STR0055})                //"Data da Fatura ou DUE"  
    Aadd(aCposImp,{"EMISSAO",10,"","D","Fecha de la factura o DUI"})                //"Data da Fatura ou DUE"  
    Aadd(aCposImp,{"NIT",13,"","C",STR0004})							//"NIT DO FORNECEDOR"
    Aadd(aCposImp,{"RAZSOC",60,"","C",STR0023})						//"Nome ou Raz?o Social"   
    Aadd(aCposImp,{"NFISCAL",18,"","C",STR0056})						//"No DA FATURA"
    Aadd(aCposImp,{"POLIZA",16,"","C",STR0007})						//"No de DUE"
    Aadd(aCposImp,{"NUMAUT",15,"","C",STR0008})						//"Numero DE AUTORIZACAO"  
    Aadd(aCposImp,{"VALCONT",12,"@R 9999999.99","N",STR0057})	//"VALOR TOTAL DA COMPRA"
    Aadd(aCposImp,{"EXENTAS",12,"@R 9999999.99","N",STR0058})	//"VALOR NAO SUJEITO A CREDITO FISCAL"
    Aadd(aCposImp,{"SUBTOT",12,"@R 9999999.99","N",STR0059})   //"SUBTOTAL"    
    Aadd(aCposImp,{"DESCONT",14,"@R 9999999.99","N",STR0060})   //"Descontos Bonificaç?es e Abatimentos Obtidos"
    Aadd(aCposImp,{"BASEIMP",12,"@R 9999999.99","N",STR0014})	//"Valor Base para Crédito Fiscal" 
    Aadd(aCposImp,{"VALIMP",12,"@R 9999999.99","N",STR0013})	   //"Credito Fiscal"    
    Aadd(aCposImp,{"CODCTR",17,"","C",STR0015})						//"CODIGO DE CONTROLE"
    Aadd(aCposImp,{"TIPONF",7,"","C",STR0003})                  //"TIPO DE FATURA"

ElseIf MV_PAR03 == 2  // Vendas

//    MsgRun(STR0016,STR0001,{|| DaVinci("V")}) //"Preparando as informacoes para o livro de vendas"###"Livros fiscais"
	/*  
	Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
    Aadd(aCposImp,{"NUMSEQ" ,06,"","C",STR0036})                //"No"
    Aadd(aCposImp,{"EMISSAO",10,"","D",STR0009})                //"DATA FATURA"(FECHA FACTURA)
    Aadd(aCposImp,{"NFISCAL",18,"","C",STR0006})                //"No DE FATURA"(No DE FACTURA)
    Aadd(aCposImp,{"NUMAUT",15,"","C",STR0008})                 //"NUMERO DE AUTORIZACAO"(No DE AUTORIZACION)
    Aadd(aCposImp,{"STATUSNF",9,"","C",STR0019})                //"ESTADO"
    Aadd(aCposImp,{"NIT",13,"","C",STR0040})                    //"NIT/CI CLIENTE" 
    Aadd(aCposImp,{"RAZSOC",60,"","C",STR0005})					   //"NOME OU RAZAO SOCIAL"(NOMBRE O RAZON SOCIAL)
    Aadd(aCposImp,{"VALCONT",12,"@R 9999999.99","N",STR0010})   //"VALOR TOTAL DE VENDA"(IMPORTE TOTAL DE VENTA)
    Aadd(aCposImp,{"EXENTAS",12,"@R 9999999.99","N",STR0011})   //"VALOR ICE/ IEHD/ TAXAS"(IMPORTE ICE/ IEHD/ TASAS)
    Aadd(aCposImp,{"EXPORT",15,"@R 9999999.99","N",STR0061})    //"EXPORTACOES E OPERACOES ISENTAS"(EXPORTACIONES Y OPERACIONES EXENTAS)
    Aadd(aCposImp,{"TAXAZERO",12,"@R 9999999.99","N",STR0012})   //"VENDAS GRAVADAS A TAXA ZERO"(VENTAS GRAVADAS A TASA CERO)
    Aadd(aCposImp,{"SUBTOT",12,"@R 9999999.99","N",STR0059})    //"SUBTOTAL"
    Aadd(aCposImp,{"DESCONT",14,"@R 9999999.99","N",STR0062})   //"DESCONTOS BONIFICACOES E ABATIMENTOS CONCEDIDOS"(DESCUENTOS BONIFICACIONES Y REBAJAS OTORGADAS)
    Aadd(aCposImp,{"BASEIMP",12,"@R 9999999.99","N",STR0017})   //"VALOR BASE PARA DEBITO FISCAL"(IMPORTE BASE PARA DEBITO FISCAL)
    Aadd(aCposImp,{"VALIMP",12,"@R 9999999.99","N",STR0018})    //"DEBITO FISCAL"(DEBITO FISCAL)
    Aadd(aCposImp,{"CODCTR",14,"","C",STR0015})						//"CODIGO DE CONTROLE"(CODIGO DE CONTROL)

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
    Aadd(aCposImp,{"VALCONT" ,12,"@R 9999999.99","N",STR0042+" "+Iif(MV_PAR03==3,STR0050,STR0051)})      // "Valor total da Devoluç?o ou Rescis?o"##"Recebida"##"Efetuada"    
    Aadd(aCposImp,{"VALIMP" ,12,"@R 9999999.99","N",Iif(MV_PAR03==3,STR0043,STR0054)})       // "Crédito Fiscal"##"Debito Fiscal"
    Aadd(aCposImp,{"CODCTR",17,"","C",STR0044})                     // "Código de Controle da Nota de Crédito - Débito"
    Aadd(aCposImp,{"DTNFORI",10,"","D",STR0045})                    // "Data Fatura Original"
    Aadd(aCposImp,{"NFORI",15,"","C",STR0046})                      // "N? Fatura Original"
    Aadd(aCposImp,{"AUTNFORI",15,"","C",STR0047})                    // "N? de Autorizaç?o Fatura Original"
    Aadd(aCposImp,{"VALNFORI",12,"@R 9999999.99","N",STR0048})      // "Valor Total Fatura Original"


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
nTotIC	   := 0
nTotIse	:= 0
nTotBas	:= 0
nTotIVA   := 0
nTotFtOri := 0
nTotExp   := 0
nTotTxz   := 0

//SetRegua((cAliasLCV)->(RecCount()))
While !((cAliasLCV)->(Eof())) .And. !lEnd
	/*
	Impressao do cabecalho do livro */
	nPag++
//	nLin := BOL3Cabec(nPag)
	/*
	Impressao do detalhe do livro */
	nPos := 0
	While !((cAliasLCV)->(Eof())) .And. !lEnd
		aDados := {}
		For nCpo := 1 To Len(aCposImp)
		
            cCpoCol   := aCposImp[nCpo,1]
            xConteudo := Iif(MV_PAR03>2 .and. cCpoCol=="VALCONT" .and. !Empty((cAliasLCV)->BASEIMP),(cAliasLCV)->BASEIMP,(cAliasLCV)->(FieldGet(FieldPos(aCposImp[nCpo,1]))))

			If Empty(aCposImp[nCpo,3])
				Aadd(aDados,PadR(Iif(AllTrim((cAliasLCV)->STATUSNF)<>"V" .and. cCpoCol$"VALCONT|VALIMP",0,xConteudo),aCposImp[nCpo,2]))
			Else
				Aadd(aDados,Transform(Iif(AllTrim((cAliasLCV)->STATUSNF)<>"V" .and. cCpoCol$"VALCONT|VALIMP",0,xConteudo),aCposImp[nCpo,3]))
			Endif
			
		Next
		
//		oSection1:Cell(NOMBRE DE TU ATRIBUTO DEL OBJETO OS):SetValue(aDados[3])
		
		If MV_PAR03 == 1 // compra
		oSection1:Cell("TIPO"):SetValue(1)
		else
		oSection1:Cell("TIPO"):SetValue(2)		
		endif
		
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
		oSection1:Cell(aCposImp[14,1]):SetValue(aDados[14])
		oSection1:Cell(aCposImp[15,1]):SetValue(aDados[15])
		
		// Nahim tratando nit y 
		
		If MV_PAR03 == 2
			oSection1:Cell(aCposImp[16,1]):SetValue(aDados[16])
		endif
		
//		oSection1:Cell("YD_DESC_P"):SetValue(TRBNCM-&gt;YD_DESC_P)				
		oSection1:Printline()
//		FmtLin(aDados,cLinDet,,,@nLin)
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

