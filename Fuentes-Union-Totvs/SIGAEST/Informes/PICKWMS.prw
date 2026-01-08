#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE AFILIAL		1
#DEFINE AFECHA		2
#DEFINE ACOD  		3
#DEFINE ADESC		4
#DEFINE AFABRIC		5
#DEFINE ADOCMT		6
#DEFINE ASERIE 	7
#DEFINE ATIPOCL		8
#DEFINE ACANTI			9
#DEFINE ALLOCAL		10
#DEFINE ALOTEC		11
#DEFINE ADTVALID		12
#DEFINE AVENCTO 	13
#DEFINE ALOCLIZ		14
/*
#DEFINE ATOTDES		15
#DEFINE AVTANET		16
#DEFINE AVTANETBS	17*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ PICKWMS  º Autor ³ Erick Etcheverry 	   º Data ³  11/09/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ REPORTE PICKWMS PICKLIST CONSOLIDADO			   	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PICKWMS()
	Local oReport
	Local cPerg := "PICKWMS"
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
	cPerg := "PICKWMS"

	oReport := TReport():New("PICKWMS","PICKING LIST CONSOLIDADO",cPerg,{|oReport| ReportPrint(oReport)},;
	"Este programa tiene como objetivo imprimir el PICKING LIST CONSOLIDADO para ventas",,,,,,,0.5)

	//oReport:SetPortrait(.T.)
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection2 := TRSection():New(oReport,"PICKING LIST CONSOLIDADO",,)

	TRCell():New(oSection2,"D2_FILIAL","SD2","Sucursal	","",4)
	//TRCell():New(oSectDad, "XX_GRUPO", "",        "Grupo",, 003, ,,,,,,/*nColSpace*/,,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection2,"D2_EMISSAO","SF2","Fecha",PesqPict("SF2","F2_EMISSAO"),10,,,,,,,,,,,)
	TRCell():New(oSection2,"D2_COD","SD2","CodProducto","",6)
	TRCell():New(oSection2,"B1_DESC","SD2","Producto","",30)
	TRCell():New(oSection2,"B1_UFABRIC","SD2","Fabricante","",3)
	TRCell():New(oSection2,"D2_DOC","SD2","Documento","",18)
	TRCell():New(oSection2,"D2_SERIE","SD2","Serie","",3)
	TRCell():New(oSection2,"A3_TIPO","SD2","TipoCliente","",9)
	TRCell():New(oSection2,"CANTIDAD","SD2","Cantidad",,14)
	TRCell():New(oSection2,"D2_LOCAL","SD2","Deposito","",2)
	TRCell():New(oSection2,"D2_LOTECTL","SD2","Lote","",10)
	TRCell():New(oSection2,"D2_DTVALID","SD2","Vencimiento",PesqPict("SF2","F2_EMISSAO"),10)
	TRCell():New(oSection2,"D2_LOCALIZ","SD2","Ubicacion","",15)

	/*TRCell():New(oSection2,"F2_VALMERC","SF2","TotVt($)",,14)
	TRCell():New(oSection2,"F2_DESCONT","SF2","Dcto($)",,14)
	TRCell():New(oSection2,"F2_NETO","SF2","VtaNet($)",,14)
	TRCell():New(oSection2,"F2_NETO2","SF2"   ,"VtaNet(Bs)",,14)*/

	//TRCell():New(oSection2,"F2_NETO2","SF2","TOTAL PESO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	/*TRCell():New(oSection2,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection2,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection2,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)*/

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[17]

	oSection2:Cell("D2_FILIAL"):SetBlock( { || aDados[AFILIAL] })
	oSection2:Cell("D2_EMISSAO"):SetBlock( { || aDados[AFECHA] })
	oSection2:Cell("D2_COD"):SetBlock( { || aDados[ACOD] })
	oSection2:Cell("B1_DESC"):SetBlock( { || aDados[ADESC] })
	oSection2:Cell("B1_UFABRIC"):SetBlock( { || aDados[AFABRIC] })
	oSection2:Cell("D2_DOC"):SetBlock( { || aDados[ADOCMT] })
	oSection2:Cell("D2_SERIE"):SetBlock( { || aDados[ASERIE] })
	oSection2:Cell("A3_TIPO"):SetBlock( { || aDados[ATIPOCL] })
	oSection2:Cell("CANTIDAD"):SetBlock( { || aDados[ACANTI] })
	oSection2:Cell("D2_LOCAL"):SetBlock( { || aDados[ALLOCAL] })
	oSection2:Cell("D2_LOTECTL"):SetBlock( { || aDados[ALOTEC] })
	oSection2:Cell("D2_DTVALID"):SetBlock( { || aDados[ADTVALID] })
	oSection2:Cell("D2_LOCALIZ"):SetBlock( { || aDados[ALOCLIZ] })

	/*oSection2:Cell("F2_VALMERC"):SetBlock( { || aDados[ALOCLIZ] })
	oSection2:Cell("F2_DESCONT"):SetBlock( { || aDados[ATOTDES] })
	oSection2:Cell("F2_NETO"):SetBlock( { || aDados[AVTANET] })
	oSection2:Cell("F2_NETO2"):SetBlock( { || aDados[AVTANETBS] })*/

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	/*
	SELECT CASE A3_TIPO WHEN 'I' THEN 'CIUDAD' WHEN 'E' THEN 'PROVINCIA' ELSE 'S/T' END A3_TIPO,
	B1_DESC,B1_UFABRIC,CORTE,D2_FILIAL,D2_EMISSAO,D2_COD,D2_CLIENTE,D2_LOJA,CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ
	FROM(SELECT D2_EMISSAO+F2_HORA CORTE,D2_FILIAL,D2_EMISSAO,F2_HORA,D2_COD,D2_CLIENTE,D2_LOJA,F2_VEND1,
	D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT)AS CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ
	FROM SD2010 SD2
	JOIN SF2010 SF2
	ON D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL
	AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND F2_ESPECIE = 'RFN' AND SF2.D_E_L_E_T_ = ''
	WHERE D2_GERANF = 'S' AND D2_ESPECIE = 'RFN'
	AND D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT) > 0
	AND D2_FILIAL BETWEEN '' AND 'ZZZZ'
	AND D2_COD BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
	AND D2_LOCAL BETWEEN '' AND 'ZZ'
	AND D2_EMISSAO+F2_HORA BETWEEN '2019090206:00' AND '2019090222:45'
	AND SD2.D_E_L_E_T_ = ''
	UNION
	SELECT D2_EMISSAO+F2_HORA AS CORTE,D2_FILIAL,D2_EMISSAO,F2_HORA,D2_COD,D2_CLIENTE,D2_LOJA,F2_VEND1
	,D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT)AS CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ
	FROM SD2010 SD2
	JOIN SF2010 SF2
	ON D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL
	AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND F2_ESPECIE = 'RFN' AND SF2.D_E_L_E_T_ = ''
	WHERE D2_GERANF = 'S' AND D2_ESPECIE = 'RFN'
	AND D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT) > 0
	AND D2_FILIAL BETWEEN '' AND 'ZZZZ'
	AND D2_COD BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
	AND D2_LOCAL BETWEEN '' AND 'ZZ'
	AND D2_EMISSAO+F2_HORA BETWEEN '2019090306:00' AND '2019090322:45'
	AND SD2.D_E_L_E_T_ = '') AS tab
	LEFT JOIN SA1010 SA1
	ON A1_COD = D2_CLIENTE AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	LEFT JOIN SA3010 SA3
	ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = ''
	LEFT JOIN SB1010 SB1
	ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ''
	WHERE A3_TIPO = 'I'
	ORDER BY D2_LOCALIZ
	*/
	cTipoCl := ""
	if MV_PAR13 == 1
		cTipoCl = "I"
	elseif MV_PAR13 == 2
		cTipoCl = "E"
	endif

	cQuery2:= " SELECT CASE A3_TIPO WHEN 'I' THEN 'CIUDAD' WHEN 'E' THEN 'PROVINCIA' ELSE 'S/T' END A3_TIPO, "
	cQuery2+= " B1_DESC,B1_UFABRIC,D2_FILIAL,D2_COD,SUM(CANTIDAD) CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ "
	cQuery2+= " FROM(SELECT D2_EMISSAO+F2_HORA CORTE,D2_FILIAL,D2_EMISSAO,F2_HORA,D2_COD,D2_CLIENTE,D2_LOJA,F2_VEND1,D2_SERIE, "
	cQuery2+= " D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT)AS CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ,D2_DOC "
	cQuery2+= " FROM "+ RetSQLname('SD2') + " SD2 JOIN "+ RetSQLname('SF2') + " SF2 "
	cQuery2+= " ON D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL "
	cQuery2+= " AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND F2_ESPECIE = 'RFN' AND SF2.D_E_L_E_T_ = '' "
	cQuery2+= " WHERE D2_GERANF = 'S' AND D2_ESPECIE = 'RFN' "
	cQuery2+= " AND D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT) > 0 "
	cQuery2+= " AND D2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND D2_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery2+= " AND D2_LOCAL BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	cQuery2+= " AND D2_EMISSAO+F2_HORA BETWEEN '" + DTOS(MV_PAR03)+MV_PAR04 + "' AND '" + DTOS(MV_PAR03)+MV_PAR05 + "' "
	cQuery2+= " AND SD2.D_E_L_E_T_ = '' "
	cQuery2+= " UNION "
	cQuery2+= " SELECT D2_EMISSAO+F2_HORA CORTE,D2_FILIAL,D2_EMISSAO,F2_HORA,D2_COD,D2_CLIENTE,D2_LOJA,F2_VEND1,D2_SERIE, "
	cQuery2+= " D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT)AS CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ,D2_DOC "
	cQuery2+= " FROM "+ RetSQLname('SD2') + " SD2 JOIN "+ RetSQLname('SF2') + " SF2 "
	cQuery2+= " ON D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL "
	cQuery2+= " AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND F2_ESPECIE = 'RFN' AND SF2.D_E_L_E_T_ = '' "
	cQuery2+= " WHERE D2_GERANF = 'S' AND D2_ESPECIE = 'RFN' "
	cQuery2+= " AND D2_QUANT - (D2_QTDEDEV+D2_QTDEFAT) > 0 "
	cQuery2+= " AND D2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND D2_COD BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery2+= " AND D2_LOCAL BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	cQuery2+= " AND D2_EMISSAO+F2_HORA BETWEEN '" + DTOS(MV_PAR06)+MV_PAR07 + "' AND '" + DTOS(MV_PAR06)+MV_PAR08 + "' "
	cQuery2+= " AND SD2.D_E_L_E_T_ = '') AS tab "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SA1') + " SA1 "
	cQuery2+= " ON A1_COD = D2_CLIENTE AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SA3') + " SA3 "
	cQuery2+= " ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 "
	cQuery2+= " ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = '' "
	
	if MV_PAR13 == 3
		cQuery2+= "	WHERE A3_TIPO BETWEEN '' AND  'Z' "
	ELSE
		cQuery2+= "	WHERE A3_TIPO = '" + cTipoCl + "' "
	ENDIF
	cQuery2+= " GROUP BY A3_TIPO,B1_DESC,B1_UFABRIC,D2_FILIAL,D2_COD,CANTIDAD,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ "
	
	cQuery2+= " ORDER BY D2_LOCALIZ "

	If __CUSERID = '000000'
		aviso("",cQuery2,{'ok'},,,,,.t.)
	EndIf

	cQuery2 := ChangeQuery(cQuery2)

	TCQUERY cQuery2 NEW ALIAS "TMP2"

	IF TMP2->(!EOF()) .AND. TMP2->(!BOF())
		TMP2->(dbGoTop())
	endif

	oReport:SetMeter(TMP2->(RecCount()))
	nValMerc := 0
	i:=0

	nTotSu = 0
	nTotDes = 0
	nTotNet = 0
	nTotNetBs = 0

	While TMP2->(!Eof())
		aDados[AFILIAL] :=  ALLTRIM(TMP2->D2_FILIAL)
		aDados[ACOD] :=   TMP2->D2_COD
		aDados[ADESC] := TMP2->B1_DESC
		aDados[AFABRIC] :=    TMP2->B1_UFABRIC
		aDados[ATIPOCL] := TMP2->A3_TIPO
		aDados[ACANTI] := ALLTRIM(TRANSFORM((TMP2->CANTIDAD)	,"@E 999,999,999"))
		aDados[ALLOCAL] :=   TMP2->D2_LOCAL
		aDados[ALOTEC] := TMP2->D2_LOTECTL
		aDados[ADTVALID] := STOD(TMP2->D2_DTVALID)
		aDados[ALOCLIZ] := TMP2->D2_LOCALIZ

		/*aDados[ALOCLIZ] := TMP2->F2_VALMERC
		aDados[ATOTDES] := TMP2->F2_DESCONT
		aDados[AVTANET] := ALLTRIM(TRANSFORM((TMP2->F2_NETO)	,"@E 999,999,999.99"))
		aDados[AVTANETBS] := ALLTRIM(TRANSFORM((TMP2->F2_NETO2) ,"@E 999,999,999.99"))*/

		/*nTotSu +=	TMP2->F2_VALMERC
		nTotDes += TMP2->F2_DESCONT
		nTotNet += TMP2->F2_NETO
		nTotNetBs += TMP2->F2_NETO2*/

		oSection2:PrintLine()
		aFill(aDados,nil)

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

	End
	nRow := oReport:Row()
	//oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)

	//oReport:SkipLine()

	/*aDados[AVEND] := "TOTAL GENERAL : "
	aDados[ALOCLIZ] := nTotSu
	aDados[ATOTDES] := nTotDes
	aDados[AVTANET] := ALLTRIM(TRANSFORM((nTotNet),"@E 9,999,999.99"))
	aDados[AVTANETBS] := ALLTRIM(TRANSFORM((nTotNetBs),"@E 9,999,999.99"))*/

	//oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()
	oReport:IncMeter()

	oSection2:Finish()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga indice ou consulta(Query)                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De sucursal ?","De sucursal ?","De sucursal ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""  ,"" ,""  ,""   ,"","")
	xPutSx1(cPerg,"02","A Sucursal ?","A Sucursal ?","A Sucursal ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De fecha dia 1?","De fecha dia 1?","De fecha dia 1?", "mv_ch3","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","De Hora ?","De Hora ?","De Hora ?", "mv_ch7","C",5,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","A Hora ?","A Hora ?","A Hora	 ?", "mv_ch8","C",5,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","De fecha dia 2?","De fecha dia 2?","De fecha dia 2?", "mv_ch3","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De Hora ?","De Hora ?","De Hora ?",  "mv_ch7","C",5,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A Hora ?","A Hora ?","A Hora	 ?",  "mv_ch8","C",5,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De Producto?","De Producto ?","De Producto ?",  "mv_ch5","C",6,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A Producto ?","A Producto ?","A Producto ?",  "mv_ch6","C",6,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De Deposito ?","De Deposito ?","De Deposito ?", "mv_ch7","C",2,0,0,"G","","","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A Deposito ?","A Deposito ?","A Deposito	 ?",  "mv_ch8","C",2,0,0,"G","","","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"13","Tipo de cliente ?" , "Tipo de cliente ?" ,"Tipo de cliente ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par13","Ciudad","Ciudad","Ciudad","","Provincia","Provincia","Provincia","Todos","Todos","Todos")

return

static Function quitZero(cTexto)
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

	While lContinua

		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) == 0
			lContinua := .f.
		EndIf

		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)

Return cRetorno