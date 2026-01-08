#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"
//Devuelve el codigo de la Lista de Precios: Dependiendo del Tipo de Cliente y El codigo de Lista Padre 
user function GTAVENCTO()
	Local cQuery	:= ""
	Local aArea	:= GetArea()
	Local cHayMora:=0
	Local cResp:=.T.
	




	//Si la Condicion de Pago es Contado y  Hay Mora  
	IF M->C5_CONDPAG=="001"

		If Select("VW_filos") > 0
			dbSelectArea("VW_filos")
			dbCloseArea()
		Endif


		cQuery := "	SELECT COUNT(*) CANT "
		cQuery += " FROM UC_VIEW_CTACTE "
		cQuery += " WHERE SALDO_SUS>0 "
		cQuery += " AND CLIENTE = '" + M->C5_CLIENTE + "' AND TIENDA = '"+M->C5_LOJACLI+"' "		

		TCQuery cQuery New Alias "VW_filos"

		IF !VW_filos->(EoF())
			cHayMora =  VW_filos->CANT
		ENDIF
			
		IF cHayMora>0 
			MsgInfo("El cliente esta en Mora tiene facturas pendientes de pago, por favor se recomienda pasar por Cartera", "Info Mora")
			//cResp=.F.	

		ENDIF

		VW_filos->(DbCloseArea())		
	ENDIF




	RestArea(aArea)	
return M->C5_CONDPAG

