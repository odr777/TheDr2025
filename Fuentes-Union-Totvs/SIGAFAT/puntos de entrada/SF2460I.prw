#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³TdeP Horeb ºFecha ³  24/04/17            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para grabar datos en el encabezado de la  º±±
±±º          ³ factura de venta y titulo desde el pedido de ventas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I
	Local aArea    := GetArea()
	Private _nValFac
	Private _cSerieFac
	private nTotalF3

	//pe que se ejecuta
	If Alltrim(FunName()) == "MATA467N"
		if	RecLock("SF2",.F.)
			Replace F2_USRREG  With SUBSTR(UPPER(CUSERNAME),1,15)         //usuario que reg la factura   mod YGC
			SF2->(MsUnlock())
		END

		DbSelectArea("SF3")
		SF3->(DbSetOrder(6))
		If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )

			while SF3->(!Eof()) .AND. SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE)==xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)

				aVals := getAlicuota(SF3->F3_TES)

				if !empty(aVals)
					nAlic1 = round(SF3->F3_BASIMP1 * (aVals[2]/100),2) ///IVA FACTURA

					nAlic2= round(SF3->F3_BASIMP1 * (aVals[1]/100),2) // IT FACTURA
					Reclock('SF3',.F.)

					SF3->F3_VALIMP1	:= nAlic1	//Numero de Autorizacao
					SF3->F3_VALIMP2	:= nAlic2	//Codigo de Controle
				endif

				SF3->(DbSkip())
			endDO
			SF3->(MsUnlock())
		Endif
		SF3->(DbCloseArea())
	ENDif

	RestArea(aArea)
return

///trae iva e it
static function getAlicuota(cTes)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local aValAlic := {}
	Local cIvaCod := GetNewPar("MV_IVAALIC","IVA")//IVA CODIGO
	Local cITcod := GetNewPar("MV_ITRALIC","ITR")//IT CODIGO
	/*
	SELECT FC_IMPOSTO,FC_TES,FB_ALIQ FROM SF4010 SF4
	LEFT JOIN SFC010 SFC
	ON FC_TES = F4_CODIGO AND FC_IMPOSTO IN('IVA','ITR') AND SFC.D_E_L_E_T_ = ''
	LEFT JOIN SFB010 SFB
	ON FB_CODIGO = FC_IMPOSTO AND SFB.D_E_L_E_T_ = ''
	WHERE  F4_CODIGO = '510' AND SF4.D_E_L_E_T_ = ''
	ORDER BY FC_IMPOSTO*/

	///el query busca si hay el tipo TF que es el deposito y todos sus registros
	cQuery := " SELECT FC_IMPOSTO,FC_TES,FB_ALIQ "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SF4")+" SF4 "
	cQuery += " LEFT JOIN "
	cQuery += "   "+RetSQLName("SFC")+" SFC "
	cQuery += " ON FC_TES = F4_CODIGO AND FC_IMPOSTO IN('"+cIvaCod+"','"+cITcod+"') AND SFC.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN "
	cQuery += "   "+RetSQLName("SFB")+" SFB "
	cQuery += " ON FB_CODIGO = FC_IMPOSTO AND SFB.D_E_L_E_T_ = '' "
	cQuery += " WHERE  F4_CODIGO = '" + cTes + "' AND SF4.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY FC_IMPOSTO "

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "QRY_SEL"

	if !QRY_SEL->(EoF())
		while !QRY_SEL->(EoF())
			aadd(aValAlic,QRY_SEL->FB_ALIQ)
			QRY_SEL->(dbskip())
		enddo
	endif
	///posicion 1 es el it posicion dos es el iva

	QRY_SEL->(DbCloseArea())
	RestArea(aArea)
return aValAlic