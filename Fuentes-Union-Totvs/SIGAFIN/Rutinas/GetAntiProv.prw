
//Devuelve la cuenta contable Anticipo para el proveedor en base a su tipo y  tienda
#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

user function GetAntiProv()
	Local aArea	:= GetArea()
	Local cCtactb:= "11202005"


    //if M->A2_UTIPO=="6".AND.Alltrim(M->A2_LOJA)=="01"
    if M->A2_UTIPO=="6"
        cCtactb = "11202005"
    endif


    if(M->A2_UTIPO=="8")
        cCtactb = "11202003"
    endif



    /*
    if M->A2_UTIPO=="9".AND.ALLTRIM(M->A2_LOJA)=="63"
        cCtactb = "11202006"
    endif    

    
    if M->A2_UTIPO=="9".AND.ALLTRIM(M->A2_LOJA)!="63"
        cCtactb = ""
    endif    
    */

    if M->A2_UTIPO=="9"
        cCtactb = "11202006"
    endif    

    RestArea(aArea)	
		
return cCtactb
