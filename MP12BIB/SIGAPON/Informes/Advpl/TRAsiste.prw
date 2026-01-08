#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

#Define NNAME	1
#Define NALIAS	2
#Define NTITULO	3

#Define NTIPOAFA	1
#Define NDATAINI	2
#Define NDATAFIN	3

#Define CNORMAL		"-"
#Define CDSR		"DSR"
#Define CDEMISSA	"#"

#Define N_PB_PD		1
#Define N_PB_HORAS	2

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRAsiste ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de Asistencia Horizontal por periodo detallado 		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRAsiste()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global - SIGAPON												³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³08/11/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function TRAsiste()
	Local oReport
	Private cPerg   := "TRASISTE"   // elija el Nombre de la pregunta
	Private aCab	:= {}
	Private aCabTot	:= {}
	Private aDadoCab:= {}
	Private cEventos:= ""
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.T.)
	aCab	:= getCalen()
	cEventos:= getEventos()
	aCabTot	:= getCabTot()
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg:= "Informe de Asistencia Horizontal"

	oReport	 := TReport():New("TRAsiste",NombreProg,/*cPerg*/,{|oReport| PrintReport(oReport)},"Informe de Asistencia Horizontal")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Asistencia",{"SPC"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	oReport:SetTotalInLine(.F.)
	oReport:SetParam(cPerg)
	oReport:ShowParamPage()

	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection, "RA_FILIAL", "SRA", "Sucursal")
	TRCell():New(oSection, "RA_MAT", "SRA", "Matricula")
	TRCell():New(oSection, "RA_NOME", "SRA", "Nombre")
	for i:= 1 to Len(aCab)
		TRCell():New(oSection, aCab[i][NNAME], aCab[i][NALIAS],aCab[i][NTITULO])
	next i

	for i:= 1 to Len(aCabTot)
		TRCell():New(oSection, aCabTot[i][NNAME], aCabTot[i][NALIAS],aCabTot[i][NTITULO])
	next i

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
	Local cPeriodo	:= MV_PAR12
	Local cDataAte	:= ""//DTOS(MV_PAR13)
	Local cText		:= ""
	Local aPDFalta	:= getPDFalta()
	Local aPDTotal	:= {}
	Local cPDs		:= ""
	Local aTotales	:= {}

	#IFDEF TOP

	// consulta a la base de datos
	BeginSql Alias cAliasQry
		SELECT RA_FILIAL, PC_FILIAL, RA_MAT, RA_TNOTRAB, RA_SEQTURN, RA_DEMISSA, RA_CC, PC_MAT, RA_NOME, PC_DATA, PC_PD, P9_XSIGLA, PK_CODABO, PC_PDI,
		(SELECT SP91.P9_XSIGLA SIGLAINF FROM %table:SP9% SP91 WHERE SP91.P9_CODIGO = PC_PDI AND SP91.P9_FILIAL = SUBSTRING(PC_FILIAL, 1, 2) AND SP91.%notdel%) SIGLAINF,
		SUM(PC_QUANTI) PC_QUANTI, SUM(PC_QUANTC) PC_QUANTC
		FROM %table:SRA% SRA
		LEFT JOIN %table:SPC% SPC ON SPC.PC_FILIAL = SRA.RA_FILIAL AND SPC.PC_MAT = SRA.RA_MAT
		AND PC_CC BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
		AND PC_DEPTO BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09%
		AND PC_PERIODO = %exp:MV_PAR12%
		AND PC_NUMPAG = %exp:MV_PAR13%
		AND ((PC_PD IN (%exp:cEventos%) AND PC_PDI = '') OR (PC_PDI IN (%exp:cEventos%)))
		AND PC_PROCES = %exp:MV_PAR01%
		AND SPC.%notdel%
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SRA.RA_FILIAL AND SPK.PK_MAT = SRA.RA_MAT AND PK_DATA = PC_DATA AND PC_TPMARCA = PK_TPMARCA AND SPK.%notdel%
		LEFT JOIN %table:SP9% SP9 ON SP9.P9_CODIGO = SPC.PC_PD AND SP9.P9_FILIAL = SUBSTRING(SPC.PC_FILIAL, 1, 2) AND SP9.%notdel%
		WHERE RA_PROCES = %exp:MV_PAR01%
		AND RA_FILIAL BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND RA_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND SRA.RA_TNOTRAB BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11%
		AND SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:MV_PAR12%
		AND (SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:MV_PAR12%)
		AND SRA.%notdel%
		GROUP BY RA_FILIAL, PC_FILIAL, RA_MAT, RA_TNOTRAB, RA_SEQTURN, RA_DEMISSA, RA_CC, PC_MAT, RA_NOME, PC_DATA, PC_PD, P9_XSIGLA, PK_CODABO, PC_PDI
		UNION
		SELECT RA_FILIAL, PH_FILIAL, RA_MAT, RA_TNOTRAB, RA_SEQTURN, RA_DEMISSA, RA_CC, PH_MAT, RA_NOME, PH_DATA, PH_PD, P9_XSIGLA, PK_CODABO, PH_PDI,
		(SELECT SP91.P9_XSIGLA SIGLAINF FROM %table:SP9% SP91 WHERE SP91.P9_CODIGO = PH_PDI AND SP91.P9_FILIAL = SUBSTRING(PH_FILIAL, 1, 2) AND SP91.%notdel%) SIGLAINF,
		SUM(PH_QUANTI) PH_QUANTI, SUM(PH_QUANTC) PH_QUANTC
		FROM %table:SRA% SRA
		LEFT JOIN %table:SPH% SPH ON SPH.PH_FILIAL = SRA.RA_FILIAL AND SPH.PH_MAT = SRA.RA_MAT
		AND PH_CC BETWEEN %exp:MV_PAR06% AND %exp:MV_PAR07%
		AND PH_DEPTO BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09%
		AND PH_PERIODO = %exp:MV_PAR12%
		AND PH_NUMPAG = %exp:MV_PAR13%
		AND ((PH_PD IN (%exp:cEventos%) AND PH_PDI = '') OR (PH_PDI IN (%exp:cEventos%)))
		AND PH_PROCES = %exp:MV_PAR01%
		AND SPH.%notdel%
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SRA.RA_FILIAL AND SPK.PK_MAT = SRA.RA_MAT AND PK_DATA = PH_DATA AND PH_TPMARCA = PK_TPMARCA AND SPK.%notdel%
		LEFT JOIN %table:SP9% SP9 ON SP9.P9_CODIGO = SPH.PH_PD AND SP9.P9_FILIAL = SUBSTRING(SPH.PH_FILIAL, 1, 2) AND SP9.%notdel%
		WHERE RA_PROCES = %exp:MV_PAR01%
		AND RA_FILIAL BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND RA_MAT BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
		AND SRA.RA_TNOTRAB BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11%
		AND SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:MV_PAR12%
		AND (SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:MV_PAR12%)
		AND SRA.%notdel%
		GROUP BY RA_FILIAL, PH_FILIAL, RA_MAT, RA_TNOTRAB, RA_SEQTURN, RA_DEMISSA, RA_CC, PH_MAT, RA_NOME, PH_DATA, PH_PD, P9_XSIGLA, PK_CODABO, PH_PDI
		ORDER BY RA_FILIAL, RA_MAT

	EndSql

	DbSelectArea(cAliasQry)
	oSection:Init()
	while (cAliasQry)->(!Eof())
		cValida	:= (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT
		cSuc	:= (cAliasQry)->RA_FILIAL
		cMat	:= (cAliasQry)->RA_MAT
		cTurno	:= (cAliasQry)->RA_TNOTRAB
		cSeqTurn:= (cAliasQry)->RA_SEQTURN
		cCc		:= (cAliasQry)->RA_CC
		cNome	:= (cAliasQry)->RA_NOME
		cDesp	:= (cAliasQry)->RA_DEMISSA
		nPos	:= ASCAN(aDadoCab, (cAliasQry)->PC_DATA)
		cSPCPd	:= (cAliasQry)->PC_PD
		cXSigla	:= ALLTRIM((cAliasQry)->P9_XSIGLA)
		CSPCQuan:= cValToChar((cAliasQry)->PC_QUANTC)
		If(!EMPTY((cAliasQry)->PC_PDI))// Pregunta si hubo algun evento informado
			cSPCPd	:= (cAliasQry)->PC_PDI
			cXSigla	:= ALLTRIM((cAliasQry)->SIGLAINF)
			CSPCQuan:= cValToChar((cAliasQry)->PC_QUANTI)
		EndIf
		nExist	:= ASCAN(aPDFalta, cSPCPd)
		cDesc	:= cXSigla + IIF(nExist > 0, "", "(" + CSPCQuan + ")" )

		If(!EMPTY((cAliasQry)->PK_CODABO))//Pregunta si hubo algun evento abonado/justificado
			cDesc	:= (cAliasQry)->PK_CODABO + "(" + cValToChar((cAliasQry)->PC_QUANTC) + ")"
		EndIf
		(cAliasQry)->(dbSkip())

		If(nPos > 0)
			cCellVal:= oSection:Cell(aCab[nPos][NNAME]):GetValue()
			If(!Empty(cCellVal))
				oSection:Cell(aCab[nPos][NNAME]):SetValue( cCellVal + " / " + cDesc )
			else
				oSection:Cell(aCab[nPos][NNAME]):SetValue( cDesc )
			EndIf
		EndIf

		If(cValida <> (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT)
			oSection:Cell("RA_FILIAL"):SetValue( cSuc )
			oSection:Cell("RA_MAT"):SetValue( cMat )
			oSection:Cell("RA_NOME"):SetValue( cNome )

			//oSection:Cell("RA_NOME"):SetBorder( 'ALL', 3, CLR_GREEN, .F. )
			//oSection:Cell("RA_NOME"):SetClrBack(CLR_GREEN) //cor do fundo

			aVac:= getVac(cSuc, cMat, cPeriodo)
			for i:= 1 to Len(aVac)
				nXPos:= ASCAN(aDadoCab, aVac[i][NDATAINI])
				If(nXPos > 0)
					while ( /*STOD(aDadoCab[nXPos]) <= STOD(cDataAte) .AND.*/ STOD(aDadoCab[nXPos]) <= STOD(aVac[i][NDATAFIN]) )
						oSection:Cell(aCab[nXPos][NNAME]):SetValue( aVac[i][NTIPOAFA] )
						if(nXPos == len(aCab))
							exit
						endIf
						nXPos++
					enddo
				EndIf
			next i
			cEmp	:= SUBSTR(cSuc, 1, 2) + SPACE(2)
			aDiaDSR	:= getDSR(cEmp, cTurno, cSeqTurn)
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

			for i:= 1 to Len(aCabTot)
				oSection:Cell(aCabTot[i][N_PB_PD]):SetValue(0)
			next i

			If(!EMPTY(cEventos))
				aTotales:= getTotales(cSuc, cMat, cEventos)
				for i:= 1 to Len(aTotales)
					oSection:Cell(aTotales[i][N_PB_PD]):SetValue(aTotales[i][N_PB_HORAS])
				next i
			EndIf
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
	(cAliasQry)->(dbCloseArea())
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
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
		SELECT RCG_DIAMES
		FROM %table:RCG% RCG
		WHERE RCG.RCG_MODULO = 'PON'
		AND RCG.RCG_PROCES = %exp:MV_PAR01%
		AND RCG.RCG_PER = %exp:MV_PAR12%
		AND RCG.RCG_SEMANA = %exp:MV_PAR13%
		AND RCG.%notdel%
		ORDER BY RCG_DIAMES
	EndSql

	DbSelectArea(OrdenConsul)
	while (OrdenConsul)->(!Eof())
		AADD(aRet, { (OrdenConsul)->RCG_DIAMES, "RCG", DTOC(STOD((OrdenConsul)->RCG_DIAMES)) })
		AADD(aDadoCab, (OrdenConsul)->RCG_DIAMES)
		(OrdenConsul)->(dbSkip())
	enddo
	(OrdenConsul)->(dbCloseArea())
	restArea(aArea)
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 15/11/2019
* @description: Funcion que devuelve en un array las vacaciones de un empleado
*/
static function getVac(cSuc, cMat, cPeriodo)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT R8_TIPOAFA, R8_DATAINI, R8_DURACAO, R8_DATAFIM
		FROM %table:SR8% SR8
		WHERE R8_FILIAL = %exp:cSuc%
		AND R8_MAT = %exp:cMat%
		AND SUBSTRING(R8_DATAINI, 1, 6) = %exp:cPeriodo%
		AND SR8.%notdel%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD(aRet, {(OrdenConsul)->R8_TIPOAFA, (OrdenConsul)->R8_DATAINI, (OrdenConsul)->R8_DATAFIM})
			(OrdenConsul)->(dbSkip())
		enddo
	endIf
	(OrdenConsul)->(dbCloseArea())
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
static function getDSR(cEmp, cTurno, cSeqTurn)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RF5_DIA
		FROM %table:RF5% RF5
		WHERE RF5_FILIAL = %exp:cEmp%
		AND RF5_TIPO = (SELECT RF2_TIPOD FROM %table:RF2% RF2 WHERE RF2_FILIAL = %exp:cEmp% AND RF2_TURNO = %exp:cTurno% AND RF2_SEMANA = %exp:cSeqTurn% AND RF2.%notdel%)
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
	(OrdenConsul)->(dbCloseArea())
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
	(OrdenConsul)->(dbCloseArea())
	restArea( aArea )
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 19/11/2019
* @description: Funcion que devuelve en un array codigos de los eventos de falta
* @parameters:	cEmp	-> Empresa del empleado
*/
static function getPDFalta()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	Local cEmpDe		:= SUBSTRING(MV_PAR02, 1, 2) + Space(2)
	Local cEmpAte		:= SUBSTRING(MV_PAR03, 1, 2) + Space(2)
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT P9_CODIGO
		FROM %table:SP9% SP9
		WHERE P9_FILIAL BETWEEN %exp:cEmpDe% AND %exp:cEmpAte%
		AND P9_IDPON IN ('008A', '010A', '007N', '009N')
		AND SP9.%notdel%
		GROUP BY P9_CODIGO

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD( aRet, (OrdenConsul)->P9_CODIGO )
			(OrdenConsul)->( dbSkip() )
		enddo
	endIf
	(OrdenConsul)->(dbCloseArea())
	restArea( aArea )
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 25/11/2019
* @description: Funcion que devuelve en un array los totales de los conceptos(tabla de resultados)
* @parameters:	cSuc	-> Sucursal del empleado
cMat	-> Matricula del empleado
cPDs	-> Eventos a ser buscados(separados por ",")
*/
static function getTotales(cSuc, cMat, cPDs)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	Local cEmp			:= SUBSTRING(cSuc, 1, 2) + Space(2)
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT PB_PD, RV_DESC, SUM(PB_HORAS) AS PB_HORAS
		FROM %table:SPB% SPB
		JOIN %table:SRV% SRV ON SRV.RV_COD = SPB.PB_PD
		WHERE PB_FILIAL = %exp:cSuc%
		AND PB_MAT = %exp:cMat%
		AND PB_PD IN (SELECT P9_CODFOL FROM %table:SP9% SP9 WHERE P9_FILIAL = %exp:cEmp% AND P9_CODIGO IN (%exp:cPDs%) AND P9_CODFOL <> '' AND SP9.%notdel% GROUP BY P9_CODFOL)
		AND PB_PERIODO = %exp:MV_PAR12%
		AND PB_SEMANA = %exp:MV_PAR13%
		AND SPB.%notdel%
		AND SRV.%notdel%
		GROUP BY PB_PD, RV_DESC

		UNION

		SELECT PL_PD, RV_DESC, SUM(PL_HORAS) AS PL_HORAS
		FROM %table:SPL% SPL
		JOIN %table:SRV% SRV ON SRV.RV_COD = SPL.PL_PD
		WHERE PL_FILIAL = %exp:cSuc%
		AND PL_MAT = %exp:cMat%
		AND PL_PD IN (SELECT P9_CODFOL FROM %table:SP9% SP9 WHERE P9_FILIAL = %exp:cEmp% AND P9_CODIGO IN (%exp:cPDs%) AND P9_CODFOL <> '' AND SP9.%notdel% GROUP BY P9_CODFOL)
		AND PL_PERIODO = %exp:MV_PAR12%
		AND PL_SEMANA = %exp:MV_PAR13%
		AND SPL.%notdel%
		AND SRV.%notdel%
		GROUP BY PL_PD, RV_DESC

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD( aRet, { (OrdenConsul)->PB_PD, fConvHr((OrdenConsul)->PB_HORAS, 'H') } )
			(OrdenConsul)->( dbSkip() )
		enddo
	endIf
	(OrdenConsul)->(dbCloseArea())
	restArea( aArea )
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 25/11/2019
* @description: Funcion que devuelve en los eventos a ser tomados en cuenta en la impresion del informe
Devuelve el valor para ser utilizado dentro de un IN() en el query
*/
static function getEventos()
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local cParamEv		:= ALLTRIM(MV_PAR14)

	If !Empty(cParamEv)
		nReg:= 1
		while nReg <= Len(cParamEv)
			cRet += "'"+Subs(cParamEv,nReg,3)+"'"
			If ( nReg+3 ) <= Len(cParamEv)
				cRet += ","
			Endif
			nReg+= 3
		Enddo
		cRet := "%" + cRet + "%"
	EndIf
	restArea( aArea )
return cRet

/**
*
* @author: Denar Terrazas Parada
* @since: 25/11/2019
* @description: Funcion que devuelve en un array la cabecera para los totales
*/
static function getCabTot()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	Local cEmp			:= FWCompany()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RV_COD, RV_DESC
		FROM %table:SP9% SP9
		JOIN %table:SRV% SRV ON SRV.RV_COD = SP9.P9_CODFOL
		WHERE P9_FILIAL = %exp:cEmp%
		AND P9_CODIGO IN (%exp:cEventos%)
		AND P9_CODFOL <> ''
		AND SP9.%notdel%
		AND SRV.%notdel%
		GROUP BY RV_COD, RV_DESC

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		while( (OrdenConsul)->(!Eof()) )
			AADD( aRet, { (OrdenConsul)->RV_COD, "SRV", TRIM((OrdenConsul)->RV_DESC) } )
			(OrdenConsul)->( dbSkip() )
		enddo
	endIf
	(OrdenConsul)->(dbCloseArea())
	restArea( aArea )
return aRet

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
	xPutSX1(cPerg,"12","¿Periodo?" 				, "¿Periodo?"				,"¿Periodo?"			,"MV_CHC","C",06,0,0,"G","","RCH","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"13","¿Número de Pago?" 		, "¿Número de Pago?"		,"¿Número de Pago?"		,"MV_CHD","C",02,0,0,"G","","","","","MV_PAR13",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"14","¿Eventos?" 				, "¿Eventos?"				,"¿Eventos?"			,"MV_CHE","C",90,0,0,"G","fEventos()","","","","MV_PAR14",""       ,""            ,""        ,""     ,""   ,"")

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
