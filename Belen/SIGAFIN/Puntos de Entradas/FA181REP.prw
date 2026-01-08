#Include 'Protheus.ch'

User Function FA181REP()

RecLock('SE5',.F.)
	/*
	If __CUSERID = '000000'
		Alert(SEI->EI_TIPODOC)
	EndIf
	*/
	SE5->E5_VALOR := SEI->EI_VALOR
	SE5->E5_VLMOED2 := SEI->EI_VALOR
SE5->(MsUnlock())

Return NIL