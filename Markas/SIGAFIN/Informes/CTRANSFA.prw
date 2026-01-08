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

User Function CTRANSFA(cDocument)
	Local _wnrel        	:= "CTRANSFA"  // Nombre del archivo usado para impresión en disco segun el nombre del funcion
	Local _cDesc1        	:= "Imprime la trasferencia bancaria"
	Local _cDesc2        	:= ""
	Local _cDesc3        	:= ""
	Local _titCob       	:= "Transferencia bancaria"
	Local _Cabec1        	:= ""
	Local _Cabec2        	:= ""
	Local _cString		  	:= ""
	Local aArea    := GetArea()
	Private _tamanho      	:= "P"     //P=Vertical(80) G=horizontal(220)	--> M=
	Private _nomeprog     	:= "CTRANSFA" // Coloque aquí el nombre del programa para impresión en el encabezado
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
	_wnrel := SetPrint("SE5",_nomeProg,_cPergCD,@_titCob,_cDesc1,_cDesc2,_cDesc3,.F.,,.T.,_Tamanho,,.F.)
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
	{ || f4_ROfC3(_titCob,.F.,cDocument) } )

	RestArea(aArea)
Return

//---------------------------------------------------------------------------------------------------//
// Rutina Secundaria de RECIBO: RECIBO COBROS DIVERSOS
//---------------------------------------------------------------------------------------------------//

static function f4_ROfC3(cTitulo,bImprimir,cDocument)
	Local _xfilial := XFILIAL("SE5")
	Local _csql  := ""
	Local _nLin := 0600
	Local _nInterLin := 100
	Local _nCol1 := 1800
	Local _nCol2 := 1200
	Local _nCol3 := 0125
	Local _nCol4 := 0050
	Local _dFecha
	Local _cCliente := ""
	LOCAL vwSE5 := GetNextAlias()
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
	DEFINE FONT oFont1 NAME "Arial" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,13 OF oPrn BOLD
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,11 OF oPrn
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,15 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,15 OF oPrn BOLD
	DEFINE FONT oFont6 NAME "Arial" SIZE 0,07
	DEFINE FONT oFont7 NAME "Times New Roman" SIZE 0,12 OF oPrn
	DEFINE FONT oFont8 NAME "Times New Roman" SIZE 0,08 OF oPrn
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:SetPortrait() // Vertical

	cQuery := ""
	cQuery := " SELECT E5_PROCTRA,E5_MOEDA,CASE E5_MOEDA WHEN '$' THEN 2 ELSE 1 END AS E5_MONEDA,E5_TXMOEDA,E5_DATA,E5_VALOR,E5_BANCO,E5_AGENCIA, "
	cQuery += " E5_CONTA,E5_RECPAG,E5_BENEF,E5_HISTOR,E5_TIPODOC,E5_VLMOED2, E5_DOCUMEN "
	cQuery += " FROM " + RetSqlName("SE5") + " SE5"
	cQuery += " WHERE E5_FILIAL = '" + xfilial("SE5") + "'"
	cQuery += " AND E5_PROCTRA = '" + cDocument + "'"
	cQuery += " AND E5_DATA BETWEEN '" + DTOS(SE5->E5_DATA) + "' AND '" + DTOS(SE5->E5_DATA) + "'"
	cQuery += " AND E5_TIPODOC = 'TR'"
	cQuery += " AND E5_VENCTO = ''"
	cQuery += " AND SE5.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY R_E_C_N_O_"
	memowrite("test.txt",cQuery)
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), vwSE5, .F., .T.)
	//Aviso("Array IVA",_csql,{'ok'},,,,,.t.)
	dbSelectArea(vwSE5)
	dbGoTop()

	if (vwSE5)->(!eof())
		CTM := (vwSE5)->E5_HISTOR
				_nLin := 0400
		oPrn:StartPage()
		_dFecha := (vwSE5)->E5_DATA
		Logo(cTitulo,(vwSE5)->E5_PROCTRA,_dFecha)

		dbSelectArea(vwSE5)
		_nEspCab := 0
		cValor := AllTrim(Transform((vwSE5)->E5_VALOR,PesqPict("SE5","E5_VALOR",19,1)))
		cSimb := (vwSE5)->E5_MOEDA
		_nLin := _nLin + 100
		oPrn:Say(_nLin , _nCol3 , " DE BANCO/CAJA " ,oFont1)
		_nLin := _nLin + 70
		oPrn:Say(_nLin , _nCol3, " CODIGO:" ,oFont2)
		oPrn:Say(_nLin , _nCol3 + 1000 , alltrim((vwSE5)->E5_BANCO) +" - " +  alltrim((vwSE5)->E5_AGENCIA) + " - " + alltrim((vwSE5)->E5_CONTA) ,oFont2)
		_nLin := _nLin + 70
		cBanco:= Posicione("SA6", 1, xFilial("SA6") + (vwSE5)->E5_BANCO + (vwSE5)->E5_AGENCIA + (vwSE5)->E5_CONTA, "SA6->A6_NOME")
		oPrn:Say(_nLin , _nCol3, " BANCO/CAJA:",oFont2)
		oPrn:Say(_nLin , _nCol3 + 1000, cBanco ,oFont2)
		_nLin := _nLin + 70
		(vwSE5)->(DBSKIP())
		oPrn:Say(_nLin , _nCol3 , "	A BANCO/CAJA " ,oFont1)
		_nLin := _nLin + 70
		oPrn:Say(_nLin , _nCol3, " CODIGO:",oFont2)
		oPrn:Say(_nLin , _nCol3 + 1000, alltrim((vwSE5)->E5_BANCO) +" - " +  alltrim((vwSE5)->E5_AGENCIA) + " - " + alltrim((vwSE5)->E5_CONTA),oFont2)
		_nLin := _nLin + 70
		cBanco:= Posicione("SA6", 1, xFilial("SA6") + (vwSE5)->E5_BANCO + (vwSE5)->E5_AGENCIA + (vwSE5)->E5_CONTA, "SA6->A6_NOME")
		oPrn:Say(_nLin , _nCol3, " BANCO/CAJA:",oFont2)
		oPrn:Say(_nLin , _nCol3 + 1000, cBanco ,oFont2)
		_nLin := _nLin + 70
		oPrn:Say(_nLin , _nCol3, " VALOR:",oFont2)
		oPrn:Say(_nLin , _nCol3 + 1000, alltrim(cValor) + " " + cSimb ,oFont2)
		
		_nLin := _nLin + 70
		if (vwSE5)->E5_MONEDA == 1
			oPrn:Say(_nLin , _nCol3, " SON:",oFont2)
			oPrn:Say(_nLin , _nCol3 + 1000, alltrim(Extenso( (vwSE5)->E5_VALOR,.F.,(vwSE5)->E5_MONEDA)) + "BOLIVIANOS",oFont2)
		else
			oPrn:Say(_nLin , _nCol3, " SON:",oFont2)
			oPrn:Say(_nLin , _nCol3 + 1000, alltrim(Extenso( (vwSE5)->E5_VALOR,.F.,(vwSE5)->E5_MONEDA)) + "DOLARES",oFont2)
		endif
		_nLin := _nLin + 70
		oPrn:Say( _nLin,_nCol3,  " GLOSA:", oFont2)
		oPrn:Say( _nLin,_nCol3 + 1000, alltrim(CTM), oFont2)
		_nLin := _nLin + 70
		oPrn:Say( _nLin,_nCol3,  " DOCUMENTO:", oFont2)
		oPrn:Say( _nLin,_nCol3 + 1000, alltrim((vwSE5)->E5_DOCUMEN), oFont2)

		_nLin := _nLin + 250
		oPrn:Say(_nLin, _nCol3 + 67,cUserName,oFont1 )
		oPrn:Say(_nLin, _nCol3 + 1300,"______________________",oFont1 )
		_nLin := _nLin + _nInterLin
		oPrn:Say(_nLin, _nCol3 + 65,"	Realizado por ",oFont1 )
		oPrn:Say(_nLin, _nCol3 + 1345,"	 Autorizado por ",oFont1 )

		#IFDEF TOP
		#ENDIF
		Ms_Flush() //JLJR: Sube lo cargado a TMSPrinter
		//JLJR: No Existe este metodo para el Objeto: Reload()
		oPrn:Refresh() //JLJR: Tampoco recarga como esperabamos...
		if bImprimir
			oPrn:Print()
		else
			oPrn:Preview()
		endIf

	else
		Aviso("Info","No hay informe para exhibir",{'ok'},,,,,.f.)
	endif
	If !Empty(Select(vwSE5))
		dbCloseArea()
	Endif
return

Static Function Logo(cTitulo,cDocument,_dFecha)
	// Say(Fila, Columna, Texto, Fuente)....
	//SM0->M0_NOMECOM
	oPrn:Say( nLin1,0080, SM0->M0_NOMECOM, oFont5)
	oPrn:Say( nLin2,0080, Capital(AllTrim(SM0->M0_ENDENT)), oFont4)
	oPrn:Say( nLin3,0080, "Tel. " + SM0->M0_TEL, oFont4)
	oPrn:Say( nLin4,0080, "Fax. " + SM0->M0_FAX, oFont4)
	oPrn:Say( nLin5,0080, IIF(Alltrim(SM0->M0_CIDCOB) == "SANTA CRUZ", "Santa Cruz de La Sierra", Capital(AllTrim(SM0->M0_CIDCOB))), oFont4)
	oPrn:Say( 0330 ,0900, cTitulo, oFont12)
	oPrn:Say( 0100 ,1500, "Nro Comprobante: " + cDocument, oFont5)
	oPrn:Say( 0200 ,1500, "Fecha: 			" + fecha(_dFecha), oFont5)
	
Return

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
