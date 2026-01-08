#include 'protheus.ch'
#include 'parmtype.ch'

user function A100BL01()
	Local aArea := GetArea()
	U_UCTRANSB(SE5->E5_DOCUMEN)
	//pergunte("AFI100",.F.)
	RestArea(aArea)
return