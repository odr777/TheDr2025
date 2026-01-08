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
±±ºAUTOR  	   ³ 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Recibo  para Cuentas por Cobrar  				  º±±
±±º            ³ Imprime un  respaldo al Cliente, cuando se cancela en    º±±
±±º            ³ Tesoreria se da un recibo que es solo cuando lo solicita º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºVersion     ³ V.001                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function CFinI204() // u_CFinI204()

	Local _cDesc1        	:= "Imprime como respaldo a la otra persona (Cliente o Proveedor),"
	Local _cDesc2        	:= "cuando en Tesoreria se da un recibo por entrega o recepcion de"
	Local _cDesc3        	:= "Dinero segun sea Cuenta por Cobrar o Pagar."

	
	Local _titulo       	:= "RECIBO - COBROS "
	Local _titCob       	:= "RECIBO - Cobros Diversos"
	Local _titAnt       	:= "RECIBO - Cobro Anticipado"
	Local _Cabec1        	:= ""
	Local _Cabec2        	:= ""
	Local _cString		  	:= ""
	Local aArea    := GetArea()
	Private _tamanho      	:= "P"     //P=Vertical(80) G=horizontal(220)	--> M=
	Private _nomeprog     	:= "CFinI204" // Coloque aquí el nombre del programa para impresión en el encabezado
	Private _nTipo        	:= 18

	Private _lEnd         	:= .F.
	Private _lAbortPrint  	:= .F.
	Private _CbTxt        	:= ""
	Private _limite       	:= 80

	Private aReturn      	:= { "A Rayas", 1, "Financiero", 2, 2, 1, "", 1}
	Private _nLastKey     	:= 0
	Private _cPerg        	:= "CIA400" // PARAMETROS DE Cuentas por Cobrar Anticipadas (RA)
	Private _cPergCD       	:= "FIR087" // PARAMETROS DE Cobros Diversos
	Private _cbtxt        	:= Space(10)
	Private _cbcont       	:= 00
	Private _CONTFL       	:= 01
	Private m_pag        	:= 01
	Private _wnrel        	:= "CFinI204"  // Nombre del archivo usado para impresión en disco segun el nombre del funcion

	
		pergunte(_cPergCD,.F.)  		// Invoca y establece los parametros en SX1 en el reporte                                                                                                 
		_wnrel := SetPrint("TRI",_nomeProg,_cPergCD,@_titCob,_cDesc1,_cDesc2,_cDesc3,.F.,,.T.,_Tamanho,,.F.)
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
	Local _cRecIni := MV_PAR01  // Recibo Inicial
	Local _cRecFin := MV_PAR02  // Recibo Final
	Local _cSerie  := MV_PAR03
	Local _xfilial := XFILIAL("SEL")

	Local _csql  := ""
	Local _csql2 := ""

	Local _nLin := 0600
	Local _nInterLin := 100
	Local _nCol1 := 1800
	Local _nCol2 := 1200
	Local _nCol3 := 0300
	Local _nCol4 := 0050
	Local aInfUser := pswret()
	Local _dFecha
	Local _cCliente := ""
	Local _cCliCXC := ""
	
	Local _aSumas := { {0,0}, {0,0} , {"Bs.-","Usd.-"}} // { Formas de Pago {,}, CxP {,}}
	Local _cCobDiv := "" 
	Local _cCobDiv2 := ""
	Local _nFinHoja := 3000
	Private _nMoneda := 0
	Private _nCambio := 0
	//Private _cValor

	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL
	// Referencia en relacion al Logo...

	PRIVATE nLin1	:= 0080
	PRIVATE nLin2	:= 0140
	PRIVATE nLin3	:= 0200
	PRIVATE nLin4	:= 0255
	PRIVATE nLin5	:= 0310

	If Funname()$ "FINA087A"
		_cRecIni := cRecibo  // Recibo Inicial
		_cRecFin := cRecibo  // Recibo Final
		_cSerie  := cSerie
	end

	DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,08 OF oPrn
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,15 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,15 OF oPrn BOLD
	DEFINE FONT oFont6 NAME "Arial" SIZE 0,07
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:SetPortrait() // Vertical

	_csql := "SELECT "  + Chr(13)
 	_csql := _csql + " EL_CANCEL,CTO_SIMB, CTO_DESC, M2_MOEDA2,  EL_MOEDA,EL_SERIE , " + Chr(13)
 	_csql := _csql + " EL_RECIBO, EL_TIPODOC, EL_TXMOE02, EL_NUMERO, EL_PARCELA, EL_TIPO, EL_TXMOEDA," + Chr(13)
 	_csql := _csql + " EL_DTDIGIT, EL_EMISSAO, " + Chr(13)
    _csql := _csql + " EL_CLIORIG, EL_LOJORIG, EL_OBSBCO,A1_COD, A1_NOME, A1_END, A1_TEL, A6_NOME, A6_NUMCON, A6_NREDUZ, " + Chr(13)
    _csql := _csql + " EL_USERLGI, EL_USERLGA,EL_COBRAD, " + Chr(13)
	_csql := _csql + " EL_VALOR " + Chr(13)

    _csql := _csql + " FROM " + RetSqlName("SEL") + " SEL "
    _csql := _csql + " INNER JOIN " + RetSqlName("CTO") + " CTO ON CAST(CTO_MOEDA AS TinyInt) = EL_MOEDA " + Chr(13)
    _csql := _csql + " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD + A1_LOJA = EL_CLIORIG + EL_LOJORIG " + CHR(13)
    _csql := _csql + " INNER JOIN " + RetSqlName("SM2") + " SM2 ON M2_DATA = EL_EMISSAO " + Chr(13)
    _csql := _csql + " INNER JOIN " + RetSqlName("SA6") + " SA6 ON " + CHR(13)
    _csql := _csql + " EL_BANCO + EL_AGENCIA + EL_CONTA =  A6_COD + A6_AGENCIA + A6_NUMCON AND SA6.D_E_L_E_T_ = ' '" + CHR(13)
	//JLJR: Desde aca necesito diferenciarlo ya que luego necesitare tomar de todos los pedidos especificos...
    _csql := _csql + " WHERE (EL_TIPODOC = 'CH ' OR EL_TIPODOC = 'TF ' OR EL_TIPODOC = 'EF ' OR EL_TIPODOC = 'CD ' OR EL_TIPODOC = 'CC ' )" + CHR(13)

    _cCond := " AND SEL.R_E_C_D_E_L_ = 0 "  + Chr(13)
    _cCond := _cCond + " AND SM2.R_E_C_D_E_L_ = 0 AND CTO.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' '" + Chr(13)
    _cCond := _cCond + " AND EL_RECIBO <= '" + _cRecFin + "' AND EL_RECIBO >= '" + _cRecIni + "'" + Chr(13)
    _cCond := _cCond + " AND EL_FILIAL = '" + _xfilial + "' AND EL_SERIE='" +_cSerie+ "'"

	_csql := _csql + _cCond + " ORDER BY EL_RECIBO "

//aviso("",_csql,{'ok'},,,,,.t.)
	  
 	cArea := 'RCOF3A'
 	If Select('RCOF3A') > 0
		RCOF3A->(DbCloseArea())
	End 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,, _csql), cArea ,.T.,.F.)
	
	_csql2 := "SELECT "  + Chr(13)
 	_csql2 := _csql2 + " EL_RECIBO, EL_TIPODOC, EL_NUMERO, EL_PARCELA, EL_TIPO, EL_TXMOEDA, EL_CLIENTE, EL_LOJORIG,EL_SERIE, " + Chr(13)
 	_csql2 := _csql2 + " CTO_SIMB, CTO_DESC, " + Chr(13)
 	_csql2 := _csql2 + " E1_HIST, E1_PEDIDO, E1_RECIBO, A1_COD, A1_LOJA, A1_NOME, A1_END, A1_TEL,E1_ORIGEM,E1_PREFIXO,E1_NUM,E1_PARCELA, " + Chr(13)
 	_csql2 := _csql2 + " EL_DTDIGIT, EL_EMISSAO,EL_COBRAD, " + Chr(13)
	_csql2 := _csql2 + " EL_VALOR " + Chr(13)
 	
    _csql2 := _csql2 + " FROM " + RetSqlName("SEL") + " SEL " + Chr(13)
    _csql2 := _csql2 + " INNER JOIN " + RetSqlName("CTO") + " CTO ON CAST(CTO_MOEDA AS TinyInt) = EL_MOEDA " + Chr(13)
    _csql2 := _csql2 + " INNER JOIN " + RetSqlName("SM2") + " SM2 ON M2_DATA = EL_EMISSAO " + Chr(13)
    _csql2 := _csql2 + " INNER JOIN " + RetSqlName("SE1") + " SE1 ON " + CHR(13)
    _csql2 := _csql2 + " E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO = EL_PREFIXO + EL_NUMERO + EL_PARCELA + EL_TIPO " + CHR(13)
    _csql2 := _csql2 + " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD + A1_LOJA = E1_CLIENTE + E1_LOJA " + CHR(13)

	// Desde aca necesito diferenciarlo ya que luego necesitare tomar de todos los pedidos especificos...
    _csql2 := _csql2 + " WHERE  SE1.R_E_C_D_E_L_ = 0 AND SA1.D_E_L_E_T_ = ' ' AND CTO.D_E_L_E_T_ = ' '" + CHR(13)
    _csql2 := _csql2 + " AND EL_FILIAL = '" + _xfilial + "' AND EL_SERIE='" +_cSerie+ "'"

	_csql2 := _csql2 + _cCond + " ORDER BY EL_RECIBO "

  	cArea2 := 'RCOF3B'
  	If Select('RCOF3B') > 0
		RCOF3B->(DbCloseArea())
	End 
  	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,, _csql2), cArea2 ,.T.,.F.)
	dbSelectArea(cArea2)
	dbGoTop()
	
	dbSelectArea(cArea)
	dbGoTop()
	_cCobDiv := EL_RECIBO
	__cSerie := EL_SERIE
	While !Eof()
		dbSelectArea(cArea)
 		_nLin := 0600
		oPrn:StartPage()
		Logo(cTitulo)

		_nEspCab := 0
 		if _cCobDiv == EL_RECIBO .And. !Eof()

	 		if AllTrim(EL_MOEDA) == "1"
				_nCambio := M2_MOEDA2
			else
				_nCambio := EL_TXMOE02
			end if

			_dFecha := EL_EMISSAO
			_cCobDiv := EL_RECIBO

	   		oPrn:Say(_nLin, _nCol4, "Cliente: " + Alltrim(A1_COD)+" - " + Alltrim(A1_NOME),oFont3)
	   		_nLin := _nLin + _nInterLin
	   		oPrn:Say(_nLin, _nCol4, "Dirección: " + Alltrim(A1_END),oFont3)
	   		oPrn:Say(_nLin, _nCol1, "Telefono: " + Alltrim(A1_TEL),oFont3)
	   		_nLin := _nLin + _nInterLin
	   		oPrn:Say(_nLin, _nCol4, "Cobrador: " + GetAdvFVal("SAQ","AQ_NOME",xFilial("SAQ")+EL_COBRAD,1,""),oFont3)
	   		_nLin := _nLin + _nInterLin
	   		oPrn:Say(_nLin, _nCol4, REPLICATE('_',100),oFont3) 
	   		_nLin := _nLin + _nInterLin
			_nEspCab := _nLin + _nInterLin
	 		_nLin := _nLin + _nInterLin * 2

			//oPrn:Say(_nLin , _nCol3 + 400, " Formas de Pago:" , oFont4)
			//DatBanc(@_nLin, _nCol3, _nInterLin)
            //****** datos banco
            _nLin := _nLin + nInterLin
            oPrn:Say(_nLin , _nCol3 , " Banco " ,oFont1)
            oPrn:Say(_nLin , _nCol3 +  400, " Cuenta del Banco " ,oFont1)
            oPrn:Say(_nLin , _nCol3 +  850, " Forma de Pago Nro. " ,oFont1)

            oPrn:Say(_nLin , _nCol3 + 1400,  " Monto ",oFont1)
            oPrn:Say(_nLin , _nCol3 + 1650,  " Moneda ",oFont1)
            //********************
			_cCliente := "("+EL_CLIORIG+"-"+EL_LOJORIG+")"+Alltrim(A1_NOME)
			_aSumas[1][1] := 0
			_aSumas[1][2] := 0

			Do While EL_RECIBO == _cCobDiv .And. !Eof()
			   	_nLin := _nLin + 50
			   	oPrn:Say(_nLin , _nCol3 -  80, Capital(Alltrim(A6_NOME)) ,oFont2)
			   	oPrn:Say(_nLin , _nCol3 +  400 , Alltrim(A6_NUMCON) ,oFont2)
			   	oPrn:Say(_nLin , _nCol3 +  750 , Tabela( "05", EL_TIPODOC, .F.) + " (" + AllTrim(EL_NUMERO) +")" ,oFont2)
				oPrn:Say(_nLin , _nCol3 + 1400 , Transform(EL_VALOR, "@E 999,999,999.99") ,oFont2)
				oPrn:Say(_nLin , _nCol3 + 1650 , Capital(CTO_SIMB) ,oFont2)

				if !Empty(EL_OBSBCO)
				   	_nLin := _nLin + 50
					oPrn:Say(_nLin, _nCol3, " Observaciones del Banco: " ,oFont1)
					oPrn:Say(_nLin, _nCol3 + 500, AllTrim(EL_OBSBCO) ,oFont2)
				end if

				_cCobDiv := EL_RECIBO
				_nMoneda := Val(EL_MOEDA)
				_aSumas[1][_nMoneda] += EL_VALOR
				dbSkip()
			enddo
		endif

		// nLin en relaciçon al Logo
   		oPrn:Say(nLin1, _nCol1 - 80, "RECIBO No.:" + _cCobDiv +"-"+ __cSerie , oFont4) //EL_RECIBO sería del siguiente...
   		
   		oPrn:Say(nLin3, _nCol1-80, "FECHA:" + (dtoC(stod(_dFecha))) ,oFont4)
   		oPrn:Say(nLin4, _nCol1, "TC." + AllTrim(CValToChar(_nCambio)) ,oFont4)
   		oPrn:Say(nLin5, _nCol1, "- - - - - - - - -",oFont4)

   		if _aSumas[1][nDolares] > 0 
   			oPrn:Say(nLin2, _nCol1 - 80, _aSumas[3][nDolares] ;
   				 + Transform(_aSumas[1][nDolares],"@E 9,999,999,999.99") ,oFont5 )
   			if _nEspCab != 0
		   		oPrn:Say(_nEspCab - 100, _nCol4, "Ha cancelado la suma de: " ;
		   			+ Alltrim(extenso(_aSumas[1][nDolares] )+iif(Alltrim(Upper(_aSumas[3][nDolares]))$"BOLIVIANO".OR.AllTrim(_aSumas[3][nDolares])$"Bs.-","Bolivianos","Dolares")),oFont3)
		   	end if
		end if
	   	if _aSumas[1][nBolivianos] > 0 
   			oPrn:Say(nLin2 , _nCol1 - 80, _aSumas[3][nBolivianos] ;
   				 + Transform(_aSumas[1][nBolivianos],"@E 9,999,999,999.99") ,oFont5 )
   			if _nEspCab != 0
		   		oPrn:Say(_nEspCab , _nCol4, "Ha cancelado la suma de: " ;
			   			+ Alltrim(extenso(_aSumas[1][nBolivianos] )+iif(Alltrim(Upper(_aSumas[3][nBolivianos]))$"BOLIVIANO".OR.AllTrim(_aSumas[3][nBolivianos])$"Bs.-","Bolivianos","Dolares")),oFont3)
		   	end if
		end if

		_nLin := _nLin + _nInterLin
   		oPrn:Say(_nLin, _nCol3, "Conceptos: ", oFont3)
   		_nLin := _nLin + _nInterLin

		dbSelectArea(cArea2)
		/* Temporalmente para asegurarme que las 2 consultas tienen los mismos recibos		
				oPrn:Say(_nLin, _nCol3 + 200, AllTrim(E1_RECIBO) ,oFont2)
		   		_nLin := _nLin + 50 */
		_cCobDiv2 := _cCobDiv
		Do While (EL_RECIBO == _cCobDiv2) .And. !Eof() .And. _nFinHoja>_nLin

	   		if !Empty(E1_HIST)
				oPrn:Say(_nLin, _nCol3, " *** " ,oFont1) //+ E1_RECIBO
				oPrn:Say(_nLin, _nCol3 + 200, AllTrim(E1_HIST) ,oFont2)
		   		_nLin := _nLin + 50 //2*nInterLin
	   		end if
	   		_cCliCXC := "(" + A1_COD + "-" + A1_LOJA + ")" + Alltrim(A1_NOME)
	   		if ( _cCliente != _cCliCXC )
				oPrn:Say(_nLin, _nCol3, " Deuda de: " + Transform(EL_VALOR, "@E 999,999,999.99 ") + " " + Capital(CTO_SIMB) + "- ;Deudor: " ,oFont1) //+ E1_RECIBO
				oPrn:Say(_nLin, _nCol3 + 720, AllTrim(_cCliCXC) ,oFont2)
		   		_nLin := _nLin + 50 //2*nInterLin
	   		end if
	   		if ALLTRIM(E1_ORIGEM)$"MATA467N|MATA460|FINA040"
				oPrn:Say(_nLin, _nCol3,IIF(ALLTRIM(E1_ORIGEM)$'FINA040',"Nro. Titulo: ","Factura: ") +ALLTRIM(E1_PREFIXO)+"-"+ Alltrim(E1_NUM) + iif(!empty(E1_PARCELA),"-" + E1_PARCELA,""),oFont2 )
				oPrn:Say(_nLin , _nCol3 + 1400 , Transform(EL_VALOR, "@E 999,999,999.99") ,oFont2)
				oPrn:Say(_nLin , _nCol3 + 1650 , Capital(CTO_SIMB) ,oFont2)
		   		_nLin := _nLin + 50 //2*nInterLin
		   	ELSE
		   		if (alltrim(EL_TIPODOC) $ "RA")
		   			oPrn:Say(_nLin, _nCol3,"Anticipo: " +ALLTRIM(E1_PREFIXO)+"-"+ Alltrim(E1_NUM) + iif(!empty(E1_PARCELA),"-" + E1_PARCELA,""),oFont2 )
		   			oPrn:Say(_nLin , _nCol3 + 1400 , Transform(EL_VALOR, "@E 999,999,999.99") ,oFont2)
		   			oPrn:Say(_nLin , _nCol3 + 1650 , Capital(CTO_SIMB) ,oFont2)
		   			_nLin := _nLin + 50 //2*nInterLin
				END
		 	end if
			_cCobDiv2 := EL_RECIBO
			dbSkip()
			_cCobDiv := EL_RECIBO
		End Do

		if _nFinHoja > _nLin + nInterLin
			//FirCobr( @_nLin, _nCol3, _nInterLin, _dFecha, _cCliente, aInfUser[1][4])
		end if
		oPrn:EndPage()
    enddo
    #IFDEF TOP
	    dBCloseArea()
//		dbSelectArea(cArea)
	    dBCloseArea()
    #ENDIF
	Ms_Flush() //JLJR: Sube lo cargado a TMSPrinter
	//JLJR: No Existe este metodo para el Objeto: Reload()
	oPrn:Refresh() //JLJR: Tampoco recarga como esperabamos...
	if bImprimir
		oPrn:Print()
	else
		oPrn:Preview()
	end If
	
_csql:=Upper(_csql)
MemoWrite("_csql.sql",_csql)
MemoWrite("\_csql2.sql",_csql2) 

return

Static Function Logo(cTitulo)
// Say(Fila, Columna, Texto, Fuente)....
	//SM0->M0_NOMECOM 
	oPrn:Say( nLin1,0080, SM0->M0_NOME, oFont5) 
	oPrn:Say( nLin2,0080, Capital(AllTrim(SM0->M0_ENDENT)), oFont4)
	oPrn:Say( nLin3,0080, "Tel. " + SM0->M0_TEL, oFont4)
	oPrn:Say( nLin4,0080, "Fax. " + SM0->M0_FAX, oFont4)
	oPrn:Say( nLin5,0080, IIF(Alltrim(SM0->M0_CIDCOB) == "SANTA CRUZ", "Santa Cruz de La Sierra", Capital(AllTrim(SM0->M0_CIDCOB))), oFont4)
	oPrn:Say( 0400 ,0780, iif(EL_CANCEL == 'F',cTitulo,cTitulo+"  " + "----ANULADO----"), oFont5)
Return

/*Static Function DatBanc(_nLin, _nCol3, nInterLin, lImpBsUs)
	Default lImpBsUs := .F.

	_nLin := _nLin + nInterLin
   	oPrn:Say(_nLin , _nCol3 , " Banco " ,oFont1)
   	oPrn:Say(_nLin , _nCol3 +  400, " Cuenta del Banco " ,oFont1)
   	oPrn:Say(_nLin , _nCol3 +  850, " Forma de Pago Nro. " ,oFont1)

	oPrn:Say(_nLin , _nCol3 + 1400, Iif( lImpBsUs, " Monto_Bs ", " Monto "),oFont1)
	oPrn:Say(_nLin , _nCol3 + 1650, Iif( lImpBsUs, " Monto_Us ", " Moneda "),oFont1)

return*/


static function FirCobr(_nLin, _nCol3, _nInterLin, _dFecha, _cCliente, _cUsuAct)  

	Local _nImpCli := 0
	Local aLogoEmpresa := SuperGetMV( "MV_LOGEMP", , "{'Empresa','" + SM0->M0_NOME + "'}")
	_cCliente := SubStr(_cCliente, 1, 42)
	_nImpCli  := Len( _cCliente)%2
	
	_nLin := _nLin + _nInterLin
	LugEmp( @_nLin, _nInterLin, _nCol3, _dFecha)

   	oPrn:Say(_nLin , _nCol3 ," " + Replicate("_",38) ,oFont4 )
   	oPrn:Say(_nLin , _nCol3 + 1000," " + Replicate("_",42) ,oFont4 )
   	_nLin := _nLin + 60
   	// Calcular según el largo del Nombre...
   	oPrn:Say(_nLin, _nCol3 - 80 - _nImpCli, _cCliente, oFont5)
   	oPrn:Say(_nLin, _nCol3 + 1020, aLogoEmpresa[1],oFont5 )
   	_nLin := _nLin + 60
   	oPrn:Say(_nLin, _nCol3 + 1220, aLogoEmpresa[2]+ AllTrim(Str(Year(STOD(_dFecha)))),oFont5 )
   	_nLin := _nLin + _nInterLin
   	oPrn:Say(_nLin, _nCol3 +  950, DTOC(DATE()) + " - " + TIME() + " - Usuario Actual: " + UsrFullName(), oFont1)

return

static function LugEmp( _nLin, _nInterLin, _nCol3, _dFecha) //Lugar de la Empresa...
	//adv: oPrn:Say(_nLin , _nCol3 + 400, IIF( Alltrim(SM0->M0_CIDCOB) == "SANTA CRUZ", "Santa Cruz de la Sierra", ;
	//	Capital(AllTrim(SM0->M0_CIDCOB)) ) + ", " + u_f4_fecha(_dFecha), oFont4)
   	
	oPrn:Say(nLin4 , 1800, fecha(_dFecha), oFont4)
	//oPrn:Say(nLin4 ,_nCol1 , u_f4_fecha(_dFecha), oFont4)
   	_nLin := _nLin + ( _nInterLin * 3)

return


static function DetalleBco( _nLin, _nCol3, _nValor, _cSimb)

   	_nLin := _nLin + 80
   	oPrn:Say(_nLin , _nCol3 -  80, Capital(Alltrim(A6_NOME)), oFont2)
   	oPrn:Say(_nLin , _nCol3 +  400 , Alltrim(A6_NUMCON), oFont2)
   	oPrn:Say(_nLin , _nCol3 +  850 , IIf( SubStr(E5_BANCO,1,2) == 'CJ','Efectivo ', ;
   		IIf(AllTrim(E5_NUMCHEQ)=='','Transferencia ','Cheque ' + AllTrim(E5_NUMCHEQ) ) ), oFont2)
	oPrn:Say(_nLin , _nCol3 + 1400 , Transform( _nValor, "@E 9,999,999,999.99"), oFont2)
	oPrn:Say(_nLin , _nCol3 + 1650 , Capital(_cSimb), oFont2)
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
