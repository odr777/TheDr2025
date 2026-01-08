#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"
#Include "PROTHEUS.CH"
//Alinhamentos
#Define PAD_LEFT	0
#Define PAD_RIGHT	1
#Define PAD_CENTER	2
#Define PAD_JUSTIFY	3

//Colunas
#Define COL_TEXT		0040
#Define COL_CANTIDAD	0040
#Define COL_DESCR		0100
#Define COL_FACT		0380

#Define COL_PROY		0370

/**
* @author: Denar Terrazas Parada
* @since: 18/08/2022
* @description:	Impresión de contrato para facturas al crédito.
*				Utilizado en el punto de entrada MT462MNU.
*				Específico Markas.
* @parameters:	cParam1-> F2_FILIAL
*				cParam2-> F2_DOC
*				cParam3-> F2_SERIE
*				cParam4-> F2_CLIENTE
*				cParam5-> F2_LOJA
*				cParam6-> F2_COND
*/
User Function ContrCre(cParam1, cParam2, cParam3, cParam4, cParam5, cParam6)
	Local aArea			:= getArea()
	Local cLoadingMsg 	:= "Imprimiendo, espere..."
	Local wnrel		 	:= "Impresion de contrato de venta a crédito"
	Private oPrint
	Private nomeProg 	:= "ContrCre"
	Private lEnd		:= .F.
	Private lFirstPage	:= .T.
	Private cNomeFont	:= "Arial"
	Private oFontDet	:= TFont():New(cNomeFont,12,12,,.F.,,,,.T.,.F.)
	Private oFontNDet	:= TFont():New(cNomeFont,12,12,,.T.,,,,.T.,.F.)
	Private oFontRod	:= TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private nReg 		:= 0
	Private cBranch		:= cParam1
	Private cDocument	:= cParam2
	Private cSerie		:= cParam3
	Private cClient		:= cParam4
	Private cStore		:= cParam5
	Private cPymtCond	:= cParam6//Condición de pago

	cE4_COND:= GetAdvFVal("SE4", "E4_COND", xFilial("SE4") + cPymtCond , 1, "")//E4_FILIAL+E4_CODIGO
	If(Trim(cE4_COND) $ '0|00')//Al contado
		FWAlertWarning("Esta opción sólo está disponible para facturas al crédito.", "TOTVS")
		RestArea(aArea)
		Return
	EndIf

	Processa({|lEnd| MOVD3CONF()}, cLoadingMsg)
	Processa({|lEnd| fImpPres(@lEnd,wnRel,nReg)}, cLoadingMsg)

	RestArea(aArea)

Return

Static Function MOVD3CONF()
	//Local cFilename := 'ContrCre'

	cCaminho := GetTempPath()
	cArquivo := "Contrato_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)//Carta
	oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,nReg)
	Local aArea		:= GetArea()
	Local nX		:= 1
	Local cWarrDoc	:= ""
	Local cWarrName	:= ""

	Private nHorzSize := 510//oPrint:nHorzSize()
	Private nLinAtu := 050
	Private nTamLin := 012
	Private nLinFin := 750
	Private nColIni := 010
	Private nColFin := 580
	Private dDataGer:= Date()
	Private cHoraGer:= Time()
	Private nPagAtu	:= 1
	Private cNomeUsr:= UsrRetName(RetCodUsr())

	oPrint:StartPage()

	oPrint:SayAlign(nLinAtu, COL_TEXT, "MARKAS S.R.L.", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "HAUSCENTER", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinAtu += nTamLin
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "DOCUMENTO PRIVADO", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "Conste por el presente contrato de VENTA A CREDITO Y RECONOCIMIENTO DE DEUDA de:", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinAtu += nTamLin
	nLinAtu += nTamLin

	oPrint:Box( nLinAtu, COL_CANTIDAD, nLinAtu + nTamLin + 3, COL_DESCR)
	oPrint:Box( nLinAtu, COL_DESCR, nLinAtu + nTamLin + 3, COL_FACT)
	oPrint:Box( nLinAtu, COL_FACT, nLinAtu + nTamLin + 3, nHorzSize + 40)

	oPrint:SayAlign(nLinAtu, COL_CANTIDAD + 5, "Cantidad", oFontNDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinAtu, COL_DESCR + 5, "Descripción", oFontNDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinAtu, COL_FACT + 5, "Factura", oFontNDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinAtu += nTamLin + 3

	/*
	DbSelectArea("SD2")
	SD2->( DbSetOrder(nOrder) )
	SD2->( DbSeek() )
	*/

	aDetail:= getInvoiceDetail()//Obtiene datos de la SD2

	for nX:= 1 to LEN(aDetail)

		verifyNewLine(nTamLin + 3)

		oPrint:Box( nLinAtu, COL_CANTIDAD, nLinAtu + nTamLin + 3, COL_DESCR)
		oPrint:Box( nLinAtu, COL_DESCR, nLinAtu + nTamLin + 3, COL_FACT)
		oPrint:Box( nLinAtu, COL_FACT, nLinAtu + nTamLin + 3, nHorzSize + 40)

		oPrint:SayAlign(nLinAtu, COL_CANTIDAD + 5, CValToChar(aDetail[nX][1]), oFontDet, COL_DESCR - COL_CANTIDAD, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_DESCR + 5, aDetail[nX][2], oFontDet, COL_FACT - COL_DESCR, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_FACT + 5, aDetail[nX][3], oFontDet, nHorzSize - COL_FACT, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinAtu += nTamLin + 3

	next nX

	nLinAtu += nTamLin

	//Se posiciona en el registro del cliente
	DbSelectArea("SA1")
	SA1->( DbSetOrder(1) )//A1_FILIAL+A1_COD+A1_LOJA
	SA1->( DbSeek(xFilial("SA1") + cClient + cStore) )

	cTexto := "PRIMERA. (LAS PARTES). Son partes integrantes las siguientes:"
	//cTexto += CRLF
	cTexto2 := "1.- Son partes integrantes del presente contrato: 1.1. - MARKAS S.R.L. con nombre comercial HAUSCENTER empresa legalmente constituida, inscrita debidamente en FUNDEMPRESA con Matricula de Comercio Nro. 00340039, con NIT Nro. 312394023, legalmente representada por el señor ALVARO RODRIGO QUISBERT RAMOS, mayor de edad, boliviano, soltero, con C.I. Nro. 3349535 L.P., con domicilio en Avenida Cañoto Nro. 256, en virtud al Instrumento Público Nro. 1133/2019, de fecha 02 de agosto de 2019, otorgado ante la notaria de fe pública Nro. 62, a cargo del Dr. Hugo Mauricio Miranda Valenzuela, del distrito judicial de Santa Cruz de la Sierra, en adelante y para efectos del presente contrato se denominará EL VENDEDOR - ACREEDOR."
	//cTexto += CRLF
	cTexto3 := "1.2. Por otra parte " + TRIM(SA1->A1_NOME) + " mayor de edad, con CI: " + TRIM(SA1->A1_CGC) + " SC de profesión o actividad DEPENDIENTE, con domicilio en " + TRIM(SA1->A1_END) + " y para efectos del presente contrato se denominará COMPRADOR - DEUDOR(ES)”."
	//cTexto += CRLF

	//Garante
	cWarrantor	:= GetAdvFVal("SF2", "F2_XGARANT", cBranch + cDocument + cSerie + cClient + cStore , 1, 0)//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	if(!Empty(cWarrantor))
		cWarrDoc	:= GetAdvFVal("MAB", "MAB_XCGC", xFilial("MAB") + cWarrantor + cClient + cStore , 1, "")//MAB_FILIAL+MAB_CODIGO+MAB_CODCLI+MAB_LOJA
		cWarrName	:= GetAdvFVal("MAB", "MAB_NOME", xFilial("MAB") + cWarrantor + cClient + cStore , 1, "")//MAB_FILIAL+MAB_CODIGO+MAB_CODCLI+MAB_LOJA
		cWarrAddress:= GetAdvFVal("MAB", "MAB_XEND", xFilial("MAB") + cWarrantor + cClient + cStore , 1, "")//MAB_FILIAL+MAB_CODIGO+MAB_CODCLI+MAB_LOJA
		cTexto4 := "1.3. Por otra parte " + TRIM(cWarrName) + " con CI: " + TRIM(cWarrDoc) + " mayor de edad, con domicilio real en " + TRIM(cWarrAddress) + ", Ciudad: Santa Cruz en lo sucesivo denominado el CO-DEUDOR, FIADOR(A), GARANTE PERSONAL SOLIDARIO(A) MANCOMUNADO(A) E INDIVISIBLE."
		//cTexto += CRLF
	endIf

	cTexto5 := 'SEGUNDA. (OBJETO, PRECIO, FORMA DE PAGO). “HAUSCENTER”, declara ser dueño absoluto de los bienes detallados en el presente contrato, en adelante el (los) BIEN(ES).'


	nTotalInvoice	:= GetAdvFVal("SF2", "F2_VALBRUT", cBranch + cDocument + cSerie + cClient + cStore , 1, 0)//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	nCurrency		:= GetAdvFVal("SF2", "F2_MOEDA", cBranch + cDocument + cSerie + cClient + cStore , 1, 0)//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	cCurrSymbol		:= ALLTRIM(GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(nCurrency)))) //Simbolo de la moneda
	cCurrTitle		:= ALLTRIM(GETMV("MV_MOEDA"+ALLTRIM(CVALTOCHAR(nCurrency)))) //Título de la moneda
	cTextTotal		:= Trim(Extenso(nTotalInvoice,.F.,nCurrency))

	cTexto6 := '2.1. Al presente y por así convenir a sus intereses de su libre y espontánea voluntad, VENDEDOR - ACREEDOR transfiere en calidad de VENTA A CREDITO, de conformidad a lo establecido por el art. Art. 585 del Código Civil y art. 839 del Código de Comercio, el prenombrado BIEN, completamente nuevo y en perfecto estado de funcionamiento en favor de los COMPRADOR - DEUDOR(ES) por la suma total de ' + cCurrSymbol + ' ' + cValToChar(nTotalInvoice) + ' (' + cTextTotal + ' ' + cCurrTitle + '). 2.2. La transferencia en venta, estará sujeta al plan de pagos que se adjunta al contrato y que constituye parte inseparable del presente 2.3. Por la apertura del crédito los compradores consienten en realizar el pago de la primera cuota del capital del punto 2.1.- 2.3.1. Lugar de Pago y moneda. El pago correspondiente a los anticipos será pagado de forma mensual en el domicilio del VENDEDOR - ACREEDOR, en dólares americanos o bolivianos al tipo de cambio estipulado por VENDEDOR - ACREEDOR así mismo, se puede realizar transferencias interbancarias a cuentas de “HAUSCENTER” y/o deposito bancarios.'

	cTexto7 := 'TERCERA. (MORA). 3.1. Al solo incumplimiento de cada uno de los términos expresados en la cláusula anterior, falta de pago establecidas en el plan de pagos los COMPRADOR - DEUDOR(ES) se constituirán en mora, suma líquida y exigible, pudiendo EL ACREEDOR inicial acciones legales, EXIGIR EL PAGO ÍNTEGRO DE LA OBLIGACIÓN, sin necesidad de requerimiento judicial o extrajudicial alguno. 3.2. De conformidad a lo previsto por el Art. 585 del Código Civil, los “COMPRADORES”, reciben el BIEN, tomando posesión del mismo. 3.3. Cualquier desperfecto que tuviere el BIEN, no elude el compromiso de pago DE VENTA A CRÉDITO que deben realizar el/los COMPRADOR - DEUDOR(ES) mientras realiza(n) el reclamo del producto. Se aclara que todo BIEN que sale de la Empresa previamente fue verificado en su funcionamiento por los COMPRADOR - DEUDOR(ES) y que cuenta el BIEN con la garantía de la marca correspondiente. Cualquier desperfecto, arreglo o cambio del BIEN no es responsabilidad de VENDEDOR - ACREEDOR 3.4. Por acuerdo expreso de las partes, en caso de resolución por incumplimiento de los COMPRADOR - DEUDOR(ES) al no pagar las cuotas acordadas, VENDEDOR - ACREEDOR, las tomarán como compensación de pago indemnizatorio Por su parte los COMPRADOR - DEUDOR(ES) se obligarán a la devolución y entrega del BIEN, quieta y pacíficamente sin necesidad de requerimiento judicial.'

	cTexto8 := 'CUARTA. (EFECTOS DE LA MORA). - Al establecerse la mora, voluntariamente el COMPRADOR - DEUDOR(ES) aceptan la aplicación de multa por concepto de “re impresión de formulario de pago” por cuota atrasada, reconociendo y aceptando los COMPRADOR - DEUDOR(ES) la suficiente fuerza ejecutiva por el total del contrato en caso de incumplimiento o retraso en el pago.'

	cTexto9 := 'QUINTA. (RECOJO Y ENTREGA DEL BIEN). Mientras no esté cancelado el precio total del BIEN, y ante la constitución en mora por el incumplimiento del presente contrato, y pago de las cuotas por concepto de deuda VENDEDOR - ACREEDOR, tiene la facultad de poder recoger el BIEN de cualquier lugar o persona, sin necesidad de requerimiento judicial ni extrajudicial, autorizando el COMPRADOR - DEUDOR(ES) el ingreso a su domicilio si fuera necesario.'

	cTexto10 := 'SEXTA. (EFECTOS DE LA RESOLUCIÓN). Para tal caso el COMPRADOR - DEUDOR(ES) convienen que la liquidación sin ninguna otra formalidad tiene calidad de suma liquida y exigible y de plazo vencido por lo tanto sea ejecutable.'

	cTexto11 := 'SEPTIMA. (CAMBIO DE DOMICILIO). El COMPRADOR - DEUDOR(ES) se comprometen formalmente y mientras el presente contrato tenga vigencia a dar aviso al VENDEDOR - ACREEDOR de cualquier cambio de domicilio en el término perentorio de 24 horas de ocurrido, dejando plenamente establecido el domicilio señalado en el presente contrato para fines correspondientes a las notificaciones judiciales.'

	cTexto12 := 'OCTAVA. (GARANTÍAS). Los COMPRADOR - DEUDOR(ES) garantizan el cumplimiento de la presente obligación con todos sus bienes habidos y por hacer en especial con la garantía del FIADOR(A), GARANTE PERSONAL SOLIDARIO(A) MANCOMUNADO(A) E INDIVISIBLE de generales de ley descritas en la cláusula primera numeral 1.3, quien se convierte en codeudor de la presente obligación.'

	cTexto13 := 'NOVENA. (FALLECIMIENTO DEL COMPRADOR - DEUDOR(ES)). El presente contrato VENDEDOR - ACREEDOR lo convienen intuito persona, con el COMPRADOR - DEUDOR(ES), por lo que en caso de su fallecimiento se procederá a recoger el BIEN bajo el entendido y la ejecución por incumplimiento, para el caso que el heredero o los herederos deseen adquirir para sí el bien, el vendedor realizara una liquidación del saldo deudor y si los herederos aceptan la liquidación y se comprometen a pagar el saldo podrán adquirir para sí el bien.'

	cTexto14 := 'DECIMA. (GASTOS DEL CONTRATO, PROTOCOLIZACIÓN U OTROS). Los gastos de la confección del presente contrato, su protocolización, o reconocimiento y su ejecución judicial, serán pagados por el COMPRADOR - DEUDOR(ES).'

	cTexto15 := 'DECIMA PRIMERA. (AUTORIZACIÓN). El (Los) COMPRADOR - DEUDOR(ES), GARANTE(S), mediante el presente documento y a objeto de considerar el presente crédito, en calidad de deudor, garante u otro, autoriza (mos) en forma expresa, y sin limitación alguna a VENDEDOR - ACREEDOR a solicitar, verificar, intercambiar y actualizar en cualquier momento todos los antecedentes personales que estime necesario, antes y por todo el tiempo que dure la obligación crediticia. Asimismo, autoriza (mos) a VENDEDOR - ACREEDOR a solicitar el informe confidencial a obtenerse del Buró de Información Crediticia (BIC)., de la misma forma el comprador tiene conocimiento que para efectos del presente contrato en caso de incumplimiento el vendedor podrá gestionar la incorporación de los datos del comprador, codeudor, garantes personales al Buro de Información Crediticio (BIC).'

	cTexto16 := 'DECIMA SEGUNDA. (DEL DOCUMENTO Y SUS EFECTOS). En caso de que la presente minuta no sea elevada a instrumento público, con el solo reconocimiento de firmas ante autoridad competente, surtirá efectos de documento público y se constituye en documental para una posible intimación de pago judicial.'

	cTexto17 := 'DECIMA TERCERA. (ACEPTACIÓN Y CONFORMIDAD). Las partes, expresan su plena aceptación y conformidad con el tenor íntegro de la presente minuta, en su constancia firman al pie del mismo, para su fiel y estricto cumplimiento.'


	cDataText := AllTrim(Str(Day(STOD(aDetail[1][4])),2)) + ' de '+AllTrim(MesExtenso(STOD(aDetail[1][4]))) + ' del '+ AllTrim(Str(Year(STOD(aDetail[1][4])),4))
	cTexto18 := 'Santa Cruz de la Sierra, ' + cDataText

	////solucion final SUMAR TODO SIN LO QUE TRAE EN LAS LINEAS SOLO TEXTO FIJO A ESO SUMAR TODO LO QUE TRAEN LOS CAMPOS DE GARANTE ETC ESOS CARACTERES

	/*aTexto := StrTokArr(cTexto, CRLF)

	for nX := 1 to Len(aTexto)////divide el texto*/

	nTamLin := 013.5

	nXAumento:= (nTamLin * contaCarac(cTexto,103)) /////de esa porcion cuantas lineas se imprimiran

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto2,103)) /////de esa porcion cuantas lineas se imprimiran

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto2, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto3,108)) /////1.2. Por otra parte

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto3, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	if(!Empty(cWarrantor))

		nXAumento:= (nTamLin * contaCarac(cTexto4,105)) /////de esa porcion cuantas lineas se imprimiran

		verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

		oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto4, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

		nLinAtu += nXAumento

	endif

	nXAumento:= (nTamLin * contaCarac(cTexto5,103)) /////SEGUNDA. (OBJETO,

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto5, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto6,107)) /////de esa porcion cuantas lineas se imprimiran

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto6, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto7,105)) /////TERCERA. (MORA). 3

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto7, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto8,90)) /////CUARTA. (EFECTOS DE LA MORA).

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto8, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto9,110)) /////QUINTA. (RECOJO Y ENTREGA DEL BIEN). Mientras

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto9, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto10,110)) /////SEXTA. (EFECTOS DE LA RESOLUCIÓN). P

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto10, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto11,97)) /////SEPTIMA. (CAMBIO DE DOMICILIO). El

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto11, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto12,91)) /////OCTAVA. (GARANTÍAS). Los COMPRADOR

	verifyNewLine(nXAumento) ////solo valida para hacer una nueva pagina

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto12, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto13,103)) ////NOVENA. (FALLECIMIENTO DEL COMPRADOR

	verifyNewLine(nXAumento) ////

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto13, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto14,77)) /////DECIMA. (GASTOS DEL CONTRATO,

	verifyNewLine(nXAumento) 

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto14, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto15,107)) /////DECIMA PRIMERA. (AUTORIZACIÓN).

	verifyNewLine(nXAumento)

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto15, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto16,98)) ////DECIMA SEGUNDA. (DEL DOCUMENTO Y

	verifyNewLine(nXAumento) ////

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto16, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nXAumento:= (nTamLin * contaCarac(cTexto17,111)) /////DECIMA TERCERA. (ACEPTACIÓN Y CONFORMIDAD).

	verifyNewLine(nXAumento) ////

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto17, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nLinAtu += nTamLin

	nXAumento:= (nTamLin * contaCarac(cTexto18,103)) /////

	verifyNewLine(nXAumento) ////

	oPrint:SayAlign(nLinAtu, COL_TEXT, cTexto18, oFontDet, nHorzSize, nTamLin + nXAumento, CLR_BLACK, PAD_JUSTIFY, 0)

	nLinAtu += nXAumento

	nLinAtu += nTamLin + (nTamLin / 4)

	//next nX

	nLinAtu += nTamLin
	nLinAtu += nTamLin
	nLinAtu += nTamLin

	printFooter(TRIM(SA1->A1_CGC), TRIM(SA1->A1_NOME), TRIM(cWarrDoc), TRIM(cWarrName),TRIM(SA1->A1_EST))

	//Mostrando el reporte
	oPrint:Preview()

	SA1->( DbCloseArea() )

	RestArea(aArea)

RETURN

Static Function verifyNewLine(nAumento)
	Default nAumento:= 0

	If( nLinAtu + nAumento >= oPrint:nVertSize() - (nTamLin * 2))
		oPrint:EndPage()
		oPrint:StartPage()
		nPagAtu++
		nLinAtu:= 050
	EndIf

Return

Static Function printFooter(cClDoc, cClName, cWarrDoc, cWarrName,cCliEst)
	Local nSigSize	:= (nHorzSize / 2)
	Local lPrintWarr:= !Empty(cWarrDoc) .AND. !Empty(cWarrName)
	Local nHSizeCl	:= nHorzSize

	if(lPrintWarr)
		nHSizeCl:= nSigSize
	endIf

	verifyNewLine(nTamLin * 9)

	oPrint:SayAlign(nLinAtu, COL_TEXT, cClName, oFontNDet, nHSizeCl, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	if(lPrintWarr)
		oPrint:SayAlign(nLinAtu, COL_TEXT + nSigSize, cWarrName, oFontNDet, nSigSize, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	endIf
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "COMPRADOR / DEUDOR", oFontNDet, nHSizeCl, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	if(lPrintWarr)
		oPrint:SayAlign(nLinAtu, COL_TEXT + nSigSize, "GARANTE / CO DEUDOR", oFontNDet, nSigSize, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	endIf
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "CI: " + cClDoc + " " + cCliEst, oFontNDet, nHSizeCl, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	if(lPrintWarr)
		oPrint:SayAlign(nLinAtu, COL_TEXT + nSigSize, "CI: " + cWarrDoc, oFontNDet, nSigSize, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	endIf

	nLinAtu += nTamLin
	nLinAtu += nTamLin
	nLinAtu += nTamLin

	oPrint:SayAlign(nLinAtu, COL_TEXT, "ALVARO RODRIGO QUISBERT RAMOS", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "VENDEDOR - ACREEDOR", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	nLinAtu += nTamLin
	oPrint:SayAlign(nLinAtu, COL_TEXT, "C.I.: 3349535 LP", oFontNDet, nHorzSize, nTamLin, CLR_BLACK, PAD_CENTER, 0)
	nLinAtu += nTamLin

	//Finalizando la página y sumando una más
	oPrint:EndPage()
	nPagAtu++
Return

/**
* @author: Denar Terrazas Parada
* @since: 18/08/2022
* @description: Funcion que obtiene el detalle de la factura(SD2)
*/
Static Function getInvoiceDetail()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		//SELECT D2_QUANT,D2_UDESC,D2_DOC,D2_EMISSAO
		SELECT D2_DOC,D2_COD,D2_UDESC,D2_QUANT,D2_EMISSAO,B1_DESC
		FROM %table:SD2% SD2
		JOIN %table:SB1% SB1 ON B1_COD = D2_COD AND SB1.%notdel% AND B1_FILIAL = %exp:xFilial("SB1")%
		WHERE SD2.%notdel%
		AND SD2.D2_FILIAL = %exp:cBranch%
		AND SD2.D2_DOC = %exp:cDocument%
		AND SD2.D2_SERIE = %exp:cSerie%
		AND SD2.D2_CLIENTE = %exp:cClient%
		ORDER BY SD2.D2_ITEM

	EndSql

	DbSelectArea(OrdenConsul)

	If (OrdenConsul)->(!Eof())
		while ( (OrdenConsul)->(!Eof()))
			AADD(aRet, {(OrdenConsul)->D2_QUANT, (OrdenConsul)->B1_DESC, (OrdenConsul)->D2_DOC,(OrdenConsul)->D2_EMISSAO})
			(OrdenConsul)->(dbSkip())
		End
	endIf

	restArea(aArea)
return aRet

static function contaCarac(cTexTam,nTamCorte)
	nValRet := len(cTexTam)/nTamCorte   ///UN EJEMPLO SALE 2.1
	nSaldo := nValRet - round((len(cTexTam)/nTamCorte),0)   ///REDONDEAMOS HACIA ARRIBA

	if nSaldo > 0.1
		return round(nValRet + 1,0)
	else
		return round(len(cTexTam)/nTamCorte,0)
	endif

return
