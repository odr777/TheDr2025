#INCLUDE "Protheus.ch"

/*/{Protheus.doc} User Function F550VLD
    Punto de entrada que valida la reposición de caja chica,
    este valida que Sea generado un movimiento bancario si o si caso sea
    un crédito inmediato.
    @type  Function
    @author Nahim Terrazas
    @since 29/04/2021
    @version 1.1
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function F550VLD()
Local aAreaSA6	:= SA6->(GetArea())
Local ni		:= 0
Local cResp		:= ""
Local lRet		:= .T.
// 1. código do banco2. agência3. conta4. saldo atual5. moeda6. débito7. tipo título8. núm. título9. data emissão10. vencimento11. valor 12. debitar título13. gerar mov. banc.14. aguardar autoriz.	
// valor 12. debitar título13. gerar mov. banc.14
cTipoRe := ParamIXB[1][7][2] // cheque o efectivo
lDebita := ParamIXB[1][12][2] // debita atu
lMovBan := ParamIXB[1][13][2] // movimient bancario
// If ValType(ParamIXB[1]) == "A"	
//     cResp := "Variaveis disponiveis para validação de usuario : " + CRLF
//     cResp += Replicate("-",50) + CRLF	
//     For ni := 1 to Len(ParamIXB[1])		
//         cResp += ParamIXB[1][ni][1] + " = " + IIf(ValType(ParamIXB[1][ni][2]) # "C", cValtoChar(ParamIXB[1][ni][2]), ParamIXB[1][ni][2]) + CRLF	
//     Next ni	
//     cResp += Replicate("-",50) + CRLF
// Endif                               
// MsgAlert(cResp,"PE F550VLD")
// dbSelectArea("SA6")
// SA6->(dbSetOrder(1))
// If SA6->(dbSeek(xFilial("SA6") + SET->(ET_BANCO + ET_AGEBCO + ET_CTABCO)))	
//     If ParamIXB[1][5][2] # SA6->A6_MOEDA
//     	MsgAlert("A moeda do banco selecionado precisa ser igual ao da moeda do banco do caixinha registrado!","PE F550VLD")
//         lRet := .F.	
//     Else		
//         MsgAlert("A moeda do banco selecionado precisa ser igual ao da moeda do banco do caixinha registrado!","PE F550VLD")
//     Endif
// Endif
if cTipoRe $ 'EF|TF' .AND. (!lDebita .OR. !lMovBan)
    MsgAlert("Es necesario que seleccione movimiento bancario si efectua esta forma de pago","PE F550VLD")
    lRet := .F.
endif

RestArea(aAreaSA6)
Return lRet

