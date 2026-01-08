
//Devuelve la cuenta contable Anticipo para el proveedor en base a su tipo y  tienda
#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

user function GetAntProv()
	Local aArea	:= GetArea()
	Local cCtactb:= "11202005"


    if(M->A2_UTIPO=="6".AND.M->LOJA=="01")
        cCtactb = "11202006"
    endif


    if(M->A2_UTIPO=="8")
        cCtactb = "11202003"
    endif

    if(M->A2_UTIPO=="9".AND.M->LOJA=="63")
        cCtactb = "11202006"
    endif    

    if(M->A2_UTIPO=="9".AND.M->LOJA!="63")
        cCtactb = ""
    endif    

    RestArea(aArea)	
		
return cCtactb
