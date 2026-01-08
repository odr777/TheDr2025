#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTAB2D2 ³ Autor ³	Query	: Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Punto de entrada al momento de actualizar el saldo de los    ³±±
±± almacenes																 ±±
±±³Sintaxe   ³ MTAB2D2()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      Al anular la factura de salida modifica el saldo (Belén)		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³26/11/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTAB2D2()
	Local cCodPro    := ParamIXB[1]  //-- Codigo do Produto
	Local cLocal        := ParamIXB[2]  //-- Local
	Local nMultiplic   := ParamIXB[3]  //-- 1 - Operacao de Entrada/ -1 Operacao de Saida
	//	local lActivaLoc :=  //

	//	alert(lAnulaSF3) // TRUE ANULACIÓN
	// lAnulaSF3 indica si anulará libros fiscales (si es SI es ANULACIÓN)
	if (funname() == 'MATA467N' .and. nMultiplic == 1 .AND. lAnulaSF3) .or. (funname() == 'MATA462N' .and. nMultiplic == 1 )
		cAlmDev := SuperGetMv("MV_UALMDEV",.F.,"DV") // ALMACEN DE DEVOLUCIONES
		//		alert(nMultiplic) /// sale 1
		RecLock('SD2',.F.)
		REPLACE D2_LOCAL WITH cAlmDev
		MsUnLock()
	endif
	//	dbSelectArea('SB2')
	//	dbSetOrder(1)//-- Se o produto nao existir no SB2, sera criado automaticamente
	//	If !MsSeek(xFilial('SB2')+cCodPro+cLocal, .F.)
	//		CriaSB2(cCodPro,cLocal)
	//	EndIf
	//	RecLock('SB2',.F.)//--//--Atualizacao dos campos do SB2 conforme necessidade do usuario. Exemplo:
	//	REPLACE B2_QATU WITH B2_QATU + (SD2->D2_QUANT*nMultiplic)//--
	//	MsUnLock()
Return .T.