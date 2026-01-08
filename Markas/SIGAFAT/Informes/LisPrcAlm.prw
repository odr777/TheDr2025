#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPERUT1 ³ Autor ³	Query	: Erick Etcheverry			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reporte Lista precio por stock en almacen y filial     	    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPERUT1()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ General														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³21/12/2018³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function LisPrcAlm()
	Local oReport
	PRIVATE cPerg   := "LISPRCAL"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oSection2
	Local oBreak
	Local NombreProg := "LisPrcAlm"

	oReport	 := TReport():New("LisPrcAlm",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Lista por stock en almacen")
	oSection2 := TRSection():New(oReport,"Lista",{},{})
	//oReport:HideParamPage()

	// Seleccionamos la segunda seccion
	TRCell():New(oSection2,"DA1_CODTAB"	,"DA1","Cod.Lista") //carnet dpto
	TRCell():New(oSection2,"DA0_DESCRI"	,"DA0","Lista precio",) //nombre completo
	TRCell():New(oSection2,"DA1_CODPRO"	,"DA1","Cod.producto",) //cuenta deposito salario
	TRCell():New(oSection2,"B1_DESC"	,"SB1","Producto ")
	TRCell():New(oSection2,"B1_ESPECIF"	,"SB1","Descripcion ")
	TRCell():New(oSection2,"TIPO","SB1","Cod.Marca",)
	TRCell():New(oSection2,"Marca","SB1","Marca",)
	TRCell():New(oSection2,"DA1_PRCVEN","DA1","Precio venta","@E 999,999,999,999.99") //FECHA a
	TRCell():New(oSection2,"B2_QATU","SB2","Stock","@E 999,999,999")
	TRCell():New(oSection2,"B2_LOCAL","SB2","Cod.Almacen",)
	TRCell():New(oSection2,"B2_LOCALIZ","SB2","Almacen")
	TRCell():New(oSection2,"FILIAL","SB2","Cod.sucursal",)
	TRCell():New(oSection2,"Sucursal","SB2","Sucursal",)
	TRCell():New(oSection2,"CDGRUPO","SB1","Cod.Familia",)
	TRCell():New(oSection2,"GRUPO","SB1","Familia",)
	
Return oReport

Static Function PrintReport(oReport)
	Local oSection2 := oReport:Section(1)
	Local cFiltro  := ""
	Local _aAreaSM0 := {}
	dbSelectArea("SM0")
	_aAreaSM0 := SM0->(GetArea())
	
	oSection2:BeginQuery()
	BeginSql alias "QRYSA2"
	
	/*SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RC_PD,RC_HORINFO,%exp:MV_PAR07% Producto,
	rtrim(RA_RG)+ltrim(RA_UFCI) CI,RA_NOMECMP,RA_CTDEPSA,RA_ADMISSA,%exp:MV_PAR08% FechaAplicacion,RA_EMAIL,%exp:MV_PAR09% FormaPago,
	RC_VALOR Monto,RC_HORAS,RC_VALINFO,RC_PERIODO,RC_ROTEIR,%exp:MV_PAR10% Referencia
	from %table:SRV%
	JOIN %table:SRC%
	ON RV_COD = RC_PD AND SRC010.D_E_L_E_T_ = '' AND RC_PERIODO = %exp:MV_PAR03%
	LEFT JOIN %table:SRA%
	ON RA_MAT = RC_MAT AND RA_MAT BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
	AND SRA010.D_E_L_E_T_ = ''
	WHERE RV_CODFOL = %exp:cCodFol% AND SRV010.D_E_L_E_T_ = ''*/

	SELECT DA1_CODTAB,DA0_DESCRI,DA1_CODPRO,SB2.B1_ESPECIF B1_ESPECIF,SB2.B1_DESC B1_DESC,B1_GRUPO CDGRUPO,SB2.B1_TIPO TIPO,DA1_PRCVEN,
	CASE SB2.B2_QATU WHEN 0 THEN '0' ELSE B2_QATU END B2_QATU,SB2.B2_LOCAL B2_LOCAL,SB2.B2_LOCALIZ B2_LOCALIZ,SB2.B2_FILIAL FILIAL
	FROM %table:DA1% DA1
	JOIN %table:DA0% DA0
	ON DA0_CODTAB = DA1_CODTAB AND DA0.D_E_L_E_T_ = ''
	JOIN (
	SELECT B2_FILIAL,B2_COD,B1_GRUPO,B1_ESPECIF,B1_DESC,B1_TIPO,B2_LOCAL,SUM(B2_QATU) B2_QATU,B2_LOCALIZ
	FROM %table:SB2% SB2
	JOIN %table:SB1% SB1
	ON B1_COD = B2_COD AND SB1.D_E_L_E_T_ = ''
	WHERE SB2.D_E_L_E_T_ = '' and B2_FILIAL BETWEEN %exp:mv_par01% AND %exp:mv_par02%
	AND B2_LOCAL BETWEEN %exp:mv_par04% AND %exp:mv_par05%
	GROUP BY B2_LOCAL,B2_LOCALIZ,B2_FILIAL,B2_COD,B1_DESC,B1_ESPECIF,B1_TIPO,B1_GRUPO
	)AS SB2
	on SB2.B2_COD = DA1_CODPRO
	WHERE DA1_CODTAB = %exp:mv_par03% AND DA1.D_E_L_E_T_ = ''
	order BY B2_FILIAL,B2_LOCAL,DA1_CODPRO

	EndSql
	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	
	
	oSection2:EndQuery()

	//oSection2:Print()
	While ! QRYSA2->(EoF())
		oSection2:Init()

		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+QRYSA2->FILIAL,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		oSection2:Cell("Sucursal"):SetBlock({||cNomeSuc}) // actualiza valor
		cMarcaD := Posicione("SX5",1,xFilial("SX5")+"02"+QRYSA2->TIPO ,"X5_DESCRI")
		//oSection2:Cell("Sucursal"):SetValue(cNomeSuc)
		oSection2:Cell("Marca"):SetBlock({||cMarcaD}) // actualiza valor
		cGrupo := Posicione("SBM",1,xFilial("SBM")+QRYSA2->CDGRUPO ,"BM_DESC")
		oSection2:Cell("GRUPO"):SetBlock({||cGrupo}) // actualiza valor
		oSection2:PrintLine()
		SM0->(DBCloseArea())
		QRYSA2->(DbSkip())

	ENDDO
	//restaura la sm0 por el tema de que se ocupa la filial en el sistema
	OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(RestArea(_aAreaSM0))//restaura al area original
	
	oSection2:Finish()
	QRYSA2->(DbCloseArea())
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})   usar este en esste caso cuando es BEGIN SQL
	//Aviso("query",cvaltochar(cQuery),{"si"})
	// MemoWrite("\query_ctxcbxcl.sql",cQuery[2]) usar este en esste caso cuando es BEGIN SQL
	// MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas

	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los 	parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
	// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
	// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado

	//	xPutSx1(cPerg,"01","¿De Fecha?" , "¿De Fecha?","¿De Fecha?","MV_CH1","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	//	xPutSx1(cPerg,"02","¿A Fecha?" , "¿A Fecha?","¿A Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	//	xPutSx1(cPerg,"03","¿Grupo?", "¿Grupo?","¿Grupo?","MV_CH3","C",4,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"SBM","")

	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De Sucursal Origen :","De Sucursal Origen :","De Sucursal Origen :","mv_ch1","C",4,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"SM0","")
	xPutSx1(cPerg,"02","A Sucursal Destino :","A Sucursal Destino :","A Sucursal Destino :","mv_ch2","C",4,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"SM0","")
	xPutSx1(cPerg,"03","Lista de precio :","Lista de precio :","Lista de precio :",         "mv_ch3","C",3,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"DA0","")
	xPutSx1(cPerg,"04","De almacen :","De almacen :","De almacen :",         "mv_ch3","C",2,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"NNR","")
	xPutSx1(cPerg,"05","A almacen :","A almacen :","A almacen :",         "mv_ch3","C",2,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"NNR","")
	//xPutSx1(cPerg,"02","De Sucursal Origen      :","mv_ch2","C",4,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0",""})
	//xPutSx1(cPerg,"03","Lista de precio","mv_ch2","C",4,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0",""})
	/*xPutSx1(cPerg,"03","Periodo  ?","¿Periodo  ?","Period  ?","MV_CH3","C",6,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"RCH","")
	xPutSx1(cPerg,"04","Numero de Pagamento  ?","¿Numero Pago  ?","Payment Number ?","MV_CH4","C",2,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,"RCH01","")
	xPutSx1(cPerg,"05","Matricula De  ?","¿De Matricula  ?","From Registration  ?","MV_CHA","C",6,0,0,"G","","","","","MV_PAR05",""       ,""            ,""        ,""     ,"SRA","")
	xPutSx1(cPerg,"06","Matricula Até  ?","¿A Matricula  ?","To Registration  ?","MV_CHB","C",6,0,0,"G","","","","","MV_PAR06",""       ,""            ,""        ,""     ,"SRA","")
	xPutSx1(cPerg,"07","Producto","Producto","Producto","MV_CHG","N",3,0,0,"G","","","","","MV_PAR07",""       ,""            ,""        ,""     ,"X06","")
	xPutSX1(cPerg,"08","Fecha Aplicacion" , "Fecha Aplicacion","Fecha Aplicacion","MV_CH1","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"09","Forma de Pago?","Forma de Pago?","Forma de Pago?","MV_CHI","C",1,0,0,"G","","","","","MV_PAR09")
	xPutSx1(cPerg,"10","Referencia","Referencia","Referencia","MV_CHI","C",20,0,0,"G","","","","","MV_PAR10")
	xPutSX1(cPerg,"11","Calcula por?"    , "Calcula por?","Calcula por?" ,"MV_CH1","N",8,0,0,"C","","","",""         ,"MV_PAR11","Anticipo","Anticipo","Anticipo","","Liquido pagable","Liquido pagable","Liquido pagable")*/
	//xPutSx1(cPerg,"21","Imprime Bases  ?","¿Imprime Bases  ?","Print Base  ?","MV_CHL","C",1,0,0,"C","","MV_PAR21","Sim","Si","Yes","","","Não","No","No","","","","","","","","","","","","","","","","","","S",""})

	//ValidPerg(aRegs,cPerg,.T.)

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