
#include "totvs.ch"

//GRAVA GLOSA EN LA SE5 

USER FUNCTION FAATUBCO()
	//ADICIONAR FUNNAME
	if funname() $ "FINA171" //Prestamos Bancarios 
		RecLock("SE5", .F.)
		SE5->E5_UGLOSA := SEH->EH_XOBS
		SE5->(MsUnLock())	
	endif
	//ALERT ("FAATUBCO")
RETURN
