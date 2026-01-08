#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "REPORT.CH"

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
#DEFINE OBSERVAC	32 // OBSERVACIONES
#DEFINE CRLF Chr(13)+Chr(10)

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
	oReport:SetLineHeight( 25 )//Línea agregada para que no se corte la impresión cuando se imprime en la opción PDF

	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01  	      	// Tipo de Reporte                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/////////////FOB FACTURA
	oSection0 := TRSection():New(oReport,"INVOICE",,)
	TRCell():New(oSection0,"DBA_UPOLIZ","SF1","NR.IMPORT")
	TRCell():New(oSection0,"F1_DOC","SF1","N° DE FACTURA")
	TRCell():New(oSection0,"F1_FORNECE","SF1","PROVEEDOR")
	TRCell():New(oSection0,"F1_LOJA","SF1","TIENDA")
	TRCell():New(oSection0,"A2_NOME","SF1","PROVEEDOR")
	TRCell():New(oSection0,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection0,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection0,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection0,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)
	TRCell():New(oSection0,"F1_USRREG","SF1","USUARIO",PesqPict("SF1","F1_USRREG"),TamSX3("F1_USRREG")[1],.F.,)
	TRCell():New(oSection0,"DBA_UDIM","DBA","DIM",,TamSX3("DBA_UDIM")[1],.F.,)
	TRCell():New(oSection0,"F1_HAWB","SF1","Despacho-No")

	/////////////////////DETALLES DE PRODUCTOS DE LA FOB
	oSection1 := TRSection():New(oReport,"DETALLE DEL INVOICE",,)
	TRCell():New(oSection1,"D1_ITEM","SD1","ITEM",PesqPict("SD1","D1_ITEM"),TamSX3("D1_ITEM")[1],.F.,)
	TRCell():New(oSection1,"D1_COD","SD1","CODIGO",PesqPict("SD1","D1_COD"),TamSX3("D1_COD")[1],.F.,)
	TRCell():New(oSection1,"B1_ESPECIF","SB1","DESCRIPCION", PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],.F.,)
	TRCell():New(oSection1,"D1_LOCAL","SD1","DEP", PesqPict("SD1","D1_LOCAL"),TamSX3("D1_LOCAL")[1],.F.,)
	TRCell():New(oSection1,"D1_UM","SD1","UM", PesqPict("SD1","D1_UM"),TamSX3("D1_UM")[1],.F.,)
	TRCell():New(oSection1,"B1_PESO","SB1","PESO UNITARIO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	TRCell():New(oSection1,"D1_PESO","SD1","TOTAL PESO", PesqPict("SD1","D1_TOTAL") , TamSX3("D1_TOTAL")[1] ,.F.,)
	TRCell():New(oSection1,"D1_QUANT","SD1","CANTIDAD",PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1],.F.,)
	TRCell():New(oSection1,"D1_VUNIT","SD1","COSTO UNITARIO",PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1],.F.,)
	TRCell():New(oSection1,"D1_TOTAL","SD1","TOTAL",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_CUSTO2","SD1","TOT GTOS IMP",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_CUSTO3","SD1","TOT NOTA CRED",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_CUSTO4","SD1","TOT GENERAL",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection1,"D1_PEDIDO","SD1","PEDIDO",PesqPict("SD1","D1_PEDIDO"),TamSX3("D1_PEDIDO")[1],.F.,)
	TRCell():New(oSection1,"D1_ITEMPC","SD1","ITEMPC",PesqPict("SD1","D1_ITEMPC"),TamSX3("D1_ITEMPC")[1],.F.,)
	TRCell():New(oSection1,"C6_PRUNIT","SC6","COSTO FINAL ITEM",PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1],.F.,)

	//////gastos en despacho
	oSection2 := TRSection():New(oReport,"GASTOS IMPORTACION",,)
	TRCell():New(oSection2,"F1_HAWB","SF1","NUMERO DOCTO")
	TRCell():New(oSection2,"F1_TIPODOC","SF1","TIPO DOC" + CRLF + "ITEM")
	TRCell():New(oSection2,"F1_SERIE","SF1","SERIE"+ CRLF + "UM")
	TRCell():New(oSection2,"F1_FORNECE","SF1","PROVEEDOR")
	TRCell():New(oSection2,"F1_LOJA","SF1","TIENDA")
	TRCell():New(oSection2,"A2_NOME","SF1","PROVEEDOR" + CRLF + "DESCRIPCION" )
	TRCell():New(oSection2,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection2,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)
	TRCell():New(oSection2,"F1_GASTO","SF1","" + CRLF + "  VAL. GASTO",PesqPict("SF1","F1_VALBRUT"),TamSX3("F1_VALBRUT")[1],.F.,)

	oSection3 := TRSection():New(oReport,"TOTAL INVOICE + GASTOS",,)
	TRCell():New(oSection3,"A2_NOME","SA2","CONCEPTO")
	TRCell():New(oSection3,"F1_VALMERC","SF1","TOTAL DESPACHO",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection3,"F1_VALBRUT","SF1","TOTAL GASTOS",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection3,"F1_VALIMP","SF1","TOTAL CRED.FISCAL",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection3,"F2_TOTAL","SF2","TOTAL GENERAL",cPictVal,nTamVal,.F.,)

	oSection5 := TRSection():New(oReport,"TOTAL INVOICE + GASTOS",,)
	TRCell():New(oSection5,"A2_NOME","SA2","CONCEPTO")
	TRCell():New(oSection5,"F2_TOTAL","SF1","TOTAL",cPictVal,nTamVal,.F.,)

	/////////////////////OBSERVACIONES DEL DESPACHO
	oSection6 := TRSection():New(oReport,"INVOICE",,)
	TRCell():New(oSection6,"DBA_XOBS","DBA","Observaciones", ,500)

Return oReport

Static Function ReportPrint(oReport,nTamVal)
	Local oSection0  := oReport:Section(1)
	Local oSection1  := oReport:Section(2)
	Local oSection2  := oReport:Section(3)
	Local oSection3  := oReport:Section(4)
	Local oSection5  := oReport:Section(5)
	Local oSection6  := oReport:Section(6)
	Local aDados[32] // cambiando de 31 a 32
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

	oSection0:Cell("F1_HAWB"):SetBlock( { || aDados[UPOLIZA] })
	oSection0:Cell("F1_DOC"):SetBlock( { || aDados[DOC] })
	oSection0:Cell("F1_FORNECE"):SetBlock( { || aDados[FORNECE] })
	oSection0:Cell("F1_LOJA"):SetBlock( { || aDados[LOJA] })
	oSection0:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection0:Cell("F1_EMISSAO"):SetBlock( { || aDados[EMISSAO] })
	oSection0:Cell("F1_VALMERC"):SetBlock( { || aDados[VALMERC] })
	oSection0:Cell("F1_MOEDA"):SetBlock( { || aDados[MOEDA] })
	oSection0:Cell("F1_TXMOEDA"):SetBlock( { || aDados[TXMOEDA] })
	oSection0:Cell("F1_USRREG"):SetBlock( { || aDados[USUARIO] })
	oSection0:Cell("DBA_UDIM"):SetBlock( { || aDados[PESOUNIT] })
	oSection0:Cell("DBA_UPOLIZ"):SetBlock( { || aDados[PESO] })

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

	oSection2:Cell("F1_HAWB"):SetBlock( { || aDados[UPOLIZA] })
	oSection2:Cell("F1_TIPODOC"):SetBlock( { || aDados[DOC] })
	oSection2:Cell("F1_SERIE"):SetBlock( { || aDados[FORNECE] })
	oSection2:Cell("F1_FORNECE"):SetBlock( { || aDados[NOME] })
	oSection2:Cell("F1_LOJA"):SetBlock( { || aDados[EMISSAO] })
	oSection2:Cell("A2_NOME"):SetBlock( { || aDados[VALMERC] })
	oSection2:Cell("F1_EMISSAO"):SetBlock( { || aDados[ITEM] })
	oSection2:Cell("F1_MOEDA"):SetBlock( { || aDados[COD] })
	oSection2:Cell("F1_TXMOEDA"):SetBlock( { || aDados[UDESC]  })
	oSection2:Cell("F1_GASTO"):SetBlock( { || aDados[LOCAL] })

	oSection3:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection3:Cell("F1_VALMERC"):SetBlock( { || aDados[VALMERC] })
	oSection3:Cell("F1_VALBRUT"):SetBlock( { || aDados[VALBRUT] })
	oSection3:Cell("F1_VALIMP"):SetBlock( { || aDados[MOEDA] })
	oSection3:Cell("F2_TOTAL"):SetBlock( { || aDados[TXMOEDA] })

	oSection5:Cell("A2_NOME"):SetBlock( { || aDados[NOME] })
	oSection5:Cell("F2_TOTAL"):SetBlock( { || aDados[TOTAL] })
	uConcep	:= oSection5:Cell("A2_NOME"):ColPos()
	uDifer:= oSection5:Cell("F2_TOTAL"):ColPos()

	oSection6:Cell("DBA_XOBS"):SetBlock( { || aDados[OBSERVAC] })

	cQuery:= " SELECT DISTINCT F1_FILIAL,F1_HAWB F1_HAWB,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_EMISSAO "
	cQuery+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
	cQuery+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_SERIE = D1_SERIE "
	cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
	cQuery+= " WHERE F1_HAWB BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	//cQuery+= " AND F1_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	//cQuery+= " AND F1_SERIE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cQuery+= " AND F1_TIPODOC = '10' AND F1_NFORIG = ' ' "
	cQuery+= " AND SF1.D_E_L_E_T_!='*' AND SD1.D_E_L_E_T_!='*' AND SA2.D_E_L_E_T_!='*'"


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
		cPoliIMP := TMP0->F1_HAWB

		#IFDEF TOP
			lQuery:=.T.

			If Select("TMP") > 0
				dbCloseArea()
			Endif

			cQuery:= " SELECT DBA_UPOLIZ,DBA_UDIM,F1_FILIAL,F1_HAWB F1_HAWB,F1_TIPODOC,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_EMISSAO,F1_VALMERC,F1_VALBRUT,F1_ESPECIE,F1_MOEDA,F1_TXMOEDA,F1_USRREG, "
			cQuery+= " D1_FILIAL,D1_PEDIDO,D1_ITEMPC,D1_VALIMP1,D1_DOC,D1_SERIE, D1_ITEM,D1_COD,B1_ESPECIF,D1_LOCAL,D1_UM,D1_QUANT,ROUND((D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA)/D1_QUANT,2) D1_VUNIT,D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA D1_TOTAL,D1_FORNECE,D1_EMISSAO,D1_NFORI,"
			cQuery+= " D1_SERIORI,D1_PESO, (SELECT SUM(D1_CUSTO2) D1_CUSTO2 FROM (SELECT SUM(CASE WHEN F4_ESTOQUE='N' THEN 0 ELSE D1_CUSTO2 END) D1_CUSTO2 "

			cQuery+= " FROM "+ RetSQLname('SF1') + " SF1G JOIN "+ RetSQLname('SD1') + " SD1G ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE "
			cQuery+= " LEFT JOIN "+ RetSQLname('SF4') + " SF4 ON SD1G.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
			cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2G ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
			cQuery+= " WHERE D1_NFORI = SF1.F1_DOC AND D1_SERIORI = SF1.F1_SERIE "
			cQuery+= " AND D1_COD = SD1.D1_COD "
			cQuery+= " AND F1_TIPODOC IN ('13','14') "
			cQuery+= " AND SF1G.D_E_L_E_T_!='*' AND SD1G.D_E_L_E_T_!='*' AND SA2G.D_E_L_E_T_!='*' ) AXY
			cQuery+= " ) D1_CUSTO2,"

			cQuery+= " (SELECT SUM(D1_CUSTO3) D1_CUSTO3 FROM (SELECT SUM(D2_TOTAL)*-1 D1_CUSTO3 "
			cQuery+= " FROM "+ RetSQLname('SF2') + " SF2G JOIN "+ RetSQLname('SD2') + " SD2G ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE "
			cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2G ON F2_CLIENTE = A2_COD AND F2_LOJA = A2_LOJA "
			cQuery+= " WHERE D2_NFORI = SF1.F1_DOC AND D2_SERIORI = SF1.F1_SERIE "
			cQuery+= "  AND D2_COD = SD1.D1_COD "
			cQuery+= " AND F2_TIPODOC = '07' "
			cQuery+= " AND SF2G.D_E_L_E_T_!='*' AND SD2G.D_E_L_E_T_!='*' AND SA2G.D_E_L_E_T_!='*' ) AXZ"
			cQuery+= " ) D1_CUSTO3 "

			cQuery+= " , ISNULL(CAST(CAST(DBA_XOBS AS VARBINARY(2000)) AS VARCHAR(2000)),'') AS DBA_XOBS"//Observaciones(campo memo)

			cQuery+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
			cQuery+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND SD1.D_E_L_E_T_!='*' "
			cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*'"
			cQuery+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 ON D1_COD = B1_COD  AND SB1.D_E_L_E_T_!='*'"
			cQuery+= " LEFT JOIN "+ RetSQLname('DBA') + " DBA ON DBA_HAWB = F1_HAWB AND F1_FILIAL = DBA_FILIAL AND DBA.D_E_L_E_T_!='*'"
			cQuery+= " WHERE F1_DOC = '" + cPoliza + "' "
			cQuery+= " AND F1_HAWB =  '" + cPoliIMP + "' "
			cQuery+= " AND F1_TIPODOC = '10' AND F1_NFORIG = ' ' "
			cQuery+= " AND SF1.D_E_L_E_T_!='*' ORDER BY D1_ITEM"

			//Aviso("cSql",cQuery,{"OK"},,,,,.T.)
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
		oSection1:Init()
		oSection6:Init()
		aFill(aDados,nil)

		oReport:SetMeter(TMP->(RecCount()))
		nTotalGral := 0
		nTotalGtos := 0
		nTotalNCP := 0
		nTotalProd := 0
		nTotalPes := 0
		nTotalFis := 0

		i:=0
		While TMP->(!Eof())
			If i== 0
				aDados[UPOLIZA]	:= TMP->F1_HAWB
				aDados[DOC]		:= TMP->F1_DOC
				aDados[FORNECE]	:= TMP->F1_FORNECE
				aDados[LOJA]	:= TMP->F1_LOJA
				aDados[NOME]	:= TMP->A2_NOME
				aDados[EMISSAO]	:= STOD(TMP->F1_EMISSAO)
				aDados[VALMERC]	:= TMP->F1_VALMERC
				aDados[MOEDA]	:= TMP->F1_MOEDA
				aDados[TXMOEDA]	:= TMP->F1_TXMOEDA
				aDados[USUARIO]	:= TMP->F1_USRREG
				aDados[PESOUNIT]:= TMP->DBA_UDIM
				aDados[PESO]	:= TMP->DBA_UPOLIZ
				aDados[OBSERVAC]:= TMP->DBA_XOBS

				cNFOri :=	aDados[DOC]
				cSeriOri :=	TMP->F1_SERIE
				oSection0:PrintLine()
				oSection6:PrintLine()
				aFill(aDados,nil)
				//	oReport:SkipLine()
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
			aDados[TOTGTOS] := TMP->D1_CUSTO2
			aDados[TOTNCP] := (-1) * TMP->D1_VALIMP1
			aDados[TOTPROD] := TMP->D1_TOTAL + TMP->D1_CUSTO2 - TMP->D1_VALIMP1
			aDados[PEDIDO] := TMP->D1_PEDIDO
			aDados[ITEMPC] := TMP->D1_ITEMPC
			aDados[PRCUNIT] := (TMP->D1_TOTAL + TMP->D1_CUSTO2 - TMP->D1_VALIMP1)/TMP->D1_QUANT

			nTotalPes +=	aDados[PESO]
			nTotalGral +=	aDados[TOTAL]
			nTotalGtos +=	aDados[TOTGTOS]
			nTotalNCP +=	aDados[TOTNCP]
			nTotalProd +=	aDados[TOTPROD]
			nTotalFis +=	TMP->D1_VALIMP1

			oSection1:PrintLine()
			aFill(aDados,nil)

			i++
			TMP->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",217), nRow, 10) // TOTAL INVOICE)

		oReport:SkipLine()

		aDados[UDESC] := "TOTAL DESPACHO: "
		aDados[PESO] := nTotalPes
		aDados[TOTAL] := nTotalGral
		aDados[TOTGTOS] := nTotalGtos
		aDados[TOTNCP] :=  nTotalNCP
		aDados[TOTPROD] := nTotalProd

		oSection1:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection1:Finish()

		// *************** oSection2 **********************
		oSection2:Init()
		aFill(aDados,nil)

		cQuery2:= " SELECT DISTINCT MAX(DBC_ITEM) DBC_ITEM,DBC_UM,DBC_UESPE2,DBC_UESPEC DBC_DESCRI,F1_FILIAL,F1_HAWB F1_HAWB,F1_TIPODOC,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_DTLANC,F1_EMISSAO,"
		cQuery2+= " SUM(CASE WHEN F4_ESTOQUE='N' THEN 0 ELSE D1_CUSTO2 END) F1_VALMERC, "
		cQuery2+= " CASE WHEN F1_MOEDA = '1' THEN ROUND(F1_VALBRUT/M2_MOEDA2, 2) WHEN F1_MOEDA = '2' THEN F1_VALBRUT ELSE ROUND(F1_VALBRUT*F1_TXMOEDA/M2_MOEDA2,2) END F1_VALBRUT, "
		cQuery2+= " F1_ESPECIE, '2' F1_MOEDA, M2_MOEDA2 F1_TXMOEDA, "
		cQuery2+= " (SELECT SUM(D1_PESO) D1_PESO FROM "+ RetSQLname('SD1') + " SD1A WHERE D1_FILIAL = SF1.F1_FILIAL AND SF1.F1_FORNECE = D1_FORNECE AND D1_DOC = SF1.F1_DOC AND D1_SERIE = SF1.F1_SERIE AND SD1A.D_E_L_E_T_!='*') D1_PESO, MAX(D1_TES) D1_TES "
		cQuery2+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery2+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_SERIE = D1_SERIE AND SD1.D_E_L_E_T_!='*' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SF4') + " SF4 ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_!='*' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SM2') + " SM2 ON F1_EMISSAO = M2_DATA AND SM2.D_E_L_E_T_!='*' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('DBB') + " DBB ON DBB_HAWB = '" + cPoliIMP + "' AND F1_SERIE = DBB_SERIE AND F1_DOC = DBB_DOC AND F1_FORNECE = DBB.DBB_FORNEC AND DBB.D_E_L_E_T_ LIKE ' '
		cQuery2+= " LEFT JOIN "+ RetSQLname('DBC') + " DBC ON DBC_HAWB = '" + cPoliIMP + "' AND DBB_ITEM = DBC_ITDOC AND DBC.D_E_L_E_T_ LIKE ' '
		cQuery2+= " WHERE D1_NFORI = '" + cNFOri + "' AND D1_SERIORI = '" + cSeriOri + "' "
		cQuery2+= " AND SF1.F1_FORNECE = D1_FORNECE AND F1_TIPODOC IN ('13','14')"
		cQuery2+= " AND SF1.D_E_L_E_T_!='*' "
		cQuery2+= " GROUP BY DBC_UM,DBC_UESPE2,DBC_UESPEC, F1_FILIAL, F1_HAWB, F1_TIPODOC, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME,F1_DTLANC, F1_EMISSAO, F1_MOEDA, F1_VALBRUT, M2_MOEDA2, F1_TXMOEDA, F1_ESPECIE "
		cQuery2+= " UNION "
		cQuery2+= " SELECT DISTINCT  MAX(DBC_ITEM) DBC_ITEM,DBC_UM,DBC_UESPE2,DBC_UESPEC DBC_DESCRI,F2_FILIAL,'F2_UPOLIZA',F2_TIPODOC,F2_DOC,F2_SERIE,F2_CLIENTE F2_FORNECE,F2_LOJA,A2_NOME,F2_DTLANC,F2_EMISSAO,F2_VALMERC*-1 F2_VALMERC,F2_VALBRUT*-1 F2_VALBRUT,F2_ESPECIE,F2_MOEDA,F2_TXMOEDA, "
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
		cQuery2+= " GROUP BY DBC_UM,DBC_UESPE2,DBC_UESPEC,F2_FILIAL,F2_TIPODOC,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA, A2_NOME,F2_DTLANC, "
		cQuery2+= " F2_EMISSAO,F2_VALMERC ,F2_VALBRUT ,F2_ESPECIE,F2_MOEDA,F2_TXMOEDA,D2_TES "

		cQuery2 := ChangeQuery(cQuery2)

		If Select("TMP2") > 0
			dbCloseArea()
		Endif

		TCQUERY cQuery2 NEW ALIAS "TMP2"


		IF TMP2->(!EOF()) .AND. TMP2->(!BOF())
			TMP2->(dbGoTop())
		end

		oReport:SetMeter(TMP2->(RecCount()))
		nValMerc := 0
		i:=0
		While TMP2->(!Eof())
			aDados[UPOLIZA] := TMP2->F1_HAWB
			aDados[DOC] := 	  iif(TMP2->F1_TIPODOC == '13',"GASTOS",iif(TMP2->F1_TIPODOC == '14',"FLETE","XXX")) //iif(TMP2->F1_TIPODOC == '6',"Flete",iif(TMP2->F1_TIPODOC == '7',"Seguro",iif(TMP2->F1_TIPODOC == '9',"Impuestos",iif(TMP2->F1_TIPODOC == 'A',"Gastos",IIF(TMP2->F1_TIPODOC == 'D',"Dua","")))))
			aDados[FORNECE] := TMP2->F1_SERIE
			aDados[NOME] :=    TMP2->F1_FORNECE
			aDados[EMISSAO] := F1_LOJA//
			aDados[VALMERC] := TMP2->A2_NOME
			aDados[ITEM] :=   STOD(TMP2->F1_EMISSAO)
			aDados[COD] := TMP2->F1_MOEDA //TMP2->F1_TXMOEDA
			aDados[UDESC] := TMP2->F1_TXMOEDA


			oSection2:PrintLine()
			aFill(aDados,nil)

			aDados[DOC] := TMP2->DBC_ITEM    ///item
			aDados[FORNECE] := TMP2->DBC_UM ///TMP2->F1_SERIE UM
			aDados[VALMERC] := TMP2->DBC_DESCRI    ///Descripcionespe1 y 2//TMP2->A2_NOME
			aDados[LOCAL] := TMP2->F1_VALMERC

			nValMerc +=	aDados[LOCAL]

			oSection2:PrintLine()
			aFill(aDados,nil)
			aDados[VALMERC] := TMP2->DBC_UESPE2

			oSection2:PrintLine()
			aFill(aDados,nil)

			i++
			TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",170), nRow, 10) // TOTAL GASTOS DE IMPORTACION)
		oReport:SkipLine()

		aDados[VALMERC] := "TOTAL GASTOS IMPORTACION: "
		aDados[LOCAL] := nValMerc

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

		aDados[NOME] := "REMITO + GASTOS IMPORTACION - CERDITO FISCAL: "
		aDados[VALMERC] := nTotalGral
		aDados[VALBRUT] := nValMerc
		aDados[MOEDA] := (-1) * nTotalFis
		aDados[TXMOEDA] := nTotalGral + nValMerc - nTotalFis

		oSection3:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection3:Finish()

		/////query  4

		If Select("TMP4") > 0
			dbCloseArea()
		Endif

		cQuery4:= " SELECT DISTINCT F1_FILIAL,F1_HAWB F1_HAWB,F1_TIPODOC,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_EMISSAO,F1_VALMERC+F1_FRETE+F1_DESPESA+F1_SEGURO F1_VALMERC,F1_VALBRUT,F1_ESPECIE,F1_MOEDA,F1_TXMOEDA"
		cQuery4+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery4+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE"
		cQuery4+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
		cQuery4+= " WHERE F1_DOC = '" + cPoliza + "' "
		cQuery4+= " AND F1_HAWB =  '" + cPoliIMP + "' "
		cQuery4+= " AND F1_TIPODOC = '10'"
		cQuery4+= " AND SF1.D_E_L_E_T_!='*' AND SD1.D_E_L_E_T_!='*' AND SA2.D_E_L_E_T_!='*'"
		cQuery4 := ChangeQuery(cQuery4)
		TCQUERY cQuery4 NEW ALIAS "TMP4"
		IF TMP4->(!EOF()) .AND. TMP4->(!BOF())
			TMP4->(dbGoTop())
		end
		oReport:SetMeter(TMP4->(RecCount()))
		nValFact := 0

		While TMP4->(!Eof())

			nValFact +=	TMP4->F1_VALMERC

			TMP4->(DbSkip())       // Avanza el puntero del registro en el archivo
		End


		// ***************** oSection5 ********************
		oSection5:Init()
		aFill(aDados,nil)
		oReport:SetMeter(4)
		nRow := oReport:Row()

		aDados[NOME] := "REMITO + GASTOS IMPORTACION - CREDITO FISCAL: "
		aDados[TOTAL] := nTotalGral + nValMerc - nTotalFis
		oSection5:PrintLine()
		aFill(aDados,nil)

		aDados[NOME] := "FACTURAS + RECIBOS: "
		aDados[TOTAL] := nValFact
		oSection5:PrintLine()
		aFill(aDados,nil)

		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",40), nRow, uConcep) //DIFERENCIA
		cLinha := Replicate("_",nTamVal)
		oReport:PrintText(cLinha, nRow, uDifer)
		oReport:SkipLine()

		aDados[NOME] := "DIFERENCIA: "
		aDados[TOTAL] := (nTotalGral + nValMerc - nTotalFis) - nValFact
		oSection5:PrintLine()
		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection5:Finish()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga indice ou consulta(Query)                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP

			TMP2->(dbCloseArea())
			TMP4->(dbCloseArea())

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


	aAdd(aRegs,{"01","Numero de Despacho: ","mv_ch1","C",20,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"02","A Numero de Despacho: ","mv_ch2","C",20,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})

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
