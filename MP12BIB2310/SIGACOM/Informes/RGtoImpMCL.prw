#include 'rwmake.ch'
#include "topconn.ch"
#DEFINE UPOLIZA		1
#DEFINE SERIE  		2
#DEFINE DOC			3
#DEFINE PEDIDO		4
#DEFINE FBRT		5
#DEFINE GBRT		6
#DEFINE FBOT		7
#DEFINE GBOT 		8
#DEFINE VALMERC		9
#DEFINE VALBRUT		10
#DEFINE MOEDA		11
#DEFINE TXMOEDA		12
#DEFINE ITEM		13
#DEFINE COD			14
#DEFINE UDESC		15
#DEFINE LOCAL		16
#DEFINE UM			17
#DEFINE QUANT		18
#DEFINE VUNIT		19
#DEFINE TOTAL		20
#DEFINE PESOU		21
#DEFINE FBRU		22
#DEFINE GBRU		23
#DEFINE PESO		24
#DEFINE USUARIO		25
#DEFINE SBRU		26

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RGtoImpMCLบ Autor ณ Amby Arteaga Rivero บ Data ณ  27/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ REPORTE DE GASTOS DE IMPORTACION 			  	            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Mercantil LEON - Santa Cruz                     	            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RGtoImpMCL()
	Local oReport
	Private nTamLin

	If FindFunction("TRepInUse") .And. TRepInUse()
		//	pergunte("RGtoImpMCL",.T.)
		CargarPerg()

		Pergunte("RGtoImpMCL",.F.)

		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Return Nil

Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cPerg
	Local nTam, nTamVal, cPictVal, nTamComp
	cPerg := ("RGtoImpMCL")

	nTam	:= 130
	nTamVal	:= TamSX3("F1_VALMERC")[1]
	cPictVal	:= PesqPict("SF1","F1_VALMERC")

	nTamComp := 20
	oReport := TReport():New("GTOIMPMCL","GASTOS DE IMPORTACION",cPerg,{|oReport| ReportPrint(oReport,nTamVal)},"Este programa tiene como objetivo imprimir los Gastos de Importacion "+"de acuerdo con los parametros indicados por el usuario")

	//oReport:SetPortrait(.T.)
	oReport:SetLandscape(.T.)

	pergunte(cPerg,.F.)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para parametros                         ณ
	//ณ mv_par01  	      	// Tipo de Reporte                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection0 := TRSection():New(oReport,"REMITO",,)
	TRCell():New(oSection0,"B1_ESPECIF","SB1","", PesqPict("SB1","B1_ESPECIF"),TamSX3("B1_ESPECIF")[1],.F.,)
	TRCell():New(oSection0,"F1_UPOLIZA","SF1","NR.IMPORT")
	TRCell():New(oSection0,"F1_SERIE","SF1","SERIE")
	TRCell():New(oSection0,"F1_DOC","SF1","REMITO")
	TRCell():New(oSection0,"D1_PEDIDO","SD1","PEDIDO")
	TRCell():New(oSection0,"D1_TOTAL","SD1","Gastos $Us",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	/*TRCell():New(oSection0,"D1_CUSTO","SD1","GBRT $Us",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection0,"D1_CUSTO2","SD1","FBOT $Us",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection0,"D1_CUSTO3","SD1","GBOT $Us",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)*/

	oSection2 := TRSection():New(oReport,"DETALLE DEL REMITO",,)
	TRCell():New(oSection2,"D1_ITEM","SD1","ITEM",PesqPict("SD1","D1_ITEM"),TamSX3("D1_ITEM")[1],.F.,)
	TRCell():New(oSection2,"D1_COD","SD1","CODIGO",PesqPict("SD1","D1_COD"),TamSX3("D1_COD")[1],.F.,)
	TRCell():New(oSection2,"D1_QUANT","SD1","CANTIDAD",PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1],.F.,)
	TRCell():New(oSection2,"D1_UM","SD1","UM", PesqPict("SD1","D1_UM"),TamSX3("D1_UM")[1],.F.,)
	TRCell():New(oSection2,"B1_ESPECIF","SB1","DESCRIPCION", PesqPict("SB1","B1_ESPECIF"),TamSX3("B1_ESPECIF")[1],.F.,)
	TRCell():New(oSection2,"B1_PESO","SB1","PU KG", PesqPict("SB1","B1_PESO"),TamSX3("B1_PESO")[1],.F.,)
	TRCell():New(oSection2,"D1_PESO","SD1","PUT KG", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	TRCell():New(oSection2,"D1_VUNIT","SD1","CBRU $Us",PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1],.F.,)
	TRCell():New(oSection2,"D1_TOTAL","SD1","CRUT $Us",PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1],.F.,)
	TRCell():New(oSection2,"D2_PRCVEN","SD2","Flete $Us",PesqPict("SD2","D2_PRCVEN"),TamSX3("D2_PRCVEN")[1],.F.,)
	TRCell():New(oSection2,"D2_DESPESA","SD2","Gasto $Us",PesqPict("SD2","D2_DESPESA"),TamSX3("D2_DESPESA")[1],.F.,)
	TRCell():New(oSection2,"D2_SEGURO","SD2","Seguro $Us",PesqPict("SD2","D2_SEGURO"),TamSX3("D2_SEGURO")[1],.F.,)
	nTamLin := 12 + TamSX3("D1_ITEM")[1] + TamSX3("D1_COD")[1] + TamSX3("D1_QUANT")[1] + TamSX3("D1_UM")[1] + TamSX3("B1_ESPECIF")[1] + TamSX3("B1_PESO")[1] + TamSX3("D1_PESO")[1] + TamSX3("D1_VUNIT")[1] + TamSX3("D1_TOTAL")[1] + TamSX3("D2_PRCVEN")[1] + TamSX3("D2_DESPESA")[1] + TamSX3("D2_SEGURO")[1]
Return oReport

Static Function ReportPrint(oReport,nTamVal)
	Local oSection0  := oReport:Section(1)
	//	Local oSection1  := oReport:Section(2)
	Local oSection2  := oReport:Section(2)
	Local oSection3  := oReport:Section(3)
	Local oSection4  := oReport:Section(4)
	Local oSection5  := oReport:Section(5)
	Local aDados[26]
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
	Local cSerie := ""
	Local cRemito := ""
	Local cPedido := ""
	Local nFBRT := 0
	Local nGBRT := 0
	Local nFBOT := 0
	Local nGBOT := 0
	Local nTotPeso := 0
	Local nTotMerc := 0
	Private cTipos  // Usada por la funcion FinrTipos().

	oSection0:Cell("B1_ESPECIF"):SetBlock( { || aDados[UDESC] })
	oSection0:Cell("F1_UPOLIZA"):SetBlock( { || aDados[UPOLIZA] })
	oSection0:Cell("F1_SERIE"):SetBlock( { || aDados[SERIE] })
	oSection0:Cell("F1_DOC"):SetBlock( { || aDados[DOC] })
	oSection0:Cell("D1_PEDIDO"):SetBlock( { || aDados[PEDIDO] })
	oSection0:Cell("D1_TOTAL"):SetBlock( { || aDados[FBRT] })
	/*oSection0:Cell("D1_CUSTO"):SetBlock( { || aDados[GBRT] })
	oSection0:Cell("D1_CUSTO2"):SetBlock( { || aDados[FBOT] })
	oSection0:Cell("D1_CUSTO3"):SetBlock( { || aDados[GBOT] })*/

	oSection2:Cell("D1_ITEM"):SetBlock( { || aDados[ITEM] })
	oSection2:Cell("D1_COD"):SetBlock( { || aDados[COD] })
	oSection2:Cell("D1_QUANT"):SetBlock( { || aDados[QUANT] })
	oSection2:Cell("D1_UM"):SetBlock( { || aDados[UM] })
	oSection2:Cell("B1_ESPECIF"):SetBlock( { || aDados[UDESC] })
	oSection2:Cell("B1_PESO"):SetBlock( { || aDados[PESOU] })
	oSection2:Cell("D1_PESO"):SetBlock( { || aDados[PESO] })
	oSection2:Cell("D1_VUNIT"):SetBlock( { || aDados[VUNIT] })
	oSection2:Cell("D1_TOTAL"):SetBlock( { || aDados[TOTAL] })
	oSection2:Cell("D2_PRCVEN"):SetBlock( { || aDados[FBRU] })
	oSection2:Cell("D2_DESPESA"):SetBlock( { || aDados[GBRU] })
	oSection2:Cell("D2_SEGURO"):SetBlock( { || aDados[SBRU] })
	
	
	

	oSection2:Cell("B1_ESPECIF"):SetLineBreak(.T.)		//Salto de linea para la descripcion

	cQuery:= " SELECT DISTINCT F1_FILIAL,F1_UPOLIZA,F1_TIPODOC,F1_SERIE,F1_DOC,D1_PEDIDO "
	cQuery+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
	cQuery+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE  AND SD1.D_E_L_E_T_!='*'"
	cQuery+= " WHERE F1_UPOLIZA BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery+= " AND F1_TIPODOC = '10' AND F1_NFORIG = '' AND F1_SERORIG = ''"
	cQuery+= " AND F1_HAWB <> '' AND F1_DOC = 'MP-5809315' AND SF1.D_E_L_E_T_ =' '"
	
	//aviso("TITULOS",cQuery,{'ok'},,,,,.t.)
	
	cQuery := ChangeQuery(cQuery)

	TCQUERY cQuery NEW ALIAS "TMP0"

	IF TMP0->(!EOF()) .AND. TMP0->(!BOF())
		TMP0->(dbGoTop())
	end

	While TMP0->(!Eof())
		cPoliza := TMP0->F1_UPOLIZA
		cSerie := TMP0->F1_SERIE
		cRemito := TMP0->F1_DOC
		cPedido := TMP0->D1_PEDIDO
		#IFDEF TOP
		lQuery:=.T.

		cQuery:= " SELECT F1_UPOLIZA, SUM(D1_TOTAL) GASTOS"
		cQuery+= " FROM ("
		cQuery+= " SELECT F1_UPOLIZA,D1_TOTAL "
		cQuery+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE  AND SD1.D_E_L_E_T_!='*'"
		cQuery+= " WHERE F1_UPOLIZA = '" + cPoliza + "' "
		cQuery+= " AND D1_NFORI = '" + cRemito + "' AND D1_SERIORI = '" + cSerie + "' "
		cQuery+= " AND F1_TIPODOC IN ('13','14') "  // GASTOS
		cQuery+= " AND SF1.D_E_L_E_T_!='*' "
		cQuery+= " ) GTSIMP"
		cQuery+= " GROUP BY F1_UPOLIZA "

		//aviso("GASTOS",cQuery,{'ok'},,,,,.t.)
		
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
		//		oSection1:Init()
		aFill(aDados,nil)

		oReport:SetMeter(TMP->(RecCount()))

		nTotalGral := 0
		nTotalGtos := 0
		nTotalProd := 0

		While TMP->(!Eof())
			//aDados[UDESC] := ""
			aDados[UPOLIZA] := cPoliza
			aDados[SERIE] 	:= cSerie
			aDados[DOC] 	:= cRemito
			aDados[PEDIDO] 	:= cPedido
			aDados[FBRT] 	:= TMP->GASTOS
			/*aDados[GBRT] 	:= TMP->F1_GBRT
			aDados[FBOT] 	:= TMP->F1_FBOT
			aDados[GBOT] 	:= TMP->F1_GBOT

			nFBRT 	:= TMP->F1_FBRT
			nGBRT 	:= TMP->F1_GBRT
			nFBOT 	:= TMP->F1_FBOT*/
			//FBRT 	:= TMP->GASTOS

			oSection0:PrintLine()
			aFill(aDados,nil)
			TMP->(DbSkip())       // Avanza el puntero del registro en el archivo
		End

		// *************** TOTAL PESO Y VALOR MERCADERIA - REMITO **********************
		nTotPeso := 0
		nTotMerc := 0

		cQuery1:= " SELECT F1_FILIAL,F1_UPOLIZA,F1_TIPODOC,F1_DOC,F1_SERIE,F1_VALMERC,SUM(D1_TOTAL) D1_TOTAL,SUM(D1_PESO) D1_PESO "
		cQuery1+= " FROM ( "
		cQuery1+= " SELECT F1_FILIAL,F1_UPOLIZA,F1_TIPODOC,F1_DOC,F1_SERIE,F1_VALMERC,D1_TOTAL,D1_PESO "
		cQuery1+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery1+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE  AND SD1.D_E_L_E_T_!='*' "
		cQuery1+= " WHERE F1_DOC = '" + cRemito + "' AND F1_SERIE = '" + cSerie + "' "
		cQuery1+= " AND F1_UPOLIZA = '" + cPoliza + "' "
		cQuery1+= " AND F1_TIPODOC = '10' "
		cQuery1+= " AND SF1.D_E_L_E_T_!='*' "
		cQuery1+= " ) REMIT "
		cQuery1+= " GROUP BY F1_FILIAL,F1_UPOLIZA,F1_TIPODOC,F1_DOC,F1_SERIE,F1_VALMERC "

		//aviso("qr3",cQuery1,{'ok'},,,,,.t.)
		
		cQuery1 := ChangeQuery(cQuery1)

		If Select("TMP1") > 0//Verifica se ja existe alias criado
			TMP1->( dbCloseArea() )
		Endif

		TCQUERY cQuery1 NEW ALIAS "TMP1"

		IF TMP1->(!EOF()) .AND. TMP1->(!BOF())
			TMP1->(dbGoTop())
		end

		nTotPeso := TMP1->D1_PESO
		nTotMerc := TMP1->D1_TOTAL

		// *************** oSection2 **********************
		oSection2:Init()
		aFill(aDados,nil)

		cQuery2:= " SELECT D1_ITEM,D1_COD,D1_QUANT,D1_VALFRE,D1_DESPESA,D1_SEGURO,D1_UM,B1_ESPECIF,B1_PESO,D1_PESO,D1_VUNIT,D1_TOTAL "
		cQuery2+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 "
		cQuery2+= " ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE  AND SD1.D_E_L_E_T_!='*' "
		cQuery2+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 ON D1_COD = B1_COD AND SB1.D_E_L_E_T_!='*'"
		cQuery2+= " WHERE F1_DOC = '" + cRemito + "' AND F1_SERIE = '" + cSerie + "' "
		cQuery2+= " AND F1_UPOLIZA = '" + cPoliza + "' "
		cQuery2+= " AND F1_TIPODOC = '10' "
		cQuery2+= " AND SF1.D_E_L_E_T_!='*' "

		//aviso("",cQuery2,{'ok'},,,,,.t.)
		
		cQuery2 := ChangeQuery(cQuery2)
		
		If Select("TMP2") > 0//Verifica se ja existe alias criado
			TMP2->( dbCloseArea() )
		Endif
		
		TCQUERY cQuery2 NEW ALIAS "TMP2"

		IF TMP2->(!EOF()) .AND. TMP2->(!BOF())
			TMP2->(dbGoTop())
		end

		oReport:SetMeter(TMP2->(RecCount()))
		nValMerc 	:= 0
		nPTot 		:= 0
		nCBRTot 	:= 0
		nFBRTot 	:= 0
		nGBRTot 	:= 0
		nSBRTot 	:= 0

		While TMP2->(!Eof())
			aDados[ITEM]  := TMP2->D1_ITEM
			aDados[COD]   := TMP2->D1_COD
			aDados[QUANT] := TMP2->D1_QUANT
			aDados[UM]    := TMP2->D1_UM
			aDados[UDESC] := TMP2->B1_ESPECIF
			aDados[PESOU] := TMP2->B1_PESO
			aDados[PESO]  := TMP2->D1_PESO
			aDados[VUNIT] := TMP2->D1_VUNIT
			aDados[TOTAL] := TMP2->D1_TOTAL
			aDados[FBRU]  := TMP2->D1_VALFRE//((nFBRT / nTotPeso) * TMP2->D1_PESO) / TMP2->D1_QUANT
			aDados[GBRU]  := TMP2->D1_DESPESA//((nGBRT / nTotMerc) * TMP2->D1_TOTAL) / TMP2->D1_QUANT
			aDados[SBRU]  := TMP2->D1_SEGURO
			
			nPTot 	 += aDados[PESO]
			nCBRTot  += aDados[TOTAL]
			nFBRTot  += aDados[FBRU]
			nGBRTot  += aDados[GBRU]
			nSBRTot  += aDados[SBRU]

			oSection2:PrintLine()
			aFill(aDados,nil)

			TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

		End
		nRow := oReport:Row()
		oReport:PrintText(Replicate("_",nTamLin), nRow, 10)
		oReport:SkipLine()

		aDados[UDESC] := "TOTAL GENERAL"
		aDados[PESO] := nPTot
		aDados[TOTAL] := nCBRTot
		aDados[FBRU] := nFBRTot
		aDados[GBRU] := nGBRTot
		aDados[SBRU] := nSBRTot

		oSection2:PrintLine()
		aFill(aDados,nil)
		//		oReport:SkipLine()

		nRow := oReport:Row()		
		oReport:PrintText(Replicate("=",nTamLin), nRow, 10)
		//		aFill(aDados,nil)
		oReport:SkipLine()
		oReport:IncMeter()

		oSection2:Finish()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Apaga indice ou consulta(Query)                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		#IFDEF TOP

		//		TMP2->(dbCloseArea())
		//		TMP4->(dbCloseArea())

		TMP->(dbCloseArea())
		#ENDIF
		oReport:EndPage()
		TMP0->(DbSkip())       // Avanza el puntero del registro en el archivo

	END

Return Nil

Static Function CargarPerg()
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("RGtoImpMCL",10)
	aRegs:={}

	aAdd(aRegs,{"01","De Numero Importacion: ","mv_ch1","C",20,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"02","A Numero Importacion: ","mv_ch2","C",20,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})

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