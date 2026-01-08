#include 'protheus.ch'

USER FUNCTION FINPROCITF()
	nNroRecSE5 := ParamIxb[1] // obtengo el nro de recno
	nTIPOITF := ParamIxb[2] // obtengo la opción (3 está guardando)
	If nTIPOITF == 3
		aArea := GetArea("SE5")
		nReOri :=  SE5->(Recno())
		dbSelectArea("SE5")
		dbGoto(nNroRecSE5)
		nITFVal := SE5->E5_VALOR
		//	alert("RECNO "+ cvaltochar(nNroRecSE5))
		//	alert("nTIPOITF "+ cvaltochar(nTIPOITF))
		restArea(aArea)
		dbGoto(nReOri)
		SE5->E5_HISTOR := "ITF Sobre Monto de : " + cvaltochar(nITFVal)
		SE5->E5_UCOBS  := "RECNO Origen: "+ cvaltochar(nNroRecSE5)
		
		If Empty(SE5->E5_FILORIG)			
			SE5->E5_FILORIG := SE5->E5_FILIAL
		Endif
	Endif

RETURN