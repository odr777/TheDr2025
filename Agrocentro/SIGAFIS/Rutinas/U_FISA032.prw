#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FISA032.CH"

#DEFINE CSTRF570 "IUE Retenciones - Formulario 570"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FISA032  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera as apuracoes:                                         ³±±
±±³          ³ 1 - Apuracao IVA - Formulario 200                          ³±±
±±³          ³ 2 - Apuracao IT - Formulario 400                           ³±±
±±³          ³ 3 - Apuracao IT Retencoes  - Formulario 410                ³±±
±±³          ³ 4 - IUE Retenciones  - Formulario 570                	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³ Manutencao Efetuada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Fiscal - Bolivia                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS     ³ Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jonathan Glz³06/07/15³PCREQ-4256³Se elimina la funcion AjustaSX1() la  ³±±
±±³            ³        ³          ³hace modificacion a SX1 por motivo de ³±±
±±³            ³        ³          ³adecuacion a fuentes a nuevas estruc- ³±±
±±³            ³        ³          ³turas SX para Version 12.             ³±±
±±³M.Camargo   ³09.11.15³PCREQ-4262³Merge sistemico v12.1.8		           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FISA032()

	Local   nValTit   := 0
	Local   lOk       := .F.
	Local   cApur     := ""
	Local   cPerg     := ""
	Local   aApur     := {}
	Local   aApuAnt   := {}
	Local   aFiliais  := {}
	Local   aTitulos  := {}
	Local   aCombo    := {STR0001,STR0002,STR0048, CSTRF570}//"IVA - Formulário 200"###"IT - Formulário 400"###"IT Retenções - Formulário 410"
	Private nF032Apur := 0
	Private nXForms	  := 0
	Private nXPeriodo := ""

	//nF032Apur
	//1 - Apuracao IVA 200
	//2 - Apuracao IT 400
	//3 - Apuracao IT Retencoes 410

	oDlg01:=MSDialog():New(000,000,130,370,STR0003,,,,,,,,,.T.)//"Selecione a apuração"

	oSay01 := tSay():New(020,025,{|| STR0004 },oDlg01,,,,,,.T.,,,100,20)//"Apuração:"
	oCmb01 := tComboBox():New(0030,0025,{|u|if(PCount()>0,cApur:=u,cApur)},aCombo,100,020,oDlg01,,,,,,.T.)
	oBtn01:=sButton():New(0029,135,1,{|| lOk:=.T. ,oDlg01:End() },oDlg01,.T.,,)

	oDlg01:Activate(,,,.T.,,,)

	If lOk
		nF032Apur	:= aScan(aCombo,{|x| x == cApur})
		nXForms		:= nF032Apur

		If nF032Apur == 3
			cPerg := "FISA032"
		ElseIf nF032Apur == 2
			cPerg := "FISA032A"
		ElseIf nF032Apur == 1
			cPerg := "FISA032B"			
			// ALTERAR X1_CNT01 SX1
			u_zAtuPerg(cPerg+Space(2), "MV_PAR09", 0)
		Else//Formulario 570
			cPerg := "FISA032Z"
			CriaSX1(cPerg)	// Si no esta creada la crea
		endif

		If Pergunte(cPerg,.T.)

			// Variable periodo para utilizarla en histórico F50PERGUNT
			nXPeriodo := cValToChar(MV_PAR02) + CValToChar(StrZero(MV_PAR01,2,0))
			
			//Valida data de vencimento do titulo
			If MV_PAR05 == 1 .and. dDataBase > MV_PAR04
				MsgAlert(STR0005)//"A data de vencimento deve ser maior ou igual a data do sistema."
				Return Nil
			EndIf

			//Verifica se ha uma apuracao anterior
			If File(AllTrim(MV_PAR06)+AllTrim(MV_PAR08))
				If MsgYesNo(STR0006)//"Está apuração já foi gravada, deseja refazer?"
					If !DelTitApur(AllTrim(MV_PAR06)+AllTrim(MV_PAR08))
						MsgStop(STR0007,STR0008)//"O titulo já foi baixado."###"Apenas será possível excluir o título gerado e baixado anteriormente se for estornado."
						Return Nil
					Endif
				Else
					Return Nil
				EndIf
			EndIf

			//Seleciona Filiais
			aFiliais := MatFilCalc(MV_PAR03 == 1)

			//Carrega arquivo da apuracao anterior
			aApuAnt := FMApur(AllTrim(MV_PAR06),AllTrim(MV_PAR07))

			//Busca dados da apuracao
			Do Case
			Case nF032Apur == 1
				aApur := ApurIVA(aFiliais,aApuAnt) //Apuracao do IVA 200
				ImpRel200(cApur,aApur) //Imprime a apuracao
			Case nF032Apur == 2
				aApur := ApurIT(aFiliais,aApuAnt) //Apuracao do IT 400
				ImpRel400(cApur,aApur) //Imprime a apuracao
			Case nF032Apur == 3
				aApur := ApurITR(aFiliais,aApuAnt) //Apuracao do IT Retencoes 410
				ImpRel410(cApur,aApur) //Imprime a apuracao
			Case nF032Apur == 4
				aApur := ApurIUE(aFiliais,aApuAnt) //IUE Retenciones Formulario 570
				ImpRel570(cApur,aApur) //Imprime a apuracao
			OtherWise
				MsgAlert(STR0009)//"Selecione uma apuração."
			EndCase

			//Gera titulo da apuracao
			If MV_PAR05 == 1
				If(nF032Apur == 1)
					nValTit := Round(aApur[Len(aApur)-2][4],0)
					MsgRun(STR0010,,{|| IIf(nValTit>0,aTitulos := GrvTitLoc(nValTit),Nil) })//"Gerando titulo de apuração..."
				ElseIf(nF032Apur == 4)
					nF032Apur:= 1
					nValTit := Round(aApur[Len(aApur)][4],0)
					MsgRun(STR0010,,{|| IIf(nValTit>0,aTitulos := GrvTitLoc(nValTit),Nil) })//"Gerando titulo de apuração..."
				Else
					nValTit := Round(aApur[Len(aApur)][4],0)
					MsgRun(STR0010,,{|| IIf(nValTit>0,aTitulos := GrvTitLoc(nValTit),Nil) })//"Gerando titulo de apuração..."
				EndIf
			Endif

			//Gera arquivo da apuracao
			MsgRun(STR0011,,{|| CriarArq(AllTrim(MV_PAR06),AllTrim(MV_PAR08),aApur,aTitulos) })//"Gerando Arquivo apuração de imposto..."

		EndIf
	EndIf

Return Nil

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³ ApurITR  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 11.10.2011 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³ Carrega valores para a apuracao do IT Retencoes.           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ aFiliais - Array com as filiais selecionadas.              ³±±
	±±³          ³ aApuAnt  - Array com os dados da apuracao anterior.        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ aApur - Vetor com os valores da apuracao                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Fiscal - FISA032                                           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ApurITR(aFiliais,aApuAnt)

	Local nI       := 0
	Local cQry     := ""
	Local aApur    := {}
	Local aDados   := {}

	For nI:=1 To 11
		aAdd(aDados,0)
	Next nI

	cQry := " SELECT"
	cQry += " SUM(SF3.F3_VALIMP2) AS VALIMP"
	cQry += " FROM "+RetSqlName("SF3")+" SF3"
	cQry += " WHERE SF3.D_E_L_E_T_ = ' '"
	cQry += " AND ( SF3.F3_FILIAL = '"+Space(TamSX3("F3_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
			cQry += " OR SF3.F3_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQry += " )"
	cQry += " AND SF3.F3_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	cQry += " AND SF3.F3_TIPOMOV = 'C'"

	TcQuery cQry New Alias "QRY"

	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		aDados[1] += QRY->VALIMP
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

	aDados[03] := MV_PAR09
	If Len(aApuAnt) > 3
		aDados[4] := aApuAnt[5]
	Else
		aDados[4] := MV_PAR10
	EndIf
	aDados[07] := MV_PAR11

	aDados[2] := aDados[1]

	If (aDados[3] + aDados[4] - aDados[2]) > 0
		aDados[5] := aDados[3] + aDados[4] - aDados[2]
	EndIf

	If (aDados[2] - aDados[3] - aDados[4]) > 0
		aDados[6] := aDados[2] - aDados[3] - aDados[4]
	EndIf

	If (aDados[6] - aDados[7]) > 0
		aDados[8] := aDados[6] - aDados[7]
	EndIf

	aAdd(aApur,{1,STR0049,"013",aDados[01]})//"Imposto retido"
	aAdd(aApur,{2,STR0050,"909",aDados[02]})//"Imposto determinado (Importado do campo C013)"
	aAdd(aApur,{2,STR0051,"622",aDados[03]})//"Pagos a conte realizados em DDJJ anterior e/ou em boletos de pagamento."
	aAdd(aApur,{2,STR0052,"640",aDados[04]})//"Saldo disponível de pagamentos do período anterior a compensar."
	aAdd(aApur,{2,STR0053,"747",aDados[05]})//"Diferença a favor do contribuinte para o seguinte período (C622 + C640 - C909;Si > 0)"
	aAdd(aApur,{2,STR0054,"996",aDados[06]})//"Saldo definitivo a favor do Fisco (C909 - C622 - C640;Si > 0)"
	aAdd(aApur,{2,STR0055,"677",aDados[07]})//"Inclusão de credito nos valores (Sujeito a verificacao e confirmacao por parte da S.I.N.)."
	aAdd(aApur,{2,STR0056,"576",aDados[08]})//"Pagamento de imposto em especies (C996-C677; Se > 0), (Se a prestação é fora do término, deve realizar o pagamento no boleto F.1000)."

Return aApur

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³ ApurIVA  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³ Carrega valores para a apuracao do IVA.                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ aFiliais - Array com as filiais selecionadas.              ³±±
	±±³          ³ aApuAnt  - Array com os dados da apuracao anterior.        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Nulo                                                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Fiscal - FISA032                                           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ApurIVA(aFiliais,aApuAnt)

	Local nI		:= 0
	Local cQryV		:= ""
	Local cQryC		:= ""
	Local aApur		:= {}
	Local aDados	:= {}
	Local cTesBon	:= "550" //TES de Bonificacion

	For nI:=1 To 40
		aAdd(aDados,0)
	Next nI

	//Query Vendas
	cQryV := " SELECT SF3.F3_TES, SF3.F3_NFISCAL, SF3.F3_SERIE, SF3.F3_BASIMP1 AS BASIMPV, F3_ESPECIE AS ESPECIE, SF3.F3_TIPOMOV, SF3.F3_VALCONT, SF3.F3_EXENTAS,"

	cQryV += " 	CASE"
	cQryV += "  WHEN SF3.F3_EXENTAS > 0 THEN 0"
	cQryV += "  ELSE"
	cQryV += " ("
	cQryV += " 	SELECT"
	cQryV += " 	CASE"
	cQryV += " 		WHEN F2_MOEDA = 1 THEN F2_DESCONT"
	cQryV += " 		WHEN F2_MOEDA = 2 THEN"
	cQryV += " 		("
	cQryV += " 			CASE"
	cQryV += " 				WHEN F2_TXMOEDA > 1 THEN (F2_DESCONT * F2_TXMOEDA)"
	cQryV += " 				ELSE (F2_DESCONT * (SELECT TOP 1 M2_MOEDA2 FROM "+RetSqlName("SM2")+" WHERE D_E_L_E_T_ <> '*' AND M2_DATA = SF3.F3_EMISSAO))"
	cQryV += " 			END"
	cQryV += " 		)"
	cQryV += " 	END AS F2_DESCONT"
	cQryV += " 	FROM "+RetSqlName("SF2")
	cQryV += " 	WHERE F2_DOC = SF3.F3_NFISCAL"
	cQryV += " 	AND F2_SERIE = SF3.F3_SERIE"
	cQryV += " 	AND F2_CLIENTE = SF3.F3_CLIEFOR"
	cQryV += " 	AND F2_LOJA = SF3.F3_LOJA"
	cQryV += " 	AND D_E_L_E_T_ <> '*'"
	cQryV += " ) END"
	cQryV += " AS F2_DESCONT,"

	cQryV += " ("
	cQryV += " 	SELECT SUM(D2_TOTAL) AS DESC_BON FROM"
	cQryV += " 	("
	cQryV += " 	SELECT"
	cQryV += " 	CASE"
	cQryV += " 		WHEN F2_MOEDA = 1 THEN SD2.D2_TOTAL"
	cQryV += " 		WHEN F2_MOEDA = 2 THEN "
	cQryV += " 		("
	cQryV += " 			CASE "
	cQryV += " 				WHEN F2_TXMOEDA > 1 THEN (SD2.D2_TOTAL * F2_TXMOEDA)"
	cQryV += " 				ELSE (SD2.D2_TOTAL * (SELECT TOP 1 M2_MOEDA2 FROM "+RetSqlName("SM2")+" WHERE D_E_L_E_T_ <> '*' AND M2_DATA = SF3.F3_EMISSAO))"
	cQryV += " 			END"
	cQryV += " 		)"
	cQryV += " 	END AS D2_TOTAL"
	cQryV += " 	FROM "+RetSqlName("SF2")+" SF2"
	cQryV += " 	JOIN "+RetSqlName("SD2")+" SD2 ON SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA"
	cQryV += " 	WHERE F2_DOC = SF3.F3_NFISCAL"
	cQryV += " 	AND F2_SERIE = SF3.F3_SERIE"
	cQryV += " 	AND F2_CLIENTE = SF3.F3_CLIEFOR"
	cQryV += " 	AND F2_LOJA = SF3.F3_LOJA"
	cQryV += " 	AND SD2.D2_TES = '" + cTesBon + "'"
	cQryV += " 	AND SF2.D_E_L_E_T_ <> '*'"
	cQryV += " 	AND SD2.D_E_L_E_T_ <> '*'"
	cQryV += " 	) A"
	cQryV += " ) DESC_BON"

	cQryV += " FROM "+RetSqlName("SF3")+" SF3"
	cQryV += " WHERE SF3.D_E_L_E_T_ <> '*'"
	cQryV += " AND ( SF3.F3_FILIAL = '"+Space(TamSX3("F3_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
			cQryV += " OR SF3.F3_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQryV += " )"
	cQryV += " AND SF3.F3_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	cQryV += " AND SF3.F3_TIPOMOV = 'V'"
	cQryV += " AND SF3.F3_DTCANC = ''"

	/*
	cQryV := " SELECT"
	cQryV += " SA1.A1_TIPO AS TIPO"
	cQryV += " ,SF2.F2_MOEDA AS MOEDA"
	cQryV += " ,SF2.F2_BASIMP1 AS BASIMP"
	cQryV += " ,SF2.F2_VALIMP1 AS VALIMP"
	cQryV += " ,SF2.F2_ESPECIE AS ESPECIE"
	cQryV += " FROM "+RetSqlName("SF2")+" SF2"
	cQryV += " INNER JOIN "+RetSqlName("SA1")+" SA1"
	cQryV += " ON SF2.F2_CLIENTE = SA1.A1_COD"
	cQryV += " AND SF2.F2_LOJA = SA1.A1_LOJA"
	cQryV += " WHERE SF2.D_E_L_E_T_ = ' '"
	cQryV += " AND SA1.D_E_L_E_T_ = ' '"
	cQryV += " AND ( SF2.F2_FILIAL = '"+Space(TamSX3("F2_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
	cQryV += " OR SF2.F2_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQryV += " )"
	//cQryV += " AND ( SA1.A1_FILIAL = '"+Space(TamSX3("A1_FILIAL")[1])+"'"
	cQryV += " AND ( SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
	cQryV += " OR SA1.A1_FILIAL = '"+aFiliais[nI,2]+"'"
	//cQryV += " OR SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		EndIf
	Next nI
	cQryV += " )"
	cQryV += " AND SF2.F2_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	cQryV += " UNION ALL"
	cQryV += " SELECT"
	cQryV += " SA1.A1_TIPO AS TIPO"
	cQryV += " ,SF1.F1_MOEDA AS MOEDA"
	cQryV += " ,SF1.F1_BASIMP1 AS BASIMP"
	cQryV += " ,SF1.F1_VALIMP1 AS VALIMP"
	cQryV += " ,SF1.F1_ESPECIE AS ESPECIE"
	cQryV += " FROM "+RetSqlName("SF1")+" SF1"
	cQryV += " INNER JOIN "+RetSqlName("SA1")+" SA1"
	cQryV += " ON SF1.F1_FORNECE = SA1.A1_COD"
	cQryV += " AND SF1.F1_LOJA = SA1.A1_LOJA"
	cQryV += " WHERE SF1.D_E_L_E_T_ = ' '"
	cQryV += " AND SA1.D_E_L_E_T_ = ' '"
	cQryV += " AND ( SF1.F1_FILIAL = '"+Space(TamSX3("F1_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
	cQryV += " OR SF1.F1_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQryV += " )"
	//cQryV += " AND ( SA1.A1_FILIAL = '"+Space(TamSX3("A1_FILIAL")[1])+"'"
	cQryV += " AND ( SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
	cQryV += " OR SA1.A1_FILIAL = '"+aFiliais[nI,2]+"'"
	//cQryV += " OR SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		EndIf
	Next nI
	cQryV += " )"
	cQryV += " AND SF1.F1_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	*/

	//Aviso("Query Ventas",cQryV,{"si"},,,,,.t.)

	TcQuery cQryV New Alias "QRV"

	dbSelectArea("QRV")
	Do While QRV->(!EOF())
		If AllTrim(QRV->ESPECIE) == "NF" .OR. AllTrim(QRV->ESPECIE) == "NDC"
			aDados[1] += QRV->BASIMPV // 013
			aDados[15] += QRV->F2_DESCONT + QRV->DESC_BON // 028
		EndIf

		IF QRV->F3_TES $ '520|521' //FILTRAR TES 520 y 521
			aDados[2] += QRV->BASIMPV // 014
		Endif

		If QRV->BASIMPV == 0//Revisar Segun TES
			aDados[3] += QRV->BASIMPV //015
		Endif

		If QRV->BASIMPV == 0//Revisar Segun TES
			aDados[4] += QRV->BASIMPV // 505
		Endif

		If 	AllTrim(QRV->ESPECIE) == "NCC"
			aDados[14] += QRV->BASIMPV // 027
		Endif

		/*If 	SF2->F2_DESCONT != 0 .OR. SF1->F1_DESCONT != 0
			If QRV->MOEDA != 1
				aDados[7] += xMoeda(QRV->BASIMP, QRV->MOEDA, M->F2_MOEDA, SF2->F2_EMISSAO, 2,SF2->F2_TXMOEDA, M->F2_TXMOEDA)  // 018
			Else
				aDados[7] += QRV->BASIMP // 018
			Endif
		Endif*/

		QRV->(dbSkip())
	EndDo
	QRV->(dbCloseArea())

	//Query Compras

	cQryC := " SELECT SF3.F3_TES, SF3.F3_NFISCAL, SF3.F3_SERIE, SF3.F3_BASIMP1 AS BASIMPC, F3_ESPECIE AS ESPECIE, SF3.F3_TIPOMOV, SF3.F3_VALCONT, SF3.F3_EXENTAS,"

	cQryC += " 	CASE"
	cQryC += "  WHEN SF3.F3_EXENTAS > 0 THEN 0"
	cQryC += "  ELSE"
	cQryC += " ("
	cQryC += " 	CASE"
	cQryC += " 		WHEN SF1.F1_MOEDA = 1 THEN SF1.F1_DESCONT"
	cQryC += " 		WHEN SF1.F1_MOEDA = 2 THEN"
	cQryC += " 		("
	cQryC += " 			CASE"
	cQryC += " 				WHEN SF1.F1_TXMOEDA > 1 THEN (SF1.F1_DESCONT * SF1.F1_TXMOEDA)"
	cQryC += " 				ELSE (SF1.F1_DESCONT * (SELECT TOP 1 M2_MOEDA2 FROM "+RetSqlName("SM2")+" WHERE D_E_L_E_T_ <> '*' AND M2_DATA = SF3.F3_EMISSAO))"
	cQryC += " 			END"
	cQryC += " 		)"
	cQryC += " 	END "
	cQryC += " ) END"
	cQryC += " AS F1_DESCONT"

	cQryC += " FROM "+RetSqlName("SF3")+" SF3"
	cQryC += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SF3.F3_TES"

	cQryC += " INNER JOIN "+RetSqlName("SF1") + " SF1 ON "
	cQryC += " SF1.F1_FILIAL = SF3.F3_FILIAL "
	cQryC += " AND SF1.F1_DOC = SF3.F3_NFISCAL"
	cQryC += " AND SF1.F1_SERIE = SF3.F3_SERIE"
	cQryC += " AND SF1.F1_FORNECE = SF3.F3_CLIEFOR"
	cQryC += " AND SF1.F1_LOJA = SF3.F3_LOJA"
	cQryC += " AND SF1.F1_EMISSAO = SF3.F3_EMISSAO"

	cQryC += " WHERE SF3.D_E_L_E_T_ <> '*'"
	cQryC += " AND SF1.D_E_L_E_T_ <> '*'"
	cQryC += " AND ( SF3.F3_FILIAL = '" + Space(TamSX3("F3_FILIAL")[1]) + "'"	
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
				cQryC += " OR SF3.F3_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQryC += " )"
	cQryC += " AND SF3.F3_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	cQryC += " AND SF3.F3_TIPOMOV = 'C'"
	cQryC += " AND SF3.F3_DTCANC = ''"
	cQryC += " AND F3_ESPECIE = 'NF' "
	cQryC += " AND SF4.D_E_L_E_T_ = '' AND SF4.F4_XRETEN IN ('','1') "

	/*
	cQryC := " SELECT"
	cQryC += " SA2.A2_TIPO AS TIPOC"
	cQryC += " ,SF1.F1_MOEDA AS MOEDAC"
	cQryC += " ,SF1.F1_BASIMP1 AS BASIMPC"
	cQryC += " ,SF1.F1_VALIMP1 AS VALIMPC"
	cQryC += " ,SF1.F1_ESPECIE AS ESPECIEC"
	cQryC += " FROM "+RetSqlName("SF1")+" SF1"
	cQryC += " INNER JOIN "+RetSqlName("SA2")+" SA2"
	cQryC += " ON SF1.F1_FORNECE = SA2.A2_COD"
	cQryC += " AND SF1.F1_LOJA = SA2.A2_LOJA"
	cQryC += " WHERE SF1.D_E_L_E_T_ = ' '"
	cQryC += " AND SA2.D_E_L_E_T_ = ' '"
	cQryC += " AND ( SF1.F1_FILIAL = '"+Space(TamSX3("F1_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
		cQryC += " OR SF1.F1_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
		cQryC += " )"
		//cQryC += " AND ( SA2.A2_FILIAL = '"+Space(TamSX3("A2_FILIAL")[1])+"'"
		cQryC += " AND ( SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
		cQryC += " OR SA2.A2_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
		cQryC += " )"
		cQryC += " AND SF1.F1_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
		cQryC += " UNION ALL"
		cQryC += " SELECT"
		cQryC += " SA2.A2_TIPO AS TIPOC"
		cQryC += " ,SF2.F2_MOEDA AS MOEDAC"
		cQryC += " ,SF2.F2_BASIMP1 AS BASIMPC"
		cQryC += " ,SF2.F2_VALIMP1 AS VALIMPC"
		cQryC += " ,SF2.F2_ESPECIE AS ESPECIEC"
		cQryC += " FROM "+RetSqlName("SF2")+" SF2"
		cQryC += " INNER JOIN "+RetSqlName("SA2")+" SA2"
		cQryC += " ON SF2.F2_CLIENTE = SA2.A2_COD"
		cQryC += " AND SF2.F2_LOJA = SA2.A2_LOJA"
		cQryC += " WHERE SF2.D_E_L_E_T_ = ' '"
		cQryC += " AND SA2.D_E_L_E_T_ = ' '"
		cQryC += " AND ( SF2.F2_FILIAL = '"+Space(TamSX3("F2_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
		cQryC += " OR SF2.F2_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
		cQryC += " )"
		//cQryC += " AND ( SA2.A2_FILIAL = '"+Space(TamSX3("A2_FILIAL")[1])+"'"
		cQryC += " AND ( SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
		cQryC += " OR SA2.A2_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
		cQryC += " )"
		cQryC += " AND SF2.F2_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	*/
	// Aviso("Query Compra",cQryC ,{"si"},,,,,.t.)

	TcQuery cQryC New Alias "QRC"

	dbSelectArea("QRC")
	Do While QRC->(!EOF())
		If 	AllTrim(QRC->ESPECIE) == "NF"
			aDados[7] += QRC->F1_DESCONT // 018
			aDados[11] += QRC->BASIMPC + QRC->F1_DESCONT + QRC->F3_EXENTAS // 011
			If QRC->BASIMPC != 0
				aDados[12] += QRC->BASIMPC + QRC->F1_DESCONT // 026
				// aDados[12] += QRC->BASIMPC // 026
			Endif
		EndIf

		If AllTrim(QRC->ESPECIE) == "NCP"
			aDados[6] += QRC->BASIMPC // 017
		Endif

		/*If 	SF1->F1_DESCONT != 0 .OR. SF2->F2_DESCONT != 0
			If QRC->MOEDAC != 1
				aDados[15] += xMoeda(QRC->BASIMPC, QRC->MOEDAC, M->F1_MOEDA, SF1->F1_EMISSAO, 2,SF1->F1_TXMOEDA, M->F1_TXMOEDA)  // 028
			Else
				aDados[15] += QRC->BASIMPC // 028
			Endif
		Endif*/

		QRC->(dbSkip())
	EndDo
	QRC->(dbCloseArea())

	//Processo em analise
	aDados[5] := 0 // 016

	aDados[8] := (aDados[1] + aDados[5] + aDados[6] + aDados[7]) * 0.13  // 039

	aDados[9] := 0 // 055 - sem uso

	aDados[10] := aDados[8] + aDados[9] //1002

	aDados[13] := 0 // 031 Sem uso

	aDados[16] := (aDados[12] + aDados[14] + aDados[15]) * 0.13 //114

	aDados[17] := (aDados[13] * (aDados[1] + aDados[2]) / (aDados[1] + aDados[2] + aDados[3] + aDados[4])) * 0.13 //1003

	aDados[18] := aDados[16] + aDados[17] // 1004

	If (aDados[18] - aDados[10]) > 0
		aDados[19] := aDados[18] - aDados[10] // 693
	Endif

	If aDados[10] - aDados[18] > 0
		aDados[20] := aDados[10] - aDados[18] //909
	Endif

		aDados[21] := MV_PAR09 //635
	If(aDados[21] > 0)
		aDados[22] := getValorActualizado(aDados[21]) //648
	Else
		aDados[22] := 0 //648
	EndIf

	If ((aDados[20] - aDados[21]) - aDados[22]) > 0
			aDados[23] :=  (aDados[20] - aDados[21]) - aDados[22]   // 1001
	Endif

		aDados[24] := MV_PAR11 //622
		aDados[25] := MV_PAR12 //640

	If ((aDados[24] + aDados[25]) - aDados[23]) > 0
			aDados[26] := (aDados[24] + aDados[25]) - aDados[23] //643
	Endif

	If ((aDados[23] - aDados[24]) - aDados[25]) > 0
			aDados[27] := (aDados[23] - aDados[24]) - aDados[25] //996
	Endif

		aDados[28] := aDados[27]//MV_PAR14 //924
		aDados[29] := MV_PAR15 //925
		aDados[30] := MV_PAR16 //938
		aDados[31] := MV_PAR17 //954
		aDados[32] := MV_PAR18 //967
		aDados[33] := aDados[28] + aDados[29] + aDados[30] +aDados[31] + aDados[32] //955

	If (((aDados[19] + aDados[21]) + aDados[22]) - aDados[20]) > 0
			aDados[34] := (((aDados[19] + aDados[21]) + aDados[22]) - aDados[20]) //592
	Endif

	If (aDados[26] - aDados[33]) > 0
			aDados[35] := aDados[26] - aDados[33] //747
	Endif

	If (aDados[27] > 0 ) .OR. (aDados[33] - aDados[26]) > 0
			aDados[36] := aDados[33] - aDados[26] //646
	Endif

		aDados[37] := MV_PAR19//677

	If (aDados[36] - aDados[37]) > 0
			aDados[38] := aDados[36] - aDados[37] //576
	Endif

	aDados[39] := MV_PAR20 //580
	aDados[40] := MV_PAR21 //581

	aAdd(aApur,{1,STR0111, STR0175,aDados[01]}) //"Ventas de bienes y / o servicios tributados en el mercado interno, excepto ventas tributadas con Tasa cero"
	aAdd(aApur,{2,STR0112, STR0196,aDados[02]}) //"Exportación de bienes y operaciones exentas"
	aAdd(aApur,{2,STR0113, STR0197,aDados[03]}) //"Ventas tributadas con tasa cero"
	aAdd(aApur,{2,STR0114, STR0199,aDados[04]}) //"Ventas y operaciones no tributadas que no están sujetas a IVA"
	aAdd(aApur,{2,STR0115, STR0198,aDados[05]}) //"Valor atribuido a bienes y / o servicios retirados y consumo privado"
	aAdd(aApur,{2,STR0116, STR0176,aDados[06]}) //"Devoluciones y rescisiones efectuadas durante el período"
	aAdd(aApur,{2,STR0117, STR0177,aDados[07]}) //"Descuentos, bonos y descuentos obtenidos durante el período"
	aAdd(aApur,{2,STR0118, STR0178,aDados[08]}) //"Débito fiscal correspondiente a: [(C13 + C16 + C17 + C18) * 13%]"
	aAdd(aApur,{2,STR0119, STR0179,aDados[09]}) //"Débito fiscal actualizado correspondiente a reembolsos"
	aAdd(aApur,{2,STR0120, STR0180,aDados[10]}) //"Débito fiscal total en el período (C39 + C55)"
	aAdd(aApur,{2,STR0121, STR0181,aDados[11]}) //"Total de compras correspondientes a actividades tributadas y / o no tributadas"
	aAdd(aApur,{1,STR0122, STR0182,aDados[12]}) //"Compras directamente vinculadas a actividades tributadas"
	aAdd(aApur,{2,STR0123, STR0183,aDados[13]}) //"Compras donde no es posible detallar su relación con actividades tributadas y no tributadas"
	aAdd(aApur,{2,STR0124, STR0184,aDados[14]}) //"Devoluciones y rescisiones cobradas durante el período"
	aAdd(aApur,{2,STR0125, STR0185,aDados[15]}) //"Descuentos, bonos y descuentos concedidos durante el período"
	aAdd(aApur,{2,STR0126, STR0186,aDados[16]}) //"Crédito fiscal correspondiente a: [(C26 + C27 + C28) * 13%]"
	aAdd(aApur,{2,STR0127, STR0187,aDados[17]}) //"Crédito fiscal proporcional correspondiente a la actividad tributada [C31 * (C13 + C14) / (C13 + C14 + C15 + C505)] * 13%"
	aAdd(aApur,{2,STR0128, STR0188,aDados[18]}) //"Crédito fiscal total para el período (C114 + C1003)"
	aAdd(aApur,{1,STR0129, STR0189,aDados[19]}) //"Diferencia a favor del contribuyente (C1004-C1002; Si > 0)"
	aAdd(aApur,{1,STR0130, STR0157,aDados[20]}) //"Diferencia a favor del Tesoro o Impuesto determinado (C1002-C1004; Si> 0)"
	aAdd(aApur,{2,STR0131, STR0190,aDados[21]}) //"Saldo del crédito fiscal del período anterior por compensarse (C592 del formulario del período anterior)"
	aAdd(aApur,{2,STR0132, STR0191,aDados[22]}) //"Actualización de valor en el saldo del crédito fiscal del período anterior"
	aAdd(aApur,{2,STR0133, STR0159,aDados[23]}) //"Saldo tributario determinado a favor del Tesoro (C909-C635-C648; Si > 0)"
	aAdd(aApur,{2,STR0134, STR0160,aDados[24]}) //"Pagos a cuenta realizados en DD.JJ. y / o Billetes de pago correspondientes al período declarado"
	aAdd(aApur,{2,STR0135, STR0161,aDados[25]}) //"Saldo de pagos a cuenta del período anterior por compensarse (C747 del formulario del período anterior)"
	aAdd(aApur,{2,STR0136, STR0162,aDados[26]}) //"Saldo de pagos a cuenta, a favor del contribuyente (C622 + C640-C1001; Si > 0)"
	aAdd(aApur,{2,STR0137, STR0163,aDados[27]}) //"Saldo a favor del Tesoro (C1001-C622-C640; Si > 0)"
	aAdd(aApur,{2,STR0138, STR0164,aDados[28]}) //"Tributo omitido (C996)"
	aAdd(aApur,{2,STR0139, STR0165,aDados[29]}) //"Actualización del valor del tributo omitido"
	aAdd(aApur,{2,STR0140, STR0166,aDados[30]}) //"Intereses sobre el tributo omitido actualizados"
	aAdd(aApur,{2,STR0141, STR0167,aDados[31]}) //"Multa por violación de deber formal (IDF) por envío fuera del plazo"
	aAdd(aApur,{2,STR0142, STR0168,aDados[32]}) //"Multa de la IDF por aumento del impuesto determinado en DD.JJ. Retirada enviada después del plazo"
	aAdd(aApur,{2,STR0143, STR0169,aDados[33]}) //"Deuda fiscal total (C924 + C925 + C938 + C954 + C967)"
	aAdd(aApur,{2,STR0144, STR0192,aDados[34]}) //"Saldo final del crédito tributario a favor del contribuyente por el período siguiente (C693 + C635 + C648-C909; Si> 0)"
	aAdd(aApur,{2,STR0145, STR0171,aDados[35]}) //"Saldo final de pagos a cuenta, a favor del contribuyente para el período siguiente (C643-C955; Si > 0)"
	aAdd(aApur,{2,STR0146, STR0172,aDados[36]}) //"Saldo final a favor del Tesoro (C 996 o (C955-C643), según corresponda; Si > 0"
	aAdd(aApur,{2,STR0147, STR0173,aDados[37]}) //"Pago en valores (sujeto a verificación y confirmación por el SIN)"
	aAdd(aApur,{2,STR0148, STR0174,aDados[38]}) //"Pago en dinero (C646-C677; Si > 0)"
	aAdd(aApur,{2,STR0149, STR0193,aDados[39]}) //"Canje en la venta de bienes y / o servicios"
	aAdd(aApur,{2,STR0150, STR0194,aDados[40]}) //"Canje en la compra de bienes y / o servicios"

Return aApur

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ApurIT   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carrega valores para a apuracao do IT.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aFiliais - Array com as filiais selecionadas.              ³±±
±±³          ³ aApuAnt  - Array com os dados da apuracao anterior.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aApur - Vetor com os valores da apuracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ApurIT(aFiliais,aApuAnt)

	Local nI       := 0
	Local cQry     := ""
	Local aApur    := {}
	Local aDados   := {}

	For nI:=1 To 19
		aAdd(aDados,0)
	Next nI

	//Query
	cQry := " SELECT"
	cQry += " SUM(SF3.F3_BASIMP2) AS BASIMP , "
	cQry += " SUM(SF3.F3_EXENTAS) AS EXENTO"
	cQry += " FROM "+RetSqlName("SF3")+" SF3"
	cQry += " WHERE SF3.D_E_L_E_T_ = ' '"
	cQry += " AND ( SF3.F3_FILIAL = '"+Space(TamSX3("F3_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
			cQry += " OR SF3.F3_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQry += " )"
	cQry += " AND SF3.F3_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	cQry += " AND SF3.F3_TIPOMOV = 'V'"
	// omitir facturas anuladas
	cQry += " AND SF3.F3_DTCANC = ''"

	TcQuery cQry New Alias "QRY"

	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		aDados[1]  += QRY->BASIMP
		aDados[15] += QRY->EXENTO
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

	If Len(aApuAnt) > 2
		aDados[3] := aApuAnt[4]
	Else
		aDados[3] := MV_PAR09
	EndIf
	aDados[06] := MV_PAR10
	If Len(aApuAnt) > 6
		aDados[7] := aApuAnt[8]
	Else
		aDados[7] := MV_PAR11
	EndIf
	aDados[10] := MV_PAR12

	aDados[12] :=  aDados[01] - aDados[15] // descobrir o que são os isentos.

	aDados[2] := aDados[12] * 0.03 // criar uma pergunta

	If (aDados[3] - aDados[2]) > 0
		aDados[4] := aDados[3] - aDados[2]
	EndIf

	If (aDados[2] - aDados[3]) > 0
		aDados[5] := aDados[2] - aDados[3]
	EndIf

	If (aDados[6] + aDados[7] - aDados[5]) > 0
		aDados[8] := aDados[6] + aDados[7] - aDados[5]
	EndIf

	If (aDados[5] - aDados[6] - aDados[7]) > 0
		aDados[9] := aDados[5] - aDados[6] - aDados[7]
	EndIf

	IF ((aDados[06]+aDados[07])-aDados[05]) > 0
		aDados[13] := (aDados[06]+aDados[07])-aDados[05]
	EndIf

	/*aDados[14] := aDados[5] - aDados[6] - aDados[7]*/
	aDados[14]:= aDados[9]

	aDados[16] := aDados[14] + (MV_PAR18 + MV_PAR19 + MV_PAR20 + MV_PAR21)

	/*IF (aDados[07] - aDados[02]) >0
	aDados[17] := aDados[07] - aDados[02]
EndIF*/
IF (aDados[03] - aDados[02]) >0
		aDados[17] := aDados[03] - aDados[02]
EndIF

IF (aDados[13] - aDados[16]) > 0
		aDados[18] := aDados[13] - aDados[16]
ENdIf

If (aDados[16] - aDados[13]) > 0	
		aDados[19] := aDados[16] - aDados[13]
ElseIf aDados[09] > 0
		aDados[19] := aDados[09]
EndIf

If (aDados[19] - aDados[10]) > 0
		aDados[11] := aDados[19] - aDados[10]
EndIf

	aAdd(aApur,{1,STR0058, STR0175,aDados[01]})//"Total Ingressos brutos devengados y/o percebidos en especie (incluye ingresos exentos)"  //013
	aAdd(aApur,{1,STR0059, STR0155,aDados[15]})//"Ingresos exentos"  //032
	aAdd(aApur,{1,STR0060, STR0156,aDados[12]})//"Base imponible (C13 - C32)"  //024
	aAdd(aApur,{1,STR0061, STR0157,aDados[02]})//"Impuesto liquidado (3% de C024)" //909

	aAdd(aApur,{2,STR0062, STR0158,aDados[03]})//"Pago a conta IUE a compensar (1ra. instancia ou saldo do periodo anterior (C619 do Form. Anterior))" //664
	aAdd(aApur,{2,STR0063,STR0159,aDados[05]})//"Saldo a favor da Fisco (C909 - C664; Si > 0)" //1001
	aAdd(aApur,{2,STR0064, STR0160,aDados[06]})//"Pagamentos a conta realizados na DDJJ anterior e/ou em boletos de pagamento" //622
	aAdd(aApur,{2,STR0065, STR0161,aDados[07]})//"Saldo disponivel de pagamentos do periodo anterior a compensar" //640
	aAdd(aApur,{2,STR0066, STR0162,aDados[13]})//"Saldo por Pagos a Cuenta a favor del Contribuyente (C622+C640-C1001;Si > 0)" //643
	aAdd(aApur,{2,STR0067, STR0163,aDados[09]})//"Saldo definitivo a favor da fisco (C1001 - C622 - C640; Si > 0)" // 996

	aAdd(aApur,{2,STR0068 , STR0164,aDados[14]})//"Tributo Omitido (C996)" //924
	aAdd(aApur,{2,STR0069 , STR0165,MV_PAR18})//"Actualizacion de valor sobre Tributo Omitido."" //925
	aAdd(aApur,{2,STR0070 , STR0166,MV_PAR19})//"Interesse sobre Tributo Omitido Actualizado" //938
	aAdd(aApur,{2,STR0071 , STR0167,MV_PAR20})//"Multa por Incumplimiento al Deber Formal (IDF) por presentacion fuera de plazo." // 954
	aAdd(aApur,{2,STR0072 , STR0168,MV_PAR21})//"Multa por IDF por Incremento del Impuesto Determinado en DD.JJ. Rectificatoria presentada fuera de plazo" //967
	aAdd(aApur,{2,STR0073 , STR0169,aDados[16]})//"Total Deuda Tributaria" //955

	aAdd(aApur,{2,STR0074 , STR0170,aDados[17]})//"Saldo definitivo de IUE a compensar para el siguiente periodo (C664 - C909; Si > 0)" //619
	aAdd(aApur,{2,STR0075 , STR0171,aDados[18]})//"Saldo denitivo por Pagos a Cuenta a favor del Contribuyente para el siguiente período (C643-C955; Si >0)" //747
	aAdd(aApur,{2,STR0076 , STR0172,aDados[19]})//"Saldo definitivo a favor da fisco (C996 o (C955-C643) segun corresponda; Si > 0)" // 646

	aAdd(aApur,{2,STR0077 , STR0173,aDados[10]})//"Inclusão de credito nos valores (Sujeito a verificacao e confirmacao por parte da S.I.N.)." //677
	aAdd(aApur,{2,STR0078 , STR0174,aDados[11]})//"Pago en efectivo (C646-C677; Si > 0)" //576

Return aApur

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImpRel200³ Autor ³ Leandro S Santos    ³ Data ³ 14.02.2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime apuracao formulario 200                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTitulo - Titulo do relatorio.                             ³±±
±±³          ³ aApur   - Array com os dados da apuracao.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel200(cTitulo,aApur)

	Local nI     := 0
	Local nLin   := 0
	Local nTam   := 0
	// Local lCabLF := .F.
	Local aTexto := {}

	Private oFont1 := TFont():New("Verdana",,10,,.F.,,,,,.F.)
	Private oFont2 := TFont():New("Verdana",,10,,.T.,,,,,.F.)
	Private oFont3 := TFont():New("Verdana",,15,,.T.,,,,,.F.)
	Private oFont4 := TFont():New("Verdana",,08,,.T.,,,,,.F.)

	oPrint := TmsPrinter():New(cTitulo)
	oPrint:SetPaperSize(9)
	oPrint:SetPortrait()
	oPrint:StartPage()

	nLin := 50
	oPrint:Say(nLin,0050,cTitulo,oFont3)
	nLin += 100
	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0050,STR0079,oFont1) // "Nombre(s) y apellido(s) o nombre comercial del contribuyente"
	oPrint:Box(nLin,1750,nLin+80,2355)
	oPrint:Say(nLin+20,1770,STR0080,oFont2)  // "Nº Orden"

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,SM0->M0_NOMECOM,oFont2)
	oPrint:Box(nLin,1750,nLin+80,2355)
	oPrint:Say(nLin+20,1770,CValtoChar(MV_PAR13),oFont1)

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,1145)
	oPrint:Say(nLin+20,0040,STR0038,oFont1)//"NIT"
	oPrint:Box(nLin,1145,nLin+80,1750)
	oPrint:Say(nLin+20,1165,STR0037,oFont1)//"Periodo"
	oPrint:Box(nLin,1750,nLin+80,2030)
	oPrint:Say(nLin+20,1770,STR0081,oFont1)//"DD.JJ.ORIGINAL"
	oPrint:Box(nLin,2030,nLin+80,2355)
	oPrint:Say(nLin+20,2050,STR0082,oFont1)//"FOLIO"

	nLin += 80

	dbSelectArea("SA1")
	oPrint:Box(nLin,0020,nLin+80,1145)
	oPrint:Say(nLin+20,0040,Transform(SM0->M0_CGC,X3Picture("A1_CGC")),oFont2) // NIT
	oPrint:Box(nLin,1145,nLin+80,1295)
	oPrint:Say(nLin+20,1165,STR0083,oFont2) //"Mes"
	oPrint:Box(nLin,1295,nLin+80,1445)
	oPrint:Say(nLin+20,1315,AllTrim(Str(MV_PAR01)),oFont1)
	oPrint:Box(nLin,1445,nLin+80,1595)
	oPrint:Say(nLin+20,1465,STR0084,oFont2) // "Ano"
	oPrint:Box(nLin,1595,nLin+80,1750)
	oPrint:Say(nLin+20,1615,AllTrim(Str(MV_PAR02)),oFont1)
	oPrint:Box(nLin,1750,nLin+80,1885)
	oPrint:Say(nLin+20,1770,STR0085,oFont2) // 534
	oPrint:Box(nLin,1885,nLin+80,2030)
	oPrint:Say(nLin+20,1905,AllTrim(Str(MV_PAR22)),oFont1)
	oPrint:Box(nLin,2030,nLin+80,2355)
	oPrint:Say(nLin+20,2050,STR0086,oFont4) //"Ent. Financiera"

	nLin += 100

	oPrint:Box(nLin,0020,nLin+80,2355)
	oPrint:Say(nLin+20,0040,STR0087,oFont2) //"Datos básicos de la declaración jurada que rectifica"

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,0175)
	oPrint:Say(nLin+20,0040,STR0088,oFont2) // 518
	oPrint:Box(nLin,0175,nLin+80,0990)
	oPrint:Say(nLin+20,0195,CValtoChar(MV_PAR32),oFont1)
	oPrint:Box(nLin,0990,nLin+80,1145)
	oPrint:Say(nLin+20,1010,STR0089,oFont2) // 537
	oPrint:Box(nLin,1145,nLin+80,1445)
	oPrint:Say(nLin+20,1165,CValtoChar(MV_PAR23),oFont1)
	oPrint:Box(nLin,1445,nLin+80,1595)
	oPrint:Say(nLin+20,1465,CValtoChar(MV_PAR24),oFont1)
	oPrint:Box(nLin,1595,nLin+80,1750)
	oPrint:Say(nLin+20,1615,STR0090,oFont2) // 521
	oPrint:Box(nLin,1750,nLin+80,2355)
	oPrint:Say(nLin+20,1770,AllTrim(MV_PAR25),oFont1)

	nLin += 100

	oPrint:Box(nLin,0020,nLin+80,2355)
	oPrint:Say(nLin+20,0040,STR0091,oFont2) //"Determinación del saldo final a favor del tesoro o del contribuyente"

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,STR0151,oFont2) // "RUBRO 1: determinación del débito fiscal"
	oPrint:Box(nLin,1750,nLin+80,1900)
	oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
	oPrint:Box(nLin,1900,nLin+80,2355)
	oPrint:Say(nLin+20,1920,STR0094,oFont4) // "Bolivianos sin centavos"

	For nI:=1 To Len(aApur)

		nLin += 80
		nLin := FMudaPag(nLin)

		If nI == 11
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0152,oFont2) //"RUBRO 2: determinación del crédito tributario"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4) //"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 19
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0153,oFont2) // "RUBRO 3: determinación de la diferencia"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4) //"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 28
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0200,oFont2) //"RUBRO 4: Determinación de La Deuda Tributaria"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4) //"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 34
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0201,oFont2) //"RUBRO 5: Saldo Definitivo"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4) //"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 37
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0202,oFont2) //"RUBRO 6: Importe de Pago"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4) //"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 39
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0154,oFont2) //"RUBRO 7: datos informativos"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) // Cod
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4)  //"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		aTexto := QbrLin(aApur[nI,2],85)

		nTam := 80
		If Len(aApur[nI,2]) > 85
			oPrint:Say(nLin+70,0040,aTexto[2],oFont1)
			nTam := 130
		EndIf

		oPrint:Box(nLin,0020,nLin+nTam,1750)
		oPrint:Say(nLin+20,0040,aTexto[1],oFont1)

		oPrint:Box(nLin,1750,nLin+nTam,1900)
		oPrint:Say(nLin+20,1770,aApur[nI,3],oFont1)
		oPrint:Box(nLin,1900,nLin+nTam,2355)
		oPrint:Say(nLin+20,2000,AliDir(aApur[nI,4]),oFont1)

		If Len(aApur[nI,2]) > 85
			nLin += 50
		EndIf

	Next nI

	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,STR0195,oFont2)
	oPrint:Box(nLin,1750,nLin+80,1900)
	oPrint:Say(nLin+20,1770,STR0043,oFont2)
	oPrint:Box(nLin,1900,nLin+80,2355)
	oPrint:Say(nLin+20,1920,STR0094,oFont4)
	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+80,00495)
	oPrint:Say(nLin+20,0040,STR0100,oFont2)
	oPrint:Box(nLin,00495,nLin+80,0970)
	oPrint:Say(nLin+20,0515,STR0101,oFont2)
	oPrint:Box(nLin,0970,nLin+80,1445)
	oPrint:Say(nLin+20,0990,STR0102,oFont2)
	oPrint:Box(nLin,1445,nLin+160,1750)
	oPrint:Say(nLin+20,1465,STR0103,oFont2)
	oPrint:Box(nLin,1750,nLin+160,1900)
	oPrint:Say(nLin+20,1770,STR0104,oFont2)
	oPrint:Box(nLin,1900,nLin+160,2355)
	oPrint:Say(nLin+20,1920,CValtoChar(MV_PAR29),oFont1)

	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+80,00170)
	oPrint:Say(nLin+20,0040,STR0105,oFont2) // "8880"
	oPrint:Box(nLin,0170,nLin+80,0495)
	oPrint:Say(nLin+20,0190,CValtoChar(MV_PAR26),oFont1)
	oPrint:Box(nLin,0495,nLin+80,0645)
	oPrint:Say(nLin+20,0515,STR0106,oFont2) // "8882"
	oPrint:Box(nLin,0645,nLin+80,0970)
	oPrint:Say(nLin+20,0665,CValtoChar(MV_PAR27),oFont1)
	oPrint:Box(nLin,0970,nLin+80,1120)
	oPrint:Say(nLin+20,0990,STR0107,oFont2) //"8881"
	oPrint:Box(nLin,1120,nLin+80,1445)
	oPrint:Say(nLin+20,1140,CValtoChar(MV_PAR28),oFont1)

	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+200,1445)
	oPrint:Say(nLin+20,0040,STR0108,oFont1) //"Yo juro por la exactitud de esta declaración"
	oPrint:Line(nLin+150,0060,nLin+150,1300)
	oPrint:Box(nLin,1445,nLin+110,2355)
	oPrint:Say(nLin+20,1465,STR0109,oFont1) // "Aclaración de firma"
	oPrint:Say(nLin+70,1510,CValtoChar(MV_PAR30),oFont1)

	nLin += 110

	oPrint:Box(nLin,1445,nLin+090,2355)
	oPrint:Say(nLin+20,1465,STR0110,oFont1) // "C.I."
	oPrint:Say(nLin+20,1550,CValtoChar(MV_PAR31),oFont1)

	oPrint:EndPage()
	oPrint:Preview()
	oPrint:End()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImpRel400³ Autor ³ Leandro S Santos    ³ Data ³ 14.02.2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime apuracao formulario 400.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTitulo - Titulo do relatorio.                             ³±±
±±³          ³ aApur   - Array com os dados da apuracao.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel400(cTitulo,aApur)

	Local nI     := 0
	Local nLin   := 0
	Local nTam   := 0
	//Local lCabLF := .F.
	Local aTexto := {}
	Local cDtPago := dToS(MV_PAR24)

	cDtPago := Substr(cDtPago,7,2) + "/" + Substr(cDtPago,5,2) + "/" +  Substr(cDtPago,1,4)

	Private oFont1 := TFont():New("Verdana",,10,,.F.,,,,,.F.)
	Private oFont2 := TFont():New("Verdana",,10,,.T.,,,,,.F.)
	Private oFont3 := TFont():New("Verdana",,15,,.T.,,,,,.F.)
	Private oFont4 := TFont():New("Verdana",,08,,.T.,,,,,.F.)

	oPrint := TmsPrinter():New(cTitulo)
	oPrint:SetPaperSize(9)
	oPrint:SetPortrait()
	oPrint:StartPage()

	nLin := 50
	oPrint:Say(nLin,0050,cTitulo,oFont3)
	nLin += 100
	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0050,STR0079,oFont1) //"Nombre(s) y apellido(s) o razon social del contribuyente"
	oPrint:Box(nLin,1750,nLin+80,2355)
	oPrint:Say(nLin+20,1770,STR0080,oFont1) //"N.Orden"

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,SM0->M0_NOMECOM,oFont2)
	oPrint:Box(nLin,1750,nLin+80,2355)
	oPrint:Say(nLin+20,1770,MV_PAR13,oFont2)

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,1145)
	oPrint:Say(nLin+20,0040,STR0038,oFont1)//"NIT"
	oPrint:Box(nLin,1145,nLin+80,1750)
	oPrint:Say(nLin+20,1165,STR0037,oFont1)//"Periodo"
	oPrint:Box(nLin,1750,nLin+80,2030)
	oPrint:Say(nLin+20,1770,STR0081,oFont1)//"DD.JJ.ORIGINAL"
	oPrint:Box(nLin,2030,nLin+80,2355)
	oPrint:Say(nLin+20,2050,STR0082,oFont1)//"FOLIO"

	nLin += 80

	dbSelectArea("SA1")
	oPrint:Box(nLin,0020,nLin+80,1145)
	oPrint:Say(nLin+20,0040,Transform(SM0->M0_CGC,X3Picture("A1_CGC")),oFont2) // NIT
	oPrint:Box(nLin,1145,nLin+80,1295)
	oPrint:Say(nLin+20,1165,STR0083,oFont1)//"Mes"
	oPrint:Box(nLin,1295,nLin+80,1445)
	oPrint:Say(nLin+20,1315,AllTrim(Str(MV_PAR01)),oFont2)
	oPrint:Box(nLin,1445,nLin+80,1595)
	oPrint:Say(nLin+20,1465,STR0084,oFont1)//"Ano"
	oPrint:Box(nLin,1595,nLin+80,1750)
	oPrint:Say(nLin+20,1615,AllTrim(Str(MV_PAR02)),oFont2)
	oPrint:Box(nLin,1750,nLin+80,1885)
	oPrint:Say(nLin+20,1770,STR0085,oFont1) //"534"
	oPrint:Box(nLin,1885,nLin+80,2030)
	oPrint:Say(nLin+20,1905,"   ",oFont2)
	oPrint:Box(nLin,2030,nLin+80,2355)
	oPrint:Say(nLin+20,2050,STR0086,oFont4)//"Ent. financeira"

	nLin += 100

	oPrint:Box(nLin,0020,nLin+80,2355)
	oPrint:Say(nLin+20,0040,STR0087,oFont2)//"Datos basicos de la declaracion jurada que rectifica"

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,0175)
	oPrint:Say(nLin+20,0040,STR0088,oFont2) //"518"
	oPrint:Box(nLin,0175,nLin+80,0990)
	oPrint:Say(nLin+20,0195,MV_PAR14,oFont1)
	oPrint:Box(nLin,0990,nLin+80,1145)
	oPrint:Say(nLin+20,1010,STR0089,oFont2)//"537"
	oPrint:Box(nLin,1145,nLin+80,1445)
	oPrint:Say(nLin+20,1165,MV_PAR15,oFont1)
	oPrint:Box(nLin,1445,nLin+80,1595)
	oPrint:Say(nLin+20,1465,MV_PAR16,oFont1)
	oPrint:Box(nLin,1595,nLin+80,1750)
	oPrint:Say(nLin+20,1615,STR0090,oFont2)//"521"
	oPrint:Box(nLin,1750,nLin+80,2355)
	oPrint:Say(nLin+20,1770,MV_PAR17,oFont1)

	nLin += 100

	oPrint:Box(nLin,0020,nLin+80,2355)
	oPrint:Say(nLin+20,0040,STR0091,oFont2)//"Determinacion del saldo definitivo a favor del fisco o del contribuyente"

	nLin += 80

	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,STR0092,oFont2)//"RUBRO 1: Determinacion de la base imponible e impuesto"
	oPrint:Box(nLin,1750,nLin+80,1900)
	oPrint:Say(nLin+20,1770,STR0093,oFont2)//"Cod"
	oPrint:Box(nLin,1900,nLin+80,2355)
	oPrint:Say(nLin+20,1920,STR0094,oFont4)//"Bolivianos sin centavos"

	For nI:=1 To Len(aApur)

		nLin += 80
		nLin := FMudaPag(nLin)

		If nI == 5
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0095,oFont2)//"RUBRO 2: Determinacion del saldo"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2)//"Cod"
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4)//"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 11
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0096,oFont2)//"RUBRO 3: Determinacion de la deuda tributaria"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2) //"Cod"
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4)//"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 17
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0097,oFont2)//"RUBRO 4: Saldo definitivo"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2)//"Cod"
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4)//"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		If nI == 20
			oPrint:Box(nLin,0020,nLin+80,1750)
			oPrint:Say(nLin+20,0040,STR0098,oFont2)//"RUBRO 5: Importe pago"
			oPrint:Box(nLin,1750,nLin+80,1900)
			oPrint:Say(nLin+20,1770,STR0093,oFont2)//"Cod"
			oPrint:Box(nLin,1900,nLin+80,2355)
			oPrint:Say(nLin+20,1920,STR0094,oFont4)//"Bolivianos sin centavos"
			nLin += 80
			nLin := FMudaPag(nLin)
		EndIf

		aTexto := QbrLin(aApur[nI,2],90)

		nTam := 80
		If Len(aApur[nI,2]) > 90
			oPrint:Say(nLin+70,0040,aTexto[2],oFont1)
			nTam := 130
		EndIf

		oPrint:Box(nLin,0020,nLin+nTam,1750)
		oPrint:Say(nLin+20,0040,aTexto[1],oFont1)

		oPrint:Box(nLin,1750,nLin+nTam,1900)
		oPrint:Say(nLin+20,1770,aApur[nI,3],oFont1)
		oPrint:Box(nLin,1900,nLin+nTam,2355)
		oPrint:Say(nLin+20,2000,AliDir(aApur[nI,4]),oFont1)

		If Len(aApur[nI,2]) > 90
			nLin += 50
		EndIf

	Next nI

	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,STR0099,oFont2)//"RUBRO 6: Datos pago sigma"
	oPrint:Box(nLin,1750,nLin+80,1900)
	oPrint:Say(nLin+20,1770,STR0093,oFont2)//"Cod"
	oPrint:Box(nLin,1900,nLin+80,2355)
	oPrint:Say(nLin+20,1920,STR0094,oFont4)//"Bolivianos sin centavos"
	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+80,00495)
	oPrint:Say(nLin+20,0040,STR0100,oFont2)//"N° C-31:"
	oPrint:Box(nLin,00495,nLin+80,0970)
	oPrint:Say(nLin+20,0515,STR0101,oFont2)//"N° de pago: "
	oPrint:Box(nLin,0970,nLin+80,1445)
	oPrint:Say(nLin+20,0990,STR0102,oFont2)//"Confirm.Pago:"
	oPrint:Box(nLin,1445,nLin+160,1750)
	oPrint:Say(nLin+20,1465,STR0103,oFont2)//"Imp.Pag.SIGMA"
	oPrint:Box(nLin,1750,nLin+160,1900)
	oPrint:Say(nLin+20,1770,STR0104,oFont2)//"8883"
	oPrint:Box(nLin,1900,nLin+160,2355)
	oPrint:Say(nLin+20,1920,cValtoChar(MV_PAR25),oFont1)

	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+80,00170)
	oPrint:Say(nLin+20,0040,STR0105,oFont2)//"8880"
	oPrint:Box(nLin,0170,nLin+80,0495)
	oPrint:Say(nLin+20,0190,MV_PAR22,oFont1)
	oPrint:Box(nLin,0495,nLin+80,0645)
	oPrint:Say(nLin+20,0515,STR0106,oFont2)//"8882"
	oPrint:Box(nLin,0645,nLin+80,0970)
	oPrint:Say(nLin+20,0665,MV_PAR23,oFont1)
	oPrint:Box(nLin,0970,nLin+80,1120)
	oPrint:Say(nLin+20,0990,STR0107,oFont2)//"8881"
	oPrint:Box(nLin,1120,nLin+80,1445)
	oPrint:Say(nLin+20,1140,cDtPago,oFont1)

	nLin += 80
	nLin := FMudaPag(nLin)

	oPrint:Box(nLin,0020,nLin+200,1445)
	oPrint:Say(nLin+20,0040,STR0108,oFont1)//"Juro la exactitud de la presente declaracion"
	oPrint:Line(nLin+150,0060,nLin+150,1300)
	oPrint:Box(nLin,1445,nLin+110,2355)
	oPrint:Say(nLin+20,1465,STR0109,oFont1)//"Aclaracion de Firma"
	oPrint:Say(nLin+70,1510,MV_PAR26,oFont1)

	nLin += 110

	oPrint:Box(nLin,1445,nLin+090,2355)
	oPrint:Say(nLin+20,1465,STR0110,oFont1)//"C.I."
	oPrint:Say(nLin+20,1550,MV_PAR27,oFont1)

	oPrint:EndPage()
	oPrint:Preview()
	oPrint:End()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImpRel410³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime apuracao formulario 410.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTitulo - Titulo do relatorio.                             ³±±
±±³          ³ aApur   - Array com os dados da apuracao.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel410(cTitulo,aApur)

	Local nI     := 0
	Local nLin   := 0
	Local nTam   := 0
	Local lCabLF := .F.
	Local aTexto := {}

	Private oFont1 := TFont():New("Verdana",,10,,.F.,,,,,.F.)
	Private oFont2 := TFont():New("Verdana",,10,,.T.,,,,,.F.)
	Private oFont3 := TFont():New("Verdana",,15,,.T.,,,,,.F.)

	oPrint := TmsPrinter():New(cTitulo)
	oPrint:SetPaperSize(9)
	oPrint:SetPortrait()
	oPrint:StartPage()

	nLin := 50
	oPrint:Say(nLin,0050,cTitulo,oFont3)
	nLin += 70
	oPrint:Say(nLin,0050,STR0036,oFont1)//"Declaracao Jurada Mensal"

	oPrint:Box(nLin,1900,0280,2355)
	oPrint:Say(nLin+20,1920,STR0037,oFont1)//"Periodo"

	nLin += 80
	oPrint:Box(nLin,0020,nLin+80,0450)
	oPrint:Say(nLin+20,0040,STR0038,oFont1)//"NIT"
	oPrint:Box(nLin,0450,nLin+80,1900)
	oPrint:Say(nLin+20,0470,STR0039,oFont1)//"Razao social"
	oPrint:Box(nLin,1900,nLin+80,2100)
	oPrint:Say(nLin+20,1920,STR0040,oFont2)//"Mes"
	oPrint:Box(nLin,2100,nLin+80,2355)
	oPrint:Say(nLin+20,2120,STR0041,oFont2)//"Ano"

	nLin += 80
	dbSelectArea("SA1")
	oPrint:Box(nLin,0020,nLin+80,0450)
	oPrint:Say(nLin+20,0040,Transform(SM0->M0_CGC,X3Picture("A1_CGC")),oFont1)
	oPrint:Box(nLin,0450,nLin+80,1900)
	oPrint:Say(nLin+20,0470,SM0->M0_NOMECOM,oFont1)
	oPrint:Box(nLin,1900,nLin+80,2100)
	oPrint:Say(nLin+20,1920,AllTrim(Str(MV_PAR01)),oFont2)
	oPrint:Box(nLin,2100,nLin+80,2355)
	oPrint:Say(nLin+20,2120,AllTrim(Str(MV_PAR02)),oFont2)

	nLin += 100
	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,STR0042,oFont2)//"Dados basicos da declaração jurada a favor da FISCO ou do contribuinte."
	oPrint:Box(nLin,1750,nLin+80,1900)
	oPrint:Say(nLin+20,1770,STR0043,oFont2)//"Cód"
	oPrint:Box(nLin,1900,nLin+80,2355)
	oPrint:Say(nLin+20,1920,STR0044,oFont2)//"Importe"

	For nI:=1 To Len(aApur)

		nLin += 80
		nLin := FMudaPag(nLin)

		If !lCabLF .and. aApur[nI,1] == 2
			oPrint:Box(nLin,0020,nLin+80,2355)
			oPrint:Say(nLin+20,0040,STR0045,oFont2)//"Liquidação do imposto"
			nLin += 80
			nLin := FMudaPag(nLin)
			lCabLF := .T.
		EndIf

		aTexto := QbrLin(aApur[nI,2],85)

		nTam := 80
		If Len(aApur[nI,2]) > 85
			oPrint:Say(nLin+70,0040,aTexto[2],oFont1)
			nTam := 130
		EndIf

		oPrint:Box(nLin,0020,nLin+nTam,1750)
		oPrint:Say(nLin+20,0040,aTexto[1],oFont1)

		oPrint:Box(nLin,1750,nLin+nTam,1900)
		oPrint:Say(nLin+20,1770,aApur[nI,3],oFont1)
		oPrint:Box(nLin,1900,nLin+nTam,2355)
		oPrint:Say(nLin+20,2000,AliDir(aApur[nI,4]),oFont1)

		If Len(aApur[nI,2]) > 85
			nLin += 50
		EndIf

	Next nI

	oPrint:EndPage()
	oPrint:Preview()
	oPrint:End()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImpRel570³ Autor ³ Denar Terrazas      ³ Data ³ 21.12.2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime formulario 570.                           		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTitulo - Titulo do relatorio.                             ³±±
±±³          ³ aApur   - Array com os dados da apuracao.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel570(cTitulo,aApur)

	Local nI	:= 0
	Local nLin	:= 0
	Local nTam	:= 0
	Local lCabLF:= .F.
	Local aTexto:= {}
	Local cTitC	:= "Determinación del saldo definitivo a favor del fisco o del contribuyente"

	Private oFont1 := TFont():New("Verdana",,10,,.F.,,,,,.F.)
	Private oFont2 := TFont():New("Verdana",,10,,.T.,,,,,.F.)
	Private oFont3 := TFont():New("Verdana",,15,,.T.,,,,,.F.)

	oPrint := TmsPrinter():New(cTitulo)
	oPrint:SetPaperSize(9)
	oPrint:SetPortrait()
	oPrint:StartPage()

	nLin := 50
	oPrint:Say(nLin,0050,cTitulo,oFont3)
	nLin += 70
	oPrint:Say(nLin,0050,STR0036,oFont1)//"Declaracao Jurada Mensal"

	oPrint:Box(nLin,1900,0280,2355)
	oPrint:Say(nLin+20,1920,STR0037,oFont1)//"Periodo"

	nLin += 80
	oPrint:Box(nLin,0020,nLin+80,0450)
	oPrint:Say(nLin+20,0040,STR0038,oFont1)//"NIT"
	oPrint:Box(nLin,0450,nLin+80,1900)
	oPrint:Say(nLin+20,0470,STR0039,oFont1)//"Razao social"
	oPrint:Box(nLin,1900,nLin+80,2100)
	oPrint:Say(nLin+20,1920,STR0040,oFont2)//"Mes"
	oPrint:Box(nLin,2100,nLin+80,2355)
	oPrint:Say(nLin+20,2120,STR0041,oFont2)//"Ano"

	nLin += 80
	dbSelectArea("SA1")
	oPrint:Box(nLin,0020,nLin+80,0450)
	oPrint:Say(nLin+20,0040,TRIM(SM0->M0_CGC)/*Transform(SM0->M0_CGC,X3Picture("A1_CGC"))*/,oFont1)
	oPrint:Box(nLin,0450,nLin+80,1900)
	oPrint:Say(nLin+20,0470,SM0->M0_NOMECOM,oFont1)
	oPrint:Box(nLin,1900,nLin+80,2100)
	oPrint:Say(nLin+20,1920,AllTrim(Str(MV_PAR01)),oFont2)
	oPrint:Box(nLin,2100,nLin+80,2355)
	oPrint:Say(nLin+20,2120,AllTrim(Str(MV_PAR02)),oFont2)

	nLin += 100
	oPrint:Box(nLin,0020,nLin+80,1750)
	oPrint:Say(nLin+20,0040,cTitC,oFont2)
	oPrint:Box(nLin,1750,nLin+80,1900)
	oPrint:Say(nLin+20,1770,STR0043,oFont2)//"Cód"
	oPrint:Box(nLin,1900,nLin+80,2355)
	oPrint:Say(nLin+20,1920,STR0044,oFont2)//"Importe"

	For nI:=1 To Len(aApur)

		nLin += 80
		nLin := FMudaPag(nLin)

		If !lCabLF .and. aApur[nI,1] == 3
			oPrint:Box(nLin,0020,nLin+80,2355)
			oPrint:Say(nLin+20,0040,STR0045,oFont2)//"Liquidação do imposto"
			nLin += 80
			nLin := FMudaPag(nLin)
			lCabLF := .T.
		EndIf

		aTexto := QbrLin(aApur[nI,2],85)

		nTam := 80
		If Len(aApur[nI,2]) > 85
			oPrint:Say(nLin+70,0040,aTexto[2],oFont1)
			nTam := 130
		EndIf

		oPrint:Box(nLin,0020,nLin+nTam,1750)
		oPrint:Say(nLin+20,0040,aTexto[1],oFont1)

		oPrint:Box(nLin,1750,nLin+nTam,1900)
		oPrint:Say(nLin+20,1770,aApur[nI,3],oFont1)
		oPrint:Box(nLin,1900,nLin+nTam,2355)
		oPrint:Say(nLin+20,2000,AliDir(aApur[nI,4]),oFont1)

		If Len(aApur[nI,2]) > 85
			nLin += 50
		EndIf

	Next nI

	oPrint:EndPage()
	oPrint:Preview()
	oPrint:End()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QbrLin   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 24.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a qubra do texto de acordo com o tamanho passado pelo  ³±±
±±³          ³ parametro.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTxt - Texto a ser feito a quebra.                         ³±±
±±³          ³ nLen - Tamanho do texto para a quebra.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aTxt - Array com as linhas de texto.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QbrLin(cTxt,nLen)

	Local nI   := 1
	Local aTxt := {}

	If Len(cTxt) > nLen
		For nI:=nLen To 1 Step -1
			If SubStr(cTxt,nI,1) == " "
				Exit
			EndIf
		Next nI
		aAdd(aTxt,SubStr(cTxt,1,nI))
		aAdd(aTxt,SubStr(cTxt,nI+1,Len(cTxt)))
	Else
		aAdd(aTxt,cTxt)
	EndIf

Return aTxt

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FMudaPag ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a mudanca de pagina se nescesario.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLin - Linha atual da impressao.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aApur - Vetor com os valores da apuracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FMudaPag(nLin)

	If (nLin+80) >= 3350
		nLin := 50
		oPrint:EndPage()
		oPrint:StartPage()
	EndIf

Return nLin

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AliDir   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz alinhamento do valor a direita.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nVal - Valor a ser alinhado.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cRet - Valor alinhado.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AliDir(nVal)

	Local cRet     := ""
	Local cPict := "@E 999,999,999"

	If Len(Alltrim(Str(Int(nVal))))==9
		cRet:=PADL(" ",1," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==8
		cRet:=PADL(" ",3," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==7
		cRet:=PADL(" ",5," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==6
		cRet:=PADL(" ",8," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==5
		cRet:=PADL(" ",10," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==4
		cRet:=PADL(" ",12," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==3
		cRet:=PADL(" ",15," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==2
		cRet:=PADL(" ",17," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==1
		cRet:=PADL(" ",19," ")+alltrim(Transform(nVal,cPict))
	EndIf

Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³DelTitApur³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Deleta o titulo da apuracao.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cNomeArq - Arquivo da apuracao com os dados do titulo a    ³±±
±±³          ³            ser excluido.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lRet - Indica se o titulo foi ou nao deletado.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DelTitApur(cNomArq)

	Local   lRet        := .T.
	Local   cBuffer     := ""
	Local   aLin        := {}
	Local   aDadosSE2   := {}
	Private lMsErroAuto := .F.

	If FT_FUSE(cNomArq) <> -1
		FT_FGOTOP()
		Do While !FT_FEOF()
			cBuffer := FT_FREADLN()
			If Substr(cBuffer,1,3) == "TIT"
				aLin := Separa(cBuffer,";")
				dbSelectArea("SE2")
				SE2->(dbGoTop())
				SE2->(dbSetOrder(1))
				If SE2->(dbSeek(xFilial("SE2")+aLin[2]+aLin[3]))
					If SE2->E2_VALOR <> SE2->E2_SALDO //Já foi dado Baixa no Título
						lRet := .F.
					Else
						aAdd(aDadosSE2,{"E2_FILIAL" ,xFilial("SE2"),nil})
						aAdd(aDadosSE2,{"E2_PREFIXO",SE2->E2_PREFIXO,nil})
						aAdd(aDadosSE2,{"E2_NUM"    ,SE2->E2_NUM,nil})
						aAdd(aDadosSE2,{"E2_PARCELA",SE2->E2_PARCELA,nil})
						aAdd(aDadosSE2,{"E2_TIPO"   ,SE2->E2_TIPO,nil})
						aAdd(aDadosSE2,{"E2_FORNECE",SE2->E2_FORNECE,nil})
						aAdd(aDadosSE2,{"E2_LOJA"   ,SE2->E2_LOJA,nil})

						MsExecAuto({|x,y,z| FINA050(x,y,z)},aDadosSE2,,5)
						If lMsErroAuto
							MostraErro()
							lRet := .F.
						EndIf
					EndIf
				Endif
			EndIF
			FT_FSKIP()
		EndDo
	Else
		Alert(STR0046)//"Erro na abertura do arquivo"
		Return Nil
	EndIF
	FT_FUSE()

	If lRet
		fErase(cNomArq)
	Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CriarArq ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria arquivo da apuracao.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cDir     - Diretorio do arquivo a ser gerado.              ³±±
±±³          ³ cArq     - Nome do arquivo a ser gerado.                   ³±±
±±³          ³ aDados   - Dados do arquivo a ser gerdado.                 ³±±
±±³          ³ aTitulos - Array com os dados do titulo gerado.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aApur - Vetor com os valores da apuracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriarArq(cDir,cArq,aDados,aTitulos)

	Local nHdl   := 0
	Local nlX    := 0
	Local cLinha := ""
	Local cApur  := ""

	Do Case
	Case nF032Apur == 1
		cApur := "IVA"
	Case nF032Apur == 2
		cApur := "ITR"
	Case nF032Apur == 3
		cApur := "ITC"
	EndCase

	nHdl := fCreate(cDir+cArq)
	If nHdl <= 0
		//ApMsgStop(STR0057)//"Ocorreu um erro ao criar o arquivo."
	Endif

	cLinha := cApur
	For nlX := 1 to Len(aDados)
		cLinha += ";"+AllTrim(Str(aDados[nlX,4]))
	Next nlX
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha)

	If Len(aTitulos) > 0
		cLinha := "TIT"
		For nlX := 1 to Len(aTitulos)
			cLinha += ";"
			If ValType(aTitulos[nlX]) == "N"
				cLinha += AllTrim(Str(aTitulos[nlX]))
			Else
				cLinha += AllTrim(aTitulos[nlX])
			EndIf
		Next nlX
		cLinha += chr(13)+chr(10)
		fWrite(nHdl,cLinha)
	EndIf

	If nHdl > 0
		fClose(nHdl)
	Endif

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FMApur   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna os valores de um arquivo de apuracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cDir     - Diretorio do arquivo a ser importado.           ³±±
±±³          ³ cArq     - Nome do arquivo a ser importado.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aDados - Dados do arquivo importado.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FMApur(cDir,cNomArq)

	Local nlI    := 0
	Local cLinha := ""
	Local cApur  := ""
	Local aAux   := {}
	Local aDados := {}

	Do Case
	Case nF032Apur == 1
		cApur := "IVA"
	Case nF032Apur == 2
		cApur := "ITR"
	Case nF032Apur == 3
		cApur := "ITC"
	EndCase

	IF FT_FUSE(cDir+cNomArq) <> -1
		FT_FGOTOP()
		Do While !FT_FEOF()
			cLinha := FT_FREADLN()
			If SubStr(cLinha,1,4) == cApur+";"
				cLinha := SubStr(cLinha,5,Len(cLinha))
				aAux := Separa(cLinha,";")
			EndIf
			FT_FSKIP()
		EndDo
		FT_FUSE()
	EndIf

	For nlI:=1 To Len(aAux)
		aAdd(aDados,Val(aAux[nlI]))
	Next nlI

Return aDados

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ApurIUE  ³ Autor ³ Denar Terrazas      ³ Data ³ 21.12.2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carga valores para las IUE Retenciones.		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aFiliais - Array com as filiais selecionadas.              ³±±
±±³          ³ aApuAnt  - Array com os dados da apuracao anterior.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aApur - Vetor com os valores da apuracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ApurIUE(aFiliais,aApuAnt)

	Local nI		:= 0
	Local cQry		:= ""
	Local aApur		:= {}
	Local aDados	:= {}

	Local cTes010	:= "010" //COMPRA LOCAL RET S/G
	Local cTes020	:= "020" //COMPRA LOCAL RET C/G
	Local cTes011	:= "011" //COMPRA SER. RET S/G
	Local cTes021	:= "021" //COMPRA SER. RET C/G

	Local cIUE001	:= "Importe cancelado por servicios"
	Local cIUE002	:= "Importe cancelado por adquisiciones"
	Local cIUE003	:= "Importe sujeto a impuesto (50% sobre el importe de la casilla C013)"
	Local cIUE004	:= "Importe sujeto a impuesto (20% sobre el importe de la casilla C026)"
	Local cIUE005	:= "Impuesto determinado (25% sobre (C1001 + C1002))"
	Local cIUE006	:= "Pagos a cuenta reaizados en DD.JJ. anterior o en Boletas de Pago"
	Local cIUE007	:= "Saldo disponible de pagos del periodo anterior a compensar"
	Local cIUE008	:= "Diferencia a favor del contribuyente para el siguiente periodo(C622 + C640 - C909; Si > 0)"
	Local cIUE009	:= "Saldo definitivo a favor del Fisco (C909 - C622 - C640; Si > 0)"
	Local cIUE010	:= "Imputación de crédito en valores (Sujero a verificación y confirmación por parte del S.I.N.)"
	Local cIUE011	:= "Impuesto a pagar en efectivo (C996 - C677; Si > 0), (Si la presentación y/o pago es fuera de término, debe liquidar la Deuda Trubutaria)"

	For nI:=1 To 11
		aAdd(aDados,0)
	Next nI

	cQry := " SELECT"
	cQry += " SF3.F3_TES, "
	cQry += " CASE "
	cQry += " WHEN SF3.F3_TES = '" + cTes010 + "' THEN SUM(SF3.F3_BASIMP3)"
	cQry += " WHEN SF3.F3_TES = '" + cTes020 + "' THEN SUM(SF3.F3_BASIMP3) + SUM(SF3.F3_VALIMP2) + SUM(SF3.F3_VALIMP3)"
	cQry += " WHEN SF3.F3_TES = '" + cTes011 + "' THEN SUM(SF3.F3_BASIMP3)"
	cQry += " WHEN SF3.F3_TES = '" + cTes021 + "' THEN SUM(SF3.F3_BASIMP3) + SUM(SF3.F3_VALIMP2) + SUM(SF3.F3_VALIMP3)"
	cQry += " ELSE 0"
	cQry += " END AS VALIMP"
	cQry += " FROM "+RetSqlName("SF3")+" SF3"
	cQry += " WHERE SF3.D_E_L_E_T_ = ' '"
	cQry += " AND ( SF3.F3_FILIAL = '"+Space(TamSX3("F3_FILIAL")[1])+"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
			cQry += " OR SF3.F3_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQry += " )"
	cQry += " AND SF3.F3_EMISSAO LIKE '"+AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+"%'"
	cQry += " AND SF3.F3_TIPOMOV = 'C'"
	cQry += " AND SF3.F3_TES IN ('" + cTes010 + "', '" + cTes020  + "', '" + cTes011 + "', '" + cTes021 + "')"
	cQry += " GROUP BY SF3.F3_TES"

	TcQuery cQry New Alias "QRY"

	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		If( QRY->F3_TES $ (cTes011 + "|" + cTes021) )
			aDados[1] += QRY->VALIMP
		ElseIf( QRY->F3_TES $ (cTes010 + "|" + cTes020) )
			aDados[2] += QRY->VALIMP
		EndIf
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

	aDados[3] := aDados[1] * (50/100)
	aDados[4] := aDados[2] * (20/100)

	aDados[5] := (aDados[3] + aDados[4]) * (25/100)

	aDados[6] := MV_PAR06
	aDados[7] := MV_PAR07

	aDados[8] := aDados[6] + aDados[7] - aDados[5]
	If(aDados[8] <= 0)
		aDados[8] := 0
	EndIf

	aDados[9] := aDados[5] - aDados[6] - aDados[7]
	If(aDados[9] <= 0)
		aDados[9] := 0
	EndIf

	aDados[10] := MV_PAR08

	If(aDados[9] > aDados[10])
		aDados[11] := aDados[9] - aDados[10]
	EndIf

	aAdd(aApur,{1,cIUE001,"013",aDados[01]})//"Importe cancelado por servicios"
	aAdd(aApur,{2,cIUE002,"026",aDados[02]})//"Importe cancelado por adquisiciones"
	aAdd(aApur,{2,cIUE003,"1001",aDados[03]})//"Importe sujeto a impuesto (50% sobre el importe de la casilla C013)"
	aAdd(aApur,{2,cIUE004,"1002",aDados[04]})//"Importe sujeto a impuesto (20% sobre el importe de la casilla C026)"
	aAdd(aApur,{3,cIUE005,"909",aDados[05]})//"Impuesto determinado (25% sobre (C1001 + C1002))"
	aAdd(aApur,{3,cIUE006,"622",aDados[06]})//"Pagos a cuenta reaizados en DD.JJ. anterior o en Boletas de Pago"
	aAdd(aApur,{3,cIUE007,"640",aDados[07]})//"Saldo disponible de pagos del periodo anterior a compensar"
	aAdd(aApur,{3,cIUE008,"747",aDados[08]})//"Diferencia a favor del contribuyente para el siguiente periodo(C622 + C640 - C909; Si > 0)"
	aAdd(aApur,{3,cIUE009,"996",aDados[09]})//"Saldo definitivo a favro del Fisco (C909 - C622 - C640; Si > 0)"
	aAdd(aApur,{3,cIUE010,"677",aDados[10]})//"Imputación de crédito en valores (Sujero a verificación y confirmación por parte del S.I.N.)"
	aAdd(aApur,{3,cIUE011,"576",aDados[11]})//"Impuesto a pagar en efectivo (C996 - C677; Si > 0), (Si la presentación y/o pago es fuera de término, debe liquidar la Deuda Trubutaria)"

Return aApur

/**
*
* @author: Denar Terrazas Parada
* @since: 09/02/2021
* @description: Funcion que retorna la Actualización de valor en el saldo del crédito fiscal del período anterior(648)
* @update: 01/06/2022 Crear campo tipo lógico M2_XAMEUFV - Actuali. Mes - Actualizacón Mensual
* @parameters: nValor -> Saldo de Crédito Fiscal del periodo anterior a compensar(635)
*/
static function getValorActualizado(nValor)
	Local aArea			:= getArea()
	Local aliasQuery	:= GetNextAlias()
	Local aliasQuery2	:= GetNextAlias()
	Local nRet			:= 0
	Local cData1		:= '' //Ultimo día periodo anterior
	Local cData2		:= '' //Ultimo día periodo actual
	Local nUFV1			:= 0
	Local nUFV2			:= 0

	// Obtener UFV mes anterior
	dData2:= LastDate( STOD(AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+'01') )
	dData1:= FirstDate( MonthSub(dData2,1) )
	dData2:= LastDate( MonthSub(dData2,1) )
	cData1:= DTOS(dData1)
	cData2:= DTOS(dData2)

	BeginSql Alias aliasQuery

		SELECT TOP 2 M2_DATA, M2_MOEDA4
		FROM SM2010 SM2
		WHERE M2_DATA BETWEEN %exp:(cData1)% AND %exp:(cData2)%
		AND SM2.%notdel% AND SM2.M2_XAMEUFV = 'T'
		ORDER BY 1

	EndSql

	DbSelectArea(aliasQuery)
	If (aliasQuery)->(!Eof())
		nUFV1:= (aliasQuery)->M2_MOEDA4
		/*While !(aliasQuery)->(Eof())
			If( (aliasQuery)->M2_DATA ==  cData1 )
				nUFV1:= (aliasQuery)->M2_MOEDA4
			ElseIf( (aliasQuery)->M2_DATA ==  cData2 )
				nUFV2:= (aliasQuery)->M2_MOEDA4
			EndIf
			(aliasQuery)->(dbSkip())
		Enddo*/
	EndIf
	(aliasQuery)->(dbCloseArea())

	If(nUFV1 == 0)
		alert("No se encuentra valor UFV par el mes " + cValToChar(month(dData1)) + ". Verificar en rutina Moneda.")
	EndIf

	// Obtener UFV mes actual
	dData1:= STOD(AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+'01')
	dData2:= LastDate( STOD(AllTrim(StrZero(MV_PAR02,4))+AllTrim(StrZero(MV_PAR01,2))+'01') )
	cData1:= DTOS(dData1)
	cData2:= DTOS(dData2)

	BeginSql Alias aliasQuery2

		SELECT TOP 2 M2_DATA, M2_MOEDA4
		FROM SM2010 SM2
		WHERE M2_DATA BETWEEN %exp:(cData1)% AND %exp:(cData2)%
		AND SM2.%notdel% AND SM2.M2_xAMEUFV = 'T'
		ORDER BY 1

	EndSql

	DbSelectArea(aliasQuery2)
	If (aliasQuery2)->(!Eof())
		nUFV2:= (aliasQuery2)->M2_MOEDA4
	EndIf
	(aliasQuery2)->(dbCloseArea())

	If(nUFV2 == 0)
		alert("No se encuentra valor UFV par el mes " + cValToChar(month(dData1)) + ". Verificar en rutina Moneda.")
	EndIf

	If(nUFV1 > 0 .AND. nUFV2 > 0)
		nRet:= (nUFV2 / nUFV1) - 1
		nRet:= nRet * nValor
	EndIf
	restArea(aArea)
return nRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿Mes de cálculo?"	, "¿Mes de cálculo?"	,"¿Mes de cálculo?"	,"MV_CH1","N",02,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Año de cálculo?" 	, "¿Año de cálculo?"	,"¿Año de cálculo?"	,"MV_CH2","N",04,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿Sel. Sucursales?"	, "¿Sel. Sucursales?"	,"¿Sel. Sucursales?","MV_CH3","N",01,0,1,"C","","","","","MV_PAR03","Si","Si","Si","","No","No","No")
	xPutSX1(cPerg,"04","¿Fecha Título?"		, "¿Fecha Título?"		,"¿Fecha Título?"	,"MV_CH4","D",08,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿Genera título?"	, "¿Genera título?"		,"¿Genera título?"	,"MV_CH5","N",01,0,1,"C","","","","","MV_PAR05","Si","Si","Si","","No","No","No")
	xPutSX1(cPerg,"06","¿Pagos DDJJ Ant. ?" 	, "¿Pagos DDJJ Ant. ?"	,"¿Pagos DDJJ Ant. ?"	,"MV_CH6","N",09,0,0,"G","","","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿Saldo Ant. Comp. ?" 	, "¿Saldo Ant. Comp. ?"	,"¿Saldo Ant. Comp. ?"	,"MV_CH7","N",09,0,0,"G","","","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿Inp. Créd. Val. ?" 	, "¿Inp. Créd. Val. ?"	,"¿Inp. Créd. Val. ?"	,"MV_CH8","N",09,0,0,"G","","","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")

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
