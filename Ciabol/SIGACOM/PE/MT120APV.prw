#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#Define ENTER "<BR>"  // SALTO DE LÍNEA (RETORNO DE CARRO + AVANCE DE LÍNEA)
#INCLUDE "FWEVENTVIEWCONSTS.CH"

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
	cEventID := "062"
	//	EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,"",ctitulo,cMesagem,.T.)
	cMessagem := " <H3>SE HA INCLUIDO EL PEDIDO DE COMPRA: " + SC7->C7_NUM + "</H3>" + ENTER
	cMessagem += " SUCURSAL: " + SC7->C7_FILIAL + ENTER
	cMessagem += " PROVEEDOR: " + SC7->C7_FORNECE + " " + SC7->C7_UNOME + ENTER
	cMessagem += " CENTRO DE COSTO: " + SC7->C7_CC + ENTER
	cMessagem += " CLASE DE VALOR: " + SC7->C7_CLVL + ENTER
	cMessagem += " OBSERVACIONES: " + SC7->C7_OBS + ENTER
	cMessagem += " OBSERVACIONES DE MANTENIMIENTO: " + SC7->C7_OBSM + ENTER
	cMessagem += " EN ESPERA DE APROBACION " + ENTER
	EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,""/*cCargo*/,"Nuevo pedido de compra nro: "+ SC7->C7_NUM,cMessagem,.T.)
	// U_EnviarMail("mcuevas@ciabol.com.bo,lcalvo@ciabol.com.bo,nbeltran@ciabol.com.bo,mugarte@ciabol.com.bo,jbaptista@ciabol.com.bo","fcastillo@ciabol.com.bo", "SISTEMA TOTVS: Se creo un Pedido de Compra",nil,cMessagem)
	U_EnviarMail("fcastillo@ciabol.com.bo","fcastillo@ciabol.com.bo", "SISTEMA TOTVS: Se creo un Pedido de Compra",nil,cMessagem)
	MSGINFO( "Mensaje enviado a los correos definidos", "INFORMACION" )
Return
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
