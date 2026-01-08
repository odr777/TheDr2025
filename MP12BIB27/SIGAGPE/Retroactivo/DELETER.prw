#include 'protheus.ch'
#include 'parmtype.ch'

/**
* @author: Franz Bascope / Denar Terrazas Parada
* @since: 20/04/2018
* @description: Función que borra los cálculos realizados.
*/
user function DELETER(cRA_FILIAL, cRA_MAT)
	Local aArea		:= getArea()
	Local cFilia	:= cRA_FILIAL
	Local cPer		:= CPERIODO//Periodo que se está procesando
	dbSelectArea("SRC")
	dbsetorder(4)//RC_FILIAL+RC_MAT+RC_PERIODO+RC_ROTEIR+RC_SEMANA+RC_PD
	dbSeek(cFilia + cRA_MAT + cPer + C__ROTEIRO)
	WHILE !EOF() .and. SRC->RC_MAT == cRA_MAT .and. cPer == SRC->RC_PERIODO .and. RC_ROTEIR == C__ROTEIRO
		ReClock("SRC",.F.)
		DBDELETE()
		MSUNLOCK()
		dbSkip()
	ENDDO
	DBCLOSEAREA()
	restArea(aArea)
return
