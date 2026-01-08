#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} LEERQR
MIT044 Leer datos de la factura mediante QR desarollado para Agrocentro.
@type function
@version  1
@author Jorge Saavedra
@since 06/12/2021
/*/

User Function LEERQR()
Local aArea 	:= GetArea()
Local _aQR 	:= {}

If !Empty(alltrim(M->F1_UQR))
    _aQR := StrTokArr(alltrim(M->F1_UQR) ,'|')
    M->F1_NUMAUT := _aQR[3]
    M->F1_DOC := _aQR[2]
    M->F1_CODCTR := _aQR[7]
    M->F1_FORNECE := GetAdvFVal("SA2","A2_COD", xFilial("SA2") + _aQR[1], 3) 
    M->F1_LOJA := GetAdvFVal("SA2","A2_LOJA", xFilial("SA2") + _aQR[1], 3) 
    M->F1_EMISSAO := CTOD(_aQR[4])
END

RestArea(aArea)
Return( alltrim(M->F1_UQR) )
