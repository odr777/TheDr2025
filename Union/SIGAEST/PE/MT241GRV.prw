#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MT241GRV    ³ Autor ³Erick Etcheverry     ³ Data ³16.01.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava campo customizado en el PE MT241CAB				 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT241GRV()
	Local oldArea	:= GetArea() //-- guarda a area
	Local cDoc		:= PARAMIXB[1]
	Local aCpoUs	:= PARAMIXB[2]
	Local SD3Area	:= SD3->(GetArea())
	//Aviso("aCpoUs",u_zArrToTxt(aCpoUs, .T.),{'ok'},,,,,.t.)

	SD3->(dbSetOrder(2))
	SD3->(dbSeek(xFilial()+cDoc))

	if Funname() $ "MATA241"
		cPerg:="MOVINT"
		Dbselectarea("SX1")
		SX1->(DbSetOrder(1))
		If SX1->(DbSeek(cPerg+Space(4)+'01'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := SD3->D3_DOC//DTOS(M->DDATALANC)
			SX1->(MsUnlock())
		Endif
		If SX1->(DbSeek(cPerg+Space(4)+'02'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  SD3->D3_DOC
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'03'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  SD3->D3_FILIAL
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'04'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  SD3->D3_FILIAL
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'05'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  SD3->D3_NUMSERI
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'06'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  SD3->D3_NUMSERI
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'07'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  DTOS(SD3->D3_EMISSAO)
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'08'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  DTOS(SD3->D3_EMISSAO)
			SX1->(MsUnlock())
		ENDif
		If SX1->(DbSeek(cPerg+Space(4)+'09'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  "2"
			SX1->(MsUnlock())
		ENDif
		SX1->(dbclosearea())

	endif
	SD3->(dbclosearea())

	SD3->(dbSetOrder(2))
	SD3->(dbSeek(xFilial()+cDoc))

	If( LEN(aCpoUs) > 0 )
		While SD3->D3_FILIAL+SD3->D3_DOC == xFilial()+cDoc
			RecLock("SD3",.F.)
			Replace D3_UDESCCU With UPPER(aCpoUs[1][2])
			If( LEN(aCpoUs) > 1 )
				Replace D3_UOBSERV With UPPER(aCpoUs[2][2])
			EndIf
			MsUnLock()
			dbSkip()
		EndDo
	EndIf
	SD3->(dbclosearea())

	U_MOVINT()

	Pergunte("MTA240",.F.)

	RestArea(SD3Area)
	RestArea(oldArea)
return
