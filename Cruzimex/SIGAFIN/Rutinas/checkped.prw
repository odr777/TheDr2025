#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.CH"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CHECBOX    ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 11.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Exemplo de utilização do elemento checkBox em um getDados. ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
user function checkped
	Local oSay       := nil
	Local titulo     := nil
	Local nX
	public aPVSelec := {}
	private oDlgTela
	private aHeader := {}
	private cEstado
	private aColsCidades := {}
	private lChkSel    := .F.
	private lOkSalva   := .F.
	private lChkFiltro := .F.
	private oGetDados
	static oChk, oChkFiltro
	private ValTotal := 0.0
	//	LOCAL cTexto := OEMTOANSI("Valor total")

	//array de cabeçalho do GetDados
	//Neste caso serão 4 colunas incluindo o campo que possui caixa de seleção ou checkBox
	aadd(aHeader,{''		  ,'CHECKBOL'     ,'@BMP', 2,0,,	             ,"C",     ,"V",,,'seleciona','V','S'})
	aadd(aHeader,{"Número"    ,"C5_NUM"   ,"@!"  , 3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Cod. Cliente" ,"C5_CLIENTE"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Fecha" ,"C5_EMISSAO"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"}) // EDSON 17.07.2019
	aadd(aHeader,{"Nombre Cliente"    ,"C5_UNOMCLI"      ,"@!"  , 100,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Monto."    ,"C5_MONTO"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
	buscaSC5(CCLIENTE)

	if empty(aColsCidades) // caso no existan pedidos es retornado
		return .F.
	endif

	//Nosso programa irá listar todos os municípios e fazer filtros por Estado
	@003,003 to 530,1150 dialog oDlgTela title "Lista de Pedido"

	//Aqui onde o usuário informará o estado que buscará as cidades pertencentes
	//		@011,006 say "Nombre: " pixel of oDlgTela
	//este elemento get é a caixa de testo que possui a consulta padrão (opção F3).
	//esta consulta SC5EST foi configurada no Configurador somente para este uso
	//		@011,030 get cEstado Picture "99/99/99"  size 80,11

	//botão pesquisar que, quando acionado, efetua a busca dos municípios de acordo com o Estado inserido pelo usuário
	//a variável cEstado armazena o conteúdo existente no elemento "get" acima
	//		@012,145 button "&Buscar" size 40,11 pixel of oDlgTela action filtNombre(cEstado)

	//o objeto oGetDados (MsNewGetDados) com os atributos configurados
	oGetDados := MsNewGetDados():New(025,006,230,570, GD_UPDATE, , , , {'CHECKBOL'}, 1, 99, , , , oDlgTela, aHeader, aColsCidades,,)
	//quando clicado duas vezes sobre o aCols[oGetDados:nAt,1], ou seja, onde ficará a coluna com o checkbox, ele irá alternar de LBOK para LBNO e vice versa
	oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(), oGetDados:aCols[oGetDados:nAt,1] := iif(oGetDados:aCols[oGetDados:nAt,1] == 'LBOK','LBNO','LBOK')}

	//objeto oChk de checkbox e variável lChkSel. Quando clicado, executa o método "seleciona" e possibilita
	//que o usuário selecione todas as cidades ao mesmo tempo. Facilita também no momento da escolha em casos de listas extensas
	@240,006 checkbox oChk var lChkSel PROMPT "Selecionar todos" size 60,07 on CLICK seleciona(lChkSel , oSay)

	//botao confirmar comum, ainda daremos utilidade à ele :)
	@240,125 button "&Confirmar" size 40,11 pixel of oDlgTela action close(oDlgTela)
	//botão padrão de Cancelar
	@240,190 button "&Cancelar"  size 40,11 pixel of oDlgTela action close(oDlgTela)


	//Titulo de la sumato del monto
	@240,400 SAY titulo Prompt "Monto total:" SIZE 55,07 OF oDlgTela PIXEL
	//	Va mostrando la sumatoria de la funccion "sumarMonto"
	@240,450 SAY oSay Prompt "0.0" SIZE 55,07 OF oDlgTela PIXEL

	//antes de ativar a tela (oDlgTela) e centralizá-la para o usuário,
	//o método "buscaSC5" pesquisa todas as cidades e estados para pré carregar o oGetDados
	refresh(aColsCidades,oSay)

	//ativa o oDlgTela
	activate dialog oDlgTela center

	For nX := 1 to Len(oGetDados:aCols)		
		if(oGetDados:aCols[nX,1] == 'LBOK')
			aadd(aPVSelec,oGetDados:aCols[nX,2])
			//			alert(oGetDados:aCols[nX,2])
		endif
	Next nX

return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ BUSCASC5   ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 11.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Pesquisa as cidades de acordo com o estado escolhido. Caso ¦¦¦
¦¦¦          ¦ cEstado esteja vazio, serão apresentadas todas as cidades e¦¦¦
¦¦           ¦ estados presentes na tabela.                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function buscaSC5(cEstado)

	//	private aColsCidades := {}
	//atualiza/recarrega o oGetDados e o oDlgTela antes de receber novos dados
	//	refresh(aColsCidades)
	cTemp:= getNextAlias()
	BeginSql alias cTemp

		SELECT C5_NUM, C5_CLIENTE,C5_EMISSAO ,C5_UNOMCLI, TOTVAL
		FROM %table:SC5% SC5
		JOIN (
		SELECT C6_NUM,sum(C6_VALOR) TOTVAL
		FROM  %table:SC6% SC6
		WHERE C6_CLI = %exp:CCLIENTE% AND SC6.D_E_L_E_T_!='*'
		group by C6_CLI, C6_NUM
		) SC6TOT ON C5_NUM = C6_NUM
		WHERE
		C5_LIBEROK ='S'
		AND SC5.D_E_L_E_T_!='*'
		AND SC5.C5_NOTA = ''
		and SC5.C5_USTATUS = ''
		and SC5.C5_CONDPAG='002'
		ORDER BY 3
	EndSql
	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())

	While !(cTemp)->(eof())
		
		aadd(aColsCidades,{'LBNO', allTrim((cTemp)->C5_NUM), allTrim((cTemp)->C5_CLIENTE), allTrim(DTOC(STOD((cTemp)->C5_EMISSAO))), allTrim((cTemp)->C5_UNOMCLI),(cTemp)->TOTVAL,.F.})

		(cTemp)->(dbskip())

	EndDo

	(cTemp)->(dbCloseArea())

	//atualiza o oGetDados com o novo array

return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ REFRESH  ¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 13.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Realiza limpeza dos dados na MsGetDados e inclui novo array¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function refresh(aDados,oSay)

	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()

	oGetDados := MsNewGetDados():New(025,006,230,570, GD_UPDATE, , , , {'CHECKBOL'}, 1, 99, , , , oDlgTela, aHeader, aColsCidades,,)
	oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(), oGetDados:aCols[oGetDados:nAt,1] := iif(oGetDados:aCols[oGetDados:nAt,1] == 'LBOK','LBNO','LBOK'), sumarMonto( oSay ,oGetDados:aCols[oGetDados:nAt,1],oGetDados:aCols[oGetDados:nAt,6]) }

return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ seleciona¦ Autor ¦ edson                 ¦ Data ¦ 22.05.19 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Suma el monto de la celdas selecionada y lo muestra en un say¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function sumarMonto(oSay, isCheck , valor)
private aux := 0.0
	if isCheck == 'LBOK'		
		aux := valor
		ValTotal += aux
		oSay:SetText(FmtoValor(ValTotal,13,2))
	else
		aux := valor
		ValTotal -= aux
		oSay:SetText(FmtoValor(ValTotal,13,2))
	end if
	
	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()	
return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ seleciona¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 08.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Seleciona todas as cidades apresentadas no aCols.          ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function seleciona(lChkSel ,oSay)
	//percorre todas as linhas do oGetDados	
	Local i
	ValTotal  := 0.0
	
	for i := 1 to len(oGetDados:aCols)
		//verifica o valor da variável lChkSel
		//se verdadeiro, define a primeira coluna do aCols como LBOK ou marcado (checked)
		private aux := 0.0
		if lChkSel
			oGetDados:aCOLS[i,1] := 'LBOK'
			aux := oGetDados:aCOLS[i,6]
			ValTotal += aux
			oSay:SetText(FmtoValor(ValTotal,13,2))
//			oDlgTela:CommitControls()
			//se falso, marca como LBNO ou desmarcado (unchecked)
		else
			oGetDados:aCOLS[i,1] := 'LBNO'		
			ValTotal = 0
			oSay:SetText(ValTotal)
		endif
	next
	//executa refresh no getDados e na tela
	//esses métodos Refresh() são próprio da classe MsNewGetDados e do dialog
	//totalmente diferentes do método estático definido no corpo deste fonte
	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()	
return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ selFiltro¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 03.03.16 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Executa o filtro de cidades selecionadas.                  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function selFiltro(lChkFiltro)

	buscaSC5(lChkFiltro)//atualiza o grid de dados

	oGetDados:oBrowse:Refresh()
	oDlgTela:Refresh()

return
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ VERIFLIN ¦ Autor ¦ Renan Rodrigues Ramos ¦ Data ¦ 09.10.15 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Verifica se existem cidades selecionadas.                  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
static function verifLin()

	local lRet := .F.
	Local i
	for i := 1 to len(oGetDados:aCols)
		if oGetDados:aCols[i,1] == 'LBOK'
			aadd(aCidades,{oGetDados:aCols[i,2],oGetDados:aCOLS[i,3],oGetDados:aCOLS[i,5]})
			lRet := .T.
		endIf
	next

return lRet

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  ¦ Autor ¦ edson                         ¦ Data ¦ 22.05.19 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ convierte el monto a dos decimales                         ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 9,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal