#include 'protheus.ch'
#include 'parmtype.ch'

user function GetCosPro()
Local aArea:= GetArea()
nPosMoe  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_MOEDA" })
nPosPro  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_CODPRO" })
nPosBas  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_PRCBAS" })
nCosVal := 0
nCant := 0
 	SB2->(DbSetOrder(1))
	SB2->(DbGoTop())
	If SB2->(DbSeek(xFilial('SB2')+M->DA1_CODPRO))
	 	While SB2->(!EOF()) .AND. SB2->B2_COD == M->DA1_CODPRO
	 		If aCols[n][nPosMoe] == 1
	 			If SB2->B2_CM1<>0 .AND. SB2->B2_QATU<>0
	 				//aCols[n][nPosBas]:=SB2->B2_CM1
	 				nCosVal += SB2->B2_VFIM1
	 				//exit
	 			end
	 		else
	 			If SB2->B2_CM2<>0 .AND. SB2->B2_QATU<>0
	 				//aCols[n][nPosBas]:=SB2->B2_CM2
	 				nCosVal += SB2->B2_VFIM2
	 				nCant += SB2->B2_QFIM
	 				//exit
	 			end
	 		end
	 		
		 	SB2->(DbSkip())
		End
	End
	aCols[n][nPosBas]:= ROUND(nCosVal/nCant,5)
	//alert(aCols[n][nPosBas])
oMainWnd:Refresh()
RestArea(aArea)	
//return .T.
return aCols[n][nPosBas]