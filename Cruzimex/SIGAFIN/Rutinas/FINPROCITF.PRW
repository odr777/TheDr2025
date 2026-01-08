#include 'protheus.ch'

USER FUNCTION FINPROCITF()
	nNroRecSE5 := ParamIxb[1] // obtengo el nro de recno
	nTIPOITF := ParamIxb[2] // obtengo la opci�n (3 est� guardando)
	if nTIPOITF == 3
		aArea := GetArea("SE5")
		nReOri :=  SE5->(Recno())
		dbSelectArea("SE5")
		dbGoto(nNroRecSE5)
		nITFVal := SE5->E5_VALOR
		//	alert("RECNO "+ cvaltochar(nNroRecSE5))
		//	alert("nTIPOITF "+ cvaltochar(nTIPOITF))
		restArea(aArea)
		dbGoto(nReOri)
		
		RecLock("SE5",.F.)
		SE5->E5_HISTOR := "ITF Sobre Monto de : " + cvaltochar(nITFVal)
		SE5->E5_UCOBS  := "RECNO Origen: "+ cvaltochar(nNroRecSE5)
		
		If Empty(SE5->E5_FILORIG)
			SE5->E5_FILORIG := SE5->E5_FILIAL
		Endif
		SE5->(MsUnLock())
	Endif

RETURN