#include 'protheus.ch'

User Function M410FSQL()

	Local cFiltro := ""
    Local cUsuario := RetCodUsr()
/*
    if cUsuario $ GetMV("UN_PEDIV")
        cFiltro += "@ C5_NUM + C5_FILIAL IN (SELECT C6_NUM + C6_FILIAL FROM "+ RetSQLName('SC6') +  " WHERE D_E_L_E_T_ <> '*' AND C6_XRECE1 = '' ) " //AND C5_FILIAL = '" + xFilial("SC5") + "' " 
    elseif cUsuario $ GetMV("UN_PEDII")
        cFiltro += "@ C5_NUM + C5_FILIAL IN (SELECT C6_NUM + C6_FILIAL FROM "+ RetSQLName('SC6') +  " WHERE D_E_L_E_T_ <> '*' AND C6_XRECE1 <> '' ) " //AND C5_FILIAL = '" + xFilial("SC5") + "' " 
    endif
*/
    if cUsuario $ GetMV("UN_PEDII")
        cFiltro += "@ C5_NUM + C5_FILIAL IN (SELECT C6_NUM + C6_FILIAL FROM "+ RetSQLName('SC6') +  " WHERE D_E_L_E_T_ <> '*' AND C6_XRECE1 <> '' ) " //AND C5_FILIAL = '" + xFilial("SC5") + "' " 
    endif
Return cFiltro
