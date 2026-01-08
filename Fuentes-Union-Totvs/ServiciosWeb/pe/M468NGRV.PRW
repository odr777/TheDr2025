#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M468NGRV  �Autor  �TdeP �Fecha �  12/09/2017     ���
�������������������������������������������������������������������������͹��
���Desc.     �Punto de Entrada que se ejecuta al finalizar la Venta  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������͹��
���Uso       � MP12BIB                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	cNitCli :=  If(Empty(SC5->C5_UNITCLI),GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
	cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)

	Reclock('SF2',.F.)
	SF2->F2_UNITCLI := cNitCli
	SF2->F2_UNOMCLI := cNomCli
	SF2->(MsUnlock())
	nTotBsFac := ROUND(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,4),2)
	aDados:=Array(6)
	aDados[1] := SF2->F2_SERIE
	aDados[2] := SF2->F2_ESPECIE
	aDados[3] := SF2->F2_DOC
	aDados[4] := cNitCli //If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
	aDados[5] := DtoS(SF2->F2_EMISSAO)
	aDados[6] := nTotBsFac
	Reclock('SF2',.F.)
	SF2->F2_UVLTOBS := nTotBsFac
	aRetCF := RetCF(aDados)
	
	SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
	SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
	SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
	SF2->(MsUnlock())
	SF3->(DbSetOrder(6))
	If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
		while SF3->(!Eof()) .AND. SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE)==xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)
			Reclock('SF3',.F.)
			//  ALERT(TRANSFORM(SF3->F3_VALCONT,"@E 999,999.999"))
			SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
			SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
			//		SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			SF3->F3_VALCONT := nTotBsFac
			SF3->F3_VALMERC := nTotBsFac
			SF3->F3_BASIMP1 := nTotBsFac
			SF3->F3_BASIMP2 := nTotBsFac
			IF Empty(SF3->F3_CFO) // CASO esté vacio va sustituir con D2_CF
				SF3->F3_CFO	:= SD2->D2_CF
			endif 
			SF3->(MsUnlock())
			aVals := getAlicuota(SF3->F3_TES)

			if !empty(aVals) .and. !SF3->F3_TES == ALLTRIM(SuperGetMv("MV_BONUSTS"))

				nAlic1 = round(SF3->F3_BASIMP1 * (aVals[2]/100),2) ///IVA FACTURA

				nAlic2= round(SF3->F3_BASIMP1 * (aVals[1]/100),2) // IT FACTURA
				Reclock('SF3',.F.)
				SF3->F3_VALIMP1	:= nAlic1	//Numero de Autorizacao
				SF3->F3_VALIMP2	:= nAlic2	//Codigo de Controle
				SF3->(MsUnlock())
			endif

			// Genera doble conversi�n en libros fiscales ODR 12/09/2019
			// SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)

			// ODR 31/12/2019
			// Condici�n para colocar el CERO el valor de un producto bonificado
			IF SF3->F3_TES == ALLTRIM(SuperGetMv("MV_BONUSTS"))
				Reclock('SF3',.F.)
				SF3->F3_VALCONT := 0
				SF3->(MsUnlock())
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
