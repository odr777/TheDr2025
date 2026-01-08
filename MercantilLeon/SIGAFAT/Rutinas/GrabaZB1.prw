#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 24/11/2020
* @description: Función que graba las búsquedas/consultas que se hicieron a los productos.
*				Utilizada en las funciones: ListaP17.prw, ListaPrec23.prw y ConsListaP.prw
* @parameters:	cProd	-> Código del producto a ser registrado
*				cNomRut	-> Nombre(Descripción) de la rutina que se va a guardar
*				cPresup -> Número de presupuesto(sólo si se realizó la búsqueda desde un presupuesto)
*				cCliente-> Cliente del presupuesto(sólo si se realizó la búsqueda desde un presupuesto)
* @client: Mercantil León
*
*/
user function GrabaZB1(cProd, cNomRut, cPresup, cCliente)
	Local aArea	:= getArea()
	Local dFecha:= DATE()
	Local cHora	:= TIME()

	Default cNomRut	:= ""
	Default cPresup	:= ""
	Default cCliente:= ""

	dbSelectArea("ZB1")

	RECLOCK("ZB1", .T.)

	ZB1->ZB1_FILIAL	:= xFilial("ZB1")
	ZB1->ZB1_PRODUC	:= TRIM(cProd)
	ZB1->ZB1_FECHA	:= dFecha
	ZB1->ZB1_HORA	:= cHora
	ZB1->ZB1_USER	:= PswChave(RetCodUsr()) //Usuario logueado
	ZB1->ZB1_RUTINA	:= FunName()
	ZB1->ZB1_NOMRUT	:= cNomRut
	ZB1->ZB1_PRESUP	:= cPresup
	ZB1->ZB1_CLIENT	:= cCliente

	ZB1->(MSUNLOCK())
	ZB1->(dbCloseArea())

	RestArea(aArea)
return