#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#include 'parmtype.ch'

User function MT160WF()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF      ºAutor  ³Nain Terrazas       º Data ³  05/03/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copiar datos de SC1 a SC7	    							  º±±
±±ºDesc.     ³Ajuste Nahim Dhaney Mostrar el Nro de PC					  º±±
±±º          ³MP12BIB                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA160 (PUNTO DE ENTRADA EN LA FUNCION  A160ANALIS        º±±
±±ºUso       ³ EM QUE PONTO : Após a gravação dos pedidos de compras pela º±±
±±ºanalise da cotação e antes dos eventos de contabilização, utilizado para os º±± 
±±ºprocessos de workFlow posiciona a tabela SC8 e passa como parametro o numero º±±
±±ºda cotação.                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT160WF()
//	Aviso("Información PE MT160GWF","Se Generó el PC: "+SC7->C7_NUM,{"Ok"},,"Atencion")
//Para que Actualice todos los registros del PC
Local cC7Num 	:= xFilial("SC7")+SC7->C7_NUM
Local aArea 	:= GetArea()
Local aAreaSC7 	:= SC7->(GetArea())
//Local cChvPed  	:= PARAMIXB

DBSelectArea('SC7')
DbSetOrder(1)
DbSeek(cC7Num)

//Alert('MT120APV - 1 - '+cC7Num+SC7->C7_ITEM)
While xFilial("SC7")+SC7->C7_NUM == cC7Num	
	//Alert('MT120APV - 2 - '+cC7Num+SC7->C7_ITEM)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grabando los campos personalizados por Item en el Pedido     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SC7", .F.)
		SC7->C7_UNOME := GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),1,"")
	MsUnLock()

	DbSelectArea("SC7")
	DbSkip()
Enddo

RestArea(aAreaSC7)
RestArea(aArea)

return