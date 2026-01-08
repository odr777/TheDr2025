#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#Include 'ParmType.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A468RMFUT  ºAutor  ³EDUAR ANDIA        ºFecha ³  11/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que crea el 2do pedido de Venta futura, por defecto   º±±
±±º          ³ con el deposito: '02' a su ves crea la relación del	      º±±
±±º          ³ producto con su Depósito (SB2) si no existiera             º±±
±±º          ³  - Replica los descuentos del 1er Pedido al 2do Pedido     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HP Medical                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A468RMFUT
Local aArea 	:= GetArea()
Local aCabPV	:= PARAMIXB[1]
Local aItemPV 	:= PARAMIXB[2]
Local nPosNum	:= 0 
Local nPosCond	:= 0
Local cCondicion:= ""
Local lMudou	:= .F.
LOCAL aAreaSC6 := GetArea("SC6")

Local cNewNum	:= Criavar("C5_NUM")
local nI

if type("aEntFut") == "U"// existe variable cNombreCli
	Public aEntFut	:= {}
endif
If Len(aCabPV) > 0
	nPosCond	:= aScan(aCabPV,{|x| AllTrim(x[1])=="C5_CONDPAG" })
	cCondicion	:= aCabPV[nPosCond,2] 
	
	If !Empty(cCondicion)
		nPosNum	:= aScan(aCabPV,{|x| AllTrim(x[1])=="C5_NUM" })
		cNewNum	:= U_GetNextNrPed(cCondicion)
		lMudou 	:= .T.
		aCabPV[nPosNum,2] := cNewNum		
	Endif
Endif

If Len(aItemPV) > 0
	nPosNum		:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_NUM'} )	
	nPosItem	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_ITEM'} )	
	nPosProduto	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_PRODUTO'} )	
	nPosPrunit	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_PRUNIT'} )	
	nPosPrcv	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_PRCVEN'} )
	nPosvalor	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_VALOR'} )
	nPosdesc	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_DESCONT'} )
	nPosValdes	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_VALDESC'} )
		
Endif
//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
DbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(DbGoTop())
// busca la SD2 PARA VER EL ORDEN QUE DEBO RECORRRER
nNotaAct := Ascan( ANOTAS, { |x| x[1]  == SF2->(RECNO())} )	
cPedCorre := GetAdvFVal("SD2", "D2_PEDIDO", xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ,3, "")//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

For nI:= 1 To Len(aItemPV)
	//nI C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SC6->(DbGoTop())
	// posicione("SC6",1, xFilial("SC6")+SD2->D2_PEDIDO + aItemPV[nI,nPosItem][2] + alltrim(aItemPV[nI,nPosProduto][2], "SC6->C6_PRODUTO")
	// C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	// MsSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	SD2->(MsGoTo(ANOTAS[nNotaAct][2][NI])) // POSICIONO EL RECNO DE LA SD2.
	IF SC6->(MsSeek(xFilial("SC6")+cPedCorre + SD2->D2_ITEMPV + alltrim(aItemPV[nI,nPosProduto][2])))
		If nPosNum > 0 .AND. lMudou    
			aItemPV[nI,nPosNum][2]	:= cNewNum
		Endif	
		// Nahim adicionando copia de valores
			aItemPV[nI,nPosPrunit][2]	:= SC6->C6_PRUNIT
			aItemPV[nI,nPosPrcv][2]	:= SC6->C6_PRCVEN
			aItemPV[nI,nPosvalor][2]	:= SC6->C6_VALOR
			aItemPV[nI,nPosdesc][2]	:= SC6->C6_DESCONT
			if SC6->C6_VALDESC > 0 // sólo toma en cuenta si es diferente de 0
				aItemPV[nI,nPosValdes][2]	:= SC6->C6_VALDESC
			endif
	ENDIF
Next nI
SC6->(DbCloseArea())
RestArea(aAreaSC6)
// pos
dbSelectArea("SC5")
SC5->(dbgotop())
SC5->(dbsetOrder(1))
MsSeek(xFilial("SC5")+cPedCorre) // Nahims Adicionando correlativo
/*Nahim - Copia el Numero de Pedido de Venta en el campo C5_UPVFUT para PV Futura*/
AADD(aCabPV,{"C5_UPVFUT",SC5->C5_NUM,nil})

/*campos ML especificos*/
nPosDes	:= aScan(aCabPV,{|x| AllTrim(x[1])=="C5_DESC1" })
aCabPV[nPosDes,2] := SC5->C5_DESC1		
// AADD(aCabPV,{"C5_DESC1",SC5->C5_DESC1,nil})
AADD(aCabPV,{"C5_DESC2",SC5->C5_DESC2,nil})
AADD(aCabPV,{"C5_ULOCAL",SC5->C5_ULOCAL,nil})
AADD(aCabPV,{"C5_ULUGENT",SC5->C5_ULUGENT,nil})
AADD(aCabPV,{"C5_UTPOENT",SC5->C5_UTPOENT,nil})
AADD(aCabPV,{"C5_UOBSERV",SC5->C5_UOBSERV,nil})


	// {"C5_TIPO"   ,If(lTpPedBenf,"B","N")         	,Nil},; // Tipo de pedido
	// {"C5_CLIENTE",If(lTpPedBenf,SA2->A2_COD ,SA1->A1_COD )	,Nil},; // Codigo do cliente
	// {"C5_LOJAENT",If(lTpPedBenf,SA2->A2_LOJA,SA1->A1_LOJA)	,Nil},; // Loja para entrada
	// {"C5_LOJACLI",If(lTpPedBenf,SA2->A2_LOJA,SA1->A1_LOJA)	,Nil},; // Loja do cliente
	// {"C5_EMISSAO",dDatabase   	,Nil},; // Data de emissao
	// {"C5_TABELA" ,cTabela       	,Nil},; // Codigo da Tabela de Preco
	// {"C5_CONDPAG",cCond          ,Nil},; // Codigo da condicao de pagamanto*
	// {"C5_DESC1"  ,0           	,Nil},; // Percentual de Desconto
	// {"C5_INCISS" ,"N"         	,Nil},; // ISS Incluso
	// {"C5_TIPLIB" ,"1"         	,Nil},; // Tipo de Liberacao
	// {"C5_MOEDA"  ,SF2->F2_MOEDA 	,Nil},; // Moeda
	// {"C5_LIBEROK","S"         	,Nil},; // Liberacao Total
	// {"C5_TIPOCLI",If(lTpPedBenf,SA2->A2_TIPO,SA1->A1_TIPO)	,Nil},;
	// {"C5_TIPOREM","0"				,Nil},;
	// {"C5_VEND1"  ,SF2->F2_VEND1	,Nil},;
	// {"C5_DOCGER" ,'2'        		,Nil},;
	// {"C5_TPCARGA",'1'        		,Nil},;
	// {"C5_NATUREZ",SF2->F2_NATUREZ,Nil}}

// adicionando la moneda para que mantenga la del pedido inicial  Nahim - 18/11/2020
// AADD(aCabPV,{"C5_MOEDA",SC5->C5_MOEDA,nil}) 
nPosMON	:= aScan(aCabPV,{|x| AllTrim(x[1])=="C5_MOEDA" })
aCabPV[nPosMON,2] := SC5->C5_MOEDA		

RECLOCK("SC5",.F.)
// If Empty(SC5->C5_UPVFUT)
	SC5->C5_UPVFUT := aCabPV[nPosNum,2]
	REPLACE C5_UPVFUT WITH aCabPV[nPosNum,2]
// endif
SC5->( MsUnlock())
/*Nahim Termina Copia*/

aadd(aEntFut,{aCabPV,aItemPV,SD2->D2_DOC,SD2->D2_SERIE}) //entrega futura.

Aviso("Importante","Número de Pedido (Entrega Futura): "+aCabPV[nPosNum,2],{"OK"})

RestArea(aArea)
Return({aCabPV,aItemPV})

