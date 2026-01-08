#include 'protheus.ch'
#include 'parmtype.ch'

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA087GRV  บAutor  ณTdeP Horeb SRL  บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPUNTO DE ENTRADA PARA LA IMPRESION DEL RECIBO DE COBRANZAS  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BIB									                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function FA087GRV()
	aArea    := GetArea()

	if GetRemoteType() < 0 // nahim Terrazas toma en cuenta s๓lo si no es un web services
		return .T.
	endif
	
//	alert("FA087GRV")
	
/*
	SX1->(DbSetOrder(1))
	SX1->(DbGoTop())
	If SX1->(DbSeek('FIR087'+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cRecibo
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek('FIR087'+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cRecibo
		SX1->(MsUnlock())
	End

	SX1->(DbSetOrder(1))
	SX1->(DbGoTop())
	If SX1->(DbSeek('FIR087'+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cSerie
		SX1->(MsUnlock())
	End

	IF(FUNNAME()$'FINA087A')
		if GetRemoteType() >= 0 // nahim Terrazas toma en cuenta s๓lo si no es un web services
			U_CFinI204()
		endif
		//U_CobrDiv()
	END
*/
	RestArea( aArea )

return