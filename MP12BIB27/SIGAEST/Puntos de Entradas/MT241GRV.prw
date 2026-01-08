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
	Local oldArea := GetArea() //-- guarda a area
	Local cDoc := PARAMIXB[1]
	Local aCpoUs := PARAMIXB[2]
	Local SD3Area := SD3->(GetArea())

	if Funname() $ "MATA241"
		
		SD3->(dbSetOrder(2))
		SD3->(dbSeek(xFilial()+cDoc))

		While SD3->D3_FILIAL+SD3->D3_DOC == xFilial()+cDoc
			//alert("MT241GRV")
			RecLock("SD3",.F.)
			Replace D3_UOBSERV With UPPER(aCpoUs[1][2])
			MsUnLock()
			dbSkip()
		EndDo

		SD3->(dbclosearea())

		SD3->(dbSetOrder(2))
		SD3->(dbSeek(xFilial()+cDoc))

		U_MOVMULE()

		SD3->(dbclosearea())

	endif

	RestArea(SD3Area)
	RestArea(oldArea)
return
