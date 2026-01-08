#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAxCadZTC  บAutor ณ  EDUAR ANDIA (TOTVS) บFecha ณ 15/04/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ mBrowse da tabela ZTC/Tipo de Cliente 				  	  บฑฑ
ฑฑบ          ณ Parametiza็ใo Requisitos vs Tipo de Cliente 	              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIMA\Bolivia                                         	      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AxCadZTC
Local nX 		:= 1
Local cAlias	:= "ZTC"
Local cTitle   	:= "Tipo de Credito"
Local cDel		:= 	Nil
Local cOk		:= 	Nil
Local aRotAdic  := {}
Local bPre     	:= {|| .T.}
Local bOk      	:= {|| .T.}
Local bTTS     	:= {|| GravaZTC()}
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
Private aItens	:= {}
Private aRotina := { { oemtoansi("Buscar"),"AxPesqui", 0 , 1},; // "Pesquisar"
	{ oemtoansi("Visualizar") ,"AxCadVis", 0 , 2},; //"Visualizar"
	{ oemtoansi("Incluir")	  ,"AxCadInc", 0 , 3},; //"Incluir"
	{ oemtoansi("Modificar")  ,"AxCadAlt", 0 , 4},; //"Alterar"
	{ oemtoansi("Borrar")	  ,"AxCadDel", 0 , 5}}  //"Excluir"

AADD(aRotAdic,{ "Requisitos"		,"U_TWBRequi()" , 0 , 6 })                   
AADD(aRotAdic,{ "Leyenda"			,"U_LgendZTC()"	, 0 , 6 })

AADD(aCores,{"ZTC_BLQ == 'S'"	,'DISABLE'})					//Tipo de Credito Bloqueado
AADD(aCores,{"Empty(ZTC_BLQ) .OR. ZTC_BLQ == 'N'",'ENABLE' })	//Tipo de Credito no Bloqueado

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
User Function LgendZTC
Local lRet 	 := .T.
Local aCores := {}
aCores := {{"ENABLE","Tipo de Credito Bloqueado"	},;  //Tipo de Credito Bloqueado
          {"DISABLE","Tipo de Credito NO Bloqueado"	}}   //Tipo de Credito nใo Bloqueado

BrwLegenda("Leyenda","Tipo de Credito",aCores)
Return(lRet)

Static Function GravaZTC()
Local lRet := .T.
If Inclui
	If Empty(ZTC->ZTC_BLQ)
		ZTC->ZTC_BLQ := "S"
	Endif
Endif
Return(lRet)


/*
User Function AxCadZRC
	AxCadastro("ZRC","Requisito / Credito")
Return
*/