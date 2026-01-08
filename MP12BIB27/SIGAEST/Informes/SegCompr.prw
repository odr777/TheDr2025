#include "protheus.ch"
#Include "TopConn.ch"

/**
* @author: Denar Terrazas Parada
* @since: 01/09/2022
* @description: Informe de seguimiento de Solicitudes de Compras.
*/
User Function SegCompr()
	Private cPerg       := "SegCompr"// elija el Nombre de la pregunta

	CriaSX1(cPerg)// Si no esta creada la crea

	lAcept:= Pergunte(cPerg,.T.)
	if(lAcept)//Si se confirman los parámetros
		FWMsgRun(,;
			{|| generateReport() },;
			"TOTVS",;
			"Imprimiendo informe, por favor espere...")
	EndIf

Return

Static Function generateReport()
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cTime     := StrTran(GetRmtTime(), ":", "-")
	Local cArquivo	:= ""
	Local dFromDate := MV_PAR01
	Local dToDate   := MV_PAR02
	Local oFWMsExcel
	Local oExcel

	cArquivo:= GetTempPath()+"Seguimiento SC " + DTOS(dFromDate) + "-" + DTOS(dToDate) + " " + cTime + ".xlsx"

	cQuery := " SELECT"
	cQuery += " C1_NUM NUM_SOL_COM,"
	cQuery += " C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_UM,COALESCE(C1_EMISSAO, '') C1_EMISSAO,COALESCE(C1_DATPRF, '') C1_DATPRF,C1_QUANT, c.CTT_DESC01 SOL_COM_CC, H.CTH_DESC01 SOL_COM_CLAS,"
	cQuery += " C1_OBS, C1_SOLICIT, C1_NOMAPRO APROBADOR, C1_APROV,"
	cQuery += " COALESCE(C7_EMISSAO, '') C7_EMISSAO, COALESCE(CR_DATALIB, '') FECHA_LIB, C7_NUM NUM_PC,"
	cQuery += " A2_NOME, C7_UM,"
	cQuery += " C7_QUANT, C7_PRECO, C7_TOTAL,"
	cQuery += " C2.CTT_DESC01 PC_CC, H2.CTH_DESC01 PC_CLASE_VALOR, C7_CC,"
	cQuery += " C7_QUANT-C7_QUJE CANT_PEND_PC, C7_OBS, Z.NOMBRE PC_USUARIO,"
	cQuery += " COALESCE(D1_DTDIGIT, '') D1_DTDIGIT,D1_ITEM,COALESCE(D1_EMISSAO, '') D1_EMISSAO,F1_ESPECIE TIP_REM_FAC, SD1.D1_DOC, F1_SERIE, D1_QUANT,D1_VUNIT,D1_TOTAL, C3.CTT_DESC01 DOC_CC, H3.CTH_DESC01 DOC_CLASE_VALOR,"
	cQuery += " D1_LOCAL ALMACEN, D1_LOTECTL,"
	cQuery += " E2.VALOR_FACT, E2.SALDO_PAGO, E2.MONEDA, E2.D1_DOC FACTURA, F1_XOBS"
	cQuery += " FROM SC1010 SC1 LEFT JOIN SC7010 SC7"
	cQuery += " ON SC7.D_E_L_E_T_ = ' ' AND C1_FILIAL=C7_FILIAL AND C1_NUM=C7_NUMSC AND C1_ITEM=C7_ITEMSC"
	cQuery += " LEFT JOIN SA2010 SA2 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN SD1010 SD1 ON C1_FILIAL=D1_FILIAL AND C7_NUM=D1_PEDIDO AND C7_ITEM=D1_ITEMPC AND C7_FORNECE=D1_FORNECE AND C7_LOJA=D1_LOJA AND D1_REMITO = ' '"
	cQuery += " AND SD1.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN SF1010 SF1 ON C1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND SF1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN CTT010 c ON C1_CC = CTT_CUSTO AND c.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN CTH010 H ON C1_CLVL = CTH_CLVL AND H.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN (SELECT CR_NUM, MAX(CR_DATALIB) CR_DATALIB FROM SCR010 s WHERE D_E_L_E_T_ = ' ' AND CR_TIPO = 'PC' GROUP BY CR_NUM) CR ON C7_NUM = CR_NUM"
	cQuery += " LEFT JOIN CTT010 C2 ON C7_CC = C2.CTT_CUSTO AND c.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN CTH010 H2 ON C7_CLVL = H2.CTH_CLVL AND H.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN ZUSU Z ON C7_USER = Z.CODUSR"
	cQuery += " LEFT JOIN CTT010 C3 ON D1_CC = C3.CTT_CUSTO AND c.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN CTH010 H3 ON D1_CLVL = H3.CTH_CLVL AND H.D_E_L_E_T_ = ' '"
	cQuery += " LEFT JOIN (SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_PEDIDO, D1_ESPECIE, MAX(E2_VALOR) VALOR_FACT, MAX(E2_SALDO) SALDO_PAGO, MAX(E2_MOEDA) MONEDA"
	cQuery += " 	FROM SD1010 S, SE2010 S2  WHERE S.D_E_L_E_T_ = ' ' AND S2.D_E_L_E_T_ = ' '"
	cQuery += " 	AND D1_DOC = E2_NUM AND D1_SERIE = E2_PREFIXO AND D1_FORNECE = E2_FORNECE AND D1_LOJA = E2_LOJA"
	cQuery += " 	AND D1_ESPECIE = 'NF'"
	cQuery += " 	GROUP BY D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_PEDIDO, D1_ESPECIE) E2"
	cQuery += " 	ON C7_NUM = E2.D1_PEDIDO AND C7_FORNECE = E2.D1_FORNECE AND E2.D1_LOJA = C7_LOJA"
	cQuery += " WHERE C1_EMISSAO BETWEEN '" + DTOS(dFromDate) + "' AND '" + DTOS(dToDate) + "'"
	cQuery += " AND SC1.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY C1_NUM,C1_ITEM"

	TCQuery cQuery New Alias "ALIASQRY"

	//Creando el objeto que irá a generar el contenido del Excel
	oFWMsExcel := FwMsExcelXlsx():New()//FWMsExcelEx():New()

	cTabTitle	:= "Seguimiento S.C."
	cHeaderTitle:= ""//"SOLICITUD DE COMPRAS - PEDIDO DE COMPRAS - DOCUMENTO DE ENTRADA - CUENTAS POR PAGAR"
	oFWMsExcel:AddworkSheet(cTabTitle)
	//Creando la Tabla
	oFWMsExcel:AddTable(cTabTitle,cHeaderTitle)

	//SOLICITUD DE COMPRAS
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_NUM"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_ITEM"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_PRODUTO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_DESCRI"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_UM"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_EMISSAO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_DATPRF"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_QUANT"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("CTT_DESC01"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("CTH_DESC01"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_OBS"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_SOLICIT"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_NOMAPRO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(S.C.) " + getFieldTitle("C1_APROV"),1)

	//PEDIDO DE COMPRAS
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_EMISSAO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("CR_DATALIB"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_NUM"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("A2_NOME"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_UM"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_QUANT"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_PRECO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_TOTAL"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("CTT_DESC01"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("CTH_DESC01"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_CC"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + "CANT_PEND_PC",1)//C7_QUANT-C7_QUJE CANT_PEND_PC
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + getFieldTitle("C7_OBS"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(P.C.) " + "PC_USUARIO",1)//Z.NOMBRE PC_USUARIO

	//DOCUMENTO DE ENTRADA
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_DTDIGIT"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_ITEM"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_EMISSAO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("F1_ESPECIE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_DOC"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("F1_SERIE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_QUANT"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_VUNIT"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_TOTAL"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("CTT_DESC01"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("CTH_DESC01"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_LOCAL"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(D.E.) " + getFieldTitle("D1_LOTECTL"),1)

	//CUENTAS POR PAGAR
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(C.P.) " + getFieldTitle("E2_VALOR"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(C.P.) " + getFieldTitle("E2_SALDO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(C.P.) " + getFieldTitle("E2_MOEDA"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(C.P.) " + getFieldTitle("D1_DOC"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "(C.P.) " + getFieldTitle("F1_XOBS"),1)

	//oFWMsExcel:SetCelBold(.T.)
	//oFWMsExcel:SetCelFrColor("#000000")
	//oFWMsExcel:SetCelBgColor("#7ca1ce")//Cuando se utiliza FWMsExcelEx

	While !(ALIASQRY->(EoF()))

		oFWMsExcel:AddRow(cTabTitle,cHeaderTitle,{;
			ALIASQRY->NUM_SOL_COM,;
			ALIASQRY->C1_ITEM,;
			ALIASQRY->C1_PRODUTO,;
			ALIASQRY->C1_DESCRI,;
			ALIASQRY->C1_UM,;
			IIF(!EMPTY(ALIASQRY->C1_EMISSAO), STOD(ALIASQRY->C1_EMISSAO), ''),;
			IIF(!EMPTY(ALIASQRY->C1_DATPRF), STOD(ALIASQRY->C1_DATPRF), ''),;
			ALIASQRY->C1_QUANT,;
			ALIASQRY->SOL_COM_CC,;
			ALIASQRY->SOL_COM_CLAS,;
			ALIASQRY->C1_OBS,;
			ALIASQRY->C1_SOLICIT,;
			ALIASQRY->APROBADOR,;
			ALIASQRY->C1_APROV,;
			;
			IIF(!EMPTY(ALIASQRY->C7_EMISSAO), STOD(ALIASQRY->C7_EMISSAO), ''),;//15
		IIF(!EMPTY(ALIASQRY->FECHA_LIB), STOD(ALIASQRY->FECHA_LIB), ''),;
			ALIASQRY->NUM_PC,;
			ALIASQRY->A2_NOME,;
			ALIASQRY->C7_UM,;
			ALIASQRY->C7_QUANT,;
			ALIASQRY->C7_PRECO,;
			ALIASQRY->C7_TOTAL,;
			ALIASQRY->PC_CC,;
			ALIASQRY->PC_CLASE_VALOR,;
			ALIASQRY->C7_CC,;
			ALIASQRY->CANT_PEND_PC,;
			ALIASQRY->C7_OBS,;
			ALIASQRY->PC_USUARIO,;//28
		;
			IIF(!EMPTY(ALIASQRY->D1_DTDIGIT), STOD(ALIASQRY->D1_DTDIGIT), ''),;
			ALIASQRY->D1_ITEM,;
			IIF(!EMPTY(ALIASQRY->D1_EMISSAO), STOD(ALIASQRY->D1_EMISSAO), ''),;
			ALIASQRY->TIP_REM_FAC,;
			ALIASQRY->D1_DOC,;
			ALIASQRY->F1_SERIE,;
			ALIASQRY->D1_QUANT,;
			ALIASQRY->D1_VUNIT,;
			ALIASQRY->D1_TOTAL,;
			ALIASQRY->DOC_CC,;
			ALIASQRY->DOC_CLASE_VALOR,;
			ALIASQRY->ALMACEN,;
			ALIASQRY->D1_LOTECTL,;
			;
			ALIASQRY->VALOR_FACT,;//42
		ALIASQRY->SALDO_PAGO,;
			ALIASQRY->MONEDA,;
			ALIASQRY->FACTURA,;
			ALIASQRY->F1_XOBS;//46
		;
			}, {15,16,17,18,19,20,21,22,23,24,25,26,27,28,42,43,44,45,46})

		ALIASQRY->(DbSkip())
	EndDo

	//Activando archivo y generando xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abriendo excel y archivo xml
	oExcel := MsExcel():New()		//Abre una nueva conexión con Excel
	oExcel:WorkBooks:Open(cArquivo)	//Abre una planilla
	oExcel:SetVisible(.T.)			//Visualiza la planilla
	oExcel:Destroy()				//Cierra el proceso de gerenciar tareas

	ALIASQRY->(DbCloseArea())
	RestArea(aArea)
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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De Fecha?", "¿De Fecha?"	,"¿De Fecha?"	,"MV_CH1","D",08,0,0,"G","NaoVazio()","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Fecha?" , "¿A Fecha?"	,"¿A Fecha?"	,"MV_CH2","D",08,0,0,"G","NaoVazio()","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")

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
