#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#include 'parmtype.ch'
#Include "TopConn.ch"

User function MT160WF()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF      ºAutor  ³Nain Terrazas     º Data ³  05/03/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copiar datos de SC1 a SC7	    				  º±±
±±ºDesc.     ³Ajuste Erick Etcheverry Mostrar el Nro de PC	25/02/2019º±±
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

	Local cNcOT := SC7->C7_NUMCOT
	Local acNoPed := {}

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

//Para informar el número de Pedido de Compras
	
	acNoPed := getPeds(cNcOT,SC7->C7_EMISSAO,SC7->C7_FILIAL)
	FOR i:= 1 to len(acNoPed)
		Aviso("Información PE MT160WF","Se Generó el PC: "+ acNoPed[i],{"Ok"},,"Atencion")
	next i

return

static Function getPeds(cNumCot,cEmissao,cFilla)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local acNped := {}
	
	//Montando a Consulta... Tentem evitar o SELECT * pois isso pode travar o TOPCONN
	cQuery := " SELECT DISTINCT "
	cQuery += "   C7_NUM "
	cQuery += " FROM "
	cQuery += "   " + RetSQLName("SC7") + " SC7 "
	cQuery += " WHERE "
	cQuery += " C7_NUMCOT = '"+cNumCot+"' AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " AND C7_EMISSAO = '"+DTOS(cEmissao)+"' AND C7_FILIAL = '"+cFilla+"' "
	
	cQuery := ChangeQuery(cQuery)
	
	//Executando consulta
	TCQuery cQuery New Alias "QR_SC7"
	
	//Percorrendo os registros
	While ! QR_SC7->(EoF())
		AADD(acNped,QR_SC7->C7_NUM)
		QR_SC7->(DbSkip())
	EndDo
	
	QR_SC7->(DbCloseArea())
	RestArea(aArea)
	
Return acNped