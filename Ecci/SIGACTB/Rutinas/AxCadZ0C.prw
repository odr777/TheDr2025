#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: TdeP Bolivia
* @since: 31/03/2022
* @description: Programa que actualiza fecha de cierres para informes de la tabla Z0C
*
*/
user function AxCadZ0C()
Local cVldAlt := ".T." // Validacion para permitir modificaciones.
Local cVldExc := ".T." // Validacion para permitir Eliminaciones. 

Private cString := "Z0C"

dbSelectArea("Z0C")
dbSetOrder(1)

AxCadastro(cString,"Fechas de Inf. de Cierre",cVldExc,cVldAlt,.F.)

return
