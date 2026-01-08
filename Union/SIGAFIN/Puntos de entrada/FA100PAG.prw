#include 'protheus.ch'
#include 'parmtype.ch'

user function FA100PAG()
	Local aArea := GetArea()
	//alert("PAGAR")
	
	
	If Empty(SE5->E5_FILORIG)
		RecLock("SE5",.F.)
		SE5->E5_FILORIG := SE5->E5_FILIAL
		MsUnLock()
	Endif
	If Empty(SE5->E5_DOCUMEN)
		RecLock("SE5",.F.)
		SE5->E5_DOCUMEN := SE5->E5_IDMOVI
		MsUnLock()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impresión Movimiento Bancario			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_UCIFIN01(SE5->E5_DOCUMEN)
	RestArea(aArea)
return