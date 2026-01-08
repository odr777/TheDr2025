#include "rwmake.ch"        // incluido por el asistente de conversión del AP5 IDE en 30/11/00
#include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
#DEFINE oPrn:Say SAY
#ENDIF
#DEFINE DETAILBOTTOM 1150
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UCIFIN01  ºAutor  ³ MICROSIGA          ºFecha ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³INFORME MOV. BANCARIOS                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINANCIERO                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                                                                       º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UCIFIN01(_hNumero)        // incluido por el asistente de conversión del AP5 IDE en 30/11/00
	Local aArea 	 := GetArea()
	Local _aAreaSM0 := {}
	Private cNomeSuc := ""

	dbSelectArea("SM0")
	_aAreaSM0 := SM0->(GetArea())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaración de variables utilizadas en el programa a través de la función    ³
	//³ SetPrvt, va a crear sólo las variables definidas por el usuario,    ³
	//³ identificando las variables públicas del sistema utilizadas en el código ³
	//³ Incluido por el asistente de conversión del AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("CFUNFROM,NLASTKEY,CPARDESDE,CPARHASTA,ARETURN,CPROG")
	SetPrvt("CALIAS,CPERG,AFILTER,CTITULO,CDESC1,CDESC2")
	SetPrvt("CDESC3,LCONDIC,LCOMPRI,CTAMA,AHEADER,ACOLS")
	SetPrvt("NELE,REMITO,LSALIDA,LULTIMO,QUEREM,CNUMECOM,ASECTOR")
	SetPrvt("NCOPACOM,NPAGACOM,NPAGSCOM,NVALRCOM,DFECHCOM,NULTIENC")
	SetPrvt("NPRIMPIE,CNOMBCOM,CUSUA,CCLASCOM,COBSPCOM,CTIPOREM,CNOCOCOM,CSUCFI")
	SetPrvt("NCOPICOM,ACTIPIT,ACTIPITM,ACCODITM,ACDETITM,ACUNIITM,ACUNIIT,ANCNTIT,ACOBSERV,ANCNTITM")
	SetPrvt("ADRIVER,X,nline,nLine ,D")
	SetPrvt("nLine ,_SALIAS,AREGS,I,J,")

	//#IFNDEF WINDOWS
	// Movido para el inicio del archivo por el asistente de conversión del AP5 IDE en 30/11/00 ==> 	#DEFINE oPrn:Say SAY
	//#ENDIF

	cFunFrom := FunName()
	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funci¢n     ³ KLREMITO ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 05.05.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descripci¢n ³ Formato de Salida para Remitos 					      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso        ³ SIGAFAT                                                  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±³ Modificaciones :                                                      ³±±
	±±³ Luis 27/05/03 Modificaciones del Diseño y cambio de BitMap            ³±±
	±±³ Luis 02/03/04 Corte de Hoja en la For de Impresion de Detalle         ³±±
	±±³                                                                       ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	/*/
	//VldPerg()
	CriaSX1("UCIFIN01")
	Pergunte("UCIFIN01", .F.)
	nLastKey := 0
	If Empty(_hNumero)
		Pergunte("UCIFIN01", .T.)
	Else
		Pergunte("UCIFIN01", .F.)
	Endif
	If nLastKey == 27
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Par metros:                          ³
	//³ mv_par01 == Desde Documento          ³
	//³ mv_par02 == Hasta Documento          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cParDesde	:= ""
	cParHasta	:= ""
	cDeFecha	:= ""
	cAFecha		:= ""
	cDeBanco	:= ""
	cABanco	:= ""
	cDeAgen	:= ""
	cAAgen	:= ""
	cDeCuenta	:= ""
	cACuenta	:= ""

	If Empty(_hNumero)
		cParDesde	:= mv_par01
		cParHasta	:= mv_par02
		cDeFecha	:= IIF(empty(mv_par03),DATE(),mv_par03)
		cAFecha		:= IIF(empty(mv_par04),DATE(),mv_par04)
		cDeBanco	:= mv_par05//QRE5->E5_BANCO
		cABanco	:= mv_par06//QRE5->E5_BANCO
		cDeAgen	:= mv_par07//QRE5->E5_AGENCIA
		cAAgen	:= mv_par08//QRE5->E5_AGENCIA
		cDeCuenta	:= mv_par09//QRE5->E5_CONTA
		cACuenta	:= mv_par10//QRE5->E5_CONTA
	Else
		cParDesde	:= SE5->E5_DOCUMEN
		cParHasta	:= SE5->E5_DOCUMEN
		cDeFecha	:= SE5->E5_DATA
		cAFecha		:= SE5->E5_DATA
		cDeBanco	:= SE5->E5_BANCO
		cABanco	:= SE5->E5_BANCO
		cDeAgen	:= SE5->E5_AGENCIA
		cAAgen	:= SE5->E5_AGENCIA
		cDeCuenta	:= SE5->E5_CONTA
		cACuenta	:= SE5->E5_CONTA
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definici¢n de Vectores pa	ra Control de Impresi¢n. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÄÙ
	aHeader := {}
	aCols   := {}
	nEle    := 0
	AADD(aHeader,{ "Comprobante"   , "Remito ", "@!",03,0,".T.","€€€€€€‚","C","", "" } )
	AADD(aHeader,{ "Cliente    "   , "Cliente", "@!",03,0,".T.","€€€€€€‚","C","", "" } )
	If nLastKey == 27
		Return
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carga de Variables.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	PRIVATE oPrn  := TMSPrinter():New(), ;
	lProc := .f., ;
	oFont    := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. )
	oFont3   := TFont():New( "Arial"            ,, 12,, .t.,,,,    , .f. )
	oFont5   := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. )
	oFont5b  := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. )
	oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. )
	oFont9   := TFont():New( "Arial"            ,,  8,, .f.,,,, .t., .f. )
	oFont12b := TFont():New( "Times New Roman"  ,, 12,, .t.,,,,    , .f. )
	oFont12  := TFont():New( "Times New Roman"  ,, 12,, .f.,,,,    , .f. )
	oFont14b := TFont():New( "Times New Roman"  ,, 14,, .t.,,,,    , .f. )
	oFont14  := TFont():New( "Times New Roman"  ,, 14,, .f.,,,,    , .f. )
	oFont20  := TFont():New( "Times New Roman"  ,, 20,, .t.,,,,    , .f. )
	oFont18b := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .f. )
	oFont18  := TFont():New( "Times New Roman"  ,, 18,, .f.,,,,    , .f. )
	oFont18i := TFont():New( "Times New Roman"  ,, 18,, .f.,,,, .t., .f. )
	oFont11  := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .t. )
	oFont6   := TFont():New( "HAETTENSCHWEILLER",, 10,, .t.,,,,    , .f. )
	oFont30  := TFont():New( "Bauhaus Lt Bt"    ,, 10,, .t.,,,,    , .f. )
	oFont31  := TFont():New( "Arial"            ,,  8,, .t.,,,,    , .f. )
	oFont30a := TFont():New( "Bauhaus Lt Bt"    ,, 12,, .t.,,,,    , .f. )
	oFont31a := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. )

	cQuery := " SELECT * "
	cQuery += " FROM " + RetSqlName("SE5") + " SE5"
	cQuery += " WHERE E5_FILIAL = '" + xfilial("SE5") + "'"
	cQuery += " AND E5_DOCUMEN BETWEEN '" + cParDesde + "' AND '" + cParHasta + "'"
	cQuery += " AND E5_DATA BETWEEN '" + DTOS(cDeFecha) + "' AND '" + DTOS(cAFecha) + "'"
	cQuery += " AND E5_BANCO BETWEEN '" + cDeBanco + "' AND '" + cABanco + "'"
	cQuery += " AND E5_AGENCIA BETWEEN '" + cDeAgen + "' AND '" + cAAgen + "'"
	cQuery += " AND E5_CONTA BETWEEN '" + cDeCuenta + "' AND '" + cACuenta + "'"
	cQuery += " AND SE5.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY R_E_C_N_O_"
	cQuery := ChangeQuery(cQuery)
	
	If Select("QRE5") > 0
		QRE5->(DbCloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRE5", .F., .T.)

	If __CUSERID = '000000'
		//Aviso("Array IVA",cQuery,{'ok'},,,,,.t.)
	EndIf

	lSalida := .F.             //Salida no prevista
	lUltimo := .F.             //Salida por finalizaci¢n
	querem := QRE5->E5_DOCUMEN
	While !QRE5->(EOF())

		cTm := QRE5->E5_HISTOR
		Inivars()
		cNumeCom := querem
		nCopaCom := 1
		nPagaCom := 0
		nPagsCom := 0
		nValrCom := 0
		dFechCom := QRE5->E5_DATA
		cUsua    := CUSERNAME
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+QRE5->E5_FILIAL,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := alltrim(SM0->M0_NOMECOM)
		cSucfi := QRE5->E5_FILIAL
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial) //RESTARURAR
		dbSelectArea("SM0")
		SM0->(dbSetOrder(1))
		SM0->(RestArea(_aAreaSM0))
		IF  ( QRE5->E5_RECPAG == "R")
			cNombCom := "INGRESO"
		ELSE
			cNombCom := "EGRESO"
		ENDIF
		nLine      := 0

		cNome	:= Posicione("SA6", 1, QRE5->E5_FILIAL +QRE5->E5_BANCO+QRE5->E5_AGENCIA+QRE5->E5_CONTA, "SA6->A6_NOME")
		nMoeda	:= Posicione("SA6", 1, QRE5->E5_FILIAL + QRE5->E5_BANCO+QRE5->E5_AGENCIA+QRE5->E5_CONTA, "SA6->A6_MOEDA")
		cMoeda	:= UPPER(SUPERGETMV('MV_MOEDA'+cValtoChar(nMoeda),.F.,"M"))	//Descripcion de la moneda
		AADD( acCodItm, alltrim(LEFT(cNome,40)) + " - " + alltrim(QRE5->E5_CONTA ))
		AADD( acDetItm, QRE5->E5_BENEF  )
		AADD( acUniItm, cMoeda )
		AADD( anCntItm, QRE5->E5_NATUREZ)
		AADD( acUniIt, QRE5->E5_VALOR)
		AADD( anCntIt, QRE5->E5_CCUSTO)
		AADD( acTipItm, QRE5->E5_ITEMD )
		AADD( acObserv, QRE5->E5_NUMCHEQ)
		QRE5->( dbSkip() )

		Processa({|lEnd|Imprimir()},"Impresion de Movimientos Bancarios")
	EndDo
	oPrn:Setup()
	oPrn:PreView()
	MS_FLUSH()
	
	QRE5->(DbCloseArea())
	RestArea(aArea)
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ INIVARS  ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Inicializaci¢n de Variables para KLREMITO                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KLREMITO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Inivars()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables del encabezado y pie.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	//nUltiEnc := 31                  //Ultima Fila Utilizada por el Encabezado
	//nPrimPie := 54                  //Primera Fila Utilizada por el Pie
	cClasCom := "R"                 //Clase del Remito
	cNumeCom := Space(20)           //Numero de Remito
	//cObspCom := ""                  //Observaciones en el Pie
	cTipoRem := ""                  //Tipo de Remito
	cNocoCom := ""                  //Nombre de la Copia
	nCopaCom := 0                   //Copia Actual del Remito
	nCopiCom := 0                   //Cantidad de Copias del Remito
	nPagaCom := 0                   //P gina actual del Remito
	nPagsCom := 0                   //N£mero total de p ginas del Remito
	//nValrCom := 0                   //Valor del Remito
	dFechCom := CToD("  /  /  ")    //Fecha del Remito
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables del detalle.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	acObserv := {}                  //Observ
	acTipItm := {}                  //Deposito origen
	acTipIt  := {}                  //Deposito destino
	acCodItm := {}                  //Codigo del Item
	acDetItm := {}                  //Detalle del Item
	acUniItm := {}                  //Segunda Unidad de Medida
	acUniIt  := {}                  //Primera Unidad de Medida
	anCntItm := {}                  //Cantidad  en Primera Unidad
	anCntIt  := {}                  //Cantidad  en Segunda Unidad
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPRIMIR ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KLREMITO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Imprimir()
	nCopicom:=1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Control de Impresi¢n.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	ProcRegua( nCopiCom )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ C lculo de Cantidad de P ginas.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	//nPagsCom := Len( acDetItm ) / ( ( nPrimPie - nUltiEnc ) - 1 )
	nPagsCom := Int( If( nPagsCom < 1, 1, If( nPagsCom > 1, nPagsCom + 1 , nPagsCom ) ) )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carga del driver de impresi¢n.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	//	aDriver := ReadDriver()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Llamada al spool de impresi¢n.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ariel ÄÄÄÙ
	Set Device to Screen
	For x := 1 to nCopiCom
		ImpEncab()
		ImpDetal()
		ImpPie()
		IncProc("Comprob.: "+cNumeCom+" - Copia: " + Alltrim(Str(x,3)) + " de " + Alltrim(Str(nCopiCom,3)))
		nCopaCom := nCopaCom + 1
		nPagaCom := 0
	Next x
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPENCAB ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Encabezados.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KLREMITO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Impencab()
	IF !lProc
		lProc := .t.
	ELSE
		oPrn:StartPage()
	ENDIF
	oPrn:Say( nLine, 0100, " ", oFont, 100 ) // iniciando la impresora
	NomeCopi()
	/**************************
	ENCABEZADO GENERICO
	****************************/
	nLine := 50
	cFileLogo     := GetSrvProfString("Startpath","") + "Logo.jpg"
	oPrn:Say( nLine, 0100, " ", oFont, 100 )
	//IF !Empty( GetNewPar("MV_DIRLOGO") )
	//cFileLogo += GetNewPar("MV_DIRLOGO") + ".BMP"
	//	cFileLogo += "logo_union" + ".BMP"
	IF File( AllTrim( cFileLogo ) )
		oPrn:Box( nLine, 0050, nLine + 470, 2300 )
		nLine += 10
		oPrn:SayBitmap( nLine, 0100, AllTrim(cFileLogo) , 450, 150 )
	ELSE
		nLine += 10
	ENDIF
	//ENDIF
	nLine += 40
	oPrn:Say( nLine, 670, "COMPROBANTE", oFont12, 100 )
	oPrn:Box( nLine, 1040, nLine + 70, 1780 )
	oPrn:Say( nLine, 1060, cNumeCom, oFont12b, 100 )
	oPrn:Say( nLine, 1850, "FECHA", oFont8, 100 )
	//oPrn:Box( nLine, 2000, nLine + 70, 2230 )
	oPrn:Say( nLine, 2020, DTOC(STOD(dFechCom)), oFont30, 100 )
	nLine += 150
	//oPrn:Say( nLine +  00, 0100, " ", oFont30, 100 )
	oPrn:Say( nLine, 1300,  cNombCom , oFont30, 100 )
	oPrn:Say( nLine + 030, 0070, cNomeSuc + " - " + cSucfi, oFont31, 100 )
	oPrn:Say( nLine, 1850, "T/C    :", oFont8, 100 )
	oPrn:Say( nLine, 2020, cvaltochar(POSICIONE("SM2", 1, dFechCom, "M2_MOEDA2")), oFont30, 100 )   // xmoeda
	oPrn:Say( nLine + 060, 0070, AllTrim(UPPER(SM0->M0_ENDCOB)) + " - " + AllTrim(UPPER(SM0->M0_CIDCOB)), oFont31, 100 )
	oPrn:Say( nLine + 100, 0070, "Tel.: " + SM0->M0_TEL, oFont31, 100 )
	oPrn:Say( nLine + 140, 0070, "N.I.T. " + AllTrim( SM0->M0_CGC ) + " " , oFont31, 100 )
	oPrn:Say( nLine + 180, 0070, "Telefono: " + AllTrim( SM0->M0_TEL ) + " Email : " , oFont31, 100 )
	/**********************
	FIN ENCABEZADO GENERICO
	**********************/
	nLine += 60
	nline := nline + 200
	//oPrn:Box( nLine, 0050, nLine + 200, 2300 )
	//nline := nLine += 40
	oPrn:Say (nLine,0070, "Banco / Caja:",Ofont5,100)
	Public nl1:=nLine
	nline := nLine += 70
	oPrn:Say (nLine,0070, "Beneficiario:",Ofont5,100)
	Public nl2:=nLine
	nline := nLine += 70
	oPrn:Say (nLine,0070, "Modalidad:",Ofont5,100) //1350
	Public nl3:=nLine
	nline := nLine += 70
	oPrn:Say (nLine,0070, "Moneda:",Ofont5,100)  //1500
	Public nl4:=nLine
	nline := nLine += 70
	//oPrn:Say (nLine,1650, "CANT",Ofont30,100)
	//oPrn:Say (nLine,1800, "2UM",Ofont30,100)
	oPrn:Say (nLine,0070, "Valor: ",Ofont5,100) //1650
	Public nl5:=nLine
	nline := nLine += 70
	oPrn:Say (nLine,0070, "Son:",Ofont5,100) // 1800
	Public nl6:=nLine
	/*
	nline := nLine += 100
	oPrn:Say (nLine,0070, "Item Contable:",Ofont5,100)
	Public nl7:=nLine*/
	nline := nLine += 70
	oPrn:Say (nLine,0070, "Cheque Numero:",Ofont5,100)
	Public nl8:=nLine
	nline := nLine += 70
	oPrn:Say (nLine,0070, "Glosa:",Ofont5,100)
	Public nl9:=nLine
	nline := nLine += 70
	//oPrn:Say (nLine,1650, "2UM",Ofont30,100)
	//oPrn:Say (nLine,2000, "CTB",Ofont30,100)
	//nline := nLine += 40
	//oPrn:Say (nLine,2190, "DEST",Ofont30,100)
	//nline := nLine += 100
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPDETAL ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Detalles.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KLREMITO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido por el asistente de conversión del AP5 IDE en 30/11/00 ==> Function Impdetal
Static Function Impdetal()
	nLinIni := nLine
	//For d := 1 To Len( acDetItm )
	D:=1
	//    	nLine  := nLine  + 40
	oPrn:Say (nL1,770,acCodItm[d],oFont5b,100)      // codigo
	oPrn:Say( nL2,770, padR(alltrim( TransForm( acDetItm[d], PesqPict( "SE5", "E5_BENEF" ))),40," ") , oFont5b, 100 )
	oPrn:Say( nL3,770, anCntItm[d] , oFont5b, 100 )    // CANT
	oPrn:Say( nL4,770,  TransForm( acUniItm[d], PesqPict( "SE5", "E5_MOEDA" ) )  , oFont5b, 100 )       // UM
	//		oPrn:Say( nLine, 1600,  TransForm( anCntIt[d], "@E 99,999,999.99" ) , oFont, 100 )      // CANT. 2UM
	//		oPrn:Say( nLine, 1750,  TransForm( acUniIt[d], PesqPict( "SB1", "B1_SEGUM" ) )  , oFont, 100 )         // 2UM
	oPrn:Say( nL5,770,  ALLTRIM(TransForm( acUniIt[d], "@E 99,999,999.99" )) , oFont5b, 100 )      // Costo Unit
	oPrn:Say( nL6,770,  alltrim(Extenso(acUniIt[d],.F.,1)) , oFont5b, 100 )         // Total
	//oPrn:Say( nL7,970,  TransForm( acTipItm[d], PesqPict( "SE5", "E5_ITEMD" ) ) , oFont14b, 100 )         // DEP. ORIGEN
	//		oPrn:Say( nLine, 2200,  TransForm( acTipIt[d], PesqPict( "SD3", "D3_LOCAL" ) ) , oFont, 100 )         // DEP. DEST
	//nLine   += 40
	//OBSERVACIONES
	IF !Empty( acObserv[d] )
		_oBserv := alltrim(acObserv[d])
		oPrn:Say( nL8, 770,_oBserv, oFont5b, 100 )
	ENDIF
	oPrn:Say( nL9,770,  CTM , oFont5b, 100 )         // histor
	if nLine > nLinIni + 1100                  // Agrego Luis 02/03/04
		ImpPie()
		ImpEncab()
		//ALERT("SALTO")
	endif
	nLine := DETAILBOTTOM
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ IMPPIE   ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 08.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Rutina de Impresi¢n de Pie de Documento.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KLREMITO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpPie()
	oPrn:Say (nLine,0200,"EMITIDO POR: ", oFont30, 100)
	oPrn:Say (nLine,1000,"BENEFICIARIO: ", oFont30, 100)
	oPrn:Say (nLine,1700,"AUTORIZADO POR: ", oFont30, 100)
	nline += 70
	oPrn:Say (nLine,0200,cUsua, oFont14b, 100)
	nLine += 150
	oPrn:Box( nLine, 0050, nLine+10, 2300)
	nLine += 50
	oPrn:Say (nLine,1810,"IMPRESION: " + DToC( dDatabase ),oFont8,100)
	oPrn:EndPage()
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NOMECOPI ³ Autor ³ Ariel A. Musumeci     ³ Data ³ 19.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nombres de las copias.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ KLREMITO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NomeCopi()
	If nCopaCom == 1
		cNocoCom := "ORIGINAL"
	ElseIf nCopaCom == 2
		cNocoCom := "DUPLICADO"
	ElseIf nCopaCom == 3
		cNocoCom := "TRIPLICADO"
	ElseIf nCopaCom == 4
		cNocoCom := "CUADRUPLICADO"
	ElseIf nCopaCom == 5
		cNocoCom := "ADM. VENTAS"
	Else
		cNocoCom := "COPIA " + AllTrim( Str( nCopaCom, 3 ) )
	EndIf
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ VLDPERG  ³ Autor ³ Ariel A. Musumeci   ³ Data ³ 05.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Validaci¢n de SX1 para KLREMITO                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ KLREMITO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido por el asistente de conversión del AP5 IDE en 30/11/00 ==> Function VldPerg
Static Function VldPerg()
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("UCIFIN01",6)
	aRegs:={}
	// Migracion de V 5.07 a 7. Fecha 19/7/04. HDM
	aAdd(aRegs,{cPerg,"01","Desde Documento ","Desde Documento ","Desde Documento ","mv_ch1","C",23,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SE5",'','' } )
	//aAdd(aRegs,{cPerg,"02","Hasta Documento ","Hasta Documento ","Hasta Documento ","mv_ch2","C",23,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SE5",'','' } )
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
RETURN
Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De Documento?"	, "¿De Documento?"		,"¿De Documento?"	,"MV_CH1","C",20,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Documento?" 	, "¿A Documento?"		,"¿A Documento?"	,"MV_CH2","C",20,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Fecha?" 	, "¿De Fecha?"			,"¿De Fecha?"		,"MV_CH3","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Fecha?" 		, "¿A Fecha?"			,"¿A Fecha?"		,"MV_CH4","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Banco?"	, "¿De Banco?"		,"¿De Banco?"	,"MV_CH1","C",3,0,0,"G","","A64","","","mv_par05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿De Agencia?"	, "¿De Agencia?"		,"¿De Agencia?"	,"MV_CH1","C",5,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿De Cuenta?"	, "¿De Cuenta?"		,"¿De Cuenta?"	,"MV_CH1","C",10,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿A Banco?"	, "¿A Banco?"		,"¿A Banco?"	,"MV_CH1","C",3,0,0,"G","","A64","","","mv_par08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿A Agencia?"	, "¿A Agencia?"		,"¿A Agencia?"	,"MV_CH1","C",5,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿A Cuenta?"	, "¿A Cuenta?"		,"¿A Cuenta?"	,"MV_CH1","C",10,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,""   ,"")
return
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)
	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.
	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	If !( DbSeek( cGrupo + cOrdem ))
		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
		Reclock( "SX1" , .T. )
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		Replace X1_VAR01   With cVar01
		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
		Replace X1_HELP With cHelp
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		MsUnlock()
	Else
		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif
	RestArea( aArea )
Return
