#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE ADTDIG 1
#DEFINE ACCUS  2
#DEFINE ATESD  3
#DEFINE ASERIE 4
#DEFINE ABENEF 5
#DEFINE AHIST 6
#DEFINE ACOMP 7
#DEFINE ANUM 8
#DEFINE AMOED 9
#DEFINE AVALUE 10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MOVCCHE  º Autor ³ Erick Etcheverry 	   º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ REPORTE facturas diarias	 	 				  	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MOVCCHE()
	Local oReport
	Local cPerg := "MOVCCHE"
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
	cPerg := "MOVCCHE"

	oReport := TReport():New("MOVCCHE","Movimientos Caja Chica",cPerg,{|oReport| ReportPrint(oReport)},;
	"Este programa tiene como objetivo imprimir los movimientos de caja chica")

	oReport:ShowParamPage()
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	pergunte(cPerg,.F.)

	oSection2 := TRSection():New(oReport,"MOVIMIENTOS CAJA CHICA",,)
	TRCell():New(oSection2,"EU_DTDIGIT","SEU","Fecha",PesqPict("SF2","F2_EMISSAO"),10)
	TRCell():New(oSection2,"D1_CC","SD1","C Costo","",11)
	TRCell():New(oSection2,"D1_TES","SD1","TES","",3)
	TRCell():New(oSection2,"EU_SERIE","SEU","Serie","",3)
	TRCell():New(oSection2,"EU_BENEF","SEU","Beneficiario","",40)
	TRCell():New(oSection2,"EU_HISTOR","SEU","Detalle","",40)
	TRCell():New(oSection2,"EU_NRCOMP","SEU","Cmpte","",18)
	TRCell():New(oSection2,"EU_NUM","SEU","Nro Int","",10)
	TRCell():New(oSection2,"EU_MOEDA","SEU","Mon","",2)
	TRCell():New(oSection2,"EU_VALOR","SEU","Valor",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])

	/*TRCell():New(oSection2,"F2_DESCONT","SF2","Dcto($)",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])
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

	oSection2:Cell("EU_DTDIGIT"):SetBlock( { || aDados[ADTDIG] })
	oSection2:Cell("D1_CC"):SetBlock( { || aDados[ACCUS] })
	oSection2:Cell("D1_TES"):SetBlock( { || aDados[ATESD] })
	oSection2:Cell("EU_SERIE"):SetBlock( { || aDados[ASERIE] })
	oSection2:Cell("EU_BENEF"):SetBlock( { || aDados[ABENEF] })
	oSection2:Cell("EU_HISTOR"):SetBlock( { || aDados[AHIST] })
	oSection2:Cell("EU_NRCOMP"):SetBlock( { || aDados[ACOMP] })
	oSection2:Cell("EU_NUM"):SetBlock( { || aDados[ANUM] })
	oSection2:Cell("EU_MOEDA"):SetBlock( { || aDados[AMOED] })
	oSection2:Cell("EU_VALOR"):SetBlock( { || aDados[AVALUE] })

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	/*
	SELECT EU_CAIXA,ET_NOME,EU_DTDIGIT,
	(SELECT MAX(D1_TES)
	FROM SD1010 SD1
	WHERE D1_FILIAL = EU_FILIAL AND EU_SERCOMP = D1_SERIE AND  EU_NRCOMP= D1_DOC
	AND D1_FORNECE = EU_FORNECE AND EU_LOJA = D1_LOJA AND D1_TES BETWEEN '' AND 'ZZZ'
	AND D1_CC BETWEEN '' AND 'ZZZZZZ' AND SD1.D_E_L_E_T_ = '') D1_TES,
	(SELECT MAX(D1_CC)
	FROM SD1010 SD1
	WHERE D1_FILIAL = EU_FILIAL AND EU_SERCOMP = D1_SERIE AND  EU_NRCOMP= D1_DOC
	AND D1_FORNECE = EU_FORNECE AND EU_LOJA = D1_LOJA AND D1_TES BETWEEN '' AND 'ZZZ'
	AND D1_CC BETWEEN '' AND 'ZZZZZZ' AND SD1.D_E_L_E_T_ = '') D1_CC,
	EU_FILIAL,EU_SERCOMP,EU_BENEF,EU_HISTOR,EU_NRCOMP,EU_NUM,EU_MOEDA,EU_VALOR
	FROM SEU010 SEU
	JOIN SD1010 SD1
	ON D1_FILIAL = EU_FILIAL AND EU_SERCOMP = D1_SERIE AND  EU_NRCOMP= D1_DOC
	AND D1_FORNECE = EU_FORNECE AND EU_LOJA = D1_LOJA AND D1_TES BETWEEN '' AND 'ZZZ'
	AND D1_CC BETWEEN '' AND 'ZZZZZZ' AND SD1.D_E_L_E_T_ = ''
	JOIN SET010 SETT
	ON ET_FILIAL = EU_FILIAL AND ET_CODIGO = EU_CAIXA AND SETT.D_E_L_E_T_ = ''
	WHERE
	EU_CAIXA BETWEEN '' AND 'ZZZ'
	AND EU_DTDIGIT BETWEEN '' AND 'ZZZZZZZZ'
	AND EU_FILIAL BETWEEN '' AND 'ZZZZ'
	AND SEU.D_E_L_E_T_ = ''
	GROUP BY EU_CAIXA,ET_NOME,EU_DTDIGIT,EU_FILIAL,EU_SERCOMP,EU_FORNECE,EU_LOJA,EU_BENEF,EU_HISTOR,EU_NRCOMP,EU_NUM,EU_MOEDA,EU_VALOR
	ORDER BY EU_CAIXA
	*/

	cQuery2:= " SELECT EU_CAIXA,ET_NOME,EU_DTDIGIT, "
	cQuery2+= " (SELECT MAX(D1_TES) "
	cQuery2+= " FROM "+ RetSQLname('SD1') + " SD1  "
	cQuery2+= " WHERE D1_FILIAL = EU_FILIAL AND EU_SERCOMP = D1_SERIE AND  EU_NRCOMP= D1_DOC "
	cQuery2+= " AND D1_FORNECE = EU_FORNECE AND EU_LOJA = D1_LOJA AND D1_TES BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery2+= "	AND D1_CC BETWEEN '' AND 'ZZZZZZ' AND SD1.D_E_L_E_T_ = '') D1_TES, "
	cQuery2+= " (SELECT MAX(D1_CC) "
	cQuery2+= " FROM "+ RetSQLname('SD1') + " SD1  "
	cQuery2+= " WHERE D1_FILIAL = EU_FILIAL AND EU_SERCOMP = D1_SERIE AND  EU_NRCOMP= D1_DOC "
	cQuery2+= " AND D1_FORNECE = EU_FORNECE AND EU_LOJA = D1_LOJA AND D1_CC BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery2+= "	AND D1_CC BETWEEN '' AND 'ZZZZZZ' AND SD1.D_E_L_E_T_ = '') D1_CC, "
	cQuery2+= " EU_FILIAL,EU_SERCOMP,EU_BENEF,EU_HISTOR,EU_NRCOMP,EU_NUM,EU_MOEDA,EU_VALOR "
	cQuery2+= " FROM "+ RetSQLname('SEU') + " SEU  "
	cQuery2+= " JOIN "+ RetSQLname('SET') + " SETT  "
	cQuery2+= " ON ET_FILIAL = EU_FILIAL AND ET_CODIGO = EU_CAIXA AND SETT.D_E_L_E_T_ = '' "
	cQuery2+= " WHERE "
	cQuery2+= " SEU.D_E_L_E_T_ = '' "
	cQuery2+= " AND EU_CAIXA BETWEEN  '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND EU_DTDIGIT BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
	cQuery2+= " AND EU_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery2+= " GROUP BY EU_CAIXA,ET_NOME,EU_DTDIGIT,EU_FILIAL,EU_SERCOMP,EU_FORNECE,EU_LOJA,EU_SERIE,EU_BENEF,EU_HISTOR,EU_NRCOMP,EU_NUM,EU_MOEDA,EU_VALOR "
	cQuery2+= " ORDER BY EU_CAIXA,EU_FILIAL,EU_NUM "

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
	nTotCaix = 0
	nTotCax := 0

	cCaixa := TMP2->EU_CAIXA
	cFiloal := TMP2->EU_FILIAL

	cFilfin:= ""
	cCaixFin:= ""

	While TMP2->(!Eof())
		if  TMP2->EU_CAIXA != cCaixa //si es otro documento salta de pagina

			aDados[ANUM] := "TOTAL CAJA "+ cCaixa + " : "
			aDados[AVALUE] := nTotCaix
			nRow := oReport:Row()
			oReport:PrintText(Replicate("_",350), nRow, 40) // TOTAL GASTOS DE IMPORTACION)
			oSection2:PrintLine()
			oReport:SkipLine()

			nTotCaix := 0
			cCaixa := TMP2->EU_CAIXA
		endif
		if  TMP2->EU_FILIAL != cFiloal //si es otro documento salta de pagina

			aDados[ANUM] := "TOTAL FILIAL " + cFiloal + " : "
			aDados[AVALUE] := nTotSu
			nRow := oReport:Row()
			oReport:PrintText(Replicate("_",350), nRow, 40) // TOTAL GASTOS DE IMPORTACION)
			oSection2:PrintLine()
			oReport:SkipLine()

			nTotSu := 0
			cFiloal := TMP2->EU_FILIAL
		endif

		nTotCaix += TMP2->EU_VALOR
		nTotSu += TMP2->EU_VALOR
		nTotCax += TMP2->EU_VALOR

		aDados[ADTDIG] :=  STOD(TMP2->EU_DTDIGIT)
		aDados[ACCUS] := TMP2->D1_CC
		aDados[ATESD] :=   TMP2->D1_TES
		aDados[ASERIE] := TMP2->EU_SERCOMP
		aDados[ABENEF] :=    TMP2->EU_BENEF
		aDados[AHIST] :=    TMP2->EU_HISTOR
		aDados[ACOMP] :=    TMP2->EU_NRCOMP
		aDados[ANUM] := TMP2->EU_NUM
		aDados[AMOED] := TMP2->EU_MOEDA
		aDados[AVALUE] :=   TMP2->EU_VALOR

		/*nTotSu +=	aDados[ATOTVE]
		nTotDes += aDados[ATOTDES]
		nTotNet += aDados[AVTANET]
		nTotNetBs += aDados[AVTANETBS]*/

		oSection2:PrintLine()
		aFill(aDados,nil)

		cFilfin:= TMP2->EU_CAIXA
		cCaixFin:= TMP2->EU_FILIAL

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

	End

	aDados[ANUM] := "TOTAL CAJA "+ cCaixFin + " : "
	aDados[AVALUE] := nTotCaix
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",350), nRow, 40) // TOTAL GASTOS DE IMPORTACION)
	oSection2:PrintLine()
	oReport:SkipLine()
	nTotCaix := 0

	aDados[ANUM] := "TOTAL FILIAL " + cFilfin + " : "
	aDados[AVALUE] := nTotSu
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",350), nRow, 40) // TOTAL GASTOS DE IMPORTACION)
	oSection2:PrintLine()
	oReport:SkipLine()
	nTotSu := 0

	aDados[ANUM] := "TOTAL CAJAS : "
	aDados[AVALUE] := nTotCax
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",350), nRow, 40) // TOTAL GASTOS DE IMPORTACION)
	oSection2:PrintLine()
	oReport:SkipLine()

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

	xPutSx1(cPerg,"01","De Caja ?","De Caja ?","De Caja ?","mv_ch1","C",3,0,0,"G","","SET","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Caja ?","A Caja?","A Caja ?","mv_ch2","C",3,0,0,"G","","SET","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De sucursal ?","De sucursal ?","De sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A sucursal ?","A sucursal ?","A sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De TES ?","De TES ?","De TES ?",         "mv_ch3","C",3,0,0,"G","","SF4","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A TES ?","A TES ?","A TES ?",         "mv_ch4","C",3,0,0,"G","","SF4","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"09","De Centro C. ?" , "De Centro C.?" ,"De Centro C. ?" ,"MV_CH9","C",11,0,0,"G","","CTT","","","mv_par09","","","","","","","")
	xPutSX1(cPerg,"10","A Centro C. ?" , "A Centro C.?" ,"A Centro C. ?" ,"MV_CH9","C",11,0,0,"G","","CTT","","","mv_par10","","","","","","","")

return