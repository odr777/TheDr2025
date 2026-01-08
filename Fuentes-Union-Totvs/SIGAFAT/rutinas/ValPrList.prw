#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValPrList ºAutor  ³EDUAR ANDIA /WIDENº Data ³  02/12/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función que valida que Precio de Lista no sea modificado   º±±
±±º          ³ por una valor inferior para Moneda Dolar / C6_PRUNIT       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValPrList
	Local lRet 		:= .T.
	Local nPrcOld 	:= 0
	Local cCliTab   := M->C5_CLIENTE
	Local cLojaTab  := M->C5_LOJACLI
	Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPLoteCtl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
	Local nPNumLote := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
	Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})

	Local cReadVar 	:= ReadVar()
	Local xConteudo	:= &(cReadVar)
	Local nNewPrLis	:= 0

	if GetRemoteType() < 0 // nahim Terrazas toma en cuenta sólo si no es un web services
		return .T.
	endif

	If nPPrUnit > 0
		nNewPrLis := aCols[n,nPPrUnit]
	Endif

	nPrcOld := A410Tabela(	aCols[n,nPProd]	,;
	M->C5_TABELA	,;
	n				,;
	xConteudo		,;
	cCliTab			,;
	cLojaTab		,;
	If(nPLoteCtl>0,aCols[n,nPLoteCtl],""),;
	If(nPNumLote>0,aCols[n,nPNumLote],"") )
	/*
	Aviso("ValPrList","xConteudo: " + AllTrim(Str(xConteudo)),{"OK"})
	Aviso("ValPrList","aCols[n,nPPrUnit]: " + AllTrim(Str(aCols[n,nPPrUnit])),{"OK"})
	Aviso("ValPrList","nPrcOld: " + AllTrim(Str(nPrcOld)),{"OK"})
	*/

	If M->C5_MOEDA == 2
		If xConteudo < nPrcOld
			Aviso("ValPrList","El precio no puede ser menor que la lista de precio",{"OK"})
			lRet := .F.
		EndIf
	Endif

Return(lRet)