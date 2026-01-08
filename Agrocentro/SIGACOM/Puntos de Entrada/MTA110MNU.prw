#Include 'Protheus.ch'

/*/{Protheus.doc} MT094LBF
https://tdn.totvs.com/pages/releaseview.action?pageId=6085755
@type function
@version 1.0
@author wico2k
@since 21/11/2022
/*/

User Function MTA110MNU()
Public cCodComp	:= SPACE(3)

aadd(aRotina,{'Asig. Comprador','U_AsgCmp',0,3,0,NIL})

Return aRotina


User Function AsgCmp()
Local cC1Num 	:= xFilial("SC1")+SC1->C1_NUM
Local aArea 	:= GetArea()
Local aAreaSC1 	:= SC1->(GetArea())

Define MsDialog oDlg From 0,0 To 060, 400 Title "Asignar Comprador a la SC " + SC1->C1_NUM Of oMainWnd Pixel 

@ 010,13 Say "Registre Código del Comprador :" Pixel Of oDlg
@ 008,094 MSGET cCodComp F3 "SY1" Valid ExistCpo("SY1",cCodComp) SIZE 55, 11 OF oDlg PIXEL hasbutton

DEFINE SBUTTON FROM 010,155 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
Activate MSDialog oDlg Centered

DBSelectArea('SC1')
DbSetOrder(1)
DbSeek(cC1Num)

While xFilial("SC1")+SC1->C1_NUM == cC1Num	
	RecLock("SC1", .F.)
		SC1->C1_CODCOMP := cCodComp
	MsUnLock()

	DbSelectArea("SC1")
	DbSkip()
EndDo

RestArea(aAreaSC1)
RestArea(aArea)

Return

