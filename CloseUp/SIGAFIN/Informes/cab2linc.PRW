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



User_Dataset cab2linc
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
			DECODE (EH_UGRUPO, 'PRE',0,'BOL',A6_UVLRLIN -(SUM(EH_VALOR) + SUM(ZE1_VAL)) - SUM(ZEH_VALOR),'POL',0)	SALDPAGO,
			DECODE (EH_UGRUPO, 'PRE',A6_UVLRLIN -(SUM(EH_VALOR) + SUM(ZE1_VAL)) - SUM(ZEH_VALOR),'BOL',0,'POL',0) SALDCAOP
			
			from %Table:SA6% SA6
			left join
			%table:SEH% SEH
			on EH_BANCO = A6_COD
			and EH_AGENCIA = A6_AGENCIA
			AND EH_CONTA = A6_NUMCON
			AND SEH.D_E_L_E_T_ = ' '
			left join
			%Table:ZE1% ZE1
			on ZE1_BANCO = A6_COD
			AND   ZE1_AGENCI = A6_AGENCIA
			AND   ZE1_CONTAB = A6_NUMCON
			AND ZE1.D_E_L_E_T_ = ' '
			AND   ZE1_NORDIC  = EH_NUMERO
			left join
			%Table:ZEH% ZEH
			on ZEH_BANCO = A6_COD
			AND   ZEH_AGENCI = A6_AGENCIA
			AND   ZEH_CONTA = A6_NUMCON
			AND ZEH.D_E_L_E_T_ = ' '
			left join (
			SELECT
			A6_COD CODBAN,A6_AGENCIA AGENCIA ,A6_NUMCON CUENTA,
			SUM(EH_VALOR) SUMEH_VALOR,
			SUM(ZE1_VAL) SUMZE1_VAL,
			SUM(ZEH_VALOR) SUMZEH_VALOR
			from %Table:SA6% SA6
			left join
			%Table:SEH% SEH
			on EH_BANCO = A6_COD
			and EH_AGENCIA = A6_AGENCIA
			AND  EH_CONTA = A6_NUMCON
			AND EH_FILIAL = A6_FILIAL
			AND SEH.D_E_L_E_T_ = ' '
			left join
			%Table:ZE1% ZE1
			on ZE1_BANCO = A6_COD
			AND   ZE1_AGENCI = A6_AGENCIA
			AND   ZE1_CONTAB = A6_NUMCON
			AND   ZE1_NORDIC  = EH_NUMERO
			AND ZE1_FILIAL = A6_FILIAL
			AND ZE1.D_E_L_E_T_ = ' '
			left join
			%Table:ZEH% ZEH
			on ZEH_BANCO = A6_COD
			AND   ZEH_AGENCI = A6_AGENCIA
			AND   ZEH_CONTA = A6_NUMCON
			AND ZEH_FILIAL = A6_FILIAL
			AND ZEH.D_E_L_E_T_ = ' '
			group by A6_COD, A6_AGENCIA,A6_NUMCON) SUMATORIA
			on CODBAN = A6_COD
			AND   AGENCIA = A6_AGENCIA
			AND   CUENTA = A6_NUMCON
			WHERE
			SA6.D_E_L_E_T_ = ' '
			and A6_COD = %exp:cPar1%
			and A6_AGENCIA = %exp:cPar2%
			and A6_NUMCON = %exp:cPar3%
			and EH_APLEMP = 'EMP'
			AND   ZE1_ESTADO = '3'
			and ZEH_APLEMP in (%exp:inAPLEMP%)
			
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
			(cWTabAlias)->IMPCAPOP := (cTemp)->IMPCAPOP
			(cWTabAlias)->IMPCONTI := (cTemp)->IMPCONTI
			(cWTabAlias)->INICIOLI := cEmissao
			(cWTabAlias)->DATAVENC := cEmiFin
			(cWTabAlias)->INMUEUSD := (cTemp)->INMUEUSD
			(cWTabAlias)->EQUIVEHI := (cTemp)->EQUIVEHI
			(cWTabAlias)->DFSASFAL := (cTemp)->DFSASFAL
			(cWTabAlias)->RELGAVSO := (cTemp)->RELGAVSO
			(cWTabAlias)->CODIGOLC := (cTemp)->CODIGOLC
			(cWTabAlias)->ESTADOLC := (cTemp)->ESTADOLC

			(cWTabAlias)->(MsUnlock())
			(cTemp)->(dbSkip())
		EndDo

return .T.
