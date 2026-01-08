#INCLUDE "Rwmake.ch"

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
±±ºUso       ³                                              º±±
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
Local lMudou	:= .T.
Local nI

Local cNewNum	:= Criavar("C5_NUM")
Public aEntFut	:= {}

/* Número de PV según la condición
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
*/

If Len(aItemPV) > 0
	nPosNum	:= Ascan( aItemPV[1], { |x| Alltrim( x[1] ) == 'C6_NUM'} )
	nPosQtV	:= Ascan( aItemPV[1], { |x| Upper(AllTrim(x[1])) == "C6_QTDVEN"})
	nPosQtd	:= Ascan( aItemPV[1], { |x| Upper(AllTrim(x[1])) == "C6_QTDLIB"})	
Endif

For nI:= 1 To Len(aItemPV)
    If nPosNum > 0 .AND. lMudou
		aItemPV[nI,nPosNum][2]	:= cNewNum
		aItemPV[nI,nPosQtd][2]	:= aItemPV[nI,nPosQtV][2]
    Endif	
Next nI

/*Copia el Numero de Pedido de Venta en el campo C5_UPVFUT para PV Futura*/
AADD(aCabPV,{"C5_UPVFUT",SC5->C5_NUM,nil})

RECLOCK("SC5",.F.)
If Empty(SC5->C5_UPVFUT)
	REPLACE SC5->C5_UPVFUT WITH cNewNum
endif
SC5->( MsUnlock())
RestArea(aArea)

aEntFut := {aCabPV,aItemPV}

//Aviso("Importante","Número de Pedido (Entrega Futura): "+cNewNum,{"OK"})

RestArea(aArea)
Return({aCabPV,aItemPV})
