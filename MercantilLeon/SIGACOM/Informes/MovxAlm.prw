#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nain Terrazas				       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Movimiento Por Periodo y Almacen() Denar Terrazas   			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MovxAlm()	                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mercantil Leon SRL											          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Denar       ³15/11/2021³													          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/


User Function MovxAlm()
	Local oReport
	PRIVATE cPerg   := "MOVXALM"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oSection2
	Local NombreProg := "MOVIMIENTO POR PERIODO"

	oReport	 := TReport():New("MovxAlm",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"MOVIMIENTO POR PERIODO")
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera
// oReport:lPrtParamPage = .F.

	oSection := TRSection():New(oReport,"SB1",{"SB1"})
// oSection2:= TRSection():New(oSection,"SB1",{"SB1"}) //"Carga"
	oSection2 := TRSection():New(oReport,"SB1",{"SB1"})
// oReport:SetTotalInLine(.F.)
/*                                                 
TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10) 
*/
//		Comienzan a elegir los campos que desean Mostrar
	oSection:SetHeaderPage()
	oSection2:SetHeaderPage()

// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
// Codigo	Descr.Espec.	Un.	Grupo	Cant. Ini.	    Cant. Fin.			Ventas   seccion 1
//			 	                        Cant.Ult.Compra	Fecha Ult. Comp	          	 seccion 2
	TRCell():New(oSection,"B1_COD"	,"SB1")
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1")
	TRCell():New(oSection,"B1_UM"		,"SB1")
	TRCell():New(oSection,"B1_GRUPO"	,"SB1")
	TRCell():New(oSection,"BI_CANT","SB1","Cant. Ini.")
	TRCell():New(oSection,"BI_CANTF","SB1","Cant. Fin.")
	TRCell():New(oSection,"B1_VENTAS","SB1","VENTAS")
	//TRCell():New(oSection,"cantPedidos","SB1","Pedido de Venta")
	TRCell():New(oSection,"SALDO_01","SD1","Cant. Fin. Dep. 01")
	TRCell():New(oSection,"VENTA_01","SD2","Ventas Dep. 01")
	TRCell():New(oSection,"SALDO_02","SD1","Cant. Fin. Dep. 02")
	TRCell():New(oSection,"VENTA_02","SD2","Ventas Dep. 02")
	TRCell():New(oSection,"SALDO_03","SD1","Cant. Fin. Dep. 03")
	TRCell():New(oSection,"VENTA_03","SD2","Ventas Dep. 03")
	TRCell():New(oSection,"SALDO_04","SD1","Cant. Fin. Dep. 04")
	TRCell():New(oSection,"VENTA_04","SD2","Ventas Dep. 04")
	TRCell():New(oSection,"SALDO_11","SD1","Cant. Fin. Dep. 11")
	TRCell():New(oSection,"VENTA_11","SD2","Ventas Dep. 11")
	TRCell():New(oSection,"SALDO_12","SD1","Cant. Fin. Dep. 12")
	TRCell():New(oSection,"VENTA_12","SD2","Ventas Dep. 12")
	TRCell():New(oSection,"SALDO_21","SD1","Cant. Fin. Dep. 21")
	TRCell():New(oSection,"VENTA_21","SD2","Ventas Dep. 21")
	TRCell():New(oSection,"SALDO_31","SD1","Cant. Fin. Dep. 31")
	TRCell():New(oSection,"VENTA_31","SD2","Ventas Dep. 31")
	TRCell():New(oSection,"SALDO_41","SD1","Cant. Fin. Dep. 41")
	TRCell():New(oSection,"VENTA_41","SD2","Ventas Dep. 41")
	TRCell():New(oSection,"SALDO_51","SD1","Cant. Fin. Dep. 51")
	TRCell():New(oSection,"VENTA_51","SD2","Ventas Dep. 51")
	TRCell():New(oSection,"SALDO_61","SD1","Cant. Fin. Dep. 61")
	TRCell():New(oSection,"VENTA_61","SD2","Ventas Dep. 61")



	TRCell():New(oSection2,"VACIO"	,"SB1","         ",PesqPict("SB1","B1_COD") ,TamSx3("B1_COD")[1])
	TRCell():New(oSection2,"B1_UESPEC2"	,"SB1")
	TRCell():New(oSection2,"VACIO"	,"SB1","         ",PesqPict("SB1","B1_UM") ,TamSx3("B1_UM")[1])
	TRCell():New(oSection2,"VACIO"	,"SB1","         ",PesqPict("SB1","B1_GRUPO") ,TamSx3("B1_GRUPO")[1])
	TRCell():New(oSection2,"CANTULTC"		,"SB1","Cant.Ult.Compra")
	TRCell():New(oSection2,"UFecha"		,"SB1","Fecha Ult. Comp",PesqPict("SD1","D1_EMISSAO") ,)
	TRCell():New(oSection2,"PREVENT","SB1","Prevista Entrada")

	oSection2:Cell("CANTULTC"):SetLineBreak()
Return oReport

Static Function PrintReport(oReport)
	Local oSection    := oReport:Section(1)
	Local oSection2   := oReport:Section(2)
	Local aArea       := GetArea()
	Local cAliasQry   := GetNextAlias()
	Local cQry        := ""
	Local nCont       := 0

	#IFDEF TOP

		cQry := " SELECT B1_COD, B1_ESPECIF, B1_UM, B1_UESPEC2, B1_GRUPO, ISNULL(J.UFECHA,'0') AS UFECHA, ISNULL(A.TOTAL,0) AS VENTAS,"
		cQry += " ISNULL(C.CANTULCOMPRA,0) AS CANTULTC, ISNULL(W.CANTPEDIDO,0) AS CANTPEDIDOS, ISNULL(S.PREENT,0) AS PREVENT,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '01'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '01'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '01'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_01,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '02'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '02'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '02'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_02,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '03'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '03'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '03'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_03,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '04'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '04'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '04'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_04,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '11'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '11'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '11'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_11,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '12'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '12'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '12'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_12,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '21'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '21'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '21'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_21,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '31'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '31'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '31'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_31,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '41'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '41'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '41'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_41,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '51'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '51'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '51'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_51,"

		cQry += " ("
		cQry += " 	SELECT SUM(D1_QUANT2) SALDO FROM "
		cQry += " 	("
		cQry += " 	SELECT D_E_L_E_T_, 'SD1' TABLA, D1_FILIAL, D1_COD, D1_TES, D1_LOCAL, D1_EMISSAO, D1_DTDIGIT, D1_QUANT, CASE WHEN D1_TES > 499 THEN D1_QUANT*-1 ELSE D1_QUANT END D1_QUANT2,"
		cQry += " 	CASE WHEN D1_TES > 499 THEN D1_CUSTO*-1 ELSE D1_CUSTO END D1_CUSTO, "
		cQry += " 	D1_CUSTO2, D1_DOC, D1_SERIE, D1_SEQCALC, D1_NUMSEQ, D1_LOTECTL, D1_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D_E_L_E_T_ = ' ' AND D1_COD = B1_COD"
		cQry += " 	AND D1_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D1_LOCAL = '61'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD2', D2_FILIAL, D2_COD, D2_TES, D2_LOCAL, D2_EMISSAO, D2_DTDIGIT, D2_QUANT, CASE WHEN D2_TES > 499 THEN D2_QUANT*-1 ELSE D2_QUANT END D2_QUANT2,"
		cQry += " 	CASE WHEN D2_TES > 499 THEN D2_CUSTO1*-1 ELSE D2_CUSTO1 END D2_CUSTO1, "
		cQry += " 	D2_CUSTO2, D2_DOC, D2_SERIE, D2_SEQCALC, D2_NUMSEQ, D2_LOTECTL, D2_TIPODOC, R_E_C_N_O_ FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD"
		cQry += " 	AND D2_DTDIGIT < '" + DtoS(MV_PAR02) + "' AND D2_LOCAL = '61'"
		cQry += " 	UNION"
		cQry += " 	SELECT D_E_L_E_T_, 'SD3', D3_FILIAL, D3_COD, D3_TM, D3_LOCAL, D3_EMISSAO, D3_EMISSAO, D3_QUANT, CASE WHEN D3_TM > 499 THEN D3_QUANT*-1 ELSE D3_QUANT END D3_QUANT2,"
		cQry += " 	CASE WHEN D3_TM > 499 THEN D3_CUSTO1*-1 ELSE D3_CUSTO1 END D3_CUSTO1, "
		cQry += " 	D3_CUSTO2, D3_DOC, '' SERIE, D3_SEQCALC, D3_NUMSEQ, D3_LOTECTL, D3_CF, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " WHERE D_E_L_E_T_ = ' ' AND D3_COD = B1_COD"
		cQry += " 	AND D3_EMISSAO < '" + DtoS(MV_PAR02) + "' AND D3_LOCAL = '61'"
		cQry += " 	) A"
		cQry += " 	GROUP BY D1_LOCAL"
		cQry += " ) SALDO_61,"

		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '01'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_01,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '02'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_02,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '03'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_03,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '04'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_04,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '11'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_11,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '12'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_12,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '21'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_21,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '31'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_31,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '41'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_41,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '51'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_51,"
		cQry += " ("
		cQry += " 	SELECT SUM(D2_QUANT) D2_QUANT FROM " + RetSqlName("SD2") + " WHERE D_E_L_E_T_ = ' ' AND D2_COD = B1_COD AND D2_TES IN ('510','801') AND D2_DTDIGIT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
		cQry += " 	AND D2_LOCAL = '61'"
		cQry += " 	GROUP BY D2_LOCAL "
		cQry += " ) VENTA_61"

		cQry += " FROM " + RetSqlName("SB1") + " SB1 LEFT JOIN "
		cQry += " ("
		cQry += " 	SELECT D2_COD,SUM(D2_QUANT) AS TOTAL"
		cQry += " 	FROM " + RetSqlName("SD2") + " SD2"
		cQry += " 	WHERE D2_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' AND D2_ESPECIE = 'NF' AND D_E_L_E_T_ = ' '"
		cQry += " 	GROUP BY D2_COD"
		cQry += " ) A ON A.D2_COD = B1_COD LEFT JOIN"
		cQry += " ("
		cQry += " 	SELECT A.C7_PRODUTO,SUM(C7_QUANT) AS CANTULCOMPRA FROM " + RetSqlName("SC7") + " SC7 ,"
		cQry += " 	("
		cQry += " 		SELECT C7_PRODUTO,MAX(R_E_C_N_O_) AS UFECHA "
		cQry += " 		FROM " + RetSqlName("SC7") + " SC7"
		cQry += " 		WHERE  D_E_L_E_T_ = ' '"
		cQry += " 		GROUP BY C7_PRODUTO"
		cQry += " 	) A WHERE  R_E_C_N_O_ = UFECHA AND SC7.C7_PRODUTO = A.C7_PRODUTO GROUP BY A.C7_PRODUTO"
		cQry += " ) C ON  C.C7_PRODUTO = B1_COD LEFT JOIN"
		cQry += " ("
		cQry += " 	SELECT C7_PRODUTO,MAX(C7_EMISSAO) AS UFECHA FROM " + RetSqlName("SC7") + " SC7 WHERE "
		cQry += " 	D_E_L_E_T_ = ' '"
		cQry += " 	GROUP BY C7_PRODUTO"
		cQry += " ) AS J ON J.C7_PRODUTO = B1_COD LEFT JOIN"
		cQry += " ("
		cQry += " 	SELECT C7_PRODUTO,sum(C7_QUANT-C7_QUJE) AS PREENT"
		cQry += " 	FROM " + RetSqlName("SC7") + " SC7 "
		cQry += " 	WHERE  D_E_L_E_T_ = ' '"
		cQry += " 	GROUP BY C7_PRODUTO"
		cQry += " ) AS S ON S.C7_PRODUTO = B1_COD LEFT JOIN"
		cQry += " ("
		cQry += " 	SELECT C9_PRODUTO, SUM(C9_QTDLIB) AS CANTPEDIDO"
		cQry += " 	FROM " + RetSqlName("SC9") + " SC9"
		cQry += " 	WHERE D_E_L_E_T_ = ' '"
		cQry += " 	GROUP BY C9_PRODUTO"
		cQry += " ) AS W ON W.C9_PRODUTO = B1_COD"
		cQry += " WHERE SB1.D_E_L_E_T_ = ' ' AND B1_GRUPO = '" + MV_PAR03 + "'"
		cQry += " ORDER BY VENTAS DESC"

		cQry := ChangeQuery(cQry)

		cQuery:= cQry

		//Aviso("query",cvaltochar(cQuery),{"si"})

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliasQry, .F., .T.)
		dbSelectArea(cAliasQry)
		dbGoTop()

		oSection:Init()
		oSection2:Init()
		//MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
		//oSection2:PrintLine()

		While (cAliasQry)->(! EOF())
			nCont++

			oSection:Cell("B1_COD"):SetValue( (cAliasQry)->B1_COD )
			oSection:Cell("B1_ESPECIF"):SetValue( (cAliasQry)->B1_ESPECIF )
			oSection:Cell("B1_UM"):SetValue( (cAliasQry)->B1_UM )
			oSection:Cell("B1_GRUPO"):SetValue( (cAliasQry)->B1_GRUPO )
			oSection:Cell("B1_VENTAS"):SetValue( (cAliasQry)->VENTAS )
			//oSection:Cell("cantPedidos"):SetValue( (cAliasQry)->cantPedidos )

			oSection:Cell("SALDO_01"):SetValue( (cAliasQry)->SALDO_01 )
			oSection:Cell("VENTA_01"):SetValue( (cAliasQry)->VENTA_01 )
			oSection:Cell("SALDO_02"):SetValue( (cAliasQry)->SALDO_02 )
			oSection:Cell("VENTA_02"):SetValue( (cAliasQry)->VENTA_02 )
			oSection:Cell("SALDO_03"):SetValue( (cAliasQry)->SALDO_03 )
			oSection:Cell("VENTA_03"):SetValue( (cAliasQry)->VENTA_03 )
			oSection:Cell("SALDO_04"):SetValue( (cAliasQry)->SALDO_04 )
			oSection:Cell("VENTA_04"):SetValue( (cAliasQry)->VENTA_04 )
			oSection:Cell("SALDO_11"):SetValue( (cAliasQry)->SALDO_11 )
			oSection:Cell("VENTA_11"):SetValue( (cAliasQry)->VENTA_11 )
			oSection:Cell("SALDO_12"):SetValue( (cAliasQry)->SALDO_12 )
			oSection:Cell("VENTA_12"):SetValue( (cAliasQry)->VENTA_12 )
			oSection:Cell("SALDO_21"):SetValue( (cAliasQry)->SALDO_21 )
			oSection:Cell("VENTA_21"):SetValue( (cAliasQry)->VENTA_21 )
			oSection:Cell("SALDO_31"):SetValue( (cAliasQry)->SALDO_31 )
			oSection:Cell("VENTA_31"):SetValue( (cAliasQry)->VENTA_31 )
			oSection:Cell("SALDO_41"):SetValue( (cAliasQry)->SALDO_41 )
			oSection:Cell("VENTA_41"):SetValue( (cAliasQry)->VENTA_41 )
			oSection:Cell("SALDO_51"):SetValue( (cAliasQry)->SALDO_51 )
			oSection:Cell("VENTA_51"):SetValue( (cAliasQry)->VENTA_51 )
			oSection:Cell("SALDO_61"):SetValue( (cAliasQry)->SALDO_61 )
			oSection:Cell("VENTA_61"):SetValue( (cAliasQry)->VENTA_61 )

			nCantIni := 0
			nCantFin := 0
			bArea := GetArea()

			// calcula los saldos
			dbSelectArea("NNR")
			dbgotop()
			While !Eof() .And. NNR->NNR_FILIAL = xFilial("NNR")
				nCantIni := nCantIni + CalcEst((cAliasQry)->B1_COD,NNR->NNR_CODIGO,MV_PAR01)[1]
				nCantFin := nCantFin + CalcEst((cAliasQry)->B1_COD,NNR->NNR_CODIGO,MV_PAR02)[1]
				dbskip()
			endDo
			NRR->(dbclosearea())

			RestArea(bArea)

			dbSelectArea(cAliasQry)

			// Asigna Valores a los Campos
			oSection:Cell("BI_CANT"):SetValue(nCantIni)
			oSection:Cell("BI_CANTF"):SetValue(nCantFin)
			oSection:PrintLine()

			oSection2:Cell("B1_UESPEC2"):SetValue( (cAliasQry)->B1_UESPEC2 )
			oSection2:Cell("CANTULTC"):SetValue( (cAliasQry)->CANTULTC ) // cantidad ultima compra
			if (cAliasQry)->UFecha == "0"
				//  oSection2:Cell("UFecha"):SetValue( DtoC(StoD((cAliasQry)->UFecha)))
			else
				oSection2:Cell("UFecha"):SetValue( DtoC(StoD((cAliasQry)->UFecha)))
			endif
			oSection2:Cell("PREVENT"):SetValue((cAliasQry)->PREVENT)

			oSection2:PrintLine()

			// return
			dbSkip()
		EndDo
		oSection:Finish()
		oSection2:Finish()
	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
//	oSection:EndQuery()
		//oSection2:SetParentQuery()
	#ELSE
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF
// oSection2:Printline()
// oSection:Print()
	RestArea( aArea )

Return


Static Function CriaSX1(cPerg)  // Crear Preguntas

   /*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
   Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
   especificaciones, 
   */
	// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
	// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
	// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado

	xPutSX1(cPerg,"01","¿De Fecha?" , "¿De Fecha?","¿De Fecha?","MV_CH1","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Fecha?" , "¿A Fecha?","¿A Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿Grupo?", "¿Grupo?","¿Grupo?","MV_CH3","C",4,0,0,"G","","SBM","","","MV_PAR03",""       ,""            ,""        ,""     ,"","")

return


Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea    := GetArea()
	Local aCabec   := {}
	Local cChar    := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local titulo   := oReport:Title()

	aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar ;
		, " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar ;
		, "Fecha Inicial: "+ cvaltochar(mv_par01) + "          " + cChar + "Fecha: "+ Dtoc(dDataBase)+ cChar  ;
		, "Fecha Final: "+ cvaltochar(mv_par02) +   "          " +  "Grupo: "+ cvaltochar(mv_par03) ;
		, "Depósito: **" + "          " +  "Usuario: " + substr(cUsuario,7,15) ;
		, "      " + "          " +  "      "}
	RestArea( aArea )
Return aCabec

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
