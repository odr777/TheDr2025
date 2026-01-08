#include 'protheus.ch'
#include 'parmtype.ch'

user function FA100REC()
	Local aArea := GetArea()
	//ALERT("COBRAR")
	U_UCIFIN01(SE5->E5_DOCUMEN)
	RestArea(aArea)
return