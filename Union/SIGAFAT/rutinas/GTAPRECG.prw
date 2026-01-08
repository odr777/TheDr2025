#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"
//EET TRAE LISTA PRECIO PADRE EN LA SA1
user function GTAPRECG()
	Local cQuery	:= ""
	Local aArea	:= GetArea()
	Local cLista:= ""

	If Select("VW_filos") > 0
		dbSelectArea("VW_filos")
		dbCloseArea()
	Endif

	cPadre  := Posicione("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_TABPADR")

	cQuery := "	SELECT DA0_CODTAB "
	cQuery += " FROM " + RetSqlName("DA0") + " DA0 "
	cQuery += " WHERE DA0_CONDPG = '" + M->C5_CONDPAG + "' AND DA0.D_E_L_E_T_ = '' "
	cQuery += " AND DA0_DEPTAB = '" + cPadre + "' "

	TCQuery cQuery New Alias "VW_filos"

	IF !VW_filos->(EoF())
		cLista =  VW_filos->DA0_CODTAB
	ENDIF
	//Alert(cLista)
	if empty(cLista)
		//cLista = M->C5_TABELA
		cLista = Posicione("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_TABPADR")

	endif

	VW_filos->(DbCloseArea())
	RestArea(aArea)
return cLista

User function ACTTAB()

	M->C5_TABELA:=U_GTAPRECG()
	MaVldTabPrc(M->C5_TABELA,M->C5_CONDPAG,,M->C5_EMISSAO)// .And. A410ReCalc()
	A410ReCalc()

return .T.
