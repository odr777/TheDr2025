#include "Protheus.ch"
#include "topconn.ch"
#include "FISA815.ch"
#include "XMLXFUN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FONT.CH"
#Include "RPTDEF.CH"


#DEFINE _SERREC     1
#DEFINE _NORECIBO   2
#DEFINE _FECHA      3
#DEFINE _RECIBIDO   4
#DEFINE _SALDO      5
#DEFINE _CLIENTE    6
#DEFINE _LOJA       7
#DEFINE _TASA       8

#DEFINE _TIPO       1
#DEFINE _NUMERO     2
#DEFINE _PREFIXO    3
#DEFINE _PARCELA    4
#DEFINE _VALOR      5
#DEFINE _MOEDA      6
#DEFINE _EMISSAO    7

User Function F998IMPREC()
	Local aRecibos := PARAMIXB[1]
	Local cNomTmp	:= OemToAnsi(STR0009) + Alltrim(aRecibos[6]) + Alltrim(aRecibos[5])              //"ReciboPago"
	Local cDir      := &(SuperGetmv( "MV_CFDRECP" , .F. , "GetSrvProfString('startpath','')+'\cfd\recpagos\'" ))

	U_CFinI204(Alltrim(aRecibos[5]),Alltrim(aRecibos[6]))  ///NUMERO RECIBO

	ImpPDF(aRecibos[1], Replace(aRecibos[1], ".xml", ".pdf"), cNomTmp, cDir, )

Return

Static Function ImpPDF(cXmlNom, cPdfNom, cNomTmp, cDir ,jData)
	Local cCaminhoXML	:= ""
	Local cPath 		:= Replace( cDir, "\\", "\" )
	Local oXML			:= NIL
	Local oPrinter
	Local cError		:= ""
	Local cDetalle	    := ""
	local cXml := ""
	Local cRutaSmr      := IIF(Empty(SuperGetmv( "MV_CFDSMAR" , .F., "")), GetClientDir(), &(SuperGetmv( "MV_CFDSMAR" , .F. , "GetClientDir()" )))

	Default jData := JsonObject():New()

	cCaminhoXML := Replace(cDir + cXmlNom, "\\", "\")

	IF ISSRVUNIX()
		cCaminhoXML := Replace( cCaminhoXML, "\", "/" )
		cPath := Replace( cPath, "\", "/" )
	EndIf

	oPrinter := FWMsPrinter():New(AllTrim(cPdfNom), 6, .F.,cPath , .T.)

	If FILE(cCaminhoXML)
		cXml := XmlRead(cCaminhoXML)
		cXML := STRTRAN(cXML,'<?xml version="1.0" encoding="utf-8"?>' ,'<?xml version="1.0"?>')
		oXml := xmlParser(encodeUTF16(cXML), "", @cDetalle, @cError)
	EndIf

	If oXML == NIL
		Return ""
	EndIf

	oPrinter:setDevice(IMP_PDF)
	oPrinter:lServer := .T.
	oPrinter:cPathPDF := cRutaSmr

	oPrinter:StartPage()
	ImprRec(oPrinter, oXml)
	oPrinter:EndPage()

	oPrinter:SetViewPDF(.F.)

	IF jData['origin'] ==  "FINA998"
		IF !FILE(cRutaSmr + cPdfNom)
			oPrinter:Print()
			COPY FILE (cRutaSmr + cPdfNom ) TO (cPath + cPdfNom )
		Else
			IF jData['imppdf'] == .T. .and. jData['sendemail'] == .F.
				oPrinter:Print()
				COPY FILE (cRutaSmr + cPdfNom ) TO (cPath + cPdfNom )
			ENDIF
		ENDIF
	ELSE
		oPrinter:Print()
		COPY FILE (cRutaSmr + cPdfNom ) TO (cPath + cPdfNom )
	ENDIF

	FreeObj(oPrinter)
	oPrinter := Nil

Return

/*/{Protheus.doc} ImprRec
Metodo responsable por realizar la llamada de funciones de impresión
@type 		Method

@param 		oPrinter	,object		,Objeto para la impresión
@param 		oXML 	    ,object	    ,Objeto xml con la información del recibo

@author 	raul.medina
@version	12.1.27 / Superior
@since		04/06/2021 
/*/
Static Function ImprRec(oPrinter, oXml)
	Local nLine := 0

	ImpEnc(oPrinter,oXml,@nLine)
	fLanca(oPrinter,oXML, @nLine)
	fRodape(oPrinter,oXML, @nLine)

Return

/*/{Protheus.doc} ImpEnc
Metodo responsable por realizar la impresión del encabezado del archivo.
@type 		Method

@param 		oPrinter	,object		,Objeto para la impresión
@param 		oXML 	    ,object 	,Objeto xml con la información del recibo
@param 		nLine	 	,numerico	,Linea de impresión

@author 	raul.medina
@version	12.1.27 / Superior
@since		04/06/2021 
/*/
Static Function ImpEnc(oPrinter, oXml, nLine)
	Local cFileLogo	:= ""
	Local cSerie	:= ""

	Local oFont3 := TFont():New( "ARIAL", , 12, .T., .T.)
	Local oFont8 := TFont():New("Arial",,15,.T., .T.)

	oPrinter:Line(5, 5, 790, 5, , "-2") //Linea lateral izquierda
	oPrinter:Line(5, 585, 790, 585, , "-4") //Linea lateral derecha
	oPrinter:Line(5, 5, 5, 585, , "-4")//Linea horizontal de marco

	nLine += 40
	oPrinter:Say(nLine, 195, OemToAnsi(STR0025), oFont8) //Recibo Electrónico de Pago

	nLine -= 20
	cFileLogo := fCarLogo()
	If File(cFileLogo)
		oPrinter:SayBitmap(nLine, 15, cFileLogo, 50, 50)
	Endif

	nLine += 30
	oPrinter:Say(nLine, 370, OemToAnsi(STR0026), oFont3) //Recibo no.:

	If XMLChildEX(oXml:_COMPROBANTE, "_SERIE") <> Nil
		cSerie := AllTrim(oXml:_COMPROBANTE:_SERIE:TEXT) + " "
	EndIf

	oPrinter:Say(nLine, 480, cSerie + oXml:_COMPROBANTE:_FOLIO:TEXT, oFont3)

	nLine += 12
	oPrinter:Say(nLine, 370, OemToAnsi(STR0076), oFont3) //Tipo de Comprobante
	oPrinter:Say(nLine, 480, OemToAnsi(STR0051), oFont3) //"Pago "
	nLine += 20
	oPrinter:Say(nLine, 370, OemToAnsi("Lugar, Fecha y hora de emisión"), oFont3) //Lugar, Fecha y hora de emisión
	oPrinter:Say(nLine, 480, &("oXml:_COMPROBANTE:_FECHA:TEXT"), oFont3) //oXml:_COMPROBANTE:_FECHA:TEXT
	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")//Linea horizontal de marco
Return Nil


/*/{Protheus.doc} fLanca
Metodo responsable por realizar la impresión el cuerpo del archivo.
@type 		Method

@param 		oPrinter	,object		,Objeto para la impresión
@param 		oXML 	    ,object 	,Objeto xml con la información del recibo
@param 		nLine	 	,numerico	,Linea de impresión

@author 	raul.medina
@version	12.1.27 / Superior
@since		04/06/2021 
/*/
Static Function fLanca(oPrinter,oXML, nLine)
	Local nI			:= 0
	Local oFont         := TFont():New( "ARIAL", , 07, .T., .F.)
	Local oFont3        := TFont():New( "ARIAL", , 12, .T., .T.)
	Local oFont4        := TFont():New( "ARIAL", , 07, .T., .T.)
	Local oXmlDocs      := Nil
	Local oXmlpagos     := Nil

	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")
	oPrinter:Say(nLine -= 5, 10, OemToAnsi(STR0028), oFont3)//Datos de identificación del emisor

	nLine += 15
	oPrinter:Say(nLine, 10, OemToAnsi(STR0029), oFont4) //Nombre o razon social
	oPrinter:Say(nLine, 120, oXml:_COMPROBANTE:_EMISOR:_NOMBRE:TEXT, oFont)

	oPrinter:Say(nLine, 350, OemToAnsi("Identificación"), oFont4)//"Identificación"
	oPrinter:Say(nLine, 450, oXml:_COMPROBANTE:_EMISOR:_ID:TEXT, oFont)

	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")

	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")

	oPrinter:Say(nLine -= 5, 10, OemToAnsi(STR0032) ,oFont3)//Datos de identificacion del receptor

	nLine += 15
	oPrinter:Say(nLine, 10, OemToAnsi(STR0029), oFont4)//Nombre o razon social
	oPrinter:SAY(nLine, 120, oXml:_COMPROBANTE:_RECEPTOR:_NOMBRE:TEXT, oFont)

	oPrinter:Say(nLine, 350, OemToAnsi("Identificación"), oFont4)//"Identificación"
	oPrinter:SAY(nLine, 450, oXml:_COMPROBANTE:_RECEPTOR:_ID:TEXT, oFont)

	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")


	//Documentos
	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")

	oPrinter:Say(nLine -= 5, 10, OemToAnsi("Documentos"), oFont3)//Documentos

	If XmlChildEx(oXml:_COMPROBANTE:_DOCUMENTOS, '_DOCUMENTO') <> Nil
		oXmlDocs := oXml:_COMPROBANTE:_DOCUMENTOS:_DOCUMENTO
	EndIf

	If ValType(oXmlDocs) == "O"
		ImpcDocs(oPrinter, oXmlDocs, @nLine)
	ElseIf ValType(oXmlDocs) == "A"
		For nI := 1 To Len(oXmlDocs)
			newPage(oPrinter,@nLine)
			ImpcDocs(oPrinter, oXmlDocs[nI], @nLine)
		Next nI
	EndIf

	newPage(oPrinter,@nLine)

	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")

	//Pagos
	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")

	oPrinter:Say(nLine -= 5, 10, OemToAnsi(STR0044), oFont3)//Pagos

	If XmlChildEx(oXml:_COMPROBANTE:_PAGOS, '_PAGO') <> Nil
		oXmlpagos := oXml:_COMPROBANTE:_PAGOS:_PAGO
	EndIf

	If ValType(oXmlpagos) == "O"
		ImpcDocs(oPrinter, oXmlpagos, @nLine, .T.)
	ElseIf ValType(oXmlpagos) == "A"
		For nI := 1 To Len(oXmlpagos)
			newPage(oPrinter,@nLine)
			ImpcDocs(oPrinter, oXmlpagos[nI], @nLine, .T.)
		Next nI
	EndIf

	nLine += 20
	oPrinter:Line(nLine, 5, nLine, 585, , "-4")

Return Nil

/*/{Protheus.doc} ImpcDocs
Metodo responsable por realizar la impresión de documentos y pagos.
@type 		Method

@param 		oPrinter	,object		,Objeto para la impresión
@param 		oXML 	    ,object 	,Objeto xml con la información del recibo
@param 		nLine	 	,numerico	,Linea de impresión

@author 	raul.medina
@version	12.1.27 / Superior
@since		04/06/2021 
/*/
Static Function ImpcDocs(oPrinter, oXmlDoc, nLine, lPago)
	Local oFont         := TFont():New( "ARIAL", , 07, .T., .F.)
	Local oFont4        := TFont():New( "ARIAL", , 07, .T., .T.)
	Local cTipoPago     := ""

	Default oXmlDoc := Nil
	Default lPago   := .F.

	nLine += 15
	If lPago
		oPrinter:Say(nLine, 10, OemToAnsi(STR0051), oFont4)//Pago
	Else
		oPrinter:Say(nLine, 10, OemToAnsi(STR0048), oFont4)//Documento
	EndIf

	If XmlChildEx(oXmlDoc, '_NUMERO') <> Nil
		oPrinter:SAY(nLine, 90, &("oXmlDoc:_NUMERO:TEXT"), oFont)
	EndIf

	nLine += 15
	If lPago
		oPrinter:Say(nLine, 10, OemToAnsi(STR0054), oFont4)//"Forma de pago"
	Else
		oPrinter:Say(nLine, 10, OemToAnsi("Tipo documento"), oFont4)//Tipo documento
	EndIf
	If XmlChildEx(oXmlDoc, '_TIPO') <> Nil
		cTipoPago := &("oXmlDoc:_TIPO:TEXT")
		If  cTipoPago $ "CH"
			cTipoPago := OemToAnsi(STR0045)
		ElseIf cTipoPago $ "EF"
			cTipoPago := OemToAnsi(STR0046)
		ElseIf cTipoPago $ "TF"
			cTipoPago := OemToAnsi(STR0047)
		EndIf
		oPrinter:SAY(nLine, 80, cTipoPago, oFont)
	EndIf

	oPrinter:Say(nLine, 110 , OemToAnsi(STR0061), oFont4)//Serie
	If XmlChildEx(oXmlDoc, '_PREFIJO') <> Nil
		oPrinter:SAY(nLine, 130, &("oXmlDoc:_PREFIJO:TEXT"), oFont)
	EndIf

	oPrinter:Say(nLine, 160, OemToAnsi(STR0063), oFont4)//Parcialidad
	If XmlChildEx(oXmlDoc, '_PARCELA') <> Nil
		oPrinter:SAY(nLine, 210, &("oXmlDoc:_PARCELA:TEXT"), oFont)
	EndIf

	oPrinter:Say(nLine, 230, OemToAnsi("Valor"), oFont4)//Valor
	If XmlChildEx(oXmlDoc, '_VALOR') <> Nil
		oPrinter:SAY(nLine, 260, &("oXmlDoc:_VALOR:TEXT"), oFont)
	EndIf

	oPrinter:Say(nLine, 320, OemToAnsi(STR0055), oFont4)//Moneda
	If XmlChildEx(oXmlDoc, '_MONEDA') <> Nil
		oPrinter:SAY(nLine, 370, &("oXmlDoc:_MONEDA:TEXT"), oFont)
	EndIf

	If XmlChildEx(oXmlDoc, '_TASA') <> Nil
		oPrinter:Say(nLine, 400, OemToAnsi(STR0056), oFont4)//Moneda
		oPrinter:SAY(nLine, 450, &("oXmlDoc:_TASA:TEXT"), oFont)
	EndIf

	oPrinter:Say(nLine, 490, OemToAnsi("Emisión"), oFont4)//"Emisión"
	If XmlChildEx(oXmlDoc, '_EMISION') <> Nil
		oPrinter:SAY(nLine, 520, &("oXmlDoc:_EMISION:TEXT"), oFont) //520
	EndIf

Return Nil

/*/{Protheus.doc} fRodape
Metodo responsable por realizar el pie de pagina
@type 		Method

@param 		oPrinter	,object		,Objeto para la impresión
@param 		oXML 	    ,object 	,Objeto xml con la información del recibo
@param 		nLine	 	,numerico	,Linea de impresión

@author 	raul.medina
@version	12.1.27 / Superior
@since		04/06/2021 
/*/
Static Function fRodape(oPrinter, oXML, nLine)
	Local oFont     := TFont():New( "ARIAL", , 07, .T., .F.)
	Local oFont4    := TFont():New( "ARIAL", , 07, .T., .T.)

	nLine += 15

	oPrinter:Say(nLine, 380, OemToAnsi("Pagos"), oFont4) //Pagos
	oPrinter:Say(nLine, 520, &("oXml:_COMPROBANTE:_RECIBIDO:TEXT"), oFont)

Return Nil

/*/{Protheus.doc} fCarLogo
Obtiene la imagen para el logo del la impresión
@type 		Method

@author 	raul.medina
@version	12.1.27 / Superior
@since		04/06/2021 
/*/
Static Function fCarLogo()
	Local cStartPath    := GetSrvProfString("Startpath", "")
	Local cLogo         := ""

	cLogo	:= cStartPath + "\LGRL"+ SM0->M0_CODIGO + SM0->M0_CODFIL + ".BMP" // Empresa+Filial
	//-- Logotipo da Empresa
	If !File( cLogo )
		cLogo := cStartPath + "\LGRL" + SM0->M0_CODIGO + ".BMP" // Empresa
	Endif
Return cLogo

//En esta entrega no es utilizada esta función,
Static Function borraPdf(cNumRec)
	Local cRutaSmr 	    := &(SuperGetmv( "MV_CFDSMAR" , .F. , "GetClientDir()" ))
	Local cNomXml		:= "recibopago" + cNumRec + ".pdf"
	If File(cRutaSmr + cNomXml)
		Ferase(cRutaSmr + cNomXml)
	EndIf
Return

Static Function XmlRead(cFile)
	Local nHandle	:= 0
	Local nLast		:= 0
	Local cXml		:= ""

	nHandle := FT_FUse(cFile)

	nLast := FT_FLastRec()
	FT_FGoTop()

	While !FT_FEOF()
		cXml  += FT_FReadLn()
		// Pula para próxima linha
		FT_FSKIP()
	End
	// Fecha o Arquivo
	FT_FUSE()

Return cXml

/*/{Protheus.doc} newPage
Comprueba el espacio restante en la pagina y crea el fin
de pagina y el inicio de la siguiente.
@type 		Method

@author 	José González 
@version	12.1.27 / Superior
@since		17/03/2023
/*/
static Function newPage(oPrinter,nLine)
	Local lNewPage := .F.
	Default nLine := 1

	If nLine >= 760
		lNewPage := .T.
	EndIf

	If lNewPage
		oPrinter:Line(790,5,790,585,,"-4")
		nLine := 15
		oPrinter:EndPage()
		oPrinter:StartPage()
		oPrinter:Line(5,5,790,5,,"-4") //Linea lateral izquierda
		oPrinter:Line(5,585,790,585,,"-4") //Linea lateral derecha
		oPrinter:Line(5,5,5,585,,"-4")//Linea horizontal de marco
	EndIf

Return
