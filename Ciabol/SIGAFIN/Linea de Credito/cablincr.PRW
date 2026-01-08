#include "protheus.ch"
#include "Birtdataset.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CPOWTECH  ³Nahim Terrazas		 º Data ³  24/01/18       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ dataset Detalle Fatura Invoice                			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ POWERTECH - Juritis				                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User_Dataset cablincr
	title "Cabecera Lin Crédito"
	description "Cabecera linea de crédito"
	PERGUNTE "LINECRED"

columns
	define column IMPLINCR 	type NUMERIC size 14  DECIMALS 2  label "IMPLINCR"
	define column IMPCAPOP  type NUMERIC size 14  DECIMALS 2  label "IMPCAPOP"
	define column IMPCONTI  type NUMERIC size 14  DECIMALS 2  label  "IMPCONTI"
	define column INICIOLI  type character size 10 label "INICIOLI"
	define column DATAVENC  type character size 10 label "DATAVENC"
	define column INMUEUSD  type NUMERIC size 14  DECIMALS 2 label "INMUEUSD"
	define column EQUIVEHI  type NUMERIC size 14  DECIMALS 2 label "EQUIVEHI"
	define column DFSASFAL  type NUMERIC size 14  DECIMALS 2 label "DFSASFAL"
	define column RELGAVSO  type NUMERIC size 14  DECIMALS 2 label "RELGAVSO"
	define column CODIGOLC  type character size 15 label "CODIGOLC"
	define column ESTADOLC  type character size 15 label "ESTADOLC"

define query "SELECT * FROM %WTable:1% "

process dataset
Local cWTabAlias
Local cTemp		:= getNextAlias()

Private cSerie     //Serie
Private dFechaIni  //Fecha inicio
Private dFechaFin  //Fecha Fin
Private cDoc  //Fecha Fin

cPar1 	:= self:execParamValue( "MV_PAR01" )
cPar2    := self:execParamValue( "MV_PAR02" )
cPar3   := self:execParamValue( "MV_PAR03" )
cPar4    := self:execParamValue( "MV_PAR04" )

	if cPar4 == 1 //boleta
		inAPLEMP :="BOL"
	elseif cPar4 == 2
		inAPLEMP := "POL"
	else
		inAPLEMP := "POL','BOL"
	ENDIF

	if ::isPreview()
	endif

	cWTabAlias := ::createWorkTable()

	cursorwait()


		BeginSql alias cTemp

		SELECT
			A6_UVLRLIN  IMPLINCR,
			(A6_UPRPRES/100) * A6_UVLRLIN IMPCAPOP,  
			A6_UVLRLIN IMPCONTI,
			A6_UFCILIN INICIOLI,
			A6_UFCFLIN DATAVENC,
			CASE A6_BLOCKED
			WHEN '1' THEN 'NO VIGENTE'
			WHEN '2' THEN 'VIGENTE'
			END ESTADOLC,
			A6_USINMU  INMUEUSD,
			A6_USDPF   DFSASFAL,
			A6_USMYV + A6_USVEI EQUIVEHI,
			isnull(A6_UVLRLIN /nullif((A6_USDPF+A6_USINMU+A6_USMYV+A6_USVEI), 0),0) RELGAVSO,
			A6_NUMCON CODIGOLC
			from %Table:SA6% SA6
		WHERE
		
		SA6.D_E_L_E_T_ = ' '
		and A6_COD = %exp:cPar1%
		and A6_AGENCIA = %exp:cPar2%
		and A6_NUMCON = %exp:cPar3%

		EndSql


cQuery:=GetLastQuery() 	
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"}) //  usar este en esste caso cuando es BEGIN SQL
//Aviso("",cQuery[2],{"Ok"},,,,,.T.)


		
//		TCSetField(cTemp,"F2_EMISSAO","D")

	cursorarrow()

	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())



		While (cTemp)->(!EOF())
			cEmissao	:= 		alltrim((cTemp)->INICIOLI)
			cAnho		:= 		SubStr(cEmissao, 1,4 )
			cMes		:= 		SubStr(cEmissao, 5,2 )
			cDia		:= 		SubStr(cEmissao, 7,2 )
			cEmissao	:= 		 cDia + "/" + cMes+ "/" + cAnho
			cEmiFin		:= 		alltrim((cTemp)->DATAVENC)
			cAnho		:= 		SubStr(cEmiFin, 1,4 )
			cMes		:= 		SubStr(cEmiFin, 5,2 )
			cDia		:= 		SubStr(cEmiFin, 7,2 )
			cEmiFin		:= 		 cDia + "/" + cMes+ "/" + cAnho

			RecLock(cWTabAlias, .T.)
			(cWTabAlias)->IMPLINCR := (cTemp)->IMPLINCR
			(cWTabAlias)->IMPCAPOP := xMoeda((cTemp)->IMPCAPOP,1,2,cEmissao,2) 	
			(cWTabAlias)->IMPCONTI := xMoeda((cTemp)->IMPLINCR,1,2,cEmissao,2) 			
			(cWTabAlias)->INICIOLI := cEmissao
			(cWTabAlias)->DATAVENC := cEmiFin
			(cWTabAlias)->INMUEUSD := xMoeda((cTemp)->INMUEUSD,1,2,cEmissao,2)
			(cWTabAlias)->EQUIVEHI := xMoeda((cTemp)->EQUIVEHI,1,2,cEmissao,2)
			(cWTabAlias)->DFSASFAL := xMoeda((cTemp)->DFSASFAL,1,2,cEmissao,2)
			(cWTabAlias)->RELGAVSO := (cTemp)->RELGAVSO
			(cWTabAlias)->CODIGOLC := (cTemp)->CODIGOLC
			(cWTabAlias)->ESTADOLC := (cTemp)->ESTADOLC

			(cWTabAlias)->(MsUnlock())
			(cTemp)->(dbSkip())
		EndDo

return .T.
