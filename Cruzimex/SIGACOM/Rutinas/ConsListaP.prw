#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConsListaP ºAutor  ³Nain Terrazas      º Data ³  18.10.00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍ±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍ±ÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcion responsable por F3 de la SC6 que busca con lista de º±±
±±º          ³ precio, actualizado para Buscar 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ConsListaP                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍ±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ConsListaP(_lSXB)

	Local _aArea    := GetArea()
	Private _aBuscaProd	:= {{"","","","","","",""}}
	Private aViewB2		:= {{"","","","","","","","",""}}
	Private aViewDA1	:= {{"","","","","","","","","","","","","",""}}
	Private _aProdSim	:= {{"","","",""}}
	Private _cProdSel	:= ""
	Private lBrowse 	:= .t.
	//PRIVATE INCLUI  	:= .F.
	PRIVATE cCadastro	:= "Consulta General del Producto"
	Private oDlg
	private oSayProd
	Private L110AUTO:=.F.
	DEFAULT _lSXB	:= .T.

	//Alert("Caso esta rotina seja utiliza, avise-nos pois dentro de dias a mesma sera removida !!! ")

	_aGets := {}
	AADD(_aGets,{"B1_COD",Space(20)})
	AADD(_aGets,{"B1_DESC",Space(40)})
	AADD(_aGets,{"B1_ESPECIF",Space(80)})
	AADD(_aGets,{"B1_UCODFAB",Space(15)})
	AADD(_aGets,{"B1_GRUPO",Space(4)})
	AADD(_aGets,{"B1_UMARCA",Space(30)})

//	alert("Nahim")
	_aOrdem  := {"Ascendente","Descendente"}
	_cOrdem  :=_aOrdem[1]

	//ALERT("Bemvindo")

	If lBrowse

		@ 000,000 To 540,1100 DIALOG oDlg TITLE "Consulta de Productos"

		@ 010,005 SAY "CODIGO" Object oSayProd
		@ 010,050 MSGET _aGets[1,2] SIZE 060,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_COD")

		@ 025,005 SAY "DESC." Object oSayDesc
		@ 025,050 MSGET _aGets[2,2] SIZE 150,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_DESC")

		@ 040,005 SAY "DESC.ESPECIF" Object oSayDesc
		@ 040,050 MSGET _aGets[3,2] SIZE 300,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_ESPECIF")

		@ 055,005 SAY "COD.FABRICA" Object oSayDescEsp
		@ 055,050 MSGET _aGets[4,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_UCODFAB")
		@ 055,200 SAY "GRUPO" Object oSayProd
		@ 055,230 MSGET _aGets[5,2] SIZE 020,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_GRUPO") F3 "SBM

		@ 010,370 BUTTON "&Buscar" SIZE 040,010 ACTION BuscaProd(1) Object oBnt // Nahim Terrazas 19/03/2019
		@ 010,450 BUTTON "&Buscar con Stock" SIZE 060,010 ACTION BuscaProd(2) Object oBnt // Nahim Terrazas 19/03/2019
		@ 025,370 BUTTON "Foto Producto" SIZE 040,010 ACTION MostraFoto(_cProdSel) Object oBnt
		@ 025,170 BUTTON "&Incluir" SIZE 040,010 ACTION  AxInclui('SB1',,3,,,,,,,,,,,.T.) Object oBnt
		@ 055,370 BUTTON "&Aceptar" SIZE 040,010 ACTION oDlg:End() Object oBnt

		//@ 112,005 BUTTON "Cons Producto" SIZE 040,008 ACTION ConsProd(_cProdSel) Object oBnt
		//	@ 112,060 BUTTON "Kardex por Dia" SIZE 040,008 ACTION ConsKard(_cProdSel) Object oBnt

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Inicia montagem do browse (Busca Produtos).                             ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		oListProd := TWBrowse():New(  070,05,545,065,,{"Codigo","Descr.","Descr. Especifica","Cod.Fabrica","Grupo","Marca"},{40,150,300,50,20,80},oDlg,,,,,{||IF(LEN(_aBuscaProd)>0,MostrarDatos(_aBuscaProd[oListProd:nAT,1],.T.),.t.)},,,,,,,.F.,,.T.,,.F.,,,)
		oListProd :SetArray(_aBuscaProd)
		//oListProd :bChange := { || if(Len(_aBuscaProd)>0,MostrarProducto(_aBuscaProd[oListProd:nAT],,.F.),.t.)}
		oListProd :bLine := { || if(Len(_aBuscaProd)>0,_aBuscaProd[oListProd:nAT],.t.)}
		oListProd :bWhen := { || if(Len(_aBuscaProd)>0,_aBuscaProd[oListProd:nAT],.t.)}
		// Andre Kraauss 22/03/2019 -> Actualizacion de producto sin hacer doble click
	    oListProd :bSeekChange := {||IF(LEN(_aBuscaProd)>0,MostrarDatos(_aBuscaProd[oListProd:nAT,1],.T.),.t.)}
	    oListProd :bDrawSelect := {||IF(LEN(_aBuscaProd)>0,MostrarDatos(_aBuscaProd[oListProd:nAT,1],.T.),.t.)}


		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Inicia montagem do browse (Produtos Similares).                         ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//	oListSim := TWBrowse():New( 072,105,280,060,,{"Codigo","Descripcion","Unid","Precio Venta"},{50,165,15,40},oDlg,,,,,{||If(Len(_aProdSim)>0,MostraEst(_aProdSim[oListSim:nAT,1],.T.),.T.)},,,,,,,.F.,,.T.,,.F.,,,)
		//	oListSim :SetArray(_aProdSim)
		//	oListSim :bLine := { || If(Len(_aProdSim)>0,_aProdSim[oListSim:nAT],.t.)}

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Inicia montagem do browse (Saldos em Estoque).                          ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		oListBox := TWBrowse():New( 140,05,545,060,,{"Empresa/Sucursal","Alm.","Disponible","Saldo Actual","Pedido Ventas","Reservada","Prevista Entrada","Reservada S.A.","Reservada"},{65,15,42,42,42,42,42,42,42,42,42},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || If(Len(aViewB2)>0,aViewB2[oListBox:nAT],.t.)}

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Inicia montagem do browse (Lista do Preco).                          ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		oListBox1 := TWBrowse():New( 205,05,545,060,,{"Empresa/Sucursal","Lista","Mon","Precio Venta","Desc 00%","Desc 05%","Desc 10%","Desc 12%","Desc 15%","Desc 17%","Desc 20%","Desc 23%","Desc 28%","Desc 32%"},{65,25,15,42,42,42,42,42,42,42,42,42,42,42},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox1:SetArray(aViewDA1)
		oListBox1:bLine := { || If(Len(aViewDA1)>0,aViewDA1[oListBox1:nAT],.t.)}
		
		if !Empty(&(READVAR()))
		_aGets[1,2]:=&(READVAR())
		_cProdSel:=&(READVAR())
		//BuscaProd(1)
		_cProdSel:=&(READVAR())

		End
		
		ACTIVATE DIALOG oDlg CENTERED

	EndIf

	RestArea(_aArea)

	If _lSXB
		&(READVAR()) := _cProdSel
	End

Return(.T.)

// nahim modificado para adicionar busqueda con Stock 19/03/19

Static Function BuscaProd(nTipo)
	Local _cQueryProd,_nCont,_nContCpo:=0

	_nContPre:=0   //Conta campos preenchidos
	For _nCont:=1 to Len(_aGets)
		If !Empty(_aGets[_nCont,2])
			_nContPre++
		Endif
	Next _nCont

	If _nContPre == 0
		Aviso("Importante","Necesario llenar uno de los campos para la b±±±squeda",{"OK"})
		Return
	Endif

	_cProdSel := ""

	If Select("BUSCAPROD") > 0
		BUSCAPROD->(DbCloseArea())
	Endif

	_cQueryProd:="SELECT SB1.* "
	_cQueryProd+=" FROM " + RetSqlName("SB1") +" SB1 "

	_cQueryProd+=" WHERE "

	//Processando matriz de GETS
	For _nCont:=1 to Len(_aGets)

		If !Empty(_aGets[_nCont,2])
			_nContCpo++
			If _nContCpo > 1
				_cQueryProd+=" AND "
			End
			_cBusca:=Alltrim(_aGets[_nCont,2])
			_lContinua:=.T.
			_nContEsp:=1
			While _lContinua

				If _nContEsp > 1
					_cQueryProd+=" AND "
				End

				_nPos:= At(" ",_cBusca)

				If _nPos == 0
					//NT Adicionado para buscar en Nombre y Descripci±±±n
					If _nCont == 2
						_cQueryProd+= _aGets[_nCont,1]+" + "+_aGets[_nCont+1,1]  + " LIKE '%" + _cBusca + "%' "
						_lContinua:=.F.
					Else
						_cQueryProd+= _aGets[_nCont,1] + " LIKE '%" + _cBusca + "%' "
						_lContinua:=.F.
					EndIf
				Else
					If _nCont == 2
						_cQueryProd+= _aGets[_nCont,1]+" + "+_aGets[_nCont+1,1] + " LIKE '%" + Subst(_cBusca,1,(_nPos-1)) + "%' "
						_cBusca:=Subst(_cBusca,(_nPos+1))
					Else
						_cQueryProd+= _aGets[_nCont,1] + " LIKE '%" + Subst(_cBusca,1,(_nPos-1)) + "%' "
						_cBusca:=Subst(_cBusca,(_nPos+1))
					EndIf
				End
				_nContEsp++
			End
		End
	Next _nCont
	
	if nTipo == 2 // si es 2 busca S±±±lo con Stock
		cAlmacen := SuperGetMv('MV_UCONSAM',.f.,"") // Nahim Verifica el almacén especifico  NTP 05/02/2020
		if !empty(cAlmacen)
			_cQueryProd+=" and B1_COD IN (SELECT B2_COD FROM " + RetSqlName("SB2") +" SB2  WHERE B2_QATU >0 AND B2_LOCAL in ("+ cAlmacen +") )" // NTP 05/02/2020
		else
			_cQueryProd+=" and B1_COD IN (SELECT B2_COD FROM " + RetSqlName("SB2") +" SB2  WHERE B2_QATU >0)"
		endif
	endif
	
	cValorP := SuperGetMv('MV_UCONSTP',.f.,"")
	
	if !empty(cValorP)
	_cQueryProd+=" AND B1_TIPO in ("+ cValorP +") "
	endif
	
	_cQueryProd+=" AND SB1.D_E_L_E_T_ <> '*'"
	_cQueryProd+=" ORDER BY B1_COD "
	If(Left(_cOrdem,1))=='D'
		_cQueryProd+=" DESC"
	End
//	Aviso("query",_cQueryProd,{"si"},,,,,.T.)

	TCQUERY _cQueryProd NEW ALIAS "BUSCAPROD"

	IF BUSCAPROD->(!EOF()) .AND. BUSCAPROD->(!BOF())
		BUSCAPROD->(DbGoTop())

		ASIZE(_aBuscaProd,BUSCAPROD->(RecCount()))
		ASIZE(aViewB2,0)
		ASIZE(aViewDA1,0)
		_nCont:=0

		WHILE BUSCAPROD->(!EOF())
			if _nCont==1
				_aBuscaProd[1,1]:=BUSCAPROD->B1_COD
				_aBuscaProd[1,2]:=alltrim(BUSCAPROD->B1_DESC)
				_aBuscaProd[1,3]:=alltrim(BUSCAPROD->B1_ESPECIF)
				_aBuscaProd[1,4]:=alltrim(BUSCAPROD->B1_UCODFAB)
				_aBuscaProd[1,5]:=alltrim(BUSCAPROD->B1_GRUPO)
				_aBuscaProd[1,6]:=alltrim(BUSCAPROD->B1_UMARCA)
				_nCont++
			Else
				//AADD(_aBuscaProd,{BUSCAPROD->B1_COD,BUSCAPROD->B1_DESC,alltrim(BUSCAPROD->B1_ESPECIF),IIf(!Empty(_aGets[4,2]),BUSCAPROD->ZNO_DESC,BUSCAPROD->B1_UNORMA)})
				AADD(_aBuscaProd,{BUSCAPROD->B1_COD,alltrim(BUSCAPROD->B1_DESC),alltrim(BUSCAPROD->B1_ESPECIF),alltrim(BUSCAPROD->B1_UCODFAB),alltrim(BUSCAPROD->B1_GRUPO),alltrim(BUSCAPROD->B1_UMARCA)})
			End
			BUSCAPROD->(DbSkip())
		END
	End

	oListProd:Refresh()
	oListBox1:Refresh()
Return

Static Function MostrarDatos(cProduto,_lSim,cArmazem,lBrowse,aArmazem)
	MostraEst(_aBuscaProd[oListProd:nAT,1],.T.)
	MostraLista(_aBuscaProd[oListProd:nAT,1],.T.)
Return _cProdSel

Static Function MostrarProducto(cProduto,_lSim,_lSXB)
	_cProdSel:= cProduto

	If _lSXB
		oDlg:End()
	End
Return cProduto

Static Function MostraEst(cProduto,_lSim,cArmazem,lBrowse,aArmazem)
	Local aStruSB2  := {}
	Local oCursor	:= LoadBitMap(GetResources(),"LBNO")
	Local nTotDisp	:= 0
	Local nSaldo	:= 0
	Local nQtPV		:= 0
	Local nQemp		:= 0
	Local nSalpedi	:= 0
	Local nReserva	:= 0
	Local nQempSA	:= 0
	Local nX        := 0
	Local cQuery    := ""
	Local _cNomeEmp := ""
	Local _cCodEmp  := ""
	Local y

	_cProdSel:= cProduto
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Trata parametro de pesquisa por Armazem. Caso o parametro nao seja     ±±±
	//±±± passado, listara todos os armazens encontrados.                        ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	If ValType(cArmazem) == 'U'
		cArmazem := "I"
	EndIf

	If ValType(aArmazem) == 'U'
		aArmazem := {}
	EndIf

	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Trata parametro de visualizacao do Browse. Caso o parametro nao seja   ±±±
	//±±± passado, apresenta o Browse de consulta.                               ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	If ValType(lBrowse) == 'U'
		lBrowse := .t.
	EndIf
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Posiciona o cadastro de produtos                                       ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	DbSelectArea('SB1')
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto,.f.)
		cCursor   := "MAVIEWSB2"
		lQuery    := .T.
		aStruSB2  := SB2->(dbStruct())

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Abre arquivo de empresas para obter empresas para consulta do estoque  ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		DbSelectArea("SM0")
		DbSetOrder(1)
		DbGoTop()

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Monta cQuery para realizar select no SB2 de todas as Empresas e Filiais ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		_cOrdQuery:=1
		_cOrdQueryAux:=50
		_cOrdQueryAct:=0
		_aQuery:={}

		While !Eof()
			//Condi±±±±±±o adicionada enquando se configura os arquivos da filial 02
			/*
			If SM0->M0_CODIGO <> CEMPANT
			DbSkip()
			Loop
			Endif
			*/
			_cNomeEmp := Alltrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL)
			_cCodEmp  := SM0->(M0_CODIGO+M0_CODFIL)

			//cNom := 'HPM SRL / Sucre'
			//cCodE:= '03 / 05'

			//Aviso("SM0",_cNomeEmp,{"OK"})
			If 	TCCANOPEN("SB2"+SM0->M0_CODIGO+"0") // .and. TCCANOPEN("SC6"+SM0->M0_CODIGO+"0") .and.  TCCANOPEN("SF2"+SM0->M0_CODIGO+"0")
				If SM0->M0_CODIGO == CEMPANT .AND.SM0->M0_CODFIL == CFILANT
					_cOrdQuery:= 1
				Else
					If (SM0->M0_CODIGO == CEMPANT)
						_cOrdQuery++
					Else
						_cOrdQueryAct:=	_cOrdQuery
						_cOrdQuery+=_cOrdQueryAux
					Endif
				Endif
				//Aviso("SM0",_cNomeEmp,{"OK"})

				cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
				cQuery += "B2_COD,B2_LOCAL,B2_QATU,B2_QPEDVEN,B2_QEMP,B2_SALPEDI,B2_QEMPSA,B2_RESERVA,B2_QEMPPRJ,B2_QACLASS,B2_STATUS "
				/*cQuery += " ,(Select Sum(C6_QTDVEN-C6_QTDENT-C6_QTDEMP) SALDOPED "
				cQuery += " From SC6"+SM0->M0_CODIGO+"0 SC6 "
				cQuery += " Inner Join SF4"+SM0->M0_CODIGO+"0 SF4 On C6_TES = F4_CODIGO and SF4.D_E_L_E_T_ = '' "
				cQuery += " Left Outer Join SF2"+SM0->M0_CODIGO+"0 SF2 On F2_FILIAL = C6_FILIAL and F2_PEDPEND = C6_NUM and SF2.D_E_L_E_T_ = '' "
				cQuery += " Where C6_FILIAL = B2_FILIAL and "
				cQuery += "       C6_LOCAL = B2_LOCAL and "
				cQuery += "       C6_PRODUTO = B2_COD and "
				cQuery += "       C6_QTDVEN <> C6_QTDENT and "
				cQuery += "       C6_BLQ <> 'S"+Space(Len(SC6->C6_BLQ)-1)+"' and "
				cQuery += "       C6_BLQ <> 'R"+Space(Len(SC6->C6_BLQ)-1)+"' and "
				cQuery += "       (C6_QTDVEN > C6_QTDENT OR (C6_QTDVEN <= C6_QTDENT AND C6_ENTREG>='"+DTOS(dDataBase-31)+"')) AND "

				If FunName() == 'MATA410' .and. Altera
				cQuery += "SC6.C6_NUM <> '" + M->C5_NUM + "' and "
				Endifz

				cQuery += "      F2_PEDPEND is null and "
				cQuery += "      F4_ESTOQUE = 'S' and "
				cQuery += "      SC6.D_E_L_E_T_ = '') SALPED "*/
				cQuery += "FROM SB2"+SM0->M0_CODIGO+"0 WHERE "
				cQuery += "B2_FILIAL = '"+SM0->M0_CODFIL+"' AND "

				_cOrdQuery:=	_cOrdQueryAct
				//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				//±±± Faz tratamento para pesquisa dos Armazens.                              ±±±
				//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				If Len(aArmazem) > 0

					If cArmazem == "E"
						cQuery += " B2_LOCAL NOT IN ("
					Else
						cQuery += "B2_LOCAL IN ("
					EndIf

					For y := 1 to Len(aArmazem)
						If y > 1
							cQuery += ","
						EndIf
						cQuery += "'"+aArmazem[y]+"'"
					Next
					cQuery += ") AND"

				EndIf

				cQuery += "B2_COD in ('"+cProduto+"') AND "
				cQuery += "D_E_L_E_T_ = '' "

			Endif
			DbSkip()

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Acrescenta clausula "Union" para juntar todas as select's.              ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//NT borrado por warning		_cQuery:=""
			//Aviso("SM0",_cNomeEmp,{"OK"})
			IF TCCANOPEN("SB2"+SM0->M0_CODIGO+"0") // .and. TCCANOPEN("SC6"+SM0->M0_CODIGO+"0") .and. TCCANOPEN("SF2"+SM0->M0_CODIGO+"0")
				/*	        if SM0->M0_CODIGO <> CEMPANT
				DbSkip()
				loop
				end				*/
				//Aviso("SM0",_cNomeEmp,{"OK"})
				If !Eof()
					cQuery += "UNION "
				Else
					cQuery += "ORDER BY ORDFIL"//,B2_COD, B2_LOCAL"
				EndIf
				Aadd(_aQuery,cQuery)
				cQuery:=""
			END

		EndDo
		If !Empty(cQuery)
			cQuery += "ORDER BY ORDFIL"//,B2_COD, B2_LOCAL"
		End

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Valida Query a ser executada.                                           ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

		cQuery := ChangeQuery(If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + If(LEN(_aQuery)>=12,_aQuery[12],'') + ' ' + If(LEN(_aQuery)>=13,_aQuery[13],'') + ' ' + If(LEN(_aQuery)>=14,_aQuery[14],'') + ' ' + If(LEN(_aQuery)>=15,_aQuery[15],'') + ' ' + cQuery)
		SB2->(dbCommit())

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Cria Alias temporario com o resultado da Query.                         ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Ajusta os campos que nao sao Caracter de acordo com a estrutura do SB2  ±±±
		//±±± uma vez que a TcGenQuery retorna todos os campos como Caracter.         ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		For nX := 1 To Len(aStruSB2)
			If aStruSB2[nX][2]<>"C"
				TcSetField(cCursor,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
			EndIf
		Next nX

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Inicia montagem do array (aViewB2) para visualizacao no Browse e        ±±±
		//±±± posterior retorno da funcao.                                            ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		_cNomeEmp  := ""
		_cNomeEmpA := ""

		_cCodEmp   := ""
		_cCodEmpA  := ""

		_cCodPro   := ""
		_cCodProA  := ""

		DbSelectArea(cCursor)

		ASIZE(aViewB2,(cCursor)->(RecCount()))

		DbSelectArea(cCursor)
		DbGoTop()
		While ( !Eof() )

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Trata variaveis a serem passadas para o Array para nao poluir o Browse. ±±±
			//±±± Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			If _cCodEmpA == Alltrim((cCursor)->CODFIL) .and. lBrowse
				_cNomeEmp := ""
				_cCodEmp  := ""
			Else
				_cNomeEmp := Alltrim((cCursor)->NOMEFIL)
				_cCodEmp  := Alltrim((cCursor)->CODFIL)
			EndIf

			_cNomeEmpA := Alltrim((cCursor)->NOMEFIL)
			_cCodEmpA  := Alltrim((cCursor)->CODFIL)

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Trata variaveis a serem passadas para o Array para nao poluir o Browse. ±±±
			//±±± Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			If _cCodProA == Alltrim((cCursor)->B2_COD) .and. lBrowse
				_cCodPro := ""
			Else
				_cCodPro := Alltrim((cCursor)->B2_COD)
			EndIf

			_cCodProA    := Alltrim((cCursor)->B2_COD)

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Inicia montagem do Array.                                               ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

			If lBrowse
				aAdd(aViewB2,{_cNomeEmp,;
				TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
				TransForm(SaldoSB2(,,,,,cCursor),PesqPict("SB2","B2_QATU")),;
				TransForm((cCursor)->B2_QATU,PesqPict("SB2","B2_QATU")),;
				TransForm((cCursor)->B2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
				TransForm((cCursor)->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
				TransForm((cCursor)->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
				TransForm((cCursor)->B2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
				TransForm((cCursor)->B2_RESERVA,PesqPict("SB2","B2_RESERVA"))})
			Else
				aAdd(aViewB2,{_cNomeEmp,;
				(cCursor)->B2_LOCAL,;
				SaldoSB2(,,,,,cCursor),;
				(cCursor)->B2_QATU,;
				(cCursor)->B2_QPEDVEN,;
				(cCursor)->B2_QEMP,;
				(cCursor)->B2_SALPEDI,;
				(cCursor)->B2_QEMPSA,;
				(cCursor)->B2_RESERVA})
			EndIf

			DbSelectArea(cCursor)
			DbSkip()
		EndDo

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Fecha arquivo temporario da TcGenQuery                                  ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		DbSelectArea(cCursor)
		DbCloseArea()
		DbSelectArea("SB2")

		oListBox:Refresh()

	End

	if !_lSim
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Carregando browse de Produtos Similares                                 ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		MontaSim(cProduto)
	End

Return _cProdSel

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±Í»±±±±±±
±±±±±±±±±Programa  ±±±MontaSim  ±±±Autor  ±±±Microsiga           ±±± Data ±±±  12/06/04   ±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±Í¹±±±±±±
±±±±±±±±±Desc.     ±±±                                                            ±±±±±±±±±
±±±±±±±±±          ±±±                                                            ±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±Í¹±±±±±±
±±±±±±±±±Uso       ±±± AP                                                         ±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±Í¼±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MontaSim(_cProduto)

	ASIZE(_aProdSim,0)
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Inicia montagem da Matriz com Dados de Produtos Similares               ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	DbSelectArea("SZ3")
	DbSetOrder(2) // Filial + Produto

	If DbSeek(xFilial("SZ3")+_cProduto,.f.)
		cFamilia := SZ3->Z3_FAMILIA
		cItem    := "0000"

		DbSetOrder(1) // Filial + Familia
		DbSeek(xFilial("SZ3")+cFamilia,.f.)

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Adiciona todos os produtos no array, relacionados a familia ...        ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		While !Eof() .and. SZ3->Z3_FAMILIA == cFamilia

			If SZ3->Z3_PRODUTO == _cProduto
				DbSelectArea("SZ3")
				SZ3->(DbSkip())
				Loop
			EndIf

			cItem := Soma1(cItem)
			Aadd(_aProdSim,{SZ3->Z3_PRODUTO,Posicione("SB1",1,xFilial("SB1")+SZ3->Z3_PRODUTO,"B1_DESC"),SB1->B1_UM,SB1->B1_PRV1})
			DbSelectArea("SZ3")
			SZ3->(DbSkip())
		End

	EndIf

	//NT BORRADO POR WARNING oListSim:Refresh()

Return

Static Function ConsProd(_cProduto)
	Local _cArea:=GetArea()
	//alert(_cProduto)
	If !Empty(_cProduto)
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+_cProduto))
			if pergunte("MTC050",.T.)
				MC050Con()
			end
		End
	End
	RestArea( _cArea)
Return

Static Function ConsKard(_cProduto,_cAlm)
	Local _cArea:=GetArea()

	If !Empty(_cProduto)
		_cAlm:=aViewB2[oListBox:nAT,2]
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+_cProduto))

			If SX1->(DbSeek("MTR911"+Space(4)+"01"))
				Reclock("SX1",.F.)
				SX1->X1_CNT01:=_cProduto
				SX1->(MSUNLOCK())
			End

			If SX1->(DbSeek("MTR911"+Space(4)+"02"))
				Reclock("SX1",.F.)
				SX1->X1_CNT01:=_cProduto
				SX1->(MSUNLOCK())
			End

			If SX1->(DbSeek("MTR911"+Space(4)+"08"))
				Reclock("SX1",.F.)
				SX1->X1_CNT01:=_cAlm
				SX1->(MSUNLOCK())
			End
			U_Matr911K()
		End
	End
	RestArea( _cArea)
Return

Static Function MostraFoto(_cProduto)
	Local _cArea:=GetArea()

	//FSigamat()
	//Return

	If !Empty(_cProduto)
		//_cAlm:=aViewB2[oListBox:nAT,2]
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+_cProduto))

			@ 000,000 To 405,400 DIALOG oDlgT TITLE "Foto del Producto"

			@05,05 TO 200,200 LABEL ("Foto") OF oDlgT PIXEL  //"Foto" 193/105
			If Empty(SB1->B1_BITMAP)
				@ 80,30 SAY ("Foto No Disponible") SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlgT //"Foto n?o disponivel"
			Else
				//@ 10,10 REPOSITORY oBitPro OF oDlgT NOBORDER SIZE 350,350 PIXEL
				@ 05,05 REPOSITORY oBitPro OF oDlgT NOBORDER SIZE 200,200 PIXEL
				Showbitmap(oBitPro,SB1->B1_BITMAP,"")
				oBitPro:lStretch:=.T. //Ajustar al tama±±±o del Dialog
				oBitPro:Refresh()
			Endif
			ACTIVATE DIALOG ODLGT CENTERED
		End
	End
Return

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±± Funci±±±n que muestra los datos del Sigamat - Tabla SM0                   ±±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Static Function FSigamat
	Local _aQuery 	:=	{}
	Local cSM0		:= 	""

	DbSelectArea("SM0")
	DbSetOrder(1)
	DbGoTop()

	While !Eof()
		_cNomeEmp := Alltrim(SM0->M0_FILIAL)+" / "+Alltrim(SM0->M0_NOME)
		_cCodEmp  := SM0->M0_CODIGO+" / "+SM0->M0_CODFIL
		cSM0 += _cCodEmp + "-----"+_cNomeEmp+Chr(13)+Chr(10)
		DbSkip()
	EndDo
	Aviso("SM0",cSM0,{"OK"})
Return

//AAR*************************************************************************

Static Function MostraLista(cProduto,_lSim,cArmazem,lBrowse,aArmazem)
	Local aStruDA1  := {}
	Local oCursor	:= LoadBitMap(GetResources(),"LBNO")
	Local nTotDisp	:= 0
	Local nSaldo	:= 0
	Local nQtPV		:= 0
	Local nQemp		:= 0
	Local nSalpedi	:= 0
	Local nReserva	:= 0
	Local nQempSA	:= 0
	Local nX        := 0
	Local cQuery    := ""
	Local _cNomeEmp := ""
	Local _cCodEmp  := ""
	Local nC		:= 0

	_cProdSel:= cProduto
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Trata parametro de pesquisa por Armazem. Caso o parametro nao seja     ±±±
	//±±± passado, listara todos os armazens encontrados.                        ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	If ValType(cArmazem) == 'U'
		cArmazem := "I"
	EndIf

	If ValType(aArmazem) == 'U'
		aArmazem := {}
	EndIf

	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Trata parametro de visualizacao do Browse. Caso o parametro nao seja   ±±±
	//±±± passado, apresenta o Browse de consulta.                               ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	If ValType(lBrowse) == 'U'
		lBrowse := .t.
	EndIf
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//±±± Posiciona o cadastro de produtos                                       ±±±
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	DbSelectArea('SB1')
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto,.f.)
		cCursor   := "MAVIEWDA1"
		lQuery    := .T.
		aStruDA1  := DA1->(dbStruct())

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Abre arquivo de empresas para obter empresas para consulta do estoque  ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		DbSelectArea("SM0")
		DbSetOrder(1)
		DbGoTop()

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Monta cQuery para realizar select no SB2 de todas as Empresas e Filiais ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		_cOrdQuery:=1
		_cOrdQueryAux:=50
		_cOrdQueryAct:=0
		_aQuery:={}

		While !Eof()
			_cNomeEmp := Alltrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL)
			_cCodEmp  := SM0->(M0_CODIGO+M0_CODFIL)

			If 	TCCANOPEN("DA1"+SM0->M0_CODIGO+"0")
				If SM0->M0_CODIGO == CEMPANT .AND.SM0->M0_CODFIL == CFILANT
					_cOrdQuery:= 1
				Else
					If (SM0->M0_CODIGO == CEMPANT)
						_cOrdQuery++
					Else
						_cOrdQueryAct:=	_cOrdQuery
						_cOrdQuery+=_cOrdQueryAux
					Endif
				Endif

				/*			cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
				cQuery += "DA1_CODPRO,DA1_CODTAB,DA1_MOEDA,DA1_PRCVEN,DA1_UDSC00,DA1_UDSC05,DA1_UDSC10,DA1_UDSC12,DA1_UDSC15,DA1_UDSC17,DA1_UDSC20,DA1_UDSC23,DA1_UDSC28, "
				cQuery += "DA1_UDSC32 "
				cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
				cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
				cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
				cQuery += "      DA1.D_E_L_E_T_ = '' "
				cQuery += "ORDER BY DA1_CODPRO, DA1_CODTAB" */
				nTC = POSICIONE("SM2",1,DATE(),"M2_MOEDA2")
				If nTC > 0
					cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
					cQuery += "DA1_CODPRO,DA1_CODTAB,1 DA1_MOEDA, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN*"+ cValToChar(nTC) +",5) END DA1_PRCVEN, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC00 ELSE ROUND(DA1_UDSC00*"+ cValToChar(nTC) +",5) END DA1_UDSC00, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC05 ELSE ROUND(DA1_UDSC05*"+ cValToChar(nTC) +",5) END DA1_UDSC05, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC10 ELSE ROUND(DA1_UDSC10*"+ cValToChar(nTC) +",5) END DA1_UDSC10, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC12 ELSE ROUND(DA1_UDSC12*"+ cValToChar(nTC) +",5) END DA1_UDSC12, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC15 ELSE ROUND(DA1_UDSC15*"+ cValToChar(nTC) +",5) END DA1_UDSC15, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC17 ELSE ROUND(DA1_UDSC17*"+ cValToChar(nTC) +",5) END DA1_UDSC17, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC20 ELSE ROUND(DA1_UDSC20*"+ cValToChar(nTC) +",5) END DA1_UDSC20, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC23 ELSE ROUND(DA1_UDSC23*"+ cValToChar(nTC) +",5) END DA1_UDSC23, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC28 ELSE ROUND(DA1_UDSC28*"+ cValToChar(nTC) +",5) END DA1_UDSC28, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC32 ELSE ROUND(DA1_UDSC32*"+ cValToChar(nTC) +",5) END DA1_UDSC32 "
					cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
					cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
					cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
					cQuery += "      DA1.D_E_L_E_T_ = '' "
					cQuery += "UNION "
					cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
					cQuery += "DA1_CODPRO,DA1_CODTAB,2 DA1_MOEDA, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN/"+ cValToChar(nTC) +",5) END DA1_PRCVEN, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC00 ELSE ROUND(DA1_UDSC00/"+ cValToChar(nTC) +",5) END DA1_UDSC00, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC05 ELSE ROUND(DA1_UDSC05/"+ cValToChar(nTC) +",5) END DA1_UDSC05, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC10 ELSE ROUND(DA1_UDSC10/"+ cValToChar(nTC) +",5) END DA1_UDSC10, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC12 ELSE ROUND(DA1_UDSC12/"+ cValToChar(nTC) +",5) END DA1_UDSC12, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC15 ELSE ROUND(DA1_UDSC15/"+ cValToChar(nTC) +",5) END DA1_UDSC15, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC17 ELSE ROUND(DA1_UDSC17/"+ cValToChar(nTC) +",5) END DA1_UDSC17, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC20 ELSE ROUND(DA1_UDSC20/"+ cValToChar(nTC) +",5) END DA1_UDSC20, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC23 ELSE ROUND(DA1_UDSC23/"+ cValToChar(nTC) +",5) END DA1_UDSC23, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC28 ELSE ROUND(DA1_UDSC28/"+ cValToChar(nTC) +",5) END DA1_UDSC28, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC32 ELSE ROUND(DA1_UDSC32/"+ cValToChar(nTC) +",5) END DA1_UDSC32 "
					cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
					cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
					cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
					cQuery += "      DA1.D_E_L_E_T_ = '' "
					cQuery += "ORDER BY DA1_CODTAB,DA1_CODPRO "
				Else
					//Alert("No existe Tipo de Cambio para esta Fecha. Por favor ingrese el Tipo de Cambio para la fecha "+ DTOC(DATE()) +".!!!!")
					cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
					cQuery += "DA1_CODPRO,DA1_CODTAB,DA1_MOEDA,DA1_PRCVEN,DA1_UDSC00,DA1_UDSC05,DA1_UDSC10,DA1_UDSC12,DA1_UDSC15,DA1_UDSC17,DA1_UDSC20,DA1_UDSC23,DA1_UDSC28,DA1_UDSC32 "
					cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
					cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
					cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
					cQuery += "      DA1.D_E_L_E_T_ = '' "
					cQuery += "ORDER BY DA1_CODTAB,DA1_CODPRO "
				EndIf

				_cOrdQuery:=	_cOrdQueryAct

			Endif
			DbSkip()

			//		Aadd(_aQuery,cQuery)
			//		cQuery:=""

		EndDo

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Valida Query a ser executada.                                           ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		cQuery := ChangeQuery(If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + If(LEN(_aQuery)>=12,_aQuery[12],'') + ' ' + If(LEN(_aQuery)>=13,_aQuery[13],'') + ' ' + If(LEN(_aQuery)>=14,_aQuery[14],'') + ' ' + If(LEN(_aQuery)>=15,_aQuery[15],'') + ' ' + cQuery)
		DA1->(dbCommit())

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Cria Alias temporario com o resultado da Query.                         ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Ajusta os campos que nao sao Caracter de acordo com a estrutura do SB2  ±±±
		//±±± uma vez que a TcGenQuery retorna todos os campos como Caracter.         ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		For nX := 1 To Len(aStruDA1)
			If aStruDA1[nX][2]<>"C"
				TcSetField(cCursor,aStruDA1[nX][1],aStruDA1[nX][2],aStruDA1[nX][3],aStruDA1[nX][4])
			EndIf
		Next nX

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Inicia montagem do array (aViewDA1) para visualizacao no Browse e        ±±±
		//±±± posterior retorno da funcao.                                            ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		_cNomeEmp  := ""
		_cNomeEmpA := ""

		_cCodEmp   := ""
		_cCodEmpA  := ""

		_cCodPro   := ""
		_cCodProA  := ""

		DbSelectArea(cCursor)

		ASIZE(aViewDA1,(cCursor)->(RecCount()))

		DbSelectArea(cCursor)
		DbGoTop()
		While ( !Eof() )

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Trata variaveis a serem passadas para o Array para nao poluir o Browse. ±±±
			//±±± Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			If _cCodEmpA == Alltrim((cCursor)->CODFIL) .and. lBrowse
				_cNomeEmp := ""
				_cCodEmp  := ""
			Else
				_cNomeEmp := Alltrim((cCursor)->NOMEFIL)
				_cCodEmp  := Alltrim((cCursor)->CODFIL)
			EndIf

			_cNomeEmpA := Alltrim((cCursor)->NOMEFIL)
			_cCodEmpA  := Alltrim((cCursor)->CODFIL)

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Trata variaveis a serem passadas para o Array para nao poluir o Browse. ±±±
			//±±± Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			If _cCodProA == Alltrim((cCursor)->DA1_CODPRO) .and. lBrowse
				_cCodPro := ""
			Else
				_cCodPro := Alltrim((cCursor)->DA1_CODPRO)
			EndIf

			_cCodProA    := Alltrim((cCursor)->DA1_CODPRO)

			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			//±±± Inicia montagem do Array.                                               ±±±
			//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

			If lBrowse
				aAdd(aViewDA1,{_cNomeEmp,;
				TransForm((cCursor)->DA1_CODTAB,PesqPict("DA1","DA1_CODTAB")),;
				TransForm((cCursor)->DA1_MOEDA,PesqPict("DA1","DA1_MOEDA")),;
				TransForm((cCursor)->DA1_PRCVEN,PesqPict("DA1","DA1_PRCVEN")),;
				TransForm((cCursor)->DA1_UDSC00,PesqPict("DA1","DA1_UDSC00")),;
				TransForm((cCursor)->DA1_UDSC05,PesqPict("DA1","DA1_UDSC05")),;
				TransForm((cCursor)->DA1_UDSC10,PesqPict("DA1","DA1_UDSC10")),;
				TransForm((cCursor)->DA1_UDSC12,PesqPict("DA1","DA1_UDSC12")),;
				TransForm((cCursor)->DA1_UDSC15,PesqPict("DA1","DA1_UDSC15")),;
				TransForm((cCursor)->DA1_UDSC17,PesqPict("DA1","DA1_UDSC17")),;
				TransForm((cCursor)->DA1_UDSC20,PesqPict("DA1","DA1_UDSC20")),;
				TransForm((cCursor)->DA1_UDSC23,PesqPict("DA1","DA1_UDSC23")),;
				TransForm((cCursor)->DA1_UDSC28,PesqPict("DA1","DA1_UDSC28")),;
				TransForm((cCursor)->DA1_UDSC32,PesqPict("DA1","DA1_UDSC32"))})
			Else
				aAdd(aViewDA1,{_cNomeEmp,;
				(cCursor)->DA1_CODTAB,;
				(cCursor)->DA1_MOEDA,;
				(cCursor)->DA1_PRCVEN,;
				(cCursor)->DA1_UDSC00,;
				(cCursor)->DA1_UDSC05,;
				(cCursor)->DA1_UDSC10,;
				(cCursor)->DA1_UDSC12,;
				(cCursor)->DA1_UDSC15,;
				(cCursor)->DA1_UDSC17,;
				(cCursor)->DA1_UDSC20,;
				(cCursor)->DA1_UDSC23,;
				(cCursor)->DA1_UDSC28,;
				(cCursor)->DA1_UDSC32})
			EndIf
			nC += 1
			//Alert("NomEmp: "+aViewDA1[nC][1]+" Tabla: "+aViewDA1[nC][2]+" PrecVen: "+CValToChar(aViewDA1[nC][3]))
			DbSelectArea(cCursor)
			DbSkip()
		EndDo

		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Fecha arquivo temporario da TcGenQuery                                  ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		DbSelectArea(cCursor)
		DbCloseArea()
		DbSelectArea("DA1")

		oListBox1:Refresh()
		//oMainWnd:Refresh()
	End

	if !_lSim
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		//±±± Carregando browse de Produtos Similares                                 ±±±
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		MontaSim(cProduto)
	End

Return _cProdSel