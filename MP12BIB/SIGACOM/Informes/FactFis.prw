#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FACTFIS  ³ Autor ³Omar Delgadillo			³ Data ³ 15.07.21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Informe de Facturas Fiscales                      		  ³±±
±±³          ³											                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³15.07.2021³Omar Delgadillo³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function FACTFIS()
	Local oReport := nil	
	// Local cTitulo	:= "Facturas Fiscales"
	Local aArea		:= getArea()
    Private cPerg       := "FACTFIS" //Padr("RELAT001",10)

	//Incluo/Altero as perguntas na tabela SX1
	CriaSX1(cPerg)

	//gero a pergunta de modo oculto, ficando disponível no bot?o aç?es relacionadas
	Pergunte(cPerg,.F.)

	oReport := RptDef()
	oReport:PrintDialog()
	RestArea(aArea)

Return

Static Function RptDef()
	Local oReport := Nil
	Local oSection1:= Nil

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/

	oReport := TReport():New("FactFis","Facturas de Entrada Fiscales",cPerg,{|oReport| ReportPrint(oReport)},"Facturas de Entrada Fiscales")
    // oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)

	//TReport():HideParamPage( )
	//oReport:ParamReadOnly(.T.)
	
    //Monstando a primeira seç?o
	//Neste exemplo, a primeira seç?o será composta por duas colunas, código da NCM e sua descriç?o
	//Iremos disponibilizar para esta seç?o apenas a tabela SYD, pois quando voc? for em personalizar
	//e entrar na primeira seç?o, voc? terá todos os outros campos disponíveis, com isso, será
	//permitido a inserç?o dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas voc?
	//terá toda a liberdade de modificá-los via relatorio.
	oSection1:= TRSection():New(oReport, "Facturas", {"SF1"})
    
    /*
    Campos do detalhe: {nome do campos, tamanho para impressao, mascara, tipo, cabecalho} */
    TRCell():New(oSection1,"FILIAL",    "SF1",              "Sucursal",         "@!",01)    //"Especie"
    TRCell():New(oSection1,"DOC",       "SF1",              "Factura",          "@!",18)    //"No DA FATURA"
    TRCell():New(oSection1,"SERIE" ,    "SF1",              "Serie",            "@!",03)    // Serie
    TRCell():New(oSection1,"NUMAUT",    "SF1",              "Nro. Autorización","@!",17)    //"Numero DE AUTORIZACAO"
    TRCell():New(oSection1,"EMISSAO",   "SF1",              "F.Emisión",        "@!",12)    //"Data da Fatura ou DUE"
    TRCell():New(oSection1,"DTDIGIT",   "SF1",              "F.Digitación",     "@!",12)    //"Fecha de digitación"
    TRCell():New(oSection1,"FORNECE",   "SF1",              "Cod.Prov.",        "@!",13)	//"CODIGO FORNECEDOR"
    TRCell():New(oSection1,"CGC",       "SF1",              "Nit",              "@!",13)	//"NIT DO FORNECEDOR"
    TRCell():New(oSection1,"NOME",      "SF1",              "Razon Social",     "@!",60)	//"Nome ou Raz?o Social"
    TRCell():New(oSection1,"MOEDA",     "SF1",              "Moneda",           "@!",7)	//"No de DUE"
    TRCell():New(oSection1,"D1TOTAL",   "SF1",              "Total",            "@R 999,999,999.99",18)      //"VALOR TOTAL DA COMPRA"
    TRCell():New(oSection1,"EXENTO",   "SF1",               "Exento",           "@R 999,999,999.99",18)      //"VALOR NAO SUJEITO A CREDITO FISCAL"
    TRCell():New(oSection1,"D1VALDESC", "SF1",              "Descuento",        "@R 999,999,999.99",18)      //ODR 02/08/2019
    TRCell():New(oSection1,"D1BASIMP1", "SF1",              "Base Imp.",        "@R 999,999,999.99",18)	    //"Valor Base para Crédito Fiscal"
    TRCell():New(oSection1,"D1VALIMP1", "SF1",              "Impuesto",         "@R 999,999,999.99",18)	   //"Credito Fiscal"

    IF MV_PAR05 == 1 
        TRFunction():New(oSection1:Cell("D1TOTAL"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,/*uFormula*/,.F.,.T.) 
        TRFunction():New(oSection1:Cell("EXENTO"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,/*uFormula*/,.F.,.T.) 
        TRFunction():New(oSection1:Cell("D1VALDESC"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,/*uFormula*/,.F.,.T.) 
        TRFunction():New(oSection1:Cell("D1BASIMP1"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,/*uFormula*/,.F.,.T.) 
        TRFunction():New(oSection1:Cell("D1VALIMP1"),NIL,"SUM",/*oBreak*/,,"@R 999,999,999.99"/*cPicture*/ ,/*uFormula*/,.F.,.T.) 
    ENDIF

	//A segunda seç?o, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, voc? poderia incluir os campos da tabela
	//SYD.Semelhante a seç?o 1, defino o titulo e tamanho das colunas

	oReport:SetTotalInLine(.F.)

	//Aqui, farei uma quebra  por seç?o
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
    Local cAliasQry	:= GetNextAlias()

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	?Executa a rotina DaVinci() para geracao das informacoes ?
	?fiscais                                                 ?
	?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/


    //MsgRun(STR0002,STR0001,{|| DaVinci("C")}) //"Preparando as informacoes para o livro de compras"###"Livros fiscais"
    
    cQuery := " SELECT SF1.F1_FILIAL FILIAL, SF1.F1_DOC DOC, SF1.F1_SERIE SERIE, SF1.F1_NUMAUT NUMAUT, SF1.F1_EMISSAO EMISSAO, SF1.F1_DTDIGIT DTDIGIT, SF1.F1_FORNECE FORNECE, "
	cQuery += "		CASE"
    cQuery += "			WHEN SF1.F1_UNIT <> '' "
    cQuery += "			THEN SF1.F1_UNIT "
    cQuery += "			ELSE (SELECT SA2.A2_CGC FROM " + RetSqlName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ = '' AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.A2_COD = SF1.F1_FORNECE)  "
    cQuery += "		END CGC, "
    cQuery += "		CASE  "
    cQuery += "			WHEN SF1.F1_UNOMBRE <> ''  "
    cQuery += "			THEN SF1.F1_UNOMBRE "
    cQuery += "			ELSE (SELECT SA2.A2_NOME FROM " + RetSqlName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ = '' AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.A2_COD = SF1.F1_FORNECE) "
    cQuery += "		END NOME,  "
    cQuery += "		SF1.F1_MOEDA MOEDA,  "
    cQuery += "		CASE  "
    cQuery += "			WHEN SF1.F1_MOEDA = '1'  "
    cQuery += "			THEN SUM(SD1.D1_TOTAL) "
    cQuery += "			ELSE SUM(SD1.D1_TOTAL*SF1.F1_TXMOEDA) "
    cQuery += "		END D1TOTAL, "
    cQuery += "		CASE  "
    cQuery += "			WHEN SF1.F1_MOEDA = '1'  "
    cQuery += "			THEN SUM(SD1.D1_VALDESC) "
    cQuery += "			ELSE SUM(SD1.D1_VALDESC*SF1.F1_TXMOEDA) "
    cQuery += "		END D1VALDESC, "
    cQuery += "		CASE  "
    cQuery += "			WHEN SF1.F1_MOEDA = '1'  "
    cQuery += "			THEN SUM(SD1.D1_BASIMP1) "
    cQuery += "			ELSE SUM(SD1.D1_BASIMP1*SF1.F1_TXMOEDA) "
    cQuery += "		END D1BASIMP1, "
    cQuery += "		CASE  "
    cQuery += "			WHEN SF1.F1_MOEDA = '1'  "
    cQuery += "			THEN SUM(SD1.D1_VALIMP1) "
    cQuery += "			ELSE SUM(SD1.D1_VALIMP1*SF1.F1_TXMOEDA) "
    cQuery += "		END D1VALIMP1 "
    cQuery += "FROM " + RetSqlName("SD1") + " SD1 "
    cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.D_E_L_E_T_ = '' AND SF4.F4_CODIGO = SD1.D1_TES  "
    cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1 ON SF1.D_E_L_E_T_ = ''  "
    cQuery += "						AND SF1.F1_FILIAL = SD1.D1_FILIAL  "
    cQuery += "						AND SF1.F1_DOC = SD1.D1_DOC  "
    cQuery += "						AND SF1.F1_SERIE = SD1.D1_SERIE " 
    cQuery += "						AND SF1.F1_EMISSAO = SD1.D1_EMISSAO  "
    cQuery += "						AND SF1.F1_FORNECE = SD1.D1_FORNECE  "
    cQuery += "WHERE SD1.D_E_L_E_T_ = ''  "
    cQuery += "		AND SD1.D1_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
    cQuery += "		AND SD1.D1_ESPECIE = 'NF' "
    cQuery += "		AND SF4.F4_XRETEN IN ('','1') AND SF4.F4_GERALF = '1' "
    cQuery += "		AND SF1.F1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
    cQuery += "GROUP BY SF1.F1_FILIAL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_NUMAUT, SF1.F1_EMISSAO, SF1.F1_DTDIGIT, SF1.F1_FORNECE, SF1.F1_UNIT, SF1.F1_UNOMBRE, SF1.F1_MOEDA, SF1.F1_LOJA "
    cQuery += "ORDER BY SF1.F1_EMISSAO, SF1.F1_DOC  "

    cQuery:= ChangeQuery(cQuery)
    dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

    oSection1:Init()
    While (cAliasQry)->(!EOF())

        oSection1:Cell("FILIAL"):SetValue((cAliasQry)->FILIAL)
        oSection1:Cell("DOC"):SetValue((cAliasQry)->DOC)
        oSection1:Cell("SERIE"):SetValue((cAliasQry)->SERIE)
        oSection1:Cell("NUMAUT"):SetValue((cAliasQry)->NUMAUT)
        oSection1:Cell("EMISSAO"):SetValue((cAliasQry)->EMISSAO)
        oSection1:Cell("DTDIGIT"):SetValue((cAliasQry)->DTDIGIT)
        oSection1:Cell("FORNECE"):SetValue((cAliasQry)->FORNECE)
        oSection1:Cell("CGC"):SetValue((cAliasQry)->CGC)
        oSection1:Cell("NOME"):SetValue((cAliasQry)->NOME)
        oSection1:Cell("MOEDA"):SetValue((cAliasQry)->MOEDA)
        oSection1:Cell("D1TOTAL"):SetValue((cAliasQry)->D1TOTAL)
        oSection1:Cell("EXENTO"):SetValue((cAliasQry)->D1TOTAL - (cAliasQry)->D1VALDESC - (cAliasQry)->D1BASIMP1)
        oSection1:Cell("D1VALDESC"):SetValue((cAliasQry)->D1VALDESC)
        oSection1:Cell("D1BASIMP1"):SetValue((cAliasQry)->D1BASIMP1)
        oSection1:Cell("D1VALIMP1"):SetValue((cAliasQry)->D1VALIMP1)

		oSection1:PrintLine(,,,.T.) // imprime linea.
        (cAliasQry)->(dbSkip())
    enddo

    oSection1:Finish()

return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","Data inicial ?       ","¿Fecha inicial ?     ","Initial Date ?       ","MV_CH0","D",08,0,0,"G","","","","","MV_PAR01","","")
	xPutSX1(cPerg,"02","Data final ?         ","¿Fecha final ?       ","Final Date ?         ","MV_CH0","D",08,0,0,"G","","","","","MV_PAR02","","")
	xPutSX1(cPerg,"03","Sucursal Inicial     ","Sucursal Inicial     ","Sucursal Inicial     ","MV_CH0","C",04,0,0,"G","","SM0","","","MV_PAR03","","")
	xPutSX1(cPerg,"04","Sucursal Final       ","Sucursal Final       ","Sucursal Final       ","MV_CH0","C",04,0,0,"G","","SM0","","","MV_PAR04","","")
	xPutSX1(cPerg,"05","Imprime totales?     ","Imprime totales?     ","Imprime totales?     ","MV_CHB","N",01,0,0,"C","","","","","MV_PAR05","SI","SI","SI","","NO","NO","NO")
return


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
