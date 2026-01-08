#Include "PROTHEUS.ch"
#Include "RWMAKE.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAxTipProd  บAutor  ณEDUAR ANDIA 		บFecha ณ  01/02/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Maestro de Tipo de Producto con Cuenta Contables   		  บฑฑ
ฑฑบ          ณ Para Automatizar creaci๓n del Producto (Ctas Automแticas)  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia \Industrias Bel้n		                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AxTipProd
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

/*
AxCadastro("Z05"	, "Moneda para Venta", "U_DelOk()", "U_COK()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )
*/

AxCadastro("Z05"	, "Tipo de Producto /Cuentas")  
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
