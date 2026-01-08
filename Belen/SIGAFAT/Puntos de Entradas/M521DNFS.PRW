#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ M521DNFS ³Nahim Terrazas/Erick Etcheverry	   Data ³ 26/11/19º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Modifica los pedidos de venta al revertir la factura		   ±±
±± Punto de entrada después de borrar / anular la factura				  ¹±±
±±ºObservacao³ registro por registro				                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BEL												      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M521DNFS()
	local aPedidos  := PARAMIXB[1]
	Local i
//	alert("M521DNFS " + cvaltochar(lAnulaSF3) )
	if lAnulaSF3 // sólo si está anulando 
		FOR i := 1 to len(aPedidos)
			ModiPedido(aPedidos[1])
		next i
	endif
	
return

static function ModiPedido(cDoc)
	//****************************************************************
	//* Alteração - INÍCIO
	//****************************************************************
	Local nCount
	cAlmEst := SuperGetMv('MV_UALMDEV',,'01')
	aCabec         := {}
	aItens         := {}
	aLinha         := {}
	lMsErroAuto    := .F.
	lAutoErrNoFile := .F.

	/*
	hago un for del pedido de venta
	*/

	aadd(aCabec, {"C5_NUM",     cDoc,      Nil})
	//	aadd(aCabec, {"C5_TIPO",    "N",       Nil})
	//	aadd(aCabec, {"C5_CLIENTE", cA1Cod,    Nil})
	//	aadd(aCabec, {"C5_LOJACLI", cA1Loja,   Nil})
	//	aadd(aCabec, {"C5_LOJAENT", cA1Loja,   Nil})
	//	aadd(aCabec, {"C5_CONDPAG", cE4Codigo, Nil})
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SC6->(dbSeek(xfilial("SC6") + cDoc))
	//dbSeek(cSucursal + cNum)
	while(!EOF()) .and. SC6->C6_NUM == cDoc
		aLinha := {}
      aadd(aLinha,{"C6_ITEM", SC6->C6_ITEM,        Nil})
      aadd(aLinha,{"C6_PRODUTO", SC6->C6_PRODUTO,        Nil})
      aadd(aLinha,{"C6_QTDVEN",  SC6->C6_QTDVEN,             Nil})
      aadd(aLinha,{"C6_PRCVEN",  SC6->C6_PRCVEN,          Nil})
      aadd(aLinha,{"C6_PRUNIT",  SC6->C6_PRUNIT,          Nil})
      aadd(aLinha,{"C6_VALOR",   SC6->C6_VALOR,          Nil})
      aadd(aLinha,{"C6_TES",     SC6->C6_TES,        Nil})
      aadd(aLinha,{"C6_LOCAL",  cAlmEst,        Nil})
      aadd(aItens, aLinha)
      
      SC6->(DBSKIP())
	enddo
		
	nOpcX := 4
	MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)
	
	If !lMsErroAuto
		ConOut("Alterado com sucesso! " + cDoc)
	Else
		ConOut("Erro na alteração!")
		aErroAuto := GetAutoGRLog()
		For nCount := 1 To Len(aErroAuto)
			cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
			// ConOut(cLogErro)
			Alert(cLogErro)
		Next nCount
	EndIf

	Aviso("",MostraErro("/temp","error.log"),{'ok'},,,,,.t.)
	//****************************************************************
	//* Alteração - FIM
	//****************************************************************

return
