#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½M468NGRV  ï¿½Autor  ï¿½TdeP ï¿½Fecha ï¿½  12/09/2017     ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½Punto de Entrada que se ejecuta al finalizar la Venta  ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ MP12BIB                                                    ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

user function M468NGRV()
	Local aArea    := GetArea()
	public _nValFac
	public _MoedaFac
	Private _cSerieFac

	DbSelectArea("SF2")
	//ALERT(FunName())
	_cDoc:=SF2->F2_DOC
	_cSerieFac:=SF2->F2_SERIE
	_cPedido:=SD2->D2_PEDIDO
	_nValFac:=SF2->F2_VALBRUT
	_MoedaFac:=SF2->F2_MOEDA

	//ALERT(FunName())

	cNitCli := If(Empty(SC5->C5_UNITCLI), GetAdvFVal("SA1","A1_UNITFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
	cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_UNOMFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
	cTipDoc := If(Empty(SC5->C5_XTIPDOC), GetAdvFVal("SA1","A1_TIPDOC",  xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XTIPDOC)
	cComDoc := If(Empty(SC5->C5_XCLDOCI), GetAdvFVal("SA1","A1_CLDOCID", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XCLDOCI)
	cEmail 	:= If(Empty(SC5->C5_XEMAIL),  GetAdvFVal("SA1","A1_EMAIL", 	 xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XEMAIL)

	Reclock('SF2',.F.)
	SF2->F2_UNITCLI := cNitCli
	SF2->F2_UNOMCLI := cNomCli
	SF2->F2_XTIPDOC := cTipDoc
	SF2->F2_XCLDOCI := cComDoc
	SF2->F2_XEMAIL  := cEmail
	SF2->(MsUnlock())
	nTotBsFac := ROUND(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,4),2)
	aDados:=Array(6)
	aDados[1] := SF2->F2_SERIE
	aDados[2] := SF2->F2_ESPECIE
	aDados[3] := SF2->F2_DOC
	aDados[4] := cNitCli 
	aDados[5] := DtoS(SF2->F2_EMISSAO)
	aDados[6] := nTotBsFac
	SF2->F2_UVLTOBS := nTotBsFac
	aRetCF := RetCF(aDados)
	Reclock('SF2',.F.)
	// SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao // lo genera la Facturación en Línea
	SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
	SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
	SF2->(MsUnlock())
	SF3->(DbSetOrder(6))
	If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
		while SF3->(!Eof()) .AND. SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE)==xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)
			Reclock('SF3',.F.)
			//	SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
			SF3->F3_NUMAUT	:= SF2->F2_NUMAUT 	// lo genera la Facturación en Línea
			SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
			//	SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			SF3->F3_VALCONT := nTotBsFac
			SF3->F3_VALMERC := nTotBsFac
			SF3->F3_BASIMP1 := nTotBsFac
			SF3->F3_BASIMP2 := nTotBsFac
			IF Empty(SF3->F3_CFO) // CASO estÃ© vacio va sustituir con D2_CF
				SF3->F3_CFO	:= SD2->D2_CF
			endif 
			SF3->(MsUnlock())
			aVals := getAlicuota(SF3->F3_TES)

			if !empty(aVals) .and. !SF3->F3_TES == ALLTRIM(SuperGetMv("MV_BONUSTS"))

				nAlic1 = round(SF3->F3_BASIMP1 * (aVals[2]/100),2) ///IVA FACTURA

				nAlic2= round(SF3->F3_BASIMP1 * (aVals[1]/100),2) // IT FACTURA

				SF3->F3_VALIMP1	:= nAlic1	//Numero de Autorizacao
				SF3->F3_VALIMP2	:= nAlic2	//Codigo de Controle
			endif

			// Genera doble conversiï¿½n en libros fiscales ODR 12/09/2019
			// SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)

			// ODR 31/12/2019
			// Condiciï¿½n para colocar el CERO el valor de un producto bonificado
			IF SF3->F3_TES == ALLTRIM(SuperGetMv("MV_BONUSTS"))
				SF3->F3_VALCONT := 0
			END
			SF3->(DbSkip())
		END
	End
	/*
	_cDoc := SF2->F2_DOC
	_cSerieFac := SF2->F2_SERIE
	_cPedido := SD2->D2_PEDIDO
	_nValFac := SF2->F2_VALBRUT
	_MoedaFac:=SF2->F2_MOEDA
	*/

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
