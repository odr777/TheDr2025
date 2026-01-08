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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ IMGAPREV  º Autor ³ Erick Etcheverry 	   º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ REPORTE facturas diarias	 	 				  	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IMGAPREV()
	Local oReport
	Local cPerg := "IMGAPREV"

	CriaSX1(cPerg) 

	if(funname() == "MATA143")
		AjustaSx1()
		Pergunte("IMGAPREV",.f.)
	else	
		Pergunte("IMGAPREV",.t.)
	endif

	If FindFunction("TRepInUse") .And. TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
	
Return Nil
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cPerg
	cPerg := "IMGAPREV"
	oReport := TReport():New("IMGAPREV","Gastos Previos de Importación",cPerg,{|oReport| ReportPrint(oReport)},;
		"Este programa tiene como objetivo imprimir los Gastos Previos de Importación")
	oReport:ShowParamPage()
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7
	pergunte(cPerg,.F.)
	oSection2 := TRSection():New(oReport,"Gastos previos de importacion",,)
	TRCell():New(oSection2,"A_IMPORT_PRE","SA1","Importacion","",74)
	TRCell():New(oSection2,"A_PROVEEDOR","SF2","Proveedor",,60)
	TRCell():New(oSection2,"A_DOC","SF2","Factura","",18)
	TRCell():New(oSection2,"A_COSTOBS","SF2","Costo Bolivianos Bs",PesqPict("SF1","F1_VALMERC"),TamSX3("F1_VALMERC")[1])
	TRCell():New(oSection2,"A_COSTOSUS","SF1","Costo Dolares $us",PesqPict("SF1","F1_VALMERC"),TamSX3("F1_VALMERC")[1])
	TRCell():New(oSection2,"A_FLAGRA","SF1","Gen. Despacho","",2)
	/*TRCell():New(oSection2,"F2_CLIENTE","SF2","CodCli","",6)
	TRCell():New(oSection2,"F2_NOME","SF2","Cliente","",30)
	TRCell():New(oSection2,"F2_LOJA","SF2","Tnda","",2)
	TRCell():New(oSection2,"F2_TXMOEDA","SF2","TC",PesqPict("SF2","F2_TXMOEDA"),TamSX3("F2_TXMOEDA")[1])
	TRCell():New(oSection2,"F2_VEND","SF2","Vendedor","",20)
	TRCell():New(oSection2,"F2_LOCAL","SF2","Depsto","",2)
	TRCell():New(oSection2,"F2_COND","SF2","CondPa","",	3)
	TRCell():New(oSection2,"F2_VENCTO","SF2","Vencto",PesqPict("SF2","F2_EMISSAO"),TamSX3("F2_EMISSAO")[1])
	TRCell():New(oSection2,"F2_VALMERC","SF2","TotVt($)",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])
	TRCell():New(oSection2,"F2_DESCONT","SF2","Dcto($)",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])
	TRCell():New(oSection2,"F2_NETO","SF2","VtaNet($)",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])
	TRCell():New(oSection2,"F2_NETO2","SF2"   ,"VtaNet(Bs)",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])*/
	//TRCell():New(oSection2,"F2_NETO2","SF2","TOTAL PESO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	/*TRCell():New(oSection2,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection2,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection2,"F1_TXMOEDA","SF1","TCAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)*/
Return oReport
Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[17]
	private cDoc
	PRIVATE cProv
	oSection2:Cell("A_IMPORT_PRE"):SetBlock( { || aDados[AUCCC] })
	oSection2:Cell("A_PROVEEDOR"):SetBlock( { || aDados[AFECHA] })
	oSection2:Cell("A_DOC"):SetBlock( { || aDados[ADOC] })
	oSection2:Cell("A_COSTOBS"):SetBlock( { || aDados[ASERIE] })
	oSection2:Cell("A_COSTOSUS"):SetBlock( { || aDados[APEDIDO] })
	oSection2:Cell("A_FLAGRA"):SetBlock( { || aDados[ACODCLI] }) 
	
	// *************** oSection2 **********************

	oSection2:Init()
	aFill(aDados,nil)
	cQuery2:= " SELECT F1_UFLAGRA,F1_FILIAL,F1_UHAWB A_IMPORT_PRE,F1_TIPODOC,F1_DOC A_DOC,F1_SERIE "
	cQuery2+= " A_SERIE,F1_FORNECE A_PROV,F1_LOJA,A2_NOME A_PROVEEDOR,F1_EMISSAO,F1_VALMERC,F1_VALBRUT,F1_ESPECIE,F1_MOEDA, "
	cQuery2+= " F1_TXMOEDA,F1_USRREG,D1_FILIAL,D1_PEDIDO,D1_ITEMPC,D1_DOC,D1_SERIE,D1_ITEM,D1_COD,B1_ESPECIF, "
	cQuery2+= " D1_LOCAL,D1_UM,D1_QUANT,D1_CUSTO A_COSTOBS,D1_CUSTO2 A_COSTOSUS,ROUND(ISNULL((D1_TOTAL + D1_VALFRE + D1_SEGURO + D1_DESPESA) / NULLIF(D1_QUANT,0), 0),2) D1_VUNIT, "
	cQuery2+= " D1_TOTAL + D1_VALFRE + D1_SEGURO + D1_DESPESA D1_TOTAL,D1_FORNECE,D1_EMISSAO,D1_NFORI,D1_SERIORI,D1_PESO, "
	cQuery2+= " (SELECT MAX(SA2.A2_NOME) A2_NOME_EXT FROM DBB010 DBB, SA2010 SA2 WHERE DBB.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' ' AND DBB.DBB_FORNEC = SA2.A2_COD AND DBB_HAWB = F1_UHAWB AND DBB.DBB_TIPONF IN('5', '8')) A2_NOME_EXT "
	cQuery2+= " FROM "+ RetSQLname('SF1') + " SF1 JOIN "+ RetSQLname('SD1') + " SD1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC "
	cQuery2+= " AND F1_SERIE = D1_SERIE AND D1_COD LIKE 'GI%' AND SD1.D_E_L_E_T_ != '*' LEFT JOIN SA2010 SA2 ON F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA "
	cQuery2+= " AND SA2.D_E_L_E_T_ != '*' LEFT JOIN "+ RetSQLname('SB1') + " SB1 ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ != '*' "
	cQuery2+= " WHERE F1_ESPECIE = 'NF' AND SF1.D_E_L_E_T_ != '*' "
	cQuery2+= " AND F1_UHAWB BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND F1_UHAWB != ''"
	cQuery2+= " AND F1_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' ORDER BY F1_UHAWB,D1_FORNECE,F1_DOC"

	/*
	cQuery2+= " AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery2+= " AND F2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND F2_SERIE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery2+= " GROUP BY A1_UCCC,F2_EMISSAO,F2_DOC,F2_SERIE,D2_PEDIDO,F2_CLIENTE,A1_NOME,F2_LOJA, "
	cQuery2+= " F2_TXMOEDA,F2_VEND1,A3_NOME,D2_LOCAL,E4_DESCRI,F2_VENCTO,F2_VALMERC,F2_DESCONT,F2_MOEDA,M2_MOEDA2 "
	cQuery2+= " ORDER BY SF2.F2_DOC "
	*/

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
	cDoc := TMP2->A_IMPORT_PRE
	cProv := TMP2->D1_FORNECE
	aResp := getTotPolz(TMP2->A_IMPORT_PRE)///total por poliza
	nTotSu= nTotSu + aResp[1]
	nTotDes = nTotDes+ aResp[2]
	aDados[AUCCC] := alltrim(TMP2->A_IMPORT_PRE) + " - " + TMP2->A2_NOME_EXT
	aDados[AFECHA] := ""
	aDados[ADOC] :=   ""
	aDados[ASERIE] := aResp[1]
	aDados[APEDIDO] := aResp[2]
	aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
	oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()
	aResoSub := getSubPolz(A_IMPORT_PRE,TMP2->D1_FORNECE)///SUB PROVEEDOR
	aDados[AUCCC] := ""
	aDados[AFECHA] := TMP2->A_PROVEEDOR
	aDados[ADOC] :=   ""
	aDados[ASERIE] := aResoSub[1]
	aDados[APEDIDO] := aResoSub[2]
	aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
	oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()
	While TMP2->(!Eof())
		if TMP2->A_IMPORT_PRE != cDoc //CAMBIA DE DOCUMENTO
			aResp := getTotPolz(TMP2->A_IMPORT_PRE)///total por poliza
			nTotSu= nTotSu + aResp[1]
			nTotDes = nTotDes+ aResp[2]
			aDados[AUCCC] := alltrim(TMP2->A_IMPORT_PRE) + " - " + TMP2->A2_NOME_EXT
			aDados[AFECHA] := ""
			aDados[ADOC] :=   ""
			aDados[ASERIE] := aResp[1]
			aDados[APEDIDO] := aResp[2]
			aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
			oSection2:PrintLine()
			aFill(aDados,nil)
			cDoc = TMP2->A_IMPORT_PRE
			oReport:SkipLine()
			/////////PROVEEDOR
			aResoSub := getSubPolz(A_IMPORT_PRE,TMP2->D1_FORNECE)///SUB PROVEEDOR
			aDados[AUCCC] := ""
			aDados[AFECHA] := TMP2->A_PROVEEDOR
			aDados[ADOC] :=   ""
			aDados[ASERIE] := aResoSub[1]
			aDados[APEDIDO] := aResoSub[2]
			aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
			oSection2:PrintLine()
			aFill(aDados,nil)
			cProv = TMP2->D1_FORNECE
			oReport:SkipLine()
			aDados[AUCCC] := ""
			aDados[AFECHA] := ""
			aDados[ADOC] :=   TMP2->A_DOC
			aDados[ASERIE] := TMP2->A_COSTOBS
			aDados[APEDIDO] := TMP2->A_COSTOSUS
			aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
			oSection2:PrintLine()
			aFill(aDados,nil)
			oReport:SkipLine()
		ELSE
			if TMP2->D1_FORNECE != cProv ///cambio proveedor
				aResoSub := getSubPolz(A_IMPORT_PRE,TMP2->D1_FORNECE)///SUB PROVEEDOR
				aDados[AUCCC] := ""
				aDados[AFECHA] := TMP2->A_PROVEEDOR
				aDados[ADOC] :=   ""
				aDados[ASERIE] := aResoSub[1]
				aDados[APEDIDO] := aResoSub[2]
				aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
				cProv = TMP2->D1_FORNECE
				oSection2:PrintLine()
				aFill(aDados,nil)
				oReport:SkipLine()
				aDados[AUCCC] := ""
				aDados[AFECHA] := ""
				aDados[ADOC] :=   TMP2->A_DOC
				aDados[ASERIE] := TMP2->A_COSTOBS
				aDados[APEDIDO] := TMP2->A_COSTOSUS
				aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
				oSection2:PrintLine()
				aFill(aDados,nil)
				oReport:SkipLine()
			else
				aDados[AUCCC] := ""
				aDados[AFECHA] := ""
				aDados[ADOC] :=   TMP2->A_DOC
				aDados[ASERIE] := TMP2->A_COSTOBS
				aDados[APEDIDO] := TMP2->A_COSTOSUS
				aDados[ACODCLI] := IIF(TMP2->F1_UFLAGRA == "S","SI","NO")
				oSection2:PrintLine()
				aFill(aDados,nil)
				oReport:SkipLine()
			endif
		endif
		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo
	Enddo
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)
	oReport:SkipLine()
	aDados[AUCCC] := "TOTAL GENERAL : "
	aDados[ASERIE] := nTotSu
	aDados[APEDIDO] := nTotDes
	aDados[ACODCLI] := ""
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
	xPutSx1(cPerg,"01","Despacho inicial ?","Despacho inicial ?","Despacho inicial ?","mv_ch1","C",20,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","Despacho final ?","Despacho final ?","Despacho final ?","mv_ch2","C",20,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	/*xPutSx1(cPerg,"05","De Nro. Documento ?","De Nro. Documento ?","De Nro. Documento ?",         "mv_ch5","C",18,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Nro. Documento ?","A Nro. Documento ?","A Nro. Documento ?",         "mv_ch6","C",18,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De serie ?","De serie ?","De serie ?",         "mv_ch7","C",3,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A serie ?","A serie ?","A serie ?",         "mv_ch8","C",3,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	*/
return
static Function getTotPolz(cPoliz)
	Local aArea := GetArea()
	Local aResposta := {}
	//Construindo a consulta
	BeginSql Alias "SQL_SB1"
		//COLUMN F3_ENTRADA AS DATE //Deve se usar isso para transformar o campo em data
		SELECT
		F1_FILIAL,
		F1_UHAWB A_IMPORT_PRE,
		SUM(D1_CUSTO) A_COSTOBS,
		SUM(D1_CUSTO2) A_COSTOSUS
		FROM
		SF1010 SF1
		JOIN
		SD1010 SD1
		ON F1_FILIAL = D1_FILIAL
		AND F1_DOC = D1_DOC
		AND F1_SERIE = D1_SERIE
		AND D1_COD LIKE 'GI%'
		AND SD1.D_E_L_E_T_ != '*'
		LEFT JOIN
		SA2010 SA2
		ON F1_FORNECE = A2_COD
		AND F1_LOJA = A2_LOJA
		AND SA2.D_E_L_E_T_ != '*'
		LEFT JOIN
		SB1010 SB1
		ON D1_COD = B1_COD
		AND SB1.D_E_L_E_T_ != '*'
		WHERE
		F1_ESPECIE = 'NF'
		AND SF1.D_E_L_E_T_ != '*'
		AND F1_UHAWB = %Exp:cPoliz%
		GROUP BY F1_FILIAL,F1_UHAWB
		ORDER BY F1_UHAWB
	EndSql
	aadd(aResposta,SQL_SB1->A_COSTOBS)
	aadd(aResposta,SQL_SB1->A_COSTOSUS)
	SQL_SB1->(DbCloseArea())
	RestArea(aArea)
Return aResposta

static Function getSubPolz(cPoliz,cForn)
	Local aArea := GetArea()
	Local aResposta := {}
	//Construindo a consulta
	BeginSql Alias "SQL_SD1"
		//COLUMN F3_ENTRADA AS DATE //Deve se usar isso para transformar o campo em data
		SELECT
		D1_FORNECE,
		SUM(D1_CUSTO) A_COSTOBS,
		SUM(D1_CUSTO2) A_COSTOSUS
		FROM
		SF1010 SF1
		JOIN
		SD1010 SD1
		ON F1_FILIAL = D1_FILIAL
		AND F1_DOC = D1_DOC
		AND F1_SERIE = D1_SERIE
		AND SD1.D_E_L_E_T_ != '*'
		AND D1_FORNECE = %Exp:cForn%
		AND D1_COD LIKE 'GI%'
		LEFT JOIN
		SA2010 SA2
		ON F1_FORNECE = A2_COD
		AND F1_LOJA = A2_LOJA
		AND SA2.D_E_L_E_T_ != '*'
		LEFT JOIN
		SB1010 SB1
		ON D1_COD = B1_COD
		AND SB1.D_E_L_E_T_ != '*'
		WHERE
		F1_ESPECIE = 'NF'
		AND SF1.D_E_L_E_T_ != '*'
		AND F1_UHAWB = %Exp:cPoliz%
		GROUP BY D1_FORNECE
	EndSql
	aadd(aResposta,SQL_SD1->A_COSTOBS)
	aadd(aResposta,SQL_SD1->A_COSTOSUS)
	SQL_SD1->(DbCloseArea())
	RestArea(aArea)
Return aResposta

static Function AjustaSx1() // posiciona valores para query preguntas
//	alert("Pasa AjustaSx1")
	cPerg :="IMGAPREV  "
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

	If SX1->(DbSeek(cPerg+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := dtoc(Ctod("//"))
		SX1->(MsUnlock())
	END

	If SX1->(DbSeek(cPerg+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := dtoc(Ctod("31/12/2999"))
		SX1->(MsUnlock())
	END
	
return nil
