#Include "Protheus.ch"
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF087ACOB บAutor  ณEDUAR ANDIA         บ Data ณ  03/04/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE utilizado na valida็ใo do preenchimento do campo recibo บฑฑ
ฑฑบ          ณ Para o preenchimento automแtico do c๓digo do cobrador	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia /Bel้n				                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F087ACOB
Local aArea		:= GetArea()
Local cCobr		:= ""

If !Empty(cRecibo)
	If Len(AllTrim(cRecibo))< TamSX3("EL_RECIBO")[1]
		Aviso("F087ACOB","El Tama๑o del campo debe ser de " + AllTrim(Str(TamSX3("EL_RECIBO")[1]))+ " caracteres",{"OK"})
	Endif
Endif

If !Empty(cSerie)
	DbSelectArea("SEY")
	SEY->(DbSetOrder(4))
	If SEY->(DbSeek(xFilial("SEY")+cSerie))
		While SEY->(!Eof()) .AND. SEY->EY_FILIAL == xFilial("SEY") .AND. SEY->EY_SERIE == cSerie
			If SEY->EY_STATUS=="1"
				cCobr := SEY->EY_COBRAD
				//Aviso("F087ACOB","cCobr   : " +AllTrim(cCobr)	 ,{"Ok"},,,,,.T.)
				Exit
			Endif
			SEY->(DbSkip())
		EndDo
	Endif
Endif

RestArea(aArea)
Return(cCobr)
