#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPUNTO DE ENTRADA  ³ PMA600COL ºAutor  ³Nahim Terrazas  ºFecha 5/12/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ciabol                                                     º±±
±± Carga el nombre de la tarea a los items del pedido de venta			  ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function PMA600COL()
	aArea := GetArea()
	aCols:= PARAMIXB[1] // SC6 SON LOS VALORES
	aHead:= PARAMIXB[2]	// SC6 SON LOS METADATOS
	aFat:= PARAMIXB[3] // Información de las tareas
	//	cvalor =
	//	a.	AF9_CCUSTO
	//	b.	AF9_ITEMCC
	//	c.	AF9_CLVL
	//	aCols[3] = '- '+ cvaltochar(aFat[2]) + cvalor
	aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_DESCRI"})] =  '- '+ cvaltochar(aFat[2]) +  Posicione("AF9",5,xFilial("AF9")+cvaltochar(aFat[1]) + cvaltochar(aFat[2]),"AF9_DESCRI") // Descripción de la tarea
	aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_CCUSTO"})] = AF9->AF9_CCUSTO // centro de costo
	aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_UCLVL"})] = AF9->AF9_CLVL // clase de valor
	aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_UITEM"})] = AF9->AF9_ITEMCC // item contable
	//	I3_FILIAL+I3_CUSTO+I3_CONTA+I3_MOEDA
	dbSelectArea("CTD")
	CTD->(dbSetOrder(1))
	If CTD->(dbseek(xFilial("CTD") + alltrim(AF9->AF9_ITEMCC)))
		aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_UDESC1"})] = CTD->CTD_DESC01// item contable
	else
		aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_UDESC1"})] = "CTD_DESC01"// item contable
	ENDIF
	//	aCols[Ascan(aHead,{|x| Alltrim(x[2])=="C6_UDESC1"})] = GetAdvFVal("CTD","CTD_DESC1",xFilial("CTD")+alltrim(AF9->AF9_ITEMCC),1,"No Enc.")// item contable
	RestArea(aArea)
return aCols

