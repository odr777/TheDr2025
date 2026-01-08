/**
* @author: Widen Gonzales
* @since: 29/08/2022
* @description: Punto de entrada al momento de copiar el pedido de venta.
* @help: https://tdn.totvs.com/pages/releaseview.action?pageId=6784046 
*        https://centraldeatendimento.totvs.com/hc/es/articles/4402124206615-Cross-Segmentos-TOTVS-BackOffice-L%C3%ADnea-Protheus-MI-Facturaci%C3%B3n-SIGAFAT-Uso-de-Punto-de-Entrada-A468RMFUT
*/
User Function M410STTS()
Local _nOper := PARAMIXB[1]

If _nOper == 6 //Cópia
    nTotalPEdVis := U_GETPEDTOT(SC5->C5_NUM,SC5->C5_CLIENTE)
	RecLock("SC5",.F.)
		Replace 	C5_UTOTPED      With nTotalPEdVis
        Replace 	C5_USRREG      With USRRETNAME(RETCODUSR())
	MsUnlock()
EndIf
Return Nil
