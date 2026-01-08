#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include 'protheus.ch'
#Include "Parmtype.ch"
#Include "RWMAKE.CH"

//PE

user function FIN171

	Private cNat := PADR("",TamSx3("E5_NATUREZ")[1]) // CUENTA CONTABLE BCO
	Private cBanco := Space(TamSx3("E5_BANCO")[1])
	Private cAgencia := Space(TamSx3("E5_AGENCIA")[1])
	Private cContab := Space(TamSx3("E5_CONTA")[1])

	/////////////// CREA PRESTAMOS LAS CUOTAS//////////////////////////

	if SEH->EH_APLEMP == 'EMP' //.and. MsgYesNo("Desea generar y registrar el plan de pagos?","Inclusión de Plan de Pagos")
		cAlias := "ZE1"
		cNumero := GETSXENUM( cAlias, "ZE1_NRO", cAlias, 1 )

		nTotCuot := SEH->EH_UCUOTAS  // crear campo N de 2

		cBanco   := SEH->EH_BANCO
		cAgencia := SEH->EH_AGENCIA
		cContab  := SEH->EH_CONTA
		cOPer    :=  SEH->EH_NUMERO  // Nro de prestamo
		nTasaInt := Round(SEH->EH_TAXA/100,2) // Tasa Nominal

		//////////////////////////SEH->EH_NOPER // ver si es necesario crear campo caracter C 12
		nValCuot   := Round(SEH->EH_VALOR/nTotCuot,2) /// eh_valor parece que ya esta en dolares
		nMoneda    := SEH->EH_MOEDA
		nValCuotBs := Round(SEH->EH_VLCRUZ/nTotCuot,2)   //eh vl cruz es en bolivianos ya
		//nIntBs     := Round(nValCuotBs*nTasaInt,2)
		//nInteres   :=Round(nValCuot*nTasaInt,2)
		cPrefixo   := 'PEM'
		cNat       := 'PAG.PREST.'//SEH->EH_NATUREZ
		dDataEmis  := SEH->EH_DATA
		cContrato  := SEH->EH_CONTRA
		nTasa      := RecMoeda(dDataEmis,StrZero(nMoneda,2))

		dbSelectArea(cAlias)
		dbSetOrder(1)

		nValActcuo := SEH->EH_VLCRUZ  ///bolis
		nValAcumo := SEH->EH_VALOR   //moneda corriente
		dPagAnt := SEH->EH_DATA
		for i:= 1 to nTotCuot

			nDiasInt := ((i*30*(12/nTotCuot)))+1 //DIAS PARA CUOTA A CUOTA

			RecLock(cAlias, .T.)

			(cAlias)->ZE1_FILIAL := xFilial(cAlias)
			(cAlias)->ZE1_NRO	:= cNumero  // NRO DE PLAN DE PAGOS
			(cAlias)->ZE1_DREG	:= dDatabase
			(cAlias)->ZE1_USR	:= cUserName
			(cAlias)->ZE1_BANCO  := cBanco    // BANCO
			(cAlias)->ZE1_AGENCI := cAgencia  // AGENCIA BANCO
			(cAlias)->ZE1_CONTAB := cContab   // CUENTA BANCARIA
			(cAlias)->ZE1_NORDIC := cOper    // NRO DE PRESTAMO
			(cAlias)->ZE1_VALBS  := nValCuotBs // VALOR CAPITA EN BS
			(cAlias)->ZE1_VAL    := nValCuot // VALOR CAPITAL moneda corriente
			(cAlias)->ZE1_INTBS   := ((nValActcuo*nTasaInt)/SEH->EH_UOPPLAZ) * DateDiffDay( dPagAnt , dDataEmis  +((i*30*(12/nTotCuot)))+1 )//nDiasInt  //nIntBs // VALOR CUOTA EN BS
			(cAlias)->ZE1_INT     := ((nValAcumo*nTasaInt)/SEH->EH_UOPPLAZ)*  DateDiffDay( dPagAnt , dDataEmis  +((i*30*(12/nTotCuot)))+1 )//nDiasInt//nInteres // VALOR CUEOTA EN MONEDA QUE ESTE
			(cAlias)->ZE1_TXMOED := nTasa
			(cAlias)->ZE1_PREFIX := cPrefixo  // PREFIJO PEM  PAGO PRESTAMO
			(cAlias)->ZE1_NATURE := cNat
			(cAlias)->ZE1_DREG   := dDataEmis  //  FECHA DEL PRESTAMO
			(cAlias)->ZE1_DRDIC  := dDataEmis+((i*30*(12/nTotCuot)))+1  //FECHA DE VENCIMIENTO CUOTA
			(cAlias)->ZE1_ITEM   := PADL(cValtochar(i),2,"0")
			(cAlias)->ZE1_MOEDA  := nMoneda
			(cAlias)->ZE1_CONCEP := substr('Cuota :' + PADL(cValtochar(i),2,"0") + " Prestamo : "+cvaltochar(val(cOper)),1,TamSx3("E2_HIST")[1])+" No.Ctr:"+alltrim(cContrato)
			(cAlias)->ZE1_ESTADO := '0'
			MSUnlock()
			nValActcuo = nValActcuo - nValCuotBs //CALCULO DE CAPITAL SALDO
			nValAcumo = nValAcumo - nValCuot
			dPagAnt := dDataEmis+((i*30*(12/nTotCuot)))+1
		next i
		ConfirmSX8()

		SA6->(dbSetOrder(1))
		SA6->(dbGoTop())
		if SA6->(dbSeek(xfilial("SA6")+SEH->EH_XCOD+SEH->EH_XAGENCI+SEH->EH_XNUMCON))
			nValorLin := 0
			nValorOP := 0
			if SA6->A6_MOEDA == 1
				nValorLin = SA6->A6_USLDLIN - iif(SEH->EH_MOEDA == 1,SEH->EH_VALOR,SEH->EH_VLCRUZ)  //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
				nValorOP = SA6->A6_USLDOPE - iif(SEH->EH_MOEDA == 1,SEH->EH_VALOR,SEH->EH_VLCRUZ) //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
			else              //banco esta en dolares
				nValorLin = SA6->A6_USLDLIN - iif(SEH->EH_MOEDA == 2,SEH->EH_VALOR,xMoeda(SEH->EH_VALOR,1,2,SEH->EH_DATA,2) )  //xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02)
				nValorOP = SA6->A6_USLDOPE - iif(SEH->EH_MOEDA == 2,SEH->EH_VALOR,xMoeda(SEH->EH_VALOR,1,2,SEH->EH_DATA,2) )
			endif
			RecLock("SA6", .F.)
			SA6->A6_USLDLIN = nValorLin
			SA6->A6_USLDOPE = nValorOP
			MSUnlock()
		endif

		MsgInfo("Plan de pagos Nro:" + cNumero + " de prestamo Nro.: " + cOper + " incluido con éxito", "Plan de pagos" )
	endif

	/////////////// DPFS Asfalto ///////////////////
	If SEH->EH_APLEMP = 'APL'//es inversion
		if SEH->EH_UTPIDCI == "1" .and. MsgYesNo("Desea registrar el DPF para usarlo como garantía?","Inclusión de DPF para garantia")
			if dpatfa010Inc()
				MSGINFO( "DPF registrado en activo con éxito", "Atencion" )
			else
				alert("Fallo al registrar DPF en activo")
			endif
		elseif SEH->EH_UTPIDCI == "2" .and. MsgYesNo("Desea registrar el Asfalto para usarlo como garantía?","Inclusión de Asfalto para garantia")
			if asatfa010Inc()
				MSGINFO( "Asfalto registrado en activo con éxito", "Atencion" )
			endif
		elseif SEH->EH_UTPIDCI == "3" .and. MsgYesNo("Desea registrar el monto pignorado como garantía?","Inclusión de Pignorado para garantia")
			if pigatfa010Inc()
				MSGINFO( "Monto pignorado registrado en activo con éxito", "Atencion" )
			endif
		else
			// ACTUALIZAR  DATOS DE MOV BANCARIO DEL PRESTAMO EMP
			RecLock("SE5",.F.)
			SE5->E5_UTPMOV := SEH->EH_UTPTRAN
			SE5->E5_UDESTIN := SEH->EH_UDESTRA
			SE5->E5_UGRUPO  := SEH->EH_UGRUPO
			MsUnLock()
		endif
	endif

return

static Function dpatfa010Inc()
	Local aItems := {}
	Local i
	Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica dos itens do ativo
	Local aCab := {}
	Local aParam := {}
	Private lMsHelpAuto := .t. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsistencia na execucao da rotina
	private cBaseN := ""
	PRIVATE lRetorno:= .T.
	Private cCorn:= ""

	DBSelectArea("SX5")
	DBSetOrder(1)

	If DBSeek(xFilial("SX5")+"01"+"DPF")
		cCorn= SOMA1(ALLTRIM(SX5->X5_DESCRI))
		cBaseN = "DPF" + cCorn
	else
		alert("Configure la serie DPF")
		return
	ENDIF

	aCab := {}
	AAdd(aCab,{'N1_CBASE' ,cBaseN,NIL})
	AAdd(aCab,{'N1_ITEM' ,'0001' ,NIL})
	AAdd(aCab,{'N1_AQUISIC' ,SEH->EH_DATA ,NIL})
	AAdd(aCab,{'N1_DESCRIC' ,'DPF NRO: ' + SEH->EH_APLEMP + ' '+ SEH->EH_NUMERO ,NIL})
	AAdd(aCab,{'N1_QUANTD' , 1 ,NIL})
	AAdd(aCab,{'N1_CHAPA' ,SEH->EH_APLEMP+SEH->EH_NUMERO,NIL})
	AAdd(aCab,{'N1_PATRIM' ,'N' ,NIL})
	AAdd(aCab,{'N1_GRUPO' ,'9998' ,NIL})
	AAdd(aCab,{'N1_VLCOMER' , XMOEDA(SEH->EH_VALOR,SEH->EH_MOEDA,1,SEH->EH_DATA) ,NIL})
	AAdd(aCab,{'N1_UVLHIPO' , XMOEDA(SEH->EH_VALOR,SEH->EH_MOEDA,1,SEH->EH_DATA) ,NIL})

	aItems := {}

	aAdd(aItems,{ {"N3_CBASE" , cBaseN ,NIL},;
	{'N3_ITEM' ,'0001' ,NIL},;
	{'N3_TIPO' ,'01' , NIL},;
	{"N3_BAIXA" , '0' ,NIL},;
	{'N3_HISTOR' ,"DPF NRO: " + SEH->EH_APLEMP + ' '+SEH->EH_NUMERO  , NIL},;
	{'N3_CCONTAB' ,GETNEWPAR("MV_DPFCC", "111211101           ") , NIL},;
	{'N3_TPSALDO' ,'1' , NIL},;
	{'N3_TPDEPR' ,'1' , NIL},;
	{'N3_VORIG1' , FuncaMoeda(SEH->EH_DATA,SEH->EH_VALOR,SEH->EH_MOEDA)[1]  , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,1,0,SF1->F1_TXMOEDA)
	{'N3_VORIG2' , FuncaMoeda(SEH->EH_DATA,SEH->EH_VALOR,SEH->EH_MOEDA)[2] , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,2,0,SF1->F1_TXMOEDA)
	{'N3_VORIG4' , 1 , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,2,0,SF1->F1_TXMOEDA)
	{'N3_VMXDEPR' , 0 , NIL},;
	{'N3_VLSALV1' , 0 , NIL},;
	{'N3_PERDEPR' , 0 , NIL},;
	{'N3_PRODMES' , 0 , NIL},;
	{'N3_PRODANO' , 0 , NIL},;
	{'N3_DINDEPR' ,stod('20990101') ,NIL} } ) // para que no deprecie nunca

	Begin Transaction

		MSExecAuto( {|X,Y,Z| ATFA012(X,Y,Z)} ,aCab ,aItems, 3)
		If lMsErroAuto
			lRetorno := .f.
			MostraErro()
			DisarmTransaction()
		Endif
		DBSelectArea("SX5")
		DBSetOrder(1)
		If DBSeek(xFilial("SX5")+"01"+"DPF")
			RecLock("SX5",.F.)
			SX5->X5_DESCRI := 	cCorn
			SX5->X5_DESCSPA	:= cCorn
			SX5->X5_DESCENG	:= cCorn
			MsUnLock()
		ENDIF
	End Transaction

Return lRetorno

static Function asatfa010Inc()
	Local aItems := {}
	Local i
	Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica dos itens do ativo
	Local aCab := {}
	Private lMsHelpAuto := .t. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsistencia na execucao da rotina
	private cBaseN := ""
	PRIVATE lRetorno:= .T.
	Private cCorn:= ""

	DBSelectArea("SX5")
	DBSetOrder(1)

	If DBSeek(xFilial("SX5")+"01"+"ASF")
		cCorn= SOMA1(ALLTRIM(SX5->X5_DESCRI))
		cBaseN = "ASF" + cCorn
	ELSE
		alert("Configure la serie ASF")
		return
	ENDIF

	aCab := { {'N1_FILIAL' ,'01' ,NIL},;
	{'N1_CBASE' ,cBaseN,NIL},;
	{'N1_ITEM' ,'0001' ,NIL},;
	{'N1_GRUPO' ,'9999' ,NIL},;
	{'N1_PATRIM' ,'N' ,NIL},;
	{'N1_AQUISIC' ,SEH->EH_DATA ,NIL},;  //SEH->EH_DATA
	{'N1_DESCRIC' ,'ASFALTO NRO: ' + SEH->EH_APLEMP + ' '+ SEH->EH_NUMERO ,NIL},;
	{'N1_QUANTD' , 1 ,NIL},;
	{'N1_VLCOMER' , XMOEDA(SEH->EH_VALOR,SEH->EH_MOEDA,1,SEH->EH_DATA) ,NIL},;
	{'N1_UVLHIPO' , XMOEDA(SEH->EH_VALOR,SEH->EH_MOEDA,1,SEH->EH_DATA) ,NIL},;
	{'N1_CHAPA' ,SEH->EH_APLEMP+SEH->EH_NUMERO,NIL} }

	aAdd(aItems,{ {"N3_CBASE" , cBaseN ,NIL},;
	{'N3_ITEM' ,'0001' ,NIL},;
	{'N3_TIPO' ,'01' , NIL},;
	{'N3_HISTOR' ,"ASFALTO NRO: " + SEH->EH_APLEMP + ' '+SEH->EH_NUMERO  , NIL},;
	{'N3_TPSALDO' ,'1' , NIL},;
	{'N3_TPDEPR' ,'1' , NIL},;
	{'N3_CCONTAB' ,GETNEWPAR("MV_ASFCC", "111211101           ") , NIL},;  //SI NAO TRAER DE SA6
	{'N3_VORIG1' , FuncaMoeda(SEH->EH_DATA,SEH->EH_VALOR,SEH->EH_MOEDA)[1]  , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,1,0,SF1->F1_TXMOEDA)
	{'N3_VORIG2' , FuncaMoeda(SEH->EH_DATA,SEH->EH_VALOR,SEH->EH_MOEDA)[2] , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,2,0,SF1->F1_TXMOEDA)
	{'N3_VORIG4' , 1 , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,2,0,SF1->F1_TXMOEDA)
	{'N3_VMXDEPR' , 0 , NIL},;
	{'N3_VLSALV1' , 0 , NIL},;
	{'N3_PERDEPR' , 0 , NIL},;
	{'N3_PRODMES' , 0 , NIL},;
	{'N3_PRODANO' , 0 , NIL},;
	{'N3_DINDEPR' ,stod('20990101') ,NIL} } ) // para que no deprecie nunca

	Begin Transaction

		MSExecAuto( {|X,Y,Z| ATFA012(X,Y,Z)} ,aCab ,aItems, 3)
		If lMsErroAuto
			lRetorno := .f.
			MostraErro()
			DisarmTransaction()
		Endif
		DBSelectArea("SX5")
		DBSetOrder(1)
		If DBSeek(xFilial("SX5")+"01"+"ASF")
			RecLock("SX5",.F.)
			SX5->X5_DESCRI := 	cCorn
			SX5->X5_DESCSPA	:= cCorn
			SX5->X5_DESCENG	:= cCorn
			MsUnLock()
		ENDIF
	End Transaction

Return lRetorno

static Function pigatfa010Inc()
	Local aItems := {}
	Local i
	Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica dos itens do ativo
	Local aCab := {}
	Private lMsHelpAuto := .t. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsistencia na execucao da rotina
	private cBaseN := ""
	PRIVATE lRetorno:= .T.
	Private cCorn:= ""

	DBSelectArea("SX5")
	DBSetOrder(1)

	If DBSeek(xFilial("SX5")+"01"+"PIG")
		cCorn= SOMA1(ALLTRIM(SX5->X5_DESCRI))
		cBaseN = "PIG" + cCorn
	ELSE
		alert("Configure la serie PIG")
		return
	ENDIF

	aCab := { {'N1_FILIAL' ,'01' ,NIL},;
	{'N1_CBASE' ,cBaseN,NIL},;
	{'N1_ITEM' ,'0001' ,NIL},;
	{'N1_GRUPO' ,'9997' ,NIL},;
	{'N1_PATRIM' ,'N' ,NIL},;
	{'N1_AQUISIC' ,SEH->EH_DATA ,NIL},;  //SEH->EH_DATA
	{'N1_DESCRIC' ,'PIGNORADO NRO: ' + SEH->EH_APLEMP + ' '+ SEH->EH_NUMERO ,NIL},;
	{'N1_QUANTD' , 1 ,NIL},;
	{'N1_VLCOMER' , XMOEDA(SEH->EH_VALOR,SEH->EH_MOEDA,1,SEH->EH_DATA) ,NIL},;
	{'N1_UVLHIPO' , XMOEDA(SEH->EH_VALOR,SEH->EH_MOEDA,1,SEH->EH_DATA) ,NIL},;
	{'N1_CHAPA' ,SEH->EH_APLEMP+SEH->EH_NUMERO,NIL} }

	aAdd(aItems,{ {"N3_CBASE" , cBaseN ,NIL},;
	{'N3_ITEM' ,'0001' ,NIL},;
	{'N3_TIPO' ,'01' , NIL},;
	{'N3_HISTOR' ,"PIGNORADO NRO: " + SEH->EH_APLEMP + ' '+SEH->EH_NUMERO  , NIL},;
	{'N3_TPSALDO' ,'1' , NIL},;
	{'N3_TPDEPR' ,'1' , NIL},;
	{'N3_CCONTAB' ,GETNEWPAR("MV_PIGCC", "111211101           ") , NIL},;  //SI NAO TRAER DE SA6
	{'N3_VORIG1' , FuncaMoeda(SEH->EH_DATA,SEH->EH_VALOR,SEH->EH_MOEDA)[1]  , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,1,0,SF1->F1_TXMOEDA)
	{'N3_VORIG2' , FuncaMoeda(SEH->EH_DATA,SEH->EH_VALOR,SEH->EH_MOEDA)[2] , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,2,0,SF1->F1_TXMOEDA)
	{'N3_VORIG4' , 1 , NIL},; //U_xValor(SEH->EH_VALOR,SEH->EH_DATA,SEH->EH_MOEDA,2,0,SF1->F1_TXMOEDA)
	{'N3_VMXDEPR' , 0 , NIL},;
	{'N3_VLSALV1' , 0 , NIL},;
	{'N3_PERDEPR' , 0 , NIL},;
	{'N3_PRODMES' , 0 , NIL},;
	{'N3_PRODANO' , 0 , NIL},;
	{'N3_DINDEPR' ,stod('20990101') ,NIL} } ) // para que no deprecie nunca

	Begin Transaction

		MSExecAuto( {|X,Y,Z| ATFA012(X,Y,Z)} ,aCab ,aItems, 3)
		If lMsErroAuto
			lRetorno := .f.
			MostraErro()
			DisarmTransaction()
		Endif
		DBSelectArea("SX5")
		DBSetOrder(1)
		If DBSeek(xFilial("SX5")+"01"+"PIG")
			RecLock("SX5",.F.)
			SX5->X5_DESCRI := 	cCorn
			SX5->X5_DESCSPA	:= cCorn
			SX5->X5_DESCENG	:= cCorn
			MsUnLock()
		ENDIF
	End Transaction

Return lRetorno