#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.CH"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CHECBOX    ¦ Autor ¦ Renan R. Ramos      ¦ Data ¦ 30.08.19 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Compensación automática de Ra y facturas . 			¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
user function compAutpd()
	Local oSay       := nil
	Local titulo     := nil
	LOCAL nX
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
	private cPrimComp := ""
	private cUltimaCom := ""
	//	LOCAL cTexto := OEMTOANSI("Valor total")

	//array de cabeçalho do GetDados
	//Neste caso serão 4 colunas incluindo o campo que possui caixa de seleção ou checkBox
	aadd(aHeader,{''		  ,'CHECKBOL'     ,'@BMP', 2,0,,	             ,"C",     ,"V",,,'seleciona','V','S'})
	aadd(aHeader,{"Num"    ,"C5_NUM"   ,"@!"  , 3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Cod. Cliente" ,"C5_CLIENTE"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Fecha" ,"C5_EMISSAO"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"}) // EDSON 17.07.2019
	aadd(aHeader,{"Nombre Cliente"    ,"C5_UNOMCLI"      ,"@!",50,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Factura"    ,"TituFactura"      ,"@!",18,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Saldo Fact."    ,"E1_SALDOTIT"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
	aadd(aHeader,{"Anticipo"    ,"numeroRa"      ,"@!",8,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Serie Ant."    ,"E1_SERREC"      ,"@!",3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Saldo Anticipo."    ,"SaldoRA"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
	aadd(aHeader,{"PrefixoFac"    ,"PREFIXO"      ,"@!",3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Cuota Ra"    ,"CUOTARA"      ,"@!",2,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	aadd(aHeader,{"Tienda Cliente"    ,"PREFIXO"      ,"@!",2,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
	buscaSC5()

	if empty(aColsCidades) // caso no existan pedidos es retornado
		return .F.
	endif

	//Nosso programa irá listar todos os municípios e fazer filtros por Estado
	@003,003 to 530,1150 dialog oDlgTela title "Compensaciones a realizar"

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
	@240,125 button "&Confirmar" size 40,11 pixel of oDlgTela action Llamacompensa()
	//botão padrão de Cancelar
	@240,190 button "&Cancelar"  size 40,11 pixel of oDlgTela action close(oDlgTela)

	//Titulo de la sumato del monto
	//	@240,400 SAY titulo Prompt "Monto total:" SIZE 55,07 OF oDlgTela PIXEL
	//	Va mostrando la sumatoria de la funccion "sumarMonto"
	//	@240,450 SAY oSay Prompt "0.0" SIZE 55,07 OF oDlgTela PIXEL

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

static function Llamacompensa()

	MsgRun ("Generando compensaciones automáticas", "Por favor espere", {|| compensa() } )
	close(oDlgTela)

return

static function compensa()
	// las compensaciones son todas al contado
	Local nX
	cNumRA := "000000" // NRO RA
	nMonComp :=  0 //
	nMenorValor := 0

	cCompensaciones := ""
	For nX := 1 to Len(oGetDados:aCols)

		if(oGetDados:aCols[nX,1] == 'LBOK') // realiza una compensación

			if cNumRA == oGetDados:aCols[nX,8] // si el RA está pagando varias Facturas
				// el monto de RA debería disminuir al monto anterior
				//				oGetDados:aCols[nX,10] := oGetDados:aCols[nX,10] - nMenorValor // Nahim 06/09/2019 toma en cuenta más de 3 pedidos de una
				oGetDados:aCols[nX,10] := oGetDados:aCols[nX-1,10] - nMenorValor
			endif
			// escogiendo el menor
			//						factura 				Anticipo
			nMenorValor := MIN( oGetDados:aCols[nX,7] ,oGetDados:aCols[nX,10]  )
			if nMenorValor > 0 // valida que tenga saldo en caso que se hayan solucionado varios pedidos
				cFecha := DATE()
				cHora := TIME()
//				cIdApp := __CUSERID + ALLTRIM(SUBSTR(CMONTH(cFecha), 1, 3)) + ALLTRIM(STR(DAY(cFecha)));
				cIdApp := ALLTRIM(SUBSTR(CMONTH(cFecha), 1, 3)) + ALLTRIM(STR(DAY(cFecha)));
				+ ALLTRIM(STR(YEAR(cFecha))) + alltrim(SUBSTR(cHora, 1, 2))+ alltrim(SUBSTR(cHora, 4, 2));
				+ alltrim(SUBSTR(cHora, 7, 2)) + cvaltochar(Randomize(1,34000))
				cNumRA := oGetDados:aCols[nX,8]
				cBody :='{'
				cBody +='   "CLIENTE": "'+ Padr(oGetDados:aCols[nX,3],TamSx3("A1_COD")[1]) + '",'
				//			cBody +='	"TIENDA":"01",                          ' // PONER al final
				cBody +='	"TIENDA":"'+ oGetDados:aCols[nX,13] + '",' // PONER al final
				cBody +='	"SERIE":"CMP",                          '
				cBody +='	"DDATABASE":"'+DTOC(DDATABASE)+'", ' // adicionando fecha de compensación del título
				cBody +='   "IDAPP": "'+ cIdApp + '",'
				//			cBody +='	"COBRADOR":"001232",                    '
				cBody +='	"PAGOS": [                              '
				cBody +='	]	                                    '
				cBody +='	,                                       '
				cBody +='	"BAJAS": [                              '
				// objeto de título por pagar
				cBody +='		   			{                       '
				cBody +='	"FILIAL": "01  ",               '
				cBody +='	"PREFIJO": "'+ oGetDados:aCols[nX,11] + '",'
				cBody +='	"NUMERO": "'+ oGetDados:aCols[nX,6] + '", '
				cBody +='	"CUOTA": "  ",                  ' // no tiene cuotas porque es al contado.
				cBody +='	"MONTOM1": '+cValtochar(nMenorValor) + ','
				cBody +='	"MONTOM2": 0                    '
				cBody +='		},{   								'
				// objeto Anticipo
				cBody +='			"FILIAL": "01  ",               '
				cBody +='			"PREFIJO": "REC",               '
				cBody +='			"NUMERO": "'+ oGetDados:aCols[nX,8] + '", '
				cBody +='			"CUOTA": "'+ oGetDados:aCols[nX,12] + '",'
				cBody +='			"SERIE": "'+ oGetDados:aCols[nX,9] + '",'
				cBody +='			"MONTOM1": '+cValtochar(nMenorValor) + ', '
				cBody +='			"MONTOM2": 0                    '
				cBody +='		}                                   '

				cBody +='	],                                      '
				cBody +='	"PEDIDOS": [                            '
				cBody +='	]                                       '
				cBody +=' }                                         '

//				aviso("",cBody,{'ok'},,,,,.t.)
				
				oObj := nil
				cCompenJson := U_postcmp(cbody)
				FWJsonDeserialize(cCompenJson,@oObj)
				if Type("oObj:data") <> "U" //
					cCompensaciones +="Se compensó el título: " +  oGetDados:aCols[nX,6]  + " - recibo: "  + oObj:data:recibo + Chr(13) + Chr(10) + " - " + oObj:data:serie
				else
					cCompensaciones +="No se pudo compensar el título: " +  oGetDados:aCols[nX,6]   + Chr(13) + Chr(10)
				endif
				
			endif
			//			if nX == 1  // primera compensación automática
			//				cPrimComp = oObj:data:recibo
			//			endif
			//			if nX == Len(oGetDados:aCols) // última compensación automática
			//				cUltimaCom = oObj:data:recibo
			//			endif
			// crea objeto para realizar la compensación
			//			alert(oGetDados:aCols[nX,2])
			//armar el objeto
			//			alert(oGetDados:aCols[nX,2])
			//			exit
		endif
	Next nX
	aviso("Se generaron las siguientes compensaciones",cCompensaciones,{'ok'},,,,,.t.)
	//	ALERT(cPrimComp)
	//	ALERT(cUltimaCom)
	//	alert("compensando..")
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
static function buscaSC5()

	//	private aColsCidades := {}
	//atualiza/recarrega o oGetDados e o oDlgTela antes de receber novos dados
	//	refresh(aColsCidades)
	cTemp:= getNextAlias()
	BeginSql alias cTemp

		SELECT C5_NUM, SE1.E1_MOEDA monedaRA ,SE1.E1_NUM numeroRA, SE1.E1_SALDO saldoRA,
		SE1.E1_VLCRUZ ,SE12.E1_NUM TITUFACTURA ,SE12.E1_SALDO E1_SALDOTIT, SE1.E1_SERREC,
		SE12.E1_PREFIXO PrefixoFac, SE1.E1_PARCELA CUOTARA , C5_LOJACLI ,	 *
		FROM SE1010 SE1
		JOIN SC5010 SC5 ON SC5.D_E_L_E_T_ = ' ' AND C5_URECIBO = E1_NUM AND E1_SERREC = C5_USERIE
		JOIN SE1010 SE12 ON SE12.D_E_L_E_T_ = ' ' AND C5_NOTA = SE12.E1_NUM AND C5_SERIE = SE12.E1_PREFIXO AND se12.E1_SALDO >= 1
		WHERE SE1.D_E_L_E_T_  LIKE ' ' AND SE1.E1_TIPO = 'RA ' AND SE1.E1_SALDO >= 1 AND SE1.E1_MOEDA = 1
		order by 3
	EndSql
	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())

	While !(cTemp)->(eof())

		/*
		aadd(aHeader,{''		  ,'CHECKBOL'     ,'@BMP', 2,0,,	             ,"C",     ,"V",,,'seleciona','V','S'})
		aadd(aHeader,{"Num"    ,"C5_NUM"   ,"@!"  , 3,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
		aadd(aHeader,{"Cod. Cliente" ,"C5_CLIENTE"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
		aadd(aHeader,{"Fecha PV" ,"C5_EMISSAO"      ,"@!"  ,6,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"}) // EDSON 17.07.2019
		aadd(aHeader,{"Nombre Cliente"    ,"C5_UNOMCLI"      ,"@!",50,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
		aadd(aHeader,{"Factura"    ,"TituFactura"      ,"@!",18,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
		aadd(aHeader,{"Saldo Fact."    ,"E1_SALDOTIT"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
		aadd(aHeader,{"Anticipo"    ,"numeroRa"      ,"@!",8,0,,"€€€€€€€€€€€€€€ ","C","SC5","R"})
		aadd(aHeader,{"Serie Ant."    ,"E1_SERREC"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
		aadd(aHeader,{"Saldo Anticipo."    ,"SaldoRA"      ,"@E 999,999,999.99"  , 13,0,,"€€€€€€€€€€€€€€ ","N","SC5","R"})
		*/

		aadd(aColsCidades,{'LBNO', allTrim((cTemp)->C5_NUM), allTrim((cTemp)->E1_CLIENTE), allTrim(DTOC(STOD((cTemp)->C5_EMISSAO))),;
		allTrim((cTemp)->C5_UNOMCLI),(cTemp)->TITUFACTURA,(cTemp)->E1_SALDOTIT,(cTemp)->numeroRa ,;
		(cTemp)->E1_SERREC,(cTemp)->SaldoRA, (cTemp)->PrefixoFac, (cTemp)->CUOTARA,(cTemp)->C5_LOJACLI, .F.})

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
	//	private aux := 0.0
	if isCheck == 'LBOK'
		//		aux := valor
		//		ValTotal += aux
		//		oSay:SetText(FmtoValor(ValTotal,13,2))
	else
		//		aux := valor
		//		ValTotal -= aux
		//		oSay:SetText(FmtoValor(ValTotal,13,2))
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
	local i 
	ValTotal  := 0
	for i := 1 to len(oGetDados:aCols)
		//verifica o valor da variável lChkSel
		//se verdadeiro, define a primeira coluna do aCols como LBOK ou marcado (checked)
		//		private aux := 0.0
		if lChkSel
			oGetDados:aCOLS[i,1] := 'LBOK'
			//			aux := oGetDados:aCOLS[i,6]
			//			ValTotal += 1
			//			oSay:SetText()
			//			oDlgTela:CommitControls()
			//se falso, marca como LBNO ou desmarcado (unchecked)
		else
			oGetDados:aCOLS[i,1] := 'LBNO'
			//			ValTotal -= 1
			//			oSay:SetText(ValTotal)
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

	buscaSC5()//atualiza o grid de dados

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