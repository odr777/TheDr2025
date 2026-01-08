#Include "Protheus.ch"
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF087ACOB บAutor  ณEDUAR ANDIA         บ Data ณ  08/07/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE utilizado na valida็ใo do preenchimento do campo recibo บฑฑ
ฑฑบ          ณ Para o preenchimento automแtico do c๓digo do cobrador	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia /Uni๓n Agronegocios S.A.	                          บฑฑ
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

If cSerie == GETMV("MV_XCOMPEN")
	Aviso("F087ACOB","La serie "+GETMV("MV_XCOMPEN")+" es para compensaci๓n, si desea realizar un cobro seleccione otra serie ",{"OK"})
EndIf 


/*
If !(RetCodUsr()=="000000")	//Dif. de Admin
	oSerie:Disable()
Endif
*/

//If !Empty(cSerie)
	DbSelectArea("SAQ")
	If SAQ->(FieldPos("AQ_UCODUSR"))>0
		
		SAQ->(DbSetOrder(4))
		If SAQ->(DbSeek(xFilial("SAQ")+RetCodUsr()))
			While SAQ->(!Eof()) .AND. SAQ->AQ_FILIAL == xFilial("SAQ") .AND. SAQ->AQ_UCODUSR == RetCodUsr()
				cCobr := SAQ->AQ_COD
				//Aviso("F087ACOB","cCobr   : " +AllTrim(cCobr)	 ,{"Ok"},,,,,.T.)
				Exit
				SAQ->(DbSkip())
			EndDo
		Endif
	Endif
//Endif

RestArea(aArea)
Return(cCobr)



