#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

#DEFINE NIDAUS		26	//Posicion del ID de la ausencia

/*
5-> Codigo de ausencia
7-> Codigo de concepto
8-> Fecha de inicio
10-> Fecha de Fin
*/ 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ GPEA240 ณDenar Terrazas				   บ Data ณ 19/06/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Punto de entrada para imprimir la boleta de vacacion       บฑฑ
ฑฑบ          ณ desde la rutina de ausencias                               บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบModific.  ณ Se agreg๓ funcionalidad para registrar documentos          บฑฑ
ฑฑ 20/09/2019ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ                                                            บฑฑ
ฑฑฬออออออออออุอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TdeP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GPEA240()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		If cIdPonto == 'BUTTONBAR'
			xRet := { {'Imprimir Boleta', 'IMPRIMIR', { || imprimir(oObj) } } }
			AADD(xRet, {'Documentos', 'ADJUNTAR', { || MSdoc() } })
		EndIf

	EndIf

Return xRet

static function imprimir(oObj)
	Local oModel:= oObj:AMODELSTRUCT
	Local nLinea:= oModel[1][4][1][3]:NLINE
	Local aDados:= oModel[1][4][1][3]:ACOLS
	Local cId:= aDados[nLinea][NIDAUS]
	U_GPERBVAC(cId)
return

/**
*
* @author: Denar Terrazas Parada
* @since: 20/09/2019
* @description: Funci๓n para a๑adir documentos
*/
Static Function MSdoc()

Private aRotina := FWloadmenudef('GPEA240')

MsDocument('SRA',SRA->(RecNo()), 4)

return .t.
