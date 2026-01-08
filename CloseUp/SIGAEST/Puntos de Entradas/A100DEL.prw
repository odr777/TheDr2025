#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A100DEL()  ºAutor Erick Etcheverry ³ESTOQUE º Data ³30/01/19º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Actualiza el borrado del traspaso de salida 		          º±±
±±PE.     ³ Ejecutado despues de borrar el remito de entrada SF1	       ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA462TN Transferencia entre sucursales                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function A100DEL()
	Local lRetD2 := .t.
	Local cSD2fil := alltrim(SF1->F1_FILORIG)//vemos desde que filial se hizo para actualizar a esa filial no a la de la entrada
	Local cSD2Doc := alltrim(SF1->F1_DOC)
	Local cSD2Ser := alltrim(SF1->F1_SERIE)

	if FunName() $ "MATA462TN"

		lRetD2 := .F.
		dbSelectArea("SD2")

		SD2->(dbSetOrder(3))

		IF SD2->(dbSeek(cSD2fil + cSD2Doc + cSD2Ser))

			While SD2->( !Eof() .and. alltrim(D2_FILIAL+D2_DOC+D2_SERIE) == cSD2fil + cSD2Doc + cSD2Ser)

				if 'RTS' $ SD2->D2_ESPECIE
					
					nQuant := SD2->D2_QUANT

					RECLOCK("SD2", .F.)

					SD2->D2_QTDAFAT := nQuant

					SD2->D2_QTDEFAT := 0

					MSUNLOCK()

				endif
				
				SD2->( dbSkip() )
			ENDDO

			lRetD2 = .T.

		ELSE

			MsgInfo("Documento no borrado", "A100DEL MSG") //Nao permite que se borre el doc

		ENDIF
	ENDIF

return lRetD2
