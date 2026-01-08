#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
	Remito de Entrada 
*/
User Function ImpRemito()
Local nTotImp 	:= 0 , nPos := 0 , cCpoBase := "" , cCpoImp := ""  
Local Titulo    := PADC("Nota Fiscal - Nfiscal",74)
Local cDesc1	:= PADC("Este programa emitira Nota Fiscal de Entrada/Salida",74)
Local cDesc2 	:= ""  ,  cDesc3 := PADC("da Nfiscal",74)
Local cPerg		:= "NFSIGW"  , cString := "SF2" , cSerie := ""
Local cLoja     := "" , cCondPag := "" , cTipo := "" , cPedatu  := "" , cItemAtu := "" 
Local I         := 1 , J := 1 , nOPC := 0 , cCor := ""     

Private aPed_Vend := {}                         // Numero do Pedido de Venda
Private aItem_Ped := {}                         // Numero do Item do Pedido de Venda
Private aDOC      := {}                         // Numero do Documento, para quando não tiver pedido de vendas.
Private aItem     := {}                         // Numero do Item do Documento, para quando nao tiver pedido de vendas
Private aPre_Tab  := {}                         // Preco Unitario de Tabela
Private aDesc     := {}                         // Desconto por Item
Private aVal_Desc := {}                         // Valor do Desconto
Private aTES      := {}                         // TES
Private aCF       := {}                         // Classificacao quanto natureza da Operacao
Private aPeso_Pro := {}                         // Peso Liquido
Private aPed      := {}
Private aCod_Vend := {} 
Private aDesc_NF  := {}
Private aPed_Cli  := {} 
Private aDesc_Pro := {}
Private aVendedor := {}
Private aLoliz := {}
Private aFabric := {}
Private aReturn 		:= { "Especial", 1,"Administracion", 1, 2, 1,"",1 }
Private lContinua 		:= .T.
Private nLin   			:=0                     
Private nTamNf			:=72     // Apenas Informativo, tamanho do Formulario de Nota Fiscal (em Linhas)
Private aImpnf 			:= {}
Private nLinIni			:=0
Private cNum_NF			:= ""  	
Private dEmissao
Private nTot_Fat		:= 0
Private nFrete  		:= 0
Private nSeguro 		:= 0
Private nValor_Merc		:= 0
Private cNum_Duplic		:= ""
Private cEspecie		:=""
Private nVolume			:= 0
Private nPeso_Liquid 	:= 0
Private nPeso_Bruto     := 0
Private cCliente  		:= "" 
Private cTipo_Cli 		:= "" 
Private cCod_Cli 		:= "" 
Private cCob_Cli 		:= "" 
Private cRec_Cli 		:= "" 
Private cFax_Cli		:= ""
Private cCod_Mens		:= "" 
Private cTpFrete 		:= ""
Private cNOME_CLI 		:= "" 
private cEND_CLI 		:= "" 
Private cBairro  		:= "" 
Private cCep_Cli 		:= ""
Private cMun_Cli  		:= "" 
Private cEst_Cli  		:= ""
Private cCGC_Cli  		:= ""
Private cInsc_Cli		:= "" 
Private cTran_Cli		:= ""
Private cTel_Cli 		:= "" 
Private cSUFRAMA  		:= "" 
Private cCalcSuf 	    := ""
Private lZFranca 	    := .T.
Private cMun_Transp		:= "" 
Private cEnd_Transp		:= ""
Private cNome_Transp	:= ""
Private cEst_Transp		:= "" 
Private cVia_Transp		:= ""
Private cCGC_Transp 	:= ""
Private cTel_Transp		:= ""
Private cDuplicatas		:= "" 
Private cNatureza		:= ""
Private cFAX 			:= ""    
Private nPBruto			:= 0
Private nPLiqui			:= 0
Private cMensagem		:= 0
Private wnrel           := "SIGANF" 

Private	aPre_Lot   		:= {} 
Private	aPre_Fel   		:= {} 
Private	aPref_DV 		:= {}                         // Serie  quando houver devolucao
Private	aCod_Pro 		:= {}                         // Codigo  do Produto
Private	aQtd_Pro 		:= {}                         // Quantidade do Produto
Private	aPre_Uni 		:= {}                         // Preco Unitario de Venda
Private aVal_Merc		:= {}                         // Valor da Mercadoria  
Private aDescricao		:= {}                        // Descricao do Produto
Private aUnid_Pro		:= {}                         // Unidade do Produto             
Private aCod_Trib		:= {}                         // Codigo de Tributacao
Private aParc_Dup 		:= {}
Private aVenc_Dup		:= {} 
Private aValor_Dup 		:= {} 
Private aPedido 		:= {}
Private aPesoProd 		:= {}
Private aNum_NFDV		:= {}                         // Numero quando houver devolucao
Private nMoneda			:= 0             
Private cTitulo_cab		:= ""
Private nTipoRem        := "0"


Private cPedido			:= ""             
Private cSucursal		:= ""
Private Cvendedor       := ""

//alert('impremito')

IF(FUNNAME()=='MATA462N')
	cTitulo := "R E M I T O  D E  V E N T A"    
   @ 06, 040 PSAY cTitulo
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+Space(4)+'01'))               
   	RecLock('SX1',.F.)                              
   	SX1->X1_CNT01 := SF2->F2_DOC 
   	SX1->(MsUnlock())
   End
   If SX1->(DbSeek(cPerg+Space(4)+'02'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  SF2->F2_DOC
    SX1->(MsUnlock())
   END  
   If SX1->(DbSeek(cPerg+Space(4)+'03'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  SF2->F2_SERIE
    SX1->(MsUnlock())
   END   
   If SX1->(DbSeek(cPerg+Space(4)+'04'))
    RecLock('SX1',.F.)                  
    SX1->X1_PRESEL :=  2
    SX1->(MsUnlock())
   END           
END


IF(FUNNAME()=='MATA102N' .OR. FUNNAME()=='MATA101N')
	if(FUNNAME()=='MATA102N')
		cTitulo_cab := "R E M I T O  D E  E N T R A D A"
	else
		cTitulo_cab := "F A C T U R A  D E  E N T R A D A"
	endif
   
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+Space(4)+'01'))               
   	RecLock('SX1',.F.)                              
   	SX1->X1_CNT01 := SF1->F1_DOC 
   	SX1->(MsUnlock())
   End
   If SX1->(DbSeek(cPerg+Space(4)+'02'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  SF1->F1_DOC
    SX1->(MsUnlock())
   END  
   If SX1->(DbSeek(cPerg+Space(4)+'03'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  SF1->F1_SERIE
    SX1->(MsUnlock())
   END   
   If SX1->(DbSeek(cPerg+Space(4)+'04'))
    RecLock('SX1',.F.)                  
    SX1->X1_PRESEL :=  1
    SX1->(MsUnlock()) 
   END        
END
//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+  
Pergunte(cPerg,.F.)               // Pergunta no SX1

/*/
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
//+--------------------------------------------------------------+
/*/
//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P")
If nLastKey == 27
	Return
Endif
//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
VerImpLoc()
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
RptStatus({|| RptDetailLoc()})
Return
Static Function RptDetailLoc()
Local I,J  := 1
If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif
//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2   					   // NOTA FISCAL DE SAIDA
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
		
		If SF2->F2_SERIE #mv_par03    // Verifica se a Serie do Arquivo é Diferente do Parametro Informado !!!
			DbSkip()
			Loop
		Endif
		
		IF lAbortPrint
			@ 00,01 PSAY "** CERRADO POR EL OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		// * Cabecalho da Nota Fiscal
		cCliente    :=SF2->F2_CLIENTE
		cNum_NF     :=SF2->F2_DOC             // Numero
		cSerie      :=SF2->F2_SERIE           // Serie
		dEmissao    :=SF2->F2_EMISSAO         // Data de Emissao
		nTot_Fat    :=SF2->F2_VALFAT          // Valor Total da Fatura   
		
		// Se o campo F2_VALFAT (VALOR DA FATURA) estiver zerado, calcula o total da fatura 
		// somando os valores dos impostos + o valor da mercadoria + Despesas + Seguro + Frete - Descontos
		if nTot_Fat == 0
			nTotImp:=0
			nTotImp=SF2->F2_VALIMP1+SF2->F2_VALIMP2+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5+SF2->F2_VALIMP6
			If cPaisLoc == "ARG"
				nTotImp=nTotImp+SF2->F2_VALIMP7+SF2->F2_VALIMP8+SF2->F2_VALIMP9
			EndIf	
			nTot_Fat := SF2->F2_VALMERC+SF2->F2_DESPESA+SF2->F2_SEGURO+SF2->F2_FRETE+nTotImp
			nTot_Fat := nTot_Fat - SF2->F2_DESCONT
		endif
		cLoja       :=SF2->F2_LOJA            // Loja do Cliente
		nFrete      :=SF2->F2_FRETE           // Frete
		nSeguro     :=SF2->F2_SEGURO          // Seguro
		nValor_Merc :=SF2->F2_VALMERC         // Valor  da Mercadoria
		cNum_Duplic :=SF2->F2_DUPL            // Numero da Duplicata
		cCond_Pag   :=SF2->F2_COND            // Condicao de Pagamento  
		cTipo       :=SF2->F2_TIPO            // Tipo do Cliente
		cEspecie    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		nVolume     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
		nMoneda		:=SF2->F2_MOEDA			  // MONEDA
		aImpNF := {}
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+cNum_NF+cSerie)
		
  		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal de Saída     ¦
		//+--------------------------------------------------------------+		
		cPedAtu := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV  
		aPed_Vend:={}                         // Numero do Pedido de Venda
		aItem_Ped:={}                         // Numero do Item do Pedido de Venda
		aDoc     :={}                         // Numero do Documento, para quando não tiver pedido de vendas.
		aItem    :={}                         // Numero do Item do Documento, para quando nao tiver pedido de vendas
		aNum_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		aPref_DV :={}                         // Serie  quando houver devolucao
		aCod_Pro :={}                         // Codigo  do Produto
		aQtd_Pro :={}                         // Peso/Quantidade do Produto
		aPre_Uni :={}                         // Preco Unitario de Venda   
		aPre_Lot :={}                         //solange
		aPre_Fel :={}                         //solange
		aPre_Tab :={}                         // Preco Unitario de Tabela
		aDesc    :={}                         // Desconto por Item
		aVal_Desc:={}                         // Valor do Desconto
		aVal_Merc:={}                         // Valor da Mercadoria
		aTES     :={}                         // TES
		aCF      :={}                         // Classificacao quanto natureza da Operacao
		
		While !eof() .and. SD2->D2_DOC==cNum_NF .and. SD2->D2_SERIE==cSerie
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			If !Empty(SD2->D2_PEDIDO)
				AADD(aPed_Vend ,SD2->D2_PEDIDO)
				AADD(aItem_Ped ,SD2->D2_ITEMPV)
			Else
				AADD(aDoc ,SD2->D2_DOC)
				AADD(aItem ,SD2->D2_ITEM)
			EndIf
			AADD(aNum_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(aPREF_DV  ,SD2->D2_SERIORI)
			AADD(aCod_pro  ,SD2->D2_COD)    
			//AADD(aLote     ,SD2->D2_NUMLOTE)
			AADD(aQtd_Pro  ,SD2->D2_QUANT)     // Guarda as quant. da NF
			AADD(aPre_Uni  ,SD2->D2_PRCVEN)
			AADD(aPre_Lot  ,SD1->D1_LOTECTL)          // lote
			AADD(aPre_Fel  ,SD1->D1_DTVALID)          // lote
			AADD(aPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(adesc     ,SD2->D2_DESC)
			AADD(aVal_Merc ,SD2->D2_TOTAL)
			AADD(aTes      ,SD2->D2_TES)
			AADD(aCF       ,SD2->D2_CF)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega o Array aImpNF com todos os impostos contidos no Item³
			//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
			SFC->( dbSetOrder(1) )
			SFC->(DbSeek(xFilial("SFC")+SD2->D2_TES))
			While SFC->FC_TES == SD2->D2_TES .And. !SFC->(EOF())
				
				SFB->( dbSetOrder(1) )
				SFB->(dBSeek(xFilial("SFB")+SFC->FC_IMPOSTO))  
				cCpoBase := "D2_BASIMP"+SFB->FB_CPOLVRO
				cCpoImp  := "D2_VALIMP"+SFB->FB_CPOLVRO
				
				nPos	:=	Ascan(aImpNF,{|x| x[1] == SFC->FC_IMPOSTO } )
				If nPos == 0
					aadd( aImpNF,{ SFC->FC_IMPOSTO, SFB->FB_DESCR, SFB->FB_ALIQ, SD2->&(cCpoBase), SD2->&(cCpoImp)} )
				Else
					aImpNF[nPos][4]	+= SD2->&(cCpoBase)            // Base de Calculo
					aImpNF[nPos][5]	+= SD2->&(cCpoImp)             // Valor do Imposto
				Endif
				SFC->(DbSkip())
			EndDo
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		
		I:=1
		For I:=1 to Len(aCod_pro)
			dbSeek(xFilial("SB1")+aCod_pro[I])
			AADD(aPeso_Pro ,SB1->B1_PESO * aQtd_Pro[I])
			AADD(aUnid_Pro ,SB1->B1_UM)
			AADD(aDescricao ,SB1->B1_DESC)
			AADD(aCod_Trib ,SB1->B1_ORIGEM)
			// Calculo do Peso Liquido da Nota Fiscal
			nPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(aPeso_Pro)
				nPESO_LIQUID:=nPESO_LIQUID+aPeso_Pro[j]
			Next
		Next
		
		//Verifica se tem Pedido de vENDAS
		If Len(aPed_Vend) > 0
			dbSelectArea("SC5")                            // * Pedidos de Venda
			dbSetOrder(1)
			
			For I:=1 to Len(aPed_Vend)
				dbSeek(xFilial("SC5")+aPed_Vend[I])
				If ASCAN(aPed,aPed_Vend[I])==0
					cCliente    :=SC5->C5_CLIENTE            // Codigo do Cliente
					cTipo_Cli   :=SC5->C5_TIPOCLI            // Tipo de Cliente
					cCod_Mens   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
					cMensagem   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
					cTpFrete    :=SC5->C5_TPFRETE            // Tipo de Entrega
					cCondPag    :=SC5->C5_CONDPAG            // Condicao de Pagamento
					nPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto   
					nTipoRem    :=SC5->C5_TIPOREM            // Tipo de remito
					cPedido     :=SC5->C5_NUM
					cSucursal   :=SC5->C5_FILIAL
					cVendedor   :=SC5->C5_VEND1
					aCod_Vend:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
					SC5->C5_VEND2,;             // Codigo do Vendedor 2
					SC5->C5_VEND3,;             // Codigo do Vendedor 3
					SC5->C5_VEND4,;             // Codigo do Vendedor 4
					SC5->C5_VEND5}              // Codigo do Vendedor 5
					aDesc_NF := {SC5->C5_DESC1,;             // Desconto Global 1
					SC5->C5_DESC2,;             // Desconto Global 2
					SC5->C5_DESC3,;             // Desconto Global 3
					SC5->C5_DESC4}              // Desconto Global 4
					AADD(aPed,aPed_Vend[I])
				Endif
			Next
		Else   // Não tem pedido de Vendas
			aDocUM      := {}
			For I:=1 to Len(aDoc)
				If cTipo=='N' .OR. cTipo=='C' .OR. cTipo=='P' .OR. cTipo=='I' .OR. cTipo=='S' .OR. cTipo=='T' .OR. cTipo=='O'
					
					dbSelectArea("SA1")                // * Cadastro de Clientes
					dbSetOrder(1)
					dbSeek(xFilial("SA1")+cCliente+cLoja)
					If ASCAN(aDocUM,aDoc[I])==0
						cCliente    :=SA1->A1_COD            	 // Codigo do Cliente
						cTipo_Cli   :=SA1->A1_TIPO               // Tipo de Cliente
						cCod_Mens   :=SA1->A1_MENSAGE            // Codigo da Mensagem Padrao
						cMensagem   :=""                         // Mensagem para a Nota Fiscal
						cTpFrete    :=SA1->A1_TPFRET             // Tipo de Entrega
						cCondPag    :=SA1->A1_COND               // Condicao de Pagamento
						aCod_Vend:= {SA1->A1_VEND}               // Codigo do Vendedor 1
						aDesc_NF := {SA1->A1_DESC}               // Desconto Global 1
						AADD(aDocUM,aDoc[I])
					EndIf
				Endif
			Next
		EndIf
		DbSelectArea("SM0")
		SM0->(DBSETORDER(1))
		SM0->(DbSeek(cEmpAnt+SF2->F2_FILIAL))
		cSucursal:= SM0->M0_FILIAL
		If Len(aPed_Vend) >= 0
			dbSelectArea("SC6")                    // * Itens de Pedido de Venda
			dbSetOrder(1)
			aPed_CLI :={}                          // Numero de Pedido
			aDesc_pro:={}                          // Descricao aux do produto
			J:=Len(aPed_Vend)
			For I:=1 to J
				dbSeek(xFilial("SC6")+aPed_Vend[I]+aItem_Ped[I])
				AADD(aPed_CLI ,SC6->C6_PEDCLI)
				AADD(aDesc_pro,SC6->C6_DESCRI)
				AADD(aVal_Desc,SC6->C6_VALDESC)
			Next
		Else
			dbSelectArea("SD2")                    // * Itens da Nota Fiscal
			dbSetOrder(3)
			aFatura  :={}                          // Numero de Fatura
			aDesc_pro:={}                          // Descricao aux do produto
			J:=Len(aDoc)
			For I:=1 to J
				dbSeek(xFilial("SD2")+aDoc[I]+cSerie+cCliente+cLoja+aCod_pro[I]+aItem[I])
				AADD(aFatura ,SD2->D2_DOC)
				AADD(aVal_Desc,SD2->D2_DESCON)
				SB1->(dbSeek(xFilial("SB1")+aCod_pro[I]))
				AADD(aDesc_pro,SC6->C6_DESCRI)
			Next
		EndIf
		
		If cTipo=='N' .OR. cTipo=='C' .OR. cTipo=='P' .OR. cTipo=='I' .OR. cTipo=='S' .OR. cTipo=='T' .OR. cTipo=='O'
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+cCliente+cLoja)
			cCod_Cli :=SA1->A1_COD             // Codigo do Cliente
			cNome_Cli:=SA1->A1_NOME            // Nome
			cEnd_Cli :=SA1->A1_END             // Endereco
			cBairro  :=SA1->A1_BAIRRO          // Bairro
			cCep_Cli :=SA1->A1_CEP             // CEP
			cCob_Cli :=SA1->A1_ENDCOB          // Endereco de Cobranca
			cRec_Cli :=SA1->A1_ENDENT          // Endereco de Entrega
			cMun_Cli :=SA1->A1_MUN             // Municipio
			cEst_Cli :=SA1->A1_EST             // Estado
			cCGC_Cli :=SA1->A1_CGC             // CGC
			cInsc_Cli:=SA1->A1_INSCR           // Inscricao estadual
			cTran_Cli:=SA1->A1_TRANSP          // Transportadora
			cTel_Cli :=SA1->A1_TEL             // Telefone
			cFax_Cli :=SA1->A1_FAX             // Fax
			cSuframa :=SA1->A1_SUFRAMA            // Codigo Suframa
			cCalcSuf :=SA1->A1_CALCSUF            // Calcula Suframa
			// Alteracao p/ Calculo de Suframa
			if !empty(cSuframa) .and. cCalcSuf =="S"
				IF cTipo == 'D' .OR. cTipo == 'B'
					lZFranca := .F.
				else
					lZFranca := .T.
				endif
			Else
				lZFranca:= .F.
			endif
			
		Else
			lZFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+cCliente+cLoja)
			cCod_Cli :=SA2->A2_COD             // Codigo do Fornecedor
			cNome_Cli:=SA2->A2_NOME            // Nome Fornecedor
			cEnd_Cli :=SA2->A2_END             // Endereco
			cBairro  :=SA2->A2_BAIRRO          // Bairro
			cCep_Cli :=SA2->A2_CEP             // CEP
			cCob_Cli :=""                      // Endereco de Cobranca
			cRec_Cli :=""                      // Endereco de Entrega
			cMun_Cli :=SA2->A2_MUN             // Municipio
			cEst_Cli :=SA2->A2_EST             // Estado
			cCGC_Cli :=SA2->A2_CGC             // CGC
			cInsc_Cli:=SA2->A2_INSCR           // Inscricao estadual
			cTran_Cli:=SA2->A2_TRANSP          // Transportadora
			cTel_Cli :=SA2->A2_TEL             // Telefone
			cFax_Cli :=SA2->A2_FAX             // Fax
		Endif
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		aVendedor:={}                         // Nome do Vendedor
		I:=1
		J:=Len(aCod_Vend)
		For I:=1 to J
			dbSeek(xFilial("SA3")+aCod_Vend[I])
			Aadd(aVendedor,SA3->A3_NREDUZ)
		Next
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
		cNome_Transp :=SA4->A4_NOME           // Nome Transportadora
		cEnd_Transp  :=SA4->A4_END            // Endereco
		cMun_Transp  :=SA4->A4_MUN            // Municipio
		cEst_Transp  :=SA4->A4_EST            // Estado
		cVia_Transp  :=SA4->A4_VIA            // Via de Transporte
		cCGC_Transp  :=SA4->A4_CGC            // CGC
		cTel_Transp  :=SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		aParc_Dup  :={}                       // Parcela
		aVenc_Dup  :={}                       // Vencimento
		aValor_Dup :={}                       // Valor
		cDuplicatas:=IIF(dbSeek(xFilial()+cSerie+cNum_Duplic,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		While !eof() .and. SE1->E1_NUM==cNum_Duplic .and. cDuplicatas==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(aParc_Dup ,SE1->E1_PARCELA)
			AADD(aVenc_Dup ,SE1->E1_VENCTO)
			AADD(aValor_Dup,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial("SF4")+aTES[1])
		cNatureza:=SF4->F4_TEXTO              // Natureza da Operacao
		
		// Inicia a Impressão da NF
		ImprimeLoc()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
Else   ////REMITO DE ENTRADA
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		//+-----------------------------------------------------------+
		//¦ Inicializa  regua de impressao                            ¦
		//+-----------------------------------------------------------+
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		IF lAbortPrint
			@ 00,01 PSAY "** CERRADO POR EL OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal de Entrada   ¦
		//+--------------------------------------------------------------+
		
		cNum_NF     :=SF1->F1_DOC             // Numero
		cSerie      :=SF1->F1_SERIE           // Serie
		cFornece    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		dEmissao    :=SF1->F1_EMISSAO         // Data de Emissao
		nTot_Fat    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		cLoja       :=SF1->F1_LOJA            // Loja do Cliente
		nFrete      :=SF1->F1_FRETE           // Frete
		nSeguro     :=SF1->F1_DESPESA         // Despesa
		nValor_Merc :=SF1->F1_VALMERC         // Valor  da Mercadoria
		cNum_Duplic :=SF1->F1_DUPL            // Numero da Duplicata
		cCond_Pag   :=SF1->F1_COND            // Condicao de Pagamento
		cTipo       :=SF1->F1_TIPO            // Tipo do Cliente
		cNFOri      :=""	 				  // SF1->F1_NFORI           // NF Original
		aPREF_DV    :=""			  		  // SF1->F1_SERIORI         // Serie Original
		nMoneda		:=SF1->F1_MOEDA			  // MONEDA
		DbSelectArea("SM0")
		SM0->(DBSETORDER(1))
		SM0->(DbSeek(cEmpAnt+SF1->F1_FILIAL))
		cSucursal:= SM0->M0_FILIAL
		
		aImpNF := {}
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(3)                                                                
		dbGoTop() 
		dbSeek(SF1->F1_FILIAL+DTOS(SF1->F1_EMISSAO)+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))                                                                                                   
		                                                                                      
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		aPedido  :={}                         // Numero do Pedido de Compra
		aItem_Ped:={}                         // Numero do Item do Pedido de Compra
		aNum_NFDV:={}                         // Numero quando houver devolucao
		aPREF_DV :={}                         // Serie  quando houver devolucao
		aCod_Pro :={}                         // Codigo  do Produto
		aQtd_Pro :={}                         // Quantidade do Produto
		aPre_Uni :={}                         // Preco Unitario de Compra
		aPre_Lot :={}                         // solange
		aPre_Fel :={}                         // solange
		aPesoProd:={}                         // Peso do Produto
		aDesc   :={}                         // Desconto por Item
		aVal_Desc:={}                         // Valor do Desconto
		aVal_Merc:={}                         // Valor da Mercadoria
		aTes     :={}                         // TES
		aCF      :={}                         // Classificacao quanto natureza da Operacao
		aLoliz := {}
		aFabric	:={} 
				
		While sd1->(!eof()) .and. SF1->F1_FILIAL+DTOS(SF1->F1_EMISSAO)+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ==;
		    SD1->D1_FILIAL+DTOS(SD1->D1_EMISSAO)+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)      
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!           
				Loop
			Endif 
			
			AADD(aPedido ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(aItem_Ped ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(aNum_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(aPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(aCod_Pro  ,SD1->D1_COD)            // Produto
			AADD(aQtd_Pro  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(aPre_Uni  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(aPre_Lot  ,SD1->D1_LOTECTL)          // lote
			//ALERT(SD1->D1_DTVALID)
			AADD(aPre_Fel  ,SD1->D1_DTVALID)          // lote
			AADD(aPesoProd ,SD1->D1_PESO)           // Peso do Produto
			AADD(aDesc    ,SD1->D1_DESC)           // % Desconto
			AADD(aVal_Merc ,SD1->D1_TOTAL)          // Valor Total
			AADD(aTes      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(aCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(aLoliz       ,SD1->D1_LOCALIZ)             // Codigo Fiscal
			AADD(aFabric       ,POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_UFABRIC"))             // Codigo Fiscal

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega o Array aImpNF com todos os impostos contidos no Item³
			//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
			SFC->( dbSetOrder(1) )
			SFC->(DbSeek(xFilial("SFC")+SD1->D1_TES))
			While SFC->FC_TES == SD1->D1_TES .And. !SFC->(EOF())
				
				SFB->( dbSetOrder(1) )
				SFB->(dBSeek(xFilial("SFB")+SFC->FC_IMPOSTO))
				cCpoBase := "D1"+Subs(SFB->FB_CPOBAEI,3,8)
				cCpoImp  := "D1"+Subs(SFB->FB_CPOVREI,3,8)
				nPos	:=	Ascan(aImpNF,{|x| x[1] == SFC->FC_IMPOSTO } )  
	
				If !Empty(SFB->FB_CPOBAEI) .And. !Empty(SFB->FB_CPOVREI)
					If nPos == 0              		
							aadd( aImpNF,{ SFC->FC_IMPOSTO, SFB->FB_DESCR, SFB->FB_ALIQ, , SD1->&(cCpoImp)} )
					Else                  
						aImpNF[nPos][4]	+= SD1->&(cCpoBase)            // Base de Calculo
						aImpNF[nPos][5]	+= SD1->&(cCpoImp)             // Valor do Imposto
					Endif
				EndIf
				SFC->(DbSkip())
			EndDo          
			DbSelectArea('SD1')
			SD1->(dbskip())
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		aUnid_Pro:={}                           // Unidade do Produto
		aDesc_pro:={}                           // Descricao do Produto
		aDescricao :={}                         // Descricao do Produto
		aCod_Trib:={}                           // Codigo de Tributacao
		cSuframa :=""
		cCalcSuf :=""
		
		I:=1                   
		For I:=1 to Len(aCod_Pro)
			dbSeek(xFilial()+aCod_Pro[I])
			dbSelectArea("SB1")
			AADD(aDesc_pro ,SB1->B1_DESC)
			AADD(aUnid_Pro ,SB1->B1_UM)
			AADD(aCod_Trib ,SB1->B1_ORIGEM)
			AADD(aDescricao ,SB1->B1_DESC)
		Next
		
		If cTipo == "D"
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+cFornece)
			cCod_Cli :=SA1->A1_COD             // Codigo do Cliente
			cNome_Cli:=SA1->A1_NOME            // Nome
			cEnd_Cli :=SA1->A1_END             // Endereco
			cBairro  :=SA1->A1_BAIRRO          // Bairro
			cCep_Cli :=SA1->A1_CEP             // CEP
			cCob_Cli :=SA1->A1_ENDCOB          // Endereco de Cobranca
			cRec_Cli :=SA1->A1_ENDENT          // Endereco de Entrega
			cMun_Cli :=SA1->A1_MUN             // Municipio
			cEst_Cli :=SA1->A1_EST             // Estado
			cCGC_Cli :=SA1->A1_CGC             // CGC
			cInsc_Cli:=SA1->A1_INSCR           // Inscricao estadual
			cTran_Cli:=SA1->A1_TRANSP          // Transportadora
			cTel_Cli :=SA1->A1_TEL             // Telefone
			cFax_Cli :=SA1->A1_FAX             // Fax
			
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+cFornece+cLoja)
			cCod_Cli :=SA2->A2_COD                // Codigo do Cliente
			cNome_Cli:=SA2->A2_NOME               // Nome
			cEnd_Cli :=SA2->A2_END                // Endereco
			cBairro  :=SA2->A2_BAIRRO             // Bairro
			cCep_Cli :=SA2->A2_CEP                // CEP
			cCob_Cli :=""                         // Endereco de Cobranca
			cRec_Cli :=""                         // Endereco de Entrega
			cMun_Cli :=SA2->A2_MUN                // Municipio
			cEst_Cli :=SA2->A2_EST                // Estado
			cCGC_Cli :=SA2->A2_CGC                // CGC
			cInsc_Cli:=SA2->A2_INSCR              // Inscricao estadual
			cTran_Cli:=SA2->A2_TRANSP             // Transportadora
			cTel_Cli :=SA2->A2_TEL                // Telefone
			cFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		aParc_Dup  :={}                       // Parcela
		aVenc_Dup  :={}                       // Vencimento
		aValor_Dup :={}                       // Valor
		cDuplicatas:=IIF(dbSeek(xFilial()+cSerie+cNum_Duplic,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		While !eof() .and. SE1->E1_NUM==cNum_Duplic .and. cDuplicatas==.T.
			AADD(aParc_Dup ,SE1->E1_PARCELA)
			AADD(aVenc_Dup ,SE1->E1_VENCTO)
			AADD(aValor_Dup,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_TES)
		cNatureza:=SF4->F4_TEXTO              // Natureza da Operacao
		
		cNome_Transp :=" "           // Nome Transportadora
		cEnd_Transp  :=" "           // Endereco
		cMun_Transp  :=" "           // Municipio
		cEst_Transp  :=" "           // Estado
		cVia_Transp  :=" "           // Via de Transporte
		cCGC_Transp  :=" "           // CGC
		cTel_Transp  :=" "           // Fone
		cTpFrete     :=" "           // Tipo de Frete
		nVolume      := 0            // Volume
		cEspecie     :=" "           // Especie
		cCod_Mens    :=" "           // Codigo da Mensagem
		cMensagem    :=" "           // Mensagem da Nota
		nPeso_Liquid :=0
		nPeso_Bruto  :=0
		
		// Inicia a Impressão da NF
		ImprimeLoc()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif
dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+
      
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMPLOC¦ Autor ¦   Gilson da Silva     ¦ Data ¦ 11/06/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function VerImpLoc()
nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	nOpc       := 1
	While .T.
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		IF MsgYesNo("Fomulario esta posicionado ? ")
			nOpc := 1
		ElseIF MsgYesNo("Tenta Novamente ? ")
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
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦IMPRIMELOC  ¦ Autor ¦ Gilson da Silva    ¦ Data ¦ 11/06./02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function ImprimeLoc()
Local nTotImp :=0
Local I := 0
Local nCol := 0
//+-------------------------------------+
//¦ Impressao do Cabecalho da N.F.      ¦
//+-------------------------------------+
@ 04, 000 PSAY Chr(23) 
@ 06, 000 PSAY Chr(15)                // Compressao de Impressao
IF(FUNNAME()=='MATA462N')
   @ 06, 016 PSAY PADC("R E M I T O  D E  V E N T A",213)
   @ 07, 016 PSAY "Número de Remito: " + alltrim(cNum_NF)
   @ 07, 058 PSAY "Serie: " +cSerie              // Serie 
else   
   @ 06, 016 PSAY PADC(cTitulo_cab,213)
   @ 07, 016 PSAY "Número de Remito: " + alltrim(cNum_NF) // Numero da Nota Fiscal
   @ 07, 055 PSAY "Serie: " +cSerie              // Serie
endif   

@ 07, 170 PSAY "Sucursal: " + cSucursal

//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+
//@ 09, 000 PSAY REPLICATE('-',213)
IF(FUNNAME()=='MATA462N')  
	@ 08, 016 PSAY "CLIENTE : "+cCod_Cli + " - " + cNome_Cli
else
	@ 08, 0016 PSAY "Proveedor : "+cCod_Cli + " - " + cNome_Cli
end     
@ 08, 170 PSAY "Fecha: "
@ 08, 178 PSAY dEmissao              // Data da Emissao do Documento

If mv_par04 == 2  // NF Saida
	//+-------------------------------------+
	//¦ Impressao da Fatura/Duplicata       ¦
	//+-------------------------------------+
	
	nLin:=19
	nCol := 10             
	DUPLICLOC()	//  Imprime dados da(s) duplicata(s)
Endif
//+-------------------------------------+
//¦ Imprime Linha Detalhe da NF         ¦
//+-------------------------------------+
nLin := 14
ImpDetLoc()                 

IF(FUNNAME()<>'MATA462N')    
  if mv_par04 == 2
	  @ 35, 0100  PSAY "valor Mercaderia: " + TRANSFORM(nValor_Merc,"@E 9,999,999.99")
	  @ 36, 0100  PSAY "valor Flete     : " + TRANSFORM(nFrete,"@E 9,999,999.99")
	  @ 37, 0100  PSAY "valor Seguro    : " + TRANSFORM(nSeguro,"@E 9,999,999.99")
	  @ 38, 0100  PSAY "Total Factura   : " + TRANSFORM(nTot_Fat,"@E 9,999,999.99") + Iif(nMoneda ==1,"  BOLIVIANOS","  DOLARES")
      @ 40, 016   PSAY "Usr   : " + cUserName + "  " + time()
  Else    
      nLin:=nLin+1
	  @ nLin, 0100  PSAY "valor Mercaderia: " + TRANSFORM(nValor_Merc,"@E 9,999,999.99")
      nLin:=nLin+1
	  @ nLin, 0100  PSAY "valor Flete     : " + TRANSFORM(nFrete,"@E 9,999,999.99")
      nLin:=nLin+1
	  @ nLin, 0100  PSAY "valor Seguro    : " + TRANSFORM(nSeguro,"@E 9,999,999.99")
      nLin:=nLin+1
	  @ nLin, 0100  PSAY "Total Remito    : " + TRANSFORM(nTot_Fat,"@E 9,999,999.99") + Iif(nMoneda ==1,"  BOLIVIANOS","  DOLARES")
      nLin:=nLin+1
      nLin:=nLin+1
      @ nLin, 016   PSAY "Usr   : " + cUserName + "  " + time()
      nLin:=nLin+1
  End
ENDIF

//+------------------------------------+
//¦ Impressao dos Impostos             ¦
//+------------------------------------+
IF(FUNNAME()<>'MATA462N') 
	if mv_par04 == 2
		nLin:= 61 
	else
	    nLin:=nLin+1
	end
    
If Len(aImpNF) > 0
	@nLin, 20 PSAY "IMPUESTO    ALICUOTA     BASE DE CALCULO    VALOR IMPUESTO"
	nLin :=nLin+1 
EndIf	
nTotImp:= 0
For  I:=1   to Len(aImpNF)
	@nLin, 23 PSAY aImpNF[I,1]  
	@nLin, 34 PSAY aImpNF[I,3]  Picture "@E 99.99%"
	@nLin, 47 PSAY aImpNF[I,4]  Picture "@E 99,999,999.99"
	@nLin, 65 PSAY aImpNF[I,5]  Picture "@E 99,999,999.99"	
	nLin :=nLin+1     
	nTotImp:= nTotImp+aImpNF[I,5]      
Next	     
//@ nLin,44  PSAY "TOTAL IMPUESTOS ==>> "  
//@ nLin,65  PSAY nTotImp       Picture"@E 99,999,999.99"
@ nLin+1, 000 PSAY chr(18)                   // Descompressao de Impressao
SetPrc(0,0)                              // (Zera o Formulario)
endif
Return 
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLICLOC ¦ Autor ¦   Gilson da Silva    ¦ Data ¦ 11/06/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Parcelamento das Duplicacatas                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function DUPLICLOC()
Local BB := 1
Local nCol := 10
Local nAjuste := 0
For BB:= 1 to Len(aValor_Dup)
	If cDuplicatas==.T. .and. BB<=Len(aValor_Dup)
		@ nLin, nCol + nAjuste      PSAY cNum_Duplic + " " + aParc_Dup[BB]
		@ nLin, nCol + 16 + nAjuste      PSAY aVenc_Dup[BB]
		@ nLin, nCol + 31 + nAjuste PSAY aValor_Dup[BB] Picture("@E 9,999,999.99")
		nAjuste := nAjuste + 50
	Endif
Next
Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDETLOC   ¦ Autor ¦   Gilson da Silva  ¦ Data ¦ 11/06/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function IMPDETLOC()
Local nTamDet :=if(mv_par04==2,10,999)            // Tamanho da Area de Detalhe
Local I :=1
Local J :=1
Local L :=nLin           
//alert('impdetloc')
  nLin := nLin-3
@ nLin, 00 PSAY REPLICATE('-',213) 
  nLin := nLin+1
  If mv_par04 == 2
  	//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  	@ nLin, 016 PSAY "CODIGO            DESCRIPCION                      UNID.        CANTIDAD        VAL UNIT.        VALOR TOTAL     LOTE         VALIDEZ       TES  "
  	//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  else
  	//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  	@ nLin, 016 PSAY "CODIGO            DESCRIPCION                      UNID.        CANTIDAD        VAL UNIT.        VALOR TOTAL     LOTE         VALIDEZ       TES     PED.COMPRA  UBICACION         FABRICANTE"
  	//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  end
  nLin := nLin+1
@ nLin, 00 PSAY REPLICATE('-',213) 
nLin := L         
//alert('entre')
For _I:=1 to nTamDET
	//ALERT("I: " + CVALTOCHAR(_I))
	//ALERT("codpro:" + cvaltochar(len(aCod_Pro)))
    IF _I <= Len(aCod_Pro)                                                                            
   // alert(aTes[_I])
		@ nLin, 017  PSAY alltrim(Substr(aCod_Pro[_I],1,15))	Picture "@!"
		@ nLin, 035  PSAY  alltrim(Substr(aDescricao[_I],1,40))			
//	   	@ nLin, 078  PSAY RTRIM (aCod_Trib[I])
		@ nLin, 068  PSAY aUnid_Pro[_I]
		@ nLin, 077  PSAY aQtd_Pro[_I]               Picture"@E 999,999.99"
		@ nLin, 092  PSAY aPre_Uni[_I]               Picture"@E 99,999,999.99"
		@ nLin, 110  PSAY aVal_Merc[_I]              Picture"@E 99,999,999.99"                  
		@ nLin, 128  PSAY alltrim(aPre_Lot[_I]) // lote    
		@ nLin, 140  PSAY aPre_Fel[_I]      
		@ nLin, 155  PSAY cvaltochar(alltrim(aTES[_I]))
		If mv_par04 == 1
			@ nLin, 165  PSAY aPedido [_I]
			//@ nLin, 165  PSAY POSICIONE('SC7',3,XFILIAL('SC7')+ SF1->F1_FORNECE + SF1->F1_LOJA+ aPedido [_I],'C7_NUMSC')
		end
		@ nLin, 177  PSAY aLoliz[_I] //ubicacion
		@ nLin, 195  PSAY aFabric[_I]//fabricante
//		J:=J+1 
    ELSE
       _i:=ntamdet
	END	
	nLin :=nLin+1
Next _I                 
//ALERT('FIM FOR')
  L:=nLin+1
@ L, 00 PSAY REPLICATE('-',213)
	nLin :=nLin+1
IF(FUNNAME()=='MATA462N')
	L++ 
	@ L, 0100  PSAY "valor Mercaderia: " + TRANSFORM(nValor_Merc,"@E 9,999,999.99")
	L++
	@ L, 0100  PSAY "valor Flete     : " + TRANSFORM(nFrete,"@E 9,999,999.99")
	L++
	@ L, 0100  PSAY "valor Seguro    : " + TRANSFORM(nSeguro,"@E 9,999,999.99")
	L++
	@ L, 0100  PSAY "Total Factura   : " + TRANSFORM(nTot_Fat,"@E 9,999,999.99") + Iif(nMoneda ==1,"  BOLIVIANOS","  DOLARES")
	L++
	L++
	@ L, 016   PSAY "Usr   : " + cUserName + "  " + time()
	
ENDIF
Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MENSOBSLOC  ¦ Autor ¦   Gilson da Silva   ¦ Data ¦ 11/06/02¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem no Campo Observacao                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function MENSOBSLOC()
Local nCol := 05
Local nTamObs:=150
@ nLin, nCol PSAY UPPER(SUBSTR(cMensagem,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(cMensagem,151,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(cMensagem,301,nTamObs))
Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPMENPLOC ¦ Autor ¦   Gilson da Silva   ¦ Data ¦ 11/06/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem Padrao da Nota Fiscal                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function IMPMENPLOC()
Local nCol:= 05
If !Empty(cCod_Mens)
	@ nLin, NCol PSAY FORMULA(cCod_Mens)
Endif
Return