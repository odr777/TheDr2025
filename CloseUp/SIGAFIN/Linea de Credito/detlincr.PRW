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



User_Dataset detlincr
	title "Detalle Lin Crédito"
	description "Detalle linea de crédito"
	PERGUNTE "LINECRED"

columns
	define column NOMBENT 	type character size 30   label "Nombre Entidad"
	define column GRUPO  	type character size 30   label "Grupo"
	define column NROPERA   type character size 20  label "Nro de Operacion"
	define column DESCRIPC  type character size 20   label "Descripcion"
	define column DDATEINI  type character size 10   	label 	"DDATEINI"
	define column DDATEFIN  type character size 10   	label 	"DDATEFIN"
	define column DESTINO   type character size 30   label "DESTINO"
	define column TOTALREP  type NUMERIC size 14  DECIMALS 2 label "TOTALREP"

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
			A6_UFCILIN,
			A6_UVLRLIN,
			ZEH_DATA,
			EH_DATA,
			ZE1_DDEP,
			A6_COD  Banco,
			A6_AGENCIA      AgBco,
			A6_NUMCON  Codigo,
			A6_NREDUZ      ENTIDAD,
			A6_NOME          Nombre,
			isnull(EH_OPERAC,'-')       Nro,
			isnull(EH_DATA,'-')  FechaInicio,
			isnull(EH_DATARES,'-')  FechaFin,
			isnull(EH_MOEDA,0)      Moneda,
			A6_UVLRLIN      Monto,
			A6_UVLRLIN      MontoDólares ,
			isnull(EH_TARIFA,0)         Comisión,
			isnull(EH_TAXA,0)   Tasa ,
			A6_UPOROP   '%C.Op.',
			(A6_UPOROP/100) * A6_UVLRLIN  'MontoCOpUSD' ,
			A6_UTIPLIN       Objeto,
			CASE A6_UTIPLIN
			WHEN 'PR' THEN 'PRESTAMOS'
			WHEN 'CT' THEN 'CONTNGENCIAS'
			WHEN 'AM' THEN 'PRESTAMOS Y CONTINGENCIAS'
			ELSE 'CR'
		END Descripcion,
		isnull((SUMEH_VALOR + SUMZE1_VAL) - ZEH_VALOR,0) Utilizacion ,
		ZEH_VALOR,
		A6_USDPF          DPFsyAsfaltos,
		A6_USINMU      Inmuebles,
		A6_USMYV        MaqVehículos,
		A6_USDPF +A6_USINMU+A6_USMYV       TotalGarantías,
		isnull(A6_UVLRLIN -(SUMEH_VALOR + SUMZE1_VAL) - ZEH_VALOR,0)  Saldo,
		isnull(A6_UVLRLIN /nullif((A6_USDPF+A6_USINMU+A6_USMYV), 0),0)   RelacionTotLineavsGarantias  ,
		EH_UTPTRAN    codTipo1,
		EH_UGRUPO      codGrupo1,
		EH_UGRUPO,
		EH_UDESTRA      destino1,
		EH_OPERAC      operación1,
		ZEH_UTPTRA     codTipo2,
		ZEH_UGRUPO     codGrupo2,
		ZEH_UDESTR    destino2,
		ZEH_OPERAC      operación2,
		isnull(SUMZE1_VAL,0) SUMZE1_VAL,
		isnull(SUMEH_VALOR,0) SUMEH_VALOR,
		isnull(ZEH_VALOR,0) ZEH_VALOR,
		CASE isnull(EH_UGRUPO,' ')
		WHEN 'PR' THEN A6_UVLRLIN -(SUMEH_VALOR + SUMZE1_VAL) - ZEH_VALOR
		WHEN 'BOL' THEN 0
		WHEN 'POL' THEN 0
		else 0
		END SaldoLinea,
		CASE EH_UGRUPO
		WHEN 'PR' THEN 0
		WHEN 'BOL' THEN A6_UVLRLIN -(SUMEH_VALOR + SUMZE1_VAL)
		WHEN 'POL' THEN 0
		else 0
		END SaldoOtros,
		3*A6_USDPF+2*A6_USINMU+A6_USMYV MontoRel321,
		CASE isnull(EH_UGRUPO,' ')
		WHEN 'PRE' THEN A6_UVLRLIN-(3*A6_USDPF+2*A6_USINMU+A6_USMYV)
		ELSE 0
		END DifRel,
		isnull(SUMEH_VALOR - SUMZEH_VALOR,0) UtilPrestamos,
		isnull(SUMZEH_VALOR,0) as UtilOtros,
		CASE A6_BLOCKED
		WHEN '1' THEN 'NO VIGENTE'
		WHEN '2' THEN 'VIGENTE'
		END DifRel
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
		AND SEH.D_E_L_E_T_ = ' '
		left join
		%Table:ZE1% ZE1
		on ZE1_BANCO = A6_COD
		AND   ZE1_AGENCI = A6_AGENCIA
		AND   ZE1_CONTAB = A6_NUMCON
		AND   ZE1_NORDIC  = EH_NUMERO
		AND ZE1.D_E_L_E_T_ = ' '
		left join
		%Table:ZEH% ZEH
		on ZEH_BANCO = A6_COD
		AND   ZEH_AGENCI = A6_AGENCIA
		AND   ZEH_CONTA = A6_NUMCON
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

		EndSql


cQuery:=GetLastQuery() 	
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"}) //  usar este en esste caso cuando es BEGIN SQL
//Aviso("",cQuery[2],{"Ok"},,,,,.T.)


		
//		TCSetField(cTemp,"F2_EMISSAO","D")

	cursorarrow()

	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())


		While (cTemp)->(!EOF())
			cEmissao	:= 		alltrim((cTemp)->FECHAINICIO)
			cAnho		:= 		SubStr(cEmissao, 1,4 )
			cMes		:= 		SubStr(cEmissao, 5,2 )
			cDia		:= 		SubStr(cEmissao, 7,2 )
			cEmissao	:= 		 cDia + "/" + cMes+ "/" + cAnho

			cEmiFin		:= 		alltrim((cTemp)->FECHAINICIO)
			cAnho		:= 		SubStr(cEmiFin, 1,4 )
			cMes		:= 		SubStr(cEmiFin, 5,2 )
			cDia		:= 		SubStr(cEmiFin, 7,2 )
			cEmiFin		:= 		 cDia + "/" + cMes+ "/" + cAnho

			RecLock(cWTabAlias, .T.)

				(cWTabAlias)->GRUPO := (cTemp)->EH_UGRUPO
				(cWTabAlias)->NOMBENT := (cTemp)->ENTIDAD
				(cWTabAlias)->NROPERA := (cTemp)->NRO
				(cWTabAlias)->DESCRIPC := (cTemp)->DESCRIPCION
				(cWTabAlias)->DDATEINI := cEmissao
				(cWTabAlias)->DDATEFIN := cEmiFin
				(cWTabAlias)->DESTINO := (cTemp)->NOMBRE
				(cWTabAlias)->TOTALREP := (cTemp)->ZEH_VALOR

			(cWTabAlias)->(MsUnlock())
			(cTemp)->(dbSkip())
		EndDo

return .T.
