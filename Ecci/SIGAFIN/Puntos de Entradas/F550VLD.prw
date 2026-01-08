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
cTipoRe := ParamIXB[1][7][2] // cheque o efectivo
lDebita := ParamIXB[1][12][2] // debita atu
lMovBan := ParamIXB[1][13][2] // movimient bancario

if cTipoRe $ 'EF|TF' .AND. (!lDebita .OR. !lMovBan)
    MsgAlert("Es necesario que seleccione movimiento bancario si efectua esta forma de pago","PE F550VLD")
    lRet := .F.
endif
if cTipoRe $ 'CH' .AND. (!lDebita .OR. !lMovBan) // 08/05/2021 - automáticamente tiene que dar de baja el cheque y el movimiento bancario
    MsgAlert("Es necesario que seleccione Debitar título y Genera Mov Bancario","PE F550VLD")
    lRet := .F.
endif


RestArea(aAreaSA6)
Return lRet

