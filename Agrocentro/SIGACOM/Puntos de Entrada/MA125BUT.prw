#include 'protheus.ch'

/*/{Protheus.doc} MA125BUT
Añadir opción Conocimiento.
@type function
@version 1.1 
@author jbravo
@since 01/12/2023
/*/

User Function MA125BUT()
Local aArea := GetArea()
Local nRec := SC3->(RECNO())
Local aButtons := {}

    If !INCLUI
        aAdd(aButtons,{'Conocimiento',{|| MsDocument( 'SC3', nRec, 4, , , , .T.  )},'Conocimiento','Conoc.'})
    EndIf

    RestArea(aArea)
Return (aButtons)
