#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE AFILIAL		1
#DEFINE AFILDEST		2
#DEFINE AFECHA  		3
#DEFINE ACOD		4
#DEFINE ADESC		5
#DEFINE AFABRIC		6
#DEFINE ACANTI		7
#DEFINE ALOCALI 	8
#DEFINE ALOTCT		9
#DEFINE AVENCI		10
#DEFINE ALOCLIZ		11
#DEFINE ALOTEC		12
#DEFINE ADTVALID	13
#DEFINE AVENCTO 	14
#DEFINE ALOCLIZ		1
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

User Function PICKTRANS()
	Local oReport
	Local cPerg := "PICKTRANS"
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
	cPerg := "PICKTRANS"

	oReport := TReport():New("PICKTRANS","PICKING LIST TRANSFERENCIA",cPerg,{|oReport| ReportPrint(oReport)},;
	"Este programa tiene como objetivo imprimir el PICKING LIST CONSOLIDADO para transferencias",,,,,,,0.5)

	//oReport:SetPortrait(.T.)
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection2 := TRSection():New(oReport,"PICKING LIST TRANSFERENCIA",,)

	TRCell():New(oSection2,"D2_FILIAL","SD2","Sucursal","",4)
	//TRCell():New(oSectDad, "XX_GRUPO", "",        "Grupo",, 003, ,,,,,,/*nColSpace*/,,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSection2,"D2_FILDEST","SF2","Sucursal Dest.","",4)
	TRCell():New(oSection2,"D2_EMISSAO","SD2","Fecha",PesqPict("SF2","F2_EMISSAO"),10,,,,,,,,,,,)
	TRCell():New(oSection2,"D2_COD","SD2","Cod. Producto","",6)
	TRCell():New(oSection2,"B1_DESC","SD2","Producto","",40)
	TRCell():New(oSection2,"B1_UFABRIC","SD2","Fabricante","",3)
	TRCell():New(oSection2,"D2_QUANT","SD2","Cantidad","",18)
	TRCell():New(oSection2,"D2_LOCAL","SD2","Deposito","",2)
	TRCell():New(oSection2,"D2_LOCTL","SD2","Lote","",10)
	TRCell():New(oSection2,"D2_DTVALID","SD2","Vencimiento",PesqPict("SF2","F2_EMISSAO"),10,,,,,,,,,,,)
	TRCell():New(oSection2,"D2_LOCALIZ","SD2","Ubicacion","",15)

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[17]

	oSection2:Cell("D2_FILIAL"):SetBlock( { || aDados[17] })
	oSection2:Cell("D2_EMISSAO"):SetBlock( { || aDados[AFECHA] })
	oSection2:Cell("D2_COD"):SetBlock( { || aDados[ACOD] })
	oSection2:Cell("B1_DESC"):SetBlock( { || aDados[ACOD] })
	oSection2:Cell("B1_UFABRIC"):SetBlock( { || aDados[AFABRIC] })
	oSection2:Cell("D2_QUANT"):SetBlock( { || aDados[ACANTI] })
	oSection2:Cell("D2_LOCAL"):SetBlock( { || aDados[ALOCALI] })
	oSection2:Cell("D2_LOCTL"):SetBlock( { || aDados[ALOTCT] })
	oSection2:Cell("D2_DTVALID"):SetBlock( { || aDados[AVENCI] })
	oSection2:Cell("D2_LOCALIZ"):SetBlock( { || aDados[ALOCLIZ] })

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	/*
	SELECT D2_FILIAL,F2_FILDEST,D2_EMISSAO,D2_COD,B1_DESC,'B1_UFABRIC'FABRICANTE,SUM(D2_QUANT) D2_QUANT, D2_LOCAL, D2_LOTECTL,D2_DTVALID,D2_LOCALIZ
	FROM SD2010 SD2
	JOIN SF2010 SF2
	ON F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL
	AND D2_CLIENTE = F2_CLIENTE AND D2_DOC = F2_DOC AND D2_LOJA = F2_LOJA AND F2_ESPECIE ='RTS' AND SF2.D_E_L_E_T_ = ''
	LEFT JOIN SB1010 SB1 on B1_COD=D2_COD and SB1.D_E_L_E_T_=' '
	WHERE D2_TIPODOC = '54'
	AND SD2.D_E_L_E_T_ = ''
	GROUP BY D2_FILIAL,F2_FILDEST,D2_EMISSAO,D2_COD,B1_DESC,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ
	ORDER BY D2_LOCALIZ
	*/

	cQuery2:= " SELECT D2_FILIAL,D2_EMISSAO,D2_COD,B1_DESC,B1_UFABRIC,SUM(D2_QUANT) D2_QUANT, D2_LOCAL, "
	cQuery2+= "	D2_LOTECTL,D2_DTVALID,D2_LOCALIZ "
	cQuery2+= " FROM "+ RetSQLname('SD2') + " SD2 JOIN "+ RetSQLname('SF2') + " SF2 "
	cQuery2+= " ON F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_DOC = F2_DOC AND D2_LOJA = F2_LOJA "
	cQuery2+= " AND F2_ESPECIE ='RTS' and F2_FILDEST BETWEEN '"+trim(mv_par02)+"' and '"+trim(mv_par03)+"' AND F2_FILIAL = '"+trim(mv_par01)+"' AND SF2.D_E_L_E_T_ = '' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SB1') + " SB1 "
	cQuery2+= " on B1_COD=D2_COD and SB1.D_E_L_E_T_=' ' "
	cQuery2+= " WHERE D2_TIPODOC = '54' AND SD2.D_E_L_E_T_ = ''"
	cQuery2+= " AND D2_EMISSAO Between '"+DTOS(mv_par04)+"' and '"+DTOS(mv_par05)+"'"
	cQuery2+= " AND D2_COD Between '"+trim(mv_par06)+"' and '"+trim(mv_par07)+"'"
	cQuery2+= " AND D2_LOCAL Between '"+trim(mv_par08)+"' and '"+trim(mv_par09)+"'"
	cQuery2+= " GROUP BY D2_FILIAL,D2_EMISSAO,D2_COD,B1_DESC,B1_UFABRIC,D2_LOCAL,D2_LOTECTL,D2_DTVALID,D2_LOCALIZ"
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

	While TMP2->(!Eof())
		aDados[17] := TMP2->D2_FILIAL
		aDados[AFECHA] :=   STOD(TMP2->D2_EMISSAO)
		aDados[ACOD] := TMP2->D2_COD
		aDados[AFABRIC] :=    TMP2->B1_UFABRIC
		aDados[ACANTI] :=    TRANSFORM((TMP2->D2_QUANT)	,"@E 999,999,999")
		aDados[ALOCALI] :=    TMP2->D2_LOCAL
		aDados[ALOTCT] := TMP2->D2_LOTECTL
		aDados[AVENCI] := STOD(TMP2->D2_DTVALID)
		aDados[ALOCLIZ] :=   TMP2->D2_LOCALIZ

		oSection2:PrintLine()
		aFill(aDados,nil)

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

	End
	nRow := oReport:Row()

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

	xPutSx1(cPerg,"01","De sucursal fija ?","De sucursal fija ?","De sucursal fija ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","De Sucursal ?","De Sucursal ?","De Sucursal ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","A Sucursal ?","A Sucursal ?","A Sucursal ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","De fecha inicial?","De fecha inicial?","De fecha inicial?", "mv_ch3","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De fecha final?","De fecha final?","De fecha final?", "mv_ch3","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","De Producto?","De Producto ?","De Producto ?",  "mv_ch5","C",6,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","A Producto ?","A Producto ?","A Producto ?",  "mv_ch6","C",6,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","De Deposito ?","De Deposito ?","De Deposito ?", "mv_ch7","C",2,0,0,"G","","NNR","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","A Deposito ?","A Deposito ?","A Deposito ?",  "mv_ch8","C",2,0,0,"G","","NNR","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	//xPutSX1(cPerg,"13","Tipo de cliente ?" , "Tipo de cliente ?" ,"Tipo de cliente ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par13","Ciudad","Ciudad","Ciudad","","Provincia","Provincia","Provincia","Todos","Todos","Todos")

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