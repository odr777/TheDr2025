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
#DEFINE ATOTVE		14
#DEFINE ATOTDES		15
#DEFINE AVTANET		16
#DEFINE AVTANETBS	17
#DEFINE VENDEDOR	18
#DEFINE VENDEDORNOM	19

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥ CPGPRML  ∫ Autor ≥ Erick Etcheverry 	   ∫ Data ≥  28/08/2019 ∫±±
±± 													π±±
±±∫DescriáÑo ≥ REPORTE facturas diarias	Agrupadas 	 				  	    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ TdeP                                       	            	∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function CPGAGMS()
    Local oReport
    Local cPerg := "CPGPRMS"
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
    cPerg := "CPGPRMS"

    oReport := TReport():New("CPGPRMS","Cuentas por pagar por grupo de producto resumido",cPerg,{|oReport| ReportPrint(oReport)},;
        "Cuentas por pagar por grupo de producto resumido",,,,,,,0.5)

    //oReport:SetPortrait(.T.)
    oReport:SetLandscape(.T.)
    oReport:lParamPage := .F.
    oReport:cFontBody := 'Courier New'
    oReport:nFontBody := 7

    oSection2 := TRSection():New(oReport,"CUENTAS POR PAGAR POR PEDIDOS CON SALDO",,)

    // TRCell():New(oSection2,"Pedido","SF2","PEDIDO DE VENTA","",6)
    TRCell():New(oSection2,"Cliente","SF2","COD CLIENTE","",6)
    TRCell():New(oSection2,"Cliente_nom","SF2","CLIENTE","",40)
    TRCell():New(oSection2,"Vendedor_cod","SF2","COD VENDEDOR","",6)
    TRCell():New(oSection2,"Vendedor","SF2","VENDEDOR","",40)
    // TRCell():New(oSection2,"Fecha_emi","SF2","FECHA",PesqPict("SF2","F2_EMISSAO"),10,,,,,,,,,,,)
    // TRCell():New(oSection2,"Nro_Doc","SF2","NRO FACTURA","",13)
    // TRCell():New(oSection2,"Fecha_vcto","SF2","FECHA VENCIMIENTO",PesqPict("SF2","F2_EMISSAO"),10)
    TRCell():New(oSection2,"Base_imp","SF2","VALOR PEDIDO",,17)
    TRCell():New(oSection2,"MONTO_COBRADO","SF2","VALOR PAGADO",,17)
    TRCell():New(oSection2,"TOTSAL","SF2","VALOR EN ABIERTO",,17)

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[20]

	// oSection2:Cell("Pedido"):SetBlock( { || aDados[PEDIDO] })
	oSection2:Cell("Cliente"):SetBlock( { || aDados[CLIENTE] })
	oSection2:Cell("Cliente_nom"):SetBlock( { || aDados[CLNOM] })	
	oSection2:Cell("Vendedor_cod"):SetBlock( { || aDados[VENDEDOR] })
	oSection2:Cell("Vendedor"):SetBlock( { || aDados[VENDEDORNOM] })
	// oSection2:Cell("Fecha_emi"):SetBlock( { || aDados[FEMIS] })
	// oSection2:Cell("Nro_Doc"):SetBlock( { || aDados[FDOC] })
	// oSection2:Cell("Fecha_vcto"):SetBlock( { || aDados[FVENCT] })
	oSection2:Cell("Base_imp"):SetBlock( { || aDados[BIMP] })
	oSection2:Cell("MONTO_COBRADO"):SetBlock( { || aDados[MCOBR] })
	oSection2:Cell("TOTSAL"):SetBlock( { || aDados[SALD] })
	/*oSection2:Cell("F2_VEND"):SetBlock( { || aDados[AVEND] })
	oSection2:Cell("F2_LOCAL"):SetBlock( { || aDados[ADPOSTO] })
	oSection2:Cell("F2_COND"):SetBlock( { || aDados[ACONDPA] })
	oSection2:Cell("F2_VENCTO"):SetBlock( { || aDados[AVENCTO] })
	oSection2:Cell("F2_VALMERC"):SetBlock( { || aDados[ATOTVE] })
	oSection2:Cell("F2_DESCONT"):SetBlock( { || aDados[ATOTDES] })
	oSection2:Cell("F2_NETO"):SetBlock( { || aDados[AVTANET] })
	oSection2:Cell("F2_NETO2"):SetBlock( { || aDados[AVTANETBS] })*/

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	cQuery2:= " SELECT "
	cQuery2+= " F2_MOEDA,CASE WHEN F2_MOEDA = 1 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END "
	cQuery2+= " ELSE NULL END Monto_Bs,CASE WHEN F2_MOEDA = 2 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END "
	cQuery2+= " ELSE NULL END Monto_Us,CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE (SELECT MAX(M2_MOEDA2) "
	cQuery2+= " FROM "+ RetSQLname('SM2') + " SM2 "
	cQuery2+= " WHERE M2_DATA = '" + DTOS(DDATABASE) + "') END TC,CASE WHEN F2_MOEDA = 1 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END "
	cQuery2+= " ELSE CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END*CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE (SELECT MAX(M2_MOEDA2) "
	cQuery2+= " FROM "+ RetSQLname('SM2') + " SM2 "
	cQuery2+= " WHERE M2_DATA = '" + DTOS(DDATABASE) + "') END END Total_Bs,A1_FILIAL Sucursal, A1_COD Cliente, A1_LOJA Tienda, A1_NOME Cliente_nom, A1_OBSERV Obs_Cliente,  "
	cQuery2+= " ISNULL(A3_COD, 'S/V') Vendedor_cod, ISNULL(A3_NOME, 'SIN VENDEDOR') Vendedor,D2_FILIAL Sucursal_trans, "
	cQuery2+= " SUM(D2_QUANT) Cantidad, "
	cQuery2+= " SUM(D2_PRCVEN) Precio, SUM(D2_BASIMP1) Base_imp,(CASE WHEN F2_MOEDA = 1 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END "
	cQuery2+= " ELSE CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END*CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE (SELECT MAX(M2_MOEDA2) "
	cQuery2+= " FROM "+ RetSQLname('SM2') + " SM2 "
	cQuery2+= " WHERE M2_DATA = '" + DTOS(DDATABASE) + "') END END)/ISNULL(SUM(VALOR),1)*ISNULL(SUM(VALOR)-SUM(TOTSAL), 0) MONTO_COBRADO, "
	cQuery2+= " (CASE WHEN F2_MOEDA = 1 THEN CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END "
	cQuery2+= " ELSE CASE WHEN sum(D2_BASIMP1) = 0 THEN sum(D2_TOTAL) ELSE sum(D2_BASIMP1) END*CASE WHEN F2_TXMOEDA <> 0 THEN F2_TXMOEDA ELSE(SELECT MAX(M2_MOEDA2) "
	cQuery2+= " FROM "+ RetSQLname('SM2') + " SM2 "
	cQuery2+= " WHERE M2_DATA = '" + DTOS(DDATABASE) + "') END END)/ISNULL(SUM(VALOR),1)*ISNULL(SUM(TOTSAL), 0) TOTSAL "
	cQuery2+= " FROM "+ RetSQLname('SA1') + " SA1, "+ RetSQLname('SD2') + " SD2, "+ RetSQLname('SF2') + " SF2 "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SA3') + " SA3 ON F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ' ' "
	cQuery2+= " JOIN (SELECT E1_FILIAL, E1_NUM, E1_SERIE, E1_CLIENTE, E1_LOJA,E1_VENCTO, SUM(E1_VALOR) VALOR, SUM(E1_SALDO) TOTSAL"
	cQuery2+= " FROM "+ RetSQLname('SE1') + " SE1 "
	cQuery2+= " WHERE D_E_L_E_T_ = ' ' GROUP BY E1_FILIAL, E1_NUM, E1_SERIE, E1_CLIENTE, E1_LOJA,E1_VENCTO "
	cQuery2+= " ) SE1 ON E1_NUM = F2_DOC AND TOTSAL > 0 AND E1_SERIE = F2_SERIE AND E1_CLIENTE = F2_CLIENTE AND E1_LOJA = F2_LOJA AND E1_FILIAL= F2_FILIAL, "
	cQuery2+= " "+ RetSQLname('SB1') + " SB1 "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SBM') + " SBM ON B1_GRUPO = BM_GRUPO AND B1_FILIAL = BM_FILIAL AND SBM.D_E_L_E_T_ = ' ' "
	cQuery2+= " WHERE A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND D2_COD = B1_COD"
	cQuery2+= " AND D2_ESPECIE = 'NF   ' AND SA1.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "	
	
	cQuery2+= " AND D2_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	
	cQuery2+= " AND F2_VEND1 BETWEEN '" + MV_PAR14 + "' AND '" + MV_PAR15 + "' "
	
	cQuery2+= " AND A1_EST BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	
	cQuery2+= " AND BM_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	
	cQuery2+= " AND D2_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	
	cQuery2+= " AND D2_PEDIDO BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	
	cQuery2+= " AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "	
	
	// cQuery2+= " GROUP BY D2_EMISSAO,D2_PEDIDO,F2_MOEDA,A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV,A3_COD,A3_NOME,D2_FILIAL,D2_DTDIGIT,D2_DOC,D2_SERIE,D2_CLIENTE,E1_VENCTO,F2_TXMOEDA "
	cQuery2+= " GROUP BY  F2_MOEDA,A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV,A3_COD,A3_NOME,D2_FILIAL,D2_CLIENTE,F2_TXMOEDA"
	
	cQuery2+= " ORDER BY A1_COD, 1"
	

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

    While TMP2->(!Eof())
		
        if (TMP2->F2_MOEDA == 1)
			nValImpUs = xMoeda(TMP2->Base_imp,1,2,DDATABASE,2)
			nValCobUs = xMoeda(TMP2->MONTO_COBRADO,1,2,DDATABASE,2)
			nValTotUs = xMoeda(TMP2->TOTSAL,1,2,DDATABASE,2)
			nValImpBs = TMP2->Base_imp
			nValCobBs = TMP2->MONTO_COBRADO
			nValTotBs = TMP2->TOTSAL
        else
			nValImpBs = xMoeda(TMP2->Base_imp,2,1,DDATABASE,2)
			nValCobBs = xMoeda(TMP2->MONTO_COBRADO,2,1,DDATABASE,2)
			nValTotBs = xMoeda(TMP2->TOTSAL,2,1,DDATABASE,2)
			nValImpUs = TMP2->Base_imp
			nValCobUs = TMP2->MONTO_COBRADO
			nValTotUs = TMP2->TOTSAL
        ENDIF
		
		// aDados[PEDIDO] :=  TMP2->Pedido		
		aDados[VENDEDOR] := TMP2->Vendedor_cod
		aDados[VENDEDORNOM] :=   TMP2->Vendedor
		aDados[CLIENTE] := TMP2->Cliente
		aDados[CLNOM] :=   TMP2->Cliente_nom
		// aDados[FEMIS] :=   STOD(TMP2->Fecha_emi)
		// aDados[FDOC] :=    TMP2->Nro_Doc
		// aDados[FVENCT] :=  STOD(TMP2->Fecha_vcto)
		aDados[BIMP] :=    iif(MV_PAR13 == 1,nValImpBs,nValImpUs)
		aDados[MCOBR] :=   iif(MV_PAR13 == 1,nValCobBs,nValCobUs)
		aDados[SALD] :=    iif(MV_PAR13 == 1,nValTotBs,nValTotUs)  
		

		/*aDados[AVEND] :=   TMP2->F2_VEND
		aDados[ADPOSTO] := TMP2->F2_LOCAL
		aDados[ACONDPA] := TMP2->F2_COND
		aDados[AVENCTO] := STOD(TMP2->Fecha_emi)
		aDados[ATOTVE] := TMP2->F2_VALMERC
		aDados[ATOTDES] := TMP2->F2_DESCONT
		aDados[AVTANET] := ALLTRIM(TRANSFORM((TMP2->F2_NETO)	,"@E 999,999,999.99"))
		aDados[AVTANETBS] := ALLTRIM(TRANSFORM((TMP2->F2_NETO2) ,"@E 999,999,999.99"))*/

		nTotSu +=	aDados[BIMP]
		nTotDes += aDados[MCOBR]
		nTotNet += aDados[SALD]
		
		aDados[BIMP] :=    ALLTRIM(TRANSFORM((aDados[BIMP])	,"@E 999,999,999.99"))
		aDados[MCOBR] :=   ALLTRIM(TRANSFORM((aDados[MCOBR]),"@E 999,999,999.99"))
		aDados[SALD] :=    ALLTRIM(TRANSFORM((aDados[SALD])	,"@E 999,999,999.99"))

		oSection2:PrintLine()
		aFill(aDados,nil)

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

    End
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)

	oReport:SkipLine()

	aDados[FDOC] := "TOTAL GENERAL : "
	aDados[BIMP] := ALLTRIM(TRANSFORM((nTotSu)	,"@E 999,999,999.99"))
	aDados[MCOBR] := ALLTRIM(TRANSFORM((nTotDes)	,"@E 999,999,999.99"))
	aDados[SALD] := ALLTRIM(TRANSFORM((nTotNet)	,"@E 999,999,999.99"))

	oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()
	oReport:IncMeter()

	oSection2:Finish()

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Apaga indice ou consulta(Query)                                     ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
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

	// Ajusta o tamanho do grupo. Ajuste emergencial para validaÁ„o dos fontes.
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

	xPutSx1(cPerg,"01","De Producto ?","De Producto ?","De Producto ?","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Producto ?","A Producto ?","A Producto ?","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De Grupo ?","De Grupo ?","De Grupo ?","mv_ch1","C",4,0,0,"G","","SBM","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A Grupo ?","A Grupo ?","A Grupo ?","mv_ch2","C",4,0,0,"G","","SBM","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Cliente ?","De Cliente ?","De Cliente ?","mv_ch1","C",6,0,0,"G","","SA1CLI","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Cliente ?","A Cliente ?","A Cliente ?","mv_ch2","C",6,0,0,"G","","SA1CLI","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De Pedido ?","De Pedido ?","De Pedido ?",         "mv_ch5","C",6,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A Pedido ?","A Pedido ?","A Pedido ?",         "mv_ch6","C",6,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De Departamento ?","De Departamento ?","De Departamento ?",         "mv_ch7","C",2,0,0,"G","","12","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A Departamento ?","A Departamento ?","A Departamento ?",         "mv_ch8","C",2,0,0,"G","","12","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"13","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par13","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")
	xPutSx1(cPerg,"14","De Vendedor ?","De Vendedor ?","De Vendedor ?",         "mv_ch7","C",6,0,0,"G","","SA3","","","mv_par14",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"15","A Vendedor ?","A Vendedor ?","A Vendedor ?",         "mv_ch7","C",6,0,0,"G","","SA3","","","mv_par15",""       ,""            ,""        ,""     ,"","")
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
