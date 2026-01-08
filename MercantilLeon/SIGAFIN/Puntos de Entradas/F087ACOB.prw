#include 'protheus.ch'
#include 'parmtype.ch'

//ERICK ETCHEVERRY codigo de vendedor
user function F087ACOB()
	Local cCodVen := ""

	cCodVen := Posicione("SAQ",1,XFILIAL("SAQ") + Retcodusr(), "AQ_COD")

return cCodVen