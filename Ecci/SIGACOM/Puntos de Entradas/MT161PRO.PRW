#INCLUDE "PROTHEUS.CH"
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