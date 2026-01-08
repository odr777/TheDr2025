/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SumaImp³ Autor ³ MS                   ³Fecha ³ 10/06/07    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripc. ³ suma todos valimp 							    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Llamado por asientos standard 640                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION ORIGINAL             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ FECHA  ³ BOPS ³  MOTIVO DE LA ALTERACION               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³XXXXXX³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function SumaImp(cTabla,cCampo)
// cTabla parametro que indica sobre que tabla estoy   ejemplo: F2
// cCampo campo de la tabla a sumar EJEMPLO:  VALIMP   

local nSuma := 0.00
local nTXM := 1
Local I:=0
LOCAL aNumeros := {"1","2","3","4","5","6","A","B","C","D","E","F","G","H","I","J","K",;
				   "L","M","N","O","P","Q","T","V","W","X","Y"}
				  

For I=1 to len(aNumeros)
    cSuma := "S"+cTabla+"->"+cTabla+"_"+cCampo+aNumeros[i]
    nSuma := nSuma + &cSuma * nTXM
next

Return nSuma

User Function SUMVALIMP(cTabla)
Local nTotal := 0   
If cTabla == "SF1"
	nTotal := SF1->F1_VALIMP1 + SF1->F1_VALIMP2 + SF1->F1_VALIMP3 + SF1->F1_VALIMP4 + SF1->F1_VALIMP5 + SF1->F1_VALIMP6 + SF1->F1_VALIMP7 + SF1->F1_VALIMP8 + SF1->F1_VALIMP9
ElseIF cTabla == "SF2"
	nTotal := SF2->F2_VALIMP1 + SF2->F2_VALIMP2 + SF2->F2_VALIMP3 + SF2->F2_VALIMP4 + SF2->F2_VALIMP5 + SF2->F2_VALIMP6 + SF2->F2_VALIMP7 + SF2->F2_VALIMP8 + SF2->F2_VALIMP9
ElseIf cTabla == "SD1"
	nTotal := SD1->D1_VALIMP1 + SD1->D1_VALIMP2 + SD1->D1_VALIMP3 + SD1->D1_VALIMP4 + SD1->D1_VALIMP5 + SD1->D1_VALIMP6 + SD1->D1_VALIMP7 + SD1->D1_VALIMP8 + SD1->D1_VALIMP9
ElseIF cTabla == "SD2"
	nTotal := SD2->D2_VALIMP1 + SD2->D2_VALIMP2 + SD2->D2_VALIMP3 + SD2->D2_VALIMP4 + SD2->D2_VALIMP5 + SD2->D2_VALIMP6 + SD2->D2_VALIMP7 + SD2->D2_VALIMP8 + SD2->D2_VALIMP9
Endif                                                                                                                                                                        

Return (nTotal)