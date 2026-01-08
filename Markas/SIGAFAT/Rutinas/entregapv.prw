#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'PROTHEUS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ENTREGAPV ³ Autor ³ Walter Caetano  Silva ³ Data ³ 30/12/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Manutenção de Entrega de PVs                      ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EntregaPV()

Local aAmb      := GetArea()

_cOpcao   := PARAMIXB
nOpcx     := Iif( _cOpcao == "A", 3, 5 )
_cEntrega := SC5->C5_NUM

If _cOpcao != "V"
	//Set Key 115 TO U_Teste()   		//F4
	//Set Key 116 TO U_GetCodBarra()   	//F5
	Set Key 117 TO VisEst()   			//F6
EndIf

If AllTrim(SC5->C5_NOTA)=='REMITO' .and. _cOpcao == "A"

	Aviso("Inconsistencia","Ya fue generado REMITO para la venta."+CHR(13)+CHR(10)+"No es posible hacer el proceso de Modificacion de SERIALES.",{"Ok"})

	Set Key 115 TO
	Set Key 116 TO
	Set Key 117 TO
	
	Return()

ElseIf _cOpcao == "A"      //Inclusão
	
	// Averigua si hay itens en SC9 para asignacion, si no los crea, si no los crea es porque no hay itens disponibles o con control de serie
	If LibPVEnt() == 0
		Aviso("Inconsistencia","No hay itenes con stock disponible o con control de seriados."+CHR(13)+CHR(10)+;
		"No es posible hacer el proceso de Inclusion de SERIALES",{"Ok"})

		Set Key 115 TO
		Set Key 116 TO
		Set Key 117 TO
		
		Return()

	Endif
	
Endif

_cCliente:=SC5->C5_CLIENTE
_cLoja   :=SC5->C5_LOJACLI
_cNome   :=POSICIONE('SA1',1,XFILIAL('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_NOME')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aCposEnt:={}
AADD(_aCposEnt,'C9_ITEM')
AADD(_aCposEnt,'C9_SEQUEN')
AADD(_aCposEnt,'C9_PRODUTO')
AADD(_aCposEnt,'C9_LOTECTL')
AADD(_aCposEnt,'C9_QTDLIB')
AADD(_aCposEnt,'C9_LOCAL')
AADD(_aCposEnt,'C9_NUMSERI')
AADD(_aCposEnt,'C9_ULOCALI')

dbSelectArea("Sx3")
dbSetOrder(2)
nUsado:=0
aHeader:={}
For _nCont:=1 to Len(_aCposEnt)
	If dbSeek(_aCposEnt[_nCont])
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
			nUsado:=nUsado+1
			cNome := AllTrim(X3_CAMPO)
			bValid := {|| fVldaHeader()}
			AADD(aHeader,{ TRIM(x3_titulo), AllTrim(x3_campo), x3_picture,;
			x3_tamanho, x3_decimal, x3_vlduser+If(!Empty(x3_vlduser)," .and. ","")+"Eval(bValid)", x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	End
Next _nCont

_nPosItem  := aScan(aHeader,{|x| x[2]=="C9_ITEM"})
_nPosSeq   := aScan(aHeader,{|x| x[2]=="C9_SEQUEN"})
_nPosProd  := aScan(aHeader,{|x| x[2]=="C9_PRODUTO"})
_nPosLocal := aScan(aHeader,{|x| x[2]=="C9_ULOCALI"})
_nPosSerie := aScan(aHeader,{|x| x[2]=="C9_NUMSERI"})
_nPosPartnum := aScan(aHeader,{|x| x[2]=='C9_LOTECTL'})
_nPosLoc   := aScan(aHeader,{|x| x[2]=="C9_LOCAL"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(SC5->C5_NOTA)<>'REMITO'
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbGotop()
	dbSeek(xFilial("SC9")+SC5->C5_NUM)
	aCols := {}
	_cItem:='00'
	While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
		If Posicione('SB1',1,xFilial('SB1')+SC9->C9_PRODUTO,'B1_USERIE') == 'S'   //Produto con control de Numero Serial
			If Empty(SC9->C9_BLEST) .or. _cOpcao # "I"    //Há estoque disponível
				_cItem:=Soma1(_cItem)
				aAdd(aCols,{SC9->C9_ITEM,SC9->C9_SEQUEN,SC9->C9_PRODUTO,SC9->C9_LOTECTL,SC9->C9_QTDLIB,SC9->C9_LOCAL,SC9->C9_NUMSERI,SC9->C9_ULOCALI,.F.})
			eND
		End
		dbSelectArea("SC9")
		SC9->(dbSkip())
	End
Else
	dbSelectArea("SD2")
	dbSetOrder(8)
	dbGotop()
	dbSeek(xFilial("SD2")+SC5->C5_NUM)
	aCols := {}
	_cItem:='00'
	While SD2->(!EOF()) .And. SD2->D2_PEDIDO == SC5->C5_NUM
		_cItem:=Soma1(_cItem)
		If Posicione('SB1',1,xFilial('SB1')+SD2->D2_COD,'B1_USERIE') == 'S'   //Produto con control de Numero Serial
			aAdd(aCols,{SD2->D2_ITEM,SD2->D2_SEQUEN,SD2->D2_COD,SD2->D2_LOTECTL,SD2->D2_QUANT,SD2->D2_LOCAL,SD2->D2_NUMSERI,SD2->D2_LOCALIZ,.F.})
		End
		dbSelectArea("SD2")
		SD2->(dbSkip())
	End
	
End
	
If Len(Acols) == 0  .and. _cOpcao == "I"
	Aviso("Inconsistencia","No hay itenes con stock disponible o con control de seriados."+CHR(13)+CHR(10)+;
	"No es posible hacer el proceso de Inclusion de SERIALES",{"Ok"})
	Set Key 115 TO
	Set Key 116 TO
	Set Key 117 TO
	
	Return
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Entrega de Productos"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//bFunc := {|| fVldFam()}
AADD(aC,{"_cEntrega"   ,{15,010} ,"Entrega nro." ,"@!S6"        ,"!Empty(_cEntrega)",,})
AADD(aC,{"_cCliente"   ,{15,080} ,"Cliente     " ,"@!S6"        ,"!Empty(_cCliente)",,})
AADD(aC,{"_cLoja"      ,{15,150} ,"Tienda       " ,"@!S2"        ,"!Empty(_cLoja)",,})
AADD(aC,{"_cNome"      ,{30,010} ,"Nombre      " ,"@!S40"        ,"!Empty(_cNome)",,})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCGD:={64,5,118,315}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cLinhaOk:="Allwaystrue()"
cLinhaOk:="U_EntLinOk()"
cTudoOk :="Allwaystrue()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,4096)

If lRetMod2 // Gravacao. . .
	For _l := 1 To Len(aCols)
		If !aCols[_l,Len(aHeader)+1]  //.AND. !Empty(aCols[_l,_nPosLocal]) .AND. !Empty(aCols[_l,_nPosSerie])   //Item Válido
			If SC9->(DbSeek(xFilial('SC9')+SC5->C5_NUM+aCols[_l,_nPosItem]+aCols[_l,_nPosSeq]+aCols[_l,_nPosProd]))
				RecLock("SC9",.F.)    //Alteracao
				// SC9->C9_SEQUEN    := aCols[_l,_nPosSeq]
				SC9->C9_ULOCALI   := aCols[_l,_nPosLocal]
				SC9->C9_NUMSERI   := aCols[_l,_nPosSerie]
				SC9->C9_BLCRED    := SPACE(LEN(SC9->C9_BLCRED))
				SC9->C9_BLEST     := SPACE(LEN(SC9->C9_BLEST))
				SC9->(MsUnlock())
				
				_lSBF:=.F.
				SBF->(DbSetOrder(1))
				If SBF->(DbSeek(xFilial('SBF')+SC9->(C9_LOCAL+C9_ULOCALI+C9_PRODUTO+C9_NUMSERI)) )
					If SBF->BF_QUANT >= SC9->C9_QTDLIB //.AND. SBF->BF_EMPENHO == 0.00
						_lSBF:=.T.
						Reclock('SBF',.F.)
						SBF->BF_EMPENHO:=SC9->C9_QTDLIB
						SBF->(MsUnlock())
					Endif
				Endif
				SDB->(DbSetOrder(2))
				If SDB->(DbSeek(xFilial('SDB')+SC9->(C9_PRODUTO+C9_LOCAL+C9_LOTECTL+C9_NUMLOTE+C9_NUMSERI+C9_ULOCALI)) )
					If SDB->DB_QUANT >= SC9->C9_QTDLIB //.AND. SDB->DB_EMPENHO == 0.00
						Reclock('SDB',.F.)
						SDB->DB_EMPENHO:=SC9->C9_QTDLIB
						SDB->(MsUnlock())
					Endif
				Endif
				
			Endif
		Else
			If SC9->(DbSeek(xFilial('SC9')+SC5->C5_NUM+aCols[_l,_nPosItem]+aCols[_l,_nPosSeq]+aCols[_l,_nPosProd]))
				RecLock("SC9",.F.)    //Alteracao
				a460Estorna(.f.)
				SC9->(MsUnlock())
			Endif
		Endif
		
	Next _l
	
Endif

Set Key 115 TO
Set Key 116 TO
Set Key 117 TO

RestArea(aAmb)

Return


//--------------------------------------------------------------------------------------------------------------------------------
User Function EntLinOk()
Local _lRet:=.T.
Local _aArea      := GetArea()
If !GdDeleted(N)
	
	_nProcura := aScan(aCols,{|x| x[_nPosSerie]==BuscAcols("C9_NUMSERI")})
	
	If _nProcura != 0
		
		If aCols[n,3] == aCols[_nProcura,3]
			
			If aCols[n,Len(aHeader)+1] .or. aCols[_nProcura,Len(aHeader)+1]
				
				_lRet := .f.
				
				//	   _lRet:=(_nProcura == 0 .or. _nProcura == N .or. aCols[n,Len(aHeader)+1]==.T.)   ////Não encontrou o produto na familia atual ou encontrou apenas o digitado atualmente ou Item deletado
				
				//	   If _nProcura != 0 .and. _nProcura != n
				//	       _lRet := iif(_lRet .and. (aCols[n,3] == aCols[_nProcura,3]),.t.,.f.)
				//		   If !_lRet
				MsgBox ("El Numero Serial " + AllTrim(BuscAcols("C9_NUMSERI")) +  " ya esta cadastrado en esa entrega.","Atencion","ALERT")
			EndIf
		Endif
	Endif
	
	If Empty(BuscAcols("C9_NUMSERI"))
		// 	Else
		MsgBox ("El llenado del campo NUMERO SERIAL es obligatorio.","Atencion","ALERT")
		_lRet:=.F.
	EndIf
	
	If GetAdvFVal("SB1","B1_RASTRO",xFilial("SB1")+BuscAcols("C9_PRODUTO"),1,"") $ "L".AND.EMPTY(BuscAcols("C9_PRODUTO"))
		MsgBox ("El llenado del campo LOTE es obligatorio.","Atencion","ALERT")
		_lRet:=.F.
	END
	
	
	If Empty(BuscAcols("C9_ULOCALI"))
		MsgBox ("El llenado del campo UBICACION es obligatorio.","Atencion","ALERT")
		_lRet:=.F.
	EndIf
	
	If !Empty(BuscAcols("C9_NUMSERI")) .AND. !Empty(BuscAcols("C9_ULOCALI")) .AND. !Empty(BuscAcols("C9_LOTECTL"))
		dbSelectArea("SBF")
		dbSetOrder(1) //Z3_FILIAL+Z3_FAMILIA
		IF !dbSeek(xFilial("SBF")+BuscAcols("C9_LOCAL")+BuscAcols("C9_ULOCALI")+BuscAcols("C9_PRODUTO")+BuscAcols("C9_NUMSERI")+BuscAcols("C9_LOTECTL"))
			MsgBox ("Ubicación o Serie Invalida del Producto: " + BuscAcols("C9_PRODUTO") ,"Atencion","ALERT")
			_lRet:=.F.
		END
	END
End

RestArea(_aArea)
Return(_lRet)


//--------------------------------------------------------------------------------------------------------------------------------
Static Function fVldFam()

Local lRet := .t.

dbSelectArea("SZA")
dbSetOrder(1) //Z3_FILIAL+Z3_FAMILIA
dbSeek(xFilial("SZA")+_cFamilia)
If Found()
	Aviso("Inconsistência...","Familha de Productos Alternativos já existe.",{"Ok"})
	lRet := .f.
EndIf

Return(lRet)



//--------------------------------------------------------------------------------------------------------------------------------
Static Function fVldaHeader()

Local lRet := .t.
//Private nPos := aScan(aHeader,{|x| AllTrim(x[2])=="ZA_PRODUTO"})

return(.t.)
/*If Empty(nPos)
	Aviso("Inconsistencia","Campo ZA_PRODUTO não foi encontrado no aHeader.",{"Ok"})
	Return(.t.)
Endif
*/

/*If AllTrim(SX3->X3_CAMPO) == "ZA_PRODUTO"
	If aScan(aCols,{|x| x[nPos]==M->ZA_PRODUTO})<>0
		Aviso("Inconsistência","Produto já existe para esta familia.",{"Ok"})
		lRet := .f.
	Endif
	
	dbSelectArea("SZA")
	dbSetOrder(2) //ZA_FILIAL+ZA_PRODUTO
	dbSeek(xFilial("SZA")+M->ZA_PRODUTO)
	If Found()
		Aviso("Inconsistencia","Produto faz parte da familia "+SZA->ZA_FAMILIA+" - "+SZA->ZA_DESCR,{"Ok"})
		lRet := .f.
	Endif
Endif
*/
Return(lRet)



//--------------------------------------------------------------------------------------------------------------------------------
Static Function LibPvEnt()

Local _nCont
Local _nContLib := 1
Local lLibCompl := .t.

DbSelectArea('SC9')
SC9->(DbSetOrder(1))
SC9->(DbGoTop())

DbSelectArea('SC6')
SC6->(DbSetOrder(1))
SC6->(DbGoTop())

If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
	
	While SC6->(!EOF()) .and. SC6->C6_NUM == SC5->C5_NUM
		If Posicione('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_USERIE') == 'S' .and. SC6->C6_QTDEMP > 0.00   //Produto con control de Numero Serial
			//Borrando las aprobaciones atuales
			_nQtdLib:=SC6->C6_QTDEMP    //Salvando a Qtde Liberada para o item do PV
			
			If !SC9->(DbSeek(xFilial('SC9')+SC6->(C6_NUM+C6_ITEM)))
				_nContLib := 0
				_nQtdLib:=if(_nQtdLib==0.00,SC6->(C6_QTDVEN-C6_QTDENT),_nQtdLib)
				if _nQtdLib > SC6->C6_QTDVEN
					_nQtdLib:=SC6->(C6_QTDVEN-C6_QTDENT)
				Endif
			
				For _nCont := 1 to _nQtdLib
					_nContLib += MaLibDoFat(SC6->(RecNo()),1,.F.,.T.,.F.,.T.)
				Next _nCont
				
			Endif
			
//			lLibCompl := iif( _nQtdLib == _nContLib, .t., .f. )

		Endif
		
		DbSelectArea('SC6')
		SC6->(DbSkip())
		
	Enddo
	
	Reclock('SC5',.F.)
	SC5->C5_LIBEROK := 'S' // iif( lLibCompl, 'S', 'N' )
	SC5->(MsUnlock())
	
End

Return(_nContLib)


//--------------------------------------------------------------------------------------------------------------------------------
User Function Teste()
If !Pergunte("ENTPV2",.T.)
	Return
End

If Select('TRBSDB') > 0
	TRBSDB->(DbCloseArea())
End

_cProduto := GdFieldGet('C9_PRODUTO',N)

_cQuerySDB:="SELECT DB_NUMSERI,DB_LOCALIZ FROM " + RetSqlName('SDB') + " SDB "
_cQuerySDB+=" WHERE DB_PRODUTO = '" + GdFieldGet('C9_PRODUTO',N) + "' AND "
_cQuerySDB+=" DB_LOCALIZ = '" + mv_par01 + "' AND "
_cQuerySDB+=" DB_NUMSERI >= '" + mv_par02 + "' AND "
_cQuerySDB+=" DB_NUMSERI <= '" + mv_par03 + "' AND "
_cQuerySDB+=" DB_ESTORNO = ' ' AND "
_cQuerySDB+=" DB_NUMSERI <> ' ' AND "
_cQuerySDB+=" (DB_QUANT-DB_EMPENHO > 0) AND "
_cQuerySDB+=" D_E_L_E_T_ <> '*'
TCQUERY _cQuerySDB NEW ALIAS "TRBSDB"
Memowrite('ENTREGAPVSER.SQL',_cQuerySDB)

If TRBSDB->(!EOF()) .AND. TRBSDB->(!BOF())
	_nLin:=N
	While TRBSDB->(!EOF())
		If _nLin > Len(aCols) .OR. aCols[_nLin,_nPosProd] <> _cProduto
			Exit
		End
		
		ACOLS[_nLin,_nPosLocal]  :=TRBSDB->DB_LOCALIZ
		ACOLS[_nLin,_nPosSerie]  :=TRBSDB->DB_NUMSERI
		
		_nLin:=_nLin+1
		TRBSDB->(DbSkip())
	End
End

TRBSDB->(DbCloseArea())

Return


//--------------------------------------------------------------------------------------------------------------------------------
User Function GetCodBarra()
Local cCodigo1:=Space(Len(SBF->BF_NUMSERI))
Private oCod,oProduto,oDesc,oLocal,oUltSer
Private cProduto:=Space(len(SBF->BF_PRODUTO))
Private cLocal:=Space(Len(SBF->BF_LOCAL))
Private cDesc:=Space(Len(SB1->B1_DESC))
Private cUltSer:=Space(Len(SBF->BF_NUMSERI))


DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo) FROM  180,080 TO 450,550 PIXEL OF oMainWnd
@ 10,10 SAY 'Numero de Serie' SIZE 50,8 OF oDlg PIXEL
@ 10,60 MSGET oCod VAR cCodigo1 PICTURE "@!" VALID VldNumSerie(@cCodigo1,oCod)  SIZE 160,10 OF oDlg PIXEL
@ 25,10 TO 25,550
@ 40,10 SAY 'Ult Numero Serial' SIZE 50,8 OF oDlg PIXEL
@ 40,60 MSGET oUltSer VAR cUltSer PICTURE "@!" WHEN .F. SIZE 160,10 OF oDlg PIXEL
@ 55,10 SAY 'Producto' SIZE 50,8 OF oDlg PIXEL
@ 55,60 MSGET oProduto VAR cProduto PICTURE "@!" WHEN .F. SIZE 160,10 OF oDlg PIXEL
@ 70,10 SAY 'Descripcion' SIZE 50,8 OF oDlg PIXEL
@ 70,60 MSGET oDesc VAR cDesc PICTURE "@!" WHEN .F. SIZE 160,10 OF oDlg PIXEL
@ 85,10 SAY 'Almacen' SIZE 50,8 OF oDlg PIXEL
@ 85,60 MSGET oLocal VAR cLocal PICTURE "@!" WHEN .F. SIZE 160,10 OF oDlg PIXEL

DEFINE SBUTTON FROM 115, 172 TYPE 1 ACTION (nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 115, 200 TYPE 2 ACTION (nOpca:=3,oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

Return


//--------------------------------------------------------------------------------------------------------------------------------
Static Function VldNumSerie(cCodigo1,oCod)
Local _cLocaliz:=POSICIONE('SBF',3,XFILIAL('SBF')+cCodigo1,'BF_LOCALIZ')

//Obtem 1a Linha do Acols, para o Produto relacionado ao serial, que não está preenchida.
Local _nLin  := aScan(aCols,{|x| x[_nPosProd]==SBF->BF_PRODUTO .and. x[_nPosLoc]==SBF->BF_LOCAL .and. x[_nPosSerie] == Space(Len(SBF->BF_NUMSERI)) })

If _nLin > 0
	ACOLS[_nLin,_nPosSerie]:=cCodigo1
	ACOLS[_nLin,_nPosLocal]:=_cLocaliz
	cUltSer:=cCodigo1
	_oGet := CallMod2Obj()
	ObjectMethod(_oGet:oBrowse,"Refresh()")
	SetFocus(oCod:hWnd)
	cProduto:=SBF->BF_PRODUTO
	cDesc   :=Posicione('SB1',1,xFilial('SB1')+cProduto,'B1_DESC')
	cLocal  :=SBF->BF_LOCAL + ' - ' //+ Posicione('SZB',1,xFilial('SZB')+SBF->BF_LOCAL,'ZB_NOMALM')
	oProduto:Refresh()
	oDesc:Refresh()
	oLocal:Refresh()
	oUltSer:Refresh()
Else
	Aviso("Entrega Seriales","Todos los seriales del producto " + SBF->BF_PRODUTO + " ya fueran llenados.",{"Ok"})
End
cCodigo1:=Space(Len(SBF->BF_NUMSERI))
oCod:Refresh()

Return .t.


//--------------------------------------------------------------------------------------------------------------------------------
Static Function VisEst()
Local StrDatos:=""
If ValType("N") <> 'U'
	//U_MostraEst(GdFieldGet('C9_PRODUTO',N))
	StrDatos:=U_VisSalDir(GdFieldGet('C9_PRODUTO',N),GdFieldGet('C9_LOCAL',N),.F.)
	GdFieldPUT('C9_NUMSERI',PADR(StrToArray(StrDatos,'||')[1],TamSX3("C9_NUMSERI")[1]),N)
	GdFieldPUT('C9_ULOCALI',PADR(StrToArray(StrDatos,'||')[2],TamSX3("C9_ULOCALI")[1]),N)
	GdFieldPUT('C9_LOTECTL',PADR(StrToArray(StrDatos,'||')[3],TamSX3("C9_LOTECTL")[1]),N)
	aCols[n,7]:=PADR(StrToArray(StrDatos,'||')[1],TamSX3("C9_NUMSERI")[1])
	aCols[n,8]:=PADR(StrToArray(StrDatos,'||')[2],TamSX3("C9_ULOCALI")[1])
	aCols[n,4]:=PADR(StrToArray(StrDatos,'||')[3],TamSX3("C9_LOTECTL")[1])
	
End

Return
