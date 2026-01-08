#include "protheus.ch"

/**
*
* @author: Denar Terrazas Parada
* @since: 24/03/2021
* @description: Impresión de Documentos de Entrada y Salida
*				- Entrada: Remitos y Facturas
*				- Salida: Facturas
*/
User Function XDocsEyS()
	Local oReport
	Private cPerg   := "XDocsEyS"   // elija el Nombre de la pregunta

	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Documentos de entrada y salida"

	oReport	 := TReport():New("Documentos",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte " + NombreProg, .T.)

	oSection := TRSection():New(oReport,"Documentos",{"SD1", "SD2"})
	oReport:SetTotalInLine(.F.)

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"B1_COD"		,"SB1", "Producto")
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1")
	TRCell():New(oSection,"B1_UESPEC2"	,"SB1")
	TRCell():New(oSection,"DOCUMENTO"	,"SD1", "Documento")
	TRCell():New(oSection,"SERIE"		,"SD1", "Serie")
	TRCell():New(oSection,"FECHA"		,"SD1", "Fecha")
	TRCell():New(oSection,"TES"			,"SD1", "Tes")
	TRCell():New(oSection,"TIPO"		,"SD1", "Tipo")
	TRCell():New(oSection,"CANTIDAD"	,"SD1", "Cantidad")
	TRCell():New(oSection,"PRECIO"		,"SD1", "Precio")
	TRCell():New(oSection,"TOTAL"		,"SD1", "Total")

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(1)

	#IFDEF TOP
		// Query
		oSection:BeginQuery()
		BeginSql alias "QRYFAC"

		SELECT SB1.B1_COD, SB1.B1_ESPECIF, SB1.B1_UESPEC2,
		SD1.D1_DOC AS DOCUMENTO, SD1.D1_SERIE AS SERIE, SD1.D1_EMISSAO AS FECHA, SD1.D1_TES AS TES, 'ENTRADA' AS TIPO,
		SD1.D1_QUANT AS CANTIDAD, SD1.D1_VUNIT AS PRECIO, SD1.D1_TOTAL AS TOTAL
		FROM %Table:SB1% SB1
		LEFT JOIN %Table:SD1% SD1 ON SB1.B1_COD = SD1.D1_COD AND SD1.D1_TES IN ('001', '021') AND SD1.%notDel%
		WHERE B1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SD1.D1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR03)% AND %Exp:DTOS(MV_PAR04)%
		AND ((SD1.D1_ESPECIE = 'NF' AND SD1.D1_REMITO = '') OR (SD1.D1_ESPECIE <> 'NF'))
		AND SB1.%notDel%
		UNION
		SELECT SB1.B1_COD AS PRODUCTO, SB1.B1_ESPECIF, SB1.B1_UESPEC2,
		SD2.D2_DOC AS DOCUMENTO, SD2.D2_SERIE AS SERIE, SD2.D2_EMISSAO AS FECHA, SD2.D2_TES AS TES, 'SALIDA' AS TIPO,
		SD2.D2_QUANT AS CANTIDAD, SD2.D2_PRCVEN AS PRECIO, SD2.D2_TOTAL AS TOTAL
		FROM %Table:SB1% SB1
		LEFT JOIN %Table:SD2% SD2 ON SB1.B1_COD = SD2.D2_COD AND SD2.%notDel%
		WHERE B1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SD2.D2_EMISSAO BETWEEN %Exp:DTOS(MV_PAR03)% AND %Exp:DTOS(MV_PAR04)%
		AND SD2.D2_ESPECIE = 'NF'
		AND SB1.%notDel%
		ORDER BY FECHA, SB1.B1_COD, TIPO

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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De Produto?" 	, "¿De Producto?"	,"From Product?"	,"MV_CH1","C",15,0,0,"G","","SB1","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Ate Produto?" 	, "¿A Producto?"	,"To Product?"		,"MV_CH2","C",15,0,0,"G","NaoVazio()","SB1","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Fecha?"		, "¿De Fecha?"		,"¿De Fecha?"		,"MV_CH3","D",08,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Fecha?" 		, "¿A Fecha?"		,"¿A Fecha?"		,"MV_CH4","D",08,0,0,"G","NaoVazio()","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

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
