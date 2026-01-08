#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MT110TEL
Permite la vinculación de la SC con un activo (maquinaria).
@type function
@author Federico
@since 9/4/2022
/*/

User Function MT110TEL      
Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
//Local nOpcx      := PARAMIXB[3]
//Local nReg       := PARAMIXB[4]
Public cChapa	 := SPACE(20)   

If Inclui
	cChapa := Space(20)
Else
	cChapa := SC1->C1_XCHAPA
Endif

@ 64, aPosGet[1,1]   SAY 'No. Placa' PIXEL SIZE 45,10 Of oNewDialog
@ 63, aPosGet[1,2]   MSGET cChapa  F3 CpoRetF3("C1_XCHAPA") Picture PesqPict("SC1","C1_XCHAPA") When VisualSX3("C1_XCHAPA") .And. CheckSX3("C1_XCHAPA",cChapa) ;
            			WHEN  (INCLUI .or. ALTERA) Of oNewDialog PIXEL HASBUTTON

Return
