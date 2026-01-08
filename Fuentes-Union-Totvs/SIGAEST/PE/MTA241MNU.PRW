#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA241MNU ºAutor  ³ERICK ETCHEVERRY    ºFecha ³  07/09/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Para adicionar el boton 'Imprimir' en la              º±±
±±º          ³ rutina de Internos (Mod II)                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION                                             	      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA241MNU

	//Aadd(aRotina,{'Imprimir',"U_RMovInternos()", 0 , 5,0,Nil})	//"Imprimir"
	AADD(aRotina, {"Imprimir","U_impmovd3()" , 0 , 5})

Return

user function impmovd3
	cPerg:="MOVINT"
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := SD3->D3_DOC//DTOS(M->DDATALANC)
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SD3->D3_DOC
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SD3->D3_FILIAL
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SD3->D3_FILIAL
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SD3->D3_NUMSERI
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'06'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SD3->D3_NUMSERI
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'07'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(SD3->D3_EMISSAO)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'08'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(SD3->D3_EMISSAO)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'09'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  "2"
		SX1->(MsUnlock())
	END
	
	u_MOVINT()
	//llama reporte
return