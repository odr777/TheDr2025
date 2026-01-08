#Include "RwMake.ch"

/**
*
* @author: Denar Terrazas Parada
* @since: 22/03/2021
* @description: Función que suma los descuentos que tuvo un pedido, utilizado en un campo virtual.
*
*/
User Function SumDesPC(cNumPV)
	Local nRet  := 0
	Local aArea := getArea()
	Local cNumPV:= PADR(cNumPV, 6)

	if(!Empty(cNumPV))
		dbSelectArea("SC7")
		dbSetOrder(1)//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		DBSeek(xFilial("SC7") + cNumPV)
		while SC7->(!EOF()) .AND. SC7->C7_NUM == cNumPV
			nRet+= SC7->C7_VLDESC
			SC7->(dbSkip())
		enddo
		SC7->(DbCloseArea())
	EndIf

	restArea(aArea)

Return nRet
