#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA410COR ºAutor  ³Walter C Silva      º Data ³ 08/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. para ajustar cores do Browse de Pedido de Vendas.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function MA410COR()        
// alert("NAHIM")
//_aCores := {{'SC5->C5_UBLQCRE == "S"' ,"BR_PRETO"},;     //Pedido en Consignacion Finalizado en Remito
_aCores := {{"U_PVCorBrow() == 'ABERTO'",'ENABLE' },;		//Pedido em Aberto
			{ "U_PVCorBrow() == 'ENCERR'" ,'DISABLE'},;		   	//Pedido Encerrado 
			{ "U_PVCorBrow() == 'LIBERA'",'BR_AMARELO'},;
			{ "U_PVCorBrow() == 'REGRA'",'BR_AZUL' },;	//Pedido Bloquedo por regra
			{ "U_PVCorBrow() == 'VTAFUTU'",'BR_PINK' },;	//Pedido Abierto para venta Futura
		  	 {"U_PVCorBrow() == 'STOCK'" ,"BR_PRETO"},;   //Pedido de venta con bloqueo de Stock -- Nahim Terrazas 22/03/2019
	    	 {"U_PVCorBrow() == 'CREDIT'" ,"BR_VIOLETA"},;   //Pedido de venta con bloqueo de crédito-- Nahim Terrazas 22/03/2019
			{ "U_PVCorBrow() == 'RECUR'",'BR_LARANJA'}}	//Pedido Bloquedo por verba
AADD(_aCores,{"U_PVCorBrow() == 'LIBPAR'" ,"BR_BRANCO"})     
AADD(_aCores,{"U_PVCorBrow() == 'CONSIG'" ,"BR_CANCEL"})     //Pedido en Consignacion Finalizado en Remito
		   //	{"U_PVBloq() == 'STOCK'" ,"BR_CANCEL"},;     //Pedido Bloqueado por Stock
		//  	 {"U_PVCorBrow() == 'CREDIT'" ,"BR_VIOLETA"},;   //Pedido de venta con bloqueo de crédito-- Nahim Terrazas 22/03/2019
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

Return(_aCores)   
  
User Function PVCorBrow()
//Controla Cores da Legenda do Browse de Pedido de Venda                                                                       
//   alert("NTP1")                                                      
private cResp 
Do Case
       Case AllTrim(SC5->C5_INCISS)=='N' .AND. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ) 
       		Return 'VTAFUTU'
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)     //Pedido Abierto
       		Return 'ABERTO' 
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. (!Empty(SC5->C5_NOTA) .or. SC5->C5_LIBEROK == 'E') .And. Empty(SC5->C5_BLQ)   // Pedido Cerrado
       	    Return 'ENCERR'
//       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ).and.SC5->C5_LIBEROK<>'P' .and. SC5->C5_USTATUS == '1 '//Pedido de venta con RA
//       		Return 'CONRA'
//       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ).and.SC5->C5_LIBEROK<>'P' .and. SC5->C5_USTATUS == '2 '//Pedido de venta con cheque
//       		Return 'CONCH'
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. SC5->C5_BLQ == '1' //Pedido Bloqueado por Regla
       		Return 'REGRA'
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. SC5->C5_BLQ == '2' //Pedido Bloqueado por Recurso
       		Return "RECUR"
       Case AllTrim(SC5->C5_NOTA) != 'REMITO' .AND. SC5->C5_LIBEROK=='P' // Pedido Liberado Parcialmente
       		Return "LIBPAR"                    
       Case AllTrim(SC5->C5_NOTA)=='REMITO' .AND. SC5->C5_TIPOREM != 'A'  //Pedido Finalizado por Remito
       		Return "FINARE"               
       Case AllTrim(SC5->C5_NOTA)=='REMITO' .AND. SC5->C5_TIPOREM == 'A'
       		Return "CONSIG"
       Case U_PVBloq() <> ""
       		Return cResp
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ).and.SC5->C5_LIBEROK<>'P' //Pedido Liberado
       		Return 'LIBERA'
       
EndCase

return 
       


//Leyenda para productos bloqueados por Credito y/o stock
User Function PVBloq    
  LOCAL aArea := GetArea()
  _cRet:="" 
//   alert("NTP")                                                      

 DbSelectArea("SC9")
 DbSetOrder(2)
 SC9->( DbSeek(SC5->C5_FILIAL +SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_NUM))

  While SC9->(!EOF()) .AND. SC9->C9_PEDIDO == SC5->C5_NUM
	  IF !SC9->C9_BLCRED=='  '.And. SC9->C9_BLCRED <> '09'.And. SC9->C9_BLCRED <> '10'.And. SC9->C9_BLCRED <> 'ZZ'
			  RestArea(aArea)
		//	  RETURN 'STOCK' // Nahim Terrazas En realidad Crédito o Stock 22/03/2019 
			  cResp =  'CREDIT'
			  RETURN cResp // Nahim Terrazas En realidad Crédito o Stock
	  END
	  IF !SC9->C9_BLEST =='  '.And. SC9->C9_BLCRED <> '09'.And. SC9->C9_BLEST  <> '10'.And. SC9->C9_BLEST  <> 'ZZ'
			  RestArea(aArea)
			  cResp =  'STOCK'
			  RETURN  'STOCK'
	  END
	  	  
   SC9->(DbSkip())
   
  EndDo      
//    _cRet:='STOCK'
  RestArea(aArea)
Return _cRet    
