#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR777  ³ Autor ³ Flavio Luiz Vicco     ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pick-List (Expedicao)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR777(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PickList()
	Local wnrel   := "MATR777"
	Local tamanho := "M"
	Local titulo  := ANSITOOEM("Pick-Lista") //"Pick-List  (Expedicao)"
	Local cDesc1  := ANSITOOEM("Emision de Productos") //"Emiss„o de produtos a serem separados pela expedicao, para"
	Local cDesc2  := ANSITOOEM("") //"determinada faixa de pedidos."
	Local cDesc3  := ""
	Local cString := "SC6"
	Local cPerg   := "MTR777"

	PRIVATE aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 } //"Zebrado"###"Administracao"
	PRIVATE nomeprog := "MATR777"
	PRIVATE nLastKey := 0
	PRIVATE nBegin   := 0
	PRIVATE aLinha   := {}
	//PRIVATE li       := 80
	PRIVATE limite   := 132
	PRIVATE lRodape  := .F.
	PRIVATE m_pag    :=1
	Private nTipo    := 15
	private valorBonificacion := 0.0
	private nDescPor := 0.0
	private cBonusTes  := SuperGetMv("MV_BONUSTS")
	private nValfat
	private nDescont
	private nBasimpl
	private nUtaten
	Private cNum     := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AjustaSX1(cPerg)
	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                      ³
	//³ mv_par01  De Pedido                                       ³
	//³ mv_par02  Ate Pedido                                      ³
	//³ mv_par03  Imprime pedidos ? 1 - Estoque                   ³
	//³                             2 - Credito                   ³
	//³                             3 - Estoque/Credito           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//---------------------------
	cTime := TIME() // Resultado: 10:37:17
	cHora := SUBSTR(cTime, 1, 2) // Resultado: 10
	cMinutos := SUBSTR(cTime,  4, 2) // Resultado: 37
	cSegundos := SUBSTR(cTime, 7, 2) // Resultado: 17

	wnrel := cHora + cMinutos + cSegundos // Cambiando el nombre del Informe a guardar
	//---------------------------
	wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,.F.,.T.,Tamanho,,.F.)
	//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
	If nLastKey == 27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		dbClearFilter()
		Return
	Endif

	RptStatus({|lEnd| C777Imp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)
	//RptStatus({|lEnd|C777Imp(Titulo,cString,nomeprog,Tamanho,nTipo,Limite)},Titulo)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C777IMP  ³ Autor ³ Flavio Luiz Vicco     ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C777Imp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)
	Local cabec1	 := "Nro. Pedido: " + SC5->C5_NUM + "  Cliente: " + SC5->C5_CLIENTE+'-'+SC5->C5_LOJACLI + " - " +POSICIONE('SA1',1,XFILIAL('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_NOME') + "Despacho: " + Iif(SC5->C5_DOCGER == '1'," Interno",Iif(SC5->C5_DOCGER == '2',"Externo",""))+" Emisión PV:" + DTOC(SC5->C5_EMISSAO)
	Local cabec2 	 := OemToAnsi("Codigo          Descripcion Producto                     UM  Ctd Vendida      Precio       Monto      Alm   Ubicacion       Lote ") //"Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Validade   Potencia    Pedido"
	Local lFirst 	 := .T.
	Local cbtxt      := SPACE(10)
	Local cbcont	 := 0
	Local lQuery     := .F.
	Local cEndereco  := ""
	Local nQtde      := 0
	Local cAliasNew  := "SC6"
	Local _nDescuento := 0
	Local _cCodKit := GETNEWPAR("MV_CODKIT",'KIT')
	#IFDEF TOP
	Local aStruSC9   := {}
	Local cName      := ""
	Local cQryAd     := ""
	Local nX         := 0
	#ELSE
	Local cFilter    := ""
	Local cKey 	     := ""
	  	 

	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//li := 80
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao dos cabecalhos                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	titulo := ANSITOOEM("PICK-LIST") //"PICK-LIST"
	IF SELECT('SC6') > 0           //Verifica se o alias OC esta aberto
		SC6->(DbCloseArea())       //Fecha o alias OC
	END
	#IFDEF TOP
	//	cAliasNew:= GetNextAlias()
	//aStruSC9 := SC6->(dbStruct())
	lQuery := .T.

	//	cQuery := "SELECT SC6.R_E_C_N_O_,C6_NUM,C6_QTDVEN,"
	//	cQuery += "C6_FILIAL,C6_QTDVEN,C6_QTDEMP, C6_PRODUTO, C6_LOCAL, "
	//	cQuery += "C6_LOTECTL, C6_POTENCI,C6_PRCVEN,C6_VALOR,"
	//	cQuery += "C6_NUMLOTE, C6_DTVALID, C6_LOCALIZ, C6_DESCRI,C6_DESCONT,C6_VALDESC,C6_TES,C6_BLQ , B1_UFABRIC"
	//	cQuery += cQryAd
	//	cQuery += " FROM "
	//	cQuery += RetSqlName("SC6") + " SC6 ," + RetSqlName("SB1")
	//	//	cQuery += "RIGHT JOIN "+RetSqlName("SDC") + " SDC "
	//	//	cQuery += "ON SDC.DC_PEDIDO=SC9.C9_PEDIDO AND SDC.DC_ITEM=SC9.C9_ITEM AND SDC.DC_SEQ=SC9.C9_SEQUEN AND SDC.D_E_L_E_T_ = ' '"
	//	cQuery += " WHERE C6_FILIAL  = '"+xFilial("SC6")+"'"
	//	cQuery += " AND  C6_NUM >= '"+mv_par01+"'"
	//	cQuery += " AND  C6_NUM <= '"+mv_par02+"'"
	//	cQuery += " AND B1_COD = C6_PRODUTO "
	//	cQuery += " AND SC6.D_E_L_E_T_ = ' '"
	//	cQuery += " ORDER BY C6_FILIAL,C6_NUM,C6_ITEM,C6_LOJA,C6_PRODUTO,C6_LOTECTL,"
	//	cQuery += " C6_NUMLOTE,C6_DTVALID"
	//

	cQuery := " SELECT SD2.R_E_C_N_O_, D2_PEDIDO, D2_QUANT, D2_FILIAL, "
	cQuery += " D2_COD, D2_LOCAL, "
	cQuery += " D2_LOTECTL, D2_POTENCI,D2_PRCVEN,D2_PRUNIT,D2_TOTAL,D2_NUMLOTE, D2_DTVALID, D2_LOCALIZ, D2_UDESC, "
	cQuery += " D2_DESCON, "
	cQuery += " ROUND(F2_DESCONT, 2) F2_DESCONT, F2_VALFAT, F2_BASIMP1 , F2_UCTATEN , "
	cQuery += " D2_TES, B1_UFABRIC, C6_BLQ "
	cQuery += " FROM " + RetSqlName("SF2")
	cQuery += " LEFT JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery += " ON (D2_FILIAL = F2_FILIAL "
	cQuery += " AND D2_DOC = F2_DOC "
	cQuery += " AND D2_SERIE = F2_SERIE "
	cQuery += " AND D2_LOJA = F2_LOJA "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ') "
	cQuery += " JOIN "+ RetSqlName("SB1")
	cQuery += " ON D2_FILIAL  = '"+xFilial("SC6")+"' "
	cQuery += " AND  D2_PEDIDO >= '"+mv_par01+"' "
	cQuery += " AND  D2_PEDIDO <= '"+mv_par02+"' "
	cQuery += " AND B1_COD = D2_COD "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN "+ RetSqlName("SC6") +" SC6 "
	cQuery += " ON (C6_FILIAL = D2_FILIAL "
	cQuery += " AND D2_PEDIDO = C6_NUM "
	cQuery += " AND D2_ITEMPV = C6_ITEM) "
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY D2_FILIAL,D2_PEDIDO,D2_ITEM,D2_LOJA,D2_COD,D2_LOTECTL, D2_NUMLOTE,D2_DTVALID "

	//	Aviso("",cQuery,{'ok'},,,,,.t.)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cString,.T.,.T.)
	#ELSE

	dbSelectArea(cString)
	cIndexSC9 := CriaTrab(nil,.F.)
	cKey :="D2_FILIAL+D2_PEDIDO++C6_ITEM+D2_COD"
	cFilter := "D2_PEDIDO  = '" + xFilial("SC6") + "' .And. "
	cFilter += "D2_PEDIDO >= '"+mv_par01+"' .And. "
	cFilter += "D2_PEDIDO <= '"+mv_par02+"'"
	//	If mv_par03 == 1 .Or. mv_par03 == 3
	//		cFilter += " .And. C9_BLEST  = '  '"
	//EndIf
	//If mv_par03 == 2 .Or. mv_par03 == 3
	//		cFilter += " .And. C9_BLCRED = '  '"
	//	EndIf
	IndRegua(cString,cIndexSC9,cKey,,cFilter,STR0008) //"Selecionando Registros..."
	dbSetIndex(cIndexSC9+OrdBagExt())

	#ENDIF
	_nContIt:=15
	_nPag:=0
	_nTotal:=0
	SetRegua(RecCount())
	(cString)->(dbGoTop())
	avalimp(132)
	//Setprc(0,0)
	SET DEVICE TO PRINT
	li:=PROW()
	While (cString)->(!Eof())
		If lEnd
			@PROW()+1,001 Psay "Cancelado por el Operador" //"CANCELADO PELO OPERADOR"
			Exit
		EndIf
		If !lQuery
			IncRegua()
		EndIf
		/*
		If li > 55 .or. lFirst
		lFirst  := .F.
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		lRodape := .T.
		EndIf
		*/
		If _nContIt > 5
			_nPag++
			If _nPag > 1
				//	   ALERT(li)
				//if _nPag > 2
				li+=3
				//else
				//  li:=26
				//End
				//				@(li),015 PSAY "		    ------------------------------         " + " --------------------  " + "       ------------------------"
				//				li+=1
				//				@li,008 PSAY "                      Recibido Por:   " + "                    Firma       "  + "           Documento Identidad"

				@(li),015 PSAY "		    ------------------------------                   " + "                        ----------------------------"
				li+=1
				@li,008 PSAY "           RECIBIDO CONFORME:                              "  + "                         ENTREGADO POR:             "
				li+=1
				@li,008 PSAY "           NOMBRE:.......................                  "  + "                         NOMBRE:...................."
				
				li+=1
				@li,000 PSAY REPLICATE('_',limite)
				li+=1
				//	_nTotal:= _nTotal - _nDescuento
				//_cUser := Embaralha(SC5->C5_USERLGI,1)
				_cUsuarioA := Substr(CUsuario,7,15)//If (!Empty(_cUser),Subs(_cUser,1,15),"")
				@(li), 000 PSAY "Impreso Por: " + Upper(SC5->C5_USRREG)
				@ li, 67 PSAY "SUB-TOTAL POR HOJA: " + TRANSFORM(round(_nTotal,2),"@E 99,999,999.99")
				//	@ li, 87 PSAY _nTotal PICTURE "@E 99,999,999.99"

				/* @ li,00 PSAY REPLICATE('-',limite)
				li+=2
				@ li, 000 PSAY PadC("****** CONTINUA EN LA SIGUIENTE PAGINA *******", 132)
				li+=3*/
				@ li, 115 PSAY 'Pag.:' + ALLTRIM(STR(_nPag-1,2))

				li+=1
				@li, 000 PSAY " "
				li+=1
				@li, 000 PSAY " "
				li+=1
				@li, 000 PSAY " "

			End

			li:=CABHP()
			_nContIt := 0
		Endif

		If EMPTY((cAliasNew)->C6_BLQ)

			cUnit := (cAliasNew)->(D2_PRUNIT)
			cCant := (cAliasNew)->(D2_QUANT)
			cValor := round( (cUnit * cCant ), 2)
			nDescont := (cAliasNew)->F2_DESCONT
			nValfat := (cAliasNew)->F2_VALFAT
			nBasimpl := (cAliasNew)->F2_BASIMP1
			nUtaten := (cAliasNew)->F2_UCTATEN

			if( (cAliasNew)->D2_TES == cBonusTes)
				valorBonificacion  +=  cValor
				nDescPor += (cAliasNew)->D2_DESCON
			endif

			@ li, 00  Psay cNum  Picture "@!"// unidad de medida
			SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->D2_COD))
			@ li, 03 Psay alltrim((cAliasNew)->D2_COD)	Picture "@!"
			cProducto   := SB1->B1_DESC //DESCRIPCION DEL PRODUCTO
			cNum += 1 
			/* If !Empty(cProducto)
			nLinha := MlCount(cProducto,40)
			cLinha:=  Memoline(cProducto,40,1)
			@ li,016 PSAY cLinha  Picture "@!"
			End */

			@ li, 13  Psay SB1->B1_UM  Picture "@!"  // unidadd de medida

			//If nLinha == 2
			@ li, 18 PSAY  alltrim(cProducto) Picture "@!"
			//			li+=1
			//End
			//	@ li, 16 Psay Subs((cAliasNew)->D2_UDESC,1,40)	Picture "@!"
			//@ li, 16 Psay Subs(SB1->B1_DESC,1,40)	Picture "@!"

			@ li, 25  Psay (cAliasNew)->(B1_UFABRIC) Picture "@!"   // FABRICANTE

			@ li, 40  Psay (cAliasNew)->(D2_QUANT)	 Picture "@E 9,999,999.99"   // CANTIDAD

			@ li, 50  Psay (cAliasNew)->(D2_PRUNIT)  Picture "@E 9,999,999.9999"   // PRECIO UNITARIO

			@ li, 60 Psay     cValor       Picture "@E 9,999,999.99"  // TOTAL
			//			@ li,05  Psay (cAliasNew)->D2_LOCAL  // almacen

			@ li,70  Psay (cAliasNew)->D2_LOTECTL	Picture "@!"   // LOTE

			@ li,80  Psay STOD((cAliasNew)->D2_DTVALID)   	//Picture PesqPict("SC6","D2_DTVALID")  validez

			@ li,90  Psay TRIM(D2_LOCALIZ)   // Ubicacion

			//	_nDescuento += IF((cAliasNew)->D2_DESCON > 0 , (cAliasNew)->(D2_PRCVEN) * (cAliasNew)->D2_DESCON / 100,0)
			//			_nDescuento += IF((cAliasNew)->C6_VALDESC > 0 , (cAliasNew)->C6_VALDESC , 0 )
			//     ALERT(	TRANSFORM(_nDescuento,"@E 999,999.9999"))
			If  Upper(SubStr((cAliasNew)->D2_COD,1,Len(_cCodKit))) == Upper(_cCodKit)
				If Select("KIT") > 0
					KIT->(DbCloseArea())
				End

				_cKitQuery:= "Select *  FROM  " + RetSqlName("SBH") + " where BH_PRODUTO = '"  + (cAliasNew)->D2_COD + "' AND D_E_L_E_T_<>'*'"
				TCQUERY _cKitQuery NEW ALIAS "KIT"
				WHILE KIT->(!EOF())
					SB1->(dbSeek(xFilial("SB1")+KIT->BH_CODCOMP))
					li+=1
					@ li, 00 Psay alltrim(KIT->BH_CODCOMP)	Picture "@!"
					@ li,010 PSAY SB1->B1_DESC  Picture "@!"
					li+=1
					@ li, 16  Psay SB1->B1_UM   				Picture "@!"
					@ li, 20  Psay KIT->BH_QUANT 	Picture "@E 9,999,999.99"
					//	    li+=1
					_nContIt++
					If _nContIt > 5
						_nPag++
						If _nPag > 1
							li+=3
							//							@(li),010 PSAY "		------------------------------     " + "--------------------  " + "      ------------------------"
							//							li+=1
							//							@li,008 PSAY "                Recibido Por:     " + "                 Firma       "  + "          Documento Identidad"

							@(li),015 PSAY "		    ------------------------------                   " + "                        ----------------------------"
							li+=1
							@li,008 PSAY "           RECIBIDO CONFORME:                              "  + "                         ENTREGADO POR:             "
							li+=1
							@li,008 PSAY "           NOMBRE:.......................                  "  + "                         NOMBRE:...................."

							li+=1
							@li,000 PSAY REPLICATE('_',limite)
							li+=1
							_cUsuarioA := Substr(CUsuario,7,15)//If (!Empty(_cUser),Subs(_cUser,1,15),"")
							@(li), 000 PSAY "Impreso Por: " + Upper(_cUsuarioA)
							@ li, 67 PSAY "SUB-TOTAL POR HOJA: " + TRANSFORM(round(_nTotal,2),"@E 99,999,999.99")
							@ li, 115 PSAY 'Pag.:' + ALLTRIM(STR(_nPag-1,2))
							li+=1
							@li, 000 PSAY " "
							li+=1
							@li, 000 PSAY " "
							li+=1
							@li, 000 PSAY " "

						End

						li:=CABHP()
						_nContIt := 0
					Endif

					KIT->(DBSKIP())
				End
			End
			li+=1
			_nContIt++
			IF POSICIONE('SF4',1,XFILIAL('SF4')+(cAliasNew)->D2_TES,'F4_ESTOQUE')== 'S' .AND. POSICIONE('SF4',1,XFILIAL('SF4')+(cAliasNew)->D2_TES,'F4_DUPLIC')== 'N' .AND. POSICIONE('SF4',1,XFILIAL('SF4')+(cAliasNew)->D2_TES,'F4_GERALF')== '2'
				//		      ALERT('ENTREE')
			ELSE
				_nTotal += cValor
				//	alert(transform(_nTotal,"@E 999,999.99"))
			END
		EndIf

		//_nTotal += (cAliasNew)->D2_TOTAL
		_cUsuario:= Substr(CUsuario,7,15)
		#IFNDEF TOP
		//	SDC->(dbSkip())
		//EndDo
		#ENDIF
		(cString)->(dbSkip())
	EndDo

	li-=1
	If _nPag > 0
		li++
		@ li, 00 PSAY REPLICATE('-',limite)
		li++
		//@ li, 78 PSAY "TOTAL: "
		//@ li, 87 PSAY _nTotal PICTURE "@E 99,999,999.99"
		//	_nTotal := _nTotal - _nDescuento

		nSubtotal  := nValfat
		nDescuento := nDescont + valorBonificacion
		nDescuento := nDescuento - nDescPor
		nTotGral   := Round(nSubtotal+nDescuento,2)

		@ li,000 PSAY "Recargo: " + LTRIM(TRANSFORM(SC5->(C5_DESPESA+C5_SEGURO+C5_FRETE),"@E 99,999,999.99"))
		@ li,072 PSAY "Subtotal: " + LTRIM(TRANSFORM(nTotGral,"@E 99,999,999.99"))
		li++
		@ li,072 PSAY "Descuentos: " + LTRIM(TRANSFORM( nDescuento ,"@E 99,999,999.99"))
		//		@ li,072 PSAY "Dctos Txn.: (" + ALLTRIM(TRANSFORM( SC5->C5_PDESCAB,"@E 99,999,999.99"))+ " %) " + LTRIM(TRANSFORM(((_nTotal-SC5->C5_DESCONT) * SC5->C5_PDESCAB / 100)+ SC5->C5_DESCONT ,"@E 99,999,999.99"))

		_nTotal := _nTotal - IF(SC5->C5_PDESCAB > 0 ,(_nTotal-SC5->C5_DESCONT)  * SC5->C5_PDESCAB / 100 ,0)
		_nTotal := _nTotal - IF(SC5->C5_DESCONT > 0 ,SC5->C5_DESCONT,0)
		_nTotal := _nTotal + SC5->(C5_DESPESA+C5_SEGURO+C5_FRETE)
		li++
		@ li, 72 PSAY "Total a pagar: " + LTRIM(TRANSFORM(nBasimpl,"@E 99,999,999.99"))
		li++
		@li,008 PSAY "Son: " + Extenso(NOROUND(nBasimpl,2)) + IIf(SC5->C5_MOEDA == 1, " Bolivianos ", " Dolares")
		//       ALERT(li)
		IF(li > 26)
			li+=2
		Else
			li:=26
		End
		//		@(li),015 PSAY "		    ------------------------------         " + " --------------------  " + "       ------------------------"
		//		li+=1
		//		@li,008 PSAY "                     Recibido Por:   " + "                     Firma       "  + "            Documento Identidad"

		@(li),015 PSAY "		    ------------------------------                   " + "                        ----------------------------"
		li+=1
		@li,008 PSAY "           RECIBIDO CONFORME:                              "  + "                         ENTREGADO POR:             "
		li+=1
		@li,008 PSAY "           NOMBRE:.......................                  "  + "                         NOMBRE:...................."

		li+=1
		// ALERT(_nPag)
		IF li < 29
			li+=(29 - li-1)

		else
			IF _nPag > 1
				If _nContIt <=5
					if ((_nPag * 29) - li+(_nPag * 2))  > 9
						li+= 9
					else
						li+= ((_nPag * 29) - li+(_nPag * 2))
					eND
				else
					li+= 1
				End

			ELSE

				li+=1
			END
		End
		@li,000 PSAY REPLICATE('_',limite)
		li+=1
		@li, 000 PSAY "Impreso Por: " + Upper(_cUsuario)

		_cUser := Embaralha(SC5->C5_USERLGI,1)
		_cUsuarioA := If (!Empty(_cUser),Subs(_cUser,1,15),"")

		@li, 050 PSAY "Elaborado por: "+SC5->C5_USRREG
		@ li, 115 PSAY 'Pag.:' + ALLTRIM(STR(_nPag,2))
		li+=1
		@li, 000 PSAY " "
		li+=1
		@li, 000 PSAY " "
		li+=1
		@li, 000 PSAY ""

		SETPRC(0,0)
		//	@(li), 050 PSAY "Entregado Por: "
		//	li+=1

		//@ If(li < 31,31,62), 115 PSAY 'Pag.:' + Str(_nPag,2)
	End

	/*If lRodape
	roda(cbcont,cbtxt,"M")
	EndIf
	*/
	SC6->(DbCloseArea())

	SET DEVICE TO SCREEN
	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
	SetpgEject(.F.)
	MS_FLUSH()

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³Autor  ³ Flavio Luiz Vicco     ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)
	Local aHelpPor01 := {"Informe o numero do pedido inicial a ser ",    "considerado na selecao."}
	Local aHelpEng01 := {"Enter the initial order number to be taken in","consideration."}
	Local aHelpSpa01 := {"Digite el numero del pedido inicial que debe ","considerarse en la seleccion."}
	Local aHelpPor02 := {"Informe o numero do pedido final a ser ",    "considerado na selecao."}
	Local aHelpEng02 := {"Enter the final order number to be taken in","consideration."}
	Local aHelpSpa02 := {"Digite el numero del pedido final que debe ","considerarse en la seleccion."}
	Local aHelpPor03 := {"Seleciona a condicao do pedido de compras a",    "ser impressa."}
	Local aHelpEng03 := {"Select the purchase order terms to print.",      ""}
	Local aHelpSpa03 := {"Elija la condicion del pedido de compras que se","debe imprimir."}
	PutSX1(cPerg,"01","De pedido ?",       "¿De pedido ?",       "From order ?","mv_ch1","C",6,0,0,"G","","","","","mv_par01","","","","",      "","","","","","","","","","","","",aHelpPor01,aHelpEng01,aHelpSpa01)
	PutSX1(cPerg,"02","Ate pedido ?",      "¿A pedido ?",        "To order ?",  "mv_ch2","C",6,0,0,"G","","","","","mv_par02","","","","zzzzzz","","","","","","","","","","","","",aHelpPor02,aHelpEng02,aHelpSpa02)
	//PutSX1(cPerg,"03","Pedidos liberados?","¿Pedidos Aprobados?","orders ?",    "mv_ch3","N",1,0,3,"C","","","","","mv_par03","Estoque","Stock","Inventory","","Credito","Credito","Credit","Credito/Estoque","Credito/Stock","Credit/Invent.","","","","","","",aHelpPor03,aHelpEng03,aHelpSpa03)
	//if(FUNNAME()== 'MATA410')
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := SC5->C5_NUM
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := SC5->C5_NUM
		SX1->(MsUnlock())
	End
	//End
Return

Static Function CabHP()
	//SetPrc(0,0)

	//	@ li,00 PSAY CHR(27)+'x'+'0'
	@ li,00 PSAY CHR(15)+Chr(27)+Chr(71)+'UNION AGRONEGOCIOS'
	@ li+1,000 PSAY PADC(" NOTA DE ENTREGA ",108)
	@ li+1,108 PSAY OemToAnsi('Fecha de impresión: ')+dtoc(DATE())
	@ li+2,108 PSAY OemToAnsi('Hora de impresión: ') + Time()
	Titulo := "Pedido.    " + AllTrim(SC5->C5_NUM) + " " +  IIf(SC5->C5_MOEDA == 1, "(en Bolivianos)", "(en Dolar)")
	Titulo += "        Tipo Cliente: " + RTRIM(IIF(SC5->C5_TIPOCLI $ '1|2|3','GRAN CONT.',IIF(SC5->C5_TIPOCLI=='6','EXENTO','')))
	//Controla Cores da Legenda do Browse de Pedido de Venda
	//cEstado:= U_PVCorBrow()
	//cEstado:=TABELA("ZS",cEstado)

	//Titulo += "     Estado:" + cEstado
	@ li+3,000 PSAY RTRIM(titulo)
	@ li+3,108 PSAY "Sucursal: " + RTRIM(SM0->M0_FILIAL)  //+ Tabela("ZA",C5->C5_LOCAL) + Space(10) + 'Tipo de Movimiento: ' + Posicione('SF5',1,xFilial('SF5')+SD3->D3_TM,'F5_TEXTO')
	//If lCanje
	@ li+4,00 PSAY "Cliente:   " + SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI + " " + ANSITOOEM(RTRIM(Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")))
	//else
	//   @ 005,00 PSAY "Proveedor.: " + SD3->D3TM + " " + Posicione("SF5",1,SD3->D3_TM,"F5_TEXTO")
	//Endif
	@ li+4,108 PSAY "TC:" + TRANSFORM(POSICIONE("SM2",1,SC5->C5_EMISSAO,"M2_MOEDA2"),"@E 999.99")
	@ li+5,000 PSAY OemToAnsi("Dirección: "  + Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_END"))
	@ li+5,108 PSAY OemToAnsi("Fecha de Emisión:") + DTOC(SC5->C5_EMISSAO)
	//------------------------------
	cDirAlmacen :=""
	nCliente 	:= 0
	ntienda	 	:= 0
	nCliente :=SC5->C5_CLIENTE
	nTienda	:= SC5->C5_LOJACLI
	nTipoEntrega := alltrim(SC5->C5_ULUGENT)
	//	cDirAlmacen :=POSICIONE("SA1",1,xFilial("SA1")+nCliente+nTienda,"A1_ENDENT")

	//	@ li+6, 000 PSAY "Dir. Entrega: "+alltrim(SC5->C5_UENDENT)
	//------------------------------
	if(empty(nTipoEntrega))
		nTipoEntrega := "         "
	endif
//	@ li+6,000 PSAY "Tipo Entrega: " + nTipoEntrega
	auxTel := alltrim(POSICIONE('SA1',1,XFILIAL('SE4')+SC5->C5_CLIENTE,"A1_TEL"))
	if(empty(auxTel))
		auxTel := "00"		
	end if
	@ li+6,000 PSAY "Tipo Entrega: " + nTipoEntrega + "    Fecha de Entrega: " + dtoc(SC5->C5_FECENT)+ " Telf.: " + auxTel
	@ li+6,108 PSAY "Factura: " + alltrim(SC5->C5_SERIE) + "/" + quitZero(alltrim(SC5->C5_NOTA))
	@ li+7,000 PSAY "Vendedor:  "+ANSITOOEM(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_COD")) +" "+ ANSITOOEM(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_NOME"))
	//	@ li+7,108 PSAY "Despacho: " + Iif(SC5->C5_DOCGER == '1'," Interno",Iif(SC5->C5_DOCGER == '2',"Externo","Entrega Futura"))
	@ li+7,108 PSAY "Tipo Vendedor:  " + Iif(SC5->C5_DOCGER == '1'," Ciudad",Iif(SC5->C5_DOCGER == '2',"Provincia","Entrega Futura"))
	@ li+8,000 PSAY "Reg. Por:  " + SC5->C5_USRREG

	cTRemito := ""
	If SC5->C5_TIPOREM == "0"
		cTRemito := "Ventas"
	Else
		If SC5->C5_TIPOREM == "A"
			cTRemito := "Consignación"
		else
			If SC5->C5_TIPOREM == "R"
				cTRemito := "Reparacion en Gtia"
			EndIf
		EndIf
	EndIf
	@ li+08,108 PSAY "Tipo Remito:  " + OemToAnsi(cTRemito)

	_cUsuarioA := Substr(CUsuario,7,15)
	@ li+9,000 PSAY "Impreso Por:  " + Upper(_cUsuarioA)

	//cClient := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENT+SC5->C5_LOJACLI,"A1_NOME")
	//@ li+8,000 PSAY "Cli.Entrega:  " + ANSITOOEM(cClient)
	@ li+09,108 PSAY "Cond. De Pago:  " + POSICIONE('SE4',1,XFILIAL('SE4')+SC5->C5_CONDPAGO,'E4_DESCRI')
	@ li+10,000 PSAY "Observación:  " + alltrim(SC5->C5_UOBSERV)
	@ li+10,108 PSAY "Fecha Vencto:  " + dtoc(POSICIONE("SE1",1,xFilial("SE1")+SC5->C5_SERIE+SC5->C5_NOTA,"E1_VENCTO"))
	@ li+11,108 PSAY "Bodega:  " + SC5->C5_ULOCAL + " " + POSICIONE('NNR',1,xFilial('NNR')+SC5->C5_ULOCAL,'NNR_DESCRI')
	@ li+12,108 PSAY "Tipo Atención:  " + Alltrim(nUtaten)
	//	alert(xFilial('NNR'))
	//	@ li+11,108 PSAY "Deposito: " + POSICIONE('NNR',1,xFilial('NNR')+SC5->C5_ULOCAL,'NNR_DESCRI')
	//Tipo Remito = DOCGER
	//Cli.Entrega = C5_CLIENT

	li:=li+14

	//Obtendo o campo de Observações
	//	cVar   := SD3->D3_OBS
	//	If !Empty(cVar)
	//		@ li+9,00 PSAY 'Obs.:'
	//		nLinha := MlCount(cVar,120)
	//		For i:=1 to nLinha
	//			cLinha:=  Memoline(cVar,120,i,,.T.)
	//			@ li,010 PSAY cLinha
	//			li+=1
	//		Next i
	//	End

	//@ li,00 PSAY Replicate("-",limite)
	//li+=1
	//if lCanje
	// @ nLin,00 PSAY "CODIGO LOTE       VENCTO   PRODUCTO                                         CANTIDAD "
	//             999999 9999999999 9999999999999999999999999999999999999999999999999 99 9,999,999.9999
	//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	//                      10        20        30        40        50        60        70        80
	//Else
	@ li,00 PSAY "#  Codigo    UM    Descripción                            Fab        Cant        P/Unit       Total       Lote       Validez      "+OemToAnsi("Ubicación")+""
	//   @ li,00 PSAY "Codigo          " + ANSITOOEM("Descripción Producto")+"                      UM  Ctd Vendida        Precio    Monto       Alm   "+ANSITOOEM("Ubicación")+"    Lote   Validez"
	//             999999 9999999999 9999999999999999999999999999999999999999999999999 99 9,999,999.9999 9,999,999.99 9,999,999.99
	//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                      10        20        30        40        50        60        70        80        90        100       110       120
	//Endif
	li:=li+1
	@ li,00 PSAY REPLICATE('-',limite)
	li:=li+1
Return(li)

static Function quitZero(cTexto)		
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

	While lContinua

		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
		EndIf

		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)

Return cRetorno

