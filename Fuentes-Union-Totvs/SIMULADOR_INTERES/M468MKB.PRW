#include 'protheus.ch'

User Function M468MKB()

	Local cFiltro := ""
    Local cUsuario := RetCodUsr()

    if lPedidos
    /*
        if cUsuario $ GetMV("UN_PEDIV")
            cFiltro += " AND C9_PEDIDO IN (SELECT C6_NUM FROM "+ RetSQLName('SC6') +  " WHERE D_E_L_E_T_ <> '*' AND C6_XRECE1 = '' )"
        elseif cUsuario $ GetMV("UN_PEDII")
            cFiltro += " AND C9_PEDIDO IN (SELECT C6_NUM FROM "+ RetSQLName('SC6') +  " WHERE D_E_L_E_T_ <> '*' AND C6_XRECE1 <> '' )"
        endif
    */
    if cUsuario $ GetMV("UN_PEDII") 
        cFiltro += " AND C9_PEDIDO IN (SELECT C6_NUM FROM "+ RetSQLName('SC6') +  " WHERE D_E_L_E_T_ <> '*' AND C6_XRECE1 <> '' )"
    endif
    endif

Return cFiltro
