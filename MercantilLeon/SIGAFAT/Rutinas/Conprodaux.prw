#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/**
*
* @author: Denar Terrazas Parada
* @since: 02/12/2020
* @description: Consulta estándar de Productos
*
*/
User Function Conprodaux(_lSXB)

	Local nW
	Local _nCont
	Local _aArea    := GetArea()
	Local aTamVen	:= {}//Tamaño de la ventana

	Private _aBuscaProd	:= {{"","","","","","",""}}
	Private aViewB2		:= {{"","","","","","","","","",""}}
	Private aViewDA1	:= {{"","","","","","","","","","",""}}
	Private _aProdSim	:= {{"","","",""}}
	Private _cProdSel	:= ""
	Private lBrowse 	:= .t.
	//PRIVATE INCLUI  	:= .F.
	PRIVATE cCadastro	:= "Consulta General del Producto"
	Private oDlg
	private oSayProd
	private oSayRazon
	private oMsGetRazon
	Private L110AUTO:=.F.

	Private _lNovaLinha:=.t.
	Private nPosCod		:= 0
	Private nPQtdVen	:= 0
	Private nPrcDesc	:= 0
	Private nValDesc	:= 0
	Private nposDep		:= 0
	Private nPPrcVen	:= 0
	Private nPValor		:= 0
	Private nPItem		:= 0
	Private nPosTes		:= 0
	Private nPosPru     := 0
	Private _aColsCop	:={}
	

	Private intCant
	Private oBitPro
	Private cNombImg	:= ""
	Private lBorrarImg	:= .F.
	Private lMoeda := .t.   ///informaron moneda del dia???   

	Private cRazon		:= ""

	Public lVal:= .F.

	DEFAULT _lSXB	:= .T.

	If FunName() == 'MATA410'//Pedido de Venta
		//Validación para sólo permitir abrir la consulta cuando es una nueva linea en el detalle del pedido
		If(!Empty(aCols[n,GdFieldPos("C6_PRODUTO")]))
			Return .F.
		EndIf
	EndIf
	aTamVen := MsAdvSize(.F.)
	/*
	MsAdvSize (http://tdn.totvs.com/display/public/mp/MsAdvSize+-+Dimensionamento+de+Janelas)
	aTamVen[1] = 1 -> Linha inicial área trabalho.
	aTamVen[2] = 2 -> Coluna inicial área trabalho.
	aTamVen[3] = 3 -> Linha final área trabalho.
	aTamVen[4] = 4 -> Coluna final área trabalho.
	aTamVen[5] = 5 -> Coluna final dialog (janela).
	aTamVen[6] = 6 -> Linha final dialog (janela).
	aTamVen[7] = 7 -> Linha inicial dialog (janela).
	*/

	/*alert("aTamVen[3]: " + cValToChar(aTamVen[3]) + CRLF +;
	"aTamVen[4]: " + cValToChar(aTamVen[4]) + CRLF +;
	"aTamVen[5]: " + cValToChar(aTamVen[5]) + CRLF +;
	"aTamVen[6]: " + cValToChar(aTamVen[6]) + CRLF)*/

	//Alert("Caso esta rotina seja utiliza, avise-nos pois dentro de dias a mesma sera removida !!! ")

	_aGets := {}
	AADD(_aGets,{"B1_COD",Space(20)})
	AADD(_aGets,{"B1_ESPECIF",Space(80)})
	AADD(_aGets,{"B1_UESPEC2",Space(80)})
	AADD(_aGets,{"B1_UCODFAB",Space(15)})
	AADD(_aGets,{"B1_GRUPO",Space(4)})
	AADD(_aGets,{"B1_UDESCMA",Space(30)})

	_aOrdem  := {"Ascendente","Descendente"}
	_cOrdem  :=_aOrdem[1]

	If lBrowse

		/*DEFINE MSDIALOG oDlg TITLE "Consulta de Productos"
		oDlg:lMaximized := .T.*/
		Define MsDialog oDlg TITLE "Consulta de Productos" From aTamVen[7],0 To aTamVen[6],aTamVen[5] OF oMainWnd PIXEL

		@ 010,005 SAY "CODIGO" Object oSayProd
		@ 010,050 MSGET _aGets[1,2] SIZE 060,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_COD")

		@ 025,005 SAY "DESC.ESPECIF" Object oSayDesc
		@ 025,050 MSGET _aGets[2,2] SIZE 300,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_ESPECIF")

		@ 040,005 SAY "DESC.ESPECIF 2" Object oSayDesc
		@ 040,050 MSGET _aGets[3,2] SIZE 300,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_UESPEC2")

		@ 055,005 SAY "COD.FABRICA" Object oSayDescEsp
		@ 055,050 MSGET _aGets[4,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_UCODFAB")
		@ 055,180 SAY "GRUPO" Object oSayProd
		@ 055,200 MSGET _aGets[5,2] SIZE 020,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_GRUPO") F3 "SBM
		@ 055,280 SAY "MONEDA 01=Bs. 02=$us 05=Aux" Object oSayProd
		//@ 055,320 MSGET _aGets[6,2] SIZE 020,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_MOEDA")

		@ 010,370 BUTTON "&Buscar" SIZE 040,010 ACTION BuscaProd17() Object oBnt

		@ 025,370 BUTTON "Imagen" SIZE 040,010 ACTION MostFoto17(_cProdSel) Object oBnt
		//	@ 025,170 BUTTON "&Incluir" SIZE 040,010 ACTION  AxInclui('SB1',,3,,,,,,,,,,,.T.) Object oBnt

		@ 040,370 BUTTON "&Conocimiento" SIZE 040,010 ACTION MSdoc(_cProdSel) Object oBnt

		@ 010,420 BUTTON "&Cancelar" SIZE 040,010 ACTION Close(oDlg) Object oBnt

		@ 025,420 BUTTON "&Aceptar" SIZE 040,010 ACTION aceptar() Object oBnt

		//Para la imagen del browser
		@ 010,500 TO 142,622 LABEL ("Imagen") OF oDlg PIXEL  //"Foto" 193/105

		//Muestra el número de la Razón
		@ 010,(aTamVen[3] - 30) SAY "R = " Object oSayRazon
		@ 010,(aTamVen[3] - 20) MSGET oMsGetRazon VAR cRazon SIZE 015,008 OF oDlg PIXEL  WHEN .F.

		//@ 112,005 BUTTON "Cons Producto" SIZE 040,008 ACTION ConsProd17(_cProdSel) Object oBnt
		//	@ 112,060 BUTTON "Kardex por Dia" SIZE 040,008 ACTION ConsKard17(_cProdSel) Object oBnt

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia montagem do browse (Busca Produtos).                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//Cuadro Productos
		@ 150,02 TO 262, ((aTamVen[3] / 2) + 7) LABEL ("P R O D U C T O S") OF oDlg PIXEL

		//oListProd := TWBrowse():New(  070,05,545,065,,{"Código","UM","Descr. Específica","Descr. Específica 2","Cod.Fábrica","Grupo","Marca"},{40,10,300,300,50,20,80},oDlg,,,,,{||IF(LEN(_aBuscaProd)>0,MostDat17(_aBuscaProd[oListProd:nAT,1],.T.),.t.)},,,,,,,.F.,,.T.,,.F.,,,)
		oListProd := TWBrowse():New(  160, 05, (aTamVen[3] / 2), 100,,{"Código","UM","Descr. Específica","Descr. Específica 2","Cod.Fábrica","Grupo","Marca"},{40,10,150,150,50,20,80},oDlg,,,,,{||IF(LEN(_aBuscaProd)>0,MostDat17(_aBuscaProd[oListProd:nAT,1],.T.),.t.)},,,,,,,.F.,,.T.,,.F.,,,)
		oListProd:SetArray(_aBuscaProd)
		oListProd:bLine       := { || if(Len(_aBuscaProd)>0,_aBuscaProd[oListProd:nAT],.t.)}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia montagem do browse (Produtos Similares).                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//	oListSim := TWBrowse():New( 072,105,280,060,,{"Codigo","Descripcion","Unid","Precio Venta"},{50,165,15,40},oDlg,,,,,{||If(Len(_aProdSim)>0,MostEst17(_aProdSim[oListSim:nAT,1],.T.),.T.)},,,,,,,.F.,,.T.,,.F.,,,)
		//	oListSim :SetArray(_aProdSim)
		//	oListSim :bLine := { || If(Len(_aProdSim)>0,_aProdSim[oListSim:nAT],.t.)}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia montagem do browse (Saldos em Estoque).                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oListBox := TWBrowse():New( 140,05,545,060,,{"Cod.Alm.","Almacén","Disponible","Cant Venta","Saldo Actual","Pedido Ventas","Reservada","Prevista Entrada","Reservada S.A.","Reservada"},{25,65,42,42,42,42,42,42,42,42,42},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

		//Cuadro Stock
		@ 150, ((aTamVen[3] / 2) + 7) TO 262, (aTamVen[3] + 2) LABEL ("S T O C K") OF oDlg PIXEL

		oListBox := TWBrowse():New( 160,(aTamVen[3] / 2) + 10,((aTamVen[3] / 2) - 10),100,,{"Cod.Alm.","Almacén","Disponible","Cant Venta","Saldo Actual","Pedido Ventas","Reservado","Ctd. Reserva", "Prevista Entrada", "Fecha"},{25,65,42,42,42,42,42,42,42,42},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || If(Len(aViewB2)>0,aViewB2[oListBox:nAT],.t.)}
		If FunName() == 'MATA410'//Pedido de Venta
			nPosCod	:= Ascan(aHeader,{ |x| Upper (Alltrim (x[2])) == "C6_PRODUTO"})
			nPQtdVen:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN"})
			nPrcDesc:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_DESCONT"})
			nValDesc:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_VALDESC"})
			nposDep	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_LOCAL"})
			nPPrcVen:= aScan(aHeader,{ |x| AllTrim(x[2]) == "C6_PRCVEN" })
			nPValor	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "C6_VALOR" })
			nPItem	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "C6_ITEM" })
			nPosTes	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "C6_TES"})
			nPosPru	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "C6_PRUNIT"})

			nUsado	:= Len(aHeader)
			oListBox:bLDblClick := {|| DobleClick(@aViewB2,@oListBox)}
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia montagem do browse (Lista do Preco).                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oListBox1 := TWBrowse():New( 205,05,545,060,,{"Empresa/Sucursal","Lista","Mon","Precio Venta","Desc 00%","Desc 05%","Desc 10%","Desc 12%","Desc 15%","Desc 17%"},{65,25,15,50,50,50,50,50,50,50},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

		//Cuadro Precios
		@ 070,02 TO 142, ((aTamVen[3] / 2) + 7) LABEL ("P R E C I O S") OF oDlg PIXEL

		oListBox1 := TWBrowse():New( 80,05,(aTamVen[3] / 2),060,,{"Empresa/Sucursal","Lista","Mon","Precio Venta","Desc 00%","Desc 05%","Desc 10%","Desc 12%","Desc 15%","Desc 17%"},{65,25,15,50,50,50,50,50,50,50},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox1:SetArray(aViewDA1)
		oListBox1:bLine := { || If(Len(aViewDA1)>0,aViewDA1[oListBox1:nAT],.t.)}
		oListBox1:bLDblClick := {|| actualizarRazon(aViewDA1[oListBox1:nAT])}
		ACTIVATE DIALOG oDlg CENTERED

		If FunName() == 'MATA410'//Pedido de Venta

			if(Len(_aColsCop)==0) // nahim
				return(.F.)
			endif

			If !Empty(_cProdSel) .and. lVal

				//alert(_cProdSel)

				For _nCont:=1 to Len(_aColsCop)

					IF _lnovalinha
						If(aCols[Len(aCols),nPQtdVen] > 0.00)
							N:= Val(aCols[Len(aCols),nPItem]) + 1//Nuevo Item
						Else
							N:= Val(aCols[Len(aCols),nPItem])//Nuevo Item
						EndIf
						aadd(aCols,Array(nUsado+1))
						//N := Len(acols)+1
					ELSE
						_lnovalinha:=.T.
					ENDIF

					For nW := 1 To nUsado
						If (aHeader[nW,2] <> "C6_REC_WT") .And. (aHeader[nW,2] <> "C6_ALI_WT")
							aCols[LEN(aCols),nW] := CriaVar(aHeader[nW,2],.T.)
						EndIf
					Next nW

					aCols[LEN(aCols),nUsado+1] := .F.
					aCols[LEN(aCols),nPItem]  :=  StrZero(N,Len(SC6->C6_ITEM))
					aCols[LEN(aCols),nPoscod]  := _aColsCop[_nCont,nPoscod]		//Cod. Producto
					aCols[LEN(aCols),nPQtdVen] := _aColsCop[_nCont,nPQtdVen]	//Cantidad
					aCols[LEN(aCols),nPosDep]  := _aColsCop[_nCont,nPosDep]		//Deposito

					if funname() $ "MATA410"
						if M->C5_MOEDA == 1 .and. lMoeda .AND. (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT))
							aCols[LEN(aCols),nPPrcVen]  := _aColsCop[_nCont,nPPrcVen]		//precio
							aCols[LEN(aCols),nPValor]  := _aColsCop[_nCont,nPValor]		//valor tot linea
							aCols[LEN(aCols),nPosPru]  := _aColsCop[_nCont,nPosPru]	
						endif
					endif

				Next _nCont
				//            Aviso("query",U_zArrToTxt(aCols,,),{"si"})

				//Eliminando itens com quantidade zerada
				_aColsCop:=aCols
				aCols:={}

				_nItem:=0
				N:=0

				For _nCont := 1 to  Len(_aColsCop)
					If _aColsCop[_nCont,nPQtdVen] > 0.00
						N++
						AADD(aCols,_aColsCop[_nCont])
						aCols[LEN(aCols),nPItem]  :=  _aColsCop[_nCont,nPItem]//StrZero(N,Len(SC6->C6_ITEM))	//Nro Item
						aCols[LEN(aCols),nPQtdVen] := _aColsCop[_nCont,nPQtdVen]	//Cantidad
						nXQuant		:= _aColsCop[_nCont,nPQtdVen]	//Cantidad
						nXPrcDesc	:= _aColsCop[_nCont,nPrcDesc]	//Porcentaje de descuento
						nXValDesc	:= _aColsCop[_nCont,nValDesc]	//Valor de descuento
						nPreco := _aColsCop[_nCont,nPPrcVen]
						nxValTot := _aColsCop[_nCont,nPValor]

						//				alert("Item: " + cvaltochar(StrZero(N,Len(SC6->C6_ITEM))))
						//				alert("Cantidad: " + cvaltochar(_aColsCop[_nCont,nPQtdVen]))

						A093Prod(.f.)
						A410Produto(_cProdSel,.t.)
						A410MultT()

						If ExistTrigger("C6_PRODUTO")
							RunTrigger(2,Len(aCols),,,"C6_PRODUTO")
						Endif

						If ExistTrigger("C6_TES")
							RunTrigger(2,Len(aCols))
						Endif

						aCols[LEN(aCols),nPQtdVen]	:= nXQuant//_aColsCop[_nCont,nPQtdVen]
						aCols[LEN(aCols),nPPrcVen]	:= round(aCols[LEN(aCols),nPPrcVen], 2)
						aCols[LEN(aCols),nPValor]	:= round(nXQuant * aCols[LEN(aCols),nPPrcVen],2)
						aCols[LEN(aCols),nPrcDesc]	:= nXPrcDesc
						aCols[LEN(aCols),nValDesc]	:= nXValDesc

						if funname() $ "MATA410"
							if M->C5_MOEDA == 1 .and. lMoeda .AND. (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT))
								aCols[LEN(aCols),nPPrcVen]	:= round(nPreco, 2) //precio venta
								aCols[LEN(aCols),nPValor]	:= round(nxValTot,2) //valor total
								aCols[LEN(aCols),nPosPru]	:= round(nPreco,2) //valor total
							endif
						endif

						//GDFieldPut("C6_XCONSUL",_cProdSel)

					End

				Next _nCont

				//            Aviso("query",U_zArrToTxt(aCols,,),{"si"})

				//            oGetDad:Refresh()
				//A410LinOk(oGetDad)
				//            Aviso("query",U_zArrToTxt(aCols,,),{"si"})

				MA410RODAP(oGetDad)

				//           GETDREFRESH()
				//		     SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
				//		     oGetDad:Refresh()
				//		     A410LinOk(oGetDad)

				//aCols[nPQtdVen-1,nPQtdVen] := intCant

			Endif

		EndIf
	EndIf
	//alert(_cProdSel)

	RestArea(_aArea)

	If _lSXB
		&(READVAR()) := _cProdSel
	End

Return(.T.)

Static Function BuscaProd17()
	Local _cQueryProd,_nCont,_nContCpo:=0
	limpiarImg()
	limpiarRazon()

	_nContPre:=0   //Conta campos preenchidos
	For _nCont:=1 to Len(_aGets)
		If !Empty(_aGets[_nCont,2])
			_nContPre++
		Endif
	Next _nCont

	If _nContPre == 0
		Aviso("Importante","Necesario llenar uno de los campos para la búsqueda",{"OK"})
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
					//NT Adicionado para buscar en Nombre y Descripción
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

	_cQueryProd+=" AND SB1.B1_MSBLQL <> '1'"//Productos NO bloqueados
	_cQueryProd+=" AND SB1.D_E_L_E_T_ <> '*'"
	_cQueryProd+=" ORDER BY B1_COD "
	If(Left(_cOrdem,1))=='D'
		_cQueryProd+=" DESC"
	End
	TCQUERY _cQueryProd NEW ALIAS "BUSCAPROD"

	IF BUSCAPROD->(!EOF()) .AND. BUSCAPROD->(!BOF())
		BUSCAPROD->(DbGoTop())

		ASIZE(_aBuscaProd,BUSCAPROD->(RecCount()))
		ASIZE(aViewB2,0)
		ASIZE(aViewDA1,0)
		_nCont:=0

		WHILE BUSCAPROD->(!EOF())
			if _nCont==1
				_aBuscaProd[1,1]:= BUSCAPROD->B1_COD
				_aBuscaProd[1,2]:= alltrim(BUSCAPROD->B1_UM)
				_aBuscaProd[1,3]:= alltrim(BUSCAPROD->B1_ESPECIF)
				_aBuscaProd[1,4]:= alltrim(BUSCAPROD->B1_UESPEC2)
				_aBuscaProd[1,5]:= alltrim(BUSCAPROD->B1_UCODFAB)
				_aBuscaProd[1,6]:= alltrim(BUSCAPROD->B1_GRUPO)
				If(!Empty(BUSCAPROD->B1_UDESCMA))
					_aBuscaProd[1,7]:= alltrim(BUSCAPROD->B1_UDESCMA)
				EndIf
				_nCont++
			Else
				//AADD(_aBuscaProd,{BUSCAPROD->B1_COD,BUSCAPROD->B1_DESC,alltrim(BUSCAPROD->B1_ESPECIF),IIf(!Empty(_aGets[4,2]),BUSCAPROD->ZNO_DESC,BUSCAPROD->B1_UNORMA)})
				If(!Empty(BUSCAPROD->B1_UDESCMA))
					AADD(_aBuscaProd,{BUSCAPROD->B1_COD,BUSCAPROD->B1_UM,alltrim(BUSCAPROD->B1_ESPECIF),alltrim(BUSCAPROD->B1_UESPEC2),alltrim(BUSCAPROD->B1_UCODFAB),alltrim(BUSCAPROD->B1_GRUPO),alltrim(BUSCAPROD->B1_UDESCMA)})
				Else
					AADD(_aBuscaProd,{BUSCAPROD->B1_COD,BUSCAPROD->B1_UM,alltrim(BUSCAPROD->B1_ESPECIF),alltrim(BUSCAPROD->B1_UESPEC2),alltrim(BUSCAPROD->B1_UCODFAB),alltrim(BUSCAPROD->B1_GRUPO),""})
				EndIf
				//,alltrim(BUSCAPROD->B1_UDESCMA)})
			End
			BUSCAPROD->(DbSkip())
		END
	End

	oListProd:Refresh()
	oListBox1:Refresh()
Return

Static Function MostDat17(cProduto,_lSim,cArmazem,lBrowse,aArmazem)

	GrabaBusq(cProduto)//Graba búsqueda

	limpiarImg()
	limpiarRazon()
	fotoBrowser(cProduto)

	MostEst17(_aBuscaProd[oListProd:nAT,1],.T.)
	MostList17(_aBuscaProd[oListProd:nAT,1],.T.)
Return _cProdSel

Static Function MostProd17(cProduto,_lSim,_lSXB)
	_cProdSel:= cProduto

	If _lSXB
		oDlg:End()
	End
Return cProduto

Static Function MostEst17(cProduto,_lSim,cArmazem,lBrowse,aArmazem)
	Local aStruSB2  := {}
	Local nX        := 0
	Local cQuery    := ""
	Local _cNomeEmp := ""
	Local _cCodEmp  := ""
	Local cDescAlm	:= "" //Descripción del almacén
	Local y

	_cProdSel:= cProduto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trata parametro de pesquisa por Armazem. Caso o parametro nao seja     ³
	//³ passado, listara todos os armazens encontrados.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(cArmazem) == 'U'
		cArmazem := "I"
	EndIf

	If ValType(aArmazem) == 'U'
		aArmazem := {}
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trata parametro de visualizacao do Browse. Caso o parametro nao seja   ³
	//³ passado, apresenta o Browse de consulta.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(lBrowse) == 'U'
		lBrowse := .t.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o cadastro de produtos                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SB1')
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto,.f.)
		cCursor   := "MAVIEWSB2"
		lQuery    := .T.
		aStruSB2  := SB2->(dbStruct())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre arquivo de empresas para obter empresas para consulta do estoque  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SM0")
		DbSetOrder(1)
		DbGoTop()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta cQuery para realizar select no SB2 de todas as Empresas e Filiais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cOrdQuery:=1
		_cOrdQueryAux:=50
		_cOrdQueryAct:=0
		_aQuery:={}

		While !Eof()
			//Condição adicionada enquando se configura os arquivos da filial 02
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
		cQuery += "B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_QPEDVEN,B2_QEMP,B2_SALPEDI,B2_QEMPSA,B2_RESERVA,B2_QEMPPRJ,B2_QACLASS,B2_STATUS "
		cQuery += "FROM SB2"+SM0->M0_CODIGO+"0 WHERE "
		cQuery += "B2_FILIAL = '"+SM0->M0_CODFIL+"' AND "

		_cOrdQuery:=	_cOrdQueryAct
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz tratamento para pesquisa dos Armazens.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acrescenta clausula "Union" para juntar todas as select's.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery:=""
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida Query a ser executada.                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cQuery := ChangeQuery(If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + If(LEN(_aQuery)>=12,_aQuery[12],'') + ' ' + If(LEN(_aQuery)>=13,_aQuery[13],'') + ' ' + If(LEN(_aQuery)>=14,_aQuery[14],'') + ' ' + If(LEN(_aQuery)>=15,_aQuery[15],'') + ' ' + cQuery)
		SB2->(dbCommit())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Alias temporario com o resultado da Query.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ajusta os campos que nao sao Caracter de acordo com a estrutura do SB2  ³
		//³ uma vez que a TcGenQuery retorna todos os campos como Caracter.         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aStruSB2)
			If aStruSB2[nX][2]<>"C"
				TcSetField(cCursor,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
			EndIf
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia montagem do array (aViewB2) para visualizacao no Browse e        ³
		//³ posterior retorno da funcao.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata variaveis a serem passadas para o Array para nao poluir o Browse. ³
			//³ Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _cCodEmpA == Alltrim((cCursor)->CODFIL) .and. lBrowse
				_cNomeEmp := ""
				_cCodEmp  := ""
			Else
				_cNomeEmp := Alltrim((cCursor)->NOMEFIL)
				_cCodEmp  := Alltrim((cCursor)->CODFIL)
			EndIf

			_cNomeEmpA := Alltrim((cCursor)->NOMEFIL)
			_cCodEmpA  := Alltrim((cCursor)->CODFIL)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata variaveis a serem passadas para o Array para nao poluir o Browse. ³
			//³ Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _cCodProA == Alltrim((cCursor)->B2_COD) .and. lBrowse
				_cCodPro := ""
			Else
				_cCodPro := Alltrim((cCursor)->B2_COD)
			EndIf

			_cCodProA    := Alltrim((cCursor)->B2_COD)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicia montagem do Array.                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cDescAlm:= GetAdvFVal("NNR","NNR_DESCRI", (cCursor)->B2_FILIAL + (cCursor)->B2_LOCAL, 1, "")
			If lBrowse
				aAdd(aViewB2,{;//_cNomeEmp,;
				TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
				TransForm(cDescAlm,PesqPict("NNR","NNR_DESCRI")),;
				TransForm(SaldoSB2(,,,,,cCursor),PesqPict("SB2","B2_QATU")),;
				0.00,;
				TransForm((cCursor)->B2_QATU,PesqPict("SB2","B2_QATU")),;
				TransForm((cCursor)->B2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
				TransForm((cCursor)->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
				TransForm((cCursor)->B2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
				TransForm((cCursor)->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
				"";
				})
			Else
				aAdd(aViewB2,{;//_cNomeEmp,;
				(cCursor)->B2_LOCAL,;
				cDescAlm,;
				SaldoSB2(,,,,,cCursor),;
				0.000,;
				(cCursor)->B2_QATU,;
				(cCursor)->B2_QPEDVEN,;
				(cCursor)->B2_QEMP,;
				(cCursor)->B2_RESERVA,;
				(cCursor)->B2_SALPEDI,;
				"";
				})
			EndIf

			DbSelectArea(cCursor)
			DbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha arquivo temporario da TcGenQuery                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cCursor)
		DbCloseArea()
		DbSelectArea("SB2")

		oListBox:Refresh()

	End

	if !_lSim
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carregando browse de Produtos Similares                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MontSim17(cProduto)
	End

Return _cProdSel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaSim  ºAutor  ³Microsiga           º Data ³  12/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontSim17(_cProduto)

	ASIZE(_aProdSim,0)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia montagem da Matriz com Dados de Produtos Similares               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZ3")
	DbSetOrder(2) // Filial + Produto

	If DbSeek(xFilial("SZ3")+_cProduto,.f.)
		cFamilia := SZ3->Z3_FAMILIA
		cItem    := "0000"

		DbSetOrder(1) // Filial + Familia
		DbSeek(xFilial("SZ3")+cFamilia,.f.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona todos os produtos no array, relacionados a familia ...        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof() .and. SZ3->Z3_FAMILIA == cFamilia

			If SZ3->Z3_PRODUTO == _cProduto
				DbSelectArea("SZ3")
				SZ3->(DbSkip())
				Loop
			EndIf

			cItem := Soma1(cItem)
			Aadd(_aProdSim,{SZ3->Z3_PRODUTO,Posicione("SB1",1,xFilial("SB1")+SZ3->Z3_PRODUTO,"B1_ESPECIF"),SB1->B1_UM,SB1->B1_PRV1})
			DbSelectArea("SZ3")
			SZ3->(DbSkip())
		End

	EndIf

	oListSim:Refresh()

Return

Static Function ConsProd17(_cProduto)
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

Static Function ConsKard17(_cProduto,_cAlm)
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

Static Function MostFoto17(_cProduto)
	Local _cArea:=GetArea()

	//FSigamat()
	//Return

	If !Empty(_cProduto)
		//_cAlm:=aViewB2[oListBox:nAT,2]
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+_cProduto))

			@ 000,000 To 405,400 DIALOG oDlgT TITLE "Imagen del Producto"

			@05,05 TO 200,200 LABEL ("Imagen") OF oDlgT PIXEL  //"Foto" 193/105
			If Empty(SB1->B1_BITMAP)
				@ 80,30 SAY ("Imagen no disponible") SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlgT //"Foto n?o disponivel"
			Else
				//@ 10,10 REPOSITORY oBitPro OF oDlgT NOBORDER SIZE 350,350 PIXEL
				@ 05,05 REPOSITORY oBitPro OF oDlgT NOBORDER SIZE 200,200 PIXEL
				Showbitmap(oBitPro,SB1->B1_BITMAP,"")
				oBitPro:lStretch:=.T. //Ajustar al tamaño del Dialog
				oBitPro:Refresh()
			Endif
			ACTIVATE DIALOG ODLGT CENTERED
		End
	End
	RestArea(_cArea)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Función que muestra los datos del Sigamat - Tabla SM0                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Sigamat17
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

Static Function MostList17(cProduto,_lSim,cArmazem,lBrowse,aArmazem)
	Local aStruDA1  := {}
	Local nX        := 0
	Local cQuery    := ""
	Local _cNomeEmp := ""
	Local _cCodEmp  := ""
	Local nC		:= 0

	_cProdSel:= cProduto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trata parametro de pesquisa por Armazem. Caso o parametro nao seja     ³
	//³ passado, listara todos os armazens encontrados.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(cArmazem) == 'U'
		cArmazem := "I"
	EndIf

	If ValType(aArmazem) == 'U'
		aArmazem := {}
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trata parametro de visualizacao do Browse. Caso o parametro nao seja   ³
	//³ passado, apresenta o Browse de consulta.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(lBrowse) == 'U'
		lBrowse := .t.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o cadastro de produtos                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SB1')
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto,.f.)
		cCursor   := "MAVIEWDA1"
		lQuery    := .T.
		aStruDA1  := DA1->(dbStruct())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre arquivo de empresas para obter empresas para consulta do estoque  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SM0")
		DbSetOrder(1)
		DbGoTop()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta cQuery para realizar select no SB2 de todas as Empresas e Filiais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

				nTC = POSICIONE("SM2",1,DATE(),"M2_MOEDA2")///TRAER TASA DE CAMBIO 2
				nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

				//hay moneda del dia
				If nTC > 0
					cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
					cQuery += "DA1_CODPRO,DA1_CODTAB,1 DA1_MOEDA, "
					cQuery += "(SELECT TOP 1 ZRA_NUMERO FROM " + RetSqlName("ZRA") + " WHERE D_E_L_E_T_ <> '*' AND ZRA_RAZON = DA1_URAZON) AS ZRA_NUMERO, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN*"+ cValToChar(nTC) +",5) END DA1_PRCVEN, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC00 ELSE ROUND(DA1_UDSC00*"+ cValToChar(nTC) +",5) END DA1_UDSC00, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC05 ELSE ROUND(DA1_UDSC05*"+ cValToChar(nTC) +",5) END DA1_UDSC05, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC10 ELSE ROUND(DA1_UDSC10*"+ cValToChar(nTC) +",5) END DA1_UDSC10, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC12 ELSE ROUND(DA1_UDSC12*"+ cValToChar(nTC) +",5) END DA1_UDSC12, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC15 ELSE ROUND(DA1_UDSC15*"+ cValToChar(nTC) +",5) END DA1_UDSC15, "
					cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC17 ELSE ROUND(DA1_UDSC17*"+ cValToChar(nTC) +",5) END DA1_UDSC17 "
					cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
					cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
					cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
					cQuery += "      DA1.D_E_L_E_T_ = '' "
					cQuery += "UNION "
					cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
					cQuery += "DA1_CODPRO,DA1_CODTAB,2 DA1_MOEDA, "
					cQuery += "(SELECT TOP 1 ZRA_NUMERO FROM " + RetSqlName("ZRA") + " WHERE D_E_L_E_T_ <> '*' AND ZRA_RAZON = DA1_URAZON) AS ZRA_NUMERO, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN/"+ cValToChar(nTC) +",5) END DA1_PRCVEN, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC00 ELSE ROUND(DA1_UDSC00/"+ cValToChar(nTC) +",5) END DA1_UDSC00, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC05 ELSE ROUND(DA1_UDSC05/"+ cValToChar(nTC) +",5) END DA1_UDSC05, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC10 ELSE ROUND(DA1_UDSC10/"+ cValToChar(nTC) +",5) END DA1_UDSC10, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC12 ELSE ROUND(DA1_UDSC12/"+ cValToChar(nTC) +",5) END DA1_UDSC12, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC15 ELSE ROUND(DA1_UDSC15/"+ cValToChar(nTC) +",5) END DA1_UDSC15, "
					cQuery += "CASE WHEN DA1_MOEDA = 2 THEN DA1_UDSC17 ELSE ROUND(DA1_UDSC17/"+ cValToChar(nTC) +",5) END DA1_UDSC17 "
					cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
					cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
					cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
					cQuery += "      DA1.D_E_L_E_T_ = '' "
					
					IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. nTC2 > 0  ////preguntamos si es importacion para activar la tasa auxiliar
						cQuery += "UNION "
						cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
						cQuery += "DA1_CODPRO,DA1_CODTAB,5 DA1_MOEDA, "
						cQuery += "(SELECT TOP 1 ZRA_NUMERO FROM " + RetSqlName("ZRA") + " WHERE D_E_L_E_T_ <> '*' AND ZRA_RAZON = DA1_URAZON) AS ZRA_NUMERO, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN*"+ cValToChar(nTC2) +",5) END DA1_PRCVEN, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC00 ELSE ROUND(DA1_UDSC00*"+ cValToChar(nTC2) +",5) END DA1_UDSC00, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC05 ELSE ROUND(DA1_UDSC05*"+ cValToChar(nTC2) +",5) END DA1_UDSC05, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC10 ELSE ROUND(DA1_UDSC10*"+ cValToChar(nTC2) +",5) END DA1_UDSC10, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC12 ELSE ROUND(DA1_UDSC12*"+ cValToChar(nTC2) +",5) END DA1_UDSC12, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC15 ELSE ROUND(DA1_UDSC15*"+ cValToChar(nTC2) +",5) END DA1_UDSC15, "
						cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_UDSC17 ELSE ROUND(DA1_UDSC17*"+ cValToChar(nTC2) +",5) END DA1_UDSC17 "
						cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
						cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
						cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
						cQuery += "      DA1.D_E_L_E_T_ = '' "
					endif
					lMoeda = .t.
				Else
					Alert("No existe Tipo de Cambio para esta Fecha. Por favor ingrese el Tipo de Cambio para la fecha "+ DTOC(DATE()) +".!!!!")
					cQuery += "SELECT '"+_cNomeEmp+"' as NOMEFIL, '"+_cCodEmp+"' as CODFIL, '" + STR(_cOrdQuery)+"' as ORDFIL,"
					cQuery += "DA1_CODPRO,DA1_CODTAB,DA1_MOEDA, "
					cQuery += "(SELECT TOP 1 ZRA_NUMERO FROM " + RetSqlName("ZRA") + " WHERE D_E_L_E_T_ <> '*' AND ZRA_RAZON = DA1_URAZON) AS ZRA_NUMERO, "
					cQuery += "DA1_PRCVEN,DA1_UDSC00,DA1_UDSC05,DA1_UDSC10,DA1_UDSC12,DA1_UDSC15,DA1_UDSC17 "
					cQuery += "FROM DA1"+SM0->M0_CODIGO+"0 DA1 "
					cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
					cQuery += "      DA1_CODPRO = '"+_cProdSel+"' and "
					cQuery += "      DA1.D_E_L_E_T_ = '' "
					cQuery += "ORDER BY DA1_CODTAB,DA1_CODPRO "
					lMoeda = .f.
				EndIf

				_cOrdQuery:=	_cOrdQueryAct

			Endif
			DbSkip()

			//		Aadd(_aQuery,cQuery)
			//		cQuery:=""

		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida Query a ser executada.                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := ChangeQuery(If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + If(LEN(_aQuery)>=12,_aQuery[12],'') + ' ' + If(LEN(_aQuery)>=13,_aQuery[13],'') + ' ' + If(LEN(_aQuery)>=14,_aQuery[14],'') + ' ' + If(LEN(_aQuery)>=15,_aQuery[15],'') + ' ' + cQuery)
		DA1->(dbCommit())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Alias temporario com o resultado da Query.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ajusta os campos que nao sao Caracter de acordo com a estrutura do SB2  ³
		//³ uma vez que a TcGenQuery retorna todos os campos como Caracter.         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aStruDA1)
			If aStruDA1[nX][2]<>"C"
				TcSetField(cCursor,aStruDA1[nX][1],aStruDA1[nX][2],aStruDA1[nX][3],aStruDA1[nX][4])
			EndIf
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia montagem do array (aViewDA1) para visualizacao no Browse e        ³
		//³ posterior retorno da funcao.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata variaveis a serem passadas para o Array para nao poluir o Browse. ³
			//³ Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _cCodEmpA == Alltrim((cCursor)->CODFIL) .and. lBrowse
				_cNomeEmp := ""
				_cCodEmp  := ""
			Else
				_cNomeEmp := Alltrim((cCursor)->NOMEFIL)
				_cCodEmp  := Alltrim((cCursor)->CODFIL)
			EndIf

			_cNomeEmpA := Alltrim((cCursor)->NOMEFIL)
			_cCodEmpA  := Alltrim((cCursor)->CODFIL)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata variaveis a serem passadas para o Array para nao poluir o Browse. ³
			//³ Caso lBrowse seja .f., deixa o Array sem os devidos tratamentos.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _cCodProA == Alltrim((cCursor)->DA1_CODPRO) .and. lBrowse
				_cCodPro := ""
			Else
				_cCodPro := Alltrim((cCursor)->DA1_CODPRO)
			EndIf

			_cCodProA    := Alltrim((cCursor)->DA1_CODPRO)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicia montagem do Array.                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
				TransForm((cCursor)->ZRA_NUMERO,PesqPict("ZRA","ZRA_NUMERO"))})
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
				(cCursor)->ZRA_NUMERO})
			EndIf
			nC += 1
			//Alert("NomEmp: "+aViewDA1[nC][1]+" Tabla: "+aViewDA1[nC][2]+" PrecVen: "+CValToChar(aViewDA1[nC][3]))
			DbSelectArea(cCursor)
			DbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha arquivo temporario da TcGenQuery                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cCursor)
		DbCloseArea()
		DbSelectArea("DA1")

		oListBox1:Refresh()
		//oMainWnd:Refresh()
	End

	if !_lSim
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carregando browse de Produtos Similares                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MontSim17(cProduto)
	End

Return _cProdSel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloque de codigo que se ejecuta al dar Doble Click en la Grilla Gasto TwBrowse - EDUAR ³
//³Marca los checkBox y realiza validación por Linea y por monto total del valor digitado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

Static Function DobleClick(aItens,oBrowse)
	Local nValDisp 	:= Val(aItens[oBrowse:nAt][3])*1000000
	Local axArea    := GetArea()

	_lSelecionou := .F.
	If aItens[oBrowse:nAt][1] == M->C5_ULOCAL
		_aLinha := Aclone(aCols[1])
		lEditCell(@aItens,oBrowse,"@E 99,999,999.99",4)
		If aItens[oBrowse:nAt][4] > nValDisp .AND. GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SB1->B1_TS,1,"")=="S" .AND. M->C5_DOCGER <> '3'
			Aviso("Monto mayor al disponible","Disponible: "+AllTrim(Str(nValDisp)),{"OK"})
			aItens[oBrowse:nAt][4]:=0.00
		Else

			nXCant:= U_GetStockNeg(_cProdSel,aItens[oBrowse:nAt][1], aItens[oBrowse:nAt][4]) //Validacion Stock Negativo
			
			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+_cProdSel,.f.)

			aItens[oBrowse:nAt][4]:= nXCant

			If aItens[oBrowse:nAt][4] > 0.00

				if !empty(_aColsCop)

					// validacion de nuevos
					if _cProdSel == _aColsCop[LEN(_aColsCop),nPoscod] .and. aItens[oBrowse:nAt][1] == _aColsCop[LEN(_aColsCop),nPosDep]
						_aColsCop[LEN(_aColsCop),nPoscod]  := _cProdSel					//Codigo del Producto
						_aColsCop[LEN(_aColsCop),nPQtdVen]  := aItens[oBrowse:nAt][4]	//Cantidad
						_aColsCop[LEN(_aColsCop),nPosDep]  := aItens[oBrowse:nAt][1]	//Almacen
					else
						//					alert("1er alert" + cvaltochar(_cProdSel))					//Codigo del Producto
						//					alert("2do alert" + cvaltochar(aItens[oBrowse:nAt][4]))		//Cantidad
						//					alert("3er alert" + cvaltochar(aItens[oBrowse:nAt][1]))		//Almacen
						aadd(_aColsCop,Array(nUsado+1))
						_aColsCop[LEN(_aColsCop),nPoscod]  := _cProdSel					//Codigo del Producto
						_aColsCop[LEN(_aColsCop),nPQtdVen]  := aItens[oBrowse:nAt][4]	//Cantidad
						_aColsCop[LEN(_aColsCop),nPosDep]  := aItens[oBrowse:nAt][1]	//Almacen

					endif
				else
					aadd(_aColsCop,Array(nUsado+1))
					_aColsCop[LEN(_aColsCop),nPoscod]  := _cProdSel					//Codigo del Producto
					_aColsCop[LEN(_aColsCop),nPQtdVen]  := aItens[oBrowse:nAt][4]	//Cantidad
					_aColsCop[LEN(_aColsCop),nPosDep]  := aItens[oBrowse:nAt][1]	//Almacen

				Endif

			else
				if(!empty(_aColsCop))
					if _cProdSel == _aColsCop[LEN(_aColsCop),nPoscod] .and. aItens[oBrowse:nAt][1] == _aColsCop[LEN(_aColsCop),nPosDep]
						_aColsCop[LEN(_aColsCop),nPoscod]  := _cProdSel					//Codigo del Producto
						_aColsCop[LEN(_aColsCop),nPQtdVen]  := aItens[oBrowse:nAt][4]	//Cantidad
						_aColsCop[LEN(_aColsCop),nPosDep]  := aItens[oBrowse:nAt][1]	//Almacen
					else
						aadd(_aColsCop,Array(nUsado+1))
						_aColsCop[LEN(_aColsCop),nPoscod]  := _cProdSel					//Codigo del Producto
						_aColsCop[LEN(_aColsCop),nPQtdVen]  := aItens[oBrowse:nAt][4]	//Cantidad
						_aColsCop[LEN(_aColsCop),nPosDep]  := aItens[oBrowse:nAt][1]	//Almacen
					endif
				EndIf
			endif

			endif

		Endif
	End

	RestArea(axArea)

Return
static function aceptar()
	lVal:= .T.
	oDlg:End()

return

/**
*
* @author: Denar Terrazas Parada
* @since: 29/09/2020
* @description: Función para visualizar documentos(Conocimiento)
*/
Static Function MSdoc(cProduto)

	Local aArea:= getArea()
	Private aRotina := FWloadmenudef('MATA010')//Maestro de Productos

	If(!Empty(cProduto))
		MsDocument('SB1',SB1->(RecNo()), 2)
	EndIf

	restArea(aArea)

return .T.

/**
*
* @author: Denar Terrazas Parada
* @since: 27/11/2020
* @description: Función para grabar las búsquedas/consultas de los productos
*				(NO APLICA EN LOS PEDIDOS DE VENTAS)
*/
Static Function GrabaBusq(cProduto)
	Local aArea:= getArea()
	If( TRIM(FunName()) <> 'MATA410' )//Si NO es un Pedido de venta

		If( TRIM(FunName()) == 'MATA415' )
			U_GrabaZB1(cProduto, "Presupuestos", M->CJ_NUM, M->CJ_CLIENTE)
		Else
			U_GrabaZB1(cProduto, "Consulta Nueva")
		EndIf

	EndIf
	restArea(aArea)
Return

/**
*
* @author: Denar Terrazas Parada
* @since: 02/12/2020
* @description: Función para mostrar la imagen del producto en el browser, al hacer doble click en el producto
*/
Static Function fotoBrowser(_cProduto)
	Local aArea:= getArea()

	If !Empty(_cProduto)
		//_cAlm:=aViewB2[oListBox:nAT,2]
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+_cProduto))

			If Empty(SB1->B1_BITMAP)
				/*If oBitPro:ExistBmp(cNombImg)
				oBitPro:DeleteBmp(cNombImg)
				EndIf
				oBitPro:Refresh()*/
				//oDlg:Refresh()
				@ 070,535 SAY ("Imagen no disponible" + CRLF + TRIM(_cProduto)) SIZE 100,16 PIXEL COLOR CLR_BLUE OF oDlg //"Foto n?o disponivel"
			Else
				//@ 10,10 REPOSITORY oBitPro OF oDlg NOBORDER SIZE 350,350 PIXEL
				@ 020,500 REPOSITORY oBitPro OF oDlg NOBORDER SIZE 122,122 PIXEL
				cNombImg:= SB1->B1_BITMAP
				Showbitmap(oBitPro,cNombImg,"")
				oBitPro:lStretch:=.T. //Ajustar al tamaño del Dialog
				oBitPro:Refresh()
			Endif
			lBorrarImg:= .T.
			//ACTIVATE DIALOG oDlg //CENTERED
		End
	End
	RestArea(aArea)
Return

/**
*
* @author: Denar Terrazas Parada
* @since: 10/12/2020
* @description: Función para limpiar las imagenes que se van cargando en el browser
*
*/
Static Function limpiarImg()

	Local aArea:= getArea()

	if(lBorrarImg)
		oDlg:ACONTROLS[LEN(oDlg:ACONTROLS)]:LVISIBLECONTROL:= .F.
		lBorrarImg:= .F.
	EndIf

	RestArea(aArea)

Return

/**
*
* @author: Denar Terrazas Parada
* @since: 07/03/2022
* @description: Función que actualiza el número de la Razón
*
*/
Static Function actualizarRazon(aXViewDA1)
	cRazon:= ""

	If( Len(aXViewDA1)>0 )
		If( aXViewDA1[11] <> NIL )
			cRazon:= aXViewDA1[11]//Número de la Razón
		EndIf
	EndIf
	oMsGetRazon:Refresh()
Return

/**
*
* @author: Denar Terrazas Parada
* @since: 07/03/2022
* @description: Función que limpia el número de la Razón
*
*/
Static Function limpiarRazon()
	cRazon:= ""
	oMsGetRazon:Refresh()
Return
