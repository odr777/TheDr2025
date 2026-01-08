#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 11/11/2020
* @description:
*				- El punto de entrada A123PIDF reemplaza el filtro definido por estándar para la visualizar las solicitudes de importación.
*				- El punto de entrada A123PIDF no recibe parámetros.
*				- El punto de entrada A123PIDF regresa una variable del tipo Array.
*				Se aplicó filtro para no mostrar las solicitudes Eliminadas por residuo.
*/
user function A123PIDF()
	Local aArea		:= getArea()
	Local aFiltro	:= {}
	Local cFiltro	:= ''

	cFiltro := ' C1_FILIAL == "0101".And. C1_TIPO = 2 .And. C1_MOEDA == nMoedaPed '
	cFiltro += ' .And. C1_QUJE < C1_QUANT .And. C1_TPOP<>"P" .And. C1_APROV$" ,L" '
	cFiltro += ' .And.( C1_COTACAO == "IMPORT" .Or. C1_COTACAO == "XXXXXX") '
	cFiltro += ' .And. ((SC1->C1_QUJE > 0 .And. SC1->C1_FLAGGCT == " ") .Or. (SC1->C1_QUJE == 0 )) .And. Empty(C1_RESIDUO)'

	aAdd(aFiltro, cFiltro)
	restArea(aArea)
return aFiltro
