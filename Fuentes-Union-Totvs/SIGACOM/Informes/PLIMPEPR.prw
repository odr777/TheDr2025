#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  PLIMPEPR ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
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

User Function PLIMPEPR()
	Local aArea        := GetArea()
	Local cQuery        := ""
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := GetTempPath()+'PLIMPEPR.xml'
	PRIVATE cPerg   := "IMPPERG"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	cQuery:= " SELECT DBB_DOC,C1_QUANT,DBB_MOEDA,DBB_HAWB,DBB_LOJA,A2_NOME,DBB_SIMBOL,DBB_FORNEC,DBB_TXMOED,DBC_CODPRO,DBC_DESCRI,DBC_QUANT,DBC_PRECO,DBC_TOTAL, "
	cQuery+= " DBC_VLDESC,'CANT REC,BAJA CC','VAL REC,MOV INT SOBRANT','va alm,100%invoice',B2_CM2,B2_CM1,A2_UCODFAB,DBA_ORIGEM "
	cQuery+= " FROM " + RetSQLname('DBB') + " DBB JOIN " + RetSQLname('DBC') + " DBC "
	cQuery+= " ON DBC_HAWB = DBB_HAWB AND DBC_FILIAL = DBB_FILIAL AND DBC.D_E_L_E_T_ = ' ' AND DBB_ITEM = DBC_ITDOC AND LEN(LTRIM(RTRIM(DBC_ITEMPC)))> 0 "
	cQuery+= " LEFT JOIN " + RetSQLname('SB2') + " SB2 "
	cQuery+= " ON B2_LOCAL = DBC_LOCAL AND DBC_CODPRO = B2_COD AND SB2.D_E_L_E_T_ = '' AND B2_FILIAL = DBC_FILIAL "
	cQuery += " LEFT JOIN " + RetSqlName("SC7") + " SC7 "
	cQuery += "	ON DBC_PEDIDO = C7_NUM AND C7_FILIAL = DBC_FILIAL AND DBC_CODPRO = C7_PRODUTO AND DBC_ITEMPC = C7_ITEM AND SC7.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SC1") + " SC1 "
	cQuery += "	ON C7_NUMSC = C1_NUM  AND C1_ITEM = C7_ITEMSC AND C7_FILIAL = C1_FILIAL AND C1_PRODUTO = C7_PRODUTO AND C7_FORNECE = C1_FORNECE AND SC7.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += " JOIN " + RetSqlName("DBA") + " DBA "
	cQuery += "	ON DBB_FILIAL = DBA_FILIAL AND DBA_HAWB = DBB_HAWB AND DBA.D_E_L_E_T_ = '' "
	cQuery+= " WHERE DBB_TIPONF = '5' AND DBB_HAWB BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
	cQuery+= " AND DBB_FILIAL = '" + MV_PAR03 + "' AND DBB.D_E_L_E_T_ = ' ' ORDER BY DBC_ITEMPC"

	TCQuery cQuery New Alias "QRYPRO"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
	//Objeto excel
	oFWMsExcel := FWMSExcel():New()

	//anhade hoja
	oFWMsExcel:AddworkSheet("Detalle Productos")
	//creando tabla
	oFWMsExcel:AddTable("Detalle Productos","Productos")
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Codigo",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Descripcion",1)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Cant Req",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Cant Fact",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Precio",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Descto",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Valor Fact",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Valor Alm",2)
	oFWMsExcel:AddColumn("Detalle Productos","Productos","Costo Unit",2)

	aInterna = getInterna(QRYPRO->DBB_HAWB,QRYPRO->DBB_TXMOED)

	While !(QRYPRO->(EoF()))
		nValAlm := iif(MV_PAR04 == 1,(QRYPRO->DBC_PRECO*(QRYPRO->DBB_TXMOED*(aInterna[2]/100)))+;
		(QRYPRO->DBC_PRECO*QRYPRO->DBB_TXMOED),(QRYPRO->DBC_PRECO*(aInterna[1]/100))+QRYPRO->DBC_PRECO)

		oFWMsExcel:AddRow("Detalle Productos","Productos",{;
		QRYPRO->DBC_CODPRO,;
		QRYPRO->DBC_DESCRI,;
		QRYPRO->C1_QUANT,;
		QRYPRO->DBC_QUANT,;
		QRYPRO->DBC_PRECO,;
		QRYPRO->DBC_VLDESC,;
		QRYPRO->DBC_TOTAL,;
		nValAlm,;
		0;
		})

		QRYPRO->(DbSkip())
	EndDo

	//activando y generando
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//abriendo excel
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cArquivo)//abre planilla
	oExcel:SetVisible(.T.)                 //Visualiza a planilla
	oExcel:Destroy()                        //cierra processo

	QRYPRO->(DbCloseArea())
	RestArea(aArea)
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De documento ?","De documento ?","De documento ?","mv_ch1","C",17,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A documento ?","A documento ?","A documento ?","mv_ch2","C",17,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","Sucursal ?","Sucursal ?","Sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	//xPutSx1(cPerg,"04","A sucursal ?","A sucursal ?","A sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	/*xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")*/
	xPutSX1(cPerg,"04","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par04","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")

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

static function getInterna(cHawb,nMoed)
	Local aArea := GetArea()
	Local cQuery	:= ""
	Local aCpiCpa := {}

	If Select("VW_CPI") > 0
		dbSelectArea("VW_CPI")
		dbCloseArea()
	Endif

	BeginSql Alias "VW_CPI"

		SELECT 'GASTO' AS TIPO,''DBB_DOC,''DBB_EMISSA,SUM(DBC_TOTAL)DBC_TOTAL,1 DBB_MOEDA,'Bs' DBB_SYMBOL,1 DBB_TXMOED,sum(DBC_VLIMP1) DBC_VLIMP1
		FROM (SELECT CASE DBB_TIPONF WHEN 'A' THEN 'GASTO' END AS TIPO ,
		DBB_DOC,DBB_EMISSA,DBC_TOTAL*DBB_TXMOED AS DBC_TOTAL,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,DBC_VLIMP1 * DBB_TXMOED AS DBC_VLIMP1
		FROM %table:DBC% DBC
		JOIN %table:DBB% DBB
		ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF IN ('A')
		AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.%notDel%
		WHERE DBC_HAWB BETWEEN %Exp:cHawb% AND %Exp:cHawb%
		AND DBC.%notDel%  AND DBC_TES <> 330)TB
		UNION
		SELECT 'DUA' AS TIPO ,DBB_DOC,DBB.DBB_EMISSA,SUM(DBC_UVALDU)DBC_TOTAL,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,0
		FROM %table:DBC% DBC
		JOIN %table:DBB% DBB
		ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF IN ('D')
		AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.%notDel%
		WHERE DBC_HAWB BETWEEN %Exp:cHawb% AND %Exp:cHawb%
		AND DBC.%notDel%  AND DBC_TES <> 330
		GROUP BY DBB_DOC,DBB_EMISSA,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED
		UNION
		SELECT 'FOB' AS TIPO,DBB.DBB_DOC,DBB.DBB_EMISSA,SUM(DBC.DBC_TOTAL) DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED,0
		FROM %table:DBC% DBC
		JOIN %table:DBB% DBB
		ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF IN ('5')
		AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.%notDel%
		WHERE DBC_HAWB BETWEEN %Exp:cHawb% AND %Exp:cHawb%
		AND DBC.%notDel%  AND DBC_TES <> 330
		GROUP BY DBB_DOC,DBB_EMISSA,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED
	EndSql

	aLastQuery    := GetLastQuery()
	cLastQuery    := aLastQuery[2]

	//Aviso("CPA",cLastQuery,{'ok'},,,,,.t.)

	nTotFob := 0//$
	nTotGas := 0//BS
	nTotDua := 0//BS
	nTotIv := 0

	While ! VW_CPI->(EoF())

		if 'FOB' $ VW_CPI->TIPO
			nTotFob += VW_CPI->DBC_TOTAL
		endif
		if 'GASTO' $ VW_CPI->TIPO
			nTotGas += VW_CPI->DBC_TOTAL
			nTotIv += VW_CPI->DBC_VLIMP1
		endif
		if 'DUA' $ VW_CPI->TIPO
			nTotDua += VW_CPI->DBC_TOTAL
		endif

		VW_CPI->(DbSkip())
	EndDo

	//ALERT(nTotFob)

	//alert(nTotGas)

	//alert(nTotDua)

	//CALCULO CPI

	nGas := nTotGas

	nTotGas := (nGas + nTotDua)/nMoed

	nTotGas = nTotGas + nTotFob

	nTotGas = nTotGas/nTotFob

	nTotGas = nTotGas - 1

	nCPI = nTotGas*100 // $us CPI

	//CALCULO CPA

	//alert()

	nTotGas := (nGas- nTotIv)/nMoed

	nTotGas = nTotGas  + nTotFob

	nTotGas = nTotGas/nTotFob

	nTotGas = nTotGas - 1

	nCPA = nTotGas*100 // $us CPI

	AADD(aCpiCpa,nCPI)
	AADD(aCpiCpa,nCPA)

	VW_CPI->(DbCloseArea())
	RestArea(aArea)

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return aCpiCpa