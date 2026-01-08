#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE PEDIDO		1
#DEFINE CLIENTE		2
#DEFINE CLNOM  		3
#DEFINE FEMIS		4
#DEFINE FDOC		5
#DEFINE FVENCT		6
#DEFINE BIMP 	7
#DEFINE MCOBR		8
#DEFINE SALD		9
#DEFINE RECIBO		10
#DEFINE FRECIBO		11
#DEFINE VLRECIB		12
#DEFINE VALRECB		13
#DEFINE ATOTVE		14
#DEFINE ATOTDES		15
#DEFINE AVTANET		16
#DEFINE AVTANETBS	17
#DEFINE VENDEDOR	18
#DEFINE VENDEDORNOM	19

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ CPGPRML  บ Autor ณ Erick Etcheverry 	   บ Data ณ  28/08/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ REPORTE facturas diarias	 	 				  	            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TdeP                                       	            	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PEDCLMOV()
    Local oReport
    Local cPerg := "PEDCLMOV"
    If FindFunction("TRepInUse") .And. TRepInUse()
        //	pergunte("RGtoImport",.T.)
        CriaSX1(cPerg)	// Si no esta creada la crea

        Pergunte(cPerg,.t.)

        oReport := ReportDef()
        oReport:PrintDialog()
    Endif
Return Nil

Static Function ReportDef()
    Local oReport
    Local oSection1
    Local cPerg
    cPerg := "PEDCLMOV"

    oReport := TReport():New("PEDCLMOV","Cuentas cliente pedido Movimientos",cPerg,{|oReport| ReportPrint(oReport)},;
        "Cuentas cliente pedido efectivo",,,,,,,0.5)

    //oReport:SetPortrait(.T.)
    oReport:SetLandscape(.T.)
    oReport:lParamPage := .F.
    oReport:cFontBody := 'Courier New'
    oReport:nFontBody := 14

    oSection2 := TRSection():New(oReport,"Cuentas cliente pedido Movimientos",,)

    TRCell():New(oSection2,"Pedido","SF2","PEDIDO DE VENTA","",6)
    TRCell():New(oSection2,"Cliente","SF2","COD CLIENTE","",6)
    TRCell():New(oSection2,"Cliente_nom","SF2","CLIENTE","",40)
    TRCell():New(oSection2,"Vendedor_cod","SF2","COD VENDEDOR","",6)
    //TRCell():New(oSection2,"Vendedor","SF2","VENDEDOR","",40)
    TRCell():New(oSection2,"Fecha_emi","SF2","FECHA",PesqPict("SF2","F2_EMISSAO"),10,,,,,,,,,,,)
    TRCell():New(oSection2,"Nro_Doc","SF2","NRO FACTURA","",13)
    //TRCell():New(oSection2,"Fecha_vcto","SF2","FECHA VENCIMIENTO",PesqPict("SF2","F2_EMISSAO"),10)
    TRCell():New(oSection2,"Base_imp","SF2","VALOR PEDIDO",,17)
    TRCell():New(oSection2,"MONTO_COBRADO","SF2","VALOR PAGADO",,17)
    TRCell():New(oSection2,"TOTSAL","SF2","VALOR EN ABIERTO",,17)	
    TRCell():New(oSection2,"EL_RECIBO","SEL","NRO RECIBO",,17)
	TRCell():New(oSection2,"EL_DTDIGIT","SEL","FECHA RECIBO",PesqPict("SF2","F2_EMISSAO"),10)
    TRCell():New(oSection2,"EL_TIPO","SEL","VL",,3)
    TRCell():New(oSection2,"EL_VALOR","SEL","VALOR RECIBO",,17)

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[20]

	oSection2:Cell("Pedido"):SetBlock( { || aDados[PEDIDO] })
	oSection2:Cell("Cliente"):SetBlock( { || aDados[CLIENTE] })
	oSection2:Cell("Cliente_nom"):SetBlock( { || aDados[CLNOM] })	
	oSection2:Cell("Vendedor_cod"):SetBlock( { || aDados[VENDEDOR] })
	//oSection2:Cell("Vendedor"):SetBlock( { || aDados[VENDEDORNOM] })
	oSection2:Cell("Fecha_emi"):SetBlock( { || aDados[FEMIS] })
	oSection2:Cell("Nro_Doc"):SetBlock( { || aDados[FDOC] })
	//oSection2:Cell("Fecha_vcto"):SetBlock( { || aDados[FVENCT] })
	oSection2:Cell("Base_imp"):SetBlock( { || aDados[BIMP] })
	oSection2:Cell("MONTO_COBRADO"):SetBlock( { || aDados[MCOBR] })
	oSection2:Cell("TOTSAL"):SetBlock( { || aDados[SALD] })
	oSection2:Cell("EL_RECIBO"):SetBlock( { || aDados[RECIBO] })
	oSection2:Cell("EL_DTDIGIT"):SetBlock( { || aDados[FRECIBO] })
	oSection2:Cell("EL_TIPO"):SetBlock( { || aDados[VLRECIB] })
	oSection2:Cell("EL_VALOR"):SetBlock( { || aDados[VALRECB] })
	

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)
	/*
	SELECT MAX(E5_ORDREC) E5_ORDREC FROM SE5010
	WHERE E5_NUMERO = '0000000000003' AND E5_CLIFOR = '000009' AND E5_LOJA = '01'
	*/
	cQuery2:= "SELECT D2_PEDIDO PEDIDO,F2_MOEDA,A1_FILIAL SUCURSAL,A1_COD CLIENTE,A1_NOME CLIENTE_NOM,ISNULL(A3_COD, 'S/V') VENDEDOR_COD,
    cQuery2+= " ISNULL(A3_NOME, 'SIN VENDEDOR') VENDEDOR,F2_EMISSAO FECHA_EMI,F2_DOC NRO_DOC,F2_SERIE,SUM(D2_QUANT) / (SELECT COUNT(EL_RECIBO) NREC FROM " + RetSQLname('SEL') + " SEL WHERE EL_NUMERO = F2_DOC AND EL_PREFIXO = F2_SERIE GROUP BY EL_FILIAL,EL_NUMERO,EL_PREFIXO) CANTIDAD, SUM(D2_PRCVEN)/(SELECT COUNT(EL_RECIBO) NREC  FROM " + RetSQLname('SEL') + " SEL WHERE EL_NUMERO = F2_DOC AND EL_PREFIXO = F2_SERIE GROUP BY EL_FILIAL,EL_NUMERO,EL_PREFIXO) PRECIO, "	
	cQuery2+= " SUM(D2_BASIMP1) BASE_IMP,(CASE WHEN F2_MOEDA = 1 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN (sum(D2_TOTAL) / F2_VALMERC) * SELNO.EL_VALOR ELSE (SUM(D2_BASIMP1) / F2_VALMERC) * SELNO.EL_VALOR END "
	cQuery2+= " ELSE CASE WHEN sum(D2_BASIMP1) = 0 THEN (SUM(D2_TOTAL) / F2_VALMERC) * SELNO.EL_VALOR ELSE (SUM(D2_BASIMP1) / F2_VALMERC) * SELNO.EL_VALOR END*CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE (SELECT MAX(M2_MOEDA2) "
	cQuery2+= " FROM "+ RetSQLname('SM2') + " SM2 "
	cQuery2+= " WHERE M2_DATA = F2_EMISSAO) END END) EL_VALOR, "
	cQuery2+= " (CASE WHEN F2_MOEDA = 1 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END "
	cQuery2+= " ELSE CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END*CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE(SELECT MAX(M2_MOEDA2) "
	cQuery2+= " FROM "+ RetSQLname('SM2') + " SM2 "
	cQuery2+= " WHERE M2_DATA = F2_EMISSAO) END END)/ISNULL(SUM(VALOR),1)*ISNULL(SUM(TOTSAL), 0) TOTSAL,E1_VENCTO Fecha_vcto,SEL.EL_RECIBO+'-'+SEL.EL_SERIE EL_RECIBO,SEL.EL_EMISSAO EL_DTDIGIT,SEL.EL_TIPO, "
	cQuery2+= " CASE F2_MOEDA WHEN 1 THEN SEL.EL_VLMOED1 ELSE (CASE WHEN SEL.EL_MOEDA LIKE  '%2%' THEN SEL.EL_VALOR ELSE SEL.EL_VALOR / SEL.EL_TXMOEDA END) END AS EL_VALOR2, "
	
	cQuery2+= " (CASE WHEN F2_MOEDA = 1 THEN CASE WHEN SUM(D2_BASIMP1) = 0 THEN (SUM(D2_TOTAL) / F2_VALMERC) * (VALOR - TOTSAL) "
    cQuery2+= " ELSE (SUM(D2_BASIMP1) / F2_VALMERC) * (VALOR - TOTSAL) END ELSE CASE WHEN SUM(D2_BASIMP1) = 0 "
	cQuery2+= " THEN (SUM(D2_TOTAL) / F2_VALMERC) * (VALOR - TOTSAL) ELSE (SUM(D2_BASIMP1) / F2_VALMERC) * (VALOR - TOTSAL) "
    cQuery2+= " END*CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE (SELECT MAX(M2_MOEDA2) FROM "+ RetSQLname('SM2') + " SM2 WHERE "
	cQuery2+= " M2_DATA = F2_EMISSAO) END END) VALOR_PAGADO "

	
	cQuery2+= " FROM "+ RetSQLname('SF2') + " SF2  "
	
	cQuery2+= " JOIN "+ RetSQLname('SD2') + " SD2 ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND D2_ESPECIE = 'NF   ' AND D2_FILIAL = F2_FILIAL AND SD2.D_E_L_E_T_ = ' '  "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SA3') + " SA3 ON F2_VEND1 = A3_COD "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SA1') + " SA1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SBM') + " SBM ON B1_GRUPO = BM_GRUPO AND B1_FILIAL = BM_FILIAL "
	cQuery2+= " LEFT JOIN (SELECT E1_FILIAL, E1_NUM, E1_SERIE, E1_CLIENTE, E1_LOJA,E1_VENCTO, SUM(E1_VALOR) VALOR, SUM(E1_SALDO) TOTSAL,E1_PARCELA,E1_PREFIXO "
	cQuery2+= " FROM "+ RetSQLname('SE1') + " SE1 "
	cQuery2+= " WHERE D_E_L_E_T_ = ' ' GROUP BY E1_FILIAL, E1_NUM, E1_SERIE, E1_CLIENTE, E1_LOJA,E1_VENCTO,E1_PARCELA,E1_PREFIXO "
	cQuery2+= " ) SE1 ON E1_NUM = F2_DOC AND E1_SERIE = F2_SERIE AND E1_CLIENTE = F2_CLIENTE AND E1_LOJA = F2_LOJA AND E1_FILIAL= F2_FILIAL "
	cQuery2+= " JOIN "+ RetSQLname('SEL') + " SELNO ON SELNO.D_E_L_E_T_ = ' ' AND SELNO.EL_NUMERO = E1_NUM  AND SELNO.EL_PREFIXO = F2_SERIE  AND SELNO.EL_CLIORIG = F2_CLIENTE AND SELNO.EL_LOJORIG = F2_LOJA "
	cQuery2+= " JOIN "+ RetSQLname('SEL') + " SEL ON SEL.EL_RECIBO = SELNO.EL_RECIBO AND SEL.EL_CLIORIG = F2_CLIENTE AND SEL.EL_LOJORIG = F2_LOJA "	
		
	
	cQuery2+= " WHERE SF2.D_E_L_E_T_ = ' ' AND F2_VEND1 BETWEEN '" + MV_PAR13 + "' AND '" + MV_PAR14 + "' "	  

	cQuery2+= " AND F2_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "

	cQuery2+= " AND F2_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	
	cQuery2+= " AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND F2_ESPECIE = 'NF' "	

	cQuery2+= " AND SEL.EL_TIPODOC IN('CC','CD','TF','CH') "	
	
	cQuery2+= " AND ISNULL(SEL.EL_EMISSAO, '" + DTOS(MV_PAR11) + "') BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "'  "	

	cQuery2+= " AND ISNULL(SEL.EL_RECIBO, '" + MV_PAR09 + "') BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "

	cQuery2+= " AND ISNULL(SEL.EL_COBRAD, '" + MV_PAR15 + "') BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' AND ISNULL(SEL.D_E_L_E_T_, ' ') = ' '  "

	cQuery2+= " AND BM_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "

	cQuery2+= " AND ISNULL(SBM.D_E_L_E_T_, ' ') = ' ' "

	cQuery2+= " AND ISNULL(SEL.D_E_L_E_T_, ' ') = ' ' "
   
	cQuery2+= " AND ISNULL(SA3.D_E_L_E_T_, ' ') = ' ' "
   
   cQuery2+= " AND ISNULL(SA1.D_E_L_E_T_, ' ') = ' ' " 
	
	cQuery2+= " GROUP BY F2_EMISSAO,D2_PEDIDO,F2_MOEDA,A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A3_COD,A3_NOME,F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,E1_VENCTO,F2_TXMOEDA,SEL.EL_RECIBO,SEL.EL_SERIE,SEL.EL_EMISSAO,SEL.EL_TIPO,SEL.EL_VALOR,SEL.EL_VLMOED1,SEL.EL_MOEDA,SEL.EL_TXMOEDA,F2_VALMERC,SELNO.EL_VALOR,VALOR, TOTSAL "
	
	cQuery2+= " UNION "

	cQuery2+= " SELECT ' ' PEDIDO,EL_MOEDA F2_MOEDA,EL_FILIAL SUCURSAL,EL_CLIENTE CLIENTE,A1_NOME CLIENTE_NOM,' ' VENDEDOR_COD, "

	cQuery2+= " ' ' VENDEDOR,EL_EMISSAO FECHA_EMI,'RA' NRO_DOC,'RA' F2_SERIE,0 CANTIDAD,0 PRECIO,0 BASE_IMP, EL_VALOR EL_VALOR, "

	cQuery2+= " 0 TOTSAL,EL_DTVCTO Fecha_vcto,EL_RECIBO+'-'+EL_SERIE EL_RECIBO,EL_EMISSAO EL_DTDIGIT,EL_TIPO, ( CASE WHEN EL_MOEDA LIKE '%2%' THEN EL_VALOR ELSE EL_VALOR / CASE WHEN EL_TXMOEDA = 0 THEN 1 ELSE EL_TXMOEDA END END ) EL_VALOR2, 0 VALOR_PAGADO "
	
	cQuery2+= " FROM "+ RetSQLname('SEL') + " SEL, "+ RetSQLname('SA1') + " SA1 "

	cQuery2+= " WHERE ISNULL(SEL.D_E_L_E_T_, ' ') = ' ' AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SEL.EL_CLIENTE AND SA1.A1_LOJA = SEL.EL_LOJA "
	
	cQuery2+= " AND ISNULL(EL_RECIBO, '" + MV_PAR09 + "') BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' AND ISNULL(EL_EMISSAO, '" + DTOS(MV_PAR11) + "') BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' "

	cQuery2+= " AND ISNULL(EL_COBRAD, '" + MV_PAR15 + "') BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' AND SEL.EL_TIPODOC IN('RA')"

	cQuery2+= " ORDER BY EL_RECIBO,NRO_DOC,F2_SERIE,CLIENTE "

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
	i:=0

	nTotSu = 0
	nTotDes = 0
	nTotNet = 0
	nTotNetBs = 0
	nValImpUs = 0
	nValCobUs = 0
	nValTotUs = 0
	nValImpBs = 0
	nValCobBs = 0
	nValTotBs = 0
	nValCobrBs = 0
	nValCobrUs = 0
	nTtoRecb = 0

    cDoc := TMP2->Pedido+TMP2->Cliente+TMP2->Nro_Doc+TMP2->F2_SERIE
	
	lFirtra := .t.

    While TMP2->(!Eof())
		
		cAct := TMP2->Pedido+TMP2->Cliente+TMP2->Nro_Doc+TMP2->F2_SERIE

		if cAct != cDoc .or. lFirtra //si es otro documento salta de pagina

			if (TMP2->F2_MOEDA == 1)
				nValImpUs = xMoeda(TMP2->Base_imp,1,2,STOD(TMP2->Fecha_emi),2)
				nValCobUs = xMoeda(TMP2->VALOR_PAGADO,1,2,stod(TMP2->Fecha_emi),2)
				nValTotUs = xMoeda(TMP2->TOTSAL,1,2,stod(TMP2->Fecha_emi),2)
				nValImpBs = TMP2->Base_imp
				nValCobBs = TMP2->VALOR_PAGADO
				nValTotBs = TMP2->TOTSAL
				nValCobrBs = iif(MV_PAR17 == 1,TMP2->EL_VALOR,xMoeda(TMP2->EL_VALOR,1,2,stod(TMP2->EL_DTDIGIT),2))
			else
				nValImpBs = xMoeda(TMP2->Base_imp,2,1,stod(TMP2->Fecha_emi),2)
				nValCobBs = xMoeda(TMP2->VALOR_PAGADO,2,1,stod(TMP2->Fecha_emi),2)
				nValTotBs = xMoeda(TMP2->TOTSAL,2,1,stod(TMP2->Fecha_emi),2)
				nValImpUs = TMP2->Base_imp
				nValCobUs = TMP2->VALOR_PAGADO
				nValTotUs = TMP2->TOTSAL
				nValCobrUs = iif(MV_PAR17 == 2,TMP2->EL_VALOR,xMoeda(TMP2->EL_VALOR,2,1,stod(TMP2->EL_DTDIGIT),2))
			ENDIF
			
			aDados[PEDIDO] :=  TMP2->Pedido		
			aDados[VENDEDOR] := TMP2->Vendedor_cod
			aDados[CLIENTE] := TMP2->Cliente
			aDados[CLNOM] :=   TMP2->Cliente_nom
			aDados[FEMIS] :=   STOD(TMP2->Fecha_emi)
			aDados[FDOC] :=    TMP2->Nro_Doc
			aDados[BIMP] :=    iif(MV_PAR17 == 1,nValImpBs,nValImpUs)
			aDados[MCOBR] :=   iif(MV_PAR17 == 1,nValCobBs,nValCobUs)
			aDados[SALD] :=    iif(MV_PAR17 == 1,nValTotBs,nValTotUs)
			
			aDados[RECIBO] :=  TMP2->EL_RECIBO
			aDados[FRECIBO] := 	STOD(TMP2->EL_DTDIGIT)
			aDados[VLRECIB] := 	iif(empty(alltrim(TMP2->EL_RECIBO)) ,"",alltrim(TMP2->EL_TIPO))
			aDados[VALRECB] :=  iif(MV_PAR17 == 1,nValCobrBs,nValCobrUs)  

			nTotSu +=	aDados[BIMP]
			nTotDes += aDados[MCOBR]
			nTotNet += aDados[SALD]
			nTtoRecb += aDados[VALRECB]
			
			aDados[BIMP] :=    ALLTRIM(TRANSFORM((aDados[BIMP])	,"@E 999,999,999.99"))
			aDados[MCOBR] :=   ALLTRIM(TRANSFORM((aDados[MCOBR]),"@E 999,999,999.99"))
			aDados[SALD] :=    ALLTRIM(TRANSFORM((aDados[SALD])	,"@E 999,999,999.99"))
			//aDados[VALRECB] :=    ALLTRIM(TRANSFORM((aDados[VALRECB])	,"@E 999,999,999.99"))

			oSection2:PrintLine()
			aFill(aDados,nil)
			
		else
			
			if (TMP2->F2_MOEDA == 1)
				nValImpUs = xMoeda(TMP2->Base_imp,1,2,STOD(TMP2->Fecha_emi),2)
				nValCobUs = xMoeda(TMP2->VALOR_PAGADO,1,2,stod(TMP2->Fecha_emi),2)
				nValTotUs = xMoeda(TMP2->TOTSAL,1,2,stod(TMP2->Fecha_emi),2)
				nValImpBs = TMP2->Base_imp
				nValCobBs = TMP2->VALOR_PAGADO
				nValTotBs = TMP2->TOTSAL
				nValCobrBs = iif(MV_PAR17 == 1,TMP2->EL_VALOR,xMoeda(TMP2->EL_VALOR,1,2,stod(TMP2->EL_DTDIGIT),2))
			else
				nValImpBs = xMoeda(TMP2->Base_imp,2,1,stod(TMP2->Fecha_emi),2)
				nValCobBs = xMoeda(TMP2->VALOR_PAGADO,2,1,stod(TMP2->Fecha_emi),2)
				nValTotBs = xMoeda(TMP2->TOTSAL,2,1,stod(TMP2->Fecha_emi),2)
				nValImpUs = TMP2->Base_imp
				nValCobUs = TMP2->VALOR_PAGADO
				nValTotUs = TMP2->TOTSAL
				nValCobrUs = iif(MV_PAR17 == 2,TMP2->EL_VALOR,xMoeda(TMP2->EL_VALOR,2,1,stod(TMP2->EL_DTDIGIT),2))
			ENDIF

			aDados[RECIBO] :=  TMP2->EL_RECIBO
			aDados[FRECIBO] := 	STOD(TMP2->EL_DTDIGIT)
			aDados[VLRECIB] := 	iif(empty(alltrim(TMP2->EL_RECIBO)) ,"",alltrim(TMP2->EL_TIPO))
			aDados[VALRECB] :=  iif(MV_PAR17 == 1,nValCobrBs,nValCobrUs)  

			aDados[PEDIDO] :=  ""	
			aDados[VENDEDOR] := ""
			aDados[CLIENTE] := ""
			aDados[CLNOM] :=   ""
			aDados[FEMIS] :=   CTOD(" / / ")
			aDados[FDOC] :=    ""

			aDados[BIMP] :=    iif(MV_PAR17 == 1,nValImpBs,nValImpUs)
			aDados[MCOBR] :=   iif(MV_PAR17 == 1,nValCobBs,nValCobUs)
			aDados[SALD] :=    iif(MV_PAR17 == 1,nValTotBs,nValTotUs)

			nTotSu +=	aDados[BIMP]
			nTotDes += aDados[MCOBR]
			nTotNet += aDados[SALD]
			nTtoRecb += aDados[VALRECB]

			aDados[BIMP] :=    ALLTRIM(TRANSFORM((aDados[BIMP])	,"@E 999,999,999.99"))
			aDados[MCOBR] :=   ALLTRIM(TRANSFORM((aDados[MCOBR]),"@E 999,999,999.99"))
			aDados[SALD] :=    ALLTRIM(TRANSFORM((aDados[SALD])	,"@E 999,999,999.99"))
			//aDados[VALRECB] :=    ALLTRIM(TRANSFORM((aDados[VALRECB])	,"@E 999,999,999.99"))

			oSection2:PrintLine()
			aFill(aDados,nil)

		endif
		
		cDoc := TMP2->Pedido+TMP2->Cliente+TMP2->Nro_Doc+TMP2->F2_SERIE

		lFirtra = .f.

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

    Enddo
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)

	oReport:SkipLine()

	aDados[FDOC] := "TOTAL GENERAL : "
	aDados[BIMP] := ALLTRIM(TRANSFORM((nTotSu)	,"@E 999,999,999.99"))
	aDados[MCOBR] := ALLTRIM(TRANSFORM((nTotDes)	,"@E 999,999,999.99"))
	aDados[SALD] := ALLTRIM(TRANSFORM((nTotNet)	,"@E 999,999,999.99"))
	aDados[VALRECB] := nTtoRecb

	oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()
	oReport:IncMeter()

	oSection2:Finish()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Apaga indice ou consulta(Query)                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    #IFDEF TOP

	TMP2->(dbCloseArea())

    #ENDIF
	oReport:EndPage()

Return Nil

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	Local aArea := GetArea()
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.
	Local cKey

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= "" // g dos espacios sm0


	xPutSx1(cPerg,"01","De fecha de factura ?","De fecha de factura ?","De fecha de factura ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A fecha de factura ?","A fecha de factura ?","A fecha de factura ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De factura ?","De factura ?","De factura ?",         "mv_ch5","C",13,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A factura ?","A factura ?","A factura ?",         "mv_ch6","C",13,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Cliente ?","De Cliente ?","De Cliente ?","mv_ch1","C",6,0,0,"G","","SA1CLI","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Cliente ?","A Cliente ?","A Cliente ?","mv_ch2","C",6,0,0,"G","","SA1CLI","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De Grupo Producto?","De Grupo Producto?","De Grupo Producto?","mv_ch1","C",4,0,0,"G","","SBM","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A Grupo Producto?","A Grupo Producto?","A Grupo Producto?","mv_ch2","C",4,0,0,"G","","SBM","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De Recibo ?","De Recibo ?","De Recibo ?",         "mv_ch5","C",6,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A Recibo ?","A Recibo ?","A Recibo ?",         "mv_ch6","C",6,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De fecha emision recibo?","De fecha emision recibo?","De fecha emision recibo?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A fecha emision recibo?","A fecha emision recibo?","A fecha emision recibo?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"13","De Vendedor ?","De Vendedor ?","De Vendedor ?",         "mv_ch7","C",6,0,0,"G","","SA3","","","mv_par13",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"14","A Vendedor ?","A Vendedor ?","A Vendedor ?",         "mv_ch7","C",6,0,0,"G","","SA3","","","mv_par14",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"15","De Cobrador ?","De Cobrador ?","De Cobrador ?","mv_ch2","C",6,0,0,"G","","SAQ","","","mv_par15",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"16","A Cobrador ?","A Cobrador ?","A Cobrador ?","mv_ch2","C",6,0,0,"G","","SAQ","","","mv_par16",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"17","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par17","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")


	/*xPutSx1(cPerg,"01","De Producto ?","De Producto ?","De Producto ?","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Producto ?","A Producto ?","A Producto ?","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De Pedido ?","De Pedido ?","De Pedido ?",         "mv_ch5","C",6,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A Pedido ?","A Pedido ?","A Pedido ?",         "mv_ch6","C",6,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De Departamento ?","De Departamento ?","De Departamento ?",         "mv_ch7","C",2,0,0,"G","","12","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A Departamento ?","A Departamento ?","A Departamento ?",         "mv_ch8","C",2,0,0,"G","","12","","","mv_par12",""       ,""            ,""        ,""     ,"","")*/
	
return

static Function quitZero(cTexto)
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

    While lContinua

        If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
        EndIf

        If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
        EndIf
    EndDo

	RestArea(aArea)
return
