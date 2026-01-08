#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAxCadZRQ  บAutor ณ  EDUAR ANDIA (TOTVS) บFecha ณ 15/04/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ mBrowse da tabela ZRQ/Requisitos 				  	      บฑฑ
ฑฑบ          ณ Parametiza็ใo Requisitos vs Tipo de Cliente 	              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIMA\Bolivia                                         	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AxCadZRQ
Local nX 		:= 1
Local cAlias	:= "ZRQ"
Local cTitle   	:= "Requisitos"
Local cDel		:= 	Nil
Local cOk		:= 	Nil
Local aRotAdic  := {}
Local bPre     	:= {|| .T.}
Local bOk      	:= {|| .T.}
Local bTTS     	:= {|| GravaZRQ()}
Local bNoTTS   	:= {|| .T.}
Local aAuto		:= Nil
Local nOpcAuto 	:= 3
Local aButtons	:= Nil
Local aACS     	:= {}
Local cTela		:= Nil
Local aCores	:= {}

Private cOkFunc := cDel
Private cDelFunc:= cOk
Private aParam  := {bPre,bOK,bTTS,bNoTTS}
Private xAuto   := aAuto  
Private aNewBtn := aButtons
Private aRotina := { { oemtoansi("Buscar"),"AxPesqui", 0 , 1},; // "Pesquisar"
	{ oemtoansi("Visualizar") ,"AxCadVis", 0 , 2},; //"Visualizar"
	{ oemtoansi("Incluir")	  ,"AxCadInc", 0 , 3},; //"Incluir"
	{ oemtoansi("Modificar")  ,"AxCadAlt", 0 , 4},; //"Alterar"
	{ oemtoansi("Borrar")	  ,"AxCadDel", 0 , 5}}  //"Excluir"
                   
AADD(aRotAdic,{ "Leyenda"			,"U_LgendZRQ()" , 0 , 6 })

AADD(aCores,{"ZRQ_BLQ == 'S'"	,'DISABLE'})					//Requisito Bloqueado
AADD(aCores,{"Empty(ZRQ_BLQ) .OR. ZRQ_BLQ == 'N'",'ENABLE' })	//Requisito no Bloqueado

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adiciona o array de rotinas adicioniais   				     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ValType( aRotAdic ) == "A"
	AEval( aRotAdic, { |x| AAdd( aRotina, x ) } )   
EndIf
For nX := 1 To Len(aACS)
	If aACS[nX] <> Nil
		aadd(aRotina[nX],aACS[nX])
	EndIf
Next nX
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o cabecalho da tela de atualizacoes				     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cCadastro := OemToAnsi(cTitle)
If aAuto==Nil
	mBrowse( 6, 1,22,75,cAlias,,,,,,aCores,,,,,,,,,,, cTela)
Else
	MBrowseAuto(nOpcAuto,Aclone(aAuto),cAlias)
EndIf
Return

//+------------------------------------------------------------------------+
//|Fun็ใo Legenda														   |
//+------------------------------------------------------------------------+
User Function LgendZRQ
Local lRet 	 := .T.
Local aCores := {}
aCores := {{"ENABLE","Requisito Bloqueado"	},;  	//Requisito Bloqueado
          {"DISABLE","Requisito NO Bloqueado"	}}  //Requisito nใo Bloqueado

BrwLegenda("Leyenda","Requisitos",aCores)
Return(lRet)

Static Function GravaZRQ()
Local lRet := .T.
If Inclui
	If Empty(ZRQ->ZRQ_BLQ)
		ZTC->ZRQ_BLQ := "S"
	Endif
Endif
Return(lRet)
