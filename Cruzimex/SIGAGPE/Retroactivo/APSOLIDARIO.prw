#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณFRANZ BASCOPE          บFecha ณ  22/09/17 บฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณDENAR TERRAZAS         บFecha ณ  22/09/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion que suma los totales ganados por emleado 		  บฑฑ
ฑฑบ          ณ de la tabla SRD y SUMA los retroactivos de la SRC 		  บฑฑ
ฑฑบ          ณ y genera aporte solidario si necesario     				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function APSOLIDARIO()
	local cPerActual := Posicione("RCH",11,XFILIAL("RCH")+"FOL"+"        ","RCH_PER")
	local cPerInicio := SUBSTR(cPerActual, 1, 4) + "01"
	local nPerInicio := val(SUBSTR(cPerActual, 1, 4) + "01")
	local aSolid := APSPARAM()
	local cFil
	local cSeq
	local cHoras
	local cCC
	local cSemana
	local cRoteir
	local dDtref
	local cProces
	local aEmpleados := SRCEMPLEADOS()
	nInicio := nPerInicio
	nContE := 1
	nSrc := 0
	dbSelectArea("SRC")
	dbSetOrder(18)

	while nContE <= len(aEmpleados)


		nSeq := 1

		while (nPerInicio >= val(cPerInicio) .and. nPerInicio < val(cPerActual))
			nvalor := (Posicione("SRD",15,aEmpleados[nContE] + cvaltochar(nPerInicio) + "593","SRD->RD_VALOR"))

			dbSeek(aEmpleados[nContE] + cPerActual + "RET" + cvaltochar(nSeq))

			WHILE aEmpleados[nContE] == RC_MAT .and. RC_HORAS == nSeq
				IF(RC_PD != Posicione("SRV",02,XFILIAL("SRV")+"0728","RV_COD") .AND. RC_PD != Posicione("SRV",02,XFILIAL("SRV")+"0729","RV_COD") .AND. RC_PD != Posicione("SRV",02,XFILIAL("SRV")+"0730","RV_COD") .AND. RC_PD != Posicione("SRV",02,XFILIAL("SRV")+"1228","RV_COD"))
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
			dDtref := RC_DTREF
			cProces := RC_PROCES
	
			if(len(aAportes) != 0 )
						
				while (nWhile <= nPorcentaje)
			
					ReClock ( "SRC",.T.)
					SRC-> RC_FILIAL:= cFil
					SRC-> RC_MAT:= aEmpleados[nContE]
					SRC-> RC_PD:= SUBSTRING(aSolid[nWhile],23,25)
					SRC-> RC_CC:= cCC
					SRC-> RC_SEMANA:= cSemana
					SRC-> RC_SEQ:= cvaltochar(nSeq)
					SRC-> RC_HORAS:= cHoras
					SRC-> RC_VALOR:= aAportes[nWhile]
					SRC-> RC_ROTEIR:= 'RET'
					SRC-> RC_DTREF:= dDtref
					SRC-> RC_PERIODO:= cPerActual
					SRC-> RC_PROCES:= cProces
					MSUNLOCK()
					nWhile++
				enddo
			
			endif
			nSrc := 0
			nSeq++
			nPerInicio++
		enddo
		nPerInicio := nInicio
		nContE++
	enddo
	dbCloseArea()
return

static function SRCEMPLEADOS()

	local aEmpleados := {}
	dbSelectArea("SRC")
	dbSetOrder(1)
	cMatanterior := ' ';

	WHILE !EOF()
		IF (cMatanterior!=RC_MAT .and. RC_ROTEIR=='RET'  )
			AADD(aEmpleados,RC_MAT)
			cMatanterior:= RC_MAT
		ENDIF
		dbskip()
	enddo
	DBCLOSEAREA()
return aEmpleados

static function APSPARAM()
	local aLista := {}
	dbSelectArea("RCC")
	dbsetorder(1)
	WHILE !EOF()
		if(RCC_CODIGO=='S011')
			aadd(aLista,RCC_CONTEU)
		ENDIF
		dbskip()
	enddo
	dbclosearea()
return aLista