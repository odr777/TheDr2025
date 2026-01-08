#include 'protheus.ch'
#include 'parmtype.ch'

#define NOPCNO	1
#define NOPCSI	2
#define CROTFIN	'FIN'
#define CROTFOL	'FOL'
#define CTIPO3	'R'

#define CTPINGR	'1'
#define CTPDESC	'2'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPEM040 ณDenar Terrazas				   บ Data ณ 09/01/2020บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Punto de entrada para: 							          บฑฑ
ฑฑบ          ณ 1. Separar el pago del finiquito.                          บฑฑ
ฑฑบ          ณ    Separa los conceptos de FOL y FIN segun                 บฑฑ
ฑฑบ          ณ    el campo RV_XFOLFIN                                     บฑฑ
ฑฑบ          ณ 2. Borrar los datos generados por el cแlculo de FOL, al    บฑฑ
ฑฑบ          ณ    momento de incluir y/o eliminar una rescisi๓n.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ                                                            บฑฑ
ฑฑฬออออออออออุอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TdeP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function GPEM040()
	Local aParam	:= PARAMIXB
	Local xRet		:= .T.
	Local oObj		:= ''
	Local cIdPonto	:= ''
	Local cIdModel	:= ''
	Private cFOLSuel:= FGETCODFOL("0031")
	Private cFINSuel:= FGETCODFOL("0048")
	Private cFOLLiq	:= FGETCODFOL("0047")
	Private cFINLiq	:= FGETCODFOL("0126")

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		If cIdPonto == 'MODELCOMMITTTS'
			If oObj:NOPERATION == 3
				deleteSRC(SRG->RG_FILIAL, SRG->RG_MAT, SRG->RG_PERIODO, SRG->RG_SEMANA)
				GPFOLFIN(SRG->RG_FILIAL, SRG->RG_MAT)
			endIf
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			If oObj:NOPERATION == 5
				deleteSRC(SRG->RG_FILIAL, SRG->RG_MAT, SRG->RG_PERIODO, SRG->RG_SEMANA)
			endIf
		EndIf

	EndIf

return xRet

/**
*
* @author: Denar Terrazas Parada
* @since: 08/01/2020
* @description: Programa para separar los conceptos de FOL y FIN en el proceso de rescici๓n
* @Module: SIGAGPE
*
*/
static function GPFOLFIN(cSucursal, cMat)
	Local nOpcAviso
	Local cTitulo	:= "Generaci๓n de Rescisi๓n"
	nOpcAviso:= Aviso(cTitulo,'SI = El sueldo se paga por separado en la planilla.' + CRLF ;
		+'NO = El sueldo forma parte del finiquito.' + CRLF + CRLF ;
		+'Nota: Para separar los conceptos a la planilla se considera el campo "Proceso Finiquito" (RV_XFOLFIN).',{'No', 'Si'})
	MsgRun("Ejecutando proceso...","Espere",{|| updateSRR(cSucursal, cMat, nOpcAviso) })
	Aviso(cTitulo,"Proceso ejecutado con ้xito!",{'Ok'})
return

/**
*
* @author: Denar Terrazas Parada
* @since: 08/01/2020
* @description: Funcion que actualiza el campo RR_XFOLFIN con los datos del campo RV_XFOLFIN
*				Cuando se quiere separar el pago de la boleta con el del finiquito
*
*/
static function updateSRR(cSucursal, cMat, nOpcAviso)
	Local aArea		:= getArea()
	Local cFolFin	:= ""
	Local nIngrFOL	:= 0
	Local nDescFOL	:= 0
	Local nIngrFIN	:= 0
	Local nDescFIN	:= 0
	Local nLiqFOL	:= 0
	Local nLiqFIN	:= 0
	Local aRecLock	:= ARRAY(16)
	dbSelectArea("SRR")
	SRR->( dbSetOrder(1) )//RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)+RR_PD+RR_CC
	SRR->( dbSeek(cSucursal + cMat + CTIPO3) )
	while ( SRR->(!Eof()) .AND. (cSucursal + cMat + CTIPO3) == SRR->(RR_FILIAL+RR_MAT+RR_TIPO3))
		cFolFin:= TRIM(Posicione("SRV", 1, xFilial("SRV") + SRR->RR_PD, "SRV->RV_XFOLFIN"))//RV_FILIAL+RV_COD
		cFolFin:= iif(EMPTY(cFolFin), CROTFIN, cFolFin)
		IF( nOpcAviso == NOPCNO)
			RECLOCK("SRR", .F.)
			SRR->RR_XFOLFIN	:= CROTFIN
			SRR->( MSUNLOCK() )
		ELSE
			IF(cFolFin == CROTFOL .OR. SRR->RR_PD == cFINSuel)
				If(SRV->RV_TIPOCOD == CTPINGR)
					nIngrFOL += SRR->RR_VALOR
				ElseIf(SRV->RV_TIPOCOD == CTPDESC)
					nDescFOL += SRR->RR_VALOR
				EndIf
			endIf
			IF(cFolFin == CROTFIN)
				If(SRV->RV_TIPOCOD == CTPINGR)
					nIngrFIN += SRR->RR_VALOR
				ElseIf(SRV->RV_TIPOCOD == CTPDESC)
					nDescFIN += SRR->RR_VALOR
				EndIf
			endIf
			RECLOCK("SRR", .F.)
			SRR->RR_XFOLFIN	:= cFolFin
			If (SRR->RR_PD == cFINSuel)
				SRR->RR_PD 		:= cFOLSuel
				SRR->RR_XFOLFIN	:= CROTFOL
			EndIf
			If(SRR->RR_PD == cFINLiq)
				nLiqFOL:= nIngrFOL - nDescFOL
				nLiqFIN:= nIngrFIN - nDescFIN
				SRR->RR_VALOR	:= nLiqFIN
				aRecLock[1]:= SRR->RR_FILIAL
				aRecLock[2]:= SRR->RR_MAT
				aRecLock[3]:= cFOLLiq
				aRecLock[4]:= SRR->RR_TIPO1
				aRecLock[5]:= SRR->RR_HORAS
				If(nLiqFOL < 0)
					aRecLock[6]:= 0
				Else
					aRecLock[6]:= nLiqFOL
				EndIf
				aRecLock[7]:= SRR->RR_TIPO2
				aRecLock[8]:= SRR->RR_DATA
				aRecLock[9]:= SRR->RR_TIPO3
				aRecLock[10]:= SRR->RR_PERIODO
				aRecLock[11]:= SRR->RR_ROTEIR
				aRecLock[12]:= SRR->RR_SEMANA
				aRecLock[13]:= SRR->RR_DATAPAG
				aRecLock[14]:= SRR->RR_CC
				aRecLock[15]:= SRR->RR_PROCES
				aRecLock[16]:= CROTFOL
			EndIf
			SRR->( MSUNLOCK() )
		EndIf
		SRR->(dbSkip())
	End
	SRR->(dbCloseArea())
	if(nOpcAviso == NOPCSI)
		if(!EMPTY(aRecLock[1]))
			dbSelectArea("SRR")
			RECLOCK("SRR", .T.)
			SRR->RR_FILIAL	:= aRecLock[1]
			SRR->RR_MAT		:= aRecLock[2]
			SRR->RR_PD		:= aRecLock[3]
			SRR->RR_TIPO1	:= aRecLock[4]
			SRR->RR_HORAS	:= aRecLock[5]
			SRR->RR_VALOR	:= aRecLock[6]
			SRR->RR_TIPO2	:= aRecLock[7]
			SRR->RR_DATA	:= aRecLock[8]
			SRR->RR_TIPO3	:= aRecLock[9]
			SRR->RR_PERIODO	:= aRecLock[10]
			SRR->RR_ROTEIR	:= aRecLock[11]
			SRR->RR_SEMANA	:= aRecLock[12]
			SRR->RR_DATAPAG	:= aRecLock[13]
			SRR->RR_CC		:= aRecLock[14]
			SRR->RR_PROCES	:= aRecLock[15]
			SRR->RR_XFOLFIN	:= aRecLock[16]
			SRR->( MSUNLOCK() )
			SRR->(dbCloseArea())

			If(nLiqFOL < 0 .AND. !existIns0045())//Si el concepto de lํquido es negativo y NO existe el concepto de insuficiencia
				insertIns0045(nLiqFOL, aRecLock)
			EndIf
		EndIf
	EndIf

	restArea(aArea)
return

/**
*
* @author: Denar Terrazas Parada
* @since: 05/04/2021
* @description: Funcion que indica si el concepto de insuficiencia ya existe o NO
*				CODFOL 0045 = Insuficiencia de Sueldo
*/
static function existIns0045()
	Local aArea	:= getArea()
	Local c0045	:= FGETCODFOL("0045") //Insuficiencia de Sueldo
	Local lRet	:= .F.

	dbSelectArea("SRR")
	dbSetOrder(5)//RR_FILIAL+RR_MAT+DTOS(RR_DATAPAG)+RR_PD
	If(dbSeek(SRG->RG_FILIAL + SRG->RG_MAT + DTOS(SRG->RG_DATADEM) + c0045))
		lRet	:= .T.
	EndIf
	dbCloseArea()
	restArea(aArea)

return lRet

/**
*
* @author: Denar Terrazas Parada
* @since: 05/04/2021
* @description: Funcion para insertar el concepto de Insuficiencia en caso de que el lํquido pagable sea negativo
*				CODFOL 0045 = Insuficiencia de Sueldo
*/
static function insertIns0045(nLiqFOL, aRecLock)
	Local aArea	:= getArea()
	Local c0045	:= FGETCODFOL("0045") //Insuficiencia de Sueldo

	cRV_TIPO	:= GetAdvFVal("SRV", "RV_TIPO", xFilial("SRV") + c0045, 1, "V")//RV_FILIAL+RV_COD
	cRR_XFOLFIN	:= GetAdvFVal("SRV", "RV_XFOLFIN", xFilial("SRV") + c0045, 1, "FIN")//RV_FILIAL+RV_COD

	dbSelectArea("SRR")
	RECLOCK("SRR", .T.)
	SRR->RR_FILIAL	:= aRecLock[1]
	SRR->RR_MAT		:= aRecLock[2]
	SRR->RR_PD		:= c0045
	SRR->RR_TIPO1	:= cRV_TIPO
	SRR->RR_HORAS	:= 0
	SRR->RR_VALOR	:= (nLiqFOL * -1)
	SRR->RR_TIPO2	:= aRecLock[7]
	SRR->RR_DATA	:= aRecLock[8]
	SRR->RR_TIPO3	:= aRecLock[9]
	SRR->RR_PERIODO	:= aRecLock[10]
	SRR->RR_ROTEIR	:= aRecLock[11]
	SRR->RR_SEMANA	:= aRecLock[12]
	SRR->RR_DATAPAG	:= aRecLock[13]
	SRR->RR_CC		:= aRecLock[14]
	SRR->RR_PROCES	:= aRecLock[15]
	SRR->RR_XFOLFIN	:= cRR_XFOLFIN
	SRR->( MSUNLOCK() )
	SRR->(dbCloseArea())

	restArea(aArea)

return

/**
*
* @author: Denar Terrazas Parada
* @since: 03/08/2021
* @description: Funcion para borrar los cแlculos de Planilla(FOL)
*/
Static Function deleteSRC(cFil, cMat, cPeriodo, cSemana)
	Local aArea		:= getArea()
	Local cQryUpd	:= ""

	Begin Transaction
		//Crea el update
		cQryUpd += " UPDATE " + RetSqlName("SRC")
		cQryUpd += " SET D_E_L_E_T_ = '*',"
		cQryUpd += " R_E_C_D_E_L_ = R_E_C_N_O_,"
		cQryUpd += " RC_CONVOC = '900'"
		cQryUpd += " WHERE RC_FILIAL = '" + cFil + "'"
		cQryUpd += " AND RC_MAT = '" + cMat + "'"
		cQryUpd += " AND RC_ROTEIR IN ('FOL', 'FIN')"
		cQryUpd += " AND RC_TIPO2 NOT IN ('E')"
		cQryUpd += " AND RC_PERIODO = '" + cPeriodo + "'"
		cQryUpd += " AND RC_SEMANA = '" + cSemana + "'"
		cQryUpd += " AND D_E_L_E_T_ = ' '"

		//Intenta ejecutar el update
		nErro := TcSqlExec(cQryUpd)

		//Se hubo error, muestra un mensaje y cancela la transacci๓n
		If nErro != 0
			MsgStop("Error al ejecutar el query en el P.E. GPEM040, funci๓n 'deleteSRC': "+TcSqlError(), "Atenci๓n")
			DisarmTransaction()
		EndIf

	End Transaction

	restArea(aArea)
Return
