#include 'protheus.ch'
#include 'parmtype.ch'

user function Cobro()

// Variaveis Locais da Funcao
Local atipo	 := {"Cheque","Depósito","En Efectivo","Tarjeta Debito","Tarjeta Crédito"}
Local cagenban	 := Space(TamSX3("EL_AGENCIA")[1])
Local cbanco	 := Space(TamSX3("EL_BANCO")[1])
Local cCobrador	 := Space(TamSX3("EL_COBRAD")[1])
Local ccuentaBan	 := Space(TamSX3("EL_CONTA")[1])
Local cDiario	 := "06"
Local cemision	 := SF2->F2_EMISSAO
Local cMoneda	 := GetMV("MV_MOEDAP"+alltrim(str(SF2->F2_MOEDA)))
Local cnumfac	 := SF2->F2_DOC
Local cRecProv	 := Space(TamSX3("EL_RECPROV")[1])
Local _aArea := GetArea()
Local cTel	 := GetAdvFVal("SA1","A1_TEL",xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),1,"")
Local ctipo   
Local cvalor	 := SF2->F2_VALBRUT
Local cvalorcob	  := SF2->F2_VALBRUT
Local crecibobs := 0
Local crecibosus := 0
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
Local oRecProv
Local oSerie
Local oTel
Local ovalor
Local ovalorcob
Local cNumFatAut:=""
// Variaveis que definem a Acao do Formulario
Local cSerie  	:=	SF2->F2_SERIE
Local cRecibo  	:=	Space(TamSX3("EL_RECIBO")[1])
Local cNatureza 	:=  Space(TamSX3("EL_NATUREZ")[1])
Local cVENTERR 	:= Iif(SFE->(FieldPos("FE_VENTERR"))>0, Criavar("FE_VENTERR"),"")
Local lNatureza 	:= .F.
Local dDataRef 	:=	dDatabase
Local cCliente 	:=	SF2->F2_CLIENTE
Local cLoja		:=	SF2->F2_LOJA
Local cCliOri 	:=	Space(TamSX3("EL_CLIENTE")[1])
Local cLojOri		:=	Space(TamSX3("EL_LOJA")[1])
Local cNome     	:=	GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),1,"")                       
Local cCGC		:=	GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),1,"")                      
// Variaveis Private da Funcao
Local _oDlg				// Dialog Principal
Local nOpcA:=1
Private cnumero	 := Space(13)
Private ctotalrec := 0
Private ccambio := 0
Private cprefijo	 := 'CH '
Private  cRecibo  	:= 	GETSXENUM('SEL','EL_RECIBO')//Criavar("EL_RECIBO")
cNatureza := GETNEWPAR('MV_UNATCOB','COBROS')
//cRecibo := GETSXENUM('SEL','EL_RECIBO')  
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD 

DEFINE MSDIALOG _oDlg TITLE "Cobros" FROM C(190),C(205) TO C(619),C(991) PIXEL

	// Cria as Groups do Sistema
	@ C(001),C(005) TO C(045),C(386) LABEL "Datos del Recibo" PIXEL OF _oDlg
	@ C(046),C(005) TO C(071),C(386) LABEL "Datos del Cliente" PIXEL OF _oDlg
	@ C(072),C(005) TO C(110),C(386) LABEL "Datos de la Factura" PIXEL OF _oDlg
	@ C(112),C(005) TO C(150),C(386) LABEL "Datos de la Cobranza" PIXEL OF _oDlg
	@ C(152),C(005) TO C(188),C(383) LABEL "Importes" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(012),C(014) Say "Nro.de Recibo" Size C(036),C(008) COLOR CLR_BLACK PIXEL OF _oDlg 
	@ C(012),C(056) MsGet oRecibo Var cRecibo Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg 
	@ C(012),C(143) Say "Emisión" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(012),C(170) MsGet oDataRef Var dDataRef Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg //When .F.
	@ C(012),C(254) Say "Modalidad" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(012),C(288) MsGet oNatureza Var cNatureza F3 "SED" Size C(050),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Valid FinVldNat( .f., cNatureza, 1 ) //When .F.
	@ C(027),C(016) Say "Cobrador" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(056) MsGet oCobrador Var cCobrador F3 "SAQ" Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(142) Say "Rec.Prov." Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(170) MsGet oRecProv Var cRecProv Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(027),C(254) Say "Cod. Diario" Size C(028),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(027),C(288) MsGet oDiario Var cDiario Size C(023),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(015) Say "Cliente" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(045) MsGet oCliente Var cCliente F3 "SA1" Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(080) Say "Tienda" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(105) MsGet oLoja Var cLoja Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(318) Say "NIT" Size C(011),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(330) MsGet oCGC Var cCGC Size C(048),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(057),C(140) Say "Nombre" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(162) MsGet oNome Var cNome Size C(151),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(080),C(015) Say "Serie" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(045) MsGet oSerie Var cSerie Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(080),C(095) Say "Nro. de Factura" Size C(039),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(137) MsGet onumfac Var cnumfac Size C(118),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(080),C(262) Say "Emisión" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(080),C(287) MsGet oemision Var cemision Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(095),C(015) Say "Valor" Size C(014),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(095),C(045) MsGet ovalor Var cvalor Size C(072),C(009) COLOR CLR_BLACK PIXEL OF _oDlg PICTURE	PesqPict("SEL","EL_VALOR",TamSX3("EL_VALOR")[1]) When .F. FONT oBold 
	@ C(095),C(143) Say "Moneda" Size C(021),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(095),C(170) MsGet oMoneda Var cMoneda Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(120),C(015) Say "Forma Pago" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(045) ComboBox ctipo Items atipo Size C(066),C(010) PIXEL OF _oDlg valid SetDatos(ctipo,cRecibo)
	@ C(120),C(132) Say "Prefijo" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(152) MsGet oprefijo Var cprefijo Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(120),C(199) Say "Numero" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(120),C(227) MsGet onumero Var cnumero Size C(118),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(018) Say "Banco" Size C(017),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(045) MsGet obanco Var cbanco F3 "SA6" Size C(026),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(092) Say "Agencia" Size C(021),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(122) MsGet oagenban Var cagenban Size C(035),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
	@ C(135),C(170) Say "Cuenta Banco" Size C(036),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(135),C(210) MsGet ocuentaBan Var ccuentaBan Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg When .F.
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

If alltrim(ctipo)$"Tarjeta Debito|Tarjeta Crédito"
	aDatosTarjeta:=DatosTarjeta()
End
aTxMoedas:=Array(Moedfin())

//ALERT('LLAVE:'+xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC+'  NF '))
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
		    
		If cvalorcob <> (ctotalrec -  ccambio) .or. ccambio < 0
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

static Function UValRec(cSerie)
Local lRet 	:= .T.
Local _aArea := GetArea()                      
	
		DbSelectArea("SEL")
		DbSetorder(8)
		If dbSeek(xFilial("SEL")+cSerie+cRecibo)
			cRecibo := GETSXENUM('SEL','EL_RECIBO')                                                                                                    
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


Static function DatosTarjeta()
Local lRet   := .T.
Local lAcepto:= .T.
Local cTarjeta	:=	 space(TamSX3('EL_UNUMTAR')[1])	,	cBanco	:=	Space(TamSX3('EL_UBANTAR')[1])
Local cObservacion 	:= Space(TamSX3('EL_UOBSTAR')[1])
Local lTerc		:=	.T. , oTerc
Local oDlg 
Local aDatosTarjeta:={}


Define MSDIALOG oDlg FROM 80,000 To 270,430  Title OemToAnsi("Cobro con Tarjeta") PIXEL //"Pago con Cheques de Terceros."
@ 01,003 To 90,216 Label OemToAnsi("Datos de la Tarjeta")	Of oDlg PIXEL //"Datos del cheque"
@ 12,008 SAY OemToAnsi("Número de la Tarjeta") SIZE 100,10 Of oDlg PIXEL //"Cliente"
@ 12,060 MSGET cTarjeta  SIZE C(80),C(10) Of oDlg PIXEL
@ 30,008 SAY OemToAnsi("Banco") SIZE 30,10 Of oDlg PIXEL //"Cliente"
@ 30,060 MSGET cBanco   SIZE C(90),C(10) Of oDlg PIXEL

@ 50,008 SAY OemToAnsi("Observación") SIZE 40,10 Of oDlg PIXEL //"Recibo"
@ 50,060 MSGET cObservacion  SIZE C(120),C(10) Of oDlg PIXEL

DEFINE SBUTTON FROM 73,145 Type 1 Action (iif(EsVacio(cTarjeta,"Número de la Tarjeta") .and. EsVacio(cBanco,"Banco") ,oDlg:End(), lAcepto:= .F.)) Of oDlg PIXEL ENABLE
DEFINE SBUTTON FROM 73,180 Type 2 Action oDlg:End() Of oDlg PIXEL ENABLE
Activate Dialog oDlg CENTERED

	IF lAcepto
		if EsVacio(cTarjeta,"Número de la Tarjeta") .and. EsVacio(cBanco,"Banco") 
			aadd(aDatosTarjeta,val(cTarjeta))
			aadd(aDatosTarjeta,cBanco)
			aadd(aDatosTarjeta,cObservacion)
		end
	END

return aDatosTarjeta
      

Static Function EsVacio(variable,campo)
Local lRet:=.T.
	If empty(alltrim(variable))
		lRet:=.F.
		Msginfo("El Campo " + campo + " es Obligatorio") 
	end
return lRet

Static Function GetTipo(cTipo)
Local StrTipo:=""
	Do Case
		Case alltrim(ctipo)$"Cheque"
			StrTipo	 := "CH"
		Case alltrim(ctipo)$"En Efectivo"
			StrTipo	 := "EF"
		Case alltrim(ctipo)$"Depósito"
			StrTipo	 := "TF"
		Case alltrim(ctipo)$"Tarjeta Debito"
			StrTipo	 := "CD"
		Case alltrim(ctipo)$"Tarjeta Crédito"
			StrTipo	 := "CC"
	End Case
Return StrTipo

Static Function UFaGrvSE5(nTipo,cTpCred,cNatureza,cRecibo,cSerie,aTaxa,cMotBx)
Local lAdiantamento:=.F.
Local nTxMoeda := 0   
Local nMoedaF := 1

Private aBaixas:= {}


If nTipo==2
		
	SE5->(DbSetOrder(3))			//	E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)
	IF !(SE5->(DbSeek(xFilial("SE5")+	SEL->EL_BANCO+SEL->EL_AGENCIA+SEL->EL_CONTA+;
		SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPODOC+Dtos(SEL->EL_DTVCTO))))
		RecLock("SE5",.T.)
	Else
		Return
	Endif
	SA6->(DbSetOrder(1))
	SA6->(DbSeek(xFilial()+SEL->(EL_BANCO+EL_AGENCIA+EL_CONTA)))
	SE5->E5_FILIAL    := xFilial("SE5") //SEL->EL_FILIAL
	SE5->E5_RECPAG    := "R"
	SE5->E5_HISTOR    := "Valor cobrado por recibo "+cRecibo+"-"+cSerie //"Valor recebido por Recibo "
	SE5->E5_DTDIGIT   := dDataBase
	SE5->E5_DATA      := SEL->EL_EMISSAO
//	SE5->E5_DTDISPO   := IIf(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA,dDatabase)
	SE5->E5_DTDISPO   := IIf(cTpCred=="1",dDataBase,SEL->EL_DTVCTO)	// 1-Imediato  2-Vencimento
	SE5->E5_TIPODOC   := "VL"
	SE5->E5_PREFIXO   := SEL->EL_PREFIXO
	SE5->E5_NUMERO    := SEL->EL_NUMero
	SE5->E5_PARCELA   := SEL->EL_PARCELA
	SE5->E5_CLIFOR    := SEL->EL_CLIENTE
	SE5->E5_LOJA      := SEL->EL_LOJA
	SE5->E5_BENEF     := SE1->E1_NOMCLI
	SE5->E5_VLMOED2   := SEL->EL_VALOR
	SE5->E5_ORDREC    := cRecibo
	//SE5->E5_SERREC    := cSerie
	SE5->E5_TIPO      := SEL->EL_TIPODOC
	SE5->E5_ORIGEM      := "FINA087A"
	SE5->E5_MOEDA     := StrZero( SA6->A6_MOEDA, 2)
	//NT 03072017 SE5->E5_VALOR     := xMoeda(SEL->EL_VALOR,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),,,aTaxa[Val(SEL->EL_MOEDA)],aTaxa[Max(SA6->A6_MOEDA,1)])
	SE5->E5_VALOR     := xMoeda(SEL->EL_VALOR,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),,,xMoeda(1,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(1)))[2]),xMoeda(1,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(1)))[2]))
	// Grava o valor de correção monetária no SE5 para ser visualizado na consulta
	If cPaisLoc == "MEX" .And. SEL->EL_MOEDA <> "1"  
		nTxCor:= Iif(SE1->E1_TXMOEDA > 0, SE1->E1_TXMOEDA, RecMoeda(SE1->E1_EMISSAO, SE1->E1_MOEDA))
		nValOrig:= xMoeda(SEL->EL_VALOR,Val(SEL->EL_MOEDA),1,,,nTxCor)       
		nValAtu:= xMoeda(SEL->EL_VALOR,Val(SEL->EL_MOEDA),1,,,aTaxa[Val(SEL->EL_MOEDA)],aTaxa[Max(SA6->A6_MOEDA,1)])
		SE5->E5_VLCORRE := nValAtu - nValOrig
	EndIf
	SE5->E5_BANCO     := SEL->EL_BANCO
	SE5->E5_AGENCIA   := SEL->EL_AGENCIA
	SE5->E5_CONTA     := SEL->EL_CONTA
	SE5->E5_VENCTO    := SEL->EL_DTVCTO
	SE5->E5_SEQ       := UF087Seq()
	SE5->E5_LA        := "S"
	SE5->E5_NATUREZ   := cNatureza	
	If( SE5->(FieldPos("E5_TXMOEDA"))>0, SE5->E5_TXMOEDA:=aTaxa[Max(SA6->A6_MOEDA,1)] ,.T. )
	MsUnlock()
	aDiario:={}
	cDiario		:=	Criavar("EL_DIACTB",.T.)
	If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
		AAdd(aDiario,{"SE5",SE5->(Recno()),cDiario,"E5_NODIA","E5_DIACTB"})
	EndIf
	nValToler	:=0
	cBanco		:= SEL->EL_BANCO
	cAgencia	:= SEL->EL_AGENCIA
	cConta		:= SEL->EL_CONTA
	cLoteFin	:= IIF(lAdiantamento,"",cRecibo)
	nValEstrang	:= SE1->E1_VALLIQ
	If SEL->EL_TPCRED == "1"
		dBaixa := dDataBase
	Else
		dBaixa := SEL->EL_DTVCTO
	Endif				
	cHist070:="Valor cobrado por recibo "+cRecibo+"-"+cSerie //"Valor recebido por Recibo "
	IF !EMPTY(SEL->EL_BANCO).And. MovBcoBx(cMotBx, .T.) .and. !lAdiantamento 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar Saldo Banc rio	        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco(cBanco,cAgencia,cConta,dBaixa,SE5->E5_VALOR,"+")
	EndIf		
Endif
Return

Static Function UF087Seq()

Local aArea		:= GetArea()
Local nSeq		:= 0
Local nTamSeq	:= TamSX3("E5_SEQ")[1]

dbSelectArea("SE5")
dbSetOrder(7)	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
While .T.
	nSeq++
	If !dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+;
				SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA + StrZero(nSeq,nTamSeq))
		Exit
	EndIf
	dbSkip()
Enddo
RestArea(aArea)
		
Return(StrZero(nSeq,nTamSeq))


Static Function GravaSE5(cTpCred,cRecibo,cSerie,aTaxa,cMotBx)
Local lAdiantamento:=.F.
Local nTxMoeda := 0   
Local nMoedaF := 1

Private aBaixas:= {}



		
	SE5->(DbSetOrder(3))			//	E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)
	IF !(SE5->(DbSeek(xFilial("SE5")+	SEL->EL_BANCO+SEL->EL_AGENCIA+SEL->EL_CONTA+;
		SEL->EL_PREFIXO+SEL->EL_NUMERO+SEL->EL_PARCELA+SEL->EL_TIPODOC+Dtos(SEL->EL_DTVCTO))))
		RecLock("SE5",.T.)
	Else
		Return
	Endif
	
	SE5->E5_FILIAL    := xFilial("SE5") //SEL->EL_FILIAL
	SE5->E5_RECPAG    := "R"
	SE5->E5_HISTOR    := "Valor cobrado por recibo "+cRecibo+"-"+cSerie //"Valor recebido por Recibo "
	SE5->E5_DTDIGIT   := dDataBase
	SE5->E5_DATA      := dDataBase
//	SE5->E5_DTDISPO   := IIf(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA,dDatabase)
	SE5->E5_DTDISPO   := IIf(cTpCred=="1",dDataBase,SEL->EL_DTVCTO)	// 1-Imediato  2-Vencimento
	SE5->E5_TIPODOC   := "BA"
	SE5->E5_PREFIXO   := SF2->F2_SERIE
	SE5->E5_NUMERO    := SF2->F2_DOC
	SE5->E5_PARCELA   := SE1->E1_PARCELA
	SE5->E5_CLIFOR    := SE1->E1_CLIENTE
	SE5->E5_LOJA      := SE1->E1_LOJA
	SE5->E5_BENEF     := SE1->E1_NOMCLI
	SE5->E5_VLMOED2   := SE1->E1_VALOR
	SE5->E5_ORDREC    := cRecibo
	SE5->E5_NATUREZ := cModalidadTitulo
	//SE5->E5_SERREC    := cSerie
	SE5->E5_TIPO      := 'NF'
	SE5->E5_MOEDA     := StrZero( SA6->A6_MOEDA, 2)
	//NT 03072017 SE5->E5_VALOR     := xMoeda(SE1->E1_VALOR,(SE1->E1_MOEDA),Max(SA6->A6_MOEDA,1),,,aTaxa[SE1->E1_MOEDA],aTaxa[Max(SA6->A6_MOEDA,1)])
	SE5->E5_VALOR     := xMoeda(SEL->EL_VALOR,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),,,xMoeda(1,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(1)))[2]),xMoeda(1,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(1)))[2]))
	SE5->E5_SEQ       := UF087Seq()
	SE5->E5_LA        := "S"
		SE5->E5_LOTE := cRecibo
	SE5->E5_MOTBX := 'NOR'
	SE5->E5_SITCOB := '0'
	SE5->E5_CLIENTE := SEL->EL_CLIENTE
	SE5->E5_FILORIG := XFILIAL('SE1')
	SE5->E5_VENCTO    := CtoD( "  /  /  " )
	//NT 03072017 If( SE5->(FieldPos("E5_TXMOEDA"))>0, SE5->E5_TXMOEDA:=aTaxa[Max(SA6->A6_MOEDA,1)] ,.T. )
	If( SE5->(FieldPos("E5_TXMOEDA"))>0, SE5->E5_TXMOEDA:=xMoeda(1,Val(SEL->EL_MOEDA),Max(SA6->A6_MOEDA,1),SF2->F2_DTDIGIT,TamSx3("M2_MOEDA"+Alltrim(Str(1)))[2]),.T. )
	MsUnlock()

Return

 Static function SetImporte(crecibobs,crecibosus,cvalorcob)
  If crecibobs > 0 .or. crecibosus > 0
  	ctotalrec := crecibobs +  XMOEDA(crecibosus,2,1,SF2->F2_EMISSAO,2)
  	ccambio := ctotalrec - cvalorcob
  end
  
 
 Return .T. 