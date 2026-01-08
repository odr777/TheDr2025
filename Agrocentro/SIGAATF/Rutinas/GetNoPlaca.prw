#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} GetNoPlaca()
	@type  User Function
	@author Jim Bravo
	@since 29/06/2023
	@version 1.0
/*/
User Function GetNoPlaca(cGrupo)
	Local cQuery	:=	""
	Local cRet		:=	""
	Local _aArea	:=	GetArea()
	Local cSuc 		:= SubStr(xFilial("SN1"), 1, 2)
	Local cEmp		:= ""
	Local cGrpDesc	:= ""
	Local nItem		:= 0

	//Obtener abreviación de la Empresa
	Do Case
		Case cSuc == "00"
			cEmp := "AG"
		Case cSuc == "01"
			cEmp := "DK"
		Case cSuc == "02"
			cEmp := "RX"
		Case cSuc == "03"
			cEmp := "SV"
		Case cSuc == "04"
			cEmp := "CA"
		Case cSuc == "05"
			cEmp := "FL"
		Case cSuc == "06"
			cEmp := "RO"
	EndCase

	//Obtener abreviación de la descripción del Grupo de bienes
	Do Case
		Case cGrupo == "0100"
			cGrpDesc := "TERR"
		Case cGrupo == "0200"
			cGrpDesc := "EDIF"
		Case cGrupo == "0300"
			cGrpDesc := "MYES"
		Case cGrupo == "0400"
			cGrpDesc := "VIVP"
		Case cGrupo == "0500"
			cGrpDesc := "EQCM"
		Case cGrupo == "0600"
			cGrpDesc := "HERR"
		Case cGrupo == "0700"
			cGrpDesc := "EQIN"
		Case cGrupo == "0800"
			cGrpDesc := "VEHI"
		Case cGrupo == "0900"
			cGrpDesc := "AVIN"
		Case cGrupo == "1000"
			cGrpDesc := "MAQA"
		Case cGrupo == "1100"
			cGrpDesc := "MAQG"
		Case cGrupo == "1200"
			cGrpDesc := "ALAM"
		Case cGrupo == "1300"
			cGrpDesc := "CANL"
		Case cGrupo == "1400"
			cGrpDesc := "TING"
		Case cGrupo == "1500"
			cGrpDesc := "SILO"
		Case cGrupo == "1600"
			cGrpDesc := "CAMI"
		Case cGrupo == "1700"
			cGrpDesc := "INET"
		Case cGrupo == "1800"
			cGrpDesc := "OBRA"
	EndCase
                     
	//Obtener Item del activo
	cQuery := " SELECT COUNT(N1_GRUPO) Q FROM " + RETSQLNAME("SN1") + " SN1 "  
	cQuery += " WHERE D_E_L_E_T_ = ' ' AND SUBSTRING(N1_FILIAL,1,2) = '" + cSuc + "' AND N1_GRUPO = '" + cGrupo + "' GROUP BY N1_GRUPO "
 
	If Select("nCant") > 0
		nCant->(dbCloseArea())
	End 

	TcQuery cQuery New Alias "nCant"

	If !Empty(nCant->Q) 
		nItem := nCant->Q + 1
	else
		nItem := 1
	End

	cRet := cEmp + "-" + cGrpDesc + "-" + StrZero(nItem, 4)

	RestArea(_aArea)

Return cRet
