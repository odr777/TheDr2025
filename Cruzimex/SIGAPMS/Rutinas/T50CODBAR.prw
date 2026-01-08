#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

/*/================================================================================================================================/*/
/*/{Protheus.doc} M105BUT
Impresión de apunte de producción de bobinas o etiquetas.
@type Impresión de Etiquetas
@author Nahim Terrazas
@since 15/02/2020
@version P12.1.17
/*/
/*/================================================================================================================================/*/

User Function T50CODBAR(cNroSeUni)
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local oPrinter
	Local cLocal          := "\spool"
	//	Local cCodigo := Posicione("SB1",1,xFilial("SB1")+M->H6_PRODUTO ,"B1_CODBAR") //"015080"
	//	Local cCodigo := M->H6_OP  //"015080"

	//	oPrinter := FWMSPrinter():New("easrel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	//	oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,1/*nRow*/ ,3/*nCol*/, alltrim(M->H6_OP)/*cCode*/,oPrinter/*oPrint*/,.T./*lCheck*/,/*Color*/,.T./*lHorz*/,0.017/*nWidth*/,1/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/ )
	//	oFont1 := TFont():New( "Courier New", ,10, .T.)
	//	oPrinter:Say( 70, 50, M->H6_PRODUTO, oFont1, 1400, CLR_BLACK) // H6_PRODUTO
	//	oPrinter:Say( 90, 50, "Nro Op. " + M->H6_OP + " / " + M->H6_OPERAC , oFont1, 1400, CLR_BLACK)// H6_OP  - H6_OPERAC
	//	oPrinter:Say( 110, 50, "Fecha: "+ cValtochar(M->H6_DATAINI) + " - " + M->H6_HORAINI, oFont1, 1400, CLR_BLACK) // H6_DATAINI - H6_HORAINI
	//	oPrinter:Say( 130, 50, "Cantidad: "+ cValtochar(ROUND(M->H6_QTDPROD,2)), oFont1, 1400, CLR_BLACK)
	//	oPrinter:Say( 111, 180, "Peso bruto: "+ cValtochar(M->H6_QTDPRO2), oFont1, 1400, CLR_BLACK)
	//	oPrinter:Say( 130, 180, "Peso neto: "+ cValtochar(M->H6_PESONET), oFont1, 1400, CLR_BLACK)

	oPrinter := FWMSPrinter():New("easrel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	if Type( "cNroSeUni" ) <> "U"  // TODO realiza la impresión en modelo 2 debería hacerse desde el módelo 1 tambien.
		oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,1/*nRow*/ ,3/*nCol*/, alltrim(cNroSeUni)/*cCode*/,oPrinter/*oPrint*/,.T./*lCheck*/,/*Color*/,.T./*lHorz*/,0.017/*nWidth*/,1/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/ )
	else
		oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,1/*nRow*/ ,3/*nCol*/, alltrim(SH6->H6_OP)/*cCode*/,oPrinter/*oPrint*/,.T./*lCheck*/,/*Color*/,.T./*lHorz*/,0.017/*nWidth*/,1/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/ )
	endif
	oFont1 := TFont():New( "Courier New", ,10, .T.)
	oPrinter:Say( 70, 50, SH6->H6_PRODUTO, oFont1, 1400, CLR_BLACK) // H6_PRODUTO // imprime código de producto
	oPrinter:Say( 80, 50, SB1->B1_DESC, oFont1, 1400, CLR_BLACK) // H6_PRODUTO // imprime código de producto
	oPrinter:Say( 90, 50, "Nro Op. " + SH6->H6_OP + " / " + SH6->H6_OPERAC , oFont1, 1400, CLR_BLACK)// H6_OP  - H6_OPERAC
	oPrinter:Say( 110, 50, "Fecha: "+ cValtochar(SH6->H6_DATAINI) + " - " + SH6->H6_HORAINI, oFont1, 1400, CLR_BLACK) // H6_DATAINI - H6_HORAINI
	oPrinter:Say( 120, 50, "HORA: "+ TIME()) // H6_DATAINI - H6_HORAINI
	oPrinter:Say( 130, 50, "Cantidad: "+ cValtochar(ROUND(SH6->H6_QTDPROD,2)), oFont1, 1400, CLR_BLACK)
	oPrinter:Say( 111, 180, "Peso bruto: "+ cValtochar(SH6->H6_QTDPRO2), oFont1, 1400, CLR_BLACK)
	oPrinter:Say( 130, 180, "Peso neto: "+ cValtochar(SH6->H6_PESONET), oFont1, 1400, CLR_BLACK)

	oPrinter:Setup()
	if oPrinter:nModalResult == PD_OK
		oPrinter:Preview()
	EndIf
	//oPrinter:print()
Return