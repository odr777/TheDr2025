#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'
//DISPARADOR TRAE PRECIO LISTA HIJA

USER function GTCLIELIST()
	Local cQuery	:= ""
	Local aArea	:= GetArea()
	Local cLista:= ""


	if M->A1_UACTLP=="2"
		return M->A1_TABPADR
	end if


	if M->A1_UACTLP=="3"
		return M->A1_TABPADR
	end if

	if Alltrim(M->A1_UACTLP)==""
		return M->A1_TABPADR
	end if


	If Select("VW_filos") > 0
		dbSelectArea("VW_filos")
		dbCloseArea()
	Endif

	cQuery := "	SELECT DA0_CODTAB "
	cQuery += " FROM " + RetSqlName("DA0") + " DA0 "
	cQuery += " WHERE DA0_CONDPG = '" + M->A1_COND + "' AND DA0.D_E_L_E_T_ = '' "
	cQuery += " AND DA0_DEPTAB = '" + M->A1_TABPADR + "' "

	TCQuery cQuery New Alias "VW_filos"

	IF !VW_filos->(EoF())
		cLista =  VW_filos->DA0_CODTAB
	ENDIF

	if empty(cLista)
		cLista = M->A1_TABPADR
		
	endif

	//cLista = M->A1_UACTLP
	
	VW_filos->(DbCloseArea())
	RestArea(aArea)

	

return cLista
