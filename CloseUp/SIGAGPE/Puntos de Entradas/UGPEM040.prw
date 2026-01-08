#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ GPEM040  ³ Autor ³ Carlos Egüez     ³ Data ³ 07/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ MVC Al Confirmar la Rescisao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ciabol                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function GPEM040()

	Local aArea := getArea()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local cIdPonto := ''
	Local oObj := ''
	Local lIsGrid := .F.
	Local cIdModel := ''

	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]

	lIsGrid := ( Len( aParam ) > 3 )

	if aParam <> NIL
		if cIdPonto == 'MODELCOMMITNTTS'

			if( oObj:NOPERATION == MODEL_OPERATION_DELETE)
				RECLOCK("SRA",.F.)

					SRA->RA_ULISN:= ''
					SRA->RA_XMOTVLN:= ''
					
					SRA->(MsUnlock())
			else
				If !Empty(SRG->RG_ULISN)
					If(ALLTRIM(SRG->RG_EFETIVA) == "S")
					alert(cIdModel)
					RECLOCK("SRA",.F.)

					SRA->RA_ULISN:= SRG->RG_ULISN
					SRA->RA_XMOTVLN:= SRG->RG_XMOTVLN

					SRA->(MsUnlock())
					endIf
				endIf
			endIf
		endif
	endif

	restArea(aArea)

Return xRet