#Include "Protheus.ch"

//Posicoes do Array  ASE2
#DEFINE _SALDO    5
#DEFINE _SALDO1   6
#DEFINE _PREFIXO  9
#DEFINE _RECNO   13
#DEFINE _PAGAR   21

#DEFINE DEB_INMEDT 3
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F85ASDBCO ºAutor  ³EDUAR ANDIA        º Data ³  19/02/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE -Permite que, no momento da confirmação da Ordem de 	  º±±
±±º          ³ Pagamento validar o saldo bancário						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia /Unión Agronegocios                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F85ASDBCO
Local aArea		:= GetArea()
Local cBanco	:= ParamIxb[1]
Local cAgencia	:= ParamIxb[2]
Local cConta	:= ParamIxb[3]
Local nValOrdens:= ParamIxb[4]
Local nSldBco 	:= 0
Local __nMoeBco	:= 0
Local lRet		:= .T.

If nPagar == DEB_INMEDT
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida Saldo de Banco   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetNewPar("MV_XVLSLOP",.T.)
		If !Empty(cBanco)
		
			__nMoeBco := GetAdvFVal("SA6","A6_MOEDA",xFilial("SA6")+cBanco+cAgencia+cConta,1,"1")
			nSldBco 	:= SldBco(cBanco,cAgencia,cConta,,,.T.)	//No usar parámetro Moeda, asume que banco es siempre en Moeda1
			nSldBco 	:= xMoeda(nSldBco,__nMoeBco,nMoedaCor,dDatabase,5,aTxMoedas[__nMoeBco][2])			
			
			nValOrdens 	:= Round(nValOrdens,TamSX3("A6_SALATU")[2])	
			/*
			Aviso("F85ASDBCO","nSldBco   : " +AllTrim(Str(nSldBco)) +CRLF+"nValOrdens: " +AllTrim(Str(nValOrdens))	 ,{"ok"},,,,,.T.)
			*/
			If nValOrdens > nSldBco
				lRet := .F.
				MsgAlert("Saldo Insuficiente")
			Endif
		Endif
	Endif
Endif

RestArea(aArea)
Return(lRet)