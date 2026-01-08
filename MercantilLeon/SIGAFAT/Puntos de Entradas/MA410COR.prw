#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA410COR บAutor  ณJorge Saavedra      บ Data ณ 28/04/2015  บฑฑ
ฑฑบPrograma  ณ MA410LEG บCorregido  ณ NT บ Data ณ 21/12/19บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. para ajustar los colores en el Browse de Pedido de Vendas.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BASE BOLIVIA                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function MA410COR()
	Local _aCores:= ParamIxb

	_aCores := {{"U_PVCorBrow() == 'ABERTO'",'ENABLE' },;		//Pedido em Aberto
	{ "U_PVCorBrow() == 'ENCERR'" ,'DISABLE'},;		   	//Pedido Encerrado
	{ "U_PVCorBrow() == 'LIBERA'",'BR_AMARELO'},;
	{ "U_PVCorBrow() == 'REGRA'",'BR_AZUL' },;	//Pedido Bloquedo por regra
	{ "U_PVCorBrow() == 'VTAFUTU'",'BR_PINK' },;	//Pedido Abierto para venta Futura
	{"U_PVCorBrow() == 'STOCK'" ,"BR_PRETO"},;   //Pedido de venta con bloqueo de Stock -- Nahim Terrazas 22/03/2019
	{"U_PVCorBrow() == 'CREDIT'" ,"BR_VIOLETA"},;   //Pedido de venta con bloqueo de cr้dito-- Nahim Terrazas 22/03/2019
	{ "U_PVCorBrow() == 'RECUR'",'BR_LARANJA'}}	//Pedido Bloquedo por verba
	AADD(_aCores,{"U_PVCorBrow() == 'LIBPAR'" ,"BR_BRANCO"})
	AADD(_aCores,{"U_PVCorBrow() == 'CONSIG'" ,"BR_CANCEL"})     //Pedido en Consignacion Finalizado en Remito
	//		  	 {"U_PVBloq() == 'CREDIT'" ,"BR_MARROM"},;   //Pedido Bloqueado por Credito
	//	{"U_PVBloq() == 'STOCK'" ,"BR_CANCEL"},;     //Pedido Bloqueado por Stock
	/*BR_MARROM
	BR_PRETO
	BR_VERMELHO
	*/
	If cPaisLoc <> "BRA"
		Aadd(_aCores,{})
		Ains(_aCores,1)
		_aCores[1] := {"U_PVCorBrow() == 'FINARE'","BR_CINZA"}
	Endif

	DbSelectArea("SC5")

return (_aCores)

User Function PVCorBrow()
	//Controla Cores da Legenda do Browse de Pedido de Venda
	cRetorno = U_PVBloq()
	Do Case
		Case cRetorno <> ""
		Return cRetorno
		Case AllTrim(SC5->C5_INCISS)=='N' .AND. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)
		Return 'VTAFUTU'
		Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)     //Pedido Abierto
		Return 'ABERTO'
		Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. (!Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E') .And. Empty(SC5->C5_BLQ)   // Pedido Cerrado
		Return 'ENCERR'
		Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. !Empty(SC5->C5_LIBEROK).And. Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) .and. SC5->C5_LIBEROK<>'P' //Pedido Liberado
		Return 'LIBERA'
		Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. SC5->C5_BLQ == '1' //Pedido Bloqueado por Regla
		Return 'REGRA'
		Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. SC5->C5_BLQ == '2' //Pedido Bloqueado por Recurso
		Return "RECUR"
		Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. SC5->C5_LIBEROK='P' // Pedido Liberado Parcialmente
		Return "LIBPAR"
		Case AllTrim(SC5->C5_NOTA)=='REMITO' .AND. SC5->C5_TIPOREM != 'A'  //Pedido Finalizado por Remito
		Return "FINARE"
		Case AllTrim(SC5->C5_NOTA)=='REMITO' .AND. SC5->C5_TIPOREM == 'A'
		Return "CONSIG"
	EndCase

RETURN

//Leyenda para productos bloqueados por Credito y/o stock
User Function PVBloq
	LOCAL aArea := GetArea()
	Local cResp := ""

	DbSelectArea("SC9")
	DbSetOrder(2)
	if DbSeek(xFilial("SC9")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_NUM)

		While SC9->(!EOF()) .AND. SC9->C9_PEDIDO == SC5->C5_NUM
			IF !SC9->C9_BLCRED =='  '.And. SC9->C9_BLCRED <> '09'.And. SC9->C9_BLCRED <> '10'.And. SC9->C9_BLCRED <> 'ZZ'
				RestArea(aArea)
				//	  RETURN 'STOCK' // Nahim Terrazas En realidad Cr้dito o Stock 22/03/2019
				cResp =  'CREDIT'
				exit
				//RETURN cResp // Nahim Terrazas En realidad Cr้dito o Stock
			END
			IF !SC9->C9_BLEST =='  '.And. SC9->C9_BLCRED <> '09'.And. SC9->C9_BLEST  <> '10'.And. SC9->C9_BLEST  <> 'ZZ'
				RestArea(aArea)
				cResp =  'STOCK'
				exit
				//RETURN  'STOCK'
			END

			SC9->(DbSkip())

		EndDo
	endif
	//    _cRet:='STOCK'
	RestArea(aArea)
Return cResp
