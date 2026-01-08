
//Devuelve la cuenta contable para el cliente en base a su  tienda
#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

user function Getctactb()
	Local aArea	:= GetArea()
	Local cCtactb:= ""
		
	if VAL(A1_LOJA)>=1.AND.VAL(A1_LOJA)<=58
		cCtactb = "11201001"
	endif

	
	if Alltrim(M->A1_LOJA)=="59"
		cCtactb = "11201002"
	endif
	
	if Alltrim(M->A1_LOJA)$"60|61"
		cCtactb = "11202001"
	endif

	if Alltrim(M->A1_LOJA)$"62|63"
		cCtactb = "11202002"
	endif

    RestArea(aArea)	
		
return cCtactb
