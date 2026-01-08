#Include 'Protheus.ch'

///despues de jalar la solicitud en el PO copia la tes Erick Etcheverry
User Function MT123ISC()

	For nX := 1 To Len(aHeader)
		Do Case
		Case Trim(aHeader[nX][2]) == "C7_TES"
			aCols[n][nX] := Posicione('SB1',1,xFilial('SB1')+aCols[n][4] ,'B1_TE')  // aCols[n][4]//Producto cod
		EndCase
	Next nX
Return