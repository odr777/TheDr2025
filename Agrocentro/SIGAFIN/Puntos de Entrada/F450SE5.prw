#include "totvs.ch"

/*/{Protheus.doc} F450SE5
Rotina para incluir botao de imprimir
@type function
@version 1.0
@author Erick Etcheverry    
@since 13/09/2023
@return variant, nill
/*/

USER FUNCTION F450SE5()
	Local aParam     := PARAMIXB  ////RECNOS GENERADOS
	Local aArea          := GetArea()

	If Type("cxGloCom")=="C"
		cxGloCom := NIL
		FreeObj(cxGloCom)
	endif

	u_COMPCAR() ///IMPRESION EN LINEA COMPENSACION ENTRE CARTERA

	RestArea(aArea)
RETURN
