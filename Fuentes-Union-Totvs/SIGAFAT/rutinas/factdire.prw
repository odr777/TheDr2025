#INCLUDE "RWMAKE.CH"
#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "CRMDEF.CH"
#INCLUDE "APWIZARD.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA410PvNfs³ Autor ³ Eduardo Riera         ³ Data ³25.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Funcao de calculo preparação do doocumento de saída.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do Pedido de Venda                              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta funcao efetua a preparação do documento de saída, para o³±±
±±³          ³pedido de venda posicionado.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function factdire(cAlias,nReg,nOpc)
	Local aArea		:= GetArea()
	Local aAreaSF2	:= {}
	Local aPvlNfs		:= {}
	Local aRegistros	:= {}
	Local aTexto		:= {}
	Local aBloqueio	:= {{"","","","","","","",""}}
	Local aNotas		:= {}
	Local lQuery		:= .F.
	Local cAliasSC9	:= "SC9"
	Local cAliasSC6	:= "SC6"
	Local nPrcVen		:= 0
	Local nQtdLib		:= 0
	Local nItemNf		:= 0
	Local nX			:= 0
	Local cSerie		:= ""
	Local lOk			:= .F.
	Local oWizard		:= NIL
	Local oListBox	:= NIL
	Local lContinua	:= .T.
	Local lCond9		:= GetNewPar("MV_DATAINF",.F.)	//Caso existam diferentes códigos de serviço no Pedido de Vendas, deverá ser gerada uma nota fiscal para cada código.
	Local cFunName	:= FunName()
	Local lTxMoeda	:= .F.
	#IFDEF TOP
	Local cQuery	:= ""
	#ENDIF

	Local dDataMoe	:= dDataBase
	Local lConfirma	:= .T.
	Local lDataFin	:= .F.
	Local lNfeQueb	:= GetNewPar("MV_NFEQUEB",.F.) .And. cPaisLoc == "BRA"
	Local lBlqISS	:= .T.
	Local bCondExec	:= {||}
	Local nY		:= 0
	Local lReajuste	:= .F.
	Local aTotsNF	:= {}
	Local lUsaNewKey:= TamSX3("F2_SERIE")[1] == 14 // Verifica se o novo formato de gravacao do Id nos campos _SERIE esta em uso
	Local cSerieId	:= IIf( lUsaNewKey , SerieNfId("SF2",4,"F2_SERIE",dDataBase,A460Especie(cSerie),cSerie) , cSerie )
	Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
	Local lM410ALDT	:= ExistBlock("M410ALDT")
	Local lM461DINF	:= ExistBlock("M461DINF")
	Local lAGRUBS	:= SuperGetMV("MV_AGRUBS",.F.,.F.)
	Local cTrcNum	:= ""
	Local lTrcNum	:= IIf(lAGRUBS,SC5->(ColumnPos("C5_TRCNUM"))>0,.F.)	//Campo da Agroindustria
	Local lAgrMoeda	:= .F.
	Local aAgrArea	:= {}
	Local cOldArea	:= ""
	Local cFilSF2	:= xFilial("SF2")

	// Se lMudouNum for .T. significa que o usuario alterou o numero da nota em MV_TPNRNFS == "3"
	// e o sistema deve respeitar o novo numero contido em cNumero
	Private lMudouNum		:= .F.
	Private cNumero		:= ""

	Private cIdPV			:= ""
	Private cPV410		:= ""

	// variaveis criadas para chamada da funcao A460AcumIt() no fonte MATA460 - calcular o total da nota e bloquear se total inferior ao valor minimo a faturar (parametro 12 do pergunte MT460A)
	Private nAcresFin		:= SC5->C5_ACRSFIN
	Private cMVARREFAT	:= SuperGetMv("MV_ARREFAT")
	Private aTamSX3		:= TamSX3("F2_VALBRUT")
	Private nBaseFIcm		:= 0
	Private nBaseFIpi		:= 0
	Private nBaseISS		:= 0
	Private nBaseIRF		:= 0
	Private nBItemInss	:= 0
	Private nBaseInss		:= 0
	Private nDecimal		:= TamSx3("F2_VALBRUT")[2]
	private cCondiPago := SC5->C5_CONDPAG// nahim factura directa
//	private lMSAuto := .T. // nahim factura directa

	lCond9   := IIf(ValType(lCond9)<>"L",.F.,lCond9)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna o SetFunName que iniciou a rotina                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetFunName("MATA461")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da Interface                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aTexto,{})
	aTexto[1] := STR0278+CRLF //"Esta rotina tem como objetivo ajuda-lo na preparação do documento "
	aTexto[1] += STR0279+SC5->C5_NUM+STR0280+CRLF+CRLF //"de saída do pedido de venda número: "###"."
	aTexto[1] += STR0281 //"O próximo passo será verificar o status de liberação do pedido de venda."
	aadd(aTexto,"")
	aTexto[2] := PadC(STR0282+SC5->C5_NUM,160)+CRLF+CRLF //"Pedido de Venda: "
	aTexto[2] += STR0283 //"O assistente identificou que o pedido de venda encontra-se liberado e irá utilizar "
	aTexto[2] += STR0284+CRLF+CRLF //"os itens aptos a faturar para preparar o documento de saída."
	aTexto[2] += STR0285  //"Caso o pedido não esteja totalmente liberado, os itens não liberados serão desprezados."
	aadd(aTexto,"")
	aTexto[3] := PadC(STR0282+SC5->C5_NUM,160)+CRLF+CRLF //"Pedido de Venda: "
	aTexto[3] += STR0286 //"O assistente identificou que o pedido de venda não possui itens liberados e irá realizar "
	aTexto[3] += STR0287  //"a liberação de todos os itens do pedido de venda, conforme os parâmetros do sistema."
	aadd(aTexto,"")
	aTexto[4] := PadC(STR0282+SC5->C5_NUM,160)+CRLF+CRLF //"Pedido de Venda: "
	aTexto[4] += STR0288 //"O assistente identificou que o pedido de venda esta liberado (totalmente ou parcialmente) e irá utilizar "
	aTexto[4] += STR0289  //"os itens liberados para preparar o documento de saída."
	aadd(aTexto,"")
	aTexto[5] := PadC(STR0282+SC5->C5_NUM,160)+CRLF+CRLF //"Pedido de Venda: "
	aTexto[5] += STR0290 //"O assistente concluiu com sucesso todos os passos para preparação do documento "
	aTexto[5] += STR0291 +CRLF+CRLF //"de saída. "
	aTexto[5] += STR0292 //"O documento de saída será gerado após a confirmação da série do documento de saída."
	aadd(aTexto,"")
	aTexto[6] := PadC(STR0282+SC5->C5_NUM,160)+CRLF+CRLF //"Pedido de Venda: "
	aTexto[6] += STR0290 //"O assistente concluiu com sucesso todos os passos para preparação do documento "
	aTexto[6] += STR0291 +CRLF+CRLF //"de saída. "
	aTexto[6] += STR0293 //"O documento de saída não será gerado neste momento, pois não há itens aptos a faturar. "

	If lNfeQueb
		aadd(aTexto,"")
		aTexto[7] := PadC(STR0282+SC5->C5_NUM,160)+CRLF+CRLF //"Pedido de Venda: "
		aTexto[7] += STR0306 +CRLF+CRLF //"O documento de saída não poderá será gerado por esta rotina, pois este pedido de vendas possui itens com códigos de serviço diferentes."
		aTexto[7] += STR0307 +CRLF+CRLF	//"De acordo com configuração do parâmetro MV_NFEQUEB, será gerado uma nota fiscal para cada código de serviço, portanto utilize a rotina de preparação de Documento de Saída para faturar este pedido."
		aTexto[7] += STR0308			//"Esta rotina está localizada em Atualizações-> Faturamento-> Documento de Saída (MATA460A) e irá fazer o tratamento de quebra dos itens gerando as notas fiscais."
	EndIf

	If ( ExistBlock("M410PVNF") )
		lContinua := ExecBlock("M410PVNF",.f.,.f.,nReg)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o usuario tem premissao para gerar   o ³
	//³documento de saida                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc <> "BRA" .AND. FieldPos("C5_CATPV") > 0 .AND. !Empty(SC5->C5_CATPV)
		If AliasIndic("AGS") //Tabela que relaciona usuario com os Tipos de Pedidos de vendas que ele tem acesso
			DBSelectArea("AGS")
			DBSetOrder(1)
			If DBSeek(xFilial("AGS") + __cUserId) //Se não encontrar o usuário na tabela, permite ele alterar o pedido
				If !DBSeek(xFilial("AGS") + __cUserId + SC5->C5_CATPV) //Verifica se o usuario tem premissao
					MsgStop(STR0300 + " " + STR0301 + " " + STR0302)//"Este usuario nao tem permissao para gerar documentos de saida para pedidos de venda com esse tipo."
					lContinua := .F.
				EndIf
			EndIf
		EndIf
	EndIf

	If lIntACD
		(cAliasSC9)->(Dbsetorder(1))
		If (cAliasSC9)->(dbSeek(xFilial(cAliasSC9)+SC5->C5_NUM))
			If !Empty ((cAliasSC9)->C9_ORDSEP)
				CB7->(DBsetorder(1))
				If CB7->(DbSeek(xFilial("CB7")+SC9->C9_ORDSEP))
					If !(!'*03' $ CB7->CB7_TIPEXP .AND. CB7->CB7_STATUS >= "4" .AND. !"*09" $ CB7->CB7_TIPEXP)
						MsgAlert('Pedido '+SC5->C5_NUM+' com ordem de separação '+SC9->C9_ORDSEP+' não concluida')
						lContinua:=.F.
					EndIf
				EndiF
			EndIf
		Endif
	Endif

	If lContinua .AND. Substr(cAcesso,51,1) != "S"
		cOldArea	:= Alias()
		aAreaSF2	:= SF2->(GetArea())
		SF2->(DbSetOrder(3))	//F2_FILIAL+F2_ECF+DTOS(F2_EMISSAO)+F2_PDV+F2_SERIE+F2_MAPA+F2_DOC
		SF2->(MsSeek(cFilSF2+Space(Len(SF2->F2_ECF))+"z",.T.))
		SF2->(DbSkip(-1))
		If ( dDataBase < SF2->F2_EMISSAO )
			Help(" ",1,"DATNF")
			lContinua := .F.
		EndIf
		If lContinua
			SF2->(MsSeek(cFilSF2+"S"+"z",.T.))
			SF2->(DbSkip(-1))
			If ( dDataBase < SF2->F2_EMISSAO )
				Help(" ",1,"DATNF")
				lContinua := .F.
			EndIf
		EndIf
		RestArea(aAreaSF2)
		DbSelectArea(cOldArea)
	EndIf

	If lContinua

		If !lNfeQueb
				bCondExec := {|| Ma410LbNfs(1,@aPvlNfs,@aBloqueio),oWizard:SetPanel(IIf(!Empty(aPvlNfs) .Or. !Empty(aBloqueio),1,2))}
		Else
			//Verifica se existem itens com códigos de serviço diferentes quando o parâmetro MV_NFEQUEB estiver ativo.
			lBlqISS := A410BloqIss(SC5->C5_NUM)

			If !lBlqISS
				bCondExec := {|| oWizard:SetPanel(7)}
			Else
				bCondExec := {|| Ma410LbNfs(1,@aPvlNfs,@aBloqueio),oWizard:SetPanel(IIf(!Empty(aPvlNfs) .Or. !Empty(aBloqueio),1,2))}
			EndIF
		EndIf
		
		Ma410LbNfs(1,@aPvlNfs,@aBloqueio) // Nahim
		Ma410LbNfs(2,@aPvlNfs,@aBloqueio) // Nahim
		lOk := .T. // Nahim
		
//		DEFINE WIZARD oWizard ;
//		TITLE STR0294; //"Assistente para preparação do documento de saída"
//		HEADER STR0295; //"Atenção"
//		MESSAGE STR0296; //"Siga atentamente os passos para prepração do documento de saída."
//		TEXT aTexto[1] ;
//		NEXT {|| Eval(bCondExec),.T.} ;
//		FINISH {||.T.}
//
//		CREATE PANEL oWizard  ;
//		HEADER STR0297; //"Liberação de pedido de venda"
//		MESSAGE ""	;
//		BACK {|| aPvlNfs:={},aBloqueio:={},oWizard:SetPanel(2),.T.} ;
//		NEXT {|| oWizard:SetPanel(3),.T.} ;
//		PANEL
//		@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[2]
//
//		CREATE PANEL oWizard  ;
//		HEADER STR0297; //"Liberação de pedido de venda"
//		MESSAGE ""	;
//		BACK {|| aPvlNfs:={},aBloqueio:={},oWizard:SetPanel(2),.T.} ;
//		NEXT {|| Ma410LbNfs(2,@aPvlNfs,@aBloqueio),Ma410LbNfs(1,@aPvlNfs,@aBloqueio)} ;
//		FINISH {|| .T.} ;
//		PANEL
//		@ 010,010 GET aTexto[3] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[3]
//
//		CREATE PANEL oWizard  ;
//		HEADER STR0297; //"Liberação de pedido de venda"
//		MESSAGE ""	;
//		BACK {|| aPvlNfs:={},aBloqueio:={},oWizard:SetPanel(2),.T.} ;
//		NEXT {|| oWizard:SetPanel(IIf(!Empty(aBloqueio),4,IIf(Empty(aPvlNfs),5,6))),(IIf(!Empty(aBloqueio),(oListBox:SetArray(aBloqueio),oListBox:bLine := { || aBloqueio[oListBox:nAT]}),.T.)),.T.} ;
//		FINISH {|| .T.} ;
//		PANEL
//		@ 010,010 GET aTexto[4] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[4]
//
//		CREATE PANEL oWizard  ;
//		HEADER STR0297; //"Liberação de pedido de venda"
//		MESSAGE STR0298	; //"Os itens abaixo encontram-se bloqueados, caso continue os mesmos serão desprezados."
//		BACK {|| aPvlNfs:={},aBloqueio:={},oWizard:SetPanel(2),.T.} ;
//		NEXT {|| oWizard:SetPanel(IIf(Empty(aPvlNfs),5,6)),.T.} ;
//		FINISH {|| .T.} ;
//		PANEL
//		oListBox := TWBrowse():New(004,003,285,130,,{RetTitle("C9_PEDIDO"),RetTitle("C9_ITEM"),RetTitle("C9_SEQUEN"),RetTitle("C9_PRODUTO"),RetTitle("C9_QTDLIB"),RetTitle("C9_BLCRED"),RetTitle("C9_BLEST"),RetTitle("C9_BLWMS")},,oWizard:oMPanel[5],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
//		oListBox:SetArray(aBloqueio)
//		oListBox:bLine := { || aBloqueio[oListBox:nAT]}
//
//		CREATE PANEL oWizard  ;
//		HEADER STR0299; //"Preparação do documento de saída."
//		MESSAGE "";
//		BACK {|| aPvlNfs:={},aBloqueio:={},oWizard:SetPanel(2),.T.} ;
//		NEXT {|| .f.} ;
//		FINISH {|| lOk := .F.} ;
//		PANEL
//		@ 010,010 GET aTexto[6] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[6]
//
//		CREATE PANEL oWizard  ;
//		HEADER STR0299; //"Preparação do documento de saída."
//		MESSAGE "";
//		BACK {|| aPvlNfs:={},aBloqueio:={},oWizard:SetPanel(2),.T.} ;
//		FINISH {|| lOk := .T.} ;
//		PANEL
//		@ 010,010 GET aTexto[5] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[7]
//
//		If lNfeQueb .And. !lBlqISS
//			CREATE PANEL oWizard  ;
//			HEADER STR0299; //"Preparação do documento de saída."
//			MESSAGE STR0295;
//			BACK {|| lBlqISS:=.T.,oWizard:SetPanel(2),.T.} ;
//			FINISH {|| .T.} ;
//			PANEL
//			@ 010,010 GET aTexto[7] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[8]
//		EndIf
//
//		ACTIVATE WIZARD oWizard CENTERED

		If !Empty(aPvlNfs) .And. lOk
			If cPaisLoc<>"BRA"
				aReg:={}
				For nX:=1 To Len(aPvlNfs)
					Aadd(aReg,aPvlNfs[nX][8])
				Next
				If SC5->C5_DOCGER=="2"		//gerar remision
					ProcRegua(Len(aReg))
					Pergunte("MT462A",.F.)
					aParams:={MV_PAR09,MV_PAR10,MV_PAR11,MV_PAR12,01,SC5->C5_MOEDA}
					cMarca:=GetMark(,'SC9','C9_OK')
					cMarcaSC9:=cMarca
					For nX:=1 To Len(aReg)
						IncProc()
						SC9->(DbGoTo(aReg[nX]))
						RecLock("SC9",.F.)
						Replace SC9->C9_OK With cMarca
						SC9->(MsUnLock())
					Next
					If cPaisLoc == "ARG"
						If !Pergunte("PVXARG",.T.)
							Return .F.
						Endif
						cLocxNFPV := MV_PAR01
						lLocxAuto  := .F.
						cIdPVArg := POSICIONE("CFH",1, xFilial("CFH")+cLocxNFPV,"CFH_IDPV")
						If !F083ExtSFP(MV_PAR01, .T.)
							Return .F.
						EndIf
					EndIf
					SetInvert(.F.)
					A462ANGera(Nil,cMarca,.T.,aReg,.F.,aParams)
				Else						//gerar fatura
//					IF Pergunte("MTA410FAT",.F.)
						// 2,1,; // Harcode #Facturar por Moneda Seleccionada #Seleccionamos Moneda 1

						Pergunte("MTA410FAT",.F.) // nahim confirma
						aParams :=	{SC5->C5_NUM,SC5->C5_NUM,; //Pedido de - ate
						SC5->C5_CLIENTE,SC5->C5_CLIENTE,; //Cliente de - ate
						SC5->C5_LOJACLI,SC5->C5_LOJACLI,; //Loja de - ate
						MV_PAR01,MV_PAR02,; //Grupo de - ate
						MV_PAR03,MV_PAR04,; //Agregador de - ate
						MV_PAR05,MV_PAR06,MV_PAR07,; //lDigita # lAglutina # lGeraLanc
						2       ,MV_PAR08,MV_PAR09,; //lInverte# lAtuaSA7  # nSepara
						MV_PAR10, 2,; //nValorMin# proforma
						"",'zzzzzzzzzzz',;//Trasnportadora de - ate
						MV_PAR11,;//Reajusta na mesma nota	
						MV_PAR12,MV_PAR13,; // # Fatura Ped. Pela #Moeda para Faturamento					
						MV_PAR14,; // #Contabiliza On Line
						If(SC5->C5_TIPO<>"N",2,1)} // Tipo de Pedido
						If (cPaisLoc == "ARG")
							//Controle de ponto de venda para argentina.
							If Pergunte("PVXARG",.T.)
								If F083ExtSFP(MV_PAR01, .T.)
									cPV410 := MV_PAR01
									cIdPV	:= POSICIONE("CFH",1, xFilial("CFH")+MV_PAR01,"CFH_IDPV")
									a468NFatura("SC9",aParams,aReg,Nil)
								EndIf
							EndIf
						Else
							a468NFatura("SC9",aParams,aReg,Nil)
						EndIf
//					Endif
				Endif
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna o SetFunName que iniciou a rotina                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetFunName(cFunName)

	//Mensagem para o usuário em caso de existirem notas com datas onde não foram encontrados valores de moeda cadastrados
	If lTxMoeda
		Aviso(STR0295,STR0303,{STR0304}) //"Mensagens"###"Alguns pedidos nao foram gerados pois nao existe taxa para a moeda na data!"
	EndIf
	If lDataFin
		Aviso(STR0295,STR0305,{STR0304})	//"Alguns itens não foram gerados, pois não são permitidas movimentações financeiras com datas menores que a data limite de movimentações no Financeiro. Verificar o parâmetro MV_DATAFIN."
	EndIf

	//Limpa controle de quebra de NF / Rateio de Frete.
	__lNumItem := .F.
	MaNfsEnd(.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega perguntas do MATA410                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte("MTA410",.F.)
	RestArea(aArea)

	if type("renSE1") <> "U"// existe variable y me indica si debo cobrarlo.
//		Fina087A(renSE1)
		u_cobAutom()
		//SERVICIO
		// agora sim limpa o objeto ou , limpa a instancia usando freeobj()
		renSE1 := NIL
		FreeObj(renSE1)
		// agora sim limpa o objeto ou , limpa a instancia usando freeobj()
		_nValFac := NIL
		FreeObj(_nValFac)
		cCondiPago := NIL
		FreeObj(cCondiPago)
		lDesdFact := nil
		FreeObj(lDesdFact)
	endif

Return
