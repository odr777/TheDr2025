#include 'protheus.ch'
#include 'parmtype.ch'
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410MNU  ºAutor  ³TdeP			   ºFecha ³  08/10/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que permite adicionar aRotinas en la Pantalla de      º±±
±±º          ³ Pedido de Venta.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA410MNU

	//aadd(aRotina,{'Imp. Nota Venta','U_NOTAPED()' , 0 , 4,0,NIL})
	//Local aRotina2  := {{"Asignar"   ,'EXECBLOCK("ENTREGAPV",.F.,.F.,"A")',0,4},;
	//			{"Visualizar",'EXECBLOCK("ENTREGAPV",.F.,.F.,"V")',0,2}}

	nPosTra := aScan(aRotina,{|x| Upper(AllTrim(x[2])) == "MA410PVNFS"})
	If nPosTra > 0
		aRotina[nPosTra,1] := "Facturar / Cobrar"
		aRotina[nPosTra,2] := "U_factdire()"
	Endif

	//AADD(AROTINA, {"Asignar Serie"   ,'EXECBLOCK("ENTREGAPV",.F.,.F.,"A")',0,4})
	//	AADD(AROTINA, {"Visual. Serie"   ,'EXECBLOCK("ENTREGAPV",.F.,.F.,"V")',0,2})
	aadd(aRotina,{'Imprimir PV','U_PEDVEN()' , 0 , 2,0,NIL})

Return