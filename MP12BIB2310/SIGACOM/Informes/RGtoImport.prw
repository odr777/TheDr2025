#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#DEFINE UPOLIZA		1
#DEFINE DOC			2
#DEFINE SERIE  		3
#DEFINE FORNECE		4
#DEFINE LOJA		5
#DEFINE NOME		6
#DEFINE EMISSAO 	7
#DEFINE VALMERC		8
#DEFINE VALBRUT		9
#DEFINE MOEDA		10
#DEFINE TXMOEDA		11
#DEFINE ITEM		12
#DEFINE COD			13
#DEFINE UDESC		14
#DEFINE LOCAL		15
#DEFINE UM			16
#DEFINE QUANT		17
#DEFINE VUNIT		18
#DEFINE TOTAL		19
#DEFINE PEDIDO		20
#DEFINE ITEMPC		21
#DEFINE TOTGTOS		22
#DEFINE TOTPROD		23
#DEFINE PESO		24
#DEFINE USUARIO		25
#DEFINE PESOUNIT	26
#DEFINE PRCUNIT		27
#DEFINE NROREM		28
#DEFINE TOTNCP		29
#DEFINE FECHALANC	30 // FECHA DEL LANZAMIENTO
#DEFINE INFODESC	31 // DESCRIPCION

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ CxPGla  º Autor ³ Amby Arteaga Rivero   º Data ³  01/06/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ REPORTE GASTOS DE IMPORTACIÓN - TdeP			  	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RGtoImport()
	Local oReport



	if(funname() == "MATA143")
		AjustaSx1()
	endif

	If FindFunction("TRepInUse") .And. TRepInUse()
		//	pergunte("RGtoImport",.T.)
		CargarPerg()

		Pergunte("RGtoImport",.F.)

		oReport := ReportDef()
		oReport:PrintDialog()
	Endif

Return Nil

Static Function ReportDef()
	Local oReport
	Local oSection1
	Local nTam, nTamVal, cPictVal, nTamComp
	PRIVATE cPerg := ("RGtoImport")

	nTam	:= 130
	nTamVal	:= TamSX3("F1_VALMERC")[1]
	cPictVal	:= PesqPict("SF1","F1_VALMERC")
	nTamComp := 20
	oReport := TReport():New("GTOIMPORT","GASTOS DE IMPORTACION",cPerg,{|oReport| ReportPrint(oReport,nTamVal)},"Este programa tiene como objetivo imprimir los Gastos de Importacion "+"de acuerdo con los parametros indicados por el usuario")

	//oReport:SetPortrait(.T.)
	oReport:SetLandscape(.T.)

	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01  	      	// Tipo de Reporte                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection0 := TRSection():New(oReport,"***ITEMS CON EL COSTO FINAL : ",,)
	oSection0:SetTotalInLine(.T.)
	oSection0:lPrintHeader := .T.
	oSection0:lHeaderVisible := .T.
	oSection0:lHeaderBreak := .T.

	TRCell():New(oSection0,"F1_UPOLIZA","SF1","NR.IMPORT")
	TRCell():New(oSection0,"F1_DOC","SF1","DOCUMENTO")
	TRCell():New(oSection0,"F1_SERIE","SF1","SERIE")
	TRCell():New(oSection0,"F1_FORNECE","SF1","PROVEEDOR")
	TRCell():New(oSection0,"F1_LOJA","SF1","TIENDA")
	TRCell():New(oSection0,"A2_NOME","SF1","PROVEEDOR")
	TRCell():New(oSection0,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection0,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	//		TRCell():New(oSection0,"F1_VALBRUT","SF1","VALOR BRUTO",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection0,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection0,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)
	TRCell():New(oSection0,"F1_USRREG","SF1","USUARIO",PesqPict("SF1","F1_USRREG"),TamSX3("F1_USRREG")[1],.F.,)
	//TRCell():New(oSection0,"F1_UCORREL","SF1","R-ENT-No",PesqPict("SF1","F1_UCORREL"),TamSX3("F1_UCORREL")[1],.F.,)

	oSection1 := TRSection():New(oReport,"DETALLE DEL INVOICE : ",,)
	TRCell():New(oSection1,"D1_ITEM","SD1","ITEM",PesqPict("SD1","D1_ITEM"),TamSX3("D1_ITEM")[1],.F.,)
	TRCell():New(oSection1,"D1_COD","SD1","CODIGO",PesqPict("SD1","D1_COD"),TamSX3("D1_COD")[1],.F.,)
	TRCell():New(oSection1,"B1_ESPECIF","SB1","DESCRIPCION", PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],.F.,)
	TRCell():New(oSection1,"D1_LOCAL","SD1","DEP", PesqPict("SD1","D1_LOCAL"),TamSX3("D1_LOCAL")[1],.F.,)
	TRCell():New(oSection1,"D1_UM","SD1","UM", PesqPict("SD1","D1_UM"),TamSX3("D1_UM")[1],.F.,)
	TRCell():New(oSection1,"B1_PESO","SB1","PESO UNITARIO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	TRCell():New(oSection1,"D1_PESO","SD1","TOTAL PESO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	TRCell():New(oSection1,"D1_QUANT","SD1","CANTIDAD",PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1],.F.,)
	TRCell():New(oSection1,"D1_VUNIT","SD1","COSTO UNITARIO",PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1],.F.,)
	TRCell():New(oSection1,"D1_TOTAL","SD1","TOTAL",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_CUSTO2","SD1","TOT GTOS IMP",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_CUSTO3","SD1","TOT NOTA CRED",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_CUSTO4","SD1","TOT GENERAL",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_PEDIDO","SD1","PEDIDO",PesqPict("SD1","D1_PEDIDO"),TamSX3("D1_PEDIDO")[1],.F.,)
	TRCell():New(oSection1,"D1_ITEMPC","SD1","ITEMPC",PesqPict("SD1","D1_ITEMPC"),TamSX3("D1_ITEMPC")[1],.F.,)
	TRCell():New(oSection1,"C6_PRUNIT","SC6","COSTO FINAL ITEM",PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1],.F.,)

	oSection2 := TRSection():New(oReport,"***LISTADO DE FACTURAS RELACIONADAS A LA IMPORTACION: ",,)
	oSection2:SetTotalInLine(.T.)
	oSection2:lPrintHeader := .T.
	oSection2:lHeaderVisible := .T.
	oSection2:lHeaderBreak := .T.
	TRCell():New(oSection2,"F1_UPOLIZA","SF1","NR.IMPORT")
	TRCell():New(oSection2,"F1_DOC","SF1","DOCUMENTO")
	TRCell():New(oSection2,"F1_SERIE","SF1","SERIE")
	TRCell():New(oSection2,"F1_FORNECE","SF1","PROVEEDOR")
	TRCell():New(oSection2,"F1_LOJA","SF1","TIENDA")
	TRCell():New(oSection2,"A2_NOME","SF1","PROVEEDOR")
	TRCell():New(oSection2,"D1_PESO","SD1","TOTAL PESO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	TRCell():New(oSection2,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection2,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection2,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)
	TRCell():New(oSection2,"F1_DTLANC","SF1","FECHA REG.",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"DBC_DESCRI","DBC","DESCRIPCION")

	oSection3 := TRSection():New(oReport,"***COSTO ORIGEN + GASTOS: ",,)
	oSection3:SetTotalInLine(.T.)
	oSection3:lPrintHeader := .T.
	oSection3:lHeaderVisible := .T.
	oSection3:lHeaderBreak := .T.
	TRCell():New(oSection3,"A2_NOME","SA2","CONCEPTO")
	TRCell():New(oSection3,"F1_VALMERC","SF1","TOTAL INVOICE",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection3,"F1_VALBRUT","SF1","TOTAL GASTOS",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection3,"F2_TOTAL","SF2","TOTAL GENERAL",cPictVal,nTamVal,.F.,)

	oSection4 := TRSection():New(oReport,"***TOTAL INVOICE: ",,)
	oSection4:SetTotalInLine(.T.)
	oSection4:lPrintHeader := .T.
	oSection4:lHeaderVisible := .T.
	oSection4:lHeaderBreak := .T.
	TRCell():New(oSection4,"F1_UPOLIZA","SF1","NR.IMPORT")
	TRCell():New(oSection4,"F1_DOC","SF1","DOCUMENTO")
	TRCell():New(oSection4,"F1_SERIE","SF1","SERIE")
	TRCell():New(oSection4,"F1_FORNECE","SF1","PROVEEDOR")
	TRCell():New(oSection4,"F1_LOJA","SF1","TIENDA")
	TRCell():New(oSection4,"A2_NOME","SF1","PROVEEDOR")
	TRCell():New(oSection4,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection4,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection4,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection4,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)

	oSection5 := TRSection():New(oReport,"***VERIFICACION DE COSTOS VERSUS FACTURAS: ",,)
	oSection5:SetTotalInLine(.T.)
	oSection5:lPrintHeader := .T.
	oSection5:lHeaderVisible := .T.
	oSection5:lHeaderBreak := .T.
	TRCell():New(oSection5,"A2_NOME","SA2","CONCEPTO")
	TRCell():New(oSection5,"F2_TOTAL","SF1","TOTAL",cPictVal,nTamVal,.F.,)

	oSection6 := TRSection():New(oReport,"***LIBERACION DE IMPORTACION EN CASO USO ALMACEN EN TRANSITO: ",,)
	oSection6:SetTotalInLine(.T.)
	oSection6:lPrintHeader := .T.
	oSection6:lHeaderVisible := .T.
	oSection6:lHeaderBreak := .T.
	TRCell():New(oSection6,"F2_DOC","SF2","DOCUMENTO")
	TRCell():New(oSection6,"F2_SERIE","SF2","SERIE")
	TRCell():New(oSection6,"F2_EMISSAO","SF2","EMISION",PesqPict("SF2","F2_EMISSAO"),10,.F.,)
	TRCell():New(oSection6,"D2_QUANT","SD2","CANTIDAD",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection6,"D2_QTDAFAT","SD2","CANTIDAD PEND. RECEPCIÓN",cPictVal,nTamVal,.F.,)

	oSection7 := TRSection():New(oReport,"***DETALLE DE LIBERACION DE IMPORTACION EN CASO USO ALMACEN TRANSITO: ",,)
	oSection7:SetTotalInLine(.T.)
	oSection7:lPrintHeader := .T.
	oSection7:lHeaderVisible := .T.
	oSection7:lHeaderBreak := .T.
	TRCell():New(oSection7,"D1_COD","SD1","PRODUCTO")
	TRCell():New(oSection7,"B1_ESPECIF","SB1","DESCRIPCION")
	TRCell():New(oSection7,"D1_LOCAL","SD1","DEPOSITO")
	TRCell():New(oSection7,"D1_UM","SD1","UNIDAD DE MEDIDA")
	TRCell():New(oSection7,"D1_QUANT","SD1","CANTIDAD IMP",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection7,"D2_QUANT","SD1","CANTIDAD TRANS",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection7,"SALDO","SD2","SALDO POR TRANSFERIR",cPictVal,nTamVal,.F.,)

Return oReport

Static Function ReportPrint(oReport,nTamVal)
	Local oSection0  := oReport:Section(1)
	Local oSection1  := oReport:Section(2)
	Local oSection2  := oReport:Section(3)
	Local oSection3  := oReport:Section(4)
	Local oSection4  := oReport:Section(5)
	Local oSection5  := oReport:Section(6)
	Local oSection6  := oReport:Section(7)
	Local oSection7  := oReport:Section(8)
	Local aDados[31] // cambiando de 29 a 30
	Local aSaldTr[10]
	Local aSaldxTr[10]
	Local nPos
	Local nRow, nPosDebi, nPosCred, nPosSald
	Local cLinha
	Local cString     := "SF1"
	Local dDtChave          := CTOD(SPACE(8))
	Local cCodCliAnt  		:= Space(06)
	Local cArqTrab, cChave
	Local dDataMoeda := dDataBase
	Local nDebCliTot:=nCredCliTot:=nSaldoCli:=0
	Local lQuery:=.F.
	Local lRABaixado:=.F.
	Local lEstorno := .F.
	Local cChaveSeq := ""
	Local nLoop := 0
	Local nTaxa  := 0
	Local nValor := 0
	Local nRegSE5 := 0
	Local cDeCliente,cAteCliente,nConsidera,dDataDe,dDataAte,nEvaluar,nSaldos,cDeModalid,cAteModalid,nMoeda
	lOcal cAliasQry := ""
	//	Local mv_par01 := "POL-26-06-15        "
	Local cNFOri := ""
	Local cSeriOri:= ""
	Local cPoliza := ""
	Private cTipos  // Usada por la funcion FinrTipos().

	oSection0:Cell("F1_UPOLIZA"):SetBlock( { || aDados[UPOLIZA] })
	oSection0:Cell("F1_DOC"):SetBlock( { || aDados[DOC] })
	oSection0:Cell("F1_SERIE"):SetBlock( { || aDados[SERIE] })
	oSection0:Cell("F1_FORNECE"):SetBlock( { || aDados[FORNECE] })
	oSection0:Cell("F1_LOJA"):SetBlock( { || aDados[LOJA] })
	oSection0:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection0:Cell("F1_EMISSAO"):SetBlock( { || aDados[EMISSAO] })
	oSection0:Cell("F1_VALMERC"):SetBlock( { || aDados[VALMERC] })
	//		oSection0:Cell("F1_VALBRUT"):SetBlock( { || aDados[VALBRUT] })
	oSection0:Cell("F1_MOEDA"):SetBlock( { || aDados[MOEDA] })
	oSection0:Cell("F1_TXMOEDA"):SetBlock( { || aDados[TXMOEDA] })
//	oSection0:Cell("F1_DTLANC"):SetBlock( { || aDados[F] })
	oSection0:Cell("F1_USRREG"):SetBlock( { || aDados[USUARIO] })
	//oSection0:Cell("F1_UCORREL"):SetBlock( { || aDados[NROREM] })

	oSection1:Cell("D1_ITEM"):SetBlock( { || aDados[ITEM] })
	oSection1:Cell("D1_COD"):SetBlock( { || aDados[COD] })
	oSection1:Cell("B1_ESPECIF"):SetBlock( { || aDados[UDESC] })
	oSection1:Cell("D1_LOCAL"):SetBlock( { || aDados[LOCAL] })
	oSection1:Cell("D1_UM"):SetBlock( { || aDados[UM] })
	oSection1:Cell("B1_PESO"):SetBlock( { || aDados[PESOUNIT] })
	oSection1:Cell("D1_PESO"):SetBlock( { || aDados[PESO] })
	oSection1:Cell("D1_QUANT"):SetBlock( { || aDados[QUANT] })
	oSection1:Cell("D1_VUNIT"):SetBlock( { || aDados[VUNIT] })
	oSection1:Cell("D1_TOTAL"):SetBlock( { || aDados[TOTAL] })
	oSection1:Cell("D1_CUSTO2"):SetBlock( { || aDados[TOTGTOS] })
	oSection1:Cell("D1_CUSTO3"):SetBlock( { || aDados[TOTNCP] })
	oSection1:Cell("D1_CUSTO4"):SetBlock( { || aDados[TOTPROD] })
	oSection1:Cell("D1_PEDIDO"):SetBlock( { || aDados[PEDIDO] })
	oSection1:Cell("D1_ITEMPC"):SetBlock( { || aDados[ITEMPC] })
	oSection1:Cell("C6_PRUNIT"):SetBlock( { || aDados[PRCUNIT] })

	oSection1:Cell("B1_ESPECIF"):SetLineBreak(.T.)		//Salto de linea para la descripcion
	/*	uDesc	:= oSection1:Cell("B1_ESPECIF"):ColPos()
	cTotal	:= oSection1:Cell("D1_TOTAL"):ColPos()
	cTota2	:= oSection1:Cell("D1_CUSTO2"):ColPos()
	cTota3	:= oSection1:Cell("D1_CUSTO3"):ColPos() */

	oSection2:Cell("F1_UPOLIZA"):SetBlock( { || aDados[UPOLIZA] })
	oSection2:Cell("F1_DOC"):SetBlock( { || aDados[DOC] })
	oSection2:Cell("F1_SERIE"):SetBlock( { || aDados[SERIE] })
	oSection2:Cell("F1_FORNECE"):SetBlock( { || aDados[FORNECE] })
	oSection2:Cell("F1_LOJA"):SetBlock( { || aDados[LOJA] })
	oSection2:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection2:Cell("D1_PESO"):SetBlock( { || aDados[PESO] })
	oSection2:Cell("F1_EMISSAO"):SetBlock( { || aDados[EMISSAO] })
	oSection2:Cell("F1_VALMERC"):SetBlock( { || aDados[VALMERC] })
	//		oSection2:Cell("F1_VALBRUT"):SetBlock( { || aDados[VALBRUT] })
	oSection2:Cell("F1_MOEDA"):SetBlock( { || aDados[MOEDA] })
	oSection2:Cell("F1_TXMOEDA"):SetBlock( { || aDados[TXMOEDA] })
	oSection2:Cell("F1_DTLANC"):SetBlock( { || aDados[FECHALANC] })
	oSection2:Cell("DBC_DESCRI"):SetBlock( { || aDados[INFODESC] })
	/*	uNome	:= oSection2:Cell("A2_NOME"):ColPos()
	uValMerc:= oSection2:Cell("F1_VALMERC"):ColPos() */

	oSection3:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection3:Cell("F1_VALMERC"):SetBlock( { || aDados[VALMERC] })
	oSection3:Cell("F1_VALBRUT"):SetBlock( { || aDados[VALBRUT] })
	oSection3:Cell("F2_TOTAL"):SetBlock( { || aDados[TOTAL] })

	oSection4:Cell("F1_UPOLIZA"):SetBlock( { || aDados[UPOLIZA] })
	oSection4:Cell("F1_DOC"):SetBlock( { || aDados[DOC] })
	oSection4:Cell("F1_SERIE"):SetBlock( { || aDados[SERIE] })
	oSection4:Cell("F1_FORNECE"):SetBlock( { || aDados[FORNECE] })
	oSection4:Cell("F1_LOJA"):SetBlock( { || aDados[LOJA] })
	oSection4:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection4:Cell("F1_EMISSAO"):SetBlock( { || aDados[EMISSAO] })
	oSection4:Cell("F1_VALMERC"):SetBlock( { || aDados[VALMERC] })
	//		oSection4:Cell("F1_VALBRUT"):SetBlock( { || aDados[VALBRUT] })
	oSection4:Cell("F1_MOEDA"):SetBlock( { || aDados[MOEDA] })
	oSection4:Cell("F1_TXMOEDA"):SetBlock( { || aDados[TXMOEDA] })
	/*	uNome	:= oSection4:Cell("A2_NOME"):ColPos()
	uValMerc:= oSection4:Cell("F1_VALMERC"):ColPos() */

	oSection5:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection5:Cell("F2_TOTAL"):SetBlock( { || aDados[TOTAL] })
	uConcep	:= oSection5:Cell("A2_NOME"):ColPos()
	uDifer:= oSection5:Cell("F2_TOTAL"):ColPos()

	oSection6:Cell("F2_DOC"):SetBlock( { || aSaldTr[1] }) //doc
	oSection6:Cell("F2_SERIE"):SetBlock( { || aSaldTr[2] }) // serie
	oSection6:Cell("F2_EMISSAO"):SetBlock( { || aSaldTr[3] }) // emissao
	oSection6:Cell("D2_QUANT"):SetBlock( { || aSaldTr[4] }) // quant
	oSection6:Cell("D2_QTDAFAT"):SetBlock( { || aSaldTr[5] }) // qtdafat

	oSection7:Cell("D1_COD"):SetBlock( { || aSaldxTr[1] }) //COD
	oSection7:Cell("B1_ESPECIF"):SetBlock( { || aSaldxTr[2] }) //doc
	oSection7:Cell("D1_LOCAL"):SetBlock( { || aSaldxTr[3] }) //doc
	oSection7:Cell("D1_UM"):SetBlock( { || aSaldxTr[4] }) //doc
	oSection7:Cell("D1_QUANT"):SetBlock( { || aSaldxTr[5] }) //doc
	oSection7:Cell("D2_QUANT"):SetBlock( { || aSaldxTr[6] }) //doc
	oSection7:Cell("SALDO"):SetBlock( { || aSaldxTr[7] }) //doc

	cQuery:= " SELECT DISTINCT F1_FILIAL,F1_HAWB F1_UPOLIZA,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_EMISSAO "
	cQuery+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
	cQuery+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_SERIE = D1_SERIE "
	cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
	cQuery+= " WHERE F1_HAWB BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery+= " AND F1_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery+= " AND F1_SERIE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cQuery+= " AND F1_TIPODOC = '10' AND F1_NFORIG = ' ' "
	cQuery+= " AND SF1.D_E_L_E_T_!='*' AND SD1.D_E_L_E_T_!='*' AND SA2.D_E_L_E_T_!='*'"

	If __CUSERID = '000000'
		aviso("",cQuery,{'ok'},,,,,.t.)
	EndIf
	cQuery := ChangeQuery(cQuery)
	
	If !Empty(Select("TMP0"))
		dbSelectArea("TMP0")
		dbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TMP0"

	IF TMP0->(!EOF()) .AND. TMP0->(!BOF())
		TMP0->(dbGoTop())
	end

	While TMP0->(!Eof())
		cPoliza := TMP0->F1_DOC
		cPoliIMP := TMP0->F1_UPOLIZA

		#IFDEF TOP
		lQuery:=.T.

		cQuery:= " SELECT F1_FILIAL,F1_HAWB F1_UPOLIZA,F1_TIPODOC,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_EMISSAO,F1_VALMERC,F1_VALBRUT,F1_ESPECIE,F1_MOEDA,F1_TXMOEDA,F1_USRREG, "
		cQuery+= " D1_FILIAL,D1_PEDIDO,D1_ITEMPC,D1_DOC,D1_SERIE, D1_ITEM,D1_COD,B1_ESPECIF,D1_LOCAL,D1_UM,D1_QUANT,ROUND((D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA)/D1_QUANT,2) D1_VUNIT,D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA D1_TOTAL,D1_FORNECE,D1_EMISSAO,D1_NFORI,"
		cQuery+= " D1_SERIORI,D1_PESO, "

		cQuery+= " ((SELECT SUM(D1_CUSTO) D1_CUSTO FROM (SELECT SUM(CASE WHEN F4_ESTOQUE='N' THEN 0 ELSE CASE F1_MOEDA WHEN 2 THEN D1_CUSTO2*M2_MOEDA2 WHEN 1 THEN D1_CUSTO END END) D1_CUSTO "
		cQuery+= " FROM "+ RetSQLname('SF1') + " SF1G JOIN "+ RetSQLname('SD1') + " SD1G ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE "
		cQuery+= " LEFT JOIN "+ RetSQLname('SF4') + " SF4 ON SD1G.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
		cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2G ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
		cQuery+= " LEFT JOIN "+ RetSQLname('SM2') + " SM2 ON F1_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_!='*' "
		cQuery+= " WHERE D1_NFORI = SF1.F1_DOC AND D1_SERIORI = SF1.F1_SERIE "
		cQuery+= " AND D1_COD = SD1.D1_COD "
		cQuery+= " AND F1_TIPODOC IN ('13','14') "
		cQuery+= " AND SF1G.D_E_L_E_T_!='*' AND SD1G.D_E_L_E_T_!='*' AND SA2G.D_E_L_E_T_!='*' ) AXY
		cQuery+= " ) /
		cQuery+= " (SELECT SUM(D1_QUANT) FROM "+ RetSQLname('SD1') + " SD12 "
        cQuery+= " WHERE SD12.D1_DOC = SF1.F1_DOC AND SD12.D1_COD = SD1.D1_COD AND SD12.D1_SERIE = SF1.F1_SERIE AND SD12.D1_FORNECE = SF1.F1_FORNECE ))* SD1.D1_QUANT "
		cQuery+= " D1_CUSTO, "
		cQuery+= " ((SELECT SUM(D1_CUSTO2) D1_CUSTO2 FROM (SELECT SUM(CASE WHEN F4_ESTOQUE='N' THEN 0 ELSE CASE F1_MOEDA WHEN 2 THEN D1_CUSTO2 WHEN 1 THEN D1_CUSTO/M2_MOEDA2 END END) D1_CUSTO2 "
		cQuery+= " FROM "+ RetSQLname('SF1') + " SF1G JOIN "+ RetSQLname('SD1') + " SD1G ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE "
		cQuery+= " LEFT JOIN "+ RetSQLname('SF4') + " SF4 ON SD1G.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
		cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2G ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
		cQuery+= " LEFT JOIN "+ RetSQLname('SM2') + " SM2 ON F1_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_!='*' "
		cQuery+= " WHERE D1_NFORI = SF1.F1_DOC AND D1_SERIORI = SF1.F1_SERIE "
		cQuery+= " AND D1_COD = SD1.D1_COD "
		cQuery+= " AND F1_TIPODOC IN ('13','14') "
		cQuery+= " AND SF1G.D_E_L_E_T_!='*' AND SD1G.D_E_L_E_T_!='*' AND SA2G.D_E_L_E_T_!='*' ) AXY
		cQuery+= " ) /
		cQuery+= " (SELECT SUM(D1_QUANT) FROM "+ RetSQLname('SD1') + " SD12 "
        cQuery+= " WHERE SD12.D1_DOC = SF1.F1_DOC AND SD12.D1_COD = SD1.D1_COD AND SD12.D1_SERIE = SF1.F1_SERIE AND SD12.D1_FORNECE = SF1.F1_FORNECE ))* SD1.D1_QUANT "
		cQuery+= " D1_CUSTO2, "
		cQuery+= " (SELECT SUM(D1_CUSTO3) D1_CUSTO3 FROM (SELECT SUM(D2_TOTAL)*-1 D1_CUSTO3 "
		cQuery+= " FROM "+ RetSQLname('SF2') + " SF2G JOIN "+ RetSQLname('SD2') + " SD2G ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE "
		cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2G ON F2_CLIENTE = A2_COD AND F2_LOJA = A2_LOJA "
		cQuery+= " WHERE D2_NFORI = SF1.F1_DOC AND D2_SERIORI = SF1.F1_SERIE "
		cQuery+= "  AND D2_COD = SD1.D1_COD "
		cQuery+= " AND F2_TIPODOC = '07' "
		cQuery+= " AND SF2G.D_E_L_E_T_!='*' AND SD2G.D_E_L_E_T_!='*' AND SA2G.D_E_L_E_T_!='*' ) AXZ"
		cQuery+= " ) D1_CUSTO3 "

		cQuery+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND SD1.D_E_L_E_T_!='*' "
		cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*' AND A2_FILIAL = SUBSTRING(F1_FILIAL,1,2) "
		cQuery+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 ON D1_COD = B1_COD  AND SB1.D_E_L_E_T_!='*'"
		cQuery+= " WHERE F1_DOC = '" + cPoliza + "' "
		cQuery+= " AND F1_HAWB =  '" + cPoliIMP + "' "
		cQuery+= " AND F1_TIPODOC = '10' AND F1_NFORIG = ' ' "
		cQuery+= " AND SF1.D_E_L_E_T_!='*' "

		
		//aviso("SUBQR",cQuery,{'ok'},,,,,.t.)
		
		cQuery := ChangeQuery(cQuery)

		TCQUERY cQuery NEW ALIAS "TMP"

		IF TMP->(!EOF()) .AND. TMP->(!BOF())
			TMP->(dbGoTop())
		end

		#ELSE
		//	DbSeek(xFilial(cString)+cDeCliFor,.T.)
		#ENDIF

		m_pag:=1
		oSection0:Init()
		/*aDados[UPOLIZA] := "ITEMS CON EL COSTO FINAL"
		oReport:SkipLine()	
		oSection0:PrintLine()
		aFill(aDados,nil)
		*/
		oSection1:Init()
		
		aFill(aDados,nil)

		oReport:SetMeter(TMP->(RecCount()))
		nTotalGral := 0
		nTotalGtos := 0
		nTotalNCP := 0
		nTotalProd := 0

		nFobMoeda := 0

		i:=0
		While TMP->(!Eof())
			If i== 0
				aDados[UPOLIZA] := TMP->F1_UPOLIZA
				aDados[DOC] := TMP->F1_DOC
				aDados[SERIE] := TMP->F1_SERIE
				aDados[FORNECE] := TMP->F1_FORNECE
				aDados[LOJA] := TMP->F1_LOJA
				aDados[NOME] := TMP->A2_NOME
				aDados[EMISSAO] := STOD(TMP->F1_EMISSAO)
				aDados[VALMERC] := TMP->F1_VALMERC
				nFobMoeda := TMP->F1_MOEDA
				aDados[MOEDA] := TMP->F1_MOEDA
				aDados[TXMOEDA] := TMP->F1_TXMOEDA
				aDados[USUARIO] := TMP->F1_USRREG

				cNFOri :=	aDados[DOC]
				cSeriOri :=	aDados[SERIE]
				oSection0:PrintLine()
				aFill(aDados,nil)
				
			end
			aDados[ITEM] := TMP->D1_ITEM
			aDados[COD] := TMP->D1_COD
			aDados[UDESC] := TMP->B1_ESPECIF
			aDados[LOCAL] := TMP->D1_LOCAL
			aDados[UM] := TMP->D1_UM
			aDados[PESOUNIT] := GetAdvFVal("SB1","B1_PESO",xFilial("SB1")+TMP->D1_COD,1,"0")
			aDados[PESO] := TMP->D1_PESO
			aDados[QUANT] := TMP->D1_QUANT
			aDados[VUNIT] := TMP->D1_VUNIT
			aDados[TOTAL] := TMP->D1_TOTAL
			aDados[TOTGTOS] := iif(nFobMoeda == 1,TMP->D1_CUSTO, TMP->D1_CUSTO2)
			aDados[TOTNCP] := TMP->D1_CUSTO3
			aDados[TOTPROD] := TMP->D1_TOTAL + iif(nFobMoeda == 1,TMP->D1_CUSTO, TMP->D1_CUSTO2) + TMP->D1_CUSTO3
			aDados[PEDIDO] := TMP->D1_PEDIDO
			aDados[ITEMPC] := TMP->D1_ITEMPC
			aDados[PRCUNIT] := (TMP->D1_TOTAL + iif(nFobMoeda == 1,TMP->D1_CUSTO, TMP->D1_CUSTO2) + TMP->D1_CUSTO3)/TMP->D1_QUANT

			nTotalGral +=	aDados[TOTAL]
			nTotalGtos +=	aDados[TOTGTOS]
			nTotalNCP +=	aDados[TOTNCP]
			nTotalProd +=	aDados[TOTPROD]

			oSection1:PrintLine()
			aFill(aDados,nil)

			i++
			TMP->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",217), nRow, 10) // TOTAL INVOICE)
		/*			cLinha := Replicate("-",nTamVal)
		oReport:PrintText(cLinha, nRow, cTotal)
		oReport:PrintText(cLinha, nRow, cTota2)
		oReport:PrintText(cLinha, nRow, cTota3) */
		oReport:SkipLine()

		aDados[UDESC] := "TOTAL INVOICE: "
		aDados[TOTAL] := nTotalGral
		aDados[TOTGTOS] := nTotalGtos
		aDados[TOTNCP] := nTotalNCP
		aDados[TOTPROD] := nTotalProd

		oSection1:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection1:Finish()

		// *************** oSection2 **********************
		oSection2:Init()
		aFill(aDados,nil)

		cQuery2:= " SELECT DISTINCT DBC_DESCRI,F1_FILIAL,F1_HAWB F1_UPOLIZA,F1_TIPODOC,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_DTLANC,F1_EMISSAO,"
		cQuery2+= " SUM(CASE WHEN F4_ESTOQUE='N' THEN 0 ELSE CASE F1_MOEDA WHEN 2 THEN D1_CUSTO2 WHEN 1 THEN D1_CUSTO/M2_MOEDA2 END END) F1_VALMERC, "
		cQuery2+= " SUM(CASE WHEN F4_ESTOQUE='N' THEN 0 ELSE CASE F1_MOEDA WHEN 2 THEN D1_CUSTO2*M2_MOEDA2 WHEN 1 THEN D1_CUSTO END END) F1_VALBS, "
		cQuery2+= " CASE WHEN F1_MOEDA = 1 THEN ROUND(F1_VALBRUT/M2_MOEDA2, 2) WHEN F1_MOEDA = 2 THEN F1_VALBRUT ELSE ROUND(F1_VALBRUT*F1_TXMOEDA/M2_MOEDA2,2) END F1_VALBRUT, "
		cQuery2+= " F1_ESPECIE, 2 F1_MOEDA, M2_MOEDA2 F1_TXMOEDA, "
		cQuery2+= " (SELECT SUM(D1_PESO) D1_PESO FROM "+ RetSQLname('SD1') + " SD1A WHERE D1_FILIAL = SF1.F1_FILIAL AND SF1.F1_FORNECE = D1_FORNECE AND D1_DOC = SF1.F1_DOC AND D1_SERIE = SF1.F1_SERIE AND SD1A.D_E_L_E_T_!='*') D1_PESO, MAX(D1_TES) D1_TES "
		cQuery2+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery2+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_SERIE = D1_SERIE AND SD1.D_E_L_E_T_!='*' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SF4') + " SF4 ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*' AND A2_FILIAL = SUBSTRING(F1_FILIAL,1,2) "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SM2') + " SM2 ON F1_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_!='*' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('DBB') + " DBB ON DBB_HAWB = '" + cPoliIMP + "' AND F1_SERIE = DBB_SERIE AND F1_DOC = DBB_DOC AND F1_FORNECE = DBB.DBB_FORNEC AND DBB.D_E_L_E_T_ LIKE ' '
		cQuery2+= " LEFT JOIN "+ RetSQLname('DBC') + " DBC ON DBC_HAWB = '" + cPoliIMP + "' AND DBB_ITEM = DBC_ITDOC AND DBC.D_E_L_E_T_ LIKE ' '
		cQuery2+= " WHERE D1_NFORI = '" + cNFOri + "' AND D1_SERIORI = '" + cSeriOri + "' "
		cQuery2+= " AND SF1.F1_FORNECE = D1_FORNECE AND F1_TIPODOC IN ('13','14')"
		cQuery2+= " AND SF1.D_E_L_E_T_!='*' "
		cQuery2+= " GROUP BY DBC_DESCRI, F1_FILIAL, F1_HAWB, F1_TIPODOC, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME,F1_DTLANC, F1_EMISSAO, F1_MOEDA, F1_VALBRUT, M2_MOEDA2, F1_TXMOEDA, F1_ESPECIE "
		cQuery2+= " UNION "
		cQuery2+= " SELECT DISTINCT DBC_DESCRI,F2_FILIAL,'F2_UPOLIZA',F2_TIPODOC,F2_DOC,F2_SERIE,F2_CLIENTE F2_FORNECE,F2_LOJA,A2_NOME,F2_DTLANC,F2_EMISSAO,F2_VALMERC*-1 F2_VALMERC,F2_VALMERC*-1 F2_VALBS,F2_VALBRUT*-1 F2_VALBRUT,F2_ESPECIE,F2_MOEDA,F2_TXMOEDA, "
		cQuery2+= " (SELECT SUM(D2_PESO) D2_PESO FROM "+ RetSQLname('SD2') + " SD2A WHERE D2_FILIAL = SF2.F2_FILIAL AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND SD2A.D_E_L_E_T_!='*') D2_PESO, D2_TES D1_TES "
		cQuery2+= " FROM "+ RetSQLname('SF2') + " SF2 JOIN "+ RetSQLname('SD2') + " SD2 "
		cQuery2+= " ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND SD2.D_E_L_E_T_!='*'"
		cQuery2+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F2_CLIENTE = A2_COD AND F2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*'"
		cQuery2+= " LEFT JOIN "+ RetSQLname('DBB') + " DBB ON DBB_HAWB = '" + cPoliIMP + "' AND F2_SERIE = DBB_SERIE AND F2_DOC = DBB_DOC AND F2_CLIENTE = DBB.DBB_FORNEC AND DBB.D_E_L_E_T_ LIKE ' '
		cQuery2+= " LEFT JOIN "+ RetSQLname('DBC') + " DBC ON DBC_HAWB = '" + cPoliIMP + "' AND DBB_ITEM = DBC_ITDOC AND DBC.D_E_L_E_T_ LIKE ''		
		cQuery2+= " WHERE D2_NFORI = '" + cNFOri + "' AND D2_SERIORI = '" + cSeriOri + "' "
		//cQuery2+= " AND F2_UPOLIZA = '" + cPoliza + "' "
		cQuery2+= " AND SF2.F2_CLIENTE = D2_CLIENTE AND F2_TIPODOC = '07' "
		cQuery2+= " AND SF2.D_E_L_E_T_!='*'  "
		cQuery2+= " ORDER BY F1_FILIAL,F1_UPOLIZA,F1_SERIE,F1_DOC,F1_FORNECE,F1_LOJA"			

		If __CUSERID = '000000'
			aviso("",cQuery2,{'ok'},,,,,.t.)
		EndIf
		cQuery2 := ChangeQuery(cQuery2)

		TCQUERY cQuery2 NEW ALIAS "TMP2"

		IF TMP2->(!EOF()) .AND. TMP2->(!BOF())
			TMP2->(dbGoTop())
		end

		oReport:SetMeter(TMP2->(RecCount()))
		nValMerc := 0
		nValMercBs := 0
		i:=0
		While TMP2->(!Eof())
			aDados[UPOLIZA] := TMP2->F1_UPOLIZA
			aDados[DOC] := 	   TMP2->F1_DOC
			aDados[SERIE] :=   TMP2->F1_SERIE
			aDados[FORNECE] := TMP2->F1_FORNECE
			aDados[LOJA] :=    TMP2->F1_LOJA
			aDados[NOME] :=    TMP2->A2_NOME
			aDados[PESO] :=    TMP2->D1_PESO
			aDados[EMISSAO] := STOD(TMP2->F1_EMISSAO)
			aDados[VALMERC] := TMP2->F1_VALMERC
			aDados[FECHALANC] := STOD(TMP2->F1_DTLANC)
			aDados[INFODESC] := TMP2->DBC_DESCRI			

			aDados[MOEDA] :=   TMP2->F1_MOEDA
			aDados[TXMOEDA] := TMP2->F1_TXMOEDA

			nValMerc +=	aDados[VALMERC]
			nValMercBs += TMP2->F1_VALBS

			oSection2:PrintLine()
			aFill(aDados,nil)

			i++
			TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",170), nRow, 10) // TOTAL GASTOS DE IMPORTACION)
		/*		oReport:PrintText(Replicate("-",40), nRow, uNome)
		cLinha := Replicate("-",nTamVal)
		oReport:PrintText(cLinha, nRow, uValMerc) */
		oReport:SkipLine()

		aDados[NOME] := "TOTAL GASTOS IMPORTACION: "
		aDados[VALMERC] := nValMerc

		oSection2:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection2:Finish()

		// ***************** oSection3 ********************
		oSection3:Init()
		aFill(aDados,nil)
		oReport:SetMeter(1)
		nRow := oReport:Row()

		aDados[NOME] := "INVOICE + GASTOS IMPORTACION: "
		aDados[VALMERC] := nTotalGral
		aDados[VALBRUT] := iif(nFobMoeda == 1,nValMercBs,nValMerc) 
		aDados[TOTAL] := nTotalGral + iif(nFobMoeda == 1,nValMercBs,nValMerc)

		oSection3:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection3:Finish()

		// *************** oSection4 **********************
		oSection4:Init()
		aFill(aDados,nil)
		cQuery4:= " SELECT DISTINCT F1_FILIAL,F1_HAWB F1_UPOLIZA,F1_TIPODOC,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_EMISSAO,F1_VALMERC+F1_FRETE+F1_DESPESA+F1_SEGURO F1_VALMERC,F1_VALBRUT,F1_ESPECIE,F1_MOEDA,F1_TXMOEDA"
		cQuery4+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery4+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE"
		cQuery4+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND A2_FILIAL = SUBSTRING(F1_FILIAL,1,2) "
		cQuery4+= " WHERE F1_DOC = '" + cPoliza + "' "
		cQuery4+= " AND F1_HAWB =  '" + cPoliIMP + "' "
		cQuery4+= " AND F1_TIPODOC = '10'"
		cQuery4+= " AND SF1.D_E_L_E_T_!='*' AND SD1.D_E_L_E_T_!='*' AND SA2.D_E_L_E_T_!='*'"

		If __CUSERID = '000000'
			aviso("QR4",cQuery4,{'ok'},,,,,.t.)
		EndIf
		cQuery4 := ChangeQuery(cQuery4)

		TCQUERY cQuery4 NEW ALIAS "TMP4"

		IF TMP4->(!EOF()) .AND. TMP4->(!BOF())
			TMP4->(dbGoTop())
		end

		oReport:SetMeter(TMP4->(RecCount()))
		nValFact := 0
		i:=0
		While TMP4->(!Eof())
			aDados[UPOLIZA] := TMP4->F1_UPOLIZA
			aDados[DOC] := TMP4->F1_DOC
			aDados[SERIE] := TMP4->F1_SERIE
			aDados[FORNECE] := TMP4->F1_FORNECE
			aDados[LOJA] := TMP4->F1_LOJA
			aDados[NOME] := TMP4->A2_NOME
			aDados[EMISSAO] := STOD(TMP4->F1_EMISSAO)
			aDados[VALMERC] := TMP4->F1_VALMERC
			//		aDados[VALBRUT] := TMP4->F1_VALBRUT
			aDados[MOEDA] := TMP4->F1_MOEDA
			aDados[TXMOEDA] := TMP4->F1_TXMOEDA

			nValFact +=	aDados[VALMERC]

			oSection4:PrintLine()
			aFill(aDados,nil)

			i++
			TMP4->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",159), nRow, 10) // uDesc)
		/*		oReport:PrintText(Replicate("-",40), nRow, uNome)
		cLinha := Replicate("-",nTamVal)
		oReport:PrintText(cLinha, nRow, uValMerc) */
		oReport:SkipLine()

		aDados[NOME] := "TOTAL FACTURAS: "
		aDados[VALMERC] := nValFact

		oSection4:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection4:Finish()

		// ***************** oSection5 ********************
		oSection5:Init()
		aFill(aDados,nil)
		oReport:SetMeter(4)
		nRow := oReport:Row()

		aDados[NOME] := "INVOICE + GASTOS IMPORTACION: "
		aDados[TOTAL] := nTotalGral + iif(nFobMoeda == 1,nValMercBs,nValMerc)
		oSection5:PrintLine()
		aFill(aDados,nil)
		//	oReport:SkipLine()

		aDados[NOME] := "FACTURAS + RECIBOS: "
		aDados[TOTAL] := nValFact
		oSection5:PrintLine()
		aFill(aDados,nil)
		//	oReport:SkipLine()

		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",40), nRow, uConcep) //DIFERENCIA
		cLinha := Replicate("_",nTamVal)
		oReport:PrintText(cLinha, nRow, uDifer)
		oReport:SkipLine()

		aDados[NOME] := "DIFERENCIA: "
		aDados[TOTAL] := nTotalGral + iif(nFobMoeda == 1,nValMercBs,nValMerc) - nValFact
		oSection5:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection5:Finish()

		/****************************SECTION 6*/
		oSection6:Init()
		aFill(aSaldTr,nil)

		cQuery6:= " SELECT F2_FILIAL,F2_HAWB F2_UPOLIZA,F2_TIPODOC,F2_DOC,F2_SERIE, F2_CLIENT,F2_LOJA,A2_NOME,F2_EMISSAO,"
		cQuery6+= " F2_VALMERC,F2_VALBRUT,F2_ESPECIE, F2_MOEDA,F2_TXMOEDA,F2_USRREG,D2_FILIAL,D2_PEDIDO,D2_ITEM,"
		cQuery6+= " D2_COD,B1_ESPECIF, D2_LOCAL,D2_UM, D2_QUANT,ROUND((D2_TOTAL+D2_VALFRE+D2_SEGURO+D2_DESPESA)/D2_QUANT, 2) D2_VUNIT,"
		cQuery6+= " D2_TOTAL+D2_VALFRE+D2_SEGURO+D2_DESPESA D2_TOTAL, D2_CLIENTE D2_EMISSAO,D2_NFORI,D2_SERIORI,D2_PESO,D2_QTDAFAT"
		cQuery6+= " FROM "+ RetSQLname('SF2') + " SF2 JOIN "+ RetSQLname('SD2') + " SD2 "
		cQuery6+= " ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND SD2.D_E_L_E_T_!='*' "
		cQuery6+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F2_CLIENT = A2_COD AND F2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*' AND A2_FILIAL = SUBSTRING(F2_FILIAL,1,2) "
		cQuery6+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_!='*'
		cQuery6+= " WHERE F2_HAWB = '" + mv_par01 + "' "
		cQuery6+= " AND F2_TIPODOC = '54'"
		cQuery6+= " AND SF2.D_E_L_E_T_!='*'"

		If __CUSERID = '000000'
			aviso("QR6",cQuery6,{'ok'},,,,,.t.)
		EndIf
		cQuery6 := ChangeQuery(cQuery6)

		TCQUERY cQuery6 NEW ALIAS "TMP6"

		IF TMP6->(!EOF()) .AND. TMP6->(!BOF())
			TMP6->(dbGoTop())
		end

		oReport:SetMeter(TMP6->(RecCount()))
		nValQnt := 0
		nValQtdnt := 0

		While TMP6->(!Eof())
			aSaldTr[1] := TMP6->F2_DOC
			aSaldTr[2] := TMP6->F2_SERIE
			aSaldTr[3] := STOD(TMP6->F2_EMISSAO)
			aSaldTr[4] := TMP6->D2_QUANT
			aSaldTr[5] := TMP6->D2_QTDAFAT

			nValQnt +=	aSaldTr[4]
			nValQtdnt +=	aSaldTr[5]

			oSection6:PrintLine()
			aFill(aSaldTr,nil)

			TMP6->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",80), nRow, 10) // TRANSFERENCIAS DE SALIDA)
		/*		oReport:PrintText(Replicate("-",40), nRow, uNome)
		cLinha := Replicate("-",nTamVal)
		oReport:PrintText(cLinha, nRow, uValMerc) */
		oReport:SkipLine()

		aSaldTr[1] := "TRANSFERENCIAS DE SALIDA: "
		aSaldTr[4] := nValQnt
		aSaldTr[5] := nValQtdnt

		oSection6:PrintLine()
		aFill(aSaldTr,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection6:Finish()

		/**************************************SECTION7*/
		oSection7:Init()
		aFill(aSaldxTr,nil)

		cQuery7:= " SELECT F1_FILIAL,F1_HAWB F1_UPOLIZA, F1_TIPODOC,F1_DOC, F1_SERIE,F1_FORNECE,F1_LOJA, A2_NOME,F1_EMISSAO,D1_ITEM, "
		cQuery7+= " F1_VALMERC, F1_VALBRUT,F1_ESPECIE,F1_MOEDA,F1_TXMOEDA, F1_USRREG,D1_FILIAL, D1_PEDIDO,D1_ITEMPC,D1_DOC,D1_SERIE, "
		cQuery7+= " D1_COD,B1_ESPECIF,D1_LOCAL,D1_UM,D1_QUANT,ROUND((D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA)/D1_QUANT, 2) D1_VUNIT, "
		cQuery7+= " D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA D1_TOTAL,D1_FORNECE,D1_EMISSAO, D1_NFORI,D1_SERIORI,D1_PESO, "
		cQuery7+= "(SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSQLname('SF2') + " SF1G JOIN " + RetSQLname('SD2') + " SD1G ON F2_FILIAL = D2_FILIAL"
		cQuery7+= " AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F1_FORNECE = D1_FORNECE WHERE F2_HAWB = SF1.F1_HAWB AND D2_COD = SD1.D1_COD AND F2_TIPODOC IN ('54') "
		cQuery7+= " AND SF1G.D_E_L_E_T_!='*' AND SD1G.D_E_L_E_T_!='*' ) D2_QUANT "
		cQuery7+= " FROM " + RetSQLname('SF1') + " SF1 JOIN " + RetSQLname('SD1') + " SD1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC "
		cQuery7+= " AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND SD1.D_E_L_E_T_!='*' LEFT JOIN " + RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD "
		cQuery7+= " AND F1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*' AND A2_FILIAL = SUBSTRING(F1_FILIAL,1,2) LEFT JOIN " + RetSQLname('SB1') + " SB1 ON D1_COD = B1_COD AND SB1.D_E_L_E_T_!='*'"
		cQuery7+= " WHERE F1_DOC = '" + cPoliza + "' "
		cQuery7+= " AND F1_HAWB =  '" + cPoliIMP + "' "
		cQuery7+= " AND F1_TIPODOC = '10' AND F1_NFORIG = ' ' AND SF1.D_E_L_E_T_!='*'"

		If __CUSERID = '000000'
			aviso("QR7",cQuery7,{'ok'},,,,,.t.)
		EndIf

		cQuery7 := ChangeQuery(cQuery7)

		TCQUERY cQuery7 NEW ALIAS "TMP7"

		IF TMP7->(!EOF()) .AND. TMP7->(!BOF())
			TMP7->(dbGoTop())
		end

		oReport:SetMeter(TMP7->(RecCount()))

		nQnt := 0
		nQntTran := 0
		nSaldo := 0

		While TMP7->(!Eof())
			aSaldxTr[1] := TMP7->D1_COD
			aSaldxTr[2] := TMP7->B1_ESPECIF
			aSaldxTr[3] := TMP7->D1_LOCAL
			aSaldxTr[4] := TMP7->D1_UM
			aSaldxTr[5] := TMP7->D1_QUANT
			aSaldxTr[6] := TMP7->D2_QUANT
			aSaldxTr[7] := aSaldxTr[5] - aSaldxTr[6]

			nQnt += aSaldxTr[5]
			nQntTran += aSaldxTr[6]
			nSaldo += aSaldxTr[7]

			oSection7:PrintLine()
			aFill(aSaldxTr,nil)

			TMP7->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",210), nRow, 10) // SALDOS POR TRANSFERIR)
		oReport:SkipLine()

		aSaldxTr[1] := "SALDOS POR TRANSFERIR: "
		aSaldxTr[5] := nQnt
		aSaldxTr[6] := nQntTran
		aSaldxTr[7] := nSaldo

		oSection7:PrintLine()
		aFill(aSaldxTr,nil)
		oReport:SkipLine()
		oReport:IncMeter()
		oSection7:Finish()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga indice ou consulta(Query)                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP

		TMP2->(dbCloseArea())
		TMP4->(dbCloseArea())
		TMP6->(dbCloseArea())
		TMP7->(dbCloseArea())

		TMP->(dbCloseArea())
		#ENDIF
		oReport:EndPage()
		TMP0->(DbSkip())       // Avanza el puntero del registro en el archivo

	END
		TMP0->(dbCloseArea())       // Avanza el puntero del registro en el archivo

Return Nil

static Function AjustaSx1() // posiciona valores para query preguntas
//	alert("Pasa AjustaSx1")
	cPerg :="RGtoImport"
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DBA->DBA_HAWB	
		SX1->(MsUnlock())
	End	
	
	If SX1->(DbSeek(cPerg+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DBA->DBA_HAWB
		SX1->(MsUnlock())
	END
	
return nil

Static Function CargarPerg()
	local i
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("RGtoImport",10)
	aRegs:={}
	

	aAdd(aRegs,{"01","De Numero Importacion: ","mv_ch1","C",20,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"02","A Numero Importacion: ","mv_ch2","C",20,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"03","De Numero Invoice: ","mv_ch3","C",12,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"04","A Numero Invoice: ","mv_ch4","C",12,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"05","De Serie: ","mv_ch5","C",3,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"06","A Serie: ","mv_ch6","C",3,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,""   ,""})

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
			SX1->X1_DEFSPA1  := aRegs[i][10]
			SX1->X1_DEFSPA2  := aRegs[i][11]
			SX1->X1_DEFSPA3  := aRegs[i][12]
			SX1->X1_DEFSPA4  := aRegs[i][13]
			SX1->X1_F3       := aRegs[i][14]
			SX1->X1_VALID    := aRegs[i][15]
			MsUnlock()
		Endif
	Next
Return
