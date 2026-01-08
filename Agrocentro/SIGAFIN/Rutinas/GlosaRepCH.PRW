#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F085GRA   º Autor ³ Widen Gonzalesº Fecha ³  11/04/17      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Glosa que se ejecuta en el PE FA550REP                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BIB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function GlosaRepCH
	Local cGlosaRep
	Local aArea     := GetArea()
	Local CTIPPAGO  := "P"//Indica que es un pago(P)
	Local lMostraGlosa := .t.

	///PREGUNTAMOS SI EXISTE LA GLOSA DEL CIERRE
	if SEU->EU_TIPO == '11' .and. Type("cxCaixGlo")=="C"
		lMostraGlosa := .f.
		RecLock("SEU",.F.)
		SEU->EU_UGLOSA := cxCaixGlo
		SEU->(MsUnlock())
		cxCaixGlo := NIL
		FreeObj(cxCaixGlo)
	endif

	if lMostraGlosa
		DEFINE MSDIALOG oDlgVCan TITLE "Concepto - Glosa" From 9,0 To 20,90
		PUBLIC cGlosaRep := Space(Len(SEU->EU_UGLOSA))
		// cGlosaCon :=  "Pago "  + ALLTRIM(SA2->A2_NREDUZ) + " / " // TamSX3('CT2_DOC')[1]
		cGlosaRep := PadR(cGlosaRep,TamSx3("EU_UGLOSA")[1]," ")
		@ 3  ,1 SAY OemToAnsi("Concepto")
		@ 3  ,5  MSGET cGlosaRep  Picture "@!" Valid !Empty(cGlosaRep)
		DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan
		// TamSX3('CT2_DOC')[1]
		ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()
		//ALERT (SEU->EU_NUM)
		If nOpca == 1
			RecLock("SEU",.F.)
			SEU->EU_UGLOSA := cGlosaRep
			SEU->(MsUnlock())
		EndIf

		DbSelectArea("SE5")
		SE5->( DbSetOrder(3) )//E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)
		If(SE5->( DbSeek(xFilial("SE5") + SEU->EU_BANCO + SEU->EU_AGENCI + SEU->EU_CONTARE + "   " + SEU->EU_TITULO) ))
			While !EOF() .AND. SubStr(SE5->E5_FILIAL, 1, 2) == Alltrim(xFilial("SEU")) .AND. SEU->EU_BANCO==SE5->E5_BANCO .AND. SEU->EU_AGENCI==SE5->E5_AGENCIA .AND. SEU->EU_CONTARE==SE5->E5_CONTA .AND. ALLTRIM(SEU->EU_TITULO)==ALLTRIM(SE5->E5_NUMERO)
				If( TRIM(SE5->E5_RECPAG) == CTIPPAGO )//Si es pago
					RecLock("SE5",.F.)
					SE5->E5_UGLOSA := cGlosaRep
					SE5->(MsUnlock())
				EndIf
				SE5->(DBSkip())
			Enddo

		EndIf
		SE5->(DbCloseArea())

		RestArea( aArea )

	endif

Return

