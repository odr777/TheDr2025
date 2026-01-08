#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE AUCCC		1
#DEFINE AFECHA		2
#DEFINE ADOC  		3
#DEFINE ASERIE		4
#DEFINE APEDIDO		5
#DEFINE ACODCLI		6
#DEFINE ACLIENTE 	7
#DEFINE ALOJA		8
#DEFINE ATC			9
#DEFINE AVEND		10
#DEFINE ADPOSTO		11
#DEFINE ACONDPA		12
#DEFINE AVENCTO 	13
#DEFINE ATOTVE		14
#DEFINE ATOTDES		15
#DEFINE AVTANET		16
#DEFINE AVTANETBS	17
#DEFINE AUSUARIO	18

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ NFEMDIA  º Autor ³ Erick Etcheverry 	   º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ REPORTE facturas diarias	 	 				  	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NFEMDIA()
	Local oReport
	Local cPerg := "NFEMDIA"
	If FindFunction("TRepInUse") .And. TRepInUse()
		//	pergunte("RGtoImport",.T.)
		CriaSX1(cPerg)	// Si no esta creada la crea

		Pergunte(cPerg,.f.)

		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Return Nil

Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cPerg
	cPerg := "NFEMDIA"

	oReport := TReport():New("NFEMDIA","Resumen Facturas Emitidas en Fecha",cPerg,{|oReport| ReportPrint(oReport)},;
	"Este programa tiene como objetivo imprimir las facturas emitidas por fecha",,,,,,,0.5)

	//oReport:SetPortrait(.T.)
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection2 := TRSection():New(oReport,"EMISION DE FACTURAS DIARIA",,)

	TRCell():New(oSection2,"F2_CC","SA1","C.C.	","",6)
	//TRCell():New(oSectDad, "XX_GRUPO", "",        "Grupo",, 003, ,,,,,,/*nColSpace*/,,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSection2,"F2_EMISSAO","SF2","Fecha",PesqPict("SF2","F2_EMISSAO"),10,,,,,,,,,,,)
	TRCell():New(oSection2,"F2_DOC","SF2","Factura","",18)
	TRCell():New(oSection2,"F2_SERIE","SF2","Serie","",3)
	TRCell():New(oSection2,"F2_PEDIDO","SF2","Pedido","",6)
	TRCell():New(oSection2,"F2_CLIENTE","SF2","CodCli","",6)
	TRCell():New(oSection2,"F2_NOME","SF2","Cliente","",30)
	TRCell():New(oSection2,"F2_LOJA","SF2","Tnda","",2)
	TRCell():New(oSection2,"F2_TXMOEDA","SF2","TC","@E 9,999,999.99",6)
	TRCell():New(oSection2,"F2_VEND","SF2","Vendedor","",20)
	TRCell():New(oSection2,"F2_LOCAL","SF2","Depsto","",2)
	TRCell():New(oSection2,"F2_COND","SF2","CondPa","",	6)
	TRCell():New(oSection2,"F2_VENCTO","SF2","Vencto",PesqPict("SF2","F2_EMISSAO"),10)
	TRCell():New(oSection2,"F2_VALMERC","SF2","TotVt($)",,14)
	TRCell():New(oSection2,"F2_DESCONT","SF2","Dcto($)",,14)
	TRCell():New(oSection2,"F2_NETO","SF2","VtaNet($)",,14)
	TRCell():New(oSection2,"F2_NETO2","SF2"   ,"VtaNet(Bs)",,14)
	TRCell():New(oSection2,"F2_USRREG","SF2"   ,"Usuario",,15)

	//TRCell():New(oSection2,"F2_NETO2","SF2","TOTAL PESO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	/*TRCell():New(oSection2,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection2,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection2,"F1_TXMOEDA","SF1","T CAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)*/

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[18]

	oSection2:Cell("F2_CC"):SetBlock( { || aDados[AUCCC] })
	oSection2:Cell("F2_EMISSAO"):SetBlock( { || aDados[AFECHA] })
	oSection2:Cell("F2_DOC"):SetBlock( { || aDados[ADOC] })
	oSection2:Cell("F2_SERIE"):SetBlock( { || aDados[ASERIE] })
	oSection2:Cell("F2_PEDIDO"):SetBlock( { || aDados[APEDIDO] })
	oSection2:Cell("F2_CLIENTE"):SetBlock( { || aDados[ACODCLI] })
	oSection2:Cell("F2_NOME"):SetBlock( { || aDados[ACLIENTE] })
	oSection2:Cell("F2_LOJA"):SetBlock( { || aDados[ALOJA] })
	oSection2:Cell("F2_TXMOEDA"):SetBlock( { || aDados[ATC] })
	oSection2:Cell("F2_VEND"):SetBlock( { || aDados[AVEND] })
	oSection2:Cell("F2_LOCAL"):SetBlock( { || aDados[ADPOSTO] })
	oSection2:Cell("F2_COND"):SetBlock( { || aDados[ACONDPA] })
	oSection2:Cell("F2_VENCTO"):SetBlock( { || aDados[AVENCTO] })
	oSection2:Cell("F2_VALMERC"):SetBlock( { || aDados[ATOTVE] })
	oSection2:Cell("F2_DESCONT"):SetBlock( { || aDados[ATOTDES] })
	oSection2:Cell("F2_NETO"):SetBlock( { || aDados[AVTANET] })
	oSection2:Cell("F2_NETO2"):SetBlock( { || aDados[AVTANETBS] })
	oSection2:Cell("F2_USRREG"):SetBlock( { || aDados[AUSUARIO] })

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	cQuery2:= " SELECT A1_UCCC F2_UCCC,F2_EMISSAO,F2_DOC,F2_SERIE,D2_PEDIDO F2_PEDIDO,F2_CLIENTE,A1_NOME F2_NOME,F2_LOJA,"
	cQuery2+= " F2_TXMOEDA,A3_NOME F2_VEND,D2_LOCAL F2_LOCAL,E4_DESCRI F2_COND,MAX(E1_VENCTO)F2_VENCTO,F2_MOEDA, "
	cQuery2+= " CASE F2_MOEDA WHEN 1 THEN F2_VALMERC/M2_MOEDA2 WHEN 2 THEN F2_VALMERC END AS F2_VALMERC, "
	cQuery2+= " CASE F2_MOEDA WHEN 1 THEN F2_DESCONT/M2_MOEDA2 WHEN 2 THEN F2_DESCONT END AS F2_DESCONT, "
	cQuery2+= " CASE F2_MOEDA WHEN 1 THEN (F2_VALMERC-F2_DESCONT)/M2_MOEDA2 WHEN 2 THEN (F2_VALMERC-F2_DESCONT) END AS F2_NETO, "
	cQuery2+= " CASE F2_MOEDA WHEN 1 THEN F2_VALMERC-F2_DESCONT WHEN 2 THEN (F2_VALMERC-F2_DESCONT)*M2_MOEDA2 END AS F2_NETO2,F2_MOEDA,M2_MOEDA2,F2_USRREG "
	cQuery2+= " FROM "+ RetSQLname('SF2') + " SF2 LEFT JOIN "+ RetSQLname('SA1') + " SA1 "
	cQuery2+= " ON A1_COD = F2_CLIENTE AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SA3') + " SA3 ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SE4') + " SE4 ON E4_CODIGO = F2_COND AND SE4.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SE1') + " SE1 "
	cQuery2+= " ON E1_NUM = F2_DOC AND F2_CLIENTE = E1_CLIENTE AND F2_LOJA = E1_LOJA AND E1_PREFIXO = F2_SERIE AND SE1.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SM2') + " SM2 ON M2_DATA = F2_EMISSAO AND SM2.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SD2') + " SD2 "
	cQuery2+= " ON D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL AND D2_ITEM = '01' AND D2_CLIENTE = F2_CLIENTE AND D2_SERIE = F2_SERIE "
	cQuery2+= " AND SD2.D_E_L_E_T_ = '' WHERE F2_DOC BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery2+= " AND F2_ESPECIE = 'NF' AND SF2.D_E_L_E_T_ = '' "
	cQuery2+= " AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery2+= " AND F2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND F2_SERIE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery2+= " AND F2_COND BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery2+= " AND F2_USRREG BETWEEN '" + UPPER(MV_PAR11) + "' AND '" + UPPER(MV_PAR12) + "' "
	cQuery2+= " GROUP BY A1_UCCC,F2_EMISSAO,F2_DOC,F2_SERIE,D2_PEDIDO,F2_CLIENTE,A1_NOME,F2_LOJA, "
	cQuery2+= " F2_TXMOEDA,F2_VEND1,A3_NOME,D2_LOCAL,E4_DESCRI,F2_VENCTO,F2_VALMERC,F2_DESCONT,F2_MOEDA,M2_MOEDA2,F2_USRREG "
	cQuery2+= " ORDER BY SF2.F2_DOC "

	If __CUSERID = '000000'
		//		aviso("",cQuery2,{'ok'},,,,,.t.)
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

	While TMP2->(!Eof())

		ntotValaux := TMP2->F2_VALMERC
		nDescont :=  TMP2->F2_DESCONT
		nNETOaux := TMP2->F2_NETO
		nF2_NETO := (nNETOaux + nDescont)
		nF2_VALMERC := (ntotValaux + nDescont)
		nTotalBS := xMoeda(nF2_NETO,2,1,DATE(),2,0)

		aDados[AUCCC] :=  TMP2->F2_UCCC
		aDados[AFECHA] := STOD(TMP2->F2_EMISSAO)
		aDados[ADOC] :=   PADL(quitZero(TMP2->F2_DOC),4,CHR(32))
		aDados[ASERIE] := TMP2->F2_SERIE
		aDados[APEDIDO] :=    TMP2->F2_PEDIDO
		aDados[ACODCLI] :=    TMP2->F2_CLIENTE
		aDados[ACLIENTE] :=    TMP2->F2_NOME
		aDados[ALOJA] := TMP2->F2_LOJA
		aDados[ATC] := TMP2->F2_TXMOEDA
		aDados[AVEND] :=   TMP2->F2_VEND
		aDados[ADPOSTO] := TMP2->F2_LOCAL
		aDados[ACONDPA] := TMP2->F2_COND
		aDados[AVENCTO] := STOD(TMP2->F2_VENCTO)
		aDados[ATOTVE] := nF2_VALMERC
		aDados[ATOTDES] := nDescont
		aDados[AVTANET] := ALLTRIM(TRANSFORM( nF2_NETO ,"@E 999,999,999.99"))
		aDados[AVTANETBS] := ALLTRIM(TRANSFORM(nTotalBS ,"@E 999,999,999.99"))
		aDados[AUSUARIO] := ALLTRIM(TMP2->F2_USRREG)

		nTotSu +=	nF2_VALMERC
		nTotDes += nDescont
		nTotNet += nF2_NETO
		nTotNetBs += nTotalBS

		oSection2:PrintLine()
		aFill(aDados,nil)

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

	End
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)

	oReport:SkipLine()

	aDados[AVEND] := "TOTAL GENERAL : "
	aDados[ATOTVE] := nTotSu
	aDados[ATOTDES] := nTotDes
	aDados[AVTANET] := ALLTRIM(TRANSFORM((nTotNet),"@E 9,999,999.99"))
	aDados[AVTANETBS] := ALLTRIM(TRANSFORM((nTotNetBs),"@E 9,999,999.99"))

	oSection2:PrintLine()
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

	xPutSx1(cPerg,"01","De sucursal Origen ?","De sucursal Origen ?","De sucursal Origen ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Sucursal Destino ?","A Sucursal Destino ?","A Sucursal Destino ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Nro. Documento ?","De Nro. Documento ?","De Nro. Documento ?",         "mv_ch5","C",18,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Nro. Documento ?","A Nro. Documento ?","A Nro. Documento ?",         "mv_ch6","C",18,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De serie ?","De serie ?","De serie ?",         "mv_ch7","C",3,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A serie ?","A serie ?","A serie ?",         "mv_ch8","C",3,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De condicion de pago ?","De condicion de pago ?","De condicion de pago ?",         "mv_ch8","C",3,0,0,"G","","SE402","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A condicion de pago ?","A condicion de pago ?","A condicion de pago ?",         "mv_ch8","C",3,0,0,"G","","SE402","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De usuario ?","De usuario ?","De usuario ?",         "mv_ch8","C",15,0,0,"G","","US3","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A usuario ?","A usuario ?","A usuario ?",         "mv_ch8","C",15,0,0,"G","","US3","","","mv_par12",""       ,""            ,""        ,""     ,"","")

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

Return cRetorno