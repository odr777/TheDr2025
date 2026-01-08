#include "protheus.ch"
#Include "TopConn.ch"

/**
* @author: Nain Terrazas
* @since: 15/11/2022
* @description: Informe de Kardex de CxP.
*/
User Function KardexCxP()
	Private cPerg       := "KardexCxP"// elija el Nombre de la pregunta

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
/*	Local dFromDate := MV_PAR01
	Local dToDate   := MV_PAR02
    */
	Local cDeProved	:= MV_PAR01
	Local cAProved	:= MV_PAR02
	Local cDeTienda	:= MV_PAR03
	Local cATienda	:= MV_PAR04
	Local oFWMsExcel
	Local oExcel

//	cArquivo:= GetTempPath()+"KardexCxP " + DTOS(dFromDate) + "-" + DTOS(dToDate) + " " + cTime + ".xlsx"

cArquivo:= GetTempPath()+"KardexCxP " + cDeProved + "-" + cAProved + " " + cTime + ".xlsx"

	cQuery := " SELECT E2_FILIAL, E2_FILORIG, D_E_L_E_T_ BORRADO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_SITUACA, "
	cQuery += " SUBSTRING(EMISSAO,7,2)+'/'+SUBSTRING(EMISSAO,5,2)+'/'+SUBSTRING(EMISSAO,1,4) F_EMISSAO, "
	cQuery += " TIPO, E2_PREFIXO, E2_NUM, ORDPAGO, DEBITO, CREDITO, "
	cQuery += " SUM(ACUM) OVER (PARTITION BY E2_FORNECE ORDER BY E2_FORNECE, EMISSAO, R_E_C_N_O_ ) AS ACUM, "
	cQuery += " SUBSTRING(E2_VENCTO,7,2)+'/'+SUBSTRING(E2_VENCTO,5,2)+'/'+SUBSTRING(E2_VENCTO,1,4) E2_VENCTO, "
	cQuery += " E2_MOEDA, E2_TXMOEDA, "
	cQuery += " E2_VLCRUZ, E2_SALDO, E2_ORIGEM, NODIA, TAB_ORI, R_E_C_N_O_, GLOSA "
	cQuery += " FROM "
	cQuery += " ( "
	cQuery += " SELECT E2_FILIAL, E2_FILORIG, S.D_E_L_E_T_, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_SITUACA, E2_EMISSAO EMISSAO, 'E2-'+E2_TIPO TIPO, E2_PREFIXO, E2_NUM, ' ' ORDPAGO, "
	cQuery += " CASE WHEN E2_TIPO IN('PA','NCP') THEN 0 ELSE E2_VALOR END DEBITO, "
	cQuery += " CASE WHEN E2_TIPO IN('PA','NCP') THEN E2_VALOR ELSE 0 END CREDITO, "
	cQuery += " (CASE WHEN E2_TIPO IN('PA','NCP') THEN -1 ELSE 1 END*E2_VALOR) AS ACUM, "
	cQuery += " E2_VENCTO, E2_MOEDA, E2_TXMOEDA, E2_VLCRUZ, E2_SALDO, E2_ORIGEM, "
	cQuery += " CASE WHEN LTRIM(ISNULL(E2_NODIA, '')+ISNULL(F1_NODIA, '')) <> ' ' THEN LTRIM(ISNULL(E2_NODIA, '')+ISNULL(F1_NODIA, '')) ELSE "
	cQuery += " 	(SELECT MAX(F1_NODIA) FROM SF1010 s "
	cQuery += " 	WHERE D_E_L_E_T_ = ' ' AND F1_DOC = E2_NUM AND F1_SERIE LIKE E2_PREFIXO AND F1_FORNECE = E2_FORNECE AND F1_LOJA LIKE E2_LOJA) END NODIA, "
	cQuery += " 'SE2' TAB_ORI, S.R_E_C_N_O_, "
	cQuery += " CASE WHEN LTRIM(ISNULL(E2_XGLOSA, '')+ISNULL(F1_XOBS, '')) <> ' ' THEN LTRIM(ISNULL(E2_XGLOSA, '')+ISNULL(F1_XOBS, '')) ELSE "
	cQuery += " 	(SELECT MAX(F1_XOBS) FROM SF1010 s "
	cQuery += " 	WHERE D_E_L_E_T_ = ' ' AND F1_DOC = E2_NUM AND F1_SERIE LIKE E2_PREFIXO AND F1_FORNECE = E2_FORNECE AND F1_LOJA LIKE E2_LOJA) END GLOSA "
	cQuery += " FROM SE2010 S LEFT JOIN SF1010 F ON(S.D_E_L_E_T_= ' ' AND F.D_E_L_E_T_ = ' ' AND E2_FILORIG = F1_FILIAL AND E2_FORNECE = F1_FORNECE AND E2_LOJA = F1_LOJA "
	cQuery += " 	AND E2_PREFIXO = F1_SERIE AND E2_NUM = F1_DOC ) "
	cQuery += " WHERE S.D_E_L_E_T_ = ' ' AND E2_FILIAL = '0101' "
	cQuery += " AND E2_FORNECE BETWEEN '"+trim(mv_par01)+"' and '"+trim(mv_par02)+"' "
	cQuery += " AND E2_LOJA BETWEEN '"+trim(mv_par03)+"' and '"+trim(mv_par04)+"' "
	cQuery += " AND E2_ORIGEM IN('MATA100', 'FINA050', 'FINA565 ', '        ') "
	cQuery += " UNION "
	cQuery += " SELECT EK_FILIAL, EK_FILIAL, S.D_E_L_E_T_, EK_FORNECE, EK_LOJA, A2_NREDUZ, EK_CANCEL, EK_EMISSAO EMISSAO, 'EK-'+EK_TIPODOC+'-'+EK_TIPO TIPO, EK_PREFIXO, EK_NUM, EK_ORDPAGO, "
	cQuery += " CASE WHEN EK_CANCEL = 'T' THEN EK_VLMOED1 ELSE 0 END DEBITO, EK_VLMOED1 CREDITO, "
	cQuery += " (CASE WHEN EK_CANCEL = 'T' THEN EK_VLMOED1 ELSE 0 END - EK_VLMOED1) AS ACUM, "
	cQuery += " ' ' VENCIMIENTO, EK_MOEDA, EK_TXMOE02, EK_VLMOED1, EK_SALDO, 'ORDPAG' ORIGEN, EK_NODIA, 'SEK' TAB_ORI, S.R_E_C_N_O_, EK_UGLOSA "
	cQuery += " FROM SEK010 S LEFT JOIN SA2010 A2 ON ( A2.D_E_L_E_T_ = ' ' AND EK_FORNECE = A2_COD AND EK_LOJA = A2_LOJA) "
	cQuery += " WHERE "
	cQuery += " EK_FORNECE BETWEEN '"+trim(mv_par01)+"' and '"+trim(mv_par02)+"' "
	cQuery += " AND EK_LOJA BETWEEN '"+trim(mv_par03)+"' and '"+trim(mv_par04)+"' "
	cQuery += " AND EK_TIPODOC IN('CP') "
	cQuery += " UNION "
	cQuery += " SELECT EK_FILIAL, EK_FILIAL, S.D_E_L_E_T_, EK_FORNECE, EK_LOJA, A2_NREDUZ, EK_CANCEL, EK_EMISSAO EMISSAO, 'EK-'+EK_TIPODOC+'-'+EK_TIPO TIPO, EK_PREFIXO, EK_NUM, EK_ORDPAGO, "
	cQuery += " EK_VLMOED1 DEBITO, "
	cQuery += " EK_VLMOED1 CREDITO, "
	cQuery += " (EK_VLMOED1 - EK_VLMOED1) AS ACUM, "
	cQuery += " ' ' VENCIMIENTO, EK_MOEDA, EK_TXMOE02, EK_VLMOED1, EK_SALDO, 'ORDPAG' ORIGEN, "
	cQuery += " CASE WHEN EK_NODIA <> ' ' THEN EK_NODIA ELSE (SELECT MAX(EK_NODIA) "
	cQuery += " 	FROM SEK010 WHERE D_E_L_E_T_ = ' ' AND EK_FILIAL = S.EK_FILIAL AND EK_ORDPAGO = S.EK_ORDPAGO) END EK_NODIA, "
	cQuery += " 'SEK' TAB_ORI, S.R_E_C_N_O_, "
	cQuery += " CASE WHEN EK_UGLOSA <> ' ' THEN EK_UGLOSA ELSE (SELECT MAX(EK_UGLOSA) "
	cQuery += " 	FROM SEK010 WHERE D_E_L_E_T_ = ' ' AND EK_FILIAL = S.EK_FILIAL AND EK_ORDPAGO = S.EK_ORDPAGO) END EK_UGLOSA "
	cQuery += " FROM SEK010 S LEFT JOIN SA2010 A2 ON ( A2.D_E_L_E_T_ = ' ' AND EK_FORNECE = A2_COD AND EK_LOJA = A2_LOJA) "
	cQuery += " WHERE "
	cQuery += " EK_FORNECE BETWEEN '"+trim(mv_par01)+"' and '"+trim(mv_par02)+"' "
	cQuery += " AND EK_LOJA BETWEEN '"+trim(mv_par03)+"' and '"+trim(mv_par04)+"' "
	cQuery += " AND EK_TIPODOC IN('TB') AND EK_TIPO IN('PA') "
	cQuery += " UNION "
	cQuery += " SELECT E5_FILIAL, E5_FILORIG, D_E_L_E_T_, E5_CLIFOR, E5_LOJA, E5_BENEF, E5_SITUACA, E5_DATA FECHA, 'E5-'+E5_TIPO+'-'+E5_TIPODOC TIPO, E5_PREFIXO, E5_NUMERO, E5_DOCUMEN, "
	cQuery += " CASE WHEN (E5_DOCUMEN = ' ' OR E5_ORIGEM IN('FINA565 ')) AND E5_RECPAG IN('P') AND E5_SITUACA <> 'C' THEN 0 ELSE E5_VALOR END DEBITO, "
	cQuery += " CASE WHEN E5_RECPAG IN('P') OR E5_SITUACA = 'C' THEN E5_VALOR ELSE 0 END CREDITO, "
	cQuery += " (CASE WHEN (E5_DOCUMEN = ' ' OR E5_ORIGEM IN('FINA565 ')) AND E5_RECPAG IN('P') AND E5_SITUACA <> 'C' THEN 0 ELSE E5_VALOR END) - "
	cQuery += " 	(CASE WHEN E5_RECPAG IN('P') OR E5_SITUACA = 'C' THEN E5_VALOR ELSE 0 END) ACUMUL, "
	cQuery += " ' ' VENCIMIENTO, E5_MOEDA, E5_TXMOEDA, E5_VALOR, 0 SALDO, E5_ORIGEM, E5_NODIA, 'SE5' TAB_ORI, R_E_C_N_O_, E5_HISTOR "
	cQuery += " FROM SE5010 s WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND E5_CLIFOR BETWEEN '"+trim(mv_par01)+"' and '"+trim(mv_par02)+"' "
	cQuery += " AND E5_LOJA BETWEEN '"+trim(mv_par03)+"' and '"+trim(mv_par04)+"' "
	cQuery += " AND ((E5_RECPAG IN('P')) OR (E5_RECPAG IN('R') AND E5_ORIGEM IN('FINA450'))) "
	cQuery += " AND E5_ORIGEM IN('FINA450','FINA050', 'FINA565 ') "
	cQuery += " ) AS AA "
	cQuery += " ORDER BY E2_FORNECE, EMISSAO, TAB_ORI, R_E_C_N_O_ "

	If FwIsAdmin() // si está en el grupo de administradores
		Aviso("",cQuery,{'ok'},,,,,.t.)
	endif

	TCQuery cQuery New Alias "ALIASQRY"

	//Creando el objeto que irá a generar el contenido del Excel
	oFWMsExcel := FwMsExcelXlsx():New()//FWMsExcelEx():New()

	cTabTitle	:= "Kardex CxP"
	cHeaderTitle:= ""//"KARDEX CXP"
	oFWMsExcel:AddworkSheet(cTabTitle)
	//Creando la Tabla
	oFWMsExcel:AddTable(cTabTitle,cHeaderTitle)

	//CXP
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_FILIAL"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_FILORIG"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "Borrado",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_FORNECE"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_LOJA"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_NOMFOR"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_SITUACA"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_EMISSAO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "TIPO",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "PREF/SERIE",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "NUM_DOC",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "ORD_PAGO",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "DEBITO",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "CREDITO",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "ACUM",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, getFieldTitle("E2_VENCTO"),1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "MONEDA",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "TC",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "BS_ORI",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "SALDO",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "ORIGEN",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "CONTAB.",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "TAB_ORI",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "ID REG",1)
	oFWMsExcel:AddColumn(cTabTitle,cHeaderTitle, "GLOSA",1)

	//oFWMsExcel:SetCelBold(.T.)
	//oFWMsExcel:SetCelFrColor("#000000")
	//oFWMsExcel:SetCelBgColor("#7ca1ce")//Cuando se utiliza FWMsExcelEx

	While !(ALIASQRY->(EoF()))

		oFWMsExcel:AddRow(cTabTitle,cHeaderTitle,{;
			ALIASQRY->E2_FILIAL,;
			ALIASQRY->E2_FILORIG,;
			ALIASQRY->BORRADO,;
			ALIASQRY->E2_FORNECE,;
			ALIASQRY->E2_LOJA,;
			ALIASQRY->E2_NOMFOR,;
			ALIASQRY->E2_SITUACA,;
			ALIASQRY->F_EMISSAO,;
			ALIASQRY->TIPO,;
			ALIASQRY->E2_PREFIXO,;
			ALIASQRY->E2_NUM,;
			ALIASQRY->ORDPAGO,;
			ALIASQRY->DEBITO,;
			ALIASQRY->CREDITO,;
			ALIASQRY->ACUM,;
			ALIASQRY->E2_VENCTO,;
			ALIASQRY->E2_MOEDA,;
			ALIASQRY->E2_TXMOEDA,;
			ALIASQRY->E2_VLCRUZ,;
			ALIASQRY->E2_SALDO,;
			ALIASQRY->E2_ORIGEM,;
			ALIASQRY->NODIA,;
			ALIASQRY->TAB_ORI,;
			ALIASQRY->R_E_C_N_O_,;
			ALIASQRY->GLOSA;
		;
			}, {})

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
	/*
    xPutSX1(cPerg,"01","¿De Fecha?", "¿De Fecha?"	,"¿De Fecha?"	,"MV_CH1","D",08,0,0,"G","NaoVazio()","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Fecha?" , "¿A Fecha?"	,"¿A Fecha?"	,"MV_CH2","D",08,0,0,"G","NaoVazio()","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
    */

    xPutSX1(cPerg,"01","De Fornecedor ?" 		, "¿De Proveedor?"			,"From Provider?"		,"MV_CHS","C",06,0,0,"G","","SA2","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","Ate Fornecedor ?" 		, "¿A Proveedor?"			,"To Provider?"			,"MV_CHT","C",06,0,0,"G","","SA2","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"03","De Loja ?" 				, "¿De Tienda?"				,"From Store?"			,"MV_CHU","C",02,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","Ate Loja ?" 			, "¿A Tienda?"				,"To Store?"			,"MV_CHV","C",02,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

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
