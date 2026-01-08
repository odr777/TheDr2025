#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FISA032.CH"

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
Function FISA032()

	Local   nValTit   := 0
	Local   lOk       := .F.
	Local   cApur     := ""
	Local   cPerg     := ""
	Local   aApur     := {}
	Local   aApuAnt   := {}
	Local   aFiliais  := {}
	Local   aTitulos  := {}
	Local   aCombo    := {STR0001,STR0002,STR0048}//"IVA - Formulário 200"###"IT - Formulário 400"###"IT Retenções - Formulário 410"
	Private nF032Apur := 0
	
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
		nF032Apur := aScan(aCombo,{|x| x == cApur})
		
		if nF032Apur == 3
			cPerg := "FISA032"  //11 preguntas
		else
			cPerg := "FISA032a" //12 preguntas
		endif
		
		If Pergunte(cPerg,.T.)
		
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
				Case nF032Apur == 2
					aApur := ApurIT(aFiliais,aApuAnt) //Apuracao do IT 400
				Case nF032Apur == 3
					aApur := ApurITR(aFiliais,aApuAnt) //Apuracao do IT Retencoes 410
				OtherWise
					MsgAlert(STR0009)//"Selecione uma apuração."
			EndCase	
			
			//Imprime a apuracao
			ImpRel(cApur,aApur)
			
			//Gera titulo da apuracao
			If MV_PAR05 == 1
				nValTit := Round(aApur[Len(aApur)][4],0)
				MsgRun(STR0010,,{|| IIf(nValTit>0,aTitulos := GrvTitLoc(nValTit),Nil) })//"Gerando titulo de apuração..."
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
	
	//Query
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

	Local nI     := 0
	Local cQry   := ""
	Local aApur  := {}
	Local aDados := {}
    
	For nI:=1 To 13	
		aAdd(aDados,0)
	Next nI
	
	//Query
	cQry := " SELECT"
	cQry += "  SF3.F3_TIPOMOV"
	cQry += " ,SUM(SF3.F3_BASIMP1) AS BASIMP"
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
	cQry += " GROUP BY SF3.F3_TIPOMOV"
	
	TcQuery cQry New Alias "QRY"
	
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		If QRY->F3_TIPOMOV == "V"
			aDados[1] += QRY->BASIMP
		Else
			aDados[2] += QRY->BASIMP
		EndIf
		QRY->(dbSkip())
	EndDo	
	QRY->(dbCloseArea())
	
	If Len(aApuAnt) > 4
		aDados[05] := aApuAnt[6]		
	Else
		aDados[05] := MV_PAR09
	EndIf
	aDados[08] := MV_PAR10
	If Len(aApuAnt) > 8
		aDados[09] := aApuAnt[10]		
	Else
		aDados[09] := MV_PAR11
	EndIf
	aDados[12] := MV_PAR12
	
	If (aDados[2] - aDados[1]) > 0
		aDados[3] := (aDados[2] - aDados[1]) * 0.13
	EndIf
	
	If (aDados[1] - aDados[2]) > 0
		aDados[4] := (aDados[1] - aDados[2]) * 0.13
	EndIf
	
	If (aDados[3] + aDados[5] - aDados[4]) > 0
		aDados[6] := (aDados[3] + aDados[5] - aDados[4])
	EndIf
	
	If (aDados[4] - aDados[3] - aDados[5]) > 0
		aDados[7] := (aDados[4] - aDados[3] - aDados[5])
	EndIf
	
	If (aDados[8] + aDados[9] - aDados[7]) > 0
		aDados[10] := (aDados[8] + aDados[9] - aDados[7])
	EndIf
	
	If (aDados[7] - aDados[8] - aDados[9]) > 0
		aDados[11] := (aDados[7] - aDados[8] - aDados[9])
	EndIf

	If (aDados[11] - aDados[12]) > 0
		aDados[13] := (aDados[11] - aDados[12])
	EndIf
	
	aAdd(aApur,{1,STR0012, "013",aDados[01]})//"Vendas e/ou serviços faturados mas serviços relacionados, descontos devoluciones e outros autorizados."
	aAdd(aApur,{1,STR0013, "026",aDados[02]})//"Compras e importações vinculadas com operações gravadas mas serviços relacionados, descontos, devoluções e outros autorizados"
	aAdd(aApur,{1,STR0014, "693",aDados[03]})//"Saldo a favor do contribuinte no período (13% de (C026 - C013); Se > 0)."
	aAdd(aApur,{1,STR0015, "909",aDados[04]})//"Imposto determinado no período (13% de (C013 - C026); Se > 0)."
	aAdd(aApur,{2,STR0016, "635",aDados[05]})//"Saldo a favor do contribuinte do periodo anterior atualizado."
	aAdd(aApur,{2,STR0017, "592",aDados[06]})//"Saldo a favor do contribuinte para o seguinte periodo (C693 + C635 - C909; Se > 0)."
	aAdd(aApur,{2,STR0018,"1001",aDados[07]})//"Saldo a favor da Fisco (C909 - C693 - C635; Se > 0)."
	aAdd(aApur,{2,STR0019, "622",aDados[08]})//"Pagamento a conta realizados na DDJJ anterior a compensar."
	aAdd(aApur,{2,STR0020, "640",aDados[09]})//"Saldo fisponível de pagamentos do período anterior a compensar."
	aAdd(aApur,{2,STR0021, "747",aDados[10]})//"Diferença a favor do contibuinte para o seguinte período )C622+C640 - C1001; Se > 0)."
	aAdd(aApur,{2,STR0022, "996",aDados[11]})//"Saldo definitivo a favor da Fisco (C1001 - C622 - C640; Si > 0)."
	aAdd(aApur,{2,STR0023, "677",aDados[12]})//"Inclusão de crédito nos valores (Sujeito a verificação e confirmação por parte da S.I.N.)."
	aAdd(aApur,{2,STR0024, "576",aDados[13]})//"Pagamento de imposto em especies (C996-C677; Se > 0), (Se a prestação é fora do término, deve realizar o pagamento no boleto F.1000)"

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

	For nI:=1 To 11	
		aAdd(aDados,0)
	Next nI
	
	//Query
	cQry := " SELECT"
	cQry += " SUM(SF3.F3_BASIMP2) AS BASIMP"
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
	
	TcQuery cQry New Alias "QRY"
	
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
		aDados[1] += QRY->BASIMP
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
	
	aDados[2] := aDados[1] * 0.03
	
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
	
	If (aDados[9] - aDados[10]) > 0
		aDados[11] := aDados[9] - aDados[10]
	EndIf
		
	aAdd(aApur,{1,STR0025, "013",aDados[01]})//"Ingressos brutos adiquiridos e/ou em especie menos abatimentos e descontos"
	aAdd(aApur,{1,STR0026, "909",aDados[02]})//"Impuesto liquidado (3% de C013)"
	aAdd(aApur,{2,STR0027, "664",aDados[03]})//"Pago a conta IUE a compensar (1ra. instancia ou saldo do periodo anterior (C619 do Form. Anterior))"
	aAdd(aApur,{2,STR0028, "619",aDados[04]})//"Saldo IUE para o seguinte periodo (C664-C909;Si > 0)"
	aAdd(aApur,{2,STR0029,"1001",aDados[05]})//"Saldo a favor da Fisco (C909 - C664; Si > 0)"
	aAdd(aApur,{2,STR0030, "622",aDados[06]})//"Pagamentos a conta realizados na DDJJ anterior e/ou em boletos de pagamento"
	aAdd(aApur,{2,STR0031, "640",aDados[07]})//"Saldo disponivel de pagamentos do periodo anterior a compensar"
	aAdd(aApur,{2,STR0032, "747",aDados[08]})//"Diferenca a favor do contribuinte para o seguinte periodo (C622 + C640 - C1001; Si > 0)"
	aAdd(aApur,{2,STR0033, "996",aDados[09]})//"Saldo definitivo a favor da fisco (C1001 - C622 - C640; Si > 0)"
	aAdd(aApur,{2,STR0034, "677",aDados[10]})//"Inclusão de credito nos valores (Sujeito a verificacao e confirmacao por parte da S.I.N.)."
	aAdd(aApur,{2,STR0035, "576",aDados[11]})//"Pagamento de imposto em especies (C996-C677; Se > 0), (Se a prestação é fora do término, deve realizar o pagamento no boleto F.1000)."

Return aApur

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImpRel   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime apuracao.                                          ³±±
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
Static Function ImpRel(cTitulo,aApur)

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
		ApMsgStop(STR0057)//"Ocorreu um erro ao criar o arquivo."
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
