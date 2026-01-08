#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ GPEA240 ณDenar Terrazas				   บ Data ณ 19/06/2019บฑฑ
ฑฑบPrograma ณ VALIDACION DE LINEA Erick Etcheverry     บ Data ณ 09/05/2024บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Punto de entrada MVC			 	 	 	 	 	          บฑฑ
ฑฑบ USO      ณ Impresion boleta vacacion y validacion de lineas           บฑฑ
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
	Local lIsGrid    := .F.


	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )

		If cIdPonto == 'BUTTONBAR'
			xRet := { {'Imprimir Boleta', 'IMPRIMIR', { || imprimir(oObj) } } }

		elseIf cIdPonto == 'FORMLINEPOS'

			oModel := FWModelActivate()
			oGrid	 := oModel:GetModel("GPEA240_SR8")
			nAtual := oGrid:GetLine()

			///esta en alguna linea
			IF nAtual > 0

				//VAMOS A VALIDAR QUE LA VACACION QUE SE digite EN UNA LINEA SEA DEL MISMO MES
				dDataIni := oGrid:GetValue('R8_DATAINI')
				dDtaFim := oGrid:GetValue('R8_DATAFIM')

				cdIni := MESANO(dDataIni)
				cdFim := MESANO(dDtaFim)

				if cdIni <> cdFim
					MSGINFO("La linea de vacacion informada sobrepasa el mes, favor ingresar la vacacion en un solo mes" , "AVISO LINEA: " + CVALTOCHAR(nAtual) )
					xRet := .f.
				else
					xRet := .t.
				endif

			endif
		EndIf

	EndIf

Return xRet

static function imprimir(oObj)
	Local oModel	:= oObj:AMODELSTRUCT
	Local nLinea	:= oModel[1][4][1][3]:NLINE
	Local aHeader	:= oModel[1][4][1][3]:AHEADER
	Local aDados	:= oModel[1][4][1][3]:ACOLS
	Local nPosId	:= Ascan(aHeader,{ |x| Upper (Alltrim (x[2])) == "R8_NUMID"})
	Local cId		:= aDados[nLinea][nPosId]
	U_GPERBVAC(cId)
return
