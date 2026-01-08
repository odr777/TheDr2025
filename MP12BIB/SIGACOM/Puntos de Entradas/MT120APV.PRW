#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

User function MT120APV()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120APV     ºAutor  ³Nain Terrazas       º Data ³  05/03/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cambia Grupo de Aprobadores según SC1 a SC7 Sólo pasa 1º regº±±
±±ºDesc.     ³Ajuste Nahim Dhaney Mostrar el Nro de PC					  º±±
±±º          ³MP12BIB                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA120 (PUNTO DE ENTRADA EN LA FUNCION                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Local ExpC1 := PARAMIXB[1]
//Local ExpC2 := PARAMIXB[2] 

Aviso("Información PE MT120APV","Se Generó el PC: "+SC7->C7_NUM,{"Ok"},,"Atencion")

/*
IF !EMPTY(SC7->C7_NUMSC)
RecLock("SC7",.F.) //con .T. Inserta con .F. modifica el registro posicionado
//	Alert("Pasó por aquí"+SC1->C1_UNIDREQ)
	SC7->C7_UUNIDRE := SC1->C1_UNIDREQ
	SC7->C7_UMR := SC1->C1_UMR
MsUnLock()
ENDIF
*/

//Return{ExpC1,ExpC2}

/*
If Alltrim(FUNNAME())$'MATA160'
	Return(SC1->C1_UNIDREQ)
Else
	If Altera
		Return
	Else
		Return
		//Return(SC1->C1_UNIDREQ)
	EndIf
EndIf
*/

/*
EXEMPLO 1 (Manipulando o grupo de aprovação):
User Function MT120APV()
Local ExpC1 := PARAMIXB[1]
Local ExpC2 := PARAMIXB[2] 
Código do usuário manipulando o grupo de aprovação, conforme necessidade.
Return{ExpC1,ExpC2}

EXEMPLO 2 (Manipulando o saldo do pedido, na alteração do pedido):
User Function MT120APV()
Local ExpC1 := PARAMIXB[1]
Local ExpC2 := PARAMIXB[2]
If Altera  
// Manipulando o saldo do pedido pelo usuário, conf. necessidade, atualizando a variável n120TotLib
EndIf
Return{ExpC1,ExpC2}
*/