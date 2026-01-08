#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAxCadZRC  บAutor ณ  EDUAR ANDIA (TOTVS) บFecha ณ 15/04/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ mBrowse da tabela ZRC				 				  	  บฑฑ
ฑฑบ          ณ Parametiza็ใo Requisitos vs Tipo de Cliente 	              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIMA\Bolivia                                         	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AxCadZRC
Local nX 		:= 1
Local cAlias	:= "ZRC"
Local cTitle   	:= "Requisitos"
Local cDel		:= 	Nil
Local cOk		:= 	Nil
Local aRotAdic  := {}
Local bPre     	:= {|| .T.}
Local bOk      	:= {|| TudoOkZRC()}
Local bTTS     	:= {|| GravaZRC()}
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

Public aItens := {}
                   
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

Static Function GravaZRC()
Local lRet := .T.
If Inclui	
Endif
Return(lRet)

Static Function TudoOkZRC
Local lRet := .T.
nReg :=	ZRC->(RECNO())

ZRC->(DbSetOrder(1))
If ZRC->(DbSeek(xFilial("ZRC")+M->ZRC_TIPO + M->ZRC_REQUIS))
	lRet := .F.
	Aviso("AxCadZRC","El registro - Tipo Cliente/Requisito ya existe",{"OK"})
Else
	lRet := .T.
Endif

ZRC->(DbGoTo(nReg))
Return(lRet)