#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MSD2460
description
@type function
@version 1.0
@author Luiz Fael
@since 14/10/2022
@return variant, return_description
/*/
User Function MSD2460()
	Local aAreaSF2   := SF2->(GetArea())
	Local aAreaSD2   := SD2->(GetArea())
	IF  FUNNAME()=="MATA468N" .OR. FUNNAME()=="MATA461"
		If !Empty(SD2->D2_ITEMPV) .and. !Empty(SC5->C5_CAMPANA)
			RecLock("SD2",.F.)
			SD2->D2_CAMPANA := SC6->CAMPANA 	//001
			SD2->(MsUnLock())
		EndIf
	Endif
	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
Return()
