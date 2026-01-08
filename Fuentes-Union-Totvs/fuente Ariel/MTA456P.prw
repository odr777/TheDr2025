#Include 'Protheus.ch'
#Include 'RwMake.ch'

#Define ENTER  Chr(10) + Chr (13)


User Function MTA456P()
    Local aArea   := GetArea()
    //Local aAreaC9 := SC9->(GetArea())
    Local aAreaC6 := SC6->(GetArea())
    Local aAreaC5 := SC5->(GetArea())
    Local lRet := .T.
    
    If !EMPTY(SC5->C5_UIDAPP)
        IF SC5->C5_EMISSAO <> DDATABASE //SC9->C9_DATALIB
            lRet := .F.   
            lRet := MsgYesNo("Se recomienda que los pedidos móviles se aprueben en la fecha del pedido: " + dtoc(SC5->C5_EMISSAO) + ENTER + "¿Desea continuar con la aprobación en esta fecha: " + dtoc(DDATABASE) + " ?", "Atencion")
            //Alert("Los pedidos móviles se tienen que aprobar en la fecha del pedido: " + dtoc(SC5->C5_EMISSAO))
        EndIf
    ENDIF

    //RestArea(aAreaC9)
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aArea)
Return lRet
