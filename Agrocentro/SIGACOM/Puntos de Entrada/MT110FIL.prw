#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT110FIL
Filtrar cUserName x C1_SOLICIT
@type function
@version  1.0
@author Federico
@since 23/5/2022
/*/

User Function MT110FIL()
Local cFiltro 			:= ''
Local nQSCAprob, i, j 	:= 0

cNextAlias := GetNextAlias()
BeginSQL Alias cNextAlias
SELECT COUNT(*) Q FROM SX6010 WHERE X6_VAR LIKE 'AG_SCAPR%' AND %NotDel%
EndSQL

If (cNextAlias)->Q > 0
	nQSCAprob := (cNextAlias)->Q

	For i := 1 To nQSCAprob
		cUsuarios 	:= GetMV("AG_SCAPR"+StrZero(i,2))
		
		If AllTrim(cUsuarios) <> ''
			aAprobador 	:= &cUsuarios		
			
			If aAprobador[1] == cUserName
				cFiltro		:= ' C1_APROV $ "B|L" .And. (C1_COTACAO == "" .Or. AllTrim(C1_COTACAO) == "IMPORT") .And. C1_PEDIDO == "" '
				
				For j := 2 To Len(aAprobador)
					If j == 2 
						cFiltro += ' .And. ( AllTrim(C1_SOLICIT) == "' + aAprobador[j] + '"'
					Else
						cFiltro += ' .Or. AllTrim(C1_SOLICIT) == "' + aAprobador[j] + '"'
					End
				Next

				cFiltro += ' )'
				
				Exit
			EndIf
		EndIf

	Next

EndIf

If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo'
	Aviso("MT110FIL",cFiltro,{'OK'},,,,,.T.)
EndIf

Return (cFiltro) 
