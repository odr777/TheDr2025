#include 'protheus.ch'
#include 'parmtype.ch'

#Define NPORGANAR	1
#Define NDATADE		2
#Define NUTILIZADO	3
#Define NGANADO		4

/**
*
* @author: Denar Terrazas Parada
* @since: 15/10/2019
* @description: Programa para validar que el empleado tenga mas de un año y 
				haga el cálculo de las duodecimas a la fecha de retiro
				Utilizado por un disparador en el campo RG_TIPORES -> RG_DFERPRO.
*/
user function DuodeFIN()
	Local aArea		:= getArea()
	Local nRet		:= 0
	Local nDiffY	:= DateDiffYear( SRA->RA_ADMISSA, M->RG_DATADEM)
	Local aSRF		:= getSRF()
	Local nDiasTrab	:= 0
	Local nDiasCal	:= DateDiffDay( FirstYDate(M->RG_DATADEM) , CTOD("31/12/" + cValToChar(YEAR(M->RG_DATADEM))) + 1 )

	//IIF(DateDiffYear( SRA->RA_ADMISSA, M->RG_DATADEM) < 1, .F., M->RG_DFERPRO)
	if(nDiffY > 0)
		nDiasTrab:= DateDiffDay(aSRF[NDATADE], M->RG_DATADEM + 1)
		nRet:= aSRF[NPORGANAR] / nDiasCal * nDiasTrab
		nRet:= nRet - vacPerAb() - aSRF[NUTILIZADO]
	endIf

	restArea(aArea)
return nRet

/**
*
* @author: Denar Terrazas Parada
* @since: 15/10/2019
* @description: Funcion que devuelve los días por ganar de vacaciones y la fecha de inicio de un nuevo periodo
*/
static function getSRF()
	Local aArea			:= getArea()
	Local OrdenConsul	:= GetNextAlias()
	Local aRet			:= {}
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
	
		SELECT RF_FILIAL, RF_MAT, RF_DATABAS, RF_DIASDIR 'POR_GANAR', 
		RF_DFERVAT 'GANADO', RF_DFERAAT 'DUODECIMA', RF_DFERANT 'UTILIZADO' 
		FROM %table:SRF% SRF 
		WHERE RF_FILIAL = %exp:SRA->RA_FILIAL%
		AND RF_MAT = %exp:SRA->RA_MAT%
		AND RF_DIASDIR <> 0
		AND RF_DFERVAT = 0
		AND SRF.%notdel%
		
	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		AADD(aRet, (OrdenConsul)->POR_GANAR)
		AADD(aRet, STOD((OrdenConsul)->RF_DATABAS))
		AADD(aRet, (OrdenConsul)->UTILIZADO)
	endIf
	restArea(aArea)
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 15/10/2019
* @description: Funcion que devuelve la cantidad de días de vacaciones tomados en el periodo actual(periodo abierto)
*				En caso de que no tenga saldo además de sus duodécimas
*/
Static Function vacPerAb()
	Local aArea			:= getArea()
	Local OrdenConsul	:= GetNextAlias()
	Local nRet			:= 0
	Local cRA_FILIAL	:= SRA->RA_FILIAL
	Local cRA_MAT		:= SRA->RA_MAT
	Local cVACCodFol	:= '0072'	//Identificador Concepto de Vacacion
	Local cPDVAC		:= GetAdvFVal("SRV","RV_COD", xFilial("SRV") + cVACCodFol, 2, "")

	// consulta a la base de datos
	BeginSql Alias OrdenConsul

	SELECT T.RA_FILIAL, T.RA_MAT, T.RA_NOME, T.RA_ADMISSA,
	COALESCE(T.GANADOS,0) AS GANADOS, COALESCE(T.DOUDECIMAS,0) AS DOUDECIMAS, COALESCE(T.UTILIZADOS,0) AS UTILIZADOS, COALESCE(T.PROGRAMADOS,0) AS PROGRAMADOS,
	(COALESCE(T.GANADOS,0)-COALESCE(T.UTILIZADOS,0)) SALDO_SIN_PROGRAMADOS,
	CASE
	WHEN (COALESCE(T.GANADOS,0)-COALESCE(T.UTILIZADOS,0)) >= COALESCE(T.PROGRAMADOS,0)
		THEN 0
	WHEN COALESCE(T.GANADOS,0) < COALESCE(T.UTILIZADOS,0)
		THEN COALESCE(T.PROGRAMADOS,0)
	ELSE COALESCE(T.PROGRAMADOS,0) - (COALESCE(T.GANADOS,0)-COALESCE(T.UTILIZADOS,0)) END AS RESTAR
	FROM
	(SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_PROCES,
	SUM(SRF.RF_DFERVAT) GANADOS, SUM(SRF.RF_DFERAAT) DOUDECIMAS, SUM(SRF.RF_DFERANT) UTILIZADOS,
	(SELECT SUM(SR8.R8_DPAGAR-SR8.R8_DPAGOS) FROM %Table:SR8% SR8 WHERE SR8.%notDel% AND SRA.RA_FILIAL = SR8.R8_FILIAL AND SRA.RA_MAT = SR8.R8_MAT AND SR8.R8_STATUS = '' AND SR8.R8_PD = %Exp:cPDVAC%
	) PROGRAMADOS
	FROM %Table:SRA% SRA
	INNER JOIN %Table:SRF% SRF ON SRF.%notDel% AND SRA.RA_FILIAL = SRF.RF_FILIAL AND SRA.RA_MAT = SRF.RF_MAT
	WHERE SRA.%notDel%
	AND SRA.RA_FILIAL 	= %exp:cRA_FILIAL%
	AND SRA.RA_MAT  	= %exp:cRA_MAT%
	GROUP BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_ADMISSA, SRA.RA_PROCES) AS T
	ORDER BY T.RA_FILIAL, T.RA_MAT

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= (OrdenConsul)->RESTAR
	endIf
	restArea(aArea)

Return nRet
