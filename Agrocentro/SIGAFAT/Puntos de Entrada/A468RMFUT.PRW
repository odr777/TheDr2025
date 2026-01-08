/**
* @author: Denar Terrazas Parada
* @since: 04/07/2022
* @description: Punto de entrada para el 2do pedido de venta futura.
* @help: https://tdn.totvs.com/pages/releaseview.action?pageId=6784046 
*        https://centraldeatendimento.totvs.com/hc/es/articles/4402124206615-Cross-Segmentos-TOTVS-BackOffice-L%C3%ADnea-Protheus-MI-Facturaci%C3%B3n-SIGAFAT-Uso-de-Punto-de-Entrada-A468RMFUT
*/
User Function A468RMFUT()

	Local aCabPV    := PARAMIXB[1]
	Local aItemPV   := PARAMIXB[2]

	AADD(aCabPV, {"C5_ULOCAL",  SC5->C5_ULOCAL, NIL})//Campo personalizado - Depósito
	AADD(aCabPV, {"C5_UCAMP",   SC5->C5_UCAMP,  NIL})//Campo personalizado - Campaña

Return({aCabPV,aItemPV})
