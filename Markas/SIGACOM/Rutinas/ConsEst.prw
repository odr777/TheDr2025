#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function ConsEst(_lSXB)

Local _aArea    := GetArea()
Private _aBuscaProd	:= {{"","","","","","",""}}
Private aViewB2		:= {{"","","","","","","","",""}}
Private _aProdSim	:= {{"","","",""}}
Private _cProdSel	:= ""
Private lBrowse 	:= .t.
//PRIVATE INCLUI  	:= .F.
PRIVATE cCadastro	:= "Consulta General del Producto"
Private oDlg
private oSayProd
Private L110AUTO:=.F.
DEFAULT _lSXB	:= .F.

//Alert("Caso esta rotina seja utiliza, avise-nos pois dentro de dias a mesma sera removida !!! ")

_aGets := {}
AADD(_aGets,{"B1_COD",Space(20)})
AADD(_aGets,{"B1_DESC",Space(80)})
AADD(_aGets,{"B1_ESPECIF",Space(80)})
//AADD(_aGets,{"ZNO_DESC",Space(20)})
/*AADD(_aGets,{"B1_UCAPACI",Space(30)})
AADD(_aGets,{"B1_UDIMENS",Space(20)})
AADD(_aGets,{"B1_MODELO",Space(20)})
AADD(_aGets,{"ZMA_DESCRI",Space(20)})
*/
_aOrdem  := {"Ascendente","Descendente"}
_cOrdem  :=_aOrdem[1]


If lBrowse
	
	@ 000,000 To 440,905 DIALOG oDlg TITLE "Consulta de Productos"
	
	@ 010,005 SAY "CODIGO" Object oSayProd
	@ 010,040 MSGET _aGets[1,2] SIZE 060,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_COD")
	
	@ 025,005 SAY "DESCRIPCION" Object oSayDesc
	@ 025,040 MSGET _aGets[2,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_DESC")
	
	@ 040,005 SAY "ESPECÍFICA" Object oSayDescEsp
	@ 040,040 MSGET _aGets[3,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_ESPECIF")  
	
	//@ 055,005 SAY "NORMA" Object oSayNorma
	//@ 055,040 MSGET _aGets[4,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("ZNO","ZNO_DESC")
/*
	@ 055,005 SAY "CAPACIDAD" Object oSayCapacidad
	@ 055,040 MSGET _aGets[4,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_UCAPACI")
	
	@ 070,005 SAY "DIMENSIÓN" Object oSayDimension
	@ 070,040 MSGET _aGets[5,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_UDIMENS")
	
	@ 055,160 SAY "MODELO" Object oSayModelo
	@ 055,205 MSGET _aGets[6,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_MODELO")
	
	@ 070,160 SAY "NORMA" Object oSayNorma
	@ 070,205 MSGET _aGets[7,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("ZNO","ZNO_DESC")
*/
//	@ 055,005 SAY "DESCRIPCION" Object oSayDescEsp
//	@ 055,040 MSGET _aGets[3,2] SIZE 100,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_ESPECIF")

//	@ 048,005 SAY "ESPECÍFICA" Object oSayDescEsp1	
//	@ 055,005 SAY "GRUPO" Object oSayGrupo
//	@ 055,040 MSGET _aGets[4,2] SIZE 060,008 OF oDlg PIXEL  Picture PesqPict("SBM","BM_GRUPO")
	
 //	@ 070,005 SAY "COD ANTERIOR" Object oSayGrupo
  //	@ 070,040 MSGET _aGets[5,2] SIZE 060,008 OF oDlg PIXEL  Picture PesqPict("SB1","B1_COD")
	
//  	@ 055,005 COMBOBOX oCbx VAR _cOrdem ITEMS _aOrdem SIZE 40,08 OF oDlg PIXEL

	@ 010,160 BUTTON "&Buscar" SIZE 040,010 ACTION BuscaProd() Object oBnt
	@ 025,160 BUTTON "&Incluir" SIZE 040,010 ACTION  AxInclui('SB1',,3,,,,,,,,,,,.T.) Object oBnt1
	@ 040,160 BUTTON "&Confirmar" SIZE 040,010 ACTION oDlg:End() Object oBnt2
	
	//@ 112,005 BUTTON "Cons Producto" SIZE 040,008 ACTION ConsProd(_cProdSel) Object oBnt
    //	@ 112,060 BUTTON "Kardex por Dia" SIZE 040,008 ACTION ConsKard(_cProdSel) Object oBnt
	
  //	@ 124,005 BUTTON "Foto Producto" SIZE 040,008 ACTION MostraFoto(_cProdSel) Object oBnt
//	@ 124,060 BUTTON "Saldos Direcion" SIZE 040,008 ACTION U_A410Test2(_cProdSel,.F.) Object oBnt
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia montagem do browse (Busca Produtos).                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	oListProd := TWBrowse():New( 05,105,280,060,,{"Codigo","Descripcion","Unid","Precio Venta","Cod Anterior"},{50,165,15,40,50},oDlg,,,,,{||IF(LEN(_aBuscaProd)>0,MostraEst(_aBuscaProd[oListProd:nAT,1],.F.),.t.)},,,,,,,.F.,,.T.,,.F.,,,)
	oListProd := TWBrowse():New(  070,05,445,085,,{"Codigo","Descripción","Específica"},{40,130,150},oDlg,,,,,{||IF(LEN(_aBuscaProd)>0,MostraEst(_aBuscaProd[oListProd:nAT,1],.T.),.t.)},,,,,,,.F.,,.T.,,.F.,,,)
	oListProd :SetArray(_aBuscaProd)
//	oListProd :bChange := { || if(Len(_aBuscaProd)>0,MostrarProducto(_aBuscaProd[oListProd:nAT],,.F.),.t.)}
	oListProd :bLine := { || if(Len(_aBuscaProd)>0,_aBuscaProd[oListProd:nAT],.t.)}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia montagem do browse (Produtos Similares).                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	oListSim := TWBrowse():New( 072,105,280,060,,{"Codigo","Descripcion","Unid","Precio Venta"},{50,165,15,40},oDlg,,,,,{||If(Len(_aProdSim)>0,MostraEst(_aProdSim[oListSim:nAT,1],.T.),.T.)},,,,,,,.F.,,.T.,,.F.,,,)
  //	oListSim :SetArray(_aProdSim)
//	oListSim :bLine := { || If(Len(_aProdSim)>0,_aProdSim[oListSim:nAT],.t.)}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia montagem do browse (Saldos em Estoque).                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 	oListBox := TWBrowse():New( 160,05,380,060,,{"Empresa/Sucursal","Alm.","Disponible","Saldo Actual","Pedido Ventas","Reservada","Prevista Entrada","Reservada S.A.","Reservada"},{65,15,42,42,42,42,42,42,42,42,42},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aViewB2)
 	oListBox:bLine := { || If(Len(aViewB2)>0,aViewB2[oListBox:nAT],.t.)}
	if !Empty(&(READVAR()))
		_aGets[1,2]:=&(READVAR())
		_cProdSel:=&(READVAR())
		//BuscaProd()
		_cProdSel:=&(READVAR())
		
	End
	oDlg:bStart:= {|| oBnt:Click() }
	ACTIVATE DIALOG oDlg CENTERED
	
EndIf


RestArea(_aArea)

If _lSXB
	&(READVAR()) := _cProdSel
End

Return(.T.)


Static Function BuscaProd()
Local _cQueryProd,_nCont,_nContCpo:=0

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
/*
Private _aBuscaProd:={{"","","",""}}
Private aViewB2	:= {{"","","","","","","","",""}}
*/
If Select("BUSCAPROD") > 0
	BUSCAPROD->(DbCloseArea())
Endif

_cQueryProd:="SELECT SB1.* "
/*If !Empty(_aGets[4,2])
	_cQueryProd+=" , ZNO.ZNO_DESC" 
En*/
_cQueryProd+=" FROM " + RetSqlName("SB1") +" SB1 "
//_cQueryProd+=" FROM SB1010 SB1 "
//_cQueryProd+=" LEFT JOIN " +RetSqlName("SZM") + " SZM On B1_FABRIC=ZM_CODIGO "   //MARCA PRODUCTO
//_cQueryProd+=" LEFT JOIN SZM010 SZM On B1_FABRIC=ZM_CODIGO "   //MARCA PRODUCTO
/*
If !Empty(_aGets[4,2])
	_cQueryProd+=" INNER JOIN " + RetSqlName("ZNO") +" ZNO  ON SB1.B1_UNORMA = ZNO.ZNO_COD "
End
	*/

_cQueryProd+=" WHERE "
/*
//Processando matriz de GETS
For _nCont:=1 to Len(_aGets)

If !Empty(_aGets[_nCont,2])
_nContCpo++
If _nContCpo > 1
_cQueryProd+=" AND "
End
_cQueryProd+= _aGets[_nCont,1] + " LIKE '%" + Alltrim(_aGets[_nCont,2]) + "%' "
End
Next _nCont
*/

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

_cQueryProd+=" AND SB1.D_E_L_E_T_ <> '*'"
//_cQueryProd+=" AND SZM.D_E_L_E_T_ <> '*'"
/*IF FUNNAME() == 'MATA410'.OR.FUNNAME() == 'MATA462N'.OR.FUNNAME() == 'MATA467N'
	_aTipo :=  StrToArray(GETNEWPAR('MV_UGRTP','05;06'),';')
	For i:=1 To Len(_aTipo)
		_cQueryProd+=" AND SB1.B1_TIPO <> '" + _aTipo[i] + "'"
	Next
End*/
_cQueryProd+=" ORDER BY B1_COD "
If(Left(_cOrdem,1))=='D'
	_cQueryProd+=" DESC"
End
TCQUERY _cQueryProd NEW ALIAS "BUSCAPROD"

//MEMOWRITE('BUSCAPROD.SQL', _cQueryProd)


IF BUSCAPROD->(!EOF()) .AND. BUSCAPROD->(!BOF())
	BUSCAPROD->(DbGoTop())
	
	ASIZE(_aBuscaProd,BUSCAPROD->(RecCount()))
	ASIZE(aViewB2,0)
	_nCont:=0

	WHILE BUSCAPROD->(!EOF())
		if _nCont==1
			_aBuscaProd[1,1]:=BUSCAPROD->B1_COD
			_aBuscaProd[1,2]:=BUSCAPROD->B1_DESC
			_aBuscaProd[1,3]:=alltrim(BUSCAPROD->B1_ESPECIF)                 
			//_aBuscaProd[1,4]:=BUSCAPROD->B1_UM
			//_aBuscaProd[1,4]:=BUSCAPROD->B1_UCAPACI     
			//_aBuscaProd[1,5]:=BUSCAPROD->B1_UDIMENS
			//_aBuscaProd[1,6]:=BUSCAPROD->B1_MODELO
			/*If !Empty(_aGets[4,2])
				_aBuscaProd[1,4]:=alltrim(BUSCAPROD->ZNO_DESC)
			else
				_aBuscaProd[1,4]:=BUSCAPROD->B1_UNORMA
			end*/                                  
//			_aBuscaProd[1,4]:=Transform(BUSCAPROD->B1_PRV1SUS,PesqPict("SB1","B1_PRV1"))
  //			_aBuscaProd[1,5]:=BUSCAPROD->B1_UCODANT
			_nCont++
		Else
			//AADD(_aBuscaProd,{BUSCAPROD->B1_COD,BUSCAPROD->B1_DESC,alltrim(BUSCAPROD->B1_ESPECIF),IIf(!Empty(_aGets[4,2]),BUSCAPROD->ZNO_DESC,BUSCAPROD->B1_UNORMA)})
			AADD(_aBuscaProd,{BUSCAPROD->B1_COD,BUSCAPROD->B1_DESC,alltrim(BUSCAPROD->B1_ESPECIF)})
		End
		BUSCAPROD->(DbSkip())
	END
End

oListProd:Refresh()
//oListBox:Refresh()
Return


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
		If 	TCCANOPEN("SB2"+SM0->M0_CODIGO+"0") .and. TCCANOPEN("SC6"+SM0->M0_CODIGO+"0") .and.  TCCANOPEN("SF2"+SM0->M0_CODIGO+"0")
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
			cQuery += "B2_COD,B2_LOCAL,B2_QATU,B2_QPEDVEN,B2_QEMP,B2_SALPEDI,B2_QEMPSA,B2_RESERVA,B2_QEMPPRJ,B2_QACLASS,B2_STATUS, "
			cQuery += "(Select Sum(C6_QTDVEN-C6_QTDENT-C6_QTDEMP) SALDOPED "
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
			Endif
			
			cQuery += "      F2_PEDPEND is null and "
			cQuery += "      F4_ESTOQUE = 'S' and "
			cQuery += "      SC6.D_E_L_E_T_ = '') SALPED "
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
		IF TCCANOPEN("SB2"+SM0->M0_CODIGO+"0") .and. TCCANOPEN("SC6"+SM0->M0_CODIGO+"0") .and. TCCANOPEN("SF2"+SM0->M0_CODIGO+"0")
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
	// ALERT(STR(_aQuery))
	// ALERT(_aQuery[1] +  _aQuery[2] + _aQuery[3] + _aQuery[4] + '-----'+cQuery )

	//Memowrite("CONSESTjorge7.txt",If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + cQuery)	
	//MemoWrite("cQRY1.sql",cQuery)
	//cQuery := ChangeQuery(If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + cQuery)
	cQuery := ChangeQuery(If(LEN(_aQuery)>=1,_aQuery[1],'') + ' '+  If(LEN(_aQuery)>=2,_aQuery[2],'') + ' '+ If(LEN(_aQuery)>=3,_aQuery[3],'')  + ' '+ If(LEN(_aQuery)>=4,_aQuery[4],'')+ ' ' + If(LEN(_aQuery)>=5,_aQuery[5],'')+ ' '+ If(LEN(_aQuery)>=6,_aQuery[6],'')+ ' '+ If(LEN(_aQuery)>=7,_aQuery[7],'')+ ' '+ If(LEN(_aQuery)>=8,_aQuery[8],'')+ ' '+ If(LEN(_aQuery)>=9,_aQuery[9],'')+ ' '+ If(LEN(_aQuery)>=10,_aQuery[10],'')+ ' '+ If(LEN(_aQuery)>=11,_aQuery[11],'')+ ' ' + If(LEN(_aQuery)>=12,_aQuery[12],'') + ' ' + If(LEN(_aQuery)>=13,_aQuery[13],'') + ' ' + If(LEN(_aQuery)>=14,_aQuery[14],'') + ' ' + If(LEN(_aQuery)>=15,_aQuery[15],'') + ' ' + cQuery)
	

	//MemoWrite("cQRY2.sql",cQuery)
	
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
		
		If lBrowse
			aAdd(aViewB2,{_cNomeEmp,;
			TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
			TransForm(SaldoSB2(,,,,,cCursor)-(cCursor)->SALPED,PesqPict("SB2","B2_QATU")),;
			TransForm((cCursor)->B2_QATU,PesqPict("SB2","B2_QATU")),;
			TransForm((cCursor)->SALPED,PesqPict("SB2","B2_QPEDVEN")),;
			TransForm((cCursor)->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
			TransForm((cCursor)->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
			TransForm((cCursor)->B2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
			TransForm((cCursor)->B2_RESERVA,PesqPict("SB2","B2_RESERVA"))})
		Else
			aAdd(aViewB2,{_cNomeEmp,;
			(cCursor)->B2_LOCAL,;
			SaldoSB2(,,,,,cCursor)-(cCursor)->SALPED,;
			(cCursor)->B2_QATU,;
			(cCursor)->SALPRED,;
			(cCursor)->B2_QEMP,;
			(cCursor)->B2_SALPEDI,;
			(cCursor)->B2_QEMPSA,;
			(cCursor)->B2_RESERVA})
		EndIf
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acumula totalizadores.                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotDisp	+= SaldoSB2(,,,,,cCursor)
		nSaldo	+= (cCursor)->B2_QATU
		nQtPV	+= (cCursor)->B2_QPEDVEN
		nQemp	+= (cCursor)->B2_QEMP
		nSalpedi	+= (cCursor)->B2_SALPEDI
		nReserva	+= (cCursor)->B2_RESERVA
		nQempSA	+= (cCursor)->B2_QEMPSA         */
		
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
	MontaSim(cProduto)
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
Static Function MontaSim(_cProduto)

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
		Aadd(_aProdSim,{SZ3->Z3_PRODUTO,Posicione("SB1",1,xFilial("SB1")+SZ3->Z3_PRODUTO,"B1_DESC"),SB1->B1_UM,SB1->B1_PRV1})
		DbSelectArea("SZ3")
		SZ3->(DbSkip())
	End
	
EndIf

oListSim:Refresh()

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
			oBitPro:lStretch:=.T. //Ajustar al tamaño del Dialog
			oBitPro:Refresh()
		Endif
		ACTIVATE DIALOG ODLGT CENTERED
	End
End
Return
         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Función que muestra los datos del Sigamat - Tabla SM0                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


