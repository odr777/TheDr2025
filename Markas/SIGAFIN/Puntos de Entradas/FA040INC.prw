#include 'protheus.ch'
#include 'parmtype.ch'

user function FA040INC()
Local OK := .T.

If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo'
	ALERT(M->E1_NOMCLI)
	ALERT(SE1->E1_NOMCLI)
EndIf

return(OK)
