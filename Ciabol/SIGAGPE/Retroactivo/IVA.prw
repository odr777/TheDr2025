#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณFRANZ BASCOPE          บFecha ณ  22/09/17 บฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณDENAR TERRAZAS         บFecha ณ  22/09/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion que suma los retroactivos de remuneracion 		  บฑฑ
ฑฑบ          ณ y los resta con los retractivos de descuento de AFPs 	  บฑฑ
ฑฑบ          ณ e inserta su diferencia en ls SRC por cada empleado        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


user function IVA()
 
 
	local aEmpleados := {}
	Local nCont := 1
	Local nSuma := 0
	Local Resta := 0
	Local Resultado := 0
	local cPerActual := Posicione("RCH",11,XFILIAL("RCH")+"FOL"+"        ","RCH_PER")
	Local aPdSuma := {}
	Local nContSum := 1
	Local aPdAfpSol := {}
	Local AFP1 := 0
	Local AFP2 := 0
	Local AFP3 := 0
	Local nFILIAL :=" "
	
		
	
	dbSelectArea("RCC")
	dbsetorder(1)
	WHILE !EOF()
		if( RCC_CODIGO =='S011' ) 
			aadd(aPdAfpSol,RCC_CONTEU)
		ENDIF
	dbskip()
	enddo
	dbclosearea()	
	AFP1 := SUBSTRING(aPdAfpSol[1],23,25)
	AFP2 := SUBSTRING(aPdAfpSol[2],23,25)
	AFP3 := SUBSTRING(aPdAfpSol[3],23,25)
	cAfp1 := Posicione("SRV",02,XFILIAL("SRV")+"0728","RV_COD")
	cAfp2 := Posicione("SRV",02,XFILIAL("SRV")+"0729","RV_COD")
	cAfp3 := Posicione("SRV",02,XFILIAL("SRV")+"0730","RV_COD")
	cAfp4 := Posicione("SRV",02,XFILIAL("SRV")+"1228","RV_COD")
	
	dbSelectArea("SRV")
	dbsetorder(1)
	dbGoTop()
		WHILE !EOF()
			if(RV_INRETRO=='S'.OR. RV_INRETBA=='S')
				AADD (aPdSuma, RV_COD)
			endif
			
		dbskip()
		enddo
	dbclosearea()
	
	dbSelectArea("SRC")
	dbSetOrder(1)
	cMatanterior := ' '	
	WHILE !EOF()
		IF (cMatanterior!=RC_MAT .and. RC_ROTEIR='RET'  )
		AADD(aEmpleados,RC_MAT)
		cMatanterior:= RC_MAT
		ENDIF	
		dbskip()
	enddo
	dbclosearea()
	

	WHILE nCont <= LEN(aEmpleados)
	dbSelectArea("SRC")
	dbSetOrder(1)	 
	dbGoTop()
	EMPLEADOS := aEmpleados[nCont]
	WHILE !EOF()	
	if( RC_MAT = EMPLEADOS .and. RC_ROTEIR == 'RET')
	  		nContSum := 1
			WHILE nContSum <= LEN(aPdSuma)
			if (RC_PD = aPdSuma[nContSum])
				nSUMA += RC_VALOR	
				nFILIAL := RC_FILIAL
															
			endif
			nContSum++
			Enddo
			
			IF(RC_PD = CVALTOCHAR(ALLTRIM(AFP1)) .OR. RC_PD = CVALTOCHAR(ALLTRIM(AFP2)) .OR. RC_PD = CVALTOCHAR(ALLTRIM(AFP3)) .OR. RC_PD = cAfp1 .OR. RC_PD = cAfp2 .OR. RC_PD = cAfp3 .OR. RC_PD = cAfp4)
				RESTA += RC_VALOR
			endif
			
	endif
	 dbskip()
	ENDDO	
	Resultado = nSUMA - RESTA
	ReClock ( "SRC",.T.)
			SRC-> RC_FILIAL:= nFILIAL
			SRC-> RC_MAT:= EMPLEADOS
			SRC-> RC_PERIODO:= cPerActual
			SRC-> RC_PD:= '992'
			SRC-> RC_VALOR:= Resultado
			SRC-> RC_ROTEIR:= "RET"			
			SRC-> RC_PROCES:= '0001'
			SRC-> RC_SEMANA:= '01'
			MSUNLOCK()
	DBCLOSEAREA()
	
	nCont ++
	nSUMA := 0
	RESTA := 0 
	Resultado := 0
	nFILIAL :=" "
	
	ENDDO
	 
	
return 

