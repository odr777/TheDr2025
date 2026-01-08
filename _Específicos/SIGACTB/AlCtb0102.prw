#include "protheus.ch"
#include "ApLib080.ch"

#DEFINE N_FECHA 	1
#DEFINE N_SLOTE 	2
#DEFINE N_DESLOT	3
#DEFINE N_CUENT 	1
#DEFINE N_DESCU 	2
#DEFINE N_DEBE 	    3
#DEFINE N_HABER     4
#DEFINE N_FILIA     5
#DEFINE N_HISTO     6
#DEFINE N_AGRUPYN   5


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FECHA:	04/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Informe de Asiento.
Se reescribio el codigo para pasar el informe a TReport.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
User Function AlCt0102
Local oReport	:= NIL

Private cPerg  	:= "ALCTB010"
Private cTitulo :=OemToAnsi( 'ASIENTO RESUMEN' )
Private M_PAG	:= 1
Private N_PAG	:= 1
Private lFirst := .T.

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

//
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FUNCION:	REPORTDEF	|	FECHA:	04/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Genero la estructura del informe.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ReportDef()
Local oReport, oSection1, oSection2

Local cReport := "ALCTB010"
Local cDescri := OemToAnsi("Genera un informe de asientos resumidos")

	ValidPerg( cPerg )

	If !Pergunte( cPerg, .T. )
		Return NIL
	EndIf
	if !SUBSTR( DtoS( mv_par01 ), 1, 6) == SUBSTR( DtoS( mv_par02 ), 1, 6)
		MsgInfo("La fecha Tiene Ser Del Mismo Mes")
		ReportDef()
	ENDIF

	oReport  := TReport():New( cReport, cTitulo, cPerg , { |oReport| ReportPrint( oReport, "CT2" ) }, cDescri )

	oReport:SetTotalInLine(.T.)
	oReport:SetLandscape(.T.)
	oReport:HideHeader()
	oReport:HideFooter()

	oSection1:= TRSection():New( oReport,"Informe de Asientos", {"CT2"})

	// Imprimie Cabecalho no Topo da Pagina
	oSection1:SetHeaderPage()

	TRCell():New( oSection1,"CORRELAT"		, "   ", "	"				, "@!"	, 90	,/*lPixel*/,{|| (cAliasCT2)->CORRELAT })	// 1

	oSection2 := TRSection():New(oSection1,"Detalle",{'CT2'})
	oSection2:SetTotalInLine(.F.)

	TRCell():New( oSection2,"CUENTA"	, "   ", "Cuenta"				, PesqPict("CT2","CT2_DEBITO")	, TamSX3("CT2_DEBITO")[1] -5 ,/*lPixel*/,{|| (cAliasCT2)->CUENTA })	// 2
	TRCell():New( oSection2,"DESCUENT"	, "   ", "Descripcion de cuenta", PesqPict("CT1","CT1_DESC01")	, TamSX3("CT1_DESC01")[1] +5 ,/*lPixel*/,{|| (cAliasCT2)->CUENTAD })	// 3
	TRCell():New( oSection2,"CDEBE"		, "   ", "Debe"					, PesqPict("CT2","CT2_VALOR")	, TamSX3("CT2_VALOR")[1] +5	 ,/*lPixel*/,{|| (cAliasCT2)->SALDO })	// 4
	TRCell():New( oSection2,"CHABER"	, "   ", "Haber"				, PesqPict("CT2","CT2_VALOR")	, TamSX3("CT2_VALOR")[1] +5	 ,/*lPixel*/,{|| (cAliasCT2)->SALDO })	// 5
	TRCell():New( oSection2,"HISTORIA"	, "   ", "Historial"			, PesqPict("CT2","CT2_HIST")	, TamSX3("CT2_HIST")[1]		 ,/*lPixel*/,{|| (cAliasCT2)->HISTORIAL })// 6
	TRCell():New( oSection2,"SALDODIS"	, "   ", "	"				    , PesqPict("CT2","CT2_VALOR")	, TamSX3("CT2_VALOR")[1] -5  ,/*lPixel*/,{|| (cAliasCT2)->SALDO })	// 7

Return oReport


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FUNCION:	REPORTPRINT	|	FECHA:	04/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Realizo la impresion del informe.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function ReportPrint( oReport )
Local oSection1	:= oReport:Section(1)
//Local oSection2 := oReport:Section(1):Section(1)
Local nProxDoc	:= 0
Local nTotDeb	:= 0
//Local nTotHab	:= 0
Local nTotSal2	:= 0
Local nTotGDeb	:= 0
Local nTotGHab	:= 0
Local nPrinted	:= 0
Local nAcumDeb	:= 0
Local nAcumHab	:= 0
Local nImpDebe	:= 0
Local nImpHaber	:= 0
Local nY		:= 0
Local nX		:= 0
Local nSaldo	:= 0

Local cTipoDeb	:= ""
Local cTipoCre	:= ""
Local cTabela	:= ""
Local cNull		:= ""
Local cSubLote	:= ""
Local cSubLotD	:= ""
Local cTamanho  := "G"
Local cCuenta	:= ""
Local cDesCuen	:= ""
Local cClave	:= ""
Local cFilCT2	:= ""
local cLote     := ""

//Local lImpTotal := .T.
//Local lPrimero := .T.

Local aDatos	:= {}
Local aCuenta	:= {}

Local dFecha	:= CTOD("  /  /  ")

Private cAliasCT2 := 'TMPCT2'
Private	nSalto    := 55
Private	cDesde    := DtoS( mv_par01 )
Private	cHasta    := DtoS( mv_par02 )
Private	aPos      := {}

	M_PAG := MV_PAR05

	cTipoDeb := '%' + FormatIn( '1/3', '/' ) + '%'
	cTipoCre := '%' + FormatIn( '2/3', '/' ) + '%'
	cTabela  := "%'SB'%"
	cNull    := "%''%"

		BeginSql Alias cAliasCT2
			COLUMN DEBITO 	AS NUMERIC(16,2)
			COLUMN CREDITO	AS NUMERIC(16,2)
			COLUMN SALDO	AS NUMERIC(16,2)

			SELECT FECHA,
				SUBLOTE, ISNULL( (  SUBLOTE ),%Exp:cNull% ) AS SUBLOTED,
				 ISNULL( (  LOTECT2 ),%Exp:cNull% ) AS LOTECT2D,

				CUENTA,  ISNULL( ( SELECT CT1_DESC01 FROM %Table:CT1% A WHERE CT1_FILIAL = %xFilial:CT1% AND CT1_CONTA = CUENTA  AND A.%NotDel% ), %Exp:cNull% ) AS CUENTAD,
				(DEBITO-CREDITO)*-1 AS SALDO, HISTORIAL, DOCUMENT, LOTECT2, FILIALCT2
			FROM (	SELECT CT2_DEBITO AS CUENTA,
						CT2_VALOR AS DEBITO,
						0 AS CREDITO,
						CT2_HIST AS HISTORIAL,
						CT2_DATA AS FECHA,
						CT2_DOC AS DOCUMENT, 
						CT2_LOTE AS LOTECT2,
						CT2_FILIAL AS FILIALCT2,
						CT2_SBLOTE AS SUBLOTE
						FROM %table:CT2% E
						WHERE CT2_FILIAL BETWEEN %Exp:mv_par10% AND %Exp:mv_par11%
						AND CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
						AND CT2_LOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
						AND CT2_DC IN %Exp:cTipoDeb%
						AND CT2_MOEDLC = %Exp:mv_par03%
						AND CT2_TPSALD = %Exp:mv_par04%
						AND CT2_LP <> '631'
						AND E.%NotDel%
					UNION ALL
					SELECT CT2_CREDIT AS CUENTA,
						0 AS DEBITO,
						CT2_VALOR AS CREDITO,
						CT2_HIST AS HISTORIAL,
						CT2_DATA AS FECHA,
						CT2_DOC AS DOCUMENT, 
						CT2_LOTE AS LOTECT2,
						CT2_FILIAL AS FILIALCT2,
						CT2_SBLOTE AS SUBLOTE
						FROM %table:CT2% G
						WHERE CT2_FILIAL BETWEEN %Exp:mv_par10% AND %Exp:mv_par11%
						AND CT2_DATA BETWEEN %Exp:cDesde% AND %Exp:cHasta%
						AND CT2_LOTE BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
						AND CT2_DC IN %Exp:cTipoCre%
						AND CT2_MOEDLC = %Exp:mv_par03%
						AND CT2_TPSALD = %Exp:mv_par04%
						AND CT2_LP <> '631'
						AND G.%NotDel%
						) F
			ORDER BY FILIALCT2, FECHA, LOTECT2, SUBLOTE, DOCUMENT, SALDO, CUENTA
		EndSql
	
	// LA FECHA QUE DEVUELVE COMO CHAR, LA PASO A DATE
	TcSetField( cAliasCT2, "FECHA"	, "D", 8, 0 )

	nTotDeb  := 0
	nTotCre  := 0
	nTotSal	 := 0
	nTotSal1 := 0
	nTotGDeb := 0
	nTotGHab := 0
	nImpDebe := 0
	nImpHaber:= 0
	Titulo   := cTitulo
	nProxDoc := IIF(MV_PAR08=0,1,MV_PAR08)//default en 1 si est√° en cero
	nLin     := 80
	dFecha	 := CTOD("  /  /  ")

	// CABECERA ESPECIFICA
	oReport:onPageBreak( { || 	N_PAG++ , nPrinted := 0 , CabecLzb( cTitulo, oReport, oSection1, cPerg, cTamanho )})

	DbSelectArea( cAliasCT2 )
	DbGoTop()

	While !Eof()
		cSubLote:= (cAliasCT2)->SUBLOTE
		cSubLotD:= (cAliasCT2)->SUBLOTED
		cCuenta	:= (cAliasCT2)->CUENTA
		cDesCuen:= (cAliasCT2)->CUENTAD
		dFecha	:= (cAliasCT2)->FECHA
		cFilCT2	:= (cAliasCT2)->FILIALCT2
		cLote   := (cAliasCT2)->LOTECT2D
		nTotSal2:= 0
		nAcumDeb:= 0
		nAcumHab:= 0
		cClave	:= (cAliasCT2)->FILIALCT2 + DTOS( (cAliasCT2)->FECHA ) + (cAliasCT2)->LOTECT2 + (cAliasCT2)->SUBLOTE + (cAliasCT2)->DOCUMENT
		nSaldo	:= 0

		// SubLotes que considero NO para acumularlos.
		IF !AllTrim( (cAliasCT2)->LOTECT2 ) $ AllTrim( MV_PAR09 )
			While !(cAliasCT2)->(Eof()) .AND. cFilCT2 == (cAliasCT2)->FILIALCT2 .AND. cLote == (cAliasCT2)->LOTECT2 .AND. cCuenta == (cAliasCT2)->CUENTA	// cClave == (cAliasCT2)->FILIALCT2 + DTOS( (cAliasCT2)->FECHA ) + (cAliasCT2)->LOTECT2 + (cAliasCT2)->SUBLOTE + (cAliasCT2)->DOCUMENT .AND. cCuenta	== (cAliasCT2)->CUENTA
				IF (cAliasCT2)->SALDO > 0
					nAcumHab+= (cAliasCT2)->SALDO
				Else
					nAcumDeb+= (cAliasCT2)->SALDO * (-1)
				EndIF
//					nSaldo += (cAliasCT2)->SALDO
				(cAliasCT2)->(DbSkip())
			EndDo

			// BUSCO EN EL ARRAY PRINCIPAL EL SUBLOTE
			nX := AsCan( aDatos, { |x| AllTrim( x[2] ) == AllTrim( cLote )})

			// SI EXISTE EL SUBLOTE
			IF nX <> 0
				// BUSCO LA CUENTA EN EL ARRAY PRINCIPAL
				nY := AsCan( aDatos[nX][4], { |x| AllTrim( x[1] ) == AllTrim( cCuenta )})

				// SI NO ENCONTRE LA CUENTA EN EL ARRAY PRINCIPAL
				IF nY == 0
					// BUSCO EN EL ARRAY DE CUENTAS POR CUENTA Y SUBLOTE
					nY := AsCan( aCuenta, { |x| AllTrim( x[1] ) == AllTrim( cCuenta ) .AND. AllTrim( x[7] ) == AllTrim( cLote )})
					
					// SI NO LO ENCONTRE, LO ADICIONO
					IF nY == 0
						AADD( aCuenta, {cCuenta,;
										cDesCuen,;
										nAcumDeb,;
										nAcumHab,;
										cFilCT2,;
										SX5des( "HS", AllTrim( cLote )),;
										cLote})
//										nSaldo,;
					Else	// SI NO, LO ACUMULO
						aCuenta[nY][3] += nAcumDeb
						aCuenta[nY][4] += nAcumHab
					EndIF
				Else	// SINO LO ACUMULO.
					aDatos[nX][4][nY][3] += nAcumDeb
					aDatos[nX][4][nY][4] += nAcumHab
				EndIF
			Else
				// SI NO EXISTE EL SUBLOTE
				nY := AsCan( aCuenta, { |x| AllTrim( x[1] ) == AllTrim( cCuenta ) .AND. AllTrim( x[7] ) == AllTrim( cLote )})

				IF nY == 0
					AADD( aCuenta, {cCuenta,;
									cDesCuen,;
									nAcumDeb,;
									nAcumHab,;
									cFilCT2,;
									SX5des( "HS", AllTrim( cLote )),;
									cLote})
				Else
					aCuenta[nY][3] += nAcumDeb
					aCuenta[nY][4] += nAcumHab
				EndIF
			EndIF

			IF !(cFilCT2 == (cAliasCT2)->FILIALCT2 .AND. cLote == (cAliasCT2)->LOTECT2  )	// !(cClave == (cAliasCT2)->FILIALCT2 + DTOS( (cAliasCT2)->FECHA ) + (cAliasCT2)->LOTECT2 + (cAliasCT2)->SUBLOTE + (cAliasCT2)->DOCUMENT)
				nY := AsCan( aDatos, { |x| x[1] == FormatFecha( MV_PAR02 ) .AND. x[2] == cLote })

				// ORDENO EL DEBE
//				aCuenta := aSort( aCuenta,,, {|x,y| x[3]-x[4] > y[3]-y[4] })

				IF nY == 0
//					AADD( aDatos, {	FormatFecha( MV_PAR02 ), cSubLote, cSubLotD, aCuenta })
					AADD( aDatos, {	FormatFecha( MV_PAR02 ), cLote, cSubLotD, aCuenta, "1" })// Agregado Carlos Galvao - 14/06/2016})})
				Else
					FOR nX := 1 To Len( aCuenta )
						AADD( aDatos[nY][4], { aCuenta[nX][1], aCuenta[nX][2], aCuenta[nX][3], aCuenta[nX][4], aCuenta[nX][5], aCuenta[nX][6] })
					Next nX
				EndIF
				aCuenta := {}
			EndIF
		Else
			While !(cAliasCT2)->(Eof()) .AND. cClave == (cAliasCT2)->FILIALCT2 + DTOS( (cAliasCT2)->FECHA ) + (cAliasCT2)->LOTECT2 + (cAliasCT2)->SUBLOTE + (cAliasCT2)->DOCUMENT
				IF (cAliasCT2)->SALDO > 0
					nImpHaber:= (cAliasCT2)->SALDO
					nImpDebe:=0
				Else
					nImpDebe:= (cAliasCT2)->SALDO * (-1)
					nImpHaber:= 0
				EndIF

				AADD( aCuenta,	{(cAliasCT2)->CUENTA,;
								(cAliasCT2)->CUENTAD,;
								nImpDebe,;
								nImpHaber,;
								cFilCT2,;
								(cAliasCT2)->HISTORIAL,;
								cLote}) 
				(cAliasCT2)->(DbSkip())
			EndDo

			IF !Empty( aCuenta )
//				AADD( aDatos, {	FormatFecha( dFecha ), cSubLote, cSubLotD, aCuenta })
				AADD( aDatos, {	FormatFecha( dFecha ), cLote, cSubLotD, aCuenta, "2" })// Agregado Carlos Galvao - 14/06/2016})})
				aCuenta := {}
			EndIF
		EndIF
	EndDo

	Imprimo( aDatos, oReport )
	
	DbSelectArea( cAliasCT2 )
	DbCloseArea()	

Return( { nTotDeb, nTotCre } )


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FUNCION:	CabecLzb	|	FECHA:	05/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Cabecera especifica
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function Imprimo( aDatos, oReport )
Local aArea 	:= GetArea()
Local oSection1	:= oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local nX		:= 0
Local nJ		:= 0
Local nProxDoc	:= 0
Local nTotGDeb	:= 0
Local nTotGHab	:= 0
Local nTotDeb	:= 0
Local nTotHab	:= 0
Local nTotSaldo := 0
Local nTotSalGe := 0
Local nSaldo	:= 0

//Local cSubLote	:= ""

Local aCuenta  := {}

Default aDatos := {}

	nProxDoc := IIF(MV_PAR08=0,1,MV_PAR08)	// Default en 1 si esta en cero

	// Ordeno el array por fecha y sublote
    // aDatos := aSort( aDatos,,, {|x,y| x[N_FECHA] + x[N_SLOTE] < y[N_FECHA] + y[N_SLOTE] } )
	// ordena por numero de cuenta ale tk:0002433
	// aDatos := aSort( aDatos,,, {|x,y| x[N_CUENT]<y[N_CUENT] } )
	
	oSection1:Init()

	FOR nX := 1 To Len( aDatos )
		nTotSaldo := 0

		oSection1:Cell("CORRELAT"):SetBlock({|| aDatos[nX][N_FECHA] + OemToAnsi(" CORRELATIVO :") + STRZERO( nProxDoc, 6 ) + ' - LOTE: ' + aDatos[nX][N_SLOTE]  })
		oReport:SkipLine()
		oSection1:PrintLine()
		oSection2:Init()

		oSection2:Cell("SALDODIS"):Disable()
		oSection2:Cell("CDEBE"):Show()
		oSection2:Cell("CHABER"):Show()

		aCuenta := aClone( aDatos[nX][4] )

	    // aCuenta := aSort( aCuenta,,, {|x,y| x[3]-x[4] > y[3]-y[4] })
		// ordena por numero de cuenta ale tk:0002433
		aCuenta := aSort( aCuenta,,, {|x,y| x[1]< y[1]})

		FOR nJ := 1 To Len( aCuenta )
			nSaldo := aCuenta[nJ][N_DEBE] - aCuenta[nJ][N_HABER]

			oSection2:Cell("CUENTA"	):SetBlock( { || aCuenta[nJ][N_CUENT] })
			oSection2:Cell("DESCUENT"):SetBlock({ || aCuenta[nJ][N_DESCU] })

			IF nSaldo >= 0
				oSection2:Cell("CDEBE"	):Show()
				oSection2:Cell("CDEBE"	):SetBlock( { || nSaldo })
				
				oSection2:Cell("CHABER"):Hide()
				oSection2:Cell("CHABER"):SetBlock(	{ || ' ' })
				nTotDeb += nSaldo
				nTotGDeb+= nSaldo
			Else
				oSection2:Cell("CHABER"):Show()
				oSection2:Cell("CHABER"):SetBlock(	{ || nSaldo * (-1) })

				oSection2:Cell("CDEBE"):Hide()
				oSection2:Cell("CDEBE"):SetBlock( { || ' ' })
				nTotHab += nSaldo * (-1)
				nTotGHab+= nSaldo * (-1)
			EndIF

			oSection2:Cell("HISTORIA"):SetBlock({ || aCuenta[nJ][N_HISTO] })
			oSection2:Cell("SALDODIS"):SetBlock({|| ' ' })

			nTotSaldo+= nSaldo * (-1)
			nTotSalGe+= nSaldo * (-1)

			oSection2:PrintLine()
		Next nJ

		oSection2:Finish()

		oReport:SkipLine()

		oSection1:Cell("CORRELAT"):SetBlock({|| OemToAnsi('TOTAL CORRELATIVO :') + STRZERO( nProxDoc, 6 ) + ' - LOTE: ' + aDatos[nX][N_SLOTE]  })
		oReport:ThinLine()
		oSection1:PrintLine()

		oSection2:Init()
		oSection2:SetHeaderSection(.F.)	// No muestro la cabecera
		oSection2:Cell("CUENTA"):Hide()
		oSection2:Cell("DESCUENT"):Hide()
		oSection2:Cell("CDEBE"):Show()
		oSection2:Cell("CHABER"):Show() 
		oSection2:Cell("HISTORIA"):Hide()
		oSection2:Cell("SALDODIS"):Enable()

		oSection2:Cell("CUENTA"):SetBlock({|| ' ' })
		oSection2:Cell("DESCUENT"):SetBlock({|| ' ' })
		oSection2:Cell("CDEBE"):SetBlock({|| nTotDeb })
		oSection2:Cell("CHABER"):SetBlock({|| nTotHab })
		oSection2:Cell("HISTORIA"):SetBlock({|| ' ' })
		oSection2:Cell("SALDODIS"):SetBlock({|| nTotSaldo })
		oSection2:PrintLine()
		oSection2:Finish()

		oSection2:SetHeaderSection(.T.)	// Muestro la cabecera
		oSection2:Cell("CUENTA"):Show()
		oSection2:Cell("DESCUENT"):Show()
		oSection2:Cell("CDEBE"):Show()
		oSection2:Cell("CHABER"):Show()
		oSection2:Cell("HISTORIA"):Show()
		oSection2:Cell("SALDODIS"):Show()

	   //proximo documento, para renumerar segun parametro informado por el usuario en cada mes
		nProxDoc ++
		nTotDeb := 0
		nTotHab := 0
	Next nX

	oReport:SkipLine()

	oSection1:Cell("CORRELAT"):SetBlock({|| OemToAnsi('TOTAL GENERAL :' )})
	oSection1:PrintLine()

	oSection2:Init()
	oReport:ThinLine()
	oSection2:SetHeaderSection(.F.)	// No muestro la cabecera
	oSection2:Cell("CDEBE"):Show()
	oSection2:Cell("CHABER"):Show()
	oSection2:Cell("HISTORIA"):Enable()

	oSection2:Cell("CUENTA"):Hide()
	oSection2:Cell("DESCUENT"):Hide()
	oSection2:Cell("CDEBE"):SetBlock({|| nTotGDeb })
	oSection2:Cell("CHABER"):SetBlock({|| nTotGHab })
	oSection2:Cell("HISTORIA"):Hide()
	oSection2:Cell("SALDODIS"):SetBlock({|| nTotSalGe })
	oSection2:PrintLine()
	oSection2:Finish()
	oSection1:Finish()

RestArea(aArea)

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FUNCION:	CabecLzb	|	FECHA:	05/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Cabecera especifica
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function CabecLzb( cTitulo, oReport, oSection1, cNome, cTamanho )
	
	oReport:PrtLeft( AllTrim(SM0->M0_NOMECOM ))
	oReport:SkipLine()
	oReport:PrtLeft( AllTrim(SM0->M0_ENDCOB ))
	oReport:SkipLine()
	oReport:PrtLeft( "(" + SM0->M0_CEPCOB + ")" + " " + Alltrim(SM0->M0_CIDCOB) + " " + Alltrim(SM0->M0_BAIRCOB ))
	oReport:PrtCenter( cTitulo )
	oReport:PrtRight( 'Del ' + DtoC( mv_par01 ) + ' Al ' + DtoC( mv_par02 ))
	oReport:SkipLine()
	oReport:PrtRight( '                             De Suc: ' + MV_PAR10 + ' a Suc: ' + MV_PAR11 )
	oReport:SkipLine()
	oReport:PrtRight( '                                                                  Hoja: ' + StrZero( M_PAG, 4 ))
	oReport:SkipLine()
	oReport:FatLine()
	oReport:SkipLine()
	oReport:SkipLine()

	M_PAG++

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FUNCION:	FORMATFECHA	|	FECHA:	04/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Doy formato a la fecha.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function FormatFecha( dFecha )
Local nMes 		:= 0
Local nDia		:= 0
Local cFecMod	:= ""
Local cDiaMod 	:= ""
Local cMesMod 	:= ""

Default dFecha	:= CTOD("  /  /  ")

	IF ValType( dFecha ) != "D"
		Return dFecha
	EndIF

	nMes := Month( dFecha )
	nDia := Day( dFecha )

	IF nDia < 10
		cDiaMod := "0" + AllTrim( Str( Day( dFecha )))
	Else
		cDiaMod := AllTrim( Str( Day( dFecha )))
	EndIF

	IF nMes < 10
		cMesMod := "0" + AllTrim( Str( Month( dFecha )))
	Else
		cMesMod := AllTrim( Str( Month( dFecha )))
	EndIF

	cFecMod := cDiaMod + "/" + cMesMod + "/" + AllTrim( Str( Year( dFecha )))

Return cFecMod


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
PROGRAMA: 	ALCTB010	|	FUNCION:	FORMATFECHA	|	FECHA:	04/02/2016 	|	AUTOR:	alejandro Bianchino	|	Resta
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCI”N: Devuelve el Valor de una Clave de una Tabla en SX5.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
Static Function SX5des( cTabla, cClave )
Local aArea := GetArea()
Local cDesc	:= ""

SetPrvt("_ALIAS,CDESCRIPCION,")

	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + cTabla + cClave)
	cDesc := AllTrim( SX5->X5_DESCSPA )

RestArea(aArea)

Return cDesc


/*/
√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú√ú
¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±
¬±¬±√ö√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ç√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ç√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ç√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ç√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ç√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø¬±¬±
¬±¬±¬≥Funcion   ¬≥          ¬≥ Autor ¬≥ Marcelo Rodriguez     ¬≥ Data ¬≥ 05/01/05 ¬≥¬±¬±
¬±¬±√É√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ö√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ù√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ù√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ù√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ù√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬¥¬±¬±
¬±¬±¬≥Descrip.  ¬≥                                                            ¬≥¬±¬±
¬±¬±√É√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ö√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬¥¬±¬±
¬±¬±¬≥Parametros¬≥                                                            ¬≥¬±¬±
¬±¬±√É√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ö√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬¥¬±¬±
¬±¬±¬≥ Uso      ¬≥                                                            ¬≥¬±¬±
¬±¬±√Ä√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ù√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ô¬±¬±
¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±¬±
√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü√ü
/*/
Static Function ValidPerg( cPerg )
	Local aArea := GetArea()
	Local i     := 0
	Local j     := 0
	Local aRegs := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpEsp := {}

	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := Padr( cPerg, 10 )

	aHelpPor := {	"Ingrese los lotes que no desea ",;
					"agruparlos, para ingresar mas de uno ",;
					"debe estar separador por ; (punto y ",;
					"coma)"}

	aHelpEng := {	"Ingrese los lotes que no desea ",;
					"agruparlos, para ingresar mas de uno ",;
					"debe estar separador por ; (punto y ",;
					"coma)"}
 
	aHelpEsp := {	"Ingrese los lotes que no desea ",;
					"agruparlos, para ingresar mas de uno ",;
					"debe estar separador por ; (punto y ",;
					"coma)"}
/*
	PutSx1( cPerg,"01","De Fecha"				,"De Fecha"				,"De Fecha"					,"mv_ch1","D",08,0,0,"G","",""		,"","","MV_PAR01",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"02","A Fecha"				,"A Fecha"				,"A Fecha"					,"mv_ch2","D",08,0,0,"G","",""		,"","","MV_PAR02",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"03","Moneda"					,"Moneda"				,"Moneda"					,"mv_ch3","C",02,0,1,"G","","CTO"	,"","","MV_PAR03",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"04","Tipo Saldo"				,"Tipo Saldo"			,"Tipo Saldo"				,"mv_ch4","C",01,0,0,"G","","SLD"	,"","","MV_PAR04",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"05","Prox. Pag."				,"Prox. Pag."			,"Prox. Pag."				,"mv_ch5","N",10,0,0,"G","",""		,"","","MV_PAR05",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"06","De lote  "				,"De lote  "			,"De lote  "				,"mv_ch6","C",06,0,0,"G","",""		,"","","MV_PAR06",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"07","A lote "				,"A lote   "			,"A lote   "				,"mv_ch7","C",06,0,0,"G","",""		,"","","MV_PAR07",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"08","Prox. Doc."				,"Prox. Doc."			,"Prox. Doc."				,"mv_ch8","N",06,0,0,"G","",""		,"","","MV_PAR08",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"09","lote sin agrupar?:"	,"lote sin agrupar?:","lote sin agrupar?:	"	,"mv_ch9","C",20,0,1,"G","",""		,"","","MV_PAR09",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)
	PutSx1( cPerg,"10","Desde Sucursal?"		,"Desde Sucursal?"		,"Desde Sucursal?"			,"mv_cha","C",04,0,1,"G","","SM0"	,"","","MV_PAR10",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
	PutSx1( cPerg,"11","A Sucursal?"			,"A Sucursal?"			,"A Sucursal?"				,"mv_chb","C",04,0,1,"G","","SM0"	,"","","MV_PAR11",""	,""		,""		,"",""	,""		,""		,"","","","","","","","","",,,)
*/
	AADD(aRegs,{cPerg,"01","De Fecha  ","De Fecha  ","De Fecha  ","mv_ch1" ,"D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	AADD(aRegs,{cPerg,"02","A Fecha   ","A Fecha   ","A Fecha   ","mv_ch2" ,"D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	AADD(aRegs,{cPerg,"03","Moneda    ","Moneda    ","Moneda    ","mv_ch3" ,"C",02,0,1,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTO","","",""} )
	AADD(aRegs,{cPerg,"04","Tipo Saldo","Tipo Saldo","Tipo Saldo","mv_ch4" ,"C", 1,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","",""} )
	AADD(aRegs,{cPerg,"05","Prox. Pag.","Prox. Pag.","Prox. Pag.","mv_ch5" ,"N",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
	AADD(aRegs,{cPerg,"06","De lote   ","De lote   ","De lote   ","mv_ch6" ,"C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	AADD(aRegs,{cPerg,"07","A lote    ","A lote    ","A lote    ","mv_ch7" ,"C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	AADD(aRegs,{cPerg,"08","Prox. Doc.","Prox. Doc.","Prox. Doc.","mv_ch8" ,"N",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
	AADD(aRegs,{cPerg,"09","lote    sin agrupar?:","lote    sin agrupar?:","lote    sin agrupar?:","mv_ch9" ,"C",60,0,1,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
	AADD(aRegs,{cPerg,"10","Desde Sucursal?:","Desde Sucursal?:","Desde Sucursal?:","mv_cha" ,"C", 4,0,1,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",""} )
	AADD(aRegs,{cPerg,"11","Hasta Sucursal?:","Hasta Sucursal?:","Hasta Sucursal?:","mv_chb" ,"C", 4,0,1,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",""} )

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

	PutSX1Help("P" + cPerg + "09",aHelpPor,aHelpEng,aHelpEsp)

	RestArea( aArea )

Return
