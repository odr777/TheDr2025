#include 'protheus.ch'
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChkBlqDes   ºAutor  ³Jorge Saavedra      º Data ³  20/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza el Analisis de los Porcentajes de Descuento	y	º±±
±±º          ³Bloquea por Regla de Negocio                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function ChkBlqDes()
	Local _cArea:=GetArea()
	Local aAmbSC6 := SC6->(GetArea())
	Local nPorDesc:=0
	Local lBloqueado:= .F.
	Local nPorPromedio := 0
	Local lContado := .f.
	Local lVenFut	:= FWIsInCallStack("U_GERVTAFUT")

	/*dData := MAX( dAtual ,SC5->C5_EMISSAO)*/
	
	if !lVenFut

		If Posicione('SE4',1,xFilial('SE4')+M->C5_CONDPAG,'E4_TIPO') == '1'
			If AllTrim(SE4->E4_COND)$ '0|00' //AL CONTADO
				lContado := .T.
			End
		End


		/*If !lBloqueado .and. SC5->C5_MOEDA == 1
			UpdSC5SC6()
			lBloqueado:= .T.
			Aviso("VALIDACION REGLA",'LA MONEDA ES EN BOLIVIANOS',{"Ok"},,"ATENCION PEDIDO BLOQUEADO POR REGLAS DE NEGOCIO")
		endif*/

		If !lBloqueado
			cQrySE1  := GetNextAlias()

			cClie := M->C5_CLIENTE
			cLoja := M->C5_LOJACLI

			BeginSql alias cQrySE1
				SELECT ISNULL(SUM(CASE WHEN E1_TIPO = 'RA ' THEN E1_SALDO*E1_TXMOEDA*-1 ELSE E1_SALDO*E1_TXMOEDA END),0) E1_SALDO, ISNULL(MIN(CASE WHEN E1_TIPO = 'RA' THEN '29991231' ELSE E1_VENCTO END), '29991231') E1_VENCTO
				FROM %table:SE1% SE1
				WHERE SE1.D_E_L_E_T_ = ' '
				And E1_CLIENTE = %Exp:cClie%
				And E1_LOJA = %Exp:cLoja%
				And E1_TIPO IN('NF ','RA ', 'CH')
				And E1_SALDO > 0
			EndSql

			cDebug := GetLastQuery()[2]

			if (cQrySE1)->( !Eof() )

				dFecVcto := StoD((cQrySE1)->E1_VENCTO)

				If dFecVcto <= date() .OR. (lContado .AND. dFecVcto <= date())
					UpdSC5SC6()
					Aviso("VALIDACION CREDITO",'EL CLIENTE TIENE DEUDAS MOROSAS',{"Ok"},,"ATENCION PEDIDO BLOQUEADO POR REGLAS DE NEGOCIO")
					lBloqueado:= .T.
				EndIf

			EndIf
		endif

		dAtual := date()

		if SC5->C5_EMISSAO < dAtual .and. !lBloqueado
			UpdSC5SC6()
			lBloqueado:= .T.
			ALERT("PEDIDO DE VENTAS SERA BLOQUEADO POR REGLA DE NEGOCIOS."+CHR(13)+CHR(10)+"REVISE LA FECHA DE EMISION.")
		endif

		nPorDesc := GetAdvFVal("SA3","A3_UPORDES",xFilial("SA3")+SC5->C5_VEND1,1,0)

		If !lBloqueado
			IF SC5->C5_DESC1 > nPorDesc
				UpdSC5SC6()
				lBloqueado:= .T.
				ALERT("PEDIDO DE VENTAS SERA BLOQUEADO POR REGLA DE NEGOCIOS."+CHR(13)+CHR(10)+"EL PORCENTAJE DE DESCUENTO ES SUPERIOR AL PERMITIDO.")
			ELSE
				SC6->(DbSetOrder(1))
				SC6->(DbGoTop())
				If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
					While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
						iF SC6->C6_BLOQUEI $ "01"
							Reclock('SC6',.F.)
							SC6->C6_BLOQUEI := ""
							SC6->(MsUnlock())
						End
						SC6->(DbSkip())
					End

				End
			END
		ENDIF

		If !lBloqueado
			If SC5->C5_DESC1 == 0
				//Verificamos el porcentaje de Descuento por Item
				nPorDescItem := 0
				SC6->(DbSetOrder(1))
				SC6->(DbGoTop())
				//Calculamos el Porcentaje de Descuento por Item
				If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
					While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
						nPorPromedio := 0
						iF SC6->C6_DESCONT > nPorDesc
							lBloqueado:= .T.
						END
						SC6->(DbSkip())
					End
				End

				//Se Actualiza el Bloqueo por que supera el Descuento por Porcentaje por Item
				iF lBloqueado
					UpdSC5SC6()
					ALERT("PEDIDO DE VENTAS SERA BLOQUEADO POR REGLA DE NEGOCIOS."+CHR(13)+CHR(10)+"EL PORCENTAJE DE DESCUENTO ES SUPERIOR AL PERMITIDO.")
				else
					SC6->(DbSetOrder(1))
					SC6->(DbGoTop())
					//Calculamos el Porcentaje Promedio de Descuento por Item
					// Cuando el Porcentaje de Descuentos en la cabecera y por Item es cero
					If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
						While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
							nPorPromedio := Round(100 - (SC6->C6_PRCVEN *100/ SC6->C6_PRUNIT),2)
							iF nPorPromedio> nPorDesc
								lBloqueado:= .T.
							END
							SC6->(DbSkip())
						End
					End
					//Actualiza el bloqueo por que supera el Descuento cuando se digita manualmente el Precio de venta
					iF lBloqueado
						UpdSC5SC6()
						ALERT("PEDIDO DE VENTAS SERA BLOQUEADO POR REGLA DE NEGOCIOS."+CHR(13)+CHR(10)+"EL PORCENTAJE DE DESCUENTO ES SUPERIOR AL PERMITIDO.")
					END
				END
			End
		END

	endif

	RestArea(_cArea)
	RestArea(aAmbSC6)
return

//Actualiza las tablas SC5 y SC6 como Bloquedas
Static Function UpdSC5SC6
	dBSelectArea("SC5")
	RecLock("SC5",.F.)
	//³Atualiza do C5_LIBEROK                                                  ³
	SC5->C5_BLQ := "1"
	SC5->(MsUnlock())

	//Se Actualiza el Bloqueo en la SC6 Descuento por Cabecera
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
		While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
			Reclock('SC6',.F.)
			SC6->C6_BLOQUEI := "01"
			SC6->(MsUnlock())
			SC6->(DbSkip())
		End

	End

return
