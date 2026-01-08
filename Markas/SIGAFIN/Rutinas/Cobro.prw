#include 'protheus.ch'
#include 'parmtype.ch'

user function Cobro()

// Variaveis Locais da Funcao
	Local atipo	 := {"Cheque","Depósito","En Efectivo","Tarjeta Debito","Tarjeta Crédito"}
	Local cDiario	 := "06"
	Local cemision	 := SF2->F2_EMISSAO
	Local cMoneda	 := GetMV("MV_MOEDAP"+alltrim(str(SF2->F2_MOEDA)))
	Local cnumfac	 := SF2->F2_DOC
	Local _aArea := GetArea()
	Local ctipo := "En Efectivo"
	Local cvalor	 := SF2->F2_VALBRUT
	Local oagenban
	Local obanco
	Local oCGC
	Local oCliente
	Local oCobrador
	Local ocuentaBan
	Local oDataRef
	Local oDiario
	Local oemision
	Local oLoja
	Local oMoneda
	Local oNatureza
	Local oNome
	Local onumero
	Local onumfac
	Local oprefijo
	Local oRecibo
	Local oSerie
	Local oxSerie
	Local ovalor
	Local ovalorcob
	Local oxDescuento
	Local oxMulta
// Variaveis que definem a Acao do Formulario
	Local cxSerie  	:=	SF2->F2_SERIE
	Local cNatureza 	:=  Space(TamSX3("EL_NATUREZ")[1])
	Local dDataRef 	:=	dDatabase
	Local cCliente 	:=	SF2->F2_CLIENTE
	Local cLoja		:=	SF2->F2_LOJA
	Local cNome     	:=	GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),1,"")
	Local cCGC		:=	GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),1,"")
	Local nOpcA:=1
	// Variaveis Private da Funcao
	Private _oDlg // Dialog Principal
	Private cnumero	 := Space(13)
	Private ctotalrec := 0
	Private ccambio := 0
	Private cprefijo	 := 'CH '
	Private cSerie := Space(TamSX3("EL_SERIE")[1])
	private cagenban	 := Space(TamSX3("EL_AGENCIA")[1])
	private cbanco	 := Space(TamSX3("EL_BANCO")[1])
	private cCobrador	 := Space(TamSX3("EL_COBRAD")[1])
	private ccuentaBan	 := Space(TamSX3("EL_CONTA")[1])
	private cvalorcob	  := SF2->F2_VALBRUT
	Private cRecibo  	:=	Criavar("EL_RECIBO")
	Private nBcoMoed  	:=	Criavar("F2_MOEDA")
	Private crecibobs := 0
	Private crecibosus := 0
	Private nxMulta := 0
	Private nxDescuento := 0

	cNatureza := GETNEWPAR('MV_UNATCOB','COBRO')

	////caja uno en bolivianos
	cCobrador := Posicione("SAQ",1,XFILIAL("SAQ") + XFILIAL("SAQ"), "AQ_COD")

	cbanco := Posicione("SA6", 1, xFilial("SA6")+"CX1", "A6_COD")///LA CAJA DE LA FILIAL

	While SA6->(!Eof() .And. SA6->A6_FILIAL+SA6->A6_COD == xFilial("SA6")+cbanco)
		If	SA6->A6_MOEDA == 1
			Exit
		EndIf
		SA6->(DbSkip())
	EndDo

	cagenban := SA6->A6_AGENCIA
	ccuentaBan := SA6->A6_NUMCON
	nBcoMoed := SA6->A6_MOEDA

	SetDatos(ctipo,cRecibo)

	cvalorcob := XMOEDA(cvalorcob,SF2->F2_MOEDA,nBcoMoed,SF2->F2_EMISSAO,2)

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

	DEFINE MSDIALOG _oDlg TITLE "Cobros" FROM C(190),C(205) TO C(620),C(990) PIXEL

	// Cria as Groups do Sistema
	@ C(001),C(005) TO C(045),C(386) LABEL "Datos del Recibo" PIXEL OF _oDlg
	@ C(046),C(005) TO C(071),C(386) LABEL "Datos del Cliente" PIXEL OF _oDlg
	@ C(072),C(005) TO C(110),C(386) LABEL "Datos de la Factura" PIXEL OF _oDlg
	@ C(112),C(005) TO C(150),C(386) LABEL "Datos de la Cobranza" PIXEL OF _oDlg
	@ C(152),C(005) TO C(188),C(383) LABEL "Importes" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(012),C(014) Say "Serie" Size C(036),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(012),C(056) MsGet oSerie Var cSerie F3 "RN" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg PICTURE PesqPict("SEL","EL_SERIE",TamSX3("EL_SERIE")[1])  Valid u_Fa087Ser(@cSerie, @cRecibo)
	@ C(012),C(142) Say "Nro.de Recibo" Size C(036),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(012),C(172) MsGet oRecibo Var cRecibo Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Valid {||u_FA087aVld('cRecibo',"")}
	@ C(012),C(254) Say "Emisión" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(012),C(288) MsGet oDataRef Var dDataRef Size C(050),C(009) COLOR CLR_BLACK PIXEL OF _oDlg //When .F.

	@ C(027),C(014) Say "Cobrador" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(056) MsGet oCobrador Var cCobrador Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(027),C(142) Say "Modalidad" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(172) MsGet oNatureza Var cNatureza F3 "SED" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Valid FinVldNat( .f., cNatureza, 1 ) //When .F.
	@ C(027),C(254) Say "Cod. Diario" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(288) MsGet oDiario Var cDiario Size C(023),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(015) Say "Cliente" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(053) MsGet oCliente Var cCliente F3 "SA1" Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(080) Say "Tienda" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(105) MsGet oLoja Var cLoja Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(318) Say "NIT" Size C(011),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(330) MsGet oCGC Var cCGC Size C(048),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(140) Say "Nombre" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(162) MsGet oNome Var cNome Size C(151),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(080),C(015) Say "Serie" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(053) MsGet oxSerie Var cxSerie Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(080),C(095) Say "Nro. de Factura" Size C(039),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(137) MsGet onumfac Var cnumfac Size C(118),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(080),C(262) Say "Emisión" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(287) MsGet oemision Var cemision Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(095),C(015) Say "Valor" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(095),C(053) MsGet ovalor Var cvalor Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg PICTURE	PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1]) When .F. FONT oBold
	@ C(095),C(120) Say "Moneda" Size C(021),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(095),C(147) MsGet oMoneda Var cMoneda Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(095),C(180) Say "Descuento" Size C(024),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(095),C(210) MsGet oxDescuento Var nxDescuento Size C(072),C(009) COLOR CLR_RED PIXEL OF _oDlg valid setDescuento() Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1])  FONT oBold
	@ C(095),C(290) Say "Multa" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg //
	@ C(095),C(310) MsGet oxMulta Var nxMulta Size C(072),C(009) COLOR CLR_RED PIXEL OF _oDlg valid setMulta() Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1])  FONT oBold
	@ C(120),C(015) Say "Forma Pago" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(053) ComboBox ctipo Items atipo Size C(066),C(010) PIXEL OF _oDlg valid SetDatos(ctipo,cRecibo)
	@ C(120),C(132) Say "Prefijo" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(152) MsGet oprefijo Var cprefijo Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(120),C(199) Say "Numero" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(227) MsGet onumero Var cnumero Size C(118),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(018) Say "Banco" Size C(017),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(053) MsGet obanco Var cbanco F3 "SA6" Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg valid SetMoeCobro()
	@ C(135),C(092) Say "Agencia" Size C(021),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(122) MsGet oagenban Var cagenban Size C(035),C(009) COLOR CLR_BLACK PIXEL OF _oDlg valid SetMoeCobro() When .F.
	@ C(135),C(170) Say "Cuenta Banco" Size C(036),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(210) MsGet ocuentaBan Var ccuentaBan Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg valid SetMoeCobro() When .F.
	@ C(135),C(285) Say "Valor" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(305) MsGet ovalorcob Var cvalorcob Size C(072),C(009) COLOR CLR_RED PIXEL OF _oDlg Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1]) When .F. FONT oBold
	@ C(160),C(015) Say "Recibido Bs." Size C(032),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(160),C(053) MsGet orecibobs Var crecibobs Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1]) valid SetImporte(crecibobs,crecibosus,cvalorcob)
	@ C(170),C(131) Say "Total Recibido Bs." Size C(045),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(170),C(178) MsGet ototalrec Var ctotalrec Size C(060),C(009) COLOR CLR_RED PIXEL OF _oDlg Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1])When .F. FONT oBold
	@ C(170),C(253) Say "Cambio Bs." Size C(028),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(170),C(287) MsGet ocambio Var ccambio Size C(060),C(009) COLOR CLR_BLUE PIXEL OF _oDlg Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1])When .F.  FONT oBold
	@ C(175),C(015) Say "Recibido $us." Size C(034),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(175),C(053) MsGet orecibosus Var crecibosus Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1])  valid SetImporte(crecibobs,crecibosus,cvalorcob)

	@ C(195),C(275) Button "&Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION IIf(UFA087vld('cRecibo',"   ",cRecibo,cbanco,cnumero,cNatureza,cvalorcob),_oDlg:End(),(nOpcA := 1,cRecibo  	:= 	GETSXENUM('SEL','EL_RECIBO')))
	@ C(195),C(328) Button "&Finalizar" Size C(037),C(012) PIXEL OF _oDlg ACTION (nOpcA := 0,_oDlg:End())

	ACTIVATE MSDIALOG _oDlg CENTERED

	iF nOpcA == 0
		Return
	END

<<<<<<< Updated upstream
	If alltrim(ctipo)$"Tarjeta Debito|Tarjeta Crédito"
		aDatosTarjeta:=DatosTarjeta()
	End
	aTxMoedas:=Array(Moedfin())

//ALERT('LLAVE:'+xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC+'  NF '))
//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	SE1->(DbSetOrder(2))
	If SE1->(DbSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC+'  NF '))  )
//alert('1:'+SE1->E1_NUM)
		For nI:= 1 to Len(aTxMoedas)
			aTxMoedas[nI]	:= xMoeda(1,nI,1,SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(nI)))[2])
		Next nI
	eND
	If Len(aTxMoedas) = 0
		aTxMoedas[1]	:= xMoeda(1,1,1,SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(1)))[2])
		aTxMoedas[2]	:= xMoeda(1,2,1,SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(2)))[2])
	EndIf
//alert('2:'+SE1->E1_NUM)

	If SE1->E1_NUM = ' '
		Alert('No se pudo realizar el cobro correctamente')
	EndIf

	cTipoPago:=GetTipo(ctipo)

	ConfirmSX8()

	BEGIN TRANSACTION
		DbSelectArea("SEL")
		RecLock("SEL",.T.)
		EL_CLIENTE := cCliente
		EL_LOJA    := cLoja
		EL_TIPODOC := cTipoPago
		EL_TIPO := cTipoPago+" "
		EL_NATUREZ  := cNatureza
		EL_RECIBO	:=cRecibo
//	EL_VLMOED1:= Round( SF2->F2_VALBRUT*aTxMoedas[SF2->F2_MOEDA] , MsDecimais(TamSX3("EL_VLMOED1")[2]))
		EL_VLMOED1:= Round( SF2->F2_VALBRUT , MsDecimais(TamSX3("EL_VLMOED1")[2]))
		EL_VALOR	:= SF2->F2_VALBRUT
		EL_FILIAL	:= XFILIAL('SEL')
		EL_CLIORIG := cCliente
		EL_LOJORIG := cLoja
		EL_NUMERO := cnumero
		EL_MOEDA := STRZERO(SE1->E1_MOEDA,2)
		EL_EMISSAO := DDATABASE
		EL_DTVCTO := DDATABASE
		EL_PREFIXO:=  cprefijo

		Do Case
		Case EL_TIPODOC $ 'EF'
			EL_TPCRED := '1'
		Case EL_TIPODOC $ 'CH'

		Case EL_TIPODOC $ 'TF'

		Case EL_TIPODOC $ 'CD'
			EL_UNUMTAR := aDatosTarjeta[0]
			EL_UBANTAR := aDatosTarjeta[1]
			EL_OBSTAR := aDatosTarjeta[2]
		Case EL_TIPODOC $ 'CC'
			EL_UNUMTAR := aDatosTarjeta[0]
			EL_UBANTAR := aDatosTarjeta[1]
			EL_OBSTAR := aDatosTarjeta[2]
		End Case
		EL_BANCO := cbanco
		EL_AGENCIA := cagenban
		EL_CONTA := ccuentaBan
		EL_ACREBAN := '1'
		EL_TERCEIR := '1'
		EL_DTDIGIT := DDATABASE
		EL_DIACTB := '06'
		EL_UVLRCBS := crecibobs
		EL_UVLRCSU := crecibosus

		F087AGrvTx( aTxMoedas )
		MsUnlock()

		RecLock("SEL",.T.)
		SEL->EL_CLIENTE := cCliente
		SEL->EL_LOJA    := cLoja
		SEL->EL_TIPODOC := 'TB'
		SEL->EL_TIPO := 'NF'
		SEL->EL_NATUREZ  := ''
		SEL->EL_PREFIXO:=  SF2->F2_SERIE
		SEL->EL_RECIBO	:=cRecibo
//	SEL->EL_VLMOED1:= Round( SF2->F2_VALBRUT*aTxMoedas[SF2->F2_MOEDA]  , MsDecimais(TamSX3("EL_VLMOED1")[2]))
		SEL->EL_VLMOED1:= Round( SF2->F2_VALBRUT , MsDecimais(TamSX3("EL_VLMOED1")[2]))
		SEL->EL_VALOR	:= SF2->F2_VALBRUT
		SEL->EL_FILIAL	:= XFILIAL('SEL')
		SEL->EL_CLIORIG := cCliente
		SEL->EL_LOJORIG := cLoja
		SEL->EL_NUMERO := SF2->F2_DOC
		SEL->EL_MOEDA := STRZERO(SE1->E1_MOEDA,2)
		SEL->EL_EMISSAO := SF2->F2_EMISSAO
		SEL->EL_DTVCTO := SF2->F2_EMISSAO


		Do Case
		Case SEL->EL_TIPODOC $ 'EF'
			//SEL->EL_TPCRED := '1'
		Case SEL->EL_TIPODOC $ 'CH'

		Case SEL->EL_TIPODOC $ 'TF'

		Case SEL->EL_TIPODOC $ 'CD'
			SEL->EL_UNUMTAR := aDatosTarjeta[0]
			SEL->EL_UBANTAR := aDatosTarjeta[1]
			SEL->EL_OBSTAR := aDatosTarjeta[2]
		Case SEL->EL_TIPODOC $ 'CC'
			SEL->EL_UNUMTAR := aDatosTarjeta[0]
			SEL->EL_UBANTAR := aDatosTarjeta[1]
			SEL->EL_OBSTAR := aDatosTarjeta[2]
		End Case
	/*SEL->EL_BANCO := cbanco
	SEL->EL_AGENCIA := cagenban
	SEL->EL_CONTA := ccuentaBan
	SEL->EL_ACREBAN := '1'
	SEL->EL_TERCEIR := '1'*/
	SEL->EL_DTDIGIT := DDATABASE
	//SEL->EL_DIACTB := '06'
	
F087AGrvTx( aTxMoedas )
MsUnlock()
cModalidadTitulo:=""
//------- Actualizamos el titulo --------------------------
//NT 03072017
RecLock("SE1",.F.)
		E1_BAIXA 	:=	DDATABASE
//		E1_LA		:='S'
		E1_MOTIVO	:='NOR'
		E1_MOVIMEN	:=DDATABASE 
		E1_SALDO	:= 0// - nVrRetCfg
		//E1_SERREC   :=SF2->F2_SERIE
		E1_RECIBO	:=cRecibo
		E1_DTACRED	:=DDATABASE
		E1_SITUACA	:= '0'
		E1_VALLIQ	:= SF2->F2_VALBRUT
		E1_STATUS	:= IF(SE1->E1_SALDO<=0,"B","A")
		E1_HIST 		:= 		"BAJA DESDE FACTURACION"
		
//	MsUnlock()
	cModalidadTitulo:=SF2->F2_NATUREZ
//---------------------------------------------------------
//----------GENERAMOS EL NUEVO REGISTRO SE1 cuando es Cheque

		If ALLTRIM(cTipoPago) $ 'CH'
			RecLock("SE1",.T.)
					E1_FILIAL   := xFilial("SE1")
					E1_PREFIXO 	:= 		cprefijo            									
					E1_NUM			:= 	   	cnumero			    								              
					E1_PARCELA 	:=		''		            									              
				  	E1_TIPO 		:=		'CH '	         											
					E1_CLIENTE 	:= 		cCliente            									
					E1_LOJA		:= 		cLoja            									
					E1_VALOR 		:= 		SF2->F2_VALBRUT              										
//					E1_VLCRUZ 		:= 		Round( SF2->F2_VALBRUT*aTxMoedas[SF2->F2_MOEDA]  , MsDecimais(TamSX3("EL_VLMOED1")[2]))
					E1_VLCRUZ 		:= 		Round( SF2->F2_VALBRUT , MsDecimais(TamSX3("EL_VLMOED1")[2]))
					E1_NATUREZ 	:= 		cNatureza
					E1_EMISSAO 	:= 		ddatabase
					E1_VENCTO		:= 		ddatabase														
					E1_VENCREA		:= 		DataValida(ddatabase,.T.)														
					E1_VENCORI 	:= 		DataValida(ddatabase,.T.)														
					E1_EMIS1		:= 		dDataBase               									
					E1_MOEDA		:= 		SF2->F2_MOEDA       										
					E1_HIST 		:= 		"BAJA DESDE FACTURACION"		
					E1_ORIGEM 		:= 		"FINA087A" 	   
					E1_LA          :='S'
					SE1->E1_VALLIQ      :=SF2->F2_VALBRUT 
					SE1->E1_SITUACA:= "1"
					SE1->E1_SALDO   := 0
					SE1->E1_BAIXA   := dDataBase
					SE1->E1_MOVIMEN := dDataBase
					SE1->E1_PORTADO:= cbanco
					SE1->E1_AGEDEP := cagenban
					SE1->E1_CONTA := ccuentaBan
					E1_STATUS	:= IF(SE1->E1_SALDO<=0,"B","A")
					E1_RECIBO	:=cRecibo
					E1_DTACRED	:=DDATABASE
					E1_TXMOEDA	:= aTxMoedas[SE1->E1_MOEDA]
					E1_NOMCLI := cNome
					SE1->(MsUnLock())
					
		END
//----------------------------------------------------------
//----------------------------------------------------------
SEL->(DBSETORDER(8))
SEL->(DbSeek(xFilial("SEL")+"   "+cRecibo+cTipoPago+cprefijo+" "+cnumero+"        "+cTipoPago+" "))  
//-------------------ACTUALIZAMOS EL BANCO ------------------------
	UFaGrvSE5(2,"1",cNatureza,cRecibo,cSerie,aTxMoedas,"NOR")
SEL->(DbSeek(xFilial("SEL")+"   "+cRecibo+'TB'+cSerie+cnumfac+" ",.T.))
//UFaGrvSE5(2,"1","",cRecibo,cSerie,aTxMoedas,"")
GravaSE5("1",cRecibo,cSerie,aTxMoedas,cModalidadTitulo)
dbCommit()
 
	END TRANSACTION
ApMsgInfo("Cobro realizado Exitosamente!","Informacion")
FreeUsedCode()
RestArea(_aArea)
=======
	u_xcobAuto()
	RestArea(_aArea)
>>>>>>> Stashed changes
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28                                                               
	EndIf
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90                                                            
		EndIf
	EndIf
Return Int(nTam)                                                                

static Function UFA087vld(cVar   ,cSerie,cRecibo,cBanco,cTitulo,cModalidad,cvalorcob)
Local lRet 	:= .T.
Local _aArea := GetArea()
                      
	If Empty(cRecibo)
			MsgStop("Por favor, Indique el campo Nro. de Recibo")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
	EndIf
	If Empty(cBanco)
			MsgStop("Por favor, Seleccione un Banco")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
	end
	If Empty(cTitulo)
			MsgStop("Por favor, Digite el Número del Titulo")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
		
	End
	If Empty(cModalidad)
			MsgStop("Por favor, Seleccione una Modalidad")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
		
	End
	If Empty(cCobrador)
			MsgStop("Por favor, Seleccione un Cobrador valido")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
	End
		    
	If (XMOEDA(cvalorcob,nBcoMoed,1,SF2->F2_EMISSAO,2) + XMOEDA(nxMulta,nBcoMoed,1,SF2->F2_EMISSAO,2)  - XMOEDA(nxDescuento,nBcoMoed,1,SF2->F2_EMISSAO,2)) <> (ctotalrec -  ccambio) .or. ccambio < 0
			MsgStop("El Valor Recibido es Diferente al Valor de la Factura")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
	End
		
		DbSelectArea("SEL")
		DbSetorder(8)
	If dbSeek(xFilial("SEL")+cSerie+cRecibo)
			Help(" ",1,"EXISTNUM")
			Return(.F.)
	EndIf
RestArea(_aArea)
return lRet

Static Function SetDatos(ctipo,cRecibo)
Local lRet 	:= .T.
Local _aArea := GetArea()    
	Do Case
	Case alltrim(ctipo)$"Cheque"
			cprefijo	 := "CH"
			cnumero	 := Space(13)
	Case alltrim(ctipo)$"En Efectivo"
			cnumero	 := cRecibo
			cprefijo	 := 'EF'
	Case alltrim(ctipo)$"Depósito"
			cnumero	 := Space(13)
			cprefijo	 := 'TF'
	Case alltrim(ctipo)$"Tarjeta Debito"
			cprefijo	 := "CD"
			cnumero	 := Space(13)
	Case alltrim(ctipo)$"Tarjeta Crédito"
			cprefijo	 := "CC"
			cnumero	 := Space(13)
	End Case
RestArea(_aArea)
return lRet

Static Function EsVacio(variable,campo)
Local lRet:=.T.
	If empty(alltrim(variable))
		lRet:=.F.
		Msginfo("El Campo " + campo + " es Obligatorio") 
	end
return lRet

Static Function SetMoeCobro()
Local lRet:=.T.
	
	cbanco := Posicione("SA6", 1, xFilial("SA6")+cBanco+cagenban+ccuentaBan, "A6_COD")
	cagenban := SA6->A6_AGENCIA
	ccuentaBan := SA6->A6_NUMCON
	nBcoMoed := SA6->A6_MOEDA

	cvalorcob := XMOEDA(SF2->F2_VALBRUT,SF2->F2_MOEDA,nBcoMoed,SF2->F2_EMISSAO,2)

return lRet
		
Return(StrZero(nSeq,nTamSeq))

Static function SetImporte(crecibobs,crecibosus,cvalorcob)

	If crecibobs >= 0 .or. crecibosus >= 0
		ctotalrec := crecibobs +  XMOEDA(crecibosus,2,1,SF2->F2_EMISSAO,2) ///todo a bs
		ccambio := ctotalrec - XMOEDA(cvalorcob,nBcoMoed,1,SF2->F2_EMISSAO,2) + XMOEDA(nxDescuento,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,2) - XMOEDA(nxMulta,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,2)
	end
  
 Return .T. 

user Function Fa087Ser(cSerie,cRecibo)
Local aSerRec	:= {}
Local nOpcA    := 0     

DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek( xFilial("SX5")+"RN"+cSerie )
	AADD( aSerRec,{ Padr( X5_CHAVE, 3 ), StrZero( Val( X5Descri() ),TamSX3("EL_RECIBO")[1] ) } )  
	cRecibo := aSerRec[1,2]
	cSerie  := aSerRec[1,1]
	nOpcA   := 1 
	cnumero	 := cRecibo
EnDIf

Return { cSerie, cRecibo }

user Function FA087aVld(cVar , cNumFatAut , lIncAdt )

Local lRet 	:= .T.                      

DEFAULT cNumFatAut := ""
DEFAULT lIncAdt	   := .F.   

Do Case 
	Case cVar=="cRecibo"
		If Empty(cRecibo)
			MsgStop("Por favor, primero indique o campo de nr do recibo")   //"Por favor, primero indique o campo de nr do recibo"
			Return (.F.)
		EndIf
		DbSelectArea("SEL")
		DbSetorder(8)
		If dbSeek(xFilial("SEL")+cSerie+cRecibo)
			Help(" ",1,"EXISTNUM")
			Return(.F.)
		EndIf
		
		dDataRef	:= dDataBase
	OtherWise
		dDataRef	:= dDataBase
		cCliente	:=	Space(Len(SEL->EL_CLIENTE))
		cLoja		:=	Space(Len(SEL->EL_LOJA))
		cNome		:=	Space(TamSX3("A1_NOME")[1])
		cCGC		:=	Space(TamSX3("A1_CGC")[1])
		cContato	:=	Space(TamSX3("A1_CONTATO")[1])
		cTel		:=	Space(TamSX3("A1_TEL")[1])
		RefData(1,cNumFatAut,lIncAdt)
		OBJRefresh(1)
EndCase

Return(lRet)

static function setMulta()

	if nxDescuento > 0 .and. nxMulta > 0
		nxDescuento := 0
	endif

	SetImporte(crecibobs,crecibosus,cvalorcob)
	
	_oDlg:refresh()
RETURN .t.

static function setDescuento()

	if nxDescuento > 0 .and. nxMulta > 0
		nxMulta := 0
	endif

	SetImporte(crecibobs,crecibosus,cvalorcob)

	_oDlg:refresh()
return .t.
