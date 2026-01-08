#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SUMASRD ºAutor  ³FRANZ BASCOPE          ºFecha ³  19/03/18 º±±
±±ºPrograma  ³ SUMASRD ºAutor  ³DENAR TERRAZAS         ºFecha ³  19/03/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que genera e inserta datos para cada empleado	  º±±
±±º          ³ de las AFPS		  										  º±±
±±º          ³ C__ROTEIRO -> Procedimiento que se está procesando		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function AFP(cRA_FILIAL, cRA_MAT)
	Local aArea			:= getArea()
	Local cPerActual 	:= CPERIODO//Periodo que se está procesando
	Local cPerRET		:= SUBSTR(cPerActual, 1, 4) + STRZERO(VAL(SUBSTR(C__ROTEIRO, 3)), 2, 0)
	Local nBase			:= 0
	Local cFilia		:= cRA_FILIAL
	Local nAFPTotal		:= 0
	Private dDataRef	:= LastDate(STOD(cPerActual + "01"))//Ultimo dia del mes
	dbSelectArea("SRC")
	dbsetorder(4)//RC_FILIAL+RC_MAT+RC_PERIODO+RC_ROTEIR+RC_SEMANA+RC_PD
	dbSeek(cFilia + cRA_MAT + cPerActual + C__ROTEIRO)
	WHILE !EOF() .AND. SRC->RC_MAT == cRA_MAT .AND. SRC->RC_FILIAL == cFilia;
			.AND. SRC->RC_PERIODO == cPerActual .AND. SRC->RC_ROTEIR == C__ROTEIRO
		cTipoCod:= GetAdvFVal("SRV", "RV_TIPOCOD", xFilial("SRV") + RC_PD ,1,"")//RV_FILIAL+RV_COD
		If(cTipoCod == '1')//Si es concepto de Remuneración
			nBase += SRC->RC_VALOR
		EndIf
		dbSkip()
	enddo
	dbSkip(-1)

	If(nBase > 0)
		cCC 	:= SRC -> RC_CC
		cSemana := SRC -> RC_SEMANA
		cDTREF	:= SRC -> RC_DTREF
		cPRO	:= SRC -> RC_PROCES
		cFilialPer	:= staticCall(CALCRET, getFilialPeriodoRet,cRA_MAT,cPerRET)//obtiene la sucursal del empleado en el periodo enviado.

		//AFP L/VEJEZ 10%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0728") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (10 / 100)
			nValor:= ROUND(nValor, 2)
			nAFPTotal+= nValor
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 10)
		EndIf

		//AFP L/ RIESGO 1.71%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0729") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (1.71 / 100)
			nValor:= ROUND(nValor, 2)
			nAFPTotal+= nValor
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 1.71)
		EndIf

		//AFP L/ COMISIÓN 0.5%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0730") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (0.50 / 100)
			nValor:= ROUND(nValor, 2)
			nAFPTotal+= nValor
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 0.5)
		EndIf

		//AFP L/APOR.SOLID 0.5%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("1228") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (0.50 / 100)
			nValor:= ROUND(nValor, 2)
			nAFPTotal+= nValor
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 0.5)
		EndIf

		//AFP LAB TOTAL 12.71%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0769") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd) .AND. nAFPTotal > 0)
			insert(cFilia, cRA_MAT, cPd, nAFPTotal, cCC, cSemana, cDTREF, cPerActual, cPRO, 12.71)
		EndIf

		//----------------PATRONALES----------------
		//AFP P/RIES.PROF.1.71
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0735") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (1.71 / 100)
			nValor:= ROUND(nValor, 2)
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 1.71)
		EndIf

		//AFP P/ SOLIDARIO 3%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("1211") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (3 / 100)
			nValor:= ROUND(nValor, 2)
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 3)
		EndIf

		//AFP P/ PRO VIVIEN 2%
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0734") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (2 / 100)
			nValor:= ROUND(nValor, 2)
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 2)
		EndIf

		//APORTE CAJA DE SALUD
		cPd:= GetAdvFVal("SRD", "RD_PD", cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("0736") ,3,"")//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		If(!Empty(cPd))
			nValor:= nBase * (10 / 100)
			nValor:= ROUND(nValor, 2)
			insert(cFilia, cRA_MAT, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, 10)
		EndIf

	EndIf
	dbCloseArea()
	restArea(aArea)
return

/**
* @author: Denar Terrazas Parada
* @since: 19/03/2018
* @description: Funcion que inserta los datos enviados en los parámetros en la tabla SRC
*/
static function insert(cFil, cMat, cPd, nValor, cCC, cSemana, cDTREF, cPerActual, cPRO, nHoras)
	Local aArea := getArea()
	//dbSelectArea("SRC")
	ReClock ( "SRC",.T.)

	SRC-> RC_FILIAL := cFil
	SRC-> RC_HORAS	:= nHoras
	SRC-> RC_MAT	:= cMat
	SRC-> RC_PD		:= cPd
	SRC-> RC_VALOR	:= nValor
	SRC-> RC_CC		:= cCC
	SRC-> RC_SEMANA	:= cSemana
	SRC-> RC_ROTEIR	:= C__ROTEIRO//C__ROTEIRO -> Procedimiento que se está procesando
	SRC-> RC_DTREF	:= cDTREF
	SRC-> RC_PERIODO:= cPerActual
	SRC-> RC_PROCES	:= cPRO
	SRC-> RC_DTREF	:= dDataRef
	SRC-> RC_DATA	:= dDataRef

	MSUNLOCK()
	//dbCloseArea()
	restArea(aArea)
return
