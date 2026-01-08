#include "rwmake.ch"
/*
-- =========================================================================
-- Company    : GRUPO UNION COLUMBIA
-- System     : PROTHEUS
-- Author     : Bladimir Escalera Zurita
-- Create date: 26/10/2009
-- Description: Genera la impresion de una Factura de Entrada (Parte de Entrada)
-- Ajuste     : Erick Etcheverry      20200218
--
-- Parameters :
--
--
--
-- Changes:
-- Date         Author                       Details
------------  ----------------------------  ----------------------------------
-- 23/10/2009  Bladimir Escalera Zurita
-- ===========================================================================
*/

User Function remitpe(_hNumero, _hSerie, _hProv)

	Local aAreaA := GetArea()

	cPerg:="UC0005"
	//cPerg:="UC0016"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables utilizadas para parametros                         ³
	//³ mv_par01             // Del remito                           ³
	//³ mv_par02             // Hasta el remito                      ³
	//³ mv_par03             // Serie                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aDRIVER := READDRIVER()
	cString:="SF1"
	titulo :=PADC("Emision de Notas de Parte de Entrada" ,74)
	cDesc1 :=PADC("Sera solicitado el Intervalo para la emision de los",74)
	cDesc2 :=PADC("remitos generadoas",74)
	cDesc3 :=""
	aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci¢n"), 1, 2, 1,"",1 }
	nomeprog:="REMITPE"
	nLin:=0
	wnrel:= "REMITPE"

	cFatFin:=""
	cFatIni:=""
	cSer:=""

	ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO
	GraContPert()
	PERGUNTE(cPerg,.F.)

	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)

	If Empty(_hNumero)
		cFatIni:=mv_par01
		cFatFin:=mv_par02
		cSer:=mv_par03
		cProv:=ALLTRIM(mv_par04)
	Else
		cFatIni:=_hNumero
		cFatFin:=_hNumero
		cSer:= _hSerie
		cProv:= ALLTRIM(_hProv)
	Endif

	If nLastKey!=27
		SetDefault(aReturn,cString)
		If nLastKey!=27
			RptStatus({|| RptRemito()})
		endif
	endif

	RestArea(aAreaA)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPTREMITO ºAutor  ³Claudio Manoel      ºFecha ³  17/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao del remito de ventas                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Union Columbia - Bolivia                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RptRemito()
	Local nPag     := 1
	Local nPags    := 1
	Local nLinPag  := 43
	Local nLinPie  := 50
	Local cObs1    := ""
	Local cObs2    := ""
	Local aAmb     := GetArea()

	Private nLin := 1

	SB1->(dbSetOrder(1))		// B1_FILIAL+B1_COD
	SB1->(dbGoTop())

	SD1->(dbSetOrder(1))		// D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
	SD1->(dbGoTop())

	SF1->(dbSetOrder(1))		// F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	SF2->(dbGoTop())

	cQuery := "SELECT * FROM "+RetSqlName("SF1")+" WHERE D_E_L_E_T_ = '' AND F1_FILIAL = '"+xFilial("SF1")+"' AND F1_DOC BETWEEN '"+cFatIni+"' AND '"+cFatFin+"' AND F1_SERIE = '"+cSer+"' "

	If cProv!=""
		cQuery := cQuery +" AND F1_FORNECE = '"+cProv+"'"
	End if

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery	), "QRY", .F., .T. )
	TcSetField("QRY","F1_EMISSAO","D",8,0)
	QRY->(dbGoTop())

	SetRegua(Val(cFatFin)-Val(cFatIni)+1)

	nPag := 1

	while QRY->(!eof())

		cQryD2 := " SELECT COUNT(*) AS NREGS "
		cQryD2 += " FROM "+RetSqlName("SD1") "
		cQryD2 += " WHERE D_E_L_E_T_ = '' "
		cQryD2 += "       AND D1_FILIAL  = '" + xFilial("SF1")  + "' "
		cQryD2 += "       AND D1_DOC     = '" + QRY->F1_DOC     + "' "
		cQryD2 += "       AND D1_SERIE   = '" + QRY->F1_SERIE   + "' "
		cQryD2 += "       AND D1_FORNECE = '" + QRY->F1_FORNECE + "' "
		cQryD2 += "       AND D1_LOJA    = '" + QRY->F1_LOJA    + "' "

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQryD2	), "QRYD2", .F., .T. )
		QRYD2->(dbGoTop())

		nPags    := iif((int((QRYD2->NREGS/nLinPag))*nLinPag)==QRYD2->NREGS,(QRYD2->NREGS/nLinPag),int(QRYD2->NREGS/nLinPag)+1)
		QRYD2->(dbCloseArea())

		SD1->(dbSeek(xFILIAL("SD1")+QRY->F1_DOC+QRY->F1_SERIE+QRY->F1_FORNECE+QRY->F1_LOJA))
		SA2->(dbSeek(xFILIAL("SA2")+QRY->F1_FORNECE+QRY->F1_LOJA))
		nLin := Cabec(nPag,nPags)

		while SD1->D1_DOC==QRY->F1_DOC .and. SD1->D1_SERIE==QRY->F1_SERIE .and. SD1->D1_FORNECE==QRY->F1_FORNECE .and. SD1->D1_LOJA==QRY->F1_LOJA .and. !eof()

			// ubicar el fabricante del producto que será impreso
			SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			@ nLin,000 PSAY PADL(SUBSTR(SD1->D1_ITEM,-1,2),2,"0") picture pesqpict("SD1","D1_ITEM")
			@ nLin,003 PSAY alltrim(SD1->D1_COD) picture pesqpict("SD1","D1_COD")
			@ nLin,010 PSAY alltrim(SB1->B1_UCODFAB)
			@ nLin,020 PSAY alltrim(SB1->B1_DESC)
			@ nLin,048 PSAY SD1->D1_QUANT picture "@E 999,999.99"
			@ nLin,058 PSAY SD1->D1_VUNIT picture "@E 99,999.9999"
			@ nLin,068 PSAY round(SD1->D1_TOTAL,2) picture "@E 99,999,999.99"

			SD1->(dbSkip())
			nLin++

			If nLin == nLinPie
				nPag++
				Pie(nLinPie)
				nLin := Cabec(nPag,nPags)
			Endif

		Enddo

		If nLin != nLinPie
			Pie(nLinPie)
		Endif

		nPag := 1

		QRY->(dbSkip())

	Enddo
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
	QRY->(dbCloseArea())
	RestArea(aAmb)
Return
Static Function VerImp()
	nLin:= 0
	If aReturn[5]==2
		nOpc:= 1
		While .T.
			Eject
			dbCommitAll()
			SETPRC(0,0)
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Intenta Nuevamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
			Do Case
				Case nOpc==1
				lContinua:=.T.
				Exit
				Case nOpc==2
				Loop
				Case nOpc==3
				lContinua:=.F.
				Return
			EndCase
		End
	Endif
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RemPerg  ³ Autor ³ Jose Carlos           ³ Data ³ 22/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabecera del la factura                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 				                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Cabec(nPag,nPags)
	Local nLin    := 1
	Local cCidade := ""
	// ciudad a imprimir en el formulario

	cCidade	:= SM0->M0_NOMECOM

	@ nLin,000 PSAY chr(18)
	@ nLin,023 PSAY "F A C T U R A  D E  E N T R A D A"
	@ nLin,072 PSAY "PAG:"+strzero(nPag,2,0)+"/"+strzero(nPags,2,0)
	nLin++
	@ nLin,023 PSAY "=================================="
	nLin++
	@ nLin,000 PSAY ALLTRIM(cCidade)+", "+dtoc(QRY->F1_EMISSAO)+" "+Alltrim(QRY->F1_HORA)
	@ nLin,055 PSAY "Nro Doc: "+AllTrim(QRY->F1_DOC)+"-"+Alltrim(QRY->F1_SERIE) picture pesqpict("QRY","F1_DOC")
	nLin++
	@ nLin,000 PSAY "Cod Prov.: "+SA2->A2_COD+"  Tienda: "+SA2->A2_LOJA
	@ nLin,055 PSAY "Sucursal: "+xFilial("SF1")
	//@ nLin,052 PSAY "Nro Nota: "+SD1->D1_SERIORI+SD1->D1_NFORI
	nLin++
	@ nLin,000 PSAY "Proveedor: "+alltrim(SA2->A2_NREDUZ)
	@ nLin,055 PSAY "Deposito: "+SD1->D1_LOCAL
	//@ nLin,052 PSAY "Sucursal: "+xFilial("SF1")
	nLin++
	@ nLin,000 PSAY "Direccion: "+alltrim(SA2->A2_END)
	//@ nLin,052 PSAY "Deposito: "+SD1->D1_LOCAL
	nLin++
	@ nLin,000 PSAY "Telefono: "+SA1->A1_TEL
	@ nLin,055 PSAY ""
	nLin++
	@ nLin,000 PSAY replicate("-",86)
	nLin++
	@ nLin,000 PSAY "#"
	@ nLin,003 PSAY "CODIGO"
	@ nLin,010 PSAY "FAB"
	@ nLin,020 PSAY "D E S C R I P C I O N"
	@ nLin,052 PSAY "CANT."
	@ nLin,062 PSAY "P/UNIT"
	@ nLin,072 PSAY "T O T A L"
	nLin++
	@ 010,000 PSAY replicate("-",86)
	nLin++
Return(nLin)
Static Function Pie(nLinPie)
	Local nLin := nLinPie
	Local vMoneda:=""
	Local cObs1    := ""
	Local cObs2    := ""
	@ nLin,000 PSAY replicate("-",86)
	nLin++

	cObs1 := iif(len(alltrim(QRY->F1_XOBS))>51,substr(alltrim(QRY->F1_XOBS),1,51),alltrim(QRY->F1_XOBS))
	cObs2 := iif(len(alltrim(QRY->F1_XOBS))>51,substr(alltrim(QRY->F1_XOBS),52),"")
	@ nLin,000 PSAY "Obs.:"+cObs1
	@ nLin,057 PSAY "Subtotal : "+transform(round(QRY->F1_VALMERC,2),"@E 99,999,999.99")
	nLin++
	If !empty(cObs2)
		@ nLin,000 PSAY cObs2
	Endif
	@ nLin,057 PSAY "Descuento: "+transform(round(QRY->F1_DESCONT,2),"@E 99,999,999.99")
	nLin++

	cExtenso1 := iif(len(extenso(QRY->F1_VALBRUT))>52,substr(extenso(QRY->F1_VALBRUT),1,52),extenso(QRY->F1_VALBRUT))
	cExtenso2 := iif(len(extenso(QRY->F1_VALBRUT))>52,substr(extenso(QRY->F1_VALBRUT),53),"")
	IF QRY->F1_MOEDA==1
		vMoneda:=" BOLIVIANOS"
	ELSE
		vMoneda:=" DOLARES"
	ENDIF
	If empty(cExtenso2)
		@ nLin,000 PSAY "Son:"+alltrim(cExtenso1)+vMoneda
	else
		@ nLin,000 PSAY "Son:"+alltrim(cExtenso1)
	endif
	@ nLin,057 PSAY "Total:     "+transform(QRY->F1_VALBRUT,"@E 99,999,999.99")
	nLin++
	If !empty(cExtenso2)
		@ nLin,000 PSAY cExtenso2+vMoneda
	Endif

	nLin+=3
	@ nLin,000 PSAY "_____________________"
	@ nLin,027 PSAY "_____________________"
	@ nLin,054 PSAY "_____________________"
	nLin++
	@ nLin,000 PSAY "   Recibi conforme"
	@ nLin,027 PSAY "   Autorizado por"
	@ nLin,054 PSAY "    Emitido por"
	nLin++
	@ nLin,000 PSAY "   NOMBRE Y FIRMA-->"
	@ nLin,027 PSAY "   NOMBRE Y FIRMA-->"
	@ nLin,054 PSAY "   NOMBRE Y FIRMA-->"
	nLin++
	IncRegua()
Return()
Static Function FimItens(nLin,nLinPag)
	Local nK := 1
	While nLin<nLinPag
		@ nLin,020+nK PSAY "*"
		nk := iif( nk == 40 , 1 , nk+1 )
		nLin++
	EndDo
Return()

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{"01","¿De Documento?","mv_ch1","C",18,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"02","¿A Documento?","mv_ch2","C",18,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"",""})
	aAdd(aRegs,{"03","¿De Serie?","mv_ch3","C",03,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,""})
	aAdd(aRegs,{"04","¿De Proveedor?","mv_ch4","C",06,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,""})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		dbSeek(cPerg+aRegs[i][1])
		If !Found()
			RecLock("SX1",!Found())
			SX1->X1_GRUPO    := cPerg
			SX1->X1_ORDEM    := aRegs[i][01]
			SX1->X1_PERSPA   := aRegs[i][02]
			SX1->X1_VARIAVL  := aRegs[i][03]
			SX1->X1_TIPO     := aRegs[i][04]
			SX1->X1_TAMANHO  := aRegs[i][05]
			SX1->X1_DECIMAL  := aRegs[i][06]
			SX1->X1_PRESEL   := aRegs[i][07]
			SX1->X1_GSC      := aRegs[i][08]
			SX1->X1_VAR01    := aRegs[i][09]
			SX1->X1_DEFSPA1    := aRegs[i][10]
			SX1->X1_DEFSPA2    := aRegs[i][11]
			SX1->X1_DEFSPA3    := aRegs[i][12]
			SX1->X1_DEFSPA4    := aRegs[i][13]
			SX1->X1_F3       := aRegs[i][14]
			SX1->X1_VALID    := aRegs[i][15]
			MsUnlock()
		Endif
	Next

	Return

Return
Static Function GraContPert()
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FILORIG,SF2->F2_FILDEST)       //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FILIAL,SF2->F2_FILIAL)          //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',dtoc(SF1->F1_EMISSAO),dtoc(SF2->F2_EMISSAO))        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',dtoc(SF1->F1_EMISSAO),dtoc(SF2->F2_EMISSAO))        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_DOC,SF2->F2_DOC)      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_DOC,SF2->F2_DOC)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_SERIE,SF2->F2_SERIE)      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"08"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_SERIE,SF2->F2_SERIE)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"09"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FORNECE,SF2->F2_CLIENTE)      //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"10"))
		Reclock("SX1",.F.)
		SX1->X1_CNT01 := if(_cTipoOp=='E',SF1->F1_FORNECE,SF2->F2_CLIENTE)        //Variable publica con sucursal en uso
		SX1->(MsUnlock())
	End
Return