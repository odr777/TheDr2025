#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA410COR บAutor  ณJorge Saavedra      บ Data ณ 28/04/2015  บฑฑ
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

return (_aCores)   

  
User Function PVCorBrow()
//Controla Cores da Legenda do Browse de Pedido de Venda                                                                       

Do Case
       Case AllTrim(SC5->C5_INCISS)=='N' .AND. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ) 
       		Return 'VTAFUTU'
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)     //Pedido Abierto
       		Return 'ABERTO' 
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. (!Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E') .And. Empty(SC5->C5_BLQ)   // Pedido Cerrado
       	    Return 'ENCERR'
       Case AllTrim(SC5->C5_NOTA)!='REMITO' .AND. !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ).and.SC5->C5_LIBEROK<>'P' //Pedido Liberado
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