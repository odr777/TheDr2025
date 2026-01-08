#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SUMASRD ºAutor  ³FRANZ BASCOPE          ºFecha ³  22/09/17 º±±
±±ºPrograma  ³ SUMASRD ºAutor  ³DENAR TERRAZAS         ºFecha ³  22/09/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que genera e inserta datos para cada empleado	  º±±
±±º          ³ de las AFPS		  										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user function AFP()

	//local aValores:= [1000]
	LOCAL aValores := ARRAY(13)
	local cMATanterior:= ''
	local aMAT := {}
	local aCC := {}
	local aSEM := {}
	local adf := {}
	local aValor := {}
	local nVueltas:= 1
	local nPorcentajes:= 1
	local cPerActual := Posicione("RCH",11,XFILIAL("RCH")+"FOL"+"        ","RCH_PER")
	AFILL(aValores, 0)
	dbSelectArea("SRC")
	dbSetOrder(1)
	WHILE !EOF()
		cMATanterior:= SRC->RC_MAT
		//alert(cMATanterior)
		if(SRC->RC_ROTEIR=='RET')
			while cMATanterior == SRC->RC_MAT
				aValores[val(RC_SEQ)] += SRC->RC_VALOR
				//alert(cMATanterior)
				cMATanterior := SRC->RC_MAT
				dbSkip()
			enddo
		endif
		dbSkip(-1)
		while ((nVueltas<= len(aValores)).and.(aValores[nVueltas]!= 0))
			while (nPorcentajes<= 4)
				cMat := SRC -> RC_MAT
				cCC := SRC -> RC_CC
				cSemana := SRC -> RC_SEMANA
				cDTREF := SRC -> RC_DTREF
				cPRO := SRC -> RC_PROCES
				cFil := SRC -> RC_FILIAL
				ReClock ( "SRC",.T.)

				SRC-> RC_FILIAL := cFil
				SRC-> RC_SEQ:= cvaltochar(nVueltas)
				SRC-> RC_HORAS:= nVueltas
				SRC-> RC_MAT:= cMat
				IF(nPorcentaje == 1)
					SRC-> RC_PD:= Posicione("SRV",02,XFILIAL("SRV")+"0728","RV_COD")
					SRC-> RC_VALOR:= aValores[nVueltas] * (10 / 100)
				elseIF(nPorcentaje == 2)
					SRC-> RC_PD:= Posicione("SRV",02,XFILIAL("SRV")+"0729","RV_COD")
					SRC-> RC_VALOR:= aValores[nVueltas] * (1.71 / 100)
				elseIF(nPorcentaje == 3)
					SRC-> RC_PD:= Posicione("SRV",02,XFILIAL("SRV")+"0730","RV_COD")
					SRC-> RC_VALOR:= aValores[nVueltas] * (0.50 / 100)
				else
					SRC-> RC_PD:= Posicione("SRV",02,XFILIAL("SRV")+"1228","RV_COD")
					SRC-> RC_VALOR:= aValores[nVueltas] * (0.50 / 100)
				endif
				SRC-> RC_CC:= cCC
				SRC-> RC_SEMANA:= cSemana
				SRC-> RC_ROTEIR:= "RET"
				SRC-> RC_DTREF:= cDTREF
				SRC-> RC_PERIODO := cPerActual
				SRC-> RC_PROCES:= cPRO
				SRC-> RC_TIPOCON:= '2'
				nPorcentajes++
				MSUNLOCK()
			enddo
			nPorcentajes := 1
			nVueltas++
		enddo
		nVueltas := 1
		AFILL(aValores, 0)
		dbSkip()
	ENDDO
	DBCLOSEAREA ()
	
return