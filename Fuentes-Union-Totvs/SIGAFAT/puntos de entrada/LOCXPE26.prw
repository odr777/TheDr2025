#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE26  ºAutor  ³Jorge Cardona,		   º Data ³  26/09/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ actualiza el campo cc que viene de la tabla sd1  		  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE26
	Local lRetD2 := .T.
	Local cSD2fil := alltrim(SF2->F2_FILIAL)//vemos desde que filial se hizo para actualizar a esa filial no a la de la entrada
	Local cSD2Doc := alltrim(SD2->D2_REMITO)
	Local cSD2Ser := 'R  '

	// SI RUTINA ES FACTURACIÓN O TRANSMITIR FACTUR ELECTRONICA
	if (FunName() $ "MATA467N" .OR. FunName() $ "MATA486").AND. !Empty(cSD2Doc)

		lRetD2 := .F.
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))

		IF SD2->(dbSeek(cSD2fil + cSD2Doc + cSD2Ser))
			While SD2->( !Eof() .and. alltrim(D2_FILIAL+D2_DOC+D2_SERIE) == alltrim(cSD2fil + cSD2Doc + cSD2Ser))
				if 'RFN' $ SD2->D2_ESPECIE
					//nQuant := SD2->D2_QUANT

					RECLOCK("SD2", .F.)

					SD2->D2_UFACDEL := 'ANULAR'

					//SD2->D2_QTDEFAT := 0

					MSUNLOCK()

				endif
				
				SD2->( dbSkip() )
			ENDDO

		lRetD2 = .T.

		//ELSE

		//	MsgInfo("Documento no borrado", "A100DEL MSG") //Nao permite que se borre el doc

		ENDIF
	ENDIF

return lRetD2

