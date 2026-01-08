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
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºModif.    ³ Omar Delgadillo ³ 28.05.25 ³ Traer los parametros de tabla º±±
±±º          ³ RCC CODIGO S011 		  									  º±±
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
	cFilialPer	:= U_getFilialPeriodoRet(cRA_MAT,cPerRET)//obtiene la sucursal del empleado en el periodo enviado.
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

	IF (nSrc>0) // SI EXISTE VALOR PARA RETROACTIVO

		aAportes:= {}
		nWhile := 1
		nPorcentaje := 0

		cFil 	:= RC_FILIAL
		cHoras 	:= RC_HORAS
		cCC 	:= RC_CC
		cSemana := RC_SEMANA
		cProces := RC_PROCES
		
		nPerAp1	:= (If( FTABELA("S011",1,5,dDataRef) <> Nil, FTABELA("S011",1,5,dDataRef), FTABELA("S011",1,5 )))/100
		nPerAp2	:= (If( FTABELA("S011",2,5,dDataRef) <> Nil, FTABELA("S011",2,5,dDataRef), FTABELA("S011",2,5 )))/100
		nPerAp3	:= (If( FTABELA("S011",3,5,dDataRef) <> Nil, FTABELA("S011",3,5,dDataRef), FTABELA("S011",3,5 )))/100
		nValAp1 := If( FTABELA("S011",1,6,dDataRef) <> Nil, FTABELA("S011",1,6,dDataRef), FTABELA("S011",1,6 ))	//13000
		nValAp2 := If( FTABELA("S011",2,6,dDataRef) <> Nil, FTABELA("S011",2,6,dDataRef), FTABELA("S011",2,6 ))	//25000
		nValAp3 := If( FTABELA("S011",3,6,dDataRef) <> Nil, FTABELA("S011",3,6,dDataRef), FTABELA("S011",3,6 )) //35000

		if nvalor > nValAp1

			if( nvalor + nSrc > nValAp1 .and. nvalor+nSrc < nValAp2)
				aadd(aAportes,(((nValor+nSrc - nValAp1) * nPerAp1) - ((nValor - nValAp1) * nPerAp1)))
				nPorcentaje := 1
			elseif (nvalor+nSrc > nValAp2 .and. nvalor+nSrc < nValAp3)
				aadd(aAportes,(((nValor+nSrc - nValAp1) * nPerAp1) - ((nValor - nValAp1) * nPerAp1)))
				aadd(aAportes,(((nValor+nSrc - nValAp2) * nPerAp2) - ((nValor - nValAp2) * nPerAp2)))
				nPorcentaje := 2
			elseif( nvalor+nSrc > nValAp3)
				aadd(aAportes,(((nValor+nSrc - nValAp1) * nPerAp1) - ((nValor - nValAp1) * nPerAp1)))
				aadd(aAportes,(((nValor+nSrc - nValAp2) * nPerAp2) - ((nValor - nValAp2) * nPerAp2)))
				aadd(aAportes,(((nValor+nSrc - nValAp3) * nPerAp3) - ((nValor - nValAp3) * nPerAp3)))
				nPorcentaje := 3
			endif
		else
			if( nvalor+nSrc > nValAp1 .and. nvalor+nSrc < nValAp2)
				aadd(aAportes,((nValor+nSrc - nValAp1) * nPerAp1))
				nPorcentaje := 1
			elseif (nvalor+nSrc > nValAp2 .and. nvalor+nSrc < nValAp3)
				aadd(aAportes,((nValor+nSrc - nValAp1) * nPerAp1))
				aadd(aAportes,((nValor+nSrc - nValAp2) * nPerAp2))
				nPorcentaje := 2
			elseif( nvalor+nSrc > nValAp3)
				aadd(aAportes,((nValor+nSrc - nValAp1) * nPerAp1))
				aadd(aAportes,((nValor+nSrc - nValAp2) * nPerAp2))
				aadd(aAportes,((nValor+nSrc - nValAp3) * nPerAp3))
				nPorcentaje := 3
			endif
		endif

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
	EndIf
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
