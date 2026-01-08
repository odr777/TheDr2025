#include "totvs.ch"

/*/{Protheus.doc} F450SE5
Rotina para incluir botao de imprimir
@type function
@version 1.0
@author Erick Etcheverry    
@since 13/09/2023
@return variant, nill
/*/

USER FUNCTION F450VALCON()
	Local nRet := 1

	DEFINE MSDIALOG oDlgVCan TITLE "Concepto - Glosa" From 9,0 To 20,90
	PUBLIC cxGloCom := Space(TamSX3('E5_UGLOSA')[1])

	cxGloCom := PadR(cxGloCom,TamSx3("E5_UGLOSA")[1]," ")
	@ 3  ,1 SAY OemToAnsi("Concepto")
	@ 3  ,5  MSGET cxGloCom  Picture "@!" Valid !Empty(cxGloCom)
	DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan

	ACTIVATE MSDIALOG oDlgVCan CENTER


RETURN nRet
