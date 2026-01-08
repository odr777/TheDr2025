#include "protheus.ch"
#Include "TopConn.ch"

#DEFINE ISNEW "S"

/**
* @author: Denar Terrazas Parada
* @since: 26/05/2022
* @description: Informe de regla de descuento.
*				Utilizado para modificar la información en el excel que imprime
*				para luego ser importado desde la función de usuario U_imporegde
*/

User Function ExpRegDe()
	//Local oReport
	Private cPerg   := "ExpRegDe"// elija el Nombre de la pregunta
	Private cClName	:= ""
	CriaSX1(cPerg)// Si no esta creada la crea

	lAcept:= Pergunte(cPerg,.T.)
	if(lAcept)
		MsgRun("Exportando archivo...","Espere",{|| generateReport() })
	EndIf
	//oReport := ReportDef()
	//oReport:PrintDialog()

Return

Static Function generateReport()
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cBranch   := xFilial("ACO")
	Local cRuleFrom := MV_PAR01
	Local cRuleTo   := MV_PAR02
	Local cClient   := MV_PAR03
	Local cStore	:= MV_PAR04
	Local cArquivo	:= GetTempPath()+'Regla-Desc-CL' + cClient + DTOS(DATE()) + ".xml"
	Local lFirst	:= .T.
	Local aDefault	:= {}
	Local oFWMsExcel
	Local oExcel

	If( !existClient(cClient, cStore) )
		FWAlertHelp("Cliente no identificado", "Por favor revise los parámetros informados")
		return
	EndIf

	cQuery := " SELECT 'N' AS IS_NEW, ACO_FILIAL, ACO_CODREG, ACO_DESCRI, ACO_CODCLI, ACO_LOJA, ACO_HORADE, ACO_DATDE, ACO_HORATE, ACO_DATATE, ACO_MOEDA,"
	cQuery += " ACP_CODPRO, ACP_PERDES,"
	cQuery += " SB1.B1_XSBCAT1, COALESCE((SELECT X5_DESCSPA FROM SX5010 WHERE D_E_L_E_T_ <> '*' AND X5_TABELA = 'Z1' AND X5_CHAVE = SB1.B1_XSBCAT1), '') AS SUB1_DESC,"
	cQuery += " SB1.B1_XSBCAT2, COALESCE((SELECT X5_DESCSPA FROM SX5010 WHERE D_E_L_E_T_ <> '*' AND X5_TABELA = 'Z2' AND X5_CHAVE = SB1.B1_XSBCAT2), '') AS SUB2_DESC,"
	cQuery += " SB1.B1_XSBCAT3, COALESCE((SELECT X5_DESCSPA FROM SX5010 WHERE D_E_L_E_T_ <> '*' AND X5_TABELA = 'Z3' AND X5_CHAVE = SB1.B1_XSBCAT3), '') AS SUB3_DESC"
	cQuery += " FROM ACO010 ACO (NOLOCK)"
	cQuery += " JOIN ACP010 ACP (NOLOCK) ON ACP.ACP_FILIAL = ACO.ACO_FILIAL AND ACP.ACP_CODREG = ACO.ACO_CODREG"
	cQuery += " JOIN SB1010 SB1 (NOLOCK) ON SB1.B1_COD = ACP.ACP_CODPRO"
	cQuery += " WHERE ACO.ACO_FILIAL BETWEEN '" + cBranch + "' AND '"  + cBranch + "'"
	cQuery += " AND ACO.ACO_CODREG BETWEEN '" + cRuleFrom + "' AND '"  + cRuleTo + "'"
	cQuery += " AND ACO.ACO_CODCLI = '" + cClient + "'"
	cQuery += " AND ACO.ACO_LOJA = '" + cStore + "'"
	cQuery += " AND ACO.D_E_L_E_T_ = ' '"
	cQuery += " AND ACP.D_E_L_E_T_ = ' '"
	cQuery += " UNION ALL"
	cQuery += " SELECT 'S' AS IS_NEW,'' ACO_FILIAL, '' ACO_CODREG, '' ACO_DESCRI, '' ACO_CODCLI, '' ACO_LOJA, '' ACO_HORADE, '' ACO_DATDE, '' ACO_HORATE, '' ACO_DATATE, NULL ACO_MOEDA,"
	cQuery += " SB1.B1_COD ACP_CODPRO, 0 ACP_PERDES,"
	cQuery += " SB1.B1_XSBCAT1, COALESCE((SELECT X5_DESCSPA FROM SX5010 WHERE D_E_L_E_T_ <> '*' AND X5_TABELA = 'Z1' AND X5_CHAVE = SB1.B1_XSBCAT1), '') AS SUB1_DESC,"
	cQuery += " SB1.B1_XSBCAT2, COALESCE((SELECT X5_DESCSPA FROM SX5010 WHERE D_E_L_E_T_ <> '*' AND X5_TABELA = 'Z2' AND X5_CHAVE = SB1.B1_XSBCAT2), '') AS SUB2_DESC,"
	cQuery += " SB1.B1_XSBCAT3, COALESCE((SELECT X5_DESCSPA FROM SX5010 WHERE D_E_L_E_T_ <> '*' AND X5_TABELA = 'Z3' AND X5_CHAVE = SB1.B1_XSBCAT3), '') AS SUB3_DESC"
	cQuery += " FROM SB1010 SB1"
	cQuery += " JOIN SB5010 SB5 ON SB1.B1_FILIAL = SB5.B5_FILIAL AND SB1.B1_COD = SB5.B5_COD"
	cQuery += " WHERE SB1.D_E_L_E_T_ = ' '"
	cQuery += " AND SB5.D_E_L_E_T_ = ' '"
	cQuery += " AND SB5.B5_ECFLAG = '1'"
	cQuery += " AND SB1.B1_MSBLQL <> '1'"
	cQuery += " AND SB1.B1_COD NOT IN "
	cQuery += " ("
	cQuery += " 	SELECT ACP.ACP_CODPRO"
	cQuery += " 	FROM ACO010 ACO (NOLOCK)"
	cQuery += " 	JOIN ACP010 ACP (NOLOCK) ON ACP.ACP_FILIAL = ACO.ACO_FILIAL AND ACP.ACP_CODREG = ACO.ACO_CODREG"
	cQuery += " 	JOIN SB1010 SB1 (NOLOCK) ON SB1.B1_COD = ACP.ACP_CODPRO"
	cQuery += " 	WHERE ACO.ACO_FILIAL BETWEEN '" + cBranch + "' AND '"  + cBranch + "'"
	cQuery += " 	AND ACO.ACO_CODREG BETWEEN '" + cRuleFrom + "' AND '"  + cRuleTo + "'"
	cQuery += " 	AND ACO.ACO_CODCLI = '" + cClient + "'"
	cQuery += " 	AND ACO.ACO_LOJA = '" + cStore + "'"
	cQuery += " 	AND ACO.D_E_L_E_T_ = ' '"
	cQuery += " 	AND ACP.D_E_L_E_T_ = ' '"
	cQuery += " )"
	cQuery += " ORDER BY IS_NEW ASC"

	TCQuery cQuery New Alias "QRYREGDE"

	//Creando el objeto que irá a generar el contenido del Excel
	oFWMsExcel := FWMsExcelEx():New()

	cTabTitle	:= "1. Regla de Descuento"
	cHeaderTitle:= "Regla de Descuento"
	oFWMsExcel:AddworkSheet(cTabTitle)
	//Creando la Tabla
	oFWMsExcel:AddTable(cTabTitle,cHeaderTitle)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_FILIAL"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_CODREG"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_DESCRI"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_CODCLI"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_LOJA"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_HORADE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_DATDE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_HORATE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_DATATE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACO_MOEDA"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACP_CODPRO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("ACP_PERDES"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("B1_XSBCAT1"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "Descripción " + getFieldTitle("B1_XSBCAT1"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("B1_XSBCAT2"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "Descripción " + getFieldTitle("B1_XSBCAT2"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("B1_XSBCAT3"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "Descripción " + getFieldTitle("B1_XSBCAT3"),1)

	oFWMsExcel:SetCelBold(.T.)
	oFWMsExcel:SetCelFrColor("#FFFFFF")
	oFWMsExcel:SetCelBgColor("#4F81BD")
	oFWMsExcel:AddRow(cTabTitle,cHeaderTitle,{;
		"ACO_FILIAL",;
		"ACO_CODREG",;
		"ACO_DESCRI",;
		"ACO_CODCLI",;
		"ACO_LOJA",;
		"ACO_HORADE",;
		"ACO_DATDE",;
		"ACO_HORATE",;
		"ACO_DATATE",;
		"ACO_MOEDA",;
		"ACP_CODPRO",;
		"ACP_PERDES",;
		"B1_XSBCAT1",;
		"X5_DESCSPA",;
		"B1_XSBCAT2",;
		"X5_DESCSPA",;
		"B1_XSBCAT3",;
		"X5_DESCSPA";
		}, {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18})

	While !(QRYREGDE->(EoF()))
		oFWMsExcel:SetCelBold(.F.)
		oFWMsExcel:SetCelFrColor("#000000")
		oFWMsExcel:SetCelBgColor("#DCE6F1")
		If(lFirst)
			lFirst:= .F.
			If( QRYREGDE->IS_NEW == ISNEW)
				AADD(aDefault, {;//
				xFilial("ACO"),;// 1 - Sucursal
				getNextDiscountRuleCode(),;// 2 - Codigo Regla de descuento
				cClName + " - APP",;// 3 - Descripción Regla de descuento
				cClient,;// 4 - Código cliente
				cStore,;// 5 - Tienda Cliente
				"00:00",;// 6 - De hora
				DATE(),;// 7 - De fecha
				"23:59",;// 8 - A hora
				"",;// 9 - A Fecha
				"1",;// 10 - Moneda
				})
			Else
				AADD(aDefault, {;
					QRYREGDE->ACO_FILIAL,;
					QRYREGDE->ACO_CODREG,;
					QRYREGDE->ACO_DESCRI,;
					QRYREGDE->ACO_CODCLI,;
					QRYREGDE->ACO_LOJA,;
					QRYREGDE->ACO_HORADE,;
					STOD(QRYREGDE->ACO_DATDE),;
					QRYREGDE->ACO_HORATE,;
					STOD(QRYREGDE->ACO_DATATE),;
					QRYREGDE->ACO_MOEDA,;
					})
			EndIf
		EndIf
		If( QRYREGDE->IS_NEW == ISNEW)
			oFWMsExcel:AddRow(cTabTitle,cHeaderTitle,{;
				aDefault[1][1],;
				aDefault[1][2],;
				aDefault[1][3],;
				aDefault[1][4],;
				aDefault[1][5],;
				aDefault[1][6],;
				aDefault[1][7],;
				aDefault[1][8],;
				aDefault[1][9],;
				aDefault[1][10],;
				QRYREGDE->ACP_CODPRO,;
				QRYREGDE->ACP_PERDES,;
				QRYREGDE->B1_XSBCAT1,;
				QRYREGDE->SUB1_DESC,;
				QRYREGDE->B1_XSBCAT2,;
				QRYREGDE->SUB2_DESC,;
				QRYREGDE->B1_XSBCAT3,;
				QRYREGDE->SUB3_DESC;
				}, {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18})
		Else
			oFWMsExcel:AddRow(cTabTitle,cHeaderTitle,{;
				QRYREGDE->ACO_FILIAL,;
				QRYREGDE->ACO_CODREG,;
				QRYREGDE->ACO_DESCRI,;
				QRYREGDE->ACO_CODCLI,;
				QRYREGDE->ACO_LOJA,;
				QRYREGDE->ACO_HORADE,;
				STOD(QRYREGDE->ACO_DATDE),;
				QRYREGDE->ACO_HORATE,;
				STOD(QRYREGDE->ACO_DATATE),;
				QRYREGDE->ACO_MOEDA,;
				QRYREGDE->ACP_CODPRO,;
				QRYREGDE->ACP_PERDES,;
				QRYREGDE->B1_XSBCAT1,;
				QRYREGDE->SUB1_DESC,;
				QRYREGDE->B1_XSBCAT2,;
				QRYREGDE->SUB2_DESC,;
				QRYREGDE->B1_XSBCAT3,;
				QRYREGDE->SUB3_DESC;
				}, {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18})
		EndIf

		QRYREGDE->(DbSkip())
	EndDo

	//Activando archivo y generando xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abriendo excel y archivo xml
	oExcel := MsExcel():New()		//Abre una nueva conexión con Excel
	oExcel:WorkBooks:Open(cArquivo)	//Abre una planilla
	oExcel:SetVisible(.T.)			//Visualiza la planilla
	oExcel:Destroy()				//Cierra el proceso de gerenciar tareas

	QRYREGDE->(DbCloseArea())
	RestArea(aArea)
Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local cTitle    := "Regla de descuento"
	Local cFileName := cTitle + "-" + DTOS(DATE())

	oReport:= TReport():New(cFileName,cTitle,cPerg,{|oReport| PrintReport(oReport)},"Reporte Regla de descuento", .T.)
	oReport:HideParamPage()
	oReport:HideHeader()
	oReport:HideFooter()
	oReport:SetTotalInLine(.F.)

	oSect1:= TRSection():New(oReport,"Titulos Regla de descuento")
	oSect1:SetHeaderBreak(.F.)
	TRCell():New(oSect1,"ACO_FILIAL"	,"ACO", "ACO_FILIAL"	)
	TRCell():New(oSect1,"ACO_CODREG"	,"ACO", "ACO_CODREG"	)
	TRCell():New(oSect1,"ACO_DESCRI"	,"ACO", "ACO_DESCRI"	)
	TRCell():New(oSect1,"ACO_CODCLI"	,"ACO", "ACO_CODCLI"	)
	TRCell():New(oSect1,"ACO_LOJA"	    ,"ACO", "ACO_LOJA"	    )
	TRCell():New(oSect1,"ACO_HORADE"	,"ACO", "ACO_HORADE"	)
	TRCell():New(oSect1,"ACO_DATDE"	    ,"ACO", "ACO_DATDE"	    )
	TRCell():New(oSect1,"ACO_HORATE"	,"ACO", "ACO_HORATE"	)
	TRCell():New(oSect1,"ACO_DATATE"	,"ACO", "ACO_DATATE"	)
	TRCell():New(oSect1,"ACO_MOEDA"	    ,"ACO", "ACO_MOEDA"	    )
	TRCell():New(oSect1,"ACP_CODPRO"	,"ACP", "ACP_CODPRO"	)
	TRCell():New(oSect1,"ACP_PERDES"	,"ACP", "ACP_PERDES"	)

	oSection:= TRSection():New(oReport,"Regla de descuento",{"ACO", "ACP"},,,,,,,.F.,.F.,.F.)
	/*oSection:SetHeaderBreak(.F.)
	oSection:SetHeaderPage(.F.)
	oSection:SetHeaderSection(.F.)*/

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"ACO_FILIAL"	,"ACO")
	TRCell():New(oSection,"ACO_CODREG"	,"ACO")
	TRCell():New(oSection,"ACO_DESCRI"	,"ACO")
	TRCell():New(oSection,"ACO_CODCLI"	,"ACO")
	TRCell():New(oSection,"ACO_LOJA"	,"ACO")
	TRCell():New(oSection,"ACO_HORADE"	,"ACO")
	TRCell():New(oSection,"ACO_DATDE"	,"ACO")
	TRCell():New(oSection,"ACO_HORATE"	,"ACO")
	TRCell():New(oSection,"ACO_DATATE"	,"ACO")
	TRCell():New(oSection,"ACO_MOEDA"	,"ACO")

	TRCell():New(oSection,"ACP_CODPRO"	,"ACP")
	TRCell():New(oSection,"ACP_PERDES"	,"ACP", , PesqPict( 'ACP', 'ACP_PERDES' ), ,,,"RIGHT",,"RIGHT")

	//TRCell():New(oSection,"NETO"		,"SRC", "Valor Neto", PesqPict( 'SRC', 'RC_VALOR' ), 14,,,"RIGHT",,"RIGHT")

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(2)
	Local cBranch   := xFilial("ACO")
	Local cRuleFrom := MV_PAR01
	Local cRuleTo   := MV_PAR02
	Local cClFrom   := MV_PAR03
	Local cClTo     := MV_PAR04
	Local cStoreFrom:= MV_PAR05
	Local cStoreTo  := MV_PAR06
	Local oSect1    := oReport:Section(1)

	//oSect1:Print()
	//oSect1:Init()
	//oSect1:PrintLine(,,,.T.)
	//oSect1:Finish()
	oSect1:PrintHeader()

	#IFDEF TOP
		// Query
		oSection:BeginQuery()
		BeginSql alias "QRYACO"

        SELECT ACO_FILIAL, ACO_CODREG, ACO_DESCRI, ACO_CODCLI, ACO_LOJA, ACO_HORADE, ACO_DATDE, ACO_HORATE, ACO_DATATE, ACO_MOEDA,
        ACP_CODPRO, ACP_PERDES
        FROM %Table:ACO% ACO
        JOIN %Table:ACP% ACP ON ACP.ACP_FILIAL = ACO.ACO_FILIAL AND ACP.ACP_CODREG = ACO.ACO_CODREG
        WHERE ACO.ACO_FILIAL BETWEEN %Exp:cBranch% AND %Exp:cBranch%
        AND ACO.ACO_CODREG BETWEEN %Exp:cRuleFrom% AND %Exp:cRuleTo%
        AND ACO.ACO_CODCLI BETWEEN %Exp:cClFrom% AND %Exp:cClTo%
        AND ACO.ACO_LOJA BETWEEN %Exp:cStoreFrom% AND %Exp:cStoreTo%
        AND ACO.%notDel%
        AND ACP.%notDel%

		EndSql

        /*
        Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
        parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
        pela funcao MakeSqlExpr para serem adicionados a query
        */
	oSection:EndQuery()

#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
#ENDIF

oSection:Print()

Return

/**
*
* @author: Denar Terrazas Parada
* @since: 27/05/2022
* @description: Funcion que devuelve el titulo de los campos enviados en el parámetro
* @parameters: cField -> Nombre del campo
*/
Static Function getFieldTitle(cField)
	Local aArea		:= getArea()
	Local cRet		:= ""

	dbSelectArea("SX3")
	dbSetOrder(2)

	If dbSeek( cField )
		cRet := TRIM( X3Titulo() )
	EndIf

	restArea(aArea)
Return cRet

/**
* @author: Denar Terrazas Parada
* @since: 02/08/2022
* @description: Funcion que obtiene el siguiente código para las reglas de descuento
*/
Static Function getNextDiscountRuleCode()
	Local aArea         := getArea()
	Local cAliasQry     := GetNextAlias()
	Local cRet          := ""
	Local cQuery        := ""

	cQuery := " SELECT TOP 1 ACO_CODREG"
	cQuery += " FROM ACO010"
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND ACO_CODREG NOT LIKE '%[A-Z]%'"
	cQuery += " ORDER BY ACO_CODREG DESC"

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea( cAliasQry )
	(cAliasQry)->( dbGoTop() )

	If (cAliasQry)->( !EOF() )
		cAux:= CValToChar( VAL( AllTrim( (cAliasQry)->ACO_CODREG ) ) + 1 )
		cRet:= PadL( cAux, TamSx3("ACO_CODREG")[1], "0" )//Aumenta ceros a la izquierda
	Else
		cRet:= "000001"
	EndIf
	(cAliasQry)->( dbCloseArea() )

	restArea( aArea )

Return cRet

/**
* @author: Denar Terrazas Parada
* @since: 02/08/2022
* @description: Funcion que verifica si el cliente informado en los parámetros existe.
*/
Static Function existClient(cClient, cStore)
	Local aArea	:= getArea()
	Local lRet	:= .F.

	cClName:= Trim( GetAdvFVal("SA1", "A1_NOME", xFilial("SA1") + cClient + cStore ,1,"") )//A1_FILIAL+A1_COD+A1_LOJA
	If( !Empty(cClName) )
		cClName:= Trim( SUBSTR(cClName, 1, 24) )
		lRet:= .T.
	EndIf

	restArea( aArea )

Return lRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De Regla de Descuento?"	, "¿De Regla de Descuento?"	,"¿De Regla de Descuento?"	,"MV_CH1","C",06,0,0,"G","","ACO","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Regla de Descuento?" 	, "¿A Regla de Descuento?"	,"¿A Regla de Descuento?"	,"MV_CH2","C",06,0,0,"G","NaoVazio()","ACO","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","Cliente?"   , "¿Cliente?"	,"¿Cliente?"     ,"MV_CH3","C",06,0,0,"G","","SA1","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿Tienda?"   , "¿Tienda?"	,"¿Tienda?"     ,"MV_CH4","C",02,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

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
