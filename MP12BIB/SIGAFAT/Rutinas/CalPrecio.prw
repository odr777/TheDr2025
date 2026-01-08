#include 'protheus.ch'
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  ºAutor  ³Jorge Saavedra      º Data ³  17/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta Decimales en Lista de Precio, Presupuesto, Pedidos de Ventas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CalPrecio()
nPosVal  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_PRCVEN" })
nPosRaz  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_URAZON" })
nPosBas  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_PRCBAS" })
	If aCols[n][nPosBas] == 0
		//aCols[n][nPosBas]   := ROUND(aCols[n][nPosVal] / aCols[n][nPosRaz],5)
	else
		aCols[n][nPosRaz] := ROUND(aCols[n][nPosVal] / aCols[n][nPosBas],4)
		RunTrigger(2,n,nil,,"DA1_PRCBAS") 
	end  
return .T.

//Ajusta el precio de Venta a 2 Decimales en el Presupuesto
User Function RedPre(cCampo)
Local lRet:= .T.
Local aArea		:= GetArea()
Local aAreaTmp1:= TMP1->(GetArea())
nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="CK_PRCVEN" })

	dbSelectArea("TMP1")
	dbGotop()
	While (!Eof())
		
		TMP1->CK_PRCVEN:= round(TMP1->CK_PRCVEN,2)
		TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
		dbSelectArea("TMP1")
		dbSkip()
	EndDo
RestArea(aAreaTmp1)
		oDlg := GetWndDefault()
		
		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf	
		Next nX
RestArea(aAreaTmp1)
RestArea( aArea )
Return &("M->"+cCampo)


//Ajusta el precio de Venta a 2 Decimales en el Pedido de Venta
User Function RedPed(cCampo)
Local lRet:= .T.
Local aArea		:= GetArea()

nPosCan  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })
nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRCVEN" })
nPosTot  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_VALOR" })

for i:=1 to Len(aCols)
	acols[i][nPosPre] := round(acols[i][nPosPre],2)
	acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)
Next		
oGetDad:refresh()
RestArea( aArea )
Return &("M->"+cCampo)
