#include 'protheus.ch'
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087SEL  ºAutor  ³Widen Gonzales º Data ³  04/12/2019      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PUNTO DE ENTRADA DESPUES DE GRABAR EN LA TABLA SEL		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA087SEL()

	Local aArea 	:= GetArea()

	IF(FUNNAME()$'FINA087A')

		DbSelectArea("SEL")
		SEL->(DbSetOrder(7))
		SEL->(DbGoTop())
		SEL->(DbSeek(FWxFilial('SEL') +cCliente+cLoja+cRecibo+cSerie))

		Do While !SEL->(Eof()) .and. SEL->EL_RECIBO == cRecibo .and. cCliente == SEL->EL_CLIORIG;
				.and. cLoja == SEL->EL_LOJORIG .and. cSerie == SEL->EL_SERIE

			if !EMPTY(ALLTRIM(SEL->EL_BANCO)) ////TIENE BANCO?? ACTUALIZAMOS LA SE5

				DbSelectArea("SE5")

				SE5->(DbSetOrder(8))

				SE5->(DbSeek(xFilial("SE5")+SEL->EL_RECIBO+SEL->EL_SERIE))
				While SE5->(!Eof()) .AND. (SE5->E5_FILIAL== xFilial("SE5").AND. SE5->E5_ORDREC==SEL->EL_RECIBO .AND. SE5->E5_SERREC == SEL->EL_SERIE)

					RecLock("SE5", .F.)
					SE5->E5_UGLOSA := SEL->EL_UOBSTAR
					SE5->(MsUnLock())

					SE5->(dbSkip())
				EndDo

			endif

			SEL->(DBSKIP())
		ENDDO

		U_CFinI204() // comentando porque se generará luego de la contabilidad.

	ENDif

	RestArea(aArea)
return
