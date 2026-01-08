#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXD2D1  ºAutor  ³EDUAR ANDIA TAPIA   º Data ³  07/29/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Para copiar valores de la transf. de Salida en la     º±±
±±º          ³ transf. de Entrada en Browser.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DATEC                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXD2D1
	Local aArea := GetArea()
	Local nI
	IF FUNNAME() $ 'MATA462TN'

		M->F1_UNROREC := SF2->F2_UNROREC
		M->F1_UOBSERV := SF2->F2_UOBSERV

		For nI := 1 To Len(aHeader)
			cCampo := Upper(AllTrim(aHeader[nI][2]))
			Do Case
			Case cCampo == "D1_LOCALIZ"
				nPosLoc   := nI
			Case cCampo == "D1_NUMSERI"
				nPosSerie := nI
			Case cCampo == "D1_UDESC"
				nPosProducto := nI
			EndCase
		Next nI

		If nPosLoc > 0
			//aCols[Len(aCols)][nPosLoc]     := SD2->D2_LOCALIZ
			aCols[Len(aCols)][nPosProducto] :=GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+SD2->D2_COD,1,"")
			//If !Empty(SD2->D2_LOCZDES)
			If(nPosSerie   > 0 ,aCols[Len(aCols)][nPosSerie]   := SD2->D2_NUMSERI    ,)
				//Endif
			Endif



			RestArea(aArea)
		Endif
		Return
