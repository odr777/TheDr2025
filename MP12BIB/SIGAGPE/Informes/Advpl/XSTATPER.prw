#include "protheus.ch"

/**
* @author: Denar Terrazas Parada
* @since: 20/07/2021
* @description: Informe que muestra el estatus de los periodos.
*/

User Function XSTATPER()
	Local oReport
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Estatus Periodo Abierto"

	oReport	 := TReport():New("Periodos",NombreProg,,{|oReport| PrintReport(oReport)},"Reporte de Estatus", .T.)
	oReport:nFontBody	:= 12
	oReport:nLineHeight	:= 45

	oSection := TRSection():New(oReport,"Periodos",{"RCH"})

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"RC_PROCES"	,"SRC")
	TRCell():New(oSection,"RC_ROTEIR"	,"SRC")
	TRCell():New(oSection,"RC_PERIODO"	,"SRC")
	TRCell():New(oSection,"RC_SEMANA"	,"SRC")
	TRCell():New(oSection,"ESTATUS"		,"RCH", "Estatus")
	TRCell():New(oSection,"FUNCIONARIOS","SRC", "Cant. Funcionarios")
	TRCell():New(oSection,"NETO"		,"SRC", "Valor Neto", PesqPict( 'SRC', 'RC_VALOR' ), 14,,,"RIGHT",,"RIGHT")

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(1)

	#IFDEF TOP
		// Query
		oSection:BeginQuery()
		BeginSql alias "QRYRCH"
		
		SELECT RC_PROCES, RC_ROTEIR, RC_PERIODO, RC_SEMANA,
		(
			SELECT CASE WHEN RCH_PERSEL = '1' THEN 'Abierto' ELSE 'Cerrado' END AS ESTATUS
			FROM %Table:RCH% WHERE %notDel% AND RCH_PROCES = RC_PROCES AND RCH_ROTEIR = RC_ROTEIR AND RCH_PER = RC_PERIODO AND RCH_NUMPAG = RC_SEMANA
		) AS ESTATUS,
		COUNT(*) AS FUNCIONARIOS, SUM(RC_VALOR) AS NETO
		FROM
		(
		SELECT RC_FILIAL, RC_MAT, RC_PROCES, RC_ROTEIR, RC_PERIODO, RC_SEMANA, SUM(RC_VALOR) AS RC_VALOR
		FROM %Table:SRC%
		WHERE RC_PROCES IN (SELECT RCH_PROCES FROM %Table:RCH% WHERE %notDel% AND RCH_ROTEIR = 'FOL' AND RCH_PERSEL = '1')
		AND RC_PERIODO IN (SELECT RCH_PER FROM %Table:RCH% WHERE %notDel% AND RCH_ROTEIR = 'FOL' AND RCH_PERSEL = '1')
		AND RC_SEMANA IN (SELECT RCH_NUMPAG FROM %Table:RCH% WHERE %notDel% AND RCH_ROTEIR = 'FOL' AND RCH_PERSEL = '1')
		AND RC_PD IN (SELECT RV_COD FROM %Table:SRV% WHERE %notDel% AND RV_CODFOL IN ('0047', '0126', '1273', '0021', '1729', '0546', '0774'))
		AND %notDel%
		GROUP BY RC_FILIAL, RC_MAT, RC_PROCES, RC_ROTEIR, RC_PERIODO, RC_SEMANA
		) A
		GROUP BY RC_PROCES, RC_ROTEIR, RC_PERIODO, RC_SEMANA

		UNION

		SELECT RD_PROCES, RD_ROTEIR, RD_PERIODO, RD_SEMANA,
		(
			SELECT CASE WHEN RCH_PERSEL = '1' THEN 'Abierto' ELSE 'Cerrado' END AS ESTATUS
			FROM %Table:RCH% WHERE %notDel% AND RCH_PROCES = RD_PROCES AND RCH_ROTEIR = RD_ROTEIR AND RCH_PER = RD_PERIODO AND RCH_NUMPAG = RD_SEMANA
		) AS ESTATUS,
		COUNT(*) AS FUNCIONARIOS, SUM(RD_VALOR) AS NETO
		FROM
		(
		SELECT RD_FILIAL, RD_MAT, RD_PROCES, RD_ROTEIR, RD_PERIODO, RD_SEMANA, SUM(RD_VALOR) AS RD_VALOR
		FROM %Table:SRD%
		WHERE RD_PROCES IN (SELECT RCH_PROCES FROM %Table:RCH% WHERE %notDel% AND RCH_ROTEIR = 'FOL' AND RCH_PERSEL = '1')
		AND RD_PERIODO IN (SELECT RCH_PER FROM %Table:RCH% WHERE %notDel% AND RCH_ROTEIR = 'FOL' AND RCH_PERSEL = '1')
		AND RD_SEMANA IN (SELECT RCH_NUMPAG FROM %Table:RCH% WHERE %notDel% AND RCH_ROTEIR = 'FOL' AND RCH_PERSEL = '1')
		AND RD_PD IN (SELECT RV_COD FROM %Table:SRV% WHERE %notDel% AND RV_CODFOL IN ('0047', '0126', '1273', '0021', '1729', '0546', '0774'))
		AND %notDel%
		GROUP BY RD_FILIAL, RD_MAT, RD_PROCES, RD_ROTEIR, RD_PERIODO, RD_SEMANA
		) A
		GROUP BY RD_PROCES, RD_ROTEIR, RD_PERIODO, RD_SEMANA

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
