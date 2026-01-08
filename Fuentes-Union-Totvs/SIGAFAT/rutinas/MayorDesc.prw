#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ MayorDescuento ³ Autor ³ Widen Gonzales					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Coloca el Mayor descuento entre Cliente y Regla de descuento³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MAYORDESC(cDesc1,cDesc4,cPdescab)
	Local aArea    := GetArea()
	//Local cResp:=""
	//Local cdif:=""
	Local cContenido:=&(ReadVar())
	//Alert(cDesc1)
	//Alert(cDesc4)
	//DbSelectArea(cNextAlias) // seleccionar area Area
	//cCond := POSICIONE("SC5",1,XFILIAL("SC5")+cClient+cLoja,"A1_COND")	
	if cDesc1 >= cDesc4
		//Alert("OK")
			//cResp=cDesc1
			//cdif=cDesc1-cDesc4
			M->C5_DESC1:=cDesc1-cDesc4
			//C5_DESC4=0
			/*RecLock("SC5",.F.)
				SC5->C5_DESC4 := 0 // Fecha Ultima Baja en SCP
			MsUnLock()*/
	else
			M->C5_DESC1:=0
			//C5_DESC1=0
			/*RecLock("SC5",.F.)
				SC5->C5_DESC1 := 0 // Fecha Ultima Baja en SCP
			MsUnLock()*/
	endif	
	
	
	/*(cNextAlias)->( DbGoTop() )
	nRespuesta := (cNextAlias)->TOTALMDESC
	(cNextAlias)->( dbCloseArea() )
	RestArea(aArea)
*/
RETURN cContenido//cResp
