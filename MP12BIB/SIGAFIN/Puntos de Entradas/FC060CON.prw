#include 'protheus.ch'
#include 'parmtype.ch'

/*/ FC060CON
Adiciona el botón consulta en Cuentas por cobrar y pagar
En este caso se adiciona la impresión excel de la misma.
@type  Punto de entrada
@author Nahim Terrazas
@since 02/10/2020
@version version
@param No
@return No
    /*/

user function FC060CON()
    TRB->(DbGoTop())
    If TRB->(EOF()).And.TRB->(BOF())
        Return
    Endif
    U_kardexcli()

RETURN
