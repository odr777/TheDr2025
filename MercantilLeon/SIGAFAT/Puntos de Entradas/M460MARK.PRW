#include "protheus.ch" 
#include "topconn.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T  ºAutor  ³ Nahim Terrazas	     º Data ³  06/05/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada utilizado para validar itens selecionados  º±±
±±º          ³na tela Documento de Saida para emissao de NF.              º±±
±±			  No se debe generar con diferentes TES 				       ±±
±±ºUso       ³ MATA460                                                    .º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460MARK()

Local aArea    := GetArea()

Local cMarca 	:= PARAMIXB[1]
Local lInverte  := PARAMIXB[2]  

Local lRet:= .T.

aFactAGen := {} // Facturas a generar
cTipoEntr := "" //  

if MV_PAR16 == 3
		MsgBox("No es posible generar pedido de venta agrupado por 'Agregador'.",".", "STOP")
		RETURN .F.
endif
/*
Nahim 27/05/2021
Comentando momentaneamente para no permiter 'agrupar' porque el usuario está generando pedidos de manera incorrecta
For nLoop := 1 to len(apedido)
	//poscio
	cDocuGen := Posicione("SC5",1,xFilial("SC5")+apedido[nLoop],"C5_DOCGER") // documento a generar
	cCliLop := SC5->C5_CLIENTE + SC5->C5_LOJACLI// cliente
	dFechaEmi := SC5->C5_EMISSAO// cliente
	for nXFact := 1 to len(aFactAGen)
		if aFactAGen[nXFact][1] == cCliLop  .and. aFactAGen[nXFact][2] == dtoC(dFechaEmi)	// mismo cliente misma fecha  
			if cDocuGen <> aFactAGen[nXFact][3] .and. MV_PAR16 <> 1 // el documento a generar es diferente
					MsgBox("No es posible generar pedido de venta con diferentes tipos de entrega.",".", "STOP")
				return .f.
			endif
		endif
	next nXFact
	Aadd(aFactAGen,{cCliLop,dtoC(dFechaEmi),cDocuGen})
	// if cDogGer <> cTipoEntr .and. !empty(cTipoEntr) // <> ""
	// 	MsgBox("No es posible generar pedido de venta con diferentes tipos de entrega",".", "STOP")
	// endif
	// cTipoEntr := cDogGer
Next nLoop
*/

RestArea(aArea)

Return(lRet)

