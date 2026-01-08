#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณFRANZ BASCOPE          บFecha ณ  22/09/17 บฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณDENAR TERRAZAS         บFecha ณ  22/09/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.  ณ Funcion que filtra los empleados por Periodo y por PD 	      บฑฑ
ฑฑบ       ณ inserta datos en la SRC de retroactivo haber basico(RVINRETRO)บฑฑ
ฑฑบ       ณ y retroactivo bono antiguedad (RVINBA)     				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function CALCRET()
	local aInret := RVINRETRO()
	local aInba := RVINBA()
	local cPerActual := Posicione("RCH",11,XFILIAL("RCH")+"FOL"+"        ","RCH_PER")
	local cPerInicio := SUBSTR(cPerActual, 1, 4) + "01"
	local nAnho:= val(SUBSTR(cPerActual, 1, 4))-1
	
	Pergunte("GP020RET",.T.)
	nSueldo := val(alltrim(mv_par01)) / 100
	nAntiguedad := val(alltrim(mv_par02))/ 100
	

	nCalculos:= 1
	nMinimo:= VAL(ALLTRIM(Posicione("RCC",1,'  '+'S005'+'  '+'201607'+'001',"RCC_CONTEU")))
	// RECORREMOS LOS EMPLEADOS

	while nCalculos <= 2
		cAnterior := ""
		nIncrement:= 1
		nContador:= 0
		aListaPD := {}
		aListaPer := {}
		aPerfinal := {}
		aRD := {}
		aMAT := {}
		aCC := {}
		aSEM := {}
		aPD := {}
		dFechaRef := {}
		aFilial := {}
		aProces := {}
		cFilia:= ""
		//Filtro por el campo RD_PD y obtencion de todos los periodos
		if(nCalculos == 1)
			aListaPD := aInret
		else
			aListaPD := aInba
		endif
		dbSelectArea("SRD")
		dbSetOrder(15)
		WHILE !EOF() //.and. RD_MAT == SRA->RA_MAT
			//IF(val(SUBSTR(RD_PERIODO, 1, 4)) == nAnho)
			while nContador< len(aListaPD )
				nContador++
				if(RD_PD == aListaPD[nContador] .and. RD_PERIODO >= cPerInicio )
					AADD (aListaPer, SRD->RD_PERIODO)
					AADD (aRD, SRD->RD_VALOR)
					AADD (aMAT, SRD->RD_MAT)
					AADD (aCC, SRD->RD_CC)
					AADD (aSEM, SRD->RD_SEMANA)
					AADD (aPD, SRD->RD_PD)
					AADD (aProces, SRD->RD_PROCES)
					AADD (aFilial, SRD->RD_FILIAL)
					AADD (dFechaRef, SRD->RD_DTREF)

				endif
			enddo
			//ENDIF
			nContador := 0
			dbSkip()

		ENDDO
		dbclosearea()
		//Filtrado de Periodos en el rango
		nListPER := 1
		DBSELECTAREA ( "SRC")
		while nListPER <= len(aListaPer) //.AND.
			if val(aListaPer[nListPER]) >= val(cPerInicio) .and. val(aListaPer[nListPER]) < val(cPerActual)
			
			cFilia := Posicione("SRA",27,aMAT[nListPER]+" ","RA_FILIAL")
			if EMPTY(cFilia)
				cFilia:= Posicione("SRA",27,aMAT[nListPER]+"F","RA_FILIAL")
				if EMPTY(cFilia)
					cFilia:= Posicione("SRA",27,aMAT[nListPER]+"A","RA_FILIAL")
				endif
			endif	
				nVal:= aRD[nListPER]
				if nCalculos == 1
					if(nVal <= nMinimo)
						nVal := nVal* nAntiguedad
					else
						nVal := nVal* nSueldo
					endif
				else
					nVal := nVal* nAntiguedad
				endif

				cAux:= Posicione("SRA",1,aFilial[nListPER]+aMAT[nListPER],"RA_ADMISSA")
				nAdmision := val(SUBSTR(DToC(cAux),7))
				IF  nAdmision<= nAnho .and. cFilia!= ' '

					if(cAnterior != aMAT[nListPER])
						nIncrement := 1
					endif
					ReClock ( "SRC",.T.)
					SRC-> RC_SEQ:= cvaltochar(nIncrement)
					SRC-> RC_MAT:= aMAT[nListPER]
					SRC-> RC_PERIODO:= cPerActual
					SRC-> RC_PD:= aPD[nListPER]
					SRC-> RC_CC:= aCC[nListPER]
					SRC-> RC_SEMANA:= aSEM[nListPER]
					SRC-> RC_VALOR:= nVal
					SRC-> RC_ROTEIR:= "RET"
					SRC-> RC_DTREF:= dFechaRef[nListPER]
					SRC-> RC_FILIAL:= cFilia
					SRC-> RC_PROCES:= aProces[nListPER]
					SRC-> RC_HORAS:= val(SUBSTR(aListaPer[nListPER],6))
					if nCalculos == 1
					if(nVal <= nMinimo)
						SRC -> RC_VALINFO := nSueldo * 100
					else
						SRC -> RC_VALINFO := nAntiguedad * 100
					endif					
					else
					SRC -> RC_VALINFO := nAntiguedad * 100
					ENDIF
					cAnterior := aMAT[nListPER]
					nIncrement++
					MSUNLOCK()
				ENDIF
			endif
			nListPER++
		ENDDO
		dbclosearea()
		nCalculos++
	enddo

return

static function RVINRETRO()
	local aLista := {}
	dbSelectArea("SRV")
	dbSetOrder(8)
	dbSeek(xFilial("SRV")+ "S")
	WHILE !EOF()
		AADD (aLista,RV_COD)
		dbSkip()
	ENDDO
	dbclosearea()
return aLista

static function RVINBA()
	local aLista := {}
	dbSelectArea("SRV")
	dbSetOrder(9)
	dbSeek(xFilial("SRV")+ "S")
	WHILE !EOF()
		AADD (aLista,RV_COD)
		dbSkip()
	ENDDO
	dbclosearea()
return aLista
