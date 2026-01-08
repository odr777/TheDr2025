#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CPDRNM		'041'	//Concepto Recargo Nocturno Masculino
#DEFINE CPDRNF		'047'	//Concepto Recargo Nocturno Femenino
#DEFINE CDSRCODFOL	'002A'	//Identificador DESCANSO SEM/REM DSR
#DEFINE CHEIDPON	'028A'	//Identificador Hora Extra
#DEFINE CHNIDPON	'004A'	//Identificador Hora Nocturna

/**
*
* @author: Denar Terrazas Parada
* @since: 29/04/2019
* @modified: 06/03/2020
* @description: Punto de entrada para:
*				- Modificar el concepto que se genera para Recargo nocturno de Mujeres.
*				- Convertir 8 horas extras a 9 cuando una funcionaria tiene 8 Horas Extras y 8 Horas Nocturnas
* @parameter: N/A
* @return: array con las informaciones a guardar
* @use: Industrias Belen
* @routine: PONM070.PRX - Consolida Resultados
* @help: http://tdn.totvs.com/display/public/PROT/DT_PE_PONCALATOT_Totalizacao_Eventos
*/
user function PONCALATOT()
	Local aArea		:= getArea()
	Local cSuc		:= PARAMIXB[1]
	Local cMat		:= PARAMIXB[2]
	Local aDatos	:= PARAMIXB[3]
	Local dDataDe	:= PARAMIXB[4]
	Local dDataAte	:= PARAMIXB[5]
	Local cSexo		:= ""
	Local cHECod	:= GetAdvFVal("SP9","P9_CODIGO",xFilial("SP9")+CHEIDPON,2,"")
	Local cHNCod	:= GetAdvFVal("SP9","P9_CODIGO",xFilial("SP9")+CHNIDPON,2,"")
	Local a8HE		:= {}
	Local a8HN		:= {}
	Local a8HEPos	:= {}
	//Local cPDDSR	:= GetAdvFVal("SP9","P9_EVECONT",xFilial("SP9")+CDSRCODFOL,2,"")
	If Select("SRA") > 0
		SRA->(dbCloseArea())
	Endif
	cSexo	:= Posicione("SRA", 1, cSuc + cMat, "SRA->RA_SEXO")

	if(cSexo == "F")
		for i:= 1 to len(aDatos)
			if(aDatos[i][4] == CPDRNM)
				aDatos[i][4]:= CPDRNF
			endIf
			if(aDatos[i][2] == cHECod .AND. aDatos[i][3] == 8)
				AADD(a8HE, aDatos[i][1])
				AADD(a8HEPos, i)
			endIf
			if(aDatos[i][2] == cHNCod .AND. aDatos[i][3] == 8)
				AADD(a8HN, aDatos[i][1])
			endIf
		next i

		for i:= 1 to Len(a8HN)
			nPos:= ASCAN(a8HE, a8HN[i])
			If(nPos > 0)
				nPos:= a8HEPos[nPos]
				aDatos[nPos][3]:= 9
			EndIf
		next i
	endIf

	restArea(aArea)
return aDatos

/**
*
* @author: Denar Terrazas Parada
* @since: 06/03/2020
* @description: Funcion que devuelve el nro de feriados en el mes.
* @parameter: 	dDataDe -> Fecha de Inicio del Periodo.
*				dDataAte-> Fecha de Fin del Periodo.
*/
static function getFeriados(dDataDe, dDataAte)
	Local aArea			:= getArea()
	Local nRet			:= 0
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT COUNT(*) FERIADOS
		FROM %table:SP3% SP3
		WHERE P3_DATA BETWEEN %exp:DTOS(dDataDe)% AND %exp:DTOS(dDataAte)%
		OR P3_MESDIA BETWEEN %exp:SUBSTRING(DTOS(dDataDe), 5, 4)% AND %exp:SUBSTRING(DTOS(dDataAte), 5, 4)%
		AND SP3.%notdel%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= (OrdenConsul)->FERIADOS
	endIf
	(OrdenConsul)->(DbCloseArea())
	restArea(aArea)
return nRet
