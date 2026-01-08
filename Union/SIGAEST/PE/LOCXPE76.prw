#include 'protheus.ch'
#include 'parmtype.ch'

user function LOCXPE76()
	Local lEnvCQ := PARAMIXB[1]
	Local cTpNF  := PARAMIXB[2]
	
	//alert(cTpNF)
	
	if ALLTRIM(cTpNF) == "N" .and. alltrim(SD1->D1_ESPECIE) == "RTE" .AND. SD1->D1_TIPODOC == "64"
		lEnvCQ = .F.
	endif

Return lEnvCQ