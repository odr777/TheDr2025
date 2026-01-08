#INCLUDE "rwmake.ch"



User Function FA86ASE5
Local aRet := GetArea()

If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo'
    alert(SE5->E5_ORDREC )
EndIf

RestArea(aRet)
Return
