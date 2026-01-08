#include 'protheus.ch'
#include 'parmtype.ch'

user function A100BL01()
	Local aArea := GetArea()
	// ConfirmSX8()
	if type("nrCorrSe5") <> "U"
		nrCorrSe5 := NIL
		FreeObj(nrCorrSe5)
	endif
	
	U_UCTRANSB(SE5->E5_DOCUMEN) // Impresión de transferencia.
	//pergunte("AFI100",.F.)
	RestArea(aArea)
return
