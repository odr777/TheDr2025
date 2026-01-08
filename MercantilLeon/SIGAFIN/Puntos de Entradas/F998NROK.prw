#INCLUDE "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F998NROK ºAutor  ³Erick Etcheverry    º Data ³  24/07/24   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada que permite agregar                       º±±
±±º    validaciones al recibo antes del guardado				    	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION F998NROK()
	Local jEncabezado   := Paramixb[3] //Json que contiene los datos que conforman el encabezado del recibo
	Local lRet     := .T. As Logical
	Local aRet     := {}  As Array
    Local aArea    := GetArea()

	cxRecibo = ALLTRIM(jEncabezado['recibo'])
    cxRecibo = cxRecibo+Space(TamSX3("EL_RECIBO")[1]-Len(cxRecibo))
	cxSerie = ALLTRIM(jEncabezado['serie'])
    cxSerie = cxSerie+Space(TamSX3("EL_SERIE")[1]-Len(cxSerie))

	DbSelectArea("SEL")
	SEL->(DbSetorder(8)) //EL_FILIAL+EL_SERIE+EL_RECIBO+EL_TIPODOC+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO
	If empty(cxSerie) .or. empty(cxRecibo)
		Help( ,, "SELNUMEXIS" ,"F998NROK","Informe numero recibo o serie" ,1, 0 )
		lRet := .F.
		cMensaje := "No se permite guardar un recibo sin serie o recibo"
		AADD(aRet,{lRet,cMensaje})
	elseif SEL->(dbSeek(xFilial("SEL") + cxSerie + cxRecibo)) //Space(10-Len(cNatureza))
        Help( ,, "SELNUMEXIS" ,"F998NROK","El Número del Recibo ya Existe" ,1, 0 )
		lRet := .F.
		cMensaje := "No se permite guardar un recibo duplicado"
		AADD(aRet,{lRet,cMensaje})
	else///TODO OK CONTINUA
		lRet := .T.
		cMensaje := " "
		AADD(aRet,{lRet,cMensaje})
	EndIf

    RestArea(aArea)	
RETURN aRet
