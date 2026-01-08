#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ Punto de entrada ³ Autor ³ Widen Gonzales					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³coloca el deposito de la cabecera en los items 
	cuando hay bonificacion - Presupuesto								
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA415END

Local nOpcA := ParamIxb[1]
Local cBonusTes  := SuperGetMv("MV_BONUSTS")
//Local cTesBonus := &(GetMv("MV_BONUSTS"))
//Alert(cBonusTes)
//Alert("'"+cBonusTes+"'") //Indica los espacios
//Alert("EK_NUM: "+SEK->EK_NUM)

//Alert("CJ_NUM: "+SCJ->CJ_NUM) //ok

//Alert("TMP1->CK_NUM: "+TMP1->CK_NUM)
//Alert("TMP2->CK_NUM: "+TMP2->CK_NUM)
//|Recorrido de una Tabla			     	     		|
//+---------------------------------------------------------------------+

//alert(nOpcA)

If Inclui .OR. Altera // Al Incluir o Modificar

If nOpcA==1  //Grabar/Confirmar
	DbSelectArea("SCK")
	SCK->(DbSetOrder(1)) //DbSetOrder INDICE 
	If SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM))
		While SCK->(!Eof()) .AND. SCK->CK_NUM == SCJ->CJ_NUM
			//Alert("CK_TES: "+SCK->CK_TES)
			IF SCK->CK_TES==cBonusTes
				//SCK->CK_LOCAL=SCJ->CJ_LOCAL
				RecLock("SCK",.F.)
				SCK->CK_LOCAL := SCJ->CJ_ULOCAL
				MsUnLock()							
			ENDIF 
			SCK->(DbSkip())		
		EndDo
	Endif
Endif

Endif

Return

