#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPERUT1 ³ Autor ³	Query	: Erick Etcheverry			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reporte TRANSFERENCIA BANCO FASSIL Erick/Nahim			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPERUT1()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ General														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³19/12/2018³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function GPERUT1()
	Local oReport
	PRIVATE cPerg   := "BANFASSI"   // elija el Nombre de la pregunta
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
	Local NombreProg := "GPERUT1"

	oReport	 := TReport():New("GPERUT1",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Trans. B. Fassil")
	//	oReport	 := TReport():New("MovxPer",NombreProg,,{|oReport| PrintReport(oReport)},"MOVIMIENTO POR PERIODO")
	//	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"SB1",{"SB1"})
	oSection2 := TRSection():New(oReport,"SRA",{"SRA"})
	/*
	TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
	TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10)
	*/
	// oSection:SetHeaderPage()  // seleccionar titulo en cabecera
	// oSection2:SetHeaderPage() // seleccionar titulo en cabecera

	//		Comienzan a elegir los campos que desean Mostrar en la seccion de arriba
	/*TRCell():New(oSection,"Convenio"	,"SB1")
	TRCell():New(oSection,"CDEBITO"	,"SB1","Cuenta_debito")
	TRCell():New(oSection,"PRODUTO"		,"SB1")
	TRCell():New(oSection,"MOEDAPAGO"	,"SB1","Moneda Pago")
	TRCell():New(oSection,"IDENTIFIC","SB1","Identificador Planilla")
	TRCell():New(oSection,"FechaAp","SB1","Fecha Aplicación")
	TRCell():New(oSection,"FechaVenc","SB1","Fecha Vencimiento")
	TRCell():New(oSection,"TOTABON","SB1","Total Abonar")
	TRCell():New(oSection,"TIPOPAGO","SB1","Tipo Pago Planilla")
	TRCell():New(oSection,"NROREGISTRO","SB1","Nro.Registro")*/
	// Separa por Lineas vacias
	//oBreak = TRBreak():New(oSection,oSection:Cell("B1_COD"),"QUEBRA")
	//TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)

	// Seleccionamos la segunda seccion
	TRCell():New(oSection2,"CI"	,"SRA","CI") //carnet dpto
	TRCell():New(oSection2,"RA_NOMECMP"	,"SRA","Nombre Beneficiario",) //nombre completo
	TRCell():New(oSection2,"RA_CTDEPSA"	,"SRA","Cuenta de Abono",) //cuenta deposito salario
	TRCell():New(oSection2,"Producto"	,"SRA",,"@E 999") 
	TRCell():New(oSection2,"FechaAplicacion","SRA","Fecha Aplicacion") //FECHA a
	TRCell():New(oSection2,"FormaPago","SRA","Forma de Pago",)
	TRCell():New(oSection2,"Monto","SRA",,"@E 999,999,999,999.99")
	TRCell():New(oSection2,"Referencia","SRA")
	TRCell():New(oSection2,"RA_EMAIL","SRA","Correo",)
	//TRCell():New(oSection,"TOTAL2"     ,"","TOTAL","")

	//FWUSERACCOUNTDATA
Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cFiltro  := ""
	
	
	if MV_PAR13 == 1
		cCodFol = '0006'
	else
		cCodFol = '0047'
	endif
	
	// Query
	oSection2:BeginQuery()
	BeginSql alias "QRYSA2"

		SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RC_PD,RC_HORINFO,%exp:MV_PAR09% Producto,
		rtrim(RA_RG)+ltrim(RA_UFCI) CI,RA_NOMECMP,RA_CTDEPSA,RA_ADMISSA,%exp:DTOC(MV_PAR10)% FechaAplicacion,RA_EMAIL,%exp:MV_PAR11% FormaPago,
		RC_VALOR Monto,RC_HORAS,RC_VALINFO,RC_PERIODO,RC_ROTEIR,%exp:MV_PAR12% Referencia
		from %table:SRV%
		JOIN %table:SRC%
		ON RV_COD = RC_PD AND SRC010.D_E_L_E_T_ = '' AND RC_PERIODO = %exp:MV_PAR03% AND RC_ROTEIR=%exp:MV_PAR02%
		JOIN %table:SRA%
		ON RA_FILIAL = RC_FILIAL and RA_FILIAL BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
		and RA_MAT = RC_MAT AND RA_MAT BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
		AND SRA010.D_E_L_E_T_ = '' and RA_UBANCO = '1' AND RA_CARGO = %exp:MV_PAR14%
		WHERE RV_CODFOL = %exp:cCodFol% AND SRV010.D_E_L_E_T_ = ''

	EndSql
	
	
	
	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	oSection2:EndQuery()

	oSection2:Print()

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

	xPutSx1(cPerg,"01","Processo  ?","¿Proceso  ?","Process   ?","MV_CH1","C",5,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","Roteiro  ?","¿Procedimiento  ?","Procedure  ?","MV_CH2","C",3,0,0,"G","","SRY","","","MV_PAR02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","Periodo  ?","¿Periodo  ?","Period  ?","MV_CH3","C",6,0,0,"G","","RCH","","","MV_PAR03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","Numero de Pagamento  ?","¿Numero Pago  ?","Payment Number ?","MV_CH4","C",2,0,0,"G","","RCH01","","","MV_PAR04",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"05","Filial De ?" , "¿De Sucursal ?", "Branch From ?", "MV_CH5","C",04,0,0,"G","","SM0","033","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","Filial Ate ?" , "¿A Sucursal ?", "Branch to ?", "MV_CH6","C",04,0,0,"G","naovazio()","SM0","033","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"07","Matricula De  ?","¿De Matricula  ?","¿De Matricula  ?","MV_CH7","C",6,0,0,"G","","SRA","","","MV_PAR07",""       ,""            ,""        ,""     ,"SRA","")
	xPutSx1(cPerg,"08","Matricula Até  ?","¿A Matricula  ?","¿A Matricula  ?","MV_CH8","C",6,0,0,"G","","SRA","","","MV_PAR08",""       ,""            ,""        ,""     ,"SRA","")
	xPutSx1(cPerg,"09","Producto","Producto","Producto","MV_CH9","N",3,0,0,"G","","","","","MV_PAR09",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"10","Fecha Aplicacion" , "Fecha Aplicacion","Fecha Aplicacion","MV_CHA","D",08,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"11","¿Forma de Pago?","¿Forma de Pago?","¿Forma de Pago?","MV_CHB","C",1,0,0,"G","","","","","MV_PAR11")
	xPutSx1(cPerg,"12","Referencia","Referencia","Referencia","MV_CHC","C",20,0,0,"G","","","","","MV_PAR12")
	xPutSX1(cPerg,"13","¿Calcula por?"    , "¿Calcula por?","¿Calcula por?" ,"MV_CHD","N",1,0,0,"C","","","","","MV_PAR13","Anticipo","Anticipo","Anticipo","","Liquido pagable","Liquido pagable","Liquido pagable")
	xPutSX1(cPerg,"14","¿Cargo?"    , "¿Cargo?","¿Cargo?" ,"MV_CHE","C",5,0,0,"G","","JURSQ3","","","MV_PAR14","","","","","","","")

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