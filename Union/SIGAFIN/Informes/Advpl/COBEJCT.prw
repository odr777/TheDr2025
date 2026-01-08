#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE ARAZSOC		1
#DEFINE ANRECBO		2
#DEFINE AFECHDI  		3
#DEFINE AUCC		4
#DEFINE ACCOND		5
#DEFINE ASERIF		6
#DEFINE ADCFAC 	7
#DEFINE ATPRECIB		8
#DEFINE ABANCO			9
#DEFINE AVALOR		10
#DEFINE AVALORSUS		11

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ COBEJCT  บ Autor ณ Erick Etcheverry 	   บ Data ณ  28/08/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ REPORTE cobranzas ventas	 	 				  	            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TdeP                                       	            	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function COBEJCT()
	Local oReport
	Local cPerg := "COBEJCT"
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
	cPerg := "COBEJCT"

	oReport := TReport():New("COBEJCT","Cobranzas Ventas",cPerg,{|oReport| ReportPrint(oReport)},;
	"Este programa tiene como objetivo imprimir cobranzas ventas",,,,,,,0.5)

	//oReport:SetPortrait(.T.)
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 9

	oSection2 := TRSection():New(oReport,"COBRANZAS VENTAS",,)

	TRCell():New(oSection2,"EL_CLIORIG","SEL","Razon Social",,30,,,,,,,0,,,,)
	TRCell():New(oSection2,"EL_RECIBO","SEL","Nro. Recibo","",12,,,,,,,0)
	TRCell():New(oSection2,"EL_DTDIGIT","SEL","Fecha",PesqPict("SEL","EL_DTDIGIT"),10,,,,,,,0)
	TRCell():New(oSection2,"A1_UCCC","SEL","CCosto","",6,,,,,,,0)
	TRCell():New(oSection2,"EL_COND","SEL","Cond. Pago","",7,,,,,,,0)
	TRCell():New(oSection2,"EL_PREFIXO","SEL","Serie","",3,,,,,,,0)
	TRCell():New(oSection2,"EL_NUMERO","SEL","Factura","",10,,,,,,,0)
	TRCell():New(oSection2,"EL_TIPO","SEL","TP Recibo","",3,,,,,,,0)
	TRCell():New(oSection2,"EL_BANCO","SEL","Banco","",16,,,,,,,0)
	TRCell():New(oSection2,"EL_VALOR","SEL","Valor USD",PesqPict("SEL","EL_VALOR"),	14,,,"RIGHT",,,,0)
	TRCell():New(oSection2,"EL_VLMOED1","SEL","Valor Bs",PesqPict("SEL","EL_VALOR"),14,,,"RIGHT",,,,0)

	//TRCell():New(oSection2,"F2_NETO2","SF2","TOTAL PESO", PesqPict("SD1","D1_PESO"),TamSX3("D1_PESO")[1],.F.,)
	/*TRCell():New(oSection2,"F1_EMISSAO","SF1","EMISION",PesqPict("SF1","F1_EMISSAO"),10,.F.,)
	TRCell():New(oSection2,"F1_VALMERC","SF1","VAL.MERCADERIA",cPictVal,nTamVal,.F.,)
	TRCell():New(oSection2,"F1_MOEDA","SF1","MONEDA")
	TRCell():New(oSection2,"F1_TXMOEDA","SF1","T CAMBIO",PesqPict("SF1","F1_TXMOEDA"),TamSX3("F1_TXMOEDA")[1],.F.,)*/

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[12]

	//oSection2:Cell("F2_CC"):SetBlock( { || aDados[] })
	oSection2:Cell("EL_CLIORIG"):SetBlock( { || aDados[ARAZSOC] })
	oSection2:Cell("EL_RECIBO"):SetBlock( { || aDados[ANRECBO] })
	oSection2:Cell("EL_DTDIGIT"):SetBlock( { || aDados[AFECHDI] })
	oSection2:Cell("A1_UCCC"):SetBlock( { || aDados[AUCC] })
	oSection2:Cell("EL_COND"):SetBlock( { || aDados[ACCOND] })
	oSection2:Cell("EL_PREFIXO"):SetBlock( { || aDados[ASERIF] })
	oSection2:Cell("EL_NUMERO"):SetBlock( { || aDados[ADCFAC] })
	oSection2:Cell("EL_TIPO"):SetBlock( { || aDados[ATPRECIB] })
	oSection2:Cell("EL_BANCO"):SetBlock( { || aDados[ABANCO] })
	oSection2:Cell("EL_VALOR"):SetBlock( { || aDados[AVALOR] })
	oSection2:Cell("EL_VLMOED1"):SetBlock( { || aDados[AVALORSUS] })

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	/*
	SELECT EL_CLIORIG + '-' +EL_LOJORIG +' '+ A1_UNOMFAC EL_CLIORIG,EL_RECIBO,EL_SERIE,A1_UCCC
	, CASE EL_EMISSAO WHEN EL_DTVCTO THEN CASE EL_TIPO WHEN 'NF' THEN 'CONTADO' ELSE '' END ELSE CASE EL_TIPO WHEN 'NF' THEN 'CREDITO' ELSE '' END END EL_COND_ERICK
	, (	SELECT
	MAX(CASE
	WHEN XSEL.EL_EMISSAO=XSEL.EL_DTVCTO AND (XSEL.EL_TIPODOC = 'TB' OR XSEL.EL_TIPODOC = 'RA')
	THEN 'CONTADO'
	ELSE (CASE 	WHEN XSEL.EL_EMISSAO<>XSEL.EL_DTVCTO AND (XSEL.EL_TIPODOC = 'TB' OR XSEL.EL_TIPODOC = 'RA')
	THEN 'CREDITO' END )
	END ) --AS EL_COND
	FROM SEL010 XSEL
	WHERE XSEL.D_E_L_E_T_ = ' '
	AND XSEL.EL_FILIAL=SEL.EL_FILIAL
	AND XSEL.EL_RECIBO=SEL.EL_RECIBO
	AND XSEL.EL_SERIE=SEL.EL_SERIE) EL_COND
	,EL_DTDIGIT,EL_DTVCTO,EL_SERIE,EL_NUMERO,EL_TIPO,EL_TIPODOC
	,EL_BANCO,EL_AGENCIA,EL_CONTA,EL_VALOR,EL_VLMOED1,EL_MOEDA
	FROM SEL010 SEL
	LEFT JOIN SA1010 SA1 ON A1_COD = EL_CLIORIG AND EL_LOJORIG = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SEL.D_E_L_E_T_ = ''
	AND (EL_TIPODOC IN ('CH ','TF ','EF ','CD ','CC ') OR EL_TIPODOC IN ('TB ') AND EL_TIPO IN ('NF'))
	AND EL_CANCEL = 'F'
	ORDER BY EL_RECIBO,SEL.R_E_C_N_O_ DESC
	*/

	cQuery2:= " SELECT EL_CLIORIG + '-' +EL_LOJORIG +' '+ A1_UNOMFAC EL_CLIORIG,EL_RECIBO,A1_UCCC, "
	cQuery2+= " (SELECT MAX(CASE WHEN XSEL.EL_EMISSAO=XSEL.EL_DTVCTO AND (XSEL.EL_TIPODOC = 'TB' OR XSEL.EL_TIPODOC = 'RA') THEN 'CONTADO' ELSE "
	cQuery2+= " (CASE 	WHEN XSEL.EL_EMISSAO<>XSEL.EL_DTVCTO AND (XSEL.EL_TIPODOC = 'TB' OR XSEL.EL_TIPODOC = 'RA') THEN 'CREDITO' END ) END ) "
	cQuery2+= " FROM "+ RetSQLname('SEL') + " XSEL "
	cQuery2+= " WHERE XSEL.D_E_L_E_T_ = ' ' AND XSEL.EL_FILIAL=SEL.EL_FILIAL AND XSEL.EL_RECIBO=SEL.EL_RECIBO "
	cQuery2+= " AND XSEL.EL_SERIE=SEL.EL_SERIE) EL_COND,EL_DTDIGIT,EL_DTVCTO,EL_SERIE, "
	cQuery2+= " CASE EL_BANCO WHEN '' THEN EL_PREFIXO ELSE '' END EL_PREFIXO , CASE EL_BANCO WHEN '' THEN EL_NUMERO ELSE '' END EL_NUMERO "
	cQuery2+= " ,EL_TIPO,EL_TIPODOC,EL_BANCO,EL_AGENCIA,EL_CONTA,EL_VALOR,EL_VLMOED1,EL_MOEDA,EL_TXMOE02 "
	cQuery2+= " FROM "+ RetSQLname('SEL') + " SEL LEFT JOIN "+ RetSQLname('SA1') + " SA1 "
	cQuery2+= " ON A1_COD = EL_CLIORIG AND EL_LOJORIG = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery2+= " AND A1_UCCC BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "
	cQuery2+= " WHERE SEL.D_E_L_E_T_ = '' " ///F2_DOC BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery2+= " AND (EL_TIPODOC IN ('CH ','TF ','EF ','CD ','CC ') OR EL_TIPODOC IN ('TB ','RA') AND EL_TIPO in ('NF','RA')) "
	cQuery2+= " AND EL_FILIAL = '" + MV_PAR01 + "' AND EL_CANCEL = 'F' "
	//cQuery2+= " AND CASE EL_EMISSAO WHEN EL_DTVCTO THEN '1' ELSE '2' END = '" + cvaltochar(MV_PAR04) + "' "  //1 contado 2 credito
	cQuery2+= " AND EL_DTDIGIT BETWEEN '" + dtos(MV_PAR05) + "' AND '" + dtos(MV_PAR06) + "' "
	cQuery2+= " AND EL_SERIE BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
	cQuery2+= " AND EL_PREFIXO <> 'NCC' "
	if MV_PAR07 == 1
		cQuery2+= " AND EL_BANCO <> '   ' "
	endif
	if MV_PAR07 == 2
		cQuery2+= " AND EL_TIPODOC = 'TB' "
	endif

	if MV_PAR04 <> 3
		cQuery2+= " AND (SELECT MAX(CASE WHEN XSEL.EL_EMISSAO=XSEL.EL_DTVCTO AND (XSEL.EL_TIPODOC = 'TB' OR XSEL.EL_TIPODOC = 'RA') THEN '1' ELSE "
		cQuery2+= " (CASE 	WHEN XSEL.EL_EMISSAO<>XSEL.EL_DTVCTO AND (XSEL.EL_TIPODOC = 'TB' OR XSEL.EL_TIPODOC = 'RA') THEN '2' END ) END ) "
		cQuery2+= " FROM "+ RetSQLname('SEL') + " XSEL "
		cQuery2+= " WHERE XSEL.D_E_L_E_T_ = ' ' AND XSEL.EL_FILIAL=SEL.EL_FILIAL AND XSEL.EL_RECIBO=SEL.EL_RECIBO "
		cQuery2+= " AND XSEL.EL_SERIE=SEL.EL_SERIE) = '" + cvaltochar(MV_PAR04) + "' "
	endif

	cQuery2+= " ORDER BY EL_RECIBO,SEL.R_E_C_N_O_ DESC "

	//aviso("",cQuery2,{'ok'},,,,,.t.)

	cQuery2 := ChangeQuery(cQuery2)

	TCQUERY cQuery2 NEW ALIAS "TMPCOB"

	IF TMPCOB->(!EOF()) .AND. TMPCOB->(!BOF())
		TMPCOB->(dbGoTop())
	end

	oReport:SetMeter(TMPCOB->(RecCount()))

	nTotValor := 0
	nTotValsus := 0
	While TMPCOB->(!Eof())

		aDados[ARAZSOC] :=  ALLTRIM(TMPCOB->EL_CLIORIG)
		aDados[ANRECBO] := ALLTRIM(TMPCOB->EL_SERIE)+" -"+ALLTRIM(TMPCOB->EL_RECIBO)///STOD(TMPCOB->EL_DTDIGIT)
		aDados[AFECHDI] := STOD(TMPCOB->EL_DTDIGIT) // PADL(quitZero(TMPCOB->F2_DOC),4,CHR(32))
		aDados[AUCC] := TMPCOB->A1_UCCC
		aDados[ACCOND] :=    TMPCOB->EL_COND
		aDados[ASERIF] :=    TMPCOB->EL_PREFIXO
		aDados[ADCFAC] := PADL(quitZero(TMPCOB->EL_NUMERO),4,CHR(32))
		aDados[ATPRECIB] := TMPCOB->EL_TIPO
		aDados[ABANCO] := alltrim(TMPCOB->EL_BANCO) + "-"+ alltrim(TMPCOB->EL_AGENCIA)+"-"+alltrim(TMPCOB->EL_CONTA)
		aDados[AVALOR] :=   iif(TMPCOB->EL_MOEDA == "1 ",(TMPCOB->EL_VALOR / TMPCOB->EL_TXMOE02);
		,TMPCOB->EL_VALOR)
		aDados[AVALORSUS] := TMPCOB->EL_VLMOED1

		/*aDados[AVTANET] := ALLTRIM(TRANSFORM( nF2_NETO ,"@E 999,999,999.99"))
		aDados[AVTANETBS] := ALLTRIM(TRANSFORM(nTotalBS ,"@E 999,999,999.99"))*/
		nTotValor+= aDados[AVALOR]

		nTotValsus+= aDados[AVALORSUS]

		oSection2:PrintLine()
		aFill(aDados,nil)

		TMPCOB->(DbSkip())       // Avanza el puntero del registro en el archivo

	End
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)

	oReport:SkipLine()
	oReport:SkipLine()

	aDados[ARAZSOC] := "TOTAL GENERAL : "
	aDados[AVALOR] := nTotValor //ALLTRIM(TRANSFORM((nTotNet),"@E 9,999,999.99"))
	aDados[AVALORSUS] := nTotValsus//ALLTRIM(TRANSFORM((nTotNetBs),"@E 9,999,999.99"))

	oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()
	oReport:IncMeter()

	oSection2:Finish()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Apaga indice ou consulta(Query)                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	#IFDEF TOP

	TMPCOB->(dbCloseArea())

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
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","Sucursal ?","Sucursal ?","Sucursal ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","De Centro Costo ?","De Centro Costo ?","De Centro Costo ?",         "mv_ch3","C",11,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","A Centro Costo ?","A Centro Costo ?","A Centro Costo ?",         "mv_ch4","C",11,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"04","Condicion de Pago?"   ,"Condicion de Pago?" ,"Condicion de Pago?"   ,"MV_CH2","N",1,0,0,"C","","","","" ,"MV_PAR04","Contado","Contado","Contado","","Credito","Credito","Credito","Todos","Todos","Todos")
	xPutSx1(cPerg,"05","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"07","Mostrar?"   ,"Mostrar?" ,"Mostrar?"   ,"MV_CH2","N",1,0,0,"C","","","","" ,"MV_PAR07","Solo Bancos","Solo Bancos","Solo Bancos","","Solo Titulos","Solo Titulos","Solo Titulos","Todos","Todos","Todos")
	xPutSx1(cPerg,"08","De Serie ?","De Serie ?","De Serie ?",         "mv_ch3","C",3,0,0,"G","","RN","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","A Serie ?","A Serie ?","A Serie ?",         "mv_ch4","C",3,0,0,"G","","RN","","","mv_par09",""       ,""            ,""        ,""     ,"","")

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