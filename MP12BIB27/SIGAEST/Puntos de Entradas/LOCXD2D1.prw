#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXD2D1  ºAutor  ³EDUAR ANDIA TAPIA   º Data ³  24/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Para copiar valores de la transf. de Salida en la     º±±
±±º          ³ transf. de Entrada en Browser.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXD2D1
	Local aArea := GetArea()
	Local nI
IF FUNNAME() $ 'MATA462TN'	
	For nI := 1 To Len(aHeader)
		cCampo := Upper(AllTrim(aHeader[nI][2]))
		Do Case
			Case cCampo == "D1_LOCALIZ"
				nPosLoc   := nI			
			Case cCampo == "D1_NUMSERI"
				nPosSerie := nI
			Case cCampo == "D1_UDESC"
				nPosProducto := nI
			Case cCampo == "D1_TES"
				nPosTes := nI
		EndCase	
	Next nI

	If nPosLoc > 0
		//aCols[Len(aCols)][nPosLoc]     := SD2->D2_LOCALIZ
		aCols[Len(aCols)][nPosProducto] :=GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+SD2->D2_COD,1,"")
		//If !Empty(SD2->D2_LOCZDES)
			If(nPosSerie   > 0 ,aCols[Len(aCols)][nPosSerie]   := SD2->D2_NUMSERI    ,)	
		//Endif
		aCols[Len(aCols)][nPosTes] := '301'
	Endif
	
	RestArea(aArea)
Endif
Return