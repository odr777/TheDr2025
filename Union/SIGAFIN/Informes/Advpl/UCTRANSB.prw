#include "rwmake.ch"

/*
-- =========================================================================
-- Company    : 	GRUPO UNION COLUMBIA
-- System     : 	PROTHEUS
-- Author     :	Bladimir Escalera Zurita
-- Create date: 	18/05/2010
-- Description:	Comprobante de Transferencias Bancarias
--
--
-- Parameters :
--
--
-- Changes:
-- Date         Author                       Details
------------  ----------------------------  ----------------------------------
-- 18/05/2010  Bladimir Escalera Zurita
-- ===========================================================================
*/

User Function UCTRANSB(_hNumero)

	Local aAreaA := GetArea()
	Local cCidade := ""
	Local nLin    := 1
	Local cPerg:="UC0020"
	//RemPerg()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables utilizadas para parametros                         ³
	//³ mv_par01             // Del remito                           ³
	//³ mv_par02             // Hasta el remito                      ³
	//³ mv_par03             // Serie                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aDRIVER := READDRIVER()
	cString:="SF2"
	titulo :=PADC("Emision de Remitos de salida" ,74)
	cDesc1 :=PADC("Sera solicitado el Intervalo para la emision de los",74)
	cDesc2 :=PADC("remitos generadoas",74)
	cDesc3 :=""
	aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci¢n"), 1, 2, 1,"",1 }
	nomeprog:="UCTRANSB"
	nLin:=0
	wnrel:= "UCTRANSB"

	cDocDe:=""
	cDocA:=""

	CriaSX1(cPerg)
	PERGUNTE(cPerg,.F.)
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)

	If Empty(_hNumero)

		cDocDe	:=mv_par01
		cDocA	:=mv_par02

	Else
		cDocDe	:=_hNumero
		cDocA	:=_hNumero
	Endif

	If nLastKey!=27
		SetDefault(aReturn,cString)
		If nLastKey!=27
			//VerImp()
			RptStatus({|| RptRemito(cDocDe,cDocA)})
		endif
	endif
	// Restaura pergunta principal
	Pergunte("AFI100",.F.)

	RestArea(aAreaA)

Return

Static Function RptRemito(cDocDe, cDocA)

	//Local cCidade	:= space(10)
	Local nPag     := 1
	Local nPags    := 1
	Local nLinPag  := if(cFilAnt == '01',38,18)
	Local nLinPie  := If(cFilAnt == '01',43,23)
	Local cObs1    := ""
	Local cObs2    := ""
	Local aAmb     := GetArea()
	Local cad:=""
	Private nLin := 1
	Private nTotItem := 0
	Private nTotDesc := 0
	Private nValTot  := 0

	SE5->(dbSetOrder(1))
	SE5->(dbGoTop())

	//documento de origen
	cQuery := "SELECT * "
	cQuery += " FROM "+ RetSqlName("SE5") + " SE5 "
	cQuery += " WHERE E5_FILIAL = '"+xFilial("SE5")+"'"
	cQuery += " AND E5_NUMCHEQ BETWEEN '"+cDocDe+"' AND '" + cDocA + "'"
	cQuery += " AND SE5.D_E_L_E_T_ <> '*'"

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery	), "QRY", .F., .T. )
	TcSetField("QRY","E5_DTDIGIT","D",8,0)
	TcSetField("QRY","VALOR","N",14,2)
	QRY->(dbGoTop())

	//documento destino
	cQuery2 := "SELECT * "
	cQuery2 += " FROM "+ RetSqlName("SE5") + " SE5 "
	cQuery2 += " WHERE E5_FILIAL = '"+xFilial("SE5")+"'"
	cQuery2 += " AND E5_DOCUMEN BETWEEN '"+cDocDe+"' AND '" + cDocA + "'"
	cQuery2 += " AND SE5.D_E_L_E_T_ <> '*'"

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery2	), "QRY2", .F., .T. )
	TcSetField("QRY2","VALOR","N",14,2)
	QRY2->(dbGoTop())

	//////////////////////////////////////////////
	//imprime la cabecera
	//////////////////////////////////////////////
	cCidade := alltrim(SM0->M0_NOMECOM)

	@ nLin,000 PSAY chr(18)
	@ nLin,010 PSAY "T R A N S F E R E N C I A  B A N C A R I A  "
	@ nLin,060 PSAY "Fecha Imp:"+dtoc(DDATABASE)
	nLin++
	@ nLin,010 PSAY "============================================"
	nLin++
	@ nLin,000 PSAY cCidade+", "+dtoc(QRY->E5_DTDIGIT)
	nLin++
	@ nLin,000 PSAY "Documento: "+Alltrim(QRY->E5_NUMCHEQ) picture pesqpict("QRY","E5_NUMCHEQ")

	//////////////////////////////////////////////////////
	//imprime el cuerpo
	//////////////////////////////////////////////////////

	//datos del banco origen
	nLin++
	nLin++
	@ nLin,000 PSAY replicate("-",80)
	nLin++
	@ nLin,000 PSAY "BANCO ORIGEN"
	@ nLin,027 PSAY "CODIGO"
	@ nLin,035 PSAY "AGENCIA"
	@ nLin,045 PSAY "CUENTA"
	@ nLin,055 PSAY "MONEDA"
	@ nLin,065 PSAY "VALOR"
	nLin++
	@ nLin++,000 PSAY replicate("-",80)
	nLin++

	SA6->(dbSetOrder(1))
	SA6->(dbGoTop())
	SA6->(dbSeek(xFILIAL("SA6")+QRY->E5_BANCO+QRY->E5_AGENCIA+QRY->E5_CONTA))   //FILIAL+COD+AGENCIA+NUMCON

	@ nLin,000 PSAY ALLTRIM(SA6->A6_NOME)
	@ nLin,030 PSAY alltrim(QRY->E5_BANCO) picture pesqpict("SE5","E5_BANCO")
	@ nLin,035 PSAY QRY->E5_AGENCIA
	@ nLin,045 PSAY QRY->E5_CONTA
	@ nLin,058 PSAY SA6->A6_MOEDA
	@ nLin,065 PSAY QRY->E5_VALOR picture "@E 999,999,999.99"

	//datos del banco destino
	nLin++
	nLin++
	@ nLin,000 PSAY replicate("-",80)
	nLin++
	@ nLin,000 PSAY "BANCO DESTINO"
	@ nLin,027 PSAY "CODIGO"
	@ nLin,035 PSAY "AGENCIA"
	@ nLin,045 PSAY "CUENTA"
	@ nLin,055 PSAY "MONEDA"
	@ nLin,065 PSAY "VALOR"

	nLin++
	@ nLin++,000 PSAY replicate("-",80)
	nLin++

	SA6->(dbSetOrder(1))
	SA6->(dbGoTop())
	SA6->(dbSeek(xFILIAL("SA6")+QRY2->E5_BANCO+QRY2->E5_AGENCIA+QRY2->E5_CONTA))   //FILIAL+COD+AGENCIA+NUMCON

	@ nLin,000 PSAY ALLTRIM(SA6->A6_NOME)
	@ nLin,030 PSAY alltrim(QRY2->E5_BANCO) picture pesqpict("SE5","E5_BANCO")
	@ nLin,035 PSAY QRY2->E5_AGENCIA
	@ nLin,045 PSAY QRY2->E5_CONTA
	@ nLin,058 PSAY SA6->A6_MOEDA
	@ nLin,065 PSAY QRY2->E5_VALOR picture "@E 999,999,999.99"

	///////////////////////////////////////////////////////
	//imprime el pie
	///////////////////////////////////////////////////////

	nLin++
	nLin++
	nLin++
	nLin++
	nLin++
	@ nLin,000 PSAY "Historial: "+Alltrim(QRY->E5_HISTOR) picture pesqpict("QRY","E5_HISTOR")
	nLin++
	//nLin++
	@ nLin,000 PSAY "Beneficiario: "+Alltrim(QRY->E5_BENEF) picture pesqpict("QRY","E5_HISTOR")
	nLin++
	nLin++
	nLin++
	nLin++
	nLin++
	nLin++
	nLin++
	@ nLin,000 PSAY "_____________________"
	@ nLin,054 PSAY "_____________________"
	nLin++
	@ nLin,000 PSAY " Emitido por"
	@ nLin,054 PSAY " Retirado por"

	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	QRY2->(dbCloseArea())

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
±±³Fun‡…o    ³ RemPerg  ³ Autor ³ Jose Lucas            ³ Data ³ 22/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam...     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 				                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RemPerg()
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("REM010",6)
	aPergs:={}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Remito De                            ³
	//³ mv_par02             // Remito hasta                         ³
	//³ mv_par03             // Serie                                ³
	//³ mv_par04             // Texto livre                          ³
	//³ mv_par05             // Mensagem                             ³
	//³ mv_par06             // Copias                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Factura De                           ³
	//³ mv_par02             // Factura hasta                        ³
	//³ mv_par03             // Tipo                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aPergs,{"Factura De   ?","¨Factura De   ?","Factura De   ","mv_ch1","C",12,0,1,"G",,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Factura Hasta?","¨Factura Hasta?","Factura Hasta","mv_ch2","C",12,0,1,"G",,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Serie        ?","¨Serie        ?","Serie        ","mv_ch3","C",03,0,1,"G",,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	//AjustaSX1(cPerg,aPergs)
	dbSelectArea(_sAlias)
Return
Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De documento?"	, "¿De documento?"		,"¿De documento?"	,"MV_CH1","C",20,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A documento?" 	, "¿A documento?"		,"¿A documento?"	,"MV_CH2","C",20,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	//xPutSX1(cPerg,"03","¿Serie?" 		, "¿Serie?"			,"¿Serie?"		,"MV_CH3","C",03,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,""   ,"")
return
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)
	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.
	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	If !( DbSeek( cGrupo + cOrdem ))
		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
		Reclock( "SX1" , .T. )
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		Replace X1_VAR01   With cVar01
		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
		Replace X1_HELP With cHelp
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		MsUnlock()
	Else
		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif
	RestArea( aArea )
Return
Static Function FimItens(nLin,nLinPag)
	Local nK := 1
	While nLin<nLinPag
		@ nLin,020+nK PSAY "*"
		nk := iif( nk == 40 , 1 , nk+1 )
		nLin++
	EndDo
Return()