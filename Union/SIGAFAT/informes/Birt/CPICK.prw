#include 'Protheus.ch'
#include "rwmake.ch"
#include 'tdsBirt.ch'
#include 'birtdataset.ch'

#define NOPCNO	1
#define NOPCSI	2

/*
----------------------------------------------------------------------------
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------------------------------------------------------+||
|| Programa  | PickList  autor |  Edson             Data  | 14/11/2019    ||
||+----------------------------------------------------------------------+||
|| Descricao | Nota de entrega           	                		      ||
||+----------------------------------------------------------------------+||
|| Uso       | Union Agronegocios				                          ||
||+----------------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
----------------------------------------------------------------------------
*/

user function CPICK()
	Local oReport
	Local nOpcAviso
	Local cTitulo	:= "Nota de Entrega"
	//	cPerg   := "CPICK"   // elija el Nombre de la pregunta
	//	CriaSX1(cPerg)

	DEFINE user_REPORT oReport NAME CPICK TITLE "Nota de Entrega Original" //ASKPAR EXCLUSIVE

	ACTIVATE REPORT oReport LAYOUT CPICK FORMAT HTML
	
	//Descomentar si se necesita preguntar si se desea imprimir copia
	/*nOpcAviso:= Aviso(cTitulo,'¿Desea imprimir la copia?',{'No', 'Si'}) //Pregunta si quiere
	If( nOpcAviso == NOPCSI)
		printCopy(oReport)
	EndIf*/
	printCopy(oReport)
return

/**
*
* @author: Denar Terrazas Parada
* @since: 06/04/2020
* @description: Imprime copia del informe, llamando a al layout de copia
* @Module: SIGAFAT
*
*/
static function printCopy(oReport)

	DEFINE user_REPORT oReport NAME CPICK TITLE "Nota de Entrega Copia" //ASKPAR EXCLUSIVE

	ACTIVATE REPORT oReport LAYOUT CPICK_COPY FORMAT HTML

return
