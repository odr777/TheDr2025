#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE AFECHA		1
#DEFINE AFILIAL		2
#DEFINE ADFILIAL	3
#DEFINE ADOC  		4
#DEFINE ACOD  		5
#DEFINE ADESC		6
#DEFINE ALLOCAL		7
#DEFINE ALODESC		8
#DEFINE ATIMOV		9
#DEFINE ADESMOV		10
#DEFINE AUM			11
#DEFINE ACANT		12
#DEFINE AGRUPO		13
#DEFINE AESDOC		14
#DEFINE AFECVAL		15
#DEFINE AUGLOSA		16

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ PICKWMS  บ Autor ณ Erick Etcheverry 	   บ Data ณ  11/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ REPORTE PICKWMS PICKLIST CONSOLIDADO			   	            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TdeP                                       	            	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TRANSPEN()
	Local oReport
	Local cPerg := "TRANSPEN"
	If FindFunction("TRepInUse") .And. TRepInUse()

		CriaSX1(cPerg)	// Si no esta creada la crea

		Pergunte(cPerg,.t.)

		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Return Nil

Static Function ReportDef()
	Local oReport
	Local cPerg
	cPerg := "TRANSPEN"

	oReport := TReport():New("TRANSPEN","Transferencias pendientes",cPerg,{|oReport| ReportPrint(oReport)},;
		"Este programa tiene como objetivo imprimir transferencias de sucursal pendientes",,,,,,,0.5)

	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection2 := TRSection():New(oReport,"TRANSFERENCIAS PENDIENTES",,)

	TRCell():New(oSection2,"D2_EMISSAO","SD2","Fecha",PesqPict("SD2","D2_EMISSAO"),10,,,,,,,,,,,)
	TRCell():New(oSection2,"D2_FILIAL","SD2","Sucursal salida","",4)
	TRCell():New(oSection2,"F2_FILDEST","SD2","Sucursal destino","",4)
	TRCell():New(oSection2,"D2_DOC","SD2","Documento","",6)
	TRCell():New(oSection2,"D2_COD","SD2","Cod.Producto","",6)
	TRCell():New(oSection2,"B1_DESC","SB1","Producto","",30)
	TRCell():New(oSection2,"D2_LOCAL","SD2","Cod.Deposito","",2)
	TRCell():New(oSection2,"NNR_DESCRI","NNR","Deposito","",2)
	TRCell():New(oSection2,"F4_CODIGO","SF4","Cod.TES","",6)
	TRCell():New(oSection2,"F4_TEXTO","SF4","TES","",6)
	TRCell():New(oSection2,"D2_UM","SD2","U.Medida","",6)
	TRCell():New(oSection2,"D2_QUANT","SD2","Cantidad","",6)
	TRCell():New(oSection2,"D2_GRUPO","SD2","Grupo","",6)
	TRCell():New(oSection2,"D2_UDESC","SB1","Estado","",6)
	TRCell():New(oSection2,"F2_EMISSAO","SD2","Fec.Recibido",PesqPict("SD2","D2_EMISSAO"),10,,,,,,,,,,,)
	TRCell():New(oSection2,"F2_UOBSERV","SF2","Glosa","",6)

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[17]

	oSection2:Cell("D2_EMISSAO"):SetBlock( { || aDados[AFECHA] })
	oSection2:Cell("D2_FILIAL"):SetBlock( { || aDados[AFILIAL] })
	oSection2:Cell("F2_FILDEST"):SetBlock( { || aDados[ADFILIAL] })
	oSection2:Cell("D2_DOC"):SetBlock( { || aDados[ADOC] })
	oSection2:Cell("D2_COD"):SetBlock( { || aDados[ACOD] })
	oSection2:Cell("B1_DESC"):SetBlock( { || aDados[ADESC] })
	oSection2:Cell("D2_LOCAL"):SetBlock( { || aDados[ALLOCAL] })
	oSection2:Cell("NNR_DESCRI"):SetBlock( { || aDados[ALODESC] })
	oSection2:Cell("F4_CODIGO"):SetBlock( { || aDados[ATIMOV] })
	oSection2:Cell("F4_TEXTO"):SetBlock( { || aDados[ADESMOV] })
	oSection2:Cell("D2_UM"):SetBlock( { || aDados[AUM] })
	oSection2:Cell("D2_QUANT"):SetBlock( { || aDados[ACANT] })
	oSection2:Cell("D2_GRUPO"):SetBlock( { || aDados[AGRUPO] })
	oSection2:Cell("D2_UDESC"):SetBlock( { || aDados[AESDOC] })
	oSection2:Cell("F2_EMISSAO"):SetBlock( { || aDados[AFECVAL] })
	oSection2:Cell("F2_UOBSERV"):SetBlock( { || aDados[AUGLOSA] })

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)


	cQuery2:= " SELECT CONVERT(DATE,D2_EMISSAO,3) FECHA, F2_UOBSERV GLOSA,D2_FILIAL, D2_LOCAL,NNR_DESCRI,D2_TES TIPO_MOV "
	cQuery2+= " ,F4_TEXTO DESC_TM,D2_DOC DOC,D2_COD CODIGO_ITEM, RTRIM(B1_DESC) DESCRIPCION,D2_UM UM,D2_QUANT CANTIDAD, "
	cQuery2+= " B1_GRUPO GRUPO,F2_FILDEST SUCURSAL_DESTINO, "
	cQuery2+= " (SELECT CASE SUM(D2_QTDAFAT) WHEN 0 THEN 'RECIBIDO' ELSE 'PENDIENTE' END FROM "+ RetSQLname('SD2') + " "
	cQuery2+= " WHERE D2_ESPECIE = 'RTS' AND D_E_L_E_T_ = ' ' AND D2_DOC = SD2.D2_DOC AND D2_SERIE = SD2.D2_SERIE AND D2_FILIAL = SD2.D2_FILIAL "
	cQuery2+= " AND D2_CLIENTE =SD2.D2_CLIENTE GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE) ESTADO_DOCUMENTO, "
	cQuery2+= " (Select TOP 1 CONVERT(DATE,D1_DTDIGIT,3) From "+ RetSQLname('SD1') + " SD1 "
	cQuery2+= " Where D1_FILIAL = F2_FILDEST And D1_DOC = D2_DOC And D1_SERIORI = D2_SERIE  And "
	cQuery2+= " D1_COD = D2_COD And D1_ESPECIE = 'RTE' And D1_IDENTB6 = D2_NUMSEQ And SD1.D_E_L_E_T_ = ' ' ) FECHA_VALIDACION "
	cQuery2+= " FROM "+ RetSQLname('SD2') + " SD2 "
	cQuery2+= " JOIN "+ RetSQLname('SF4') + " SF4 ON F4_ESTOQUE='S' AND D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "
	cQuery2+= " JOIN "+ RetSQLname('SB1') + " SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ <> '*' "
	cQuery2+= " LEFT JOIN "+ RetSQLname('SBM') + " SBM ON SBM.D_E_L_E_T_ <> '*' AND B1_GRUPO = BM_GRUPO "
	cQuery2+= " LEFT JOIN "+ RetSQLname('NNR') + " NNR ON NNR.D_E_L_E_T_ <> '*' AND NNR_CODIGO = D2_LOCAL AND NNR_FILIAL = D2_FILIAL "
	cQuery2+= " JOIN "+ RetSQLname('SF2') + " SF2 ON SF2.D_E_L_E_T_ <> '*' AND D2_FILIAL = F2_FILIAL AND D2_ESPECIE = F2_ESPECIE "
	cQuery2+= " AND D2_SERIE = F2_SERIE AND D2_DOC = F2_DOC AND D2_DTDIGIT = F2_DTDIGIT AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
	cQuery2+= " WHERE SD2.D_E_L_E_T_ <> '*' AND D2_ESPECIE = 'RTS'  "
	cQuery2+= " AND D2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "

	cxEstado = ''
	IF MV_PAR05 == 1
		cxEstado = 'RECIBIDO'
	ELSEIF MV_PAR05 == 2
		cxEstado = 'PENDIENTE'
	ENDIF

	if MV_PAR05 <> 3
		cQuery2+= " AND (SELECT CASE SUM(D2_QTDAFAT) WHEN 0 THEN 'RECIBIDO' ELSE 'PENDIENTE' END FROM "+ RetSQLname('SD2') + " "
		cQuery2+= " WHERE D2_ESPECIE = 'RTS' AND D_E_L_E_T_ = ' ' AND D2_DOC = SD2.D2_DOC AND D2_SERIE = SD2.D2_SERIE AND D2_FILIAL = SD2.D2_FILIAL "
		cQuery2+= " AND D2_CLIENTE =SD2.D2_CLIENTE GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE) =  '" + cxEstado + "'  "
	endif

	cQuery2+= " ORDER BY D2_DOC "


	cQuery2 := ChangeQuery(cQuery2)

	TCQUERY cQuery2 NEW ALIAS "TMP2"

	IF TMP2->(!EOF()) .AND. TMP2->(!BOF())
		TMP2->(dbGoTop())
	endif

	oReport:SetMeter(TMP2->(RecCount()))

	i:=0

	While TMP2->(!Eof())

		aDados[AFECHA]  := dtoc(TMP2->FECHA)
		aDados[AFILIAL] := TMP2->D2_FILIAL
		aDados[ADFILIAL] := TMP2->SUCURSAL_DESTINO
		aDados[ADOC]    := TMP2->DOC
		aDados[ACOD]    := TMP2->CODIGO_ITEM
		aDados[ADESC]   := TMP2->DESCRIPCION
		aDados[ALLOCAL] := TMP2->D2_LOCAL
		aDados[ALODESC] := TMP2->NNR_DESCRI
		aDados[ATIMOV]  := TMP2->TIPO_MOV
		aDados[ADESMOV] := TMP2->DESC_TM
		aDados[AUM]     := TMP2->UM
		aDados[ACANT]   := ALLTRIM(TRANSFORM((TMP2->CANTIDAD)	,"@E 999,999,999"))
		aDados[AGRUPO]  := TMP2->GRUPO
		aDados[AESDOC]  := TMP2->ESTADO_DOCUMENTO
		aDados[AFECVAL] := dtoc(TMP2->FECHA_VALIDACION)
		aDados[AUGLOSA] := TMP2->GLOSA

		oSection2:PrintLine()
		aFill(aDados,nil)

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

	End

	nRow := oReport:Row()

	//oSection2:PrintLine()
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
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De sucursal ?","De sucursal ?","De sucursal ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""  ,"" ,""  ,""   ,"","")
	xPutSx1(cPerg,"02","A Sucursal ?","A Sucursal ?","A Sucursal ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","A fecha?","A fecha?","A fecha?", "mv_ch3","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","De fecha?","De fecha?","De fecha?", "mv_ch3","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"05","Estado ?" , "Estado ?" ,"Estado ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par05","RECIBIDO","RECIBIDO","RECIBIDO","","PENDIENTE","PENDIENTE","PENDIENTE","TODOS","TODOS","TODOS")

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
