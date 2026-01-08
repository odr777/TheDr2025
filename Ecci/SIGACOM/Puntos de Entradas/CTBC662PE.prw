#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CTBC662 ³ Autor ³ TOTVS        	        ³ Data ³ 31.05.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Punto de entrada para imprimir desde el tracker el asiento ³±±
±±³          ³ contable 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GLOBAL                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function CTBC662()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.

	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		/*
		lIsGrid    := ( Len( aParam ) > 3 )

		If lIsGrid
		nQtdLinhas := oObj:GetQtdLine()
		nLinha    ADMIN	 := oObj:nLine
		EndIf*/

		//       If     cIdPonto == 'MODELPOS'
		If cIdPonto == 'BUTTONBAR'
			//ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
			xRet := { {'Imprimir Asiento', 'Imprimir Asiento', { || llamaAsiento(aCpoOri,__aDocOri,__aLanCT2) }, 'Imprimir Asiento' } }
//			oModel:GetModel('LCTCT2')
		EndIf

	EndIf

Return xRet

static function llamaAsiento(aCpoOri,__aDocOri,__aLanCT2)
	Local oModelK    := FwModelActive()
	onModeloGrid := oModelK:GetModel( "LCTCT2" ) //:oModelGrid:GetValue("PARCELA" )
	cPregNah:="CTR070"
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPregNah+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DTOS(onModeloGrid:GetValueByPos(2,1))
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPregNah+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(onModeloGrid:GetValueByPos(2,1))
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  onModeloGrid:GetValueByPos(3,1)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  onModeloGrid:GetValueByPos(3,1)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  onModeloGrid:GetValueByPos(5,1)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'06'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  onModeloGrid:GetValueByPos(5,1)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'07'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  '01'
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'12'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  '3'
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'15'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  onModeloGrid:GetValueByPos(4,1)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'16'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  onModeloGrid:GetValueByPos(4,1)
		SX1->(MsUnlock())
	END
	U_CtbcR070()

return