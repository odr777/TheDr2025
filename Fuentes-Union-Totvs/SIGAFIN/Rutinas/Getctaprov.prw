
//Devuelve la cuenta contable para el cliente en base a su  tienda
#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

user function Getctaprov()
	Local aArea	:= GetArea()
	Local cCtactb:= ""
		
    if(M->A2_UTIPO=="1")
        cCtactb = "21102001"
    endif
    
		
    if(M->A2_UTIPO=="2")
        cCtactb = "21102002"
    endif
        

    if(M->A2_UTIPO=="3")
        cCtactb = "21102003"
    endif

    if(M->A2_UTIPO=="4")
        cCtactb = "21401001"
    endif

   if(M->A2_UTIPO=="5")
        cCtactb = "21301001"
    endif


   if(M->A2_UTIPO=="6")
        cCtactb = "21101001"
    endif

   if(M->A2_UTIPO=="7")
        cCtactb = "21101001"
    endif


   if(M->A2_UTIPO=="8")
        cCtactb = "21101003"
    endif

   if(M->A2_UTIPO=="9")
        cCtactb = "21101002"
    endif
    

    RestArea(aArea)	
		
return cCtactb
