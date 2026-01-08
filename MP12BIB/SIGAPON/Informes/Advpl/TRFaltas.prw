#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

#Define NNAME	1
#Define NALIAS	2
#Define NTITULO	3

#Define NTIPOAFA	1
#Define NDATAINI	2
#Define NDATAFIN	3

#Define CNORMAL		"-"
#Define CDSR		"DSR"
#Define CDEMISSA	"#"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRFaltas ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de asistencia detallado por permanencia - SIGAPON   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRFaltas()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global - SIGAPON												³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³21/10/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function TRFaltas()
	Local oReport
	Private cPerg   := "TRFALTAS"   // elija el Nombre de la pregunta
	Private aCab	:= {}
	Private aDadoCab:= {}
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.T.)
	aCab	:= getCalen()
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg:= "Informe Por Permanencia"

	oReport	 := TReport():New("TRFaltas",NombreProg,/*cPerg*/,{|oReport| PrintReport(oReport)},"Informe Por Permanencia")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Faltas",{"SPC"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	oReport:SetTotalInLine(.F.)

	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection, "RA_FILIAL", "SRA", "Sucursal")
	TRCell():New(oSection, "RA_MAT", "SRA", "Matricula")
	TRCell():New(oSection, "RA_NOME", "SRA", "Nombre")
	for i:= 1 to Len(aCab)
		TRCell():New(oSection, aCab[i][NNAME], aCab[i][NALIAS],aCab[i][NTITULO])
	next i
	TRCell():New(oSection, "DIAS", "SPC", "Días continuos")

	//
	// oBreak = TRBreak():New(oSection,oSection:Cell("N4_FILIAL"),"Sub Total Filial")
	// TRFunction():New(oSection:Cell("VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	// Imprime una linea Segun la condicion (totalizadora)
	// TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)

	//TRFunction():New(oSection:Cell("VALVENGR")	,NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
	Local aArea		:= getArea()
	Local oSection	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cValida	:= ""
	Local cQuery	:= ""
	Local nRegua	:= 0
	Local aVac		:= {}
	Local cDataDe	:= DTOS(MV_PAR12)
	Local cDataAte	:= DTOS(MV_PAR13)
	Local cText		:= ""

	#IFDEF TOP

	// consulta a la base de datos
	BeginSql Alias cAliasQry

		SELECT RA_FILIAL, PC_FILIAL, RA_MAT, RA_TNOTRAB, RA_DEMISSA, RA_CC, PC_MAT, RA_NOME, PC_DATA, PC_PD, PK_CODABO
		FROM %table:SRA% SRA
		LEFT JOIN %table:SPC% SPC ON SPC.PC_FILIAL = SRA.RA_FILIAL AND SPC.PC_MAT = SRA.RA_MAT
		AND PC_PROCES = %exp:MV_PAR01%
		AND PC_CC BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
		AND PC_DEPTO BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09%
		AND PC_DATA BETWEEN %exp:DTOS(MV_PAR12)% AND %exp:DTOS(MV_PAR13)%
		AND PC_PD IN (SELECT P9_CODIGO FROM SP9010 WHERE P9_IDPON IN ('008A', '010A', '007N', '009N') AND %notdel%)
		AND SPC.%notdel%
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SRA.RA_FILIAL AND SPK.PK_MAT = SRA.RA_MAT AND PK_DATA = PC_DATA AND PC_TPMARCA = PK_TPMARCA AND SPK.%notdel%
		WHERE RA_FILIAL BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND RA_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND SRA.RA_TNOTRAB BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11%
		AND (SRA.RA_DEMISSA = '' OR SRA.RA_DEMISSA >= %exp:DTOS(MV_PAR13)% OR SRA.RA_DEMISSA BETWEEN %exp:DTOS(MV_PAR12)% AND %exp:DTOS(MV_PAR13)%)
		AND SRA.%notdel%
		GROUP BY RA_FILIAL, PC_FILIAL, RA_MAT, RA_TNOTRAB, RA_DEMISSA, RA_CC, PC_MAT, RA_NOME, PC_DATA, PC_PD, PK_CODABO
		UNION
		SELECT RA_FILIAL, PH_FILIAL, RA_MAT, RA_TNOTRAB, RA_DEMISSA, RA_CC, PH_MAT, RA_NOME, PH_DATA, PH_PD, PK_CODABO
		FROM %table:SRA% SRA
		LEFT JOIN %table:SPH% SPH ON SPH.PH_FILIAL = SRA.RA_FILIAL AND SPH.PH_MAT = SRA.RA_MAT
		AND PH_PROCES = %exp:MV_PAR01%
		AND PH_CC BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
		AND PH_DEPTO BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09%
		AND PH_DATA BETWEEN %exp:DTOS(MV_PAR12)% AND %exp:DTOS(MV_PAR13)%
		AND PH_PD IN (SELECT P9_CODIGO FROM SP9010 WHERE P9_IDPON IN ('008A', '010A', '007N', '009N') AND %notdel%)
		AND SPH.%notdel%
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SRA.RA_FILIAL AND SPK.PK_MAT = SRA.RA_MAT AND PK_DATA = PH_DATA AND PH_TPMARCA = PK_TPMARCA AND SPK.%notdel%
		WHERE RA_FILIAL BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND RA_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND SRA.RA_TNOTRAB BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11%
		AND (SRA.RA_DEMISSA = '' OR SRA.RA_DEMISSA >= %exp:DTOS(MV_PAR13)% OR SRA.RA_DEMISSA BETWEEN %exp:DTOS(MV_PAR12)% AND %exp:DTOS(MV_PAR13)%)
		AND SRA.%notdel%
		GROUP BY RA_FILIAL, PH_FILIAL, RA_MAT, RA_TNOTRAB, RA_DEMISSA, RA_CC, PH_MAT, RA_NOME, PH_DATA, PH_PD, PK_CODABO
		ORDER BY RA_FILIAL, RA_MAT

		/*
		SELECT PC_FILIAL, PC_MAT, RA_NOME, RA_ADMISSA, RA_SITFOLH, RA_DEMISSA, PC_DATA, PC_PD, COALESCE(P9_CODIGO, '') P9_CODIGO, COALESCE(P9_DESC, '') P9_DESC, COALESCE(PK_CODABO, '') PK_CODABO, COALESCE(R8_TIPOAFA, '') R8_TIPOAFA
		FROM %table:SRA% SRA
		LEFT JOIN %table:SPC% SPC ON SPC.PC_FILIAL = SRA.RA_FILIAL AND SPC.PC_MAT = SRA.RA_MAT AND SPC.%notdel%
		LEFT JOIN %table:SP9% SP9 ON SP9.P9_CODIGO = SPC.PC_PD AND P9_IDPON IN ('008A', '010A', '007N', '009N') AND SP9.%notdel%
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SPC.PC_FILIAL AND SPK.PK_MAT = SPC.PC_MAT AND SPK.PK_DATA = SPC.PC_DATA AND SPK.PK_CODEVE = SPC.PC_PD AND SPK.%notdel%
		LEFT JOIN %table:SR8% SR8 ON SR8.R8_FILIAL = SPC.PC_FILIAL AND SR8.R8_MAT = SPC.PC_MAT AND SPC.PC_DATA BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM AND SR8.%notdel%
		WHERE PC_PROCES = %exp:MV_PAR01%
		AND PC_FILIAL BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND PC_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND PC_CC BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
		AND PC_DEPTO BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09%
		AND RA_TNOTRAB BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11%
		AND PC_DATA BETWEEN %exp:DTOS(MV_PAR12)% AND %exp:DTOS(MV_PAR13)%
		AND SRA.%notdel%
		UNION
		SELECT PH_FILIAL, PH_MAT, RA_NOME, RA_ADMISSA, RA_SITFOLH, RA_DEMISSA, PH_DATA, PH_PD, COALESCE(P9_CODIGO, '') P9_CODIGO, COALESCE(P9_DESC, '') P9_DESC, COALESCE(PK_CODABO, '') PK_CODABO, COALESCE(R8_TIPOAFA, '') R8_TIPOAFA
		FROM %table:SRA% SRA
		LEFT JOIN %table:SPH% SPH ON SPH.PH_FILIAL = SRA.RA_FILIAL AND SPH.PH_MAT = SRA.RA_MAT AND SPH.%notdel%
		LEFT JOIN %table:SP9% SP9 ON SP9.P9_CODIGO = SPH.PH_PD AND P9_IDPON IN ('008A', '010A', '007N', '009N') AND SP9.%notdel%
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SPH.PH_FILIAL AND SPK.PK_MAT = SPH.PH_MAT AND SPK.PK_DATA = SPH.PH_DATA AND SPK.PK_CODEVE = SPH.PH_PD AND SPK.%notdel%
		LEFT JOIN %table:SR8% SR8 ON SR8.R8_FILIAL = SPH.PH_FILIAL AND SR8.R8_MAT = SPH.PH_MAT AND SPH.PH_DATA BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM AND SR8.%notdel%
		WHERE PH_PROCES = %exp:MV_PAR01%
		AND PH_FILIAL BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND PH_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND PH_CC BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
		AND PH_DEPTO BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09%
		AND RA_TNOTRAB BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11%
		AND PH_DATA BETWEEN %exp:DTOS(MV_PAR12)% AND %exp:DTOS(MV_PAR13)%
		AND SRA.%notdel%
		ORDER BY PC_FILIAL, PC_MAT, PC_DATA
		*/
	EndSql

	DbSelectArea(cAliasQry)
	oSection:Init()
	while (cAliasQry)->(!Eof())
		cValida	:= (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT
		cSuc	:= (cAliasQry)->RA_FILIAL
		cMat	:= (cAliasQry)->RA_MAT
		cTurno	:= (cAliasQry)->RA_TNOTRAB
		cCc		:= (cAliasQry)->RA_CC
		cNome	:= (cAliasQry)->RA_NOME
		cDesp	:= (cAliasQry)->RA_DEMISSA
		nPos	:= ASCAN(aDadoCab, (cAliasQry)->PC_DATA)
		cDesc	:= (cAliasQry)->PC_PD	//IIF((cAliasQry)->PC_PD == NIL, '', (cAliasQry)->PC_PD)
		If(!EMPTY((cAliasQry)->PK_CODABO))
			cDesc	:= (cAliasQry)->PK_CODABO
			/*ElseIf(!EMPTY((cAliasQry)->R8_TIPOAFA))
			cDesc	:= (cAliasQry)->R8_TIPOAFA*/
		EndIf
		(cAliasQry)->(dbSkip())

		If(nPos > 0)
			oSection:Cell(aCab[nPos][NNAME]):SetValue( cDesc )
		EndIf

		If(cValida <> (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT)
			oSection:Cell("RA_FILIAL"):SetValue( cSuc )
			oSection:Cell("RA_MAT"):SetValue( cMat )
			oSection:Cell("RA_NOME"):SetValue( cNome )
			//oSection:Cell("RA_NOME"):SetBorder( 'ALL', 1, , .F. )

			aVac:= getVac(cSuc, cMat, cDataDe, cDataAte)
			for i:= 1 to Len(aVac)
				nXPos:= ASCAN(aDadoCab, aVac[i][NDATAINI])
				If(nXPos > 0)
					while ( STOD(aDadoCab[nXPos]) <= STOD(cDataAte) .AND. STOD(aDadoCab[nXPos]) <= STOD(aVac[i][NDATAFIN]) )
						oSection:Cell(aCab[nXPos][NNAME]):SetValue( aVac[i][NTIPOAFA] )
						if(nXPos == len(aCab))
							exit
						endIf
						nXPos++
					enddo
				EndIf
			next i
			cEmp	:= SUBSTR(cSuc, 1, 2) + SPACE(2)
			aDiaDSR	:= getDSR(cEmp, cTurno)
			aExcep	:= getExcep(cSuc, cMat, cTurno, cCc)
			for i:= 1 to Len(aCab)
				If(len(aDiaDSR) > 0)
					for j:= 1 to Len(aDiaDSR)
						If( aDiaDSR[j] == cValToChar(DOW(STOD(aCab[i][NNAME]))) )
							oSection:Cell(aCab[i][NNAME]):SetValue( CDSR )
						EndIf
					next j
				EndIf

				If(len(aExcep) > 0)
					for j:= 1 to Len(aExcep)
						If(STOD(aCab[i][NNAME]) >= STOD(aExcep[j][1]) .AND. STOD(aCab[i][NNAME]) <= STOD(aExcep[j][2]))
							oSection:Cell(aCab[i][NNAME]):SetValue( CDSR )
						EndIf
					next j
				EndIf

				cCellVal:= oSection:Cell(aCab[i][NNAME]):GetValue()

				If(empty(cCellVal))
					oSection:Cell(aCab[i][NNAME]):SetValue( " " + CNORMAL + " " )
				EndIf

			next i
			nPos:= IIF(nPos == 0, 1, nPos)

			//Trata empleados despedidos
			If(!EMPTY(cDesp))
				for i:= nPos to Len(aCab)
					If(STOD(aCab[i][NNAME]) >= STOD(cDesp))
						oSection:Cell(aCab[i][NNAME]):SetValue(CDEMISSA)
					EndIf
				next i
			EndIf

			nDias:= getDiasCtn(oSection, nPos, cEmp)
			oSection:Cell("DIAS"):SetValue( nDias )

			oSection:PrintLine(,,,.T.)

			for i:= 1 to Len(aCab)
				oSection:Cell(aCab[i][NNAME]):SetValue("")
			next i

		endIf
	enddo

	oSection:Finish()

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	restArea(aArea)
Return

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()

	// __LOGOEMP__ imprime el logo de la empresa

	aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar + if(comparador==1," ",RptFolha+" "+cvaltochar(page));
	, " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar + RptEmiss + " " + Dtoc(dDataBase);
	, "Hora: "+ cvaltochar(TIME()) ;
	, "Empresa: "+ SM0->M0_FILIAL + " " }
	RestArea( aArea )
Return aCabec

/**
*
* @author: Denar Terrazas Parada
* @since: 21/10/2019
* @description: Funcion que devuelve el calendario en un array de acuerdo a los parámetros informados
*/
static function getCalen()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local dDate			:= MV_PAR12
	Local dDateTo		:= MV_PAR13

	While dDate <= dDateTo
		AADD(aRet, { DTOS(dDate), "RCG", DTOC(dDate) })
		AADD(aDadoCab, DTOS(dDate))
		dDate:= DaySum(dDate,1)
	Enddo

	restArea(aArea)
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 15/11/2019
* @description: Funcion que devuelve en un array las vacaciones de un empleado
*/
static function getVac(cSuc, cMat, cDataDe, cDataAte)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT R8_TIPOAFA, R8_DATAINI, R8_DURACAO, R8_DATAFIM
		FROM %table:SR8% SR8
		WHERE R8_FILIAL = %exp:cSuc%
		AND R8_MAT = %exp:cMat%
		AND R8_DATAINI BETWEEN %exp:cDataDe% AND %exp:cDataAte%
		AND SR8.%notdel%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD(aRet, {(OrdenConsul)->R8_TIPOAFA, (OrdenConsul)->R8_DATAINI, (OrdenConsul)->R8_DATAFIM})
			(OrdenConsul)->(dbSkip())
		enddo
	endIf
	restArea(aArea)
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 18/11/2019
* @description: Funcion que devuelve en un array los tipos de dias del turno solicitado
* @parameters:	cEmp	-> Empresa del empleado
cTurno	-> Turno del empleado
*/
static function getDSR(cEmp, cTurno)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RF5_DIA
		FROM %table:RF5% RF5
		WHERE RF5_FILIAL = %exp:cEmp%
		AND RF5_TIPO = (SELECT RF2_TIPOD FROM %table:RF2% RF2 WHERE RF2_FILIAL = %exp:cEmp% AND RF2_TURNO = %exp:cTurno% AND RF2.%notdel%)
		AND RF5_TPDIA = 'D'
		AND RF5.%notdel%

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD( aRet, (OrdenConsul)->RF5_DIA )
			(OrdenConsul)->( dbSkip() )
		enddo
	endIf
	restArea( aArea )
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 18/11/2019
* @description: Funcion que devuelve en un array los tipos de dias del turno solicitado
* @parameters:	cEmp	-> Empresa del empleado
cTurno	-> Turno del empleado
*/
static function getExcep(cSuc, cMat, cTurno, cCc)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT P2_DATA, P2_DATAATE
		FROM %table:SP2% SP2
		WHERE P2_FILIAL = %exp:cSuc%
		AND P2_TRABA = 'D'
		AND (P2_MAT = %exp:cMat% OR P2_TURNO = %exp:cTurno% OR P2_CC = %exp:cCc%)
		AND SP2.%notdel%

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD( aRet, { (OrdenConsul)->P2_DATA, (OrdenConsul)->P2_DATAATE} )
			(OrdenConsul)->( dbSkip() )
		enddo
	endIf
	restArea( aArea )
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 19/11/2019
* @description: Funcion que devuelve en un array los tipos de abono que justifica permanencia
* @parameters:	cEmp	-> Empresa del empleado
*/
static function getTpAbono(cEmp)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local aTipo			:= {}
	Local aJPerm		:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RCM_TIPO, RCM_XJPERM
		FROM %table:RCM% RCM
		WHERE RCM_FILIAL = %exp:cEmp%
		AND RCM_XJPERM NOT IN ('', 'R')
		AND RCM.%notdel%

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD( aTipo, ALLTRIM((OrdenConsul)->RCM_TIPO) )
			AADD( aJPerm, ALLTRIM((OrdenConsul)->RCM_XJPERM) )
			(OrdenConsul)->( dbSkip() )
		enddo
	endIf

	If(LEN(aTipo) > 0)
		AADD( aRet, aTipo )
		AADD( aRet, aJPerm )
	EndIf

	restArea( aArea )
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 19/11/2019
* @description: Funcion que devuelve la cantidad de dias continuos que tiene el empleado trabajando
* @parameters:	oSection	-> Seccion actual de impresion
nPos		-> Posicion del ultimo registro de faltas
cEmp		-> Empresa del empleado
*/
static function getDiasCtn(oSection, nPos, cEmp)
	Local aArea			:= getArea()
	Local nRet			:= 0
	Local nX			:= Len(aCab)
	Local nCont			:= 0
	Local aAbono		:= getTpAbono(cEmp)
	While ( nPos <  nX )
		cCellVal:= ALLTRIM(oSection:Cell(aCab[nX][NNAME]):GetValue())
		if(cCellVal != CDEMISSA)
			if( cCellVal == CDSR )
				exit
			elseIf(cCellVal == CNORMAL)
				nCont++
			else
				nExist	:= ASCAN(aAbono[1], cCellVal)
				If(nExist == 0)
					exit
				Else
					If aAbono[2][nExist] == 'S'
						nCont++
					EndIf
				EndIf
			EndIf
		endIf
		nX--
	Enddo
	nRet:= nCont
	restArea( aArea )
return nRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿Proceso?" 				, "¿Proceso?"				,"¿Proceso?"			,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿De Sucursal?"			, "¿De Sucursal?"			,"¿De Sucursal?"		,"MV_CH2","C",04,0,0,"G","","SM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿A Sucursal?" 			, "¿A Sucursal?"			,"¿A Sucursal?"			,"MV_CH3","C",04,0,0,"G","","SM0","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿De Matrícula?" 		, "¿De Matrícula?"			,"¿De Matrícula?"		,"MV_CH4","C",06,0,0,"G","","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿A Matrícula?" 			, "¿A Matrícula?"			,"¿A Matrícula?"		,"MV_CH5","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿De Centro de costo?" 	, "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH6","C",11,0,0,"G","","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿A Centro de costo?" 	, "¿A Centro de costo?"		,"¿A Centro de costo?"	,"MV_CH7","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿De Departamento?" 		, "¿De Departamento?"		,"¿De Departamento?"	,"MV_CH8","C",09,0,0,"G","","SQB","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿A Departamento?" 		, "¿A Departamento?"		,"¿A Departamento?"		,"MV_CH9","C",09,0,0,"G","NaoVazio()","SQB","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿De Turno?" 			, "¿De Turno?"				,"¿De Turno?"			,"MV_CHA","C",03,0,0,"G","","SR6","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿A Turno?" 				, "¿A Turno?"				,"¿A Turno?"			,"MV_CHB","C",03,0,0,"G","NaoVazio()","SR6","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"12","¿De Fecha?" 			, "¿De Fecha?"				,"¿De Fecha?"			,"MV_CHE","D",08,0,0,"G","","","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"13","¿A Fecha?" 				, "¿A Fecha?"				,"¿A Fecha?"			,"MV_CHF","D",08,0,0,"G","","","","","MV_PAR13",""       ,""            ,""        ,""     ,""   ,"")

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
