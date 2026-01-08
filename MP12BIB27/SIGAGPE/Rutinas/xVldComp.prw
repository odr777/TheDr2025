#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 08/06/2022
* @description: Funcion que valida que las sucursales indicadas en los parámetros pertenezcan a la misma empresa
*				y también sea la misma empresa en la que el usuario se encuentra autenticado.
*				Utilizada en los informes:
*				- Planilla de sueldos -> Fuente DFOLPAGA.prw
*				- Boleta de Pago -> Fuente GPERUB1.PRX
*				En caso de no cumplir con las condiciones, se cierra la rutina de donde se esté utilizando la función.
* @parameters:	cPar01	-> Sucursal parametro 1
*				cPar02	-> Sucursal parametro 2
* @call: U_xVldComp(MV_PAR01, MV_PAR02) | U_xVldComp("0101", "0102")
*/
User Function xVldComp(cPar01, cPar02)

	Local aArea		:= getArea()
	Local cTitle	:= "TOTVS: Sucursal incorrecta"
	Local cMessage	:= ""

	If(Empty(cPar01) .OR. Empty(cPar02))
		cMessage:= "Debe informar los parámetros de sucursal."
		FWAlertWarning(cMessage, cTitle)
		cMessage+= CRLF
		cMessage+= "Ingresar nuevamente."
		Final(cTitle, cMessage)//Cierra la rutina
	EndIf

	If(SubStr(cPar01, 1, 2) <> SubStr(cPar02, 1, 2))
		cMessage:= "Las sucursales seleccionadas no pertenecen a la misma empresa, ";
			+ "por favor revisar los parámetros de sucursal informados."
		FWAlertWarning(cMessage, cTitle)
		cMessage+= CRLF
		cMessage+= "Ingresar nuevamente."
		Final(cTitle, cMessage)//Cierra la rutina
	EndIf

	If(SubStr(cPar01, 1, 2) <> Trim(FWCodEmp()))
		cMessage:= "Las sucursales seleccionadas deben pertenecer a la empresa en la que se encuentra autenticado, ";
			+"por favor revisar los parámetros de sucursal informados."
		FWAlertWarning(cMessage, cTitle)
		cMessage+= CRLF
		cMessage+= "Ingresar nuevamente."
		Final(cTitle, cMessage)//Cierra la rutina
	EndIf

	restArea(aArea)

return
