#include 'protheus.ch'
#include 'parmtype.ch'

user function FA100PAG()
	Local aArea := GetArea()
	//alert("PAGAR")
	U_UCIFIN01(SE5->E5_DOCUMEN)
	RestArea(aArea)
return