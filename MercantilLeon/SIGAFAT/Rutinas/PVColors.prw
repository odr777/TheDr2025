#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 22/07/2020
* @description: Función que retorna el color de la leyenda en el pedido de Venta, utilizado en
*				el inicializador Browser del campo C5_XCOLOR
*/
user function PVColors()
	Local cParam:= U_PVCorBrow()
	Local cColor:= ""
	Do Case

		Case ALLTRIM(cParam) == "ABERTO"
		cColor:= "Verde"

		Case ALLTRIM(cParam) == "ENCERR"
		cColor:= "Rojo"

		Case ALLTRIM(cParam) == "LIBERA"
		cColor:= "Amarillo"

		Case ALLTRIM(cParam) == "REGRA"
		cColor:= "Azul"

		Case ALLTRIM(cParam) == "VTAFUTU"
		cColor:= "Rosado"

		Case ALLTRIM(cParam) == "STOCK"
		cColor:= "Negro"

		Case ALLTRIM(cParam) == "CREDIT"
		cColor:= "Violeta"

		Case ALLTRIM(cParam) == "RECUR"
		cColor:= "Naranja"

		Case ALLTRIM(cParam) == "LIBPAR"
		cColor:= "Blanco"

		Case ALLTRIM(cParam) == "CONSIG"
		cColor:= ""

		Case ALLTRIM(cParam) == "FINARE"
		cColor:= "Gris"

	EndCase

return cColor