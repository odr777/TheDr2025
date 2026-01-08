#Include "GPER680.CH"
#Include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QUISX01 ³ Autor ³ Repote	 : Jose Carlos Taborga   			³±±
±±         						 Empresa : TdeP Partner Totvs	    		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reporte de Estado de Quinquenios								³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QUISX01()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jose Carlos              ³19/04/2016³									³±±
±±³Nahim Terrazas 			³25/09/2018³	Modificacion de Query        	³±±
±±³Carlos Egüez 			³25/09/2018³	Modificacion de Reporte        	³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function ReportDef()
	Local oReport
	Local oSection

	Private cPeriodo := ""

	oReport := TReport():New("QUISX01",OemToAnsi( "Detalle de Pagos de Quinquenios"),"QUISX01",{|oReport| QUIUXLSImp(oReport)},OemToAnsi(STR0002+",")+OemToAnsi(STR0003))
	oSection := TRSection():New(oReport,OemToAnsi(STR0001),{"SRA","SRD","SRC"})

	TRCell():New(oSection,"RA_MAT",		"   ", "Matricula",PesqPict("SRA","RA_MAT"))
	TRCell():New(oSection,"RA_FILIAL",	"   ", "Suc.",PesqPict("SRA","RA_FILIAL"))
	TRCell():New(oSection,"RA_NOME",	"   ", "Funcionario",PesqPict("SRA","RA_NOME"),43)
	TRCell():New(oSection,"RA_CC",	    "   ", "C. Costo",PesqPict("SRA","RA_CC"),2)
	TRCell():New(oSection,"RA_ADMISSA",	"   ", "Fec.Ingreso",PesqPict("SRA","RA_ADMISSA"))
	TRCell():New(oSection,"ANTIGUEDAD",	"   ", "Antigüedad")
	TRCell():New(oSection,"QUIN_PAG",	"   ", "Quinq.Pagados")
	TRCell():New(oSection,"SUELD_PROM",	"   ", "Suel.Prom.",PesqPict("SRD","RD_VALOR"))
	TRCell():New(oSection,"IMP_QUIN",	"   ", "Importe.Qui.",PesqPict("SRD","RD_VALOR"))
	TRCell():New(oSection,"FECHAPAGO",	" " , "Fec.Pago",PesqPict("SRA","RA_ADMISSA"),12)
	TRCell():New(oSection,"ACUMFIN",	"   ", "Antig. a Fecha")
	TRCell():New(oSection,"INDENUEVA",	"   ", "Saldo Fecha",PesqPict("SRD","RD_VALOR"))

Return oReport

User Function QUISX01()
	Local cPerg:= "QUISX01"

	CriaSX1(cPerg)
	pergunte(cPerg,.F.)
	oReport:= ReportDef()
	oReport:PrintDialog()
Return

Static Function QUIUXLSImp(lEnd,WnRel,cString)
	LOCAL cFiltro   := ""
	LOCAL cQuery    := ""

	#IFDEF TOP
	MakeSqlExpr("QUISX01")

	oReport:Section(1):BeginQuery()
	cQrySRA  := GetNextAlias()
	BeginSql alias cQrySRA

		SELECT RA_MAT, RA_FILIAL, RA_NOME, RA_CC, RA_ADMISSA,
		DATEDIFF(YEAR, (CONVERT(DATE, RA_ADMISSA, 120)), %Exp:mv_par12%) ANTIGUEDAD,
		QUIN_PAG, SUELD_PROM, IMP_QUIN, SUBSTRING(ULT_PAG,7,2) + '/' + SUBSTRING(ULT_PAG,5,2) + '/' + SUBSTRING(ULT_PAG,1,4) AS FECHAPAGO,
		DATEDIFF(YEAR, (CONVERT(DATE, RA_ADMISSA, 120) ), %Exp:mv_par12%) - ACUMULADO as ACUMFIN,
		(DATEDIFF(YEAR, (CONVERT(DATE, RA_ADMISSA, 120) ), %Exp:mv_par12%) - ACUMULADO) * SUELD_PROM as INDENUEVA

		FROM
		(
		SELECT
		RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CC
		FROM
		%Table:SRA% SRA
		WHERE
		SRA.D_E_L_E_T_ = ' '
		AND RA_FILIAL BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND RA_CC BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND RA_MAT BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND RA_NOME BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND RA_ADMISSA BETWEEN CONVERT(VARCHAR, %Exp:mv_par09%, 112) AND CONVERT(VARCHAR, %Exp:mv_par10%, 112) ) AS SRA,
		(
		SELECT
		RC_FILIAL FILIAL,
		RC_MAT MATQUI,
		RC_VALOR VALOR,
		RC_HORAS QUIN_PAG,
		RC_DATA ULT_PAG,
		COALESCE(
		(
		SELECT SUM(RC_HORAS)
		FROM %Table:SRC% b
		JOIN %Table:SRV% SRV on RC_PD = RV_COD
		WHERE b.R_E_C_N_O_ <= SRC.R_E_C_N_O_
		AND b.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1274'
		AND RC_DATA BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND b.RC_MAT = SRC.RC_MAT
		AND RC_ROTEIR = 'QUI'
		), 0) AS ACUMULADO
		FROM
		%Table:SRC% SRC
		JOIN %Table:SRV% SRV on RC_PD = RV_COD
		WHERE
		SRC.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1274'
		AND RC_DATA BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND RC_ROTEIR = 'QUI'
		UNION
		SELECT
		RD_FILIAL FILIAL,
		RD_MAT MATQUI,
		RD_VALOR VALOR,
		RD_HORAS HORAS,
		RD_DATPGT,
		COALESCE(
		(
		SELECT SUM(RD_HORAS)
		FROM %Table:SRD% b
		JOIN %Table:SRV% SRV on RD_PD = RV_COD
		WHERE b.R_E_C_N_O_ <= SRD.R_E_C_N_O_
		AND b.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1274'
		AND RD_DATPGT BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND b.RD_MAT = SRD.RD_MAT
		AND RD_ROTEIR = 'QUI'
		), 0) AS ACUMULADO
		FROM
		%Table:SRD% SRD 
		JOIN %Table:SRV% SRV on RD_PD = RV_COD
		WHERE
		SRD.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1274'
		AND SRV.D_E_L_E_T_ = ' '
		AND RD_DATPGT BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND RD_ROTEIR = 'QUI'
		)
		A2,
		(
		SELECT
		MATVAL,
		VALOR IMP_QUIN,
		FECHAPAG,
		prd
		FROM
		(
		SELECT
		RC_MAT MATVAL,
		RC_VALOR VALOR,
		RC_HORAS HORAS,
		RC_DATA FECHAPAG,
		RC_PERIODO prd,
		SRC.R_E_C_N_O_
		FROM
		%Table:SRC% SRC
		JOIN %Table:SRV% SRV on RC_PD = RV_COD
		WHERE
		SRC.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1274'
		AND RC_DATA BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND RC_ROTEIR = 'QUI'
		UNION
		SELECT
		RD_MAT MATVAL,
		RD_VALOR VALOR,
		RD_HORAS HORAS,
		RD_DATPGT FECHAPAG,
		RD_PERIODO prd,
		SRD.R_E_C_N_O_
		FROM
		%Table:SRD% SRD
		JOIN %Table:SRV% SRV on RD_PD = RV_COD
		WHERE
		SRD.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1274'
		AND RD_DATPGT BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND RD_ROTEIR = 'QUI'
		)
		A
		)
		A3,
		(
		SELECT
		MATSUELDO,
		XSUELDO SUELD_PROM,
		RC_PERIODO PERIODO
		FROM
		(
		SELECT
		RC_MAT MATSUELDO,
		RC_VALOR XSUELDO,
		RC_HORAS HORASSUE,
		RC_DATA,
		RC_PERIODO,
		SRC.R_E_C_N_O_
		FROM
		%Table:SRC% SRC
		JOIN %Table:SRV% SRV on RC_PD = RV_COD
		WHERE
		SRC.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1273'
		AND RC_DATA BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND RC_ROTEIR = 'QUI'
		UNION
		SELECT
		RD_MAT MATSUELDO,
		RD_VALOR XSUELDO,
		RD_HORAS HORASSUE,
		RD_DATPGT,
		RD_PERIODO,
		SRD.R_E_C_N_O_
		FROM
		%Table:SRD% SRD
		JOIN %Table:SRV% SRV on RD_PD = RV_COD
		WHERE
		SRD.D_E_L_E_T_ = ' '
		AND SRV.D_E_L_E_T_ = ' '
		AND RV_CODFOL='1273'
		AND RD_DATPGT BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND RD_ROTEIR = 'QUI'
		)
		A
		)
		A4
		WHERE
		RA_MAT = MATQUI
		AND RA_MAT = MATVAL
		AND FILIAL = RA_FILIAL
		AND RA_MAT = MATSUELDO
		AND FECHAPAG = ULT_PAG
		AND PERIODO = prd
		ORDER BY
		RA_MAT, FECHAPAGO
	EndSql

	oReport:Section(1):EndQuery("")
	TRPosition():New(oReport:Section(1),"SRA",1,"xFilial()")
	#ENDIF

	//cQuery:=GetLastQuery()
	//Aviso("",cQuery[2],{"Ok"},,,,,.T.)

	oReport:Section(1):Print()
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros
	//³ mv_par01                  De Sucursal ?
	//³ mv_par02                  A Sucursal ?
	//³ mv_par03                  De Centro de Costo ?
	//³ mv_par04                  A Centro de Costo ?
	//³ mv_par05                  De Matricula ?
	//³ mv_par06                  A Matricula ?
	//³ mv_par07                  De Nombre ?
	//³ mv_par08                  A Nombre ?
	//³ mv_par09                  De ingreso ?
	//³ mv_par10                  De ingreso ?
	//³ mv_par11                  De Fecha de Pago ?
	//³ mv_par12                  A Fecha de Pago ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xPutSX1(cPerg,"01","De Sucursal ?","De Sucursal ?","De Sucursal ?","MV_CH1","C",4,0,0,"G","","SM0","","","mv_par01","","","","","","")
	xPutSX1(cPerg,"02","A Sucursal ?","A Sucursal ?","A Sucursal ?","MV_CH2","C",4,0,0,"G","","SM0","","","mv_par02","","","","","","")
	xPutSX1(cPerg,"03","De Centro de Costo ?","De Centro de Costo ?","De Centro de Costo ?","MV_CH3","C",11,0,0,"G","","CTT","","","mv_par03","","","","","","")
	xPutSX1(cPerg,"04","A Centro de Costo ?","A Centro de Costo ?","A Centro de Costo ?","MV_CH4","C",11,0,0,"G","","CTT","","","mv_par04","","","","","","")
	xPutSX1(cPerg,"05","De Matricula ?","De Matricula ?","De Matricula ?","MV_CH5","C",6,0,0,"G","","SRA","","","mv_par05","","","","","","")
	xPutSX1(cPerg,"06","A Matricula ?","A Matricula ?","A Matricula ?","MV_CH6","C",6,0,0,"G","","SRA","","","mv_par06","","","","","","")
	xPutSX1(cPerg,"07","De Nombre ?","De Nombre ?","De Nombre ?","MV_CH7","C",30,0,0,"G","","","","","mv_par07","","","","","","")
	xPutSX1(cPerg,"08","A Nombre ?","A Nombre ?","A Nombre ?","MV_CH8","C",30,0,0,"G","","","","","mv_par08","","","","","","")
	xPutSX1(cPerg,"09","De Fecha de Ingreso ?","De Fecha de Ingreso ?","De Fecha de Ingreso ?","MV_CH9","D",8,0,0,"G","","","","","mv_par09","","","","","","")
	xPutSX1(cPerg,"10","A Fecha de Ingreso ?","A Fecha de Ingreso ?","A Fecha de Ingreso ?","MV_CHA","D",8,0,0,"G","","","","","mv_par10","","","","","","")
	xPutSX1(cPerg,"11","De Fecha de Pago ?","De Fecha de Pago ?","De Fecha de Pago ?","MV_CHB","D",8,0,0,"G","","","","","mv_par11","","","","","","")
	xPutSX1(cPerg,"12","A Fecha de Pago ?","A Fecha de Pago ?","A Fecha de Pago ?","MV_CHC","D",8,0,0,"G","","","","","mv_par12","","","","","","")
	
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