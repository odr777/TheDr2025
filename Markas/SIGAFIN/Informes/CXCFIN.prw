#INCLUDE "rwmake.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

#define nBolivianos 1
#define nDolares    2
#define nInterLin   100
//#define nFinHoja    3000
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAUTOR  	   ³ Erick Etcheverry							  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Recibo  para Cuentas por Cobrar  				  		  º±±
±±º            ³ Imprime un  respaldo al Cliente, cuando se cancela en    º±±
±±º            ³ Tesoreria se da un recibo que es solo cuando lo solicita º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CXCFIN()
	Local _wnrel        	:= "CXCFIN"  // Nombre del archivo usado para impresión en disco segun el nombre del funcion
	Local _cDesc1        	:= "Imprime como respaldo a la otra persona (Cliente o Proveedor),"
	Local _cDesc2        	:= "cuando en Tesoreria se da un recibo por entrega o recepcion de"
	Local _cDesc3        	:= "Dinero segun sea Cuenta por Cobrar o Pagar."
	Local _titCob       	:= "Cuenta por cobrar"
	Local _Cabec1        	:= ""
	Local _Cabec2        	:= ""
	Local _cString		  	:= ""
	Local aArea    := GetArea()
	Private _tamanho      	:= "P"     //P=Vertical(80) G=horizontal(220)	--> M=
	Private _nomeprog     	:= "CXCFIN" // Coloque aquí el nombre del programa para impresión en el encabezado
	Private _nTipo        	:= 18

	Private _lEnd         	:= .F.
	Private _lAbortPrint  	:= .F.
	Private _CbTxt        	:= ""
	Private _limite       	:= 80

	Private aReturn      	:= { "A Rayas", 1, "Financiero", 2, 2, 1, "", 1}
	Private _nLastKey     	:= 0
	Private _cPergCD       	:= "" // PARAMETROS DE Cobros Diversos
	Private _cbtxt        	:= Space(10)
	Private _cbcont       	:= 00
	Private _CONTFL       	:= 01
	Private m_pag        	:= 01

	//pergunte(_cPergCD,.F.)  		// Invoca y establece los parametros en SX1 en el reporte
	_wnrel := SetPrint("SE1",_nomeProg,_cPergCD,@_titCob,_cDesc1,_cDesc2,_cDesc3,.F.,,.T.,_Tamanho,,.F.)
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,_cString)
	If nLastKey == 27
		Return
	Endif
	MakeSqlExpr(_cPergCD)   // Permite la  Lectura de los valores de cada uno de los parametros definidos en SX1
	SET DEVICE TO PRINTER

	_nTipo := If(aReturn[4]==1,15,18)
	MS_FLUSH()
	MsgRun("Aguarde por favor .....", "Generando el Reporte...", ;
	{ || f4_ROfC3(_titCob,.F.) } )

	RestArea(aArea)
Return

//---------------------------------------------------------------------------------------------------//
// Rutina Secundaria de RECIBO: RECIBO COBROS DIVERSOS
//---------------------------------------------------------------------------------------------------//

static function f4_ROfC3(cTitulo,bImprimir)
	Local _xfilial := XFILIAL("SE1")
	Local _csql  := ""
	Local _nLin := 0600
	Local _nInterLin := 100
	Local _nCol1 := 1800
	Local _nCol2 := 1200
	Local _nCol3 := 0125
	Local _nCol4 := 0050
	Local _dFecha
	Local _cCliente := ""
	LOCAL cUArea := GetNextAlias()
	Local _cCobDiv := ""
	Local _nFinHoja := 3000
	Private _nMoneda := 0
	Private _nCambio := 0
	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL
	PRIVATE nLin1	:= 0080
	PRIVATE nLin2	:= 0140
	PRIVATE nLin3	:= 0200
	PRIVATE nLin4	:= 0255
	PRIVATE nLin5	:= 0310
	PRIVATE cSimb	:= ""
	DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,10 OF oPrn
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,15 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,15 OF oPrn BOLD
	DEFINE FONT oFont6 NAME "Arial" SIZE 0,07
	DEFINE FONT oFont7 NAME "Times New Roman" SIZE 0,12 OF oPrn
	DEFINE FONT oFont8 NAME "Times New Roman" SIZE 0,08 OF oPrn
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:SetPortrait() // Vertical

	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	_csql := "SELECT "  + Chr(13)
	_csql := _csql + " E1_CLIENTE,COALESCE(ISNULL(NULLIF(E1_NOMCLI, ''), null),A1_NOME)E1_NOMCLI,E1_FILIAL,E1_MOEDA,E1_NUM,E1_LOJA, " + Chr(13)
	_csql := _csql + " A1_TEL,A1_END,E1_EMISSAO,E1_HIST,E1_SALDO,E1_VLCRUZ,E1_TXMOEDA,E1_VALOR,E1_CTACLI, E1_UBANCIN " + Chr(13)
	_csql := _csql + " FROM " + RetSqlName("SE1") + " SE1 "
	_csql := _csql + " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13)
	_csql := _csql + " A1_FILIAL = E1_FILIAL AND A1_COD = E1_CLIENTE AND SA1.D_E_L_E_T_ = ' ' " + CHR(13)
	_csql := _csql + " WHERE E1_FILIAL = '" + _xfilial + "' AND E1_NATUREZ = '" + SE1->E1_NATUREZ +"' " + CHR(13)
	_csql := _csql + " AND E1_CLIENTE = '" + SE1->E1_CLIENTE + "' AND E1_LOJA = '" + SE1->E1_LOJA + "' " + CHR(13)
	_csql := _csql + " AND E1_PREFIXO = '" + SE1->E1_PREFIXO + "' AND E1_NUM = '" + SE1->E1_NUM + "' " + CHR(13)
	_csql := _csql + " AND E1_PARCELA = '" + SE1->E1_PARCELA + "' AND E1_TIPO = '" + SE1->E1_TIPO + "' " + CHR(13)
	_csql := _csql + " AND SE1.D_E_L_E_T_ = ' ' AND E1_SALDO > 0" + CHR(13)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,, _csql), cUArea ,.T.,.F.)
	//Aviso("Array IVA",_csql,{'ok'},,,,,.t.)
	dbSelectArea(cUArea)
	dbGoTop()

	if (cUArea)->(!eof())

		_nLin := 0400
		oPrn:StartPage()
		Logo(cTitulo)

		dbSelectArea(cUArea)
		_nEspCab := 0
		//ALERT(VALTYPE((cUArea)->E1_MOEDA))
		//_nCambio := (cUArea)->E1_TXMOEDA
		if (cUArea)->E1_MOEDA == 1
			_nCambio := 1
			cSimb = "Bs"
		else
			cSimb = "$us"
			_nCambio := (cUArea)->E1_TXMOEDA
		endif

		_dFecha := (cUArea)->E1_EMISSAO
		_cCobDiv := (cUArea)->E1_NUM
		_nInterLin = _nInterLin - 40
		oPrn:Say(_nLin, _nCol4, "Cliente: " + Alltrim((cUArea)->E1_CLIENTE)+" - " + Alltrim((cUArea)->E1_NOMCLI),oFont7)
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol4, "Dirección: " + Alltrim((cUArea)->A1_END),oFont7)
		oPrn:Say(_nLin, _nCol1-80, "Telefono: " + Alltrim((cUArea)->A1_TEL),oFont7)

		_nLin := _nLin + _nInterLin

		oPrn:Say(_nLin, _nCol4, REPLICATE('_',100),oFont3)

		_nEspCab := _nLin + 50
		_nLin := _nLin + _nInterLin * 2

		oPrn:Say(_nLin , _nCol3 , " Banco " ,oFont1)
		oPrn:Say(_nLin , _nCol3 + 660, " Cuenta del Banco " ,oFont1)
		oPrn:Say(_nLin , _nCol3 + 1060,  " Monto ",oFont1)
		oPrn:Say(_nLin , _nCol3 + 1600,  " Moneda ",oFont1)

		//********************
		_cCliente := "("+(cUArea)->E1_CLIENTE+"-"+(cUArea)->E1_LOJA+")"+Alltrim((cUArea)->E1_NOMCLI)

		_nLin := _nLin + 50

		oPrn:Say(_nLin , _nCol3 -  80, ALLTRIM((cUArea)->E1_UBANCIN) ,oFont2)
		oPrn:Say(_nLin , _nCol3 +  680 , Alltrim((cUArea)->E1_CTACLI) ,oFont2)
		oPrn:Say(_nLin , _nCol3 + 1020 , Transform((cUArea)->E1_VALOR, "@E 999,999,999.99") ,oFont2)
		oPrn:Say(_nLin , _nCol3 + 1620 , cSimb ,oFont2)

		oPrn:Say(nLin1, _nCol1 - 80, "Comprobante: " + _cCobDiv, oFont4) //EL_RECIBO sería del siguiente...
		oPrn:Say(nLin2, _nCol1-80, "FECHA:" + (dtoC(stod(_dFecha))) ,oFont4)
		oPrn:Say(nLin3, _nCol1 -80, "TC." + AllTrim(CValToChar(_nCambio)) ,oFont4)
		_nLin := _nLin + _nInterLin + 150
		oPrn:Say(_nLin , _nCol3 -80,  " Observaciones: ",oFont1)
		If Len(alltrim(E1_HIST)) > 38
			oPrn:Say(_nLin , _nCol3 + 180 , SubStr((cUArea)->E1_HIST,1,38) ,oFont8)
			oPrn:Say(_nLin + 27 , _nCol3 + 180 , SubStr((cUArea)->E1_HIST,39,34),oFont8)
		ELSE
			oPrn:Say(_nLin , _nCol3 + 180 , AllTrim((cUArea)->E1_HIST) ,oFont2)
		EndIf

		_nLin := _nLin + _nInterLin
		_nLin := _nLin + _nInterLin
		_nLin := _nLin + _nInterLin
		_nLin := _nLin + _nInterLin
		_nLin := _nLin + _nInterLin

		oPrn:Say(_nLin, _nCol3," ______________________",oFont1 )
		oPrn:Say(_nLin, _nCol3 + 1300,"______________________",oFont1 )
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3 + 65,"	Recibi Conforme ",oFont1 )
		oPrn:Say(_nLin, _nCol3 + 1345,"	 Entregue Conforme ",oFont1 )

		#IFDEF TOP
		#ENDIF
		Ms_Flush() //JLJR: Sube lo cargado a TMSPrinter
		//JLJR: No Existe este metodo para el Objeto: Reload()
		oPrn:Refresh() //JLJR: Tampoco recarga como esperabamos...
		if bImprimir
			oPrn:Print()
		else
			oPrn:Preview()
		end If

	else
		Aviso("Info","No hay informe para exhibir",{'ok'},,,,,.f.)
	endif
	If !Empty(Select(cUArea))
		dbCloseArea()
	Endif
return

Static Function Logo(cTitulo)
	// Say(Fila, Columna, Texto, Fuente)....
	//SM0->M0_NOMECOM
	oPrn:Say( nLin1,0080, SM0->M0_NOMECOM, oFont5)
	oPrn:Say( nLin2,0080, Capital(AllTrim(SM0->M0_ENDENT)), oFont4)
	oPrn:Say( nLin3,0080, "Tel. " + SM0->M0_TEL, oFont4)
	oPrn:Say( nLin4,0080, "Fax. " + SM0->M0_FAX, oFont4)
	oPrn:Say( nLin5,0080, IIF(Alltrim(SM0->M0_CIDCOB) == "SANTA CRUZ", "Santa Cruz de La Sierra", Capital(AllTrim(SM0->M0_CIDCOB))), oFont4)
	oPrn:Say( 0300 ,0900, cTitulo, oFont5)
Return

static function LugEmp( _nLin, _nInterLin, _nCol3, _dFecha) //Lugar de la Empresa...
	//adv: oPrn:Say(_nLin , _nCol3 + 400, IIF( Alltrim(SM0->M0_CIDCOB) == "SANTA CRUZ", "Santa Cruz de la Sierra", ;
	//	Capital(AllTrim(SM0->M0_CIDCOB)) ) + ", " + u_f4_fecha(_dFecha), oFont4)

	oPrn:Say(nLin4 , 1800, fecha(_dFecha), oFont4)
	//oPrn:Say(nLin4 ,_nCol1 , u_f4_fecha(_dFecha), oFont4)
	_nLin := _nLin + ( _nInterLin * 3)

return

Static function fecha(_dFecha)
	Local _cFecha
	Local _nMes

	_cFecha :=  SubStr(_dFecha,7,2) + " de "
	_nMes := Val(SubStr(_dFecha,5,2))
	Do Case
		Case _nMes == 1
		_cFecha += "Enero"
		Case _nMes == 2
		_cFecha += "Febrero"
		Case _nMes == 3
		_cFecha += "Marzo"
		Case _nMes == 4
		_cFecha += "Abril"
		Case _nMes == 5
		_cFecha += "Mayo"
		Case _nMes == 6
		_cFecha += "Junio"
		Case _nMes == 7
		_cFecha += "Julio"
		Case _nMes == 8
		_cFecha += "Agosto"
		Case _nMes == 9
		_cFecha += "Septiembre"
		Case _nMes == 10
		_cFecha += "Octubre"
		Case _nMes == 11
		_cFecha += "Noviembre"
		Case _nMes == 12
		_cFecha += "Diciembre"
	EndCase
	_cFecha += " del " + SubStr(_dFecha,1,4)

return _cFecha
