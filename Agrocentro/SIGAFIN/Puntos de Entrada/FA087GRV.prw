#include 'protheus.ch'
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087GRV  ºAutor  ³TdeP Horeb SRL  º Data ³  30/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PUNTO DE ENTRADA PARA LA IMPRESION DEL RECIBO DE COBRANZAS  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIB									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA087GRV()
	aArea    := GetArea()

	if SEL->EL_SERIE == 'CMP' //ES UNA COMPENSACION?

		IF(FUNNAME()$'FINA087A')

			If Type("cxGlaObs")=="C"

				DbSelectArea("SEL")
				SEL->(DbSetOrder(7))
				SEL->(DbGoTop())
				SEL->(DbSeek(FWxFilial('SEL') +cCliente+cLoja+cRecibo+cSerie))

				Do While !SEL->(Eof()) .and. SEL->EL_RECIBO == cRecibo .and. cCliente == SEL->EL_CLIORIG;
						.and. cLoja == SEL->EL_LOJORIG .and. cSerie == SEL->EL_SERIE

					RecLock("SEL", .F.)
					SEL->EL_UOBSTAR := cxGlaObs
					SEL->(MsUnLock())

					///ACTUALIZAMOS LA SE5
					DbSelectArea("SE5")

					SE5->(DbSetOrder(8))

					SE5->(DbSeek(xFilial("SE5")+SEL->EL_RECIBO+SEL->EL_SERIE))  ///posicione de recibo
					While SE5->(!Eof()) .AND. (SE5->E5_FILIAL== xFilial("SE5").AND. SE5->E5_ORDREC==SEL->EL_RECIBO .AND. SE5->E5_SERREC == SEL->EL_SERIE)

						RecLock("SE5", .F.)
						SE5->E5_UGLOSA := cxGlaObs
						SE5->(MsUnLock())

						SE5->(dbSkip())
					EndDo

					SEL->(DBSKIP())
				ENDDO

				////liberamos las variables
				cxGlaObs := NIL
				FreeObj(cxGlaObs)

			ENDIF
		ENDIF
	ENDIF

	RestArea( aArea )

return
