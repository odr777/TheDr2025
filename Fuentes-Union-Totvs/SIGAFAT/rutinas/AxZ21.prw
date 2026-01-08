#include 'protheus.ch'
#Include "Parmtype.ch"
#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAxZ21  บAutor  ณEDUAR ANDIA /WIDEN	บFecha ณ  22/11/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rutina que relaciona el usuario con la moneda del Pedido   บฑฑ
ฑฑบ          ณ Para inicializar la moneda del Pedido de Venta             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia \Uni๓n Agronegocios S.A.                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AxZ21
/*
Local aRotAdic 	:= {}
Local bPre 		:= {||MsgAlert('Chamada antes da fun็ใo')}
Local bOK  		:= {||MsgAlert('Chamada ao clicar em OK'), .T.}
Local bTTS  	:= {||MsgAlert('Chamada durante transacao')}
Local bNoTTS  	:= {||MsgAlert('Chamada ap๓s transacao')}    
Local aButtons 	:= {}//adiciona bot๕es na tela de inclusใo, altera็ใo, visualiza็ใo e exclusao
aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Botใo Teste" }  ) //adiciona chamada no aRotina
aadd(aRotAdic,{ "Adicional","U_Adic", 0 , 6 })
*/

//AxCadastro("Z21"	, "Moneda para Venta", "U_DelOk()", "U_COK()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )
AxCadastro("Z21"	, "Moneda para Venta")
  
Return(.T.)

/*
User Function DelOk()  
MsgAlert("Chamada antes do delete") 
Return 
User Function COK()    
MsgAlert("Clicou botao OK") 
Return .t.      
User Function Adic()   
MsgAlert("Rotina adicional") 
Return
*/