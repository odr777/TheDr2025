#Include "Protheus.ch"

/*/================================================================================================================================/*/
/*/{Protheus.doc} M105BUT
Ponto de entrada para adicionar solicitudes al almaén.
@type function
@author Nahim Terrazas
@since 15/02/2020
@version P12.1.17
@return Array, Array com botão.
/*/
/*/================================================================================================================================/*/
User Function M105BUT
	//+---------------------------------------------------------------------+
	//| Declaracao de Variaveis                                             |
	//+---------------------------------------------------------------------+
	Local aRot := A105Imprim()
	
	
Return aRot

static function A105Imprim(cAlias,nReg,nOpcx)
	Local aAreaAnt := GetArea()
	Local cPrinter := GetMV("MV_RELSALM" ,, "" )
	Local xRet     := .T.

	If !Empty( cPrinter ) .And. Existblock( cPrinter )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a chamada do relatorio de usuario                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ExecBlock( cPrinter, .F., .F., { SCP->CP_EMISSAO,SCP->CP_NUM } )
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a chamada do relatorio padrao                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xRet := MATR105(.F.,{SCP->CP_EMISSAO,SCP->CP_NUM})
	EndIf
	Pergunte("MTA105", .F.)
	RestArea(aAreaAnt)
Return( xRet )