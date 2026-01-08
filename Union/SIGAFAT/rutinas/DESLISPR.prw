#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma disparador  ºAutor  ³ERICK ETCHEVERRY º   º Date 07/09/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Disparador lista precio MVC Obteniendo datos de la grid     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function DESLISPR(cMaster,cCampo1,cCampo2,cCampo3,cCodProd,nPrcVen)//este desarrollo solo deberia funcar en las listas hijos
	Local oModel := FwModelActive()
	Local cCodTab := oModel:GetValue( cMaster, cCampo1 ) /// CODIGO TABLA DA0
	Local cPadreTab := oModel:GetValue( cMaster, cCampo2 )// CODIGO PADRE DA0
	Local nValAuLis := oModel:GetValue( cMaster, cCampo3 )///aumento en la lista
	Local nValDesLis := oModel:GetValue( cMaster, "DA0_PERMLI" )///resta en la lista
	Local nValPrc := M->DA1_PRCVEN   //// FWFldGet(“DA0_DATDE”)

	if !empty(cPadreTab)//si tiene padre osea si es lista hijo
		nValPrcAux := getPrven(cPadreTab,cCodProd)  ///trayendo el precio de la lista padre

		if nValPrcAux != 0
			nValPrc = nValPrcAux*(nValAuLis/100) //sacando el porcentaje a sumar

			nValPrc = nValPrc + nValPrcAux
		endif
	endif

Return(nValPrc)

static Function getPrven(cPadreTab,cCodProd) // trae el precio de la lista padre
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local lRet := .f.
	Local nValPrec := 0

	If Select("QRY_DA0") > 0
		QRY_DA0->(DbCloseArea())
	Endif

	/*
	SELECT DA1_PRCVEN FROM DA0010 DA0
	JOIN DA1010 DA1
	ON DA1_CODTAB = DA0_CODTAB AND DA1_CODPRO = '000035                        '
	WHERE DA0_CODTAB = '011' AND DA0_DEPTAB <> ''*/

	cQuery := " SELECT DA1_PRCVEN "
	cQuery += " FROM "
	cQuery += " "+RetSQLName("DA0")+" DA0 "
	cQuery += " JOIN "+RetSQLName("DA1")+" DA1 "
	cQuery += " ON DA1_CODTAB = DA0_CODTAB AND DA1_CODPRO = '"+cCodProd+"' and DA1.D_E_L_E_T_ = ''"
	cQuery += " WHERE "
	cQuery += " DA0.D_E_L_E_T_ = '' "
	cQuery += " AND DA0_CODTAB = '"+cPadreTab+"' "
	cQuery += " AND DA0_DEPTAB = '' "

	cQuery := ChangeQuery(cQuery)

	If __CUSERID = '000000'
		Aviso("PRECOLIST",cQuery,{'ok'},,,,,.t.)
	EndIf

	TCQuery cQuery New Alias "QRY_DA0"

	IF!QRY_DA0->(EoF())
		nValPrec = QRY_DA0->DA1_PRCVEN
	ENDIF

	QRY_DA0->(DbCloseArea())
	RestArea(aArea)
Return nValPrec