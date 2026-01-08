#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE HBCODFOL	"0031"//Haber básico
#DEFINE BACODFOL	"0671"//BOno de antiguedad
#DEFINE CODDOMIN	"0779"//Dominical
#DEFINE PDLIQRET	"995"//Liquido pagable RETROACTIVO

#DEFINE AFPVEJEZ	"0728"//AFP L/VEJEZ 10%
#DEFINE AFPRIESGO	"0729"//AFP L/ RIESGO 1.71%
#DEFINE AFPCOMIS05	"0730"//AFP L/ COMISIÓN 0.5%
#DEFINE AFPSOLID05	"1228"//AFP L/APOR.SOLID 0.5%

#DEFINE CODRCIVA	"0067"//RC-IVA VACACIONES/PRIMAS/ETC

#DEFINE OPCDESC		"J"	//"Otros descuentos"

#DEFINE CROTENE		"RE1"
#DEFINE CROTFEB		"RE2"
#DEFINE CROTMAR		"RE3"
#DEFINE CROTABR		"RE4"

#DEFINE CCODHE		"040"//Codigo Horas Extras
#DEFINE CCODHNM		"041"//Codigo Horas Nocturnas - Masculino
#DEFINE CCODHNF		"047"//Codigo Horas Nocturnas - Femenino

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XPLANRE2 ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Planilla de Retroactivo									   	³±±
±±³          ³ Se agregaron las columnas de Dominical y Recargo Nocturno	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ XPLANRE2()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global - SIGAGPE												³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³ 31/05/2021													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function XPLANRE2()
	Local oReport
	Private cPerg   := "XPLANRE2"   // elija el Nombre de la pregunta
	Private aTabS011:= {}

	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Retroactivo"

	oReport	 := TReport():New("XPLANRE2",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Planilla Retroactivo")

	oSection := TRSection():New(oReport,"Retroactivo",{"SRC"})
	oReport:SetTotalInLine(.T.)

	//Comienzan a elegir los campos que desean Mostrar
	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
	TRCell():New(oSection,"CONTADOR"	,"SRA","N°", "@E 9999")
	TRCell():New(oSection,"RA_FILIAL"	,"SRA","SUCURSAL")
	TRCell():New(oSection,"RA_MAT"		,"SRA","MATRÍCULA")
	TRCell():New(oSection,"RA_RG"		,"SRA","CARNET DE IDENTIDAD")
	TRCell():New(oSection,"RA_ALFANUM"	,"SRA","COMPLEMENTO")
	TRCell():New(oSection,"RA_UFCI"		,"SRA","LUGAR DE EXPEDICIÓN")
	TRCell():New(oSection,"RA_NOME"		,"SRA","APELLIDOS Y NOMBRES")
	TRCell():New(oSection,"RA_SEXO"		,"SRA","SEXO(F/M)")
	TRCell():New(oSection,"RJ_DESC"		,"SRJ","OCUPACIÓN QUE DESEMPEÑA")
	TRCell():New(oSection,"RA_ADMISSA"	,"SRA","FECHA DE INGRESO")
	TRCell():New(oSection,"RA_DEMISSA"	,"SRA","FECHA DE RETIRO")
	TRCell():New(oSection,"HBDICIEM"	,"SRA","HABER BASICO EN LA PLANILLA DE DICIEMBRE")
	TRCell():New(oSection,"NUEVOHB"		,"SRA","HABER BASICO CON INCREMENTO")
	TRCell():New(oSection,"ENERO"		,"SRC","ENERO")
	TRCell():New(oSection,"FEBRERO"		,"SRC","FEBRERO")
	TRCell():New(oSection,"MARZO"		,"SRC","MARZO")
	TRCell():New(oSection,"ABRIL"		,"SRC","ABRIL")
	TRCell():New(oSection,"DOMINICAL"	,"SRC","Dominical")
	TRCell():New(oSection,"BONOANT"		,"SRC","Bono Antigüedad")
	TRCell():New(oSection,"HORASEXT"	,"SRC","Horas Extras")
	TRCell():New(oSection,"HORASNOCT"	,"SRC","Recargo Nocturno")
	TRCell():New(oSection,"TOTALRET"	,"SRC","TOTAL RETROACTIVO (Bs)")
	TRCell():New(oSection,"AFP"			,"SRC","AFP", PesqPict( 'SRC', 'RC_VALOR' ))
	TRCell():New(oSection,"RCIVA"		,"SRC","RC-IVA 13%")
	TRCell():New(oSection,"OTRDESC"		,"SRC","OTROS DESCUENTOS")
	TRCell():New(oSection,"TOTALDESC"	,"SRC","TOTAL DESCUENTOS (Bs)")
	TRCell():New(oSection,"LIQUIDOP"	,"SRC","LIQUIDO PAGABLE (Bs)")
	TRCell():New(oSection,"FIRMA"		,"SRA","FIRMA DEL EMPLEADO")

Return oReport

Static Function PrintReport(oReport)
	Local oSection	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local cValida	:= ""
	Local cFilialPer:= ""
	Local nContador	:= 1
	Local nHbDic	:= 0
	Local nNuevoHB	:= 0
	Local nHBEne	:= 0
	Local nHBFeb	:= 0
	Local nHBMar	:= 0
	Local nHBAbr	:= 0
	Local nSumaDOM	:= 0//Suma los dominicales de enero, febrero, marzo y abril por empleado
	Local nSumaBA	:= 0//Suma los bonos de antiguedad de enero, febrero, marzo y abril por empleado
	Local nSumaHE	:= 0//Suma las horas extras de enero, febrero, marzo y abril por empleado
	Local nSumaHN	:= 0//Suma las horas nocturnas de enero, febrero, marzo y abril por empleado

	Local nAFP		:= 0
	Local nRCIVA	:= 0
	Local nOtrDesc	:= 0

	Local nTotalRET	:= 0
	Local nTotalDESC:= 0
	Local nLiqRET	:= 0

	Local aSolid	:= {}
	Local cFiltro	:= ""


	//Parametros
	Local cProcesso := MV_PAR01
	Local cPeriodo	:= MV_PAR02
	Local cSemana	:= MV_PAR03
	Local cFilDe   	:= MV_PAR04
	Local cFilAte  	:= MV_PAR05
	Local cCcDe    	:= MV_PAR06
	Local cCcAte   	:= MV_PAR07
	Local cMatDe   	:= MV_PAR08
	Local cMatAte  	:= MV_PAR09
	Local cSituacao := MV_PAR10
	Local cCategoria:= MV_PAR11
	Local nOrdem	:= MV_PAR12
	Local nAgrupa	:= IIF( EMPTY(MV_PAR13), 1, MV_PAR13 )//Agrupado por: 1:=Empresa, 2:=Sucursal, 3:=Centro Costo
	Local cCodFols	:= "'"+HBCODFOL+"','"+BACODFOL+"','"+CODDOMIN+"','"+AFPVEJEZ+"','"+AFPRIESGO+"','"+AFPCOMIS05+"','"+AFPSOLID05+"','"+CODRCIVA+"'"
	Local cPDLiqRet	:= PDLIQRET//Liquido pagable retroactivo
	Local cPDHabBas	:= FGETCODFOL(HBCODFOL)

	Local cPerDic	:= cValToChar( (VAL(SUBSTR(cPeriodo, 1, 4)) - 1) ) + "12" //Periodo de diciembre del año anterior

	cSitQuery	:= ""
	If !Empty(cSituacao)
		For nReg:=1 to Len(cSituacao)
			cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cSituacao)
				cSitQuery += ","
			Endif
		Next nReg
	EndIf

	cCatQuery	:= ""
	If !Empty(cSituacao)
		For nReg:=1 to Len(cCategoria)
			cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cCategoria)
				cCatQuery += ","
			Endif
		Next nReg
	EndIf

	If(nOrdem == 1)
		cOrdLan	  := "RA_FILIAL, RA_MAT"
	ElseIf(nOrdem == 2)
		cOrdLan   := "RA_FILIAL, RA_CC, RA_MAT"
	else
		cOrdLan	  := "RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME"
	EndIf

	aSolid:= getPDsSolidarios(cPeriodo)
	If(Len(aSolid) > 0)
		cFiltro:= " AND (SRV.RV_INFSAL <> '' OR SRV.RV_COD = '" + cPDLiqRet + "'" + " OR SRV.RV_COD IN (" + aSolid[1] + ")" + " OR SRV.RV_CODFOL IN (" + cCodFols + "))"
	Else
		cFiltro:= " AND (SRV.RV_INFSAL <> '' OR SRV.RV_COD = '" + cPDLiqRet + "' OR SRV.RV_CODFOL IN (" + cCodFols + "))"
	EndIf

	#IFDEF TOP

		cQuery+= " SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,"
		cQuery+= " SRC.RC_PERIODO, SRC.RC_ROTEIR, SRC.RC_PD, SRC.RC_HORAS, SRC.RC_VALOR, SRV.RV_CODFOL, SRV.RV_COD, SRV.RV_INFSAL, RA_SALARIO"
		cQuery+= " FROM " + RetSqlName("SRA") + " SRA"
		cQuery+= " JOIN " + RetSqlName("SRC") + " SRC ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT"
		cQuery+= " JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRC.RC_PD"
		cQuery+= " WHERE SRC.RC_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
		cQuery+= " AND SRA.RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
		cQuery+= " AND SRC.RC_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
		cQuery+= " AND SRA.RA_SITFOLH IN (" + cSitQuery + ")"
		cQuery+= " AND SRA.RA_CATFUNC IN (" + cCatQuery + ")"
		cQuery+= " AND SRC.RC_PROCES = '" + cProcesso + "'"
		cQuery+= " AND SRC.RC_PERIODO = '" + cPeriodo + "'"
		cQuery+= " AND SRC.RC_SEMANA = '" + cSemana + "'"
		cQuery+= " AND SRC.RC_ROTEIR IN ('RE1', 'RE2', 'RE3', 'RE4')"
		//cQuery+= " AND (SRV.RV_INFSAL <> '' OR SRV.RV_COD = '" + cPDLiqRet + "' OR SRV.RV_CODFOL IN (" + cCodFols + "))"
		cQuery+= cFiltro
		cQuery+= " AND SRA.D_E_L_E_T_ <> '*'"
		cQuery+= " AND SRC.D_E_L_E_T_ <> '*'"
		cQuery+= " AND SRV.D_E_L_E_T_ <> '*'"
		cQuery+= " UNION "
		cQuery+= " SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,"
		cQuery+= " SRD.RD_PERIODO, SRD.RD_ROTEIR, SRD.RD_PD, SRD.RD_HORAS, SRD.RD_VALOR, SRV.RV_CODFOL, SRV.RV_COD, SRV.RV_INFSAL, RA_SALARIO"
		cQuery+= " FROM " + RetSqlName("SRA") + " SRA"
		cQuery+= " JOIN " + RetSqlName("SRD") + " SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT"
		cQuery+= " JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRD.RD_PD"
		cQuery+= " WHERE SRD.RD_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
		cQuery+= " AND SRA.RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
		cQuery+= " AND SRD.RD_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
		cQuery+= " AND SRA.RA_SITFOLH IN (" + cSitQuery + ")"
		cQuery+= " AND SRA.RA_CATFUNC IN (" + cCatQuery + ")"
		cQuery+= " AND SRD.RD_PROCES = '" + cProcesso + "'"
		cQuery+= " AND SRD.RD_PERIODO = '" + cPeriodo + "'"
		cQuery+= " AND SRD.RD_SEMANA = '" + cSemana + "'"
		cQuery+= " AND SRD.RD_ROTEIR IN ('RE1', 'RE2', 'RE3', 'RE4')"
		//cQuery+= " AND (SRV.RV_INFSAL <> '' OR SRV.RV_COD = '" + cPDLiqRet + "' OR SRV.RV_CODFOL IN (" + cCodFols + "))"
		cQuery+= cFiltro
		cQuery+= " AND SRA.D_E_L_E_T_ <> '*'"
		cQuery+= " AND SRD.D_E_L_E_T_ <> '*'"
		cQuery+= " AND SRV.D_E_L_E_T_ <> '*'"
		cQuery+= " ORDER BY " + cOrdLan

		cQuery:= ChangeQuery(cQuery)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
		dbSelectArea(cAliasQry)
		dbGoTop()

		oSection:Init()
		While (cAliasQry)->(! EOF())
			cValida		:= (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT
			cSuc		:= (cAliasQry)->RA_FILIAL
			cMat		:= (cAliasQry)->RA_MAT
			cCi			:= TRIM((cAliasQry)->RA_RG)
			cCiComp		:= TRIM((cAliasQry)->RA_ALFANUM)
			cLugarExp	:= TRIM((cAliasQry)->RA_UFCI)
			cSexo		:= (cAliasQry)->RA_SEXO
			cNome		:= (cAliasQry)->(ALLTRIM(RA_PRISOBR) + " " + ALLTRIM(RA_SECSOBR) + " " + ALLTRIM(RA_PRINOME) + " " + ALLTRIM(RA_SECNOME))

			cCodFunc:= (cAliasQry)->RA_CODFUNC
			cOcupa:= fDesc("SRJ",cCodFunc,"RJ_DESC")
			cOcupa:= Left(cOcupa, 1) + LOWER(Right(cOcupa, len(cOcupa)-1))

			cAdmissa:= DTOC(STOD((cAliasQry)->RA_ADMISSA))
			cDemissa:= DTOC(STOD((cAliasQry)->RA_DEMISSA))

			nNuevoHB:= (cAliasQry)->RA_SALARIO

			if( (cAliasQry)->RV_CODFOL == HBCODFOL .AND. (cAliasQry)->RC_ROTEIR = CROTENE )//Haber básico ENERO
				nHBEne	:= (cAliasQry)->RC_VALOR
			EndIf
			if( (cAliasQry)->RV_CODFOL == HBCODFOL .AND. (cAliasQry)->RC_ROTEIR = CROTFEB )//Haber básico FEBRERO
				nHBFeb	:= (cAliasQry)->RC_VALOR
			EndIf
			if( (cAliasQry)->RV_CODFOL == HBCODFOL .AND. (cAliasQry)->RC_ROTEIR = CROTMAR )//Haber básico MARZO
				nHBMar	:= (cAliasQry)->RC_VALOR
			EndIf
			if( (cAliasQry)->RV_CODFOL == HBCODFOL .AND. (cAliasQry)->RC_ROTEIR = CROTABR )//Haber básico ABRIL
				nHBAbr	:= (cAliasQry)->RC_VALOR
			EndIf


			IF((cAliasQry)->RV_CODFOL == CODDOMIN)//Dominical
				nSumaDOM+= (cAliasQry)->RC_VALOR
			EndIf

			IF((cAliasQry)->RV_CODFOL == BACODFOL)//Bono de antiguedad
				nSumaBA+= (cAliasQry)->RC_VALOR
			EndIf

			IF((cAliasQry)->RV_COD == CCODHE)//Horas Extras
				nSumaHE+= (cAliasQry)->RC_VALOR
			EndIf

			IF( (cAliasQry)->RV_COD $ (CCODHNM + "|" + CCODHNF) )//Horas Nocturnas
				nSumaHN+= (cAliasQry)->RC_VALOR
			EndIf

			IF((cAliasQry)->RV_INFSAL == OPCDESC)//Otros Descuentos
				nOtrDesc+= (cAliasQry)->RC_VALOR
			EndIf

			IF(Len(aSolid) > 0)
				IF( ((cAliasQry)->RV_CODFOL $ AFPVEJEZ+"|"+AFPRIESGO+"|"+AFPCOMIS05+"|"+AFPSOLID05) .OR. (cAliasQry)->RV_COD $ aSolid[2])//AFP's 12.71% y Solidarios
					nAFP+= (cAliasQry)->RC_VALOR
				EndIf
			Else
				IF( ((cAliasQry)->RV_CODFOL $ AFPVEJEZ+"|"+AFPRIESGO+"|"+AFPCOMIS05+"|"+AFPSOLID05) )//AFP's 12.71%
					nAFP+= (cAliasQry)->RC_VALOR
				EndIf
			EndIf

			IF((cAliasQry)->RV_CODFOL == CODRCIVA)//RC-IVA
				nRCIVA+= (cAliasQry)->RC_VALOR
			EndIf

			IF((cAliasQry)->RV_COD == PDLIQRET)//Liquido pagable retroactivo
				nLiqRET+= (cAliasQry)->RC_VALOR
			EndIf

			(cAliasQry)->(dbSkip())

			If(cValida <> (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT)
				nTotalRET	:= nHBEne + nHBFeb + nHBMar + nHBAbr + nSumaDOM + nSumaBA + nSumaHE + nSumaHN
				nTotalDESC	:= nAFP + nRCIVA + nOtrDesc

				cFilialPer	:= staticCall(CALCRET, getFilialPeriodoRet,cMat,cPerDic)//obtiene la sucursal del empleado en el periodo enviado.
				If( Empty(cFilialPer) .OR. cFilialPer == NIL )
					cFilialPer:= cSuc
				EndIf
				nDiasTrab	:= GetAdvFVal("SRD", "RD_HORAS", cFilialPer + cMat + cPerDic + cPerDic + cPDHabBas ,3, 0)
				nHbDic		:= GetAdvFVal("SRD", "RD_VALOR", cFilialPer + cMat + cPerDic + cPerDic + cPDHabBas ,3, 0)

				If(nDiasTrab < 30 )//Si NO trabajó el mes completo
					nHbDic:= nHbDic / nDiasTrab * 30
				EndIf

				oSection:Cell("CONTADOR"):SetValue( nContador )
				oSection:Cell("RA_FILIAL"):SetValue( cSuc )
				oSection:Cell("RA_MAT"):SetValue( cMat )
				oSection:Cell("RA_RG"):SetValue( cCi )
				oSection:Cell("RA_ALFANUM"):SetValue( cCiComp )
				oSection:Cell("RA_UFCI"):SetValue( cLugarExp )
				oSection:Cell("RA_NOME"):SetValue( cNome )
				oSection:Cell("RA_SEXO"):SetValue( cSexo )
				oSection:Cell("RJ_DESC"):SetValue( cOcupa )
				oSection:Cell("RA_ADMISSA"):SetValue( cAdmissa )
				oSection:Cell("RA_DEMISSA"):SetValue( cDemissa )

				oSection:Cell("HBDICIEM"):SetValue( nHbDic )
				oSection:Cell("NUEVOHB"):SetValue( nNuevoHB )
				oSection:Cell("ENERO"):SetValue( nHBEne )
				oSection:Cell("FEBRERO"):SetValue( nHBFeb )
				oSection:Cell("MARZO"):SetValue( nHBMar )
				oSection:Cell("ABRIL"):SetValue( nHBAbr )
				oSection:Cell("DOMINICAL"):SetValue( nSumaDOM )
				oSection:Cell("BONOANT"):SetValue( nSumaBA )
				oSection:Cell("HORASEXT"):SetValue( nSumaHE )
				oSection:Cell("HORASNOCT"):SetValue( nSumaHN )
				oSection:Cell("TOTALRET"):SetValue( nTotalRET )

				oSection:Cell("AFP"):SetValue( nAFP )
				oSection:Cell("RCIVA"):SetValue( nRCIVA )
				oSection:Cell("OTRDESC"):SetValue( nOtrDesc )
				oSection:Cell("TOTALDESC"):SetValue( nTotalDESC )

				oSection:Cell("LIQUIDOP"):SetValue( nLiqRET )
				oSection:Cell("FIRMA"):SetValue( Space(10) )

				oSection:PrintLine(,,,.T.)
				nContador++
				nHbDic		:= 0
				nNuevoHB	:= 0
				nHBEne		:= 0
				nHBFeb		:= 0
				nHBMar		:= 0
				nHBAbr		:= 0
				nSumaDOM	:= 0
				nSumaBA		:= 0
				nSumaHE		:= 0
				nSumaHN		:= 0
				nAFP		:= 0
				nRCIVA		:= 0
				nOtrDesc	:= 0
				nTotalRET	:= 0
				nTotalDESC	:= 0
				nLiqRET		:= 0
			EndIf
		enddo

		oSection:Finish()

	#ELSE
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

Return

/**
* @author: Denar Terrazas Parada
* @since: 04/06/2021
* @description: Funcion que obtiene los conceptos de los aportes Solidarios
* @params: cPer-> Periodo
*/
static function getPDsSolidarios(cPer)
	Local aArea		:= getArea()
	Local aRet		:= {}
	Local cTab		:= "S011"
	Local cPDQuery	:= ""//Utilizado para el query
	Local cPDComp	:= ""//Utilizado para comparar
	Local dDataRef	:= STOD(cPer + "01")
	Local nX		:= 1

	fCarrTab ( @aTabS011, cTab, dDataRef, .T.)

	for nX := 1 to Len(aTabS011)
		cPDQuery+= "'" + aTabS011[nX][8] + "', "
		cPDComp+= aTabS011[nX][8] + "|"
	next nX

	If(!Empty(cPDQuery))
		cPDQuery:= SUBSTR(cPDQuery, 1, LEN(cPDQuery) - 2)
		AADD(aRet, cPDQuery)
		AADD(aRet, cPDComp)
	EndIf

	RCC->(dbclosearea())

	restArea(aArea)

return aRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Periodo Competenc. (AAAAMM)?" 		, "¿Periodo Competenc. (AAAAMM)?"		,"¿Periodo Competenc. (AAAAMM)?"		,"MV_CH2","C",06,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿N° Pago?" 		, "¿N° Pago?"		,"¿N° Pago?"		,"MV_CH3","C",02,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿De Sucursal?"	, "¿De Sucursal?"	,"¿De Sucursal?"	,"MV_CH4","C",04,0,0,"G","","SM0","033","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿A Sucursal?" 	, "¿A Sucursal?"	,"¿A Sucursal?"		,"MV_CH5","C",04,0,0,"G","","SM0","033","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿De Centro de costo?" , "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH6","C",11,0,0,"G","","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿A Centro de costo?" 	, "¿A Centro de costo?"	,"¿A Centro de costo?"	,"MV_CH7","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿De Matrícula?" , "¿De Matrícula?"	,"¿De Matrícula?"	,"MV_CH8","C",06,0,0,"G","","SRA","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿A Matrícula?" 	, "¿A Matrícula?"	,"¿A Matrícula?"	,"MV_CH9","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿Situaciones por imprimir?" , "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CHA","C",05,0,0,"G","fSituacao()","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿Categorías por imprimir?" 	, "¿Categorías por imprimir?"	,"¿Categorías por imprimir?"	,"MV_CHB","C",15,0,0,"G","fCategoria()","","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"12","¿Orden?"		, "¿Orden?"			,"¿Orden?"			,"MV_CHC","N",01,0,0,"C","","","","","MV_PAR12","Sucursal+Matric.","Sucursal+Matric.","Sucursal+Matric.","","Sucursal+C.Costo","Sucursal+C.Costo","Sucursal+C.Costo"	,"Apellido Paterno","Apellido Paterno","Apellido Paterno")
	//xPutSX1(cPerg,"13","¿Agrupar Por?"		, "¿Agrupar Por?"			,"¿Agrupar Por?"			,"MV_CHD","N",01,0,0,"C","","","","","MV_PAR13","Empresa","Empresa","Empresa","","Sucursal","Sucursal","Sucursal","C.Costo","C.Costo","C.Costo")

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
