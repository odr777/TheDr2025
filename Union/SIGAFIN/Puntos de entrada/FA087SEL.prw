#include 'protheus.ch'
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087SEL  ºAutor  ³TdeP Horeb SRL º Data ³  21/12/2018      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PUNTO DE ENTRADA PARA LA IMPRESION DEL RECIBO DE COBRANZAS  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA087SEL()
	Local aArea		:= GetArea()

	dbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	SX1->(DbGoTop())
	If SX1->(DbSeek(PadR("COBRECC", 10) + '01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cRecibo
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(PadR("COBRECC", 10) + '02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cRecibo
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(PadR("COBRECC", 10) + '03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cSerie
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(PadR("COBRECC", 10) + '04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cSerie
		SX1->(MsUnlock())
	End

	IF(FUNNAME()$'FINA087A')
		IF(esCmp(cRecibo, cSerie))
			U_RECIBOCOBR()
		ELSE
			U_RECIBOCOBR()
		ENDIF
	END

	RestArea( aArea )

return

Static function esCmp(cRecibo, cSerie)
	Local aArea1	:= GetArea()
	Local lRet		:= .F.
	Local cSucursal	:= XFILIAL("SEL")
	local cTemp		:= getNextAlias()

	BeginSql alias cTemp

		SELECT *
		FROM %table:SEL% SEL
		WHERE EL_FILIAL = %exp:cSucursal%
		AND EL_RECIBO = %exp:cRecibo%
		AND EL_SERIE = %exp:cSerie%
		AND EL_BANCO <> '   '
		AND SEL.%notDel%

	EndSql

	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())

	if((cTemp)->(EOF()))
		lRet:= .T.
	endIf

	RestArea( aArea1 )
return lRet