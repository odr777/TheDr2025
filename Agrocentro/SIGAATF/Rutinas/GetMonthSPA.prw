#Include "protheus.ch"

/*/{Protheus.doc} GetMonthSPA
	(Mes en Español.)
	@type  User Function
	@author Jim Bravo
	@since 14/08/2023
	@version 1.0
/*/
User Function GetMonthSPA( dFecha )
	Local nMes := MONTH( dFecha )

	If nMes == 1
		cRet := "Enero"
	ElseIf nMes == 2
		cRet := "Febrero"	
	ElseIf nMes == 3
		cRet := "Marzo"	
	ElseIf nMes == 4
		cRet := "Abril"	
	ElseIf nMes == 5
		cRet := "Mayo"	
	ElseIf nMes == 6
		cRet := "Junio"	
	ElseIf nMes == 7
		cRet := "Julio"	
	ElseIf nMes == 8
		cRet := "Agosto"	
	ElseIf nMes == 9
		cRet := "Septiembre"	
	ElseIf nMes == 10
		cRet := "Octubre"	
	ElseIf nMes == 11
		cRet := "Noviembre"	
	ElseIf nMes == 12
		cRet := "Diciembre"
	EndIf 
Return cRet
