#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE CPDRET "995"//Concepto Liquido Retroactivo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SUMASRD ºAutor  ³FRANZ BASCOPE          ºFecha ³  22/09/17 º±±
±±ºPrograma  ³ SUMASRD ºAutor  ³DENAR TERRAZAS         ºFecha ³  22/09/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que suma los retroactivos de remuneracion 		  º±±
±±º          ³ y los Resta con los retractivos de descuento de AFPs 	  º±±
±±º          ³ e inserta su diferencia en ls SRC por cada empleado        º±±
±±º          ³ C__ROTEIRO -> Procedimiento que se está procesando		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function IVA(cRA_FILIAL, cRA_MAT)
	Local aArea	:= getArea()
	Local nCont := 1
	Local nSuma := 0
	Local nResta := 0
	Local nResultado := 0
	Local cPerActual := CPERIODO//Periodo que se está procesando
	Local aPdAfpSol := {}
	Local AFP1 := 0
	Local AFP2 := 0
	Local AFP3 := 0
	Local nAnho:= val(SUBSTR(cPerActual, 1, 4))-1
	Local nRCIVA:= 0
	Private dDataRef:= LastDate(STOD(cPerActual + "01"))//Ultimo dia del mes
	dbSelectArea("RCC")
	dbsetorder(1)
	WHILE !EOF()
		if( RCC_CODIGO =='S011' )
			aadd(aPdAfpSol,RCC_CONTEU)
		ENDIF
		dbskip()
	enddo
	dbclosearea()
	AFP1 := SUBSTRING(aPdAfpSol[1],23,25)
	AFP2 := SUBSTRING(aPdAfpSol[2],23,25)
	AFP3 := SUBSTRING(aPdAfpSol[3],23,25)
	cAfp1 := FGETCODFOL("0728")
	cAfp2 := FGETCODFOL("0729")
	cAfp3 := FGETCODFOL("0730")
	cAfp4 := FGETCODFOL("1228")

	dbSelectArea("SRC")
	dbsetorder(4)//RC_FILIAL+RC_MAT+RC_PERIODO+RC_ROTEIR+RC_SEMANA+RC_PD
	dbSeek(cRA_FILIAL + cRA_MAT + cPerActual + C__ROTEIRO)
	WHILE !EOF() .AND. SRC->RC_MAT == cRA_MAT .AND. SRC->RC_FILIAL == cRA_FILIAL;
			.AND. SRC->RC_PERIODO == cPerActual .AND. SRC->RC_ROTEIR == C__ROTEIRO

		cTipoCod:= GetAdvFVal("SRV", "RV_TIPOCOD", xFilial("SRV") + RC_PD ,1,"")//RV_FILIAL+RV_COD
		If cTipoCod == '1'
			nSuma += RC_VALOR
		endif

		IF(RC_PD == CVALTOCHAR(ALLTRIM(AFP1)) .OR. RC_PD == CVALTOCHAR(ALLTRIM(AFP2));
				.OR. RC_PD == CVALTOCHAR(ALLTRIM(AFP3)) .OR. RC_PD == cAfp1 .OR. RC_PD == cAfp2;
				.OR. RC_PD == cAfp3 .OR. RC_PD == cAfp4)
			nResta += RC_VALOR
		endif
		dbskip()
	ENDDO
	nResultado := nSuma - nResta
	cCC		:= GetAdvFVal("SRA", "RA_CC", cRA_FILIAL + cRA_MAT, 1, "")
	dDemissa:= GetAdvFVal("SRA", "RA_DEMISSA", cRA_FILIAL + cRA_MAT, 1, CTOD("  /  /    "))
	//dAdmissa:= Posicione("SRA",1,cRA_FILIAL+cRA_MAT,"RA_ADMISSA")
	//nAdmision := val(SUBSTR(DToC(dAdmissa),7))
	IF (nResultado > 0) //.AND. (nAdmision <= nAnho)
		insert(cRA_FILIAL, cRA_MAT, cPerActual, FGETCODFOL("0015"), cCC, nResultado)//RC-IVA/ BASE
		If(!Empty(dDemissa))//Si el funcionario está despedido
			nPerDemissa	:= VAL(SUBSTR(DTOS(dDemissa), 1, 6))//Periodo de despido en numérico
			nPerRet		:= VAL(cPerActual)//Periodo que se está procesando en numérico
			If( nPerDemissa < nPerRet)//Si fue despedido en un periodo anterior al que se calcula retroactivo
				nRCIVA:= nResultado * (13 / 100)
				nRCIVA:= ROUND(nRCIVA, 2)
				insert(cRA_FILIAL, cRA_MAT, cPerActual, FGETCODFOL("0067"), cCC, nRCIVA)//RC-IVA VACACIONES/PRIMAS/ETC
			EndIf
		EndIf
		nResultado:= nResultado - nRCIVA
		nResultado:= ROUND(nResultado, 2)
		insert(cRA_FILIAL, cRA_MAT, cPerActual, CPDRET, cCC, nResultado)//Liquido Retroactivo
	endif
	DBCLOSEAREA()

	nCont ++
	nSuma := 0
	nResta := 0
	nResultado := 0
	RestArea(aArea)
return

/**
* @author: Denar Terrazas Parada
* @since: 19/03/2018
* @description: Funcion que inserta los datos enviados en los parámetros en la tabla SRC
*/
static function insert(cFil, cMat, cPerActual, cPd, cCC, nResultado)
	Local aArea := getArea()
	//dbSelectArea("SRC")
	ReClock ( "SRC",.T.)
	SRC-> RC_FILIAL	:= cFil
	SRC-> RC_MAT	:= cMat
	SRC-> RC_PERIODO:= cPerActual
	SRC-> RC_PD		:= cPd
	SRC-> RC_CC		:= cCC
	SRC-> RC_VALOR	:= nResultado
	SRC-> RC_ROTEIR	:= C__ROTEIRO//C__ROTEIRO -> Procedimiento que se está procesando
	SRC-> RC_PROCES	:= CPROCESSO
	SRC-> RC_SEMANA	:= CNUMPAG
	SRC-> RC_DTREF	:= dDataRef
	SRC-> RC_DATA	:= dDataRef
	MSUNLOCK()
	//dbCloseArea()
	restArea(aArea)
return
