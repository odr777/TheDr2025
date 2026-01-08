#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 21/10/2021
* @description: Función que verifica si la matrícula enviada en los parámetros existe.
*				En caso de existir, la matrícula se considera INVALIDA.
* @parameters: cMat -> type(c) Matrícula de un funcionario.
*
*/
user function XVALIMAT(cMat)
	Local aArea			:= getArea()
	Local OrdenConsul	:= GetNextAlias()
	Local lRet			:= .T.

	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT *
		FROM%table:SRA% SRA
		WHERE SRA.RA_MAT = %exp:cMat%
		AND SRA.%notdel%
		
	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())//Si encuentra la matrícula
		lRet:= .F.
		alert(;
			"La matrícula generada(" + cMat + ") está repetida, por favor cerrar la rutina e ingresar nuevamente.";
			+ CRLF + CRLF;
			+ "(Si el mensaje persiste, contacte al administrador del sistema).";
			)
	endIf

	restArea(aArea)

return lRet
