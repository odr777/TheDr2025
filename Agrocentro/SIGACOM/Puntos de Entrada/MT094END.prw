#include 'protheus.ch'
#include 'parmtype.ch'

#define APPROVED	'L'
#define NOPCSI	2

/**
* @author: Denar Terrazas Parada
* @since: 09/08/2022
* @description: Punto de Entrada para enviar correo al proveedor cuando el pedido de compra esté totalmente aprobado.
* @routine: MATA094 - Liberar Documentos
* @help: https://tdn.totvs.com/display/public/PROT/TUMXYE_DT_PONTO_ENTRADA_MT094END
*/
User Function MT094END()
/* jbravo 6-4-2023: Anulado segun issue 218
	Local aArea     := getArea()
	Local cDocto    := PARAMIXB[1]
	Local nOpc      := PARAMIXB[3]  //1-Aprovar, 2-Estornar, 3-Aprovar pelo Superior, 4-Transferir para Superior, 5-Rejeitar, 6-Bloquear
	Local cFilDoc   := PARAMIXB[4]

	If nOpc == 1//Aprobar
		If(TRIM(SC7->C7_FILIAL) == TRIM(cFilDoc) .AND. TRIM(SC7->C7_NUM) == TRIM(cDocto))//Validación extra
			If( SC7->C7_CONAPRO == APPROVED )//Si el pedido está totalmente aprobado
				//If( confirmSendMail() )//Consulta si el usuario desea enviar el mail
				cProvEmail:= Trim(SA2->A2_EMAIL)
				If(!Empty(cProvEmail))
					cCopy	:= TRIM(SuperGetMV("MV_XMPTO", .F., ""))//Correos en copia
					aXMail	:= {cProvEmail , cCopy, TRIM(SA2->A2_NOME)}
					U_XMatr110( "SC7", SC7->(RECNO()), , aXMail )
				Else
					FWAlertWarning(;
						"El Proveedor: " + SC7->C7_FORNECE + " tienda: " + SC7->C7_LOJA + " no tiene un correo informado(A2_EMAIL).",;
						"Correo no informado")
				EndIf
				//EndIf
			EndIf
		EndIf
	endIf

	restArea(aArea)
*/
Return

/**
* @author: Denar Terrazas Parada
* @since: 09/08/2022
* @description: Pregunta al usuario si desea enviar mail al proveedor
*/
static function confirmSendMail()
	Local lRet      := .F.
	Local cTitulo   := "Enviar mail a proveedor"
	Local nOpcAviso

	nOpcAviso:= Aviso(cTitulo,'¿Desea enviar un mail con el pedido de compra al proveedor?',{'No', 'Si'})

	If(nOpcAviso == NOPCSI)
		lRet:= .T.
	EndIf

return lRet
