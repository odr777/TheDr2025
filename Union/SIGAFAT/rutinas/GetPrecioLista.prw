#include 'protheus.ch'
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  ºAutor  ³Jorge Saavedra      º Data ³  12/06/2022  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta Decimales en Lista de Precio en el Pedido de Venta º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetPrcLis()
	Local lRet:= .T.
	Local aArea		:= GetArea()
	// Local i
	nPosPro	 := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRODUTO" })
	nPosCan  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })
	nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRCVEN" })
	nPosTot  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_VALOR" })
	nPosPun  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRUNIT" })	

	if inclui
		if !Empty(alltrim(M->C5_TABELA))
			//for i:=1 to Len(aCols)
				Posicione("DA1",1,xFilial("DA1")+M->C5_TABELA+acols[N][nPosPro],"DA1_CODPRO")
				acols[N][nPosPre] := ROUND(xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,M->C5_MOEDA,M->C5_EMISSAO,4),2)// round(acols[i][nPosPre],2)
				acols[N][nPosTot] := round(acols[N][nPosCan] * acols[N][nPosPre],2)
				acols[N][nPosPun] := acols[N][nPosPre]
			//Next	
		END	
	END
	if altera 
		if !Empty(alltrim(SC5->C5_TABELA))
			//for i:=1 to Len(aCols)
				Posicione("DA1",1,xFilial("DA1")+SC5->C5_TABELA+acols[N][nPosPro],"DA1_CODPRO")
				acols[N][nPosPre] := ROUND(xMoeda(DA1->DA1_PRCVEN,DA1->DA1_MOEDA,SC5->C5_MOEDA,SC5->C5_EMISSAO,4),2)// round(acols[i][nPosPre],2)
				acols[N][nPosTot] := round(acols[N][nPosCan] * acols[N][nPosPre],2)
				acols[N][nPosPun] := acols[N][nPosPre]
			//Next	
		END	
	ENDIF
	if(!IsBlind())
		oGetDad:refresh()
		OMAINWND:refresh()
	EndIf
	RestArea( aArea )
Return lRet
