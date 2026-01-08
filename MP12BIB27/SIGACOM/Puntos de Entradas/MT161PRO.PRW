#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} 
	Ponto executado no momento do click no botão de analise de cotação
	@type P.E:
	@author user
	@since 26/08/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	https://tdn.totvs.com/pages/releaseview.action?pageId=267801959
	/*/

Return return_var
User Function MT161PRO()

	Local aPropostas := PARAMIXB[1]
	Local aRet 		 := {}  
    Local nX		 := 0

	For i:= 1 to Len(aPropostas)
	nX++
		if (aPropostas[1][nX][2][1][1]) = .T. .and. Alltrim((aPropostas[1][nX][2][1][13]))<>''      
			//aPropostas[n,p,2,x,3] : Cod produto
			aPropostas[1][nX][2][1][3]:= aPropostas[1][nX][2][1][13] 
		Else
			aPropostas[1][nX][2][1][3]:=aPropostas[1][nX][2][1][3]
		EndIf 
	Next i




Return aPropostas
