#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SUMASRD ºAutor  ³FRANZ BASCOPE          ºFecha ³  22/09/17 º±±
±±ºPrograma  ³ SUMASRD ºAutor  ³DENAR TERRAZAS         ºFecha ³  22/09/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que suma los totales ganados por emleado 		  º±±
±±º          ³ de la tabla SRD y SUMA los retroactivos de la SRC 		  º±±
±±º          ³ y genera aporte solidario si necesario     				  º±±
±±º          ³ C__ROTEIRO -> Procedimiento que se está procesando		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function APSOLIDARIO(cRA_FILIAL, cRA_MAT)
	Local aArea		:= getArea()
	Local cPerActual:= CPERIODO//Periodo que se está procesando
	Local cPerRET	:= SUBSTR(cPerActual, 1, 4) + STRZERO(VAL(SUBSTR(C__ROTEIRO, 3)), 2, 0)
	Local aSolid	:= APSPARAM()
	Local cFil
	Local cHoras
	Local cCC
	Local cSemana
	Local cProces
	Private dDataRef:= LastDate(STOD(cPerActual + "01"))//Ultimo dia del mes
	cFilia	:= cRA_FILIAL
	cFilialPer	:= staticCall(CALCRET, getFilialPeriodoRet,cRA_MAT,cPerRET)//obtiene la sucursal del empleado en el periodo enviado.
	nContE	:= 1
	nSrc	:= 0
	dbSelectArea("SRC")
	dbSetOrder(4)//RC_FILIAL+RC_MAT+RC_PERIODO+RC_ROTEIR+RC_SEMANA+RC_PD
	dbSeek(cFilia + cRA_MAT + cPerActual + C__ROTEIRO)

	nvalor := (Posicione("SRD",3,cFilialPer + cRA_MAT + cPerRET + cPerRET + FGETCODFOL("1227"),"SRD->RD_VALOR"))//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC

	WHILE cRA_MAT == RC_MAT  .and. RC_ROTEIR == C__ROTEIRO
		cTipoCod:= GetAdvFVal("SRV", "RV_TIPOCOD", xFilial("SRV") + RC_PD ,1,"")//RV_FILIAL+RV_COD
		If(cTipoCod == '1')//Si es concepto de Remuneración
			nSrc += RC_VALOR
		ENDIF
		dbSkip()
	ENDDO
	dbSkip(-1)

	aAportes:= {}
	nWhile := 1
	nPorcentaje := 0

	if nvalor > 13000

		if( nvalor + nSrc > 13000 .and. nvalor+nSrc < 25000)

			aadd(aAportes,(((nValor+nSrc - 13000) * 0.01) - ((nValor - 13000) * 0.01)))

			nPorcentaje := 1
		elseif (nvalor+nSrc > 25000 .and. nvalor+nSrc < 35000)

			aadd(aAportes,(((nValor+nSrc - 13000) * 0.01) - ((nValor - 13000) * 0.01)))
			aadd(aAportes,(((nValor+nSrc - 25000) * 0.05) - ((nValor - 25000) * 0.05)))
			nPorcentaje := 2
		elseif( nvalor+nSrc > 35000)

			aadd(aAportes,(((nValor+nSrc - 13000) * 0.01) - ((nValor - 13000) * 0.01)))
			aadd(aAportes,(((nValor+nSrc - 25000) * 0.05) - ((nValor - 25000) * 0.05)))
			aadd(aAportes,(((nValor+nSrc - 35000) * 0.1) - ((nValor - 35000) * 0.1)))
			nPorcentaje := 3
		endif
	else
		if( nvalor+nSrc > 13000 .and. nvalor+nSrc < 25000)
			aadd(aAportes,((nValor+nSrc - 13000) * 0.01))

			nPorcentaje := 1
		elseif (nvalor+nSrc > 25000 .and. nvalor+nSrc < 35000)
			aadd(aAportes,((nValor+nSrc - 13000) * 0.01))
			aadd(aAportes,((nValor+nSrc - 25000) * 0.05))

			nPorcentaje := 2
		elseif( nvalor+nSrc > 35000)

			aadd(aAportes,((nValor+nSrc - 13000) * 0.01))
			aadd(aAportes,((nValor+nSrc - 25000) * 0.05))
			aadd(aAportes,((nValor+nSrc - 13000) * 0.01))
			nPorcentaje := 3
		endif
	endif

	cFil := RC_FILIAL

	cHoras := RC_HORAS
	cCC := RC_CC
	cSemana := RC_SEMANA
	cProces := RC_PROCES

	if(len(aAportes) != 0 )

		while (nWhile <= nPorcentaje)
			IF(aAportes[nWhile] != 0)
				ReClock ( "SRC",.T.)
				SRC->RC_FILIAL	:= cFil
				SRC->RC_MAT		:= cRA_MAT
				SRC->RC_PD		:= SUBSTRING(aSolid[nWhile],23,25)
				SRC->RC_CC		:= cCC
				SRC->RC_SEMANA	:= cSemana
				SRC->RC_HORAS	:= cHoras
				SRC->RC_VALOR	:= ROUND(aAportes[nWhile], 2)
				SRC->RC_ROTEIR	:= C__ROTEIRO//C__ROTEIRO -> Procedimiento que se está procesando
				SRC->RC_PERIODO	:= cPerActual
				SRC->RC_PROCES	:= cProces
				SRC-> RC_DTREF	:= dDataRef
				SRC-> RC_DATA	:= dDataRef
				MSUNLOCK()
			ENDIF
			nWhile++

		enddo

	endif
	dbCloseArea()
	restArea(aArea)
return

static function APSPARAM()
	Local aArea		:= getArea()
	Local aLista	:= {}
	dbSelectArea("RCC")
	dbsetorder(1)
	WHILE !EOF()
		if(RCC_CODIGO=='S011')
			aadd(aLista,RCC_CONTEU)
		ENDIF
		dbskip()
	enddo
	dbclosearea()
	restArea(aArea)
return aLista
