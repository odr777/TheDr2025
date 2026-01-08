#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  LIPREXML ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Excel de importacion FOB despacho producto              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LIPREXML()
	Local aArea        := GetArea()
	Local cQuery        := ""
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := GetTempPath()+'LIPREXML.xml'
	PRIVATE cPerg   := "LIPRE2ML"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	If Select("VW_DA1PRD") > 0
		dbCloseArea()
	Endif

	cQuery:= " SELECT B1_COD,B1_UCODFAB,ISNULL((SELECT ZMA_DESCRI FROM " + RetSQLname('ZMA') + " ZMA WHERE ZMA_CODIGO = B1_UMARCA AND ZMA.D_E_L_E_T_ = ''), '') ZMA_DESCRI,B1_ESPECIF,B1_UESPEC2,B1_UM,DA1_MOEDA, "///cabecera
	cQuery+= " CASE DA1_MOEDA WHEN 1 "
	cQuery+= "   THEN CASE 1 WHEN 1 THEN isnull(DA1_PRCVEN,0) "
	cQuery+= "   ELSE isnull(DA1_PRCVEN,0)/M2_MOEDA5 END "
	cQuery+= " WHEN 2  "
	cQuery+= "   THEN CASE DA1_MOEDA WHEN 1 THEN isnull(DA1_PRCVEN,0)  "
	cQuery+= "   ELSE isnull(DA1_PRCVEN,0)*M2_MOEDA5 END  "
	cQuery+= " ELSE 0 END DA1_PRCVEN,B1_BITMAP "
	cQuery+= " FROM " + RetSQLname('SB1') + " SB1 LEFT JOIN " + RetSQLname('DA1') + " DA1 ON B1_COD = DA1_CODPRO AND DA1_CODTAB = '001' AND DA1.D_E_L_E_T_ = '' "
	cQuery+= " JOIN " + RetSQLname('SM2') + " SM2 ON M2_DATA = '" + DTOS(dDataBase) + "' AND SM2.D_E_L_E_T_ = '' "
	cQuery+= " AND B1_TIPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery+= " AND B1_UMARCA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery+= " AND B1_GRUPO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND SB1.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_DA1PRD"

	oFWMsExcel := FWMSExcel():New()

	//anhade hoja
	oFWMsExcel:AddworkSheet("Detalle Productos")
	//creando tabla
	oFWMsExcel:AddTable("Detalle Productos","Productos")
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Codigo",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Codigo Fabrica",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Marca",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Precio Bs",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Un Medida",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Desc. Especif",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Especif 2",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Descuento",2)

	While !(VW_DA1PRD->(EoF()))

		///agragamos fila a fila
		oFWMsExcel:AddRow("Detalle Productos","Productos",{;
			VW_DA1PRD->B1_COD,;
			VW_DA1PRD->B1_UCODFAB,;
			VW_DA1PRD->ZMA_DESCRI,;
			VW_DA1PRD->DA1_PRCVEN-(VW_DA1PRD->DA1_PRCVEN *(mv_par07/100)),;
			VW_DA1PRD->B1_UM,;
			VW_DA1PRD->B1_ESPECIF,;
			VW_DA1PRD->B1_UESPEC2,mv_par07})

		VW_DA1PRD->(DbSkip())
	EndDo

	//activando y generando
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//abriendo excel
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cArquivo)//abre planilla
	oExcel:SetVisible(.T.)                 //Visualiza a planilla
	oExcel:Destroy()                        //cierra processo

	VW_DA1PRD->(DbCloseArea())
	RestArea(aArea)
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De Grupo ?","De Grupo ?","De Grupo ?","mv_ch1","C",4,0,0,"G","","SBM","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Grupo ?","A Grupo ?","A Grupo ?","mv_ch2","C",4,0,0,"G","","SBM","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De Tipo?","De Tipo ?","De Tipo ?",         "mv_ch3","C",2,0,0,"G","","02","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A Tipo ?","A Tipo ?","A Tipo ?",         "mv_ch3","C",2,0,0,"G","","02","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Marca ?","De Marca ?","De Marca ?",         "mv_ch3","C",3,0,0,"G","","ZMA","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Marca ?","A Marca ?","A Marca ?",         "mv_ch3","C",3,0,0,"G","","ZMA","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"07","Descuento % ?" , "Descuento % ?" ,"Descuento % ?" ,"MV_CH4","N",3,0,0,"C","","","","","mv_par07","","","","","","","")

	//xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")*/

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
