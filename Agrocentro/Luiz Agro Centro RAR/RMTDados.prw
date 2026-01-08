#include "totvs.ch"

/*/{Protheus.doc} RMTDados
Gera ados
@type function
@version 1.0
@author Luiz Fael
@since 10/01/2023
@param oProcess, object, Objeto Regua
@param oPrn, object, Objeto Impressao
@param aSF2, array, Dados Cabec
@param aSD2, array, Dados Itens
@return variant, Return F T
/*/
User Function RMTDados(oProcess,oPrn,aSF2,aSD2)
	Local 	aArea	:= GetArea()
	Local 	lRet 	:= .T.
	SB1->(dbSetOrder(1))
	SA3->(dbSetOrder(1))
	SF4->(dbSetOrder(1))
	faSF2(oProcess,oPrn,@aSF2,@aSD2)
	If Len(aSF2) <> 0
		faSD2(oProcess,oPrn,@aSF2,@aSD2)
	EndIf
	RestArea(aArea)
Return(lRet)

/*/{Protheus.doc} faSF2
Gera Itens
@type function
@version 1.0
@author Luiz Fael
@since 10/01/2023
@param oProcess, object, Objeto Regua
@param oPrn, object, Objeto Impressao
@param aSF2, array, Dados cabec
@param aSD2, array, dados Item
@return variant, Retorno Logico
/*/
Static Function faSF2(oProcess,oPrn,aSF2,aSD2)
	Local 	nX 				:=  0
	Local 	nY				:=	0
	Local 	cCampo 			:=  ''
	Local 	cQuery 			:=  ''
	Local 	aDupli 			:=	{}
	Local 	aSF2Rec			:=  {}
	Local 	aCliFor 		:=  {}
	Local 	aTrans 			:=	{}
	Local 	aPed			:=  {}
	Local 	aVend 			:=	{}
	Local 	cTITPais		:=  ''
	Local 	lRet 			:=  .T.
	Private nSD2Rec			:=  0

	If cPaisLoc == "ARG" .OR. cPaisLoc == "BOL"
		cTITPais 	:=	'X3_TITSPA'
	Elseif cPaisLoc == "ENG"
		cTITPais 	:=	'X3_TITENG'
	Else
		cTITPais 	:=	'X3_TITULO'
	EndIf

	cQuery += "SELECT "
	cQuery += " SF2.R_E_C_N_O_ AS 'F2_REC'  "
	cQuery += " FROM " + RetSQLName("SF2") + " SF2 "
	cQuery += " WHERE "
	cQuery += " 		SF2.F2_FILIAL = '" +MV_PAR1+ "' "
	cQuery += "			AND SF2.F2_DOC+SF2.F2_SERIE = '" + SC5->C5_NOTA+SC5->C5_SERIE + "' "
	cQuery += " 		AND SF2.D_E_L_E_T_ = '' "
	aSF2Rec := JursQL(cQuery,{'F2_REC'})

	If Len(aSF2Rec) <> 0
		SF2->(dbGoto(aSF2Rec[1][1]))
		cQuery := "SELECT "
		cQuery += " SD2.R_E_C_N_O_ AS 'D2_REC'  "
		cQuery += " FROM " + RetSQLName("SD2") + " SD2 "
		cQuery += " WHERE "
		cQuery += " 		SD2.D2_FILIAL      = '" + SF2->F2_FILIAL+ "' "
		cQuery += "			AND SD2.D2_DOC	   = '" + SF2->F2_DOC   + "' "
		cQuery += "			AND SD2.D2_SERIE   = '" + SF2->F2_SERIE + "' "
		cQuery += " 		AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY SD2.D2_ITEM "
		aSD2   := JursQL(cQuery,{'D2_REC'})
		If Len(aSD2) <> 0
			oProcess:SetRegua2(19)
			oProcess:IncRegua2("Generando Cabec ...")
			//Blocos------------------------------------------------------------------------------------------------------------//
			aadd(aSF2,Array(21)) 	//aSF2[01] Ordem de venta
			aadd(aSF2,Array(28)) 	//aSF2[02] Nota Fiscal
			aadd(aSF2,Array(17))	//aSF2[03] Cliente
			aadd(aSF2,{}) 			//aSF2[04] Impostos
			aadd(aSF2,{}) 			//aSF2[05] Valor fatura
			aadd(aSF2,{})			//aSF2[06] Vendedor
			aadd(aSF2,{})			//aSF2[07] Transportadora
			aadd(aSF2,{}) 			//aSF2[08] Duplicatas
			oProcess:IncRegua2("Generando Cabec ...")
			//Pedido de Venda---------------------------------------------------------------------------------------------------// GetSx3Cache("RA_MAT", "X3_TAMANHO"
			aSF2[01][01]					:= {'C5_FILIAL'	 		  	,SC5->C5_FILIAL		,Alltrim(GetSx3Cache('C5_FILIAL' 	,cTITPais)),GetSx3Cache('C5_FILIAL'	,'X3_TIPO'),GetSx3Cache('C5_FILIAL','X3_PICTURE')}
			aSF2[01][02]					:= {'C5_NUM'	 		  	,SC5->C5_NUM		,Alltrim(GetSx3Cache('C5_NUM' 		,cTITPais)),GetSx3Cache('C5_NUM'	,'X3_TIPO'),GetSx3Cache('C5_NUM'   ,'X3_PICTURE')}
			aSF2[01][03]					:= {'C5_DOCGER'				,SC5->C5_DOCGER 	,Alltrim(GetSx3Cache('C5_DOCGER' 	,cTITPais)),GetSx3Cache('C5_DOCGER'	,'X3_TIPO'),GetSx3Cache('C5_DOCGER','X3_PICTURE')}
			iF  SC5->C5_DOCGER 				== '1'
				aSF2[01][03][02] 			:=  '1 - Nota Fiscal'
			ElseIf 	SC5->C5_DOCGER 			== '2'
				aSF2[01][03][02] 			:=  '2 - Remito'
			ElseIf 	SC5->C5_DOCGER 			== '3'
				aSF2[01][03][02] 			:=  '3 - Entrega Futura'
			EndIf
			oProcess:IncRegua2("Generando Cabec ...")
			aSF2[01][04]					:= {'C5_TIPOREM'			,SC5->C5_TIPOREM	,Alltrim(GetSx3Cache('C5_TIPOREM'	,cTITPais)),GetSx3Cache('C5_TIPOREM','X3_TIPO'),GetSx3Cache('C5_TIPOREM','X3_PICTURE')}
			iF  SC5->C5_TIPOREM 			== '0'
				aSF2[01][04][02] 			:=	'0 - Venda'
			ElseIf 	SC5->C5_TIPOREM 		== 'A'
				aSF2[01][04][02] 			:=	'A - Consignacao'
			EndIf
			aSF2[01][05]					:= {'C5_TIPO'		 		,SC5->C5_TIPO		,Alltrim(GetSx3Cache('C5_TIPO' 		,cTITPais)),GetSx3Cache('C5_TIPO'	,'X3_TIPO'),GetSx3Cache('C5_TIPO'	,'X3_PICTURE')} 	// Tipo Nota
			aSF2[01][06]					:= {'C5_CLIENTE'	 		,SC5->C5_CLIENTE	,Alltrim(GetSx3Cache('C5_CLIENTE' 	,cTITPais)),GetSx3Cache('C5_CLIENTE','X3_TIPO'),GetSx3Cache('C5_CLIENTE','X3_PICTURE')} 	// Codigo do Cliente
			aSF2[01][07]					:= {'C5_LOJACLI'	 		,SC5->C5_LOJACLI	,Alltrim(GetSx3Cache('C5_LOJACLI'	,cTITPais)),GetSx3Cache('C5_LOJACLI','X3_TIPO'),GetSx3Cache('C5_LOJACLI','X3_PICTURE')} 	// Loja do Cliente
			aSF2[01][08]					:= {'C5_TIPOCLI' 		  	,SC5->C5_TIPOCLI	,Alltrim(GetSx3Cache('C5_TIPOCLI' 	,cTITPais)),GetSx3Cache('C5_TIPOCLI','X3_TIPO'),GetSx3Cache('C5_TIPOCLI','X3_PICTURE')} 	// Tipo de Cliente
			iF  SC5->C5_TIPOCLI 			== '1'
				aSF2[01][08][02] 			:= '1 - Grande Contribuinte'
			ElseIf SC5->C5_TIPOCLI 			== '2'
				aSF2[01][08][02]			:= '2 - Consumidor Final'
			ElseIf SC5->C5_TIPOCLI 			== '3'
				aSF2[01][08][02]			:= '3 - Exterior'
			ElseIf SC5->C5_TIPOCLI 			== '4'
				aSF2[01][08][02]			:= '4 - Taxa Zero Z.Franca'
			ElseIf SC5->C5_TIPOCLI 			== '5'
				aSF2[01][08][02]			:= '5 - Taxa Zero Ext'
			ElseIf SC5->C5_TIPOCLI 			== '6'
				aSF2[01][08][02]			:= '6 - Isento'
			EndIf
			oProcess:IncRegua2("Generando Cabec ...")
			aSF2[01][09]					:= {'C5_MENPAD'	 	,SC5->C5_MENPAD 	,Alltrim(GetSx3Cache('C5_MENPAD' 	,cTITPais)),GetSx3Cache('C5_MENPAD'	,'X3_TIPO'),GetSx3Cache('C5_MENPAD'		,'X3_PICTURE')} // Codigo da Mensagem Padrao
			aSF2[01][10]					:= {'C5_MENNOTA' 	,SC5->C5_MENNOTA	,Alltrim(GetSx3Cache('C5_MENNOTA' 	,cTITPais)),GetSx3Cache('C5_MENNOTA','X3_TIPO'),GetSx3Cache('C5_MENNOTA'	,'X3_PICTURE')} // Mensagem para a Nota Fiscal
			aSF2[01][11]					:= {'C5_TPFRETE' 	,SC5->C5_TPFRETE	,Alltrim(GetSx3Cache('C5_TPFRETE' 	,cTITPais)),GetSx3Cache('C5_TPFRETE','X3_TIPO'),GetSx3Cache('C5_TPFRETE'	,'X3_PICTURE')} // Tipo de Entrega
			aSF2[01][12]					:= {'C5_CONDPAG' 	,SC5->C5_CONDPAG	,Alltrim(GetSx3Cache('C5_CONDPAG' 	,cTITPais)),GetSx3Cache('C5_CONDPAG','X3_TIPO'),GetSx3Cache('C5_CONDPAG'	,'X3_PICTURE')} // Condicao de Pagamento
			aSF2[01][13]					:= {'C5_DESC1'	 	,SC5->C5_DESC1  	,Alltrim(GetSx3Cache('C5_DESC1' 	,cTITPais)),GetSx3Cache('C5_DESC1'	,'X3_TIPO'),GetSx3Cache('C5_DESC1'		,'X3_PICTURE')}
			aSF2[01][14]					:= {'C5_DESC2'	 	,SC5->C5_DESC2  	,Alltrim(GetSx3Cache('C5_DESC2' 	,cTITPais)),GetSx3Cache('C5_DESC2'	,'X3_TIPO'),GetSx3Cache('C5_DESC2'		,'X3_PICTURE')}
			aSF2[01][15]					:= {'C5_DESC3'	 	,SC5->C5_DESC3  	,Alltrim(GetSx3Cache('C5_DESC3' 	,cTITPais)),GetSx3Cache('C5_DESC3'	,'X3_TIPO'),GetSx3Cache('C5_DESC3'		,'X3_PICTURE')}
			aSF2[01][16]					:= {'C5_DESC4'	 	,SC5->C5_DESC4  	,Alltrim(GetSx3Cache('C5_DESC4' 	,cTITPais)),GetSx3Cache('C5_DESC4'	,'X3_TIPO'),GetSx3Cache('C5_DESC4'		,'X3_PICTURE')}  // Desconto Global
			aSF2[01][17]					:= {'C5_PBRUTO'		,SC5->C5_PBRUTO		,Alltrim(GetSx3Cache('C5_PBRUTO'	,cTITPais)),GetSx3Cache('C5_PBRUTO'	,'X3_TIPO'),GetSx3Cache('C5_PBRUTO'		,'X3_PICTURE')}
			aSF2[01][18]					:= {'C5_CAMPANA' 	,SC5->C5_CAMPANA	,Alltrim(GetSx3Cache('C5_CAMPANA'	,cTITPais)),GetSx3Cache('C5_CAMPANA','X3_TIPO'),GetSx3Cache('C5_CAMPANA'	,'X3_PICTURE')}
			aSF2[01][19]					:= {'C5_CAMPDES' 	,SC5->C5_CAMPDES	,Alltrim(GetSx3Cache('C5_CAMPDES'	,cTITPais)),GetSx3Cache('C5_CAMPDES','X3_TIPO'),GetSx3Cache('C5_CAMPDES'	,'X3_PICTURE')}
			aSF2[01][20]					:= {'C5_CAMPRO' 	,SC5->C5_CAMPRO		,Alltrim(GetSx3Cache('C5_CAMPRO'	,cTITPais)),GetSx3Cache('C5_CAMPRO'	,'X3_TIPO'),GetSx3Cache('C5_CAMPRO'		,'X3_PICTURE')}
			aSF2[01][21]					:= {'C5_CAMPROD' 	,SC5->C5_CAMPROD	,Alltrim(GetSx3Cache('C5_CAMPROD'	,cTITPais)),GetSx3Cache('C5_CAMPROD','X3_TIPO'),GetSx3Cache('C5_CAMPROD'	,'X3_PICTURE')}
			oProcess:IncRegua2("Generando Cabec ...")
			//Nota Fiscal--------------------------------------------------------------------------------------------------------//
			aSF2[02][01]					:= {'F2_FILIAL'		,SF2->F2_FILIAL		,Alltrim(GetSx3Cache('F2_FILIAL' 	,cTITPais)),GetSx3Cache('F2_FILIAL'	,'X3_TIPO'),GetSx3Cache('F2_FILIAL'		,'X3_PICTURE')}
			aSF2[02][02]					:= {'F2_PREFIXO'	,SF2->F2_PREFIXO	,Alltrim(GetSx3Cache('F2_PREFIXO'	,cTITPais)),GetSx3Cache('F2_PREFIXO','X3_TIPO'),GetSx3Cache('F2_PREFIXO'	,'X3_PICTURE')}
			aSF2[02][03]					:= {'F2_DOC'   		,SF2->F2_DOC		,Alltrim(GetSx3Cache('F2_DOC	'	,cTITPais)),GetSx3Cache('F2_DOC	'	,'X3_TIPO'),GetSx3Cache('F2_DOC	'		,'X3_PICTURE')}
			aSF2[02][04]					:= {'F2_SERIE' 		,SF2->F2_SERIE		,Alltrim(GetSx3Cache('F2_SERIE	'	,cTITPais)),GetSx3Cache('F2_SERIE'	,'X3_TIPO'),GetSx3Cache('F2_SERIE'		,'X3_PICTURE')}
			aSF2[02][05]					:= {'F2_CLIENTE'	,SF2->F2_CLIENTE	,Alltrim(GetSx3Cache('F2_CLIENTE'	,cTITPais)),GetSx3Cache('F2_CLIENTE','X3_TIPO'),GetSx3Cache('F2_CLIENTE'	,'X3_PICTURE')}
			aSF2[02][06]					:= {'F2_LOJA'   	,SF2->F2_LOJA		,Alltrim(GetSx3Cache('F2_LOJA	'	,cTITPais)),GetSx3Cache('F2_LOJA'	,'X3_TIPO'),GetSx3Cache('F2_LOJA'		,'X3_PICTURE')}
			aSF2[02][07]					:= {'F2_CLIENT' 	,SF2->F2_CLIENT		,Alltrim(GetSx3Cache('F2_CLIENT	'	,cTITPais)),GetSx3Cache('F2_CLIENT'	,'X3_TIPO'),GetSx3Cache('F2_CLIENT'		,'X3_PICTURE')}
			aSF2[02][08]					:= {'F2_LOJENT' 	,SF2->F2_LOJENT		,Alltrim(GetSx3Cache('F2_LOJENT	'	,cTITPais)),GetSx3Cache('F2_LOJENT'	,'X3_TIPO'),GetSx3Cache('F2_LOJENT'		,'X3_PICTURE')}
			aSF2[02][09]					:= {'F2_COND'   	,SF2->F2_COND		,Alltrim(GetSx3Cache('F2_COND	'	,cTITPais)),GetSx3Cache('F2_COND'	,'X3_TIPO'),GetSx3Cache('F2_COND'		,'X3_PICTURE')}
			aSF2[02][10]					:= {'F2_DUPL'   	,SF2->F2_DUPL		,Alltrim(GetSx3Cache('F2_DUPL	'	,cTITPais)),GetSx3Cache('F2_DUPL'	,'X3_TIPO'),GetSx3Cache('F2_DUPL'		,'X3_PICTURE')}
			aSF2[02][11]					:= {'F2_EMISSAO'	,SF2->F2_EMISSAO	,Alltrim(GetSx3Cache('F2_EMISSAO'	,cTITPais)),GetSx3Cache('F2_EMISSAO','X3_TIPO'),GetSx3Cache('F2_EMISSAO'	,'X3_PICTURE')}
			aSF2[02][12]					:= {'F2_EST'    	,SF2->F2_EST		,Alltrim(GetSx3Cache('F2_EST	'	,cTITPais)),GetSx3Cache('F2_EST	'	,'X3_TIPO'),GetSx3Cache('F2_EST	'		,'X3_PICTURE')}
			aSF2[02][13]					:= {'F2_FRETE'  	,SF2->F2_FRETE		,Alltrim(GetSx3Cache('F2_FRETE	'	,cTITPais)),GetSx3Cache('F2_FRETE'	,'X3_TIPO'),GetSx3Cache('F2_FRETE'		,'X3_PICTURE')}
			oProcess:IncRegua2("Generando Cabec ...")
			aSF2[02][14]					:= {'F2_TIPO'   	,SF2->F2_TIPO		,Alltrim(GetSx3Cache('F2_TIPO	'	,cTITPais)),GetSx3Cache('F2_TIPO'	,'X3_TIPO'),GetSx3Cache('F2_TIPO'		,'X3_PICTURE')}
			aSF2[02][15]					:= {'F2_TRANSP' 	,SF2->F2_TRANSP		,Alltrim(GetSx3Cache('F2_TRANSP	'	,cTITPais)),GetSx3Cache('F2_TRANSP'	,'X3_TIPO'),GetSx3Cache('F2_TRANSP'		,'X3_PICTURE')}
			aSF2[02][16]					:= {'F2_ESPECIE'	,SF2->F2_ESPECIE	,Alltrim(GetSx3Cache('F2_ESPECIE'	,cTITPais)),GetSx3Cache('F2_ESPECIE','X3_TIPO'),GetSx3Cache('F2_ESPECIE'	,'X3_PICTURE')}
			aSF2[02][17]					:= {'F2_MOEDA'  	,SF2->F2_MOEDA		,Alltrim(GetSx3Cache('F2_MOEDA	'	,cTITPais)),GetSx3Cache('F2_MOEDA'	,'X3_TIPO'),GetSx3Cache('F2_MOEDA'		,'X3_PICTURE')}
			aSF2[02][18]					:= {'F2_REGIAO' 	,SF2->F2_REGIAO		,Alltrim(GetSx3Cache('F2_REGIAO	'	,cTITPais)),GetSx3Cache('F2_REGIAO'	,'X3_TIPO'),GetSx3Cache('F2_REGIAO'		,'X3_PICTURE')}
			aSF2[02][19]					:= {'F2_NATUREZ'	,SF2->F2_NATUREZ	,Alltrim(GetSx3Cache('F2_NATUREZ'	,cTITPais)),GetSx3Cache('F2_NATUREZ','X3_TIPO'),GetSx3Cache('F2_NATUREZ'	,'X3_PICTURE')}
			aSF2[02][20]					:= {'F2_TIPOREM'	,SF2->F2_TIPOREM	,Alltrim(GetSx3Cache('F2_TIPOREM'	,cTITPais)),GetSx3Cache('F2_TIPOREM','X3_TIPO'),GetSx3Cache('F2_TIPOREM'	,'X3_PICTURE')}
			aSF2[02][21]					:= {'F2_TABELA' 	,SF2->F2_TABELA		,Alltrim(GetSx3Cache('F2_TABELA	'	,cTITPais)),GetSx3Cache('F2_TABELA'	,'X3_TIPO'),GetSx3Cache('F2_TABELA'		,'X3_PICTURE')}
			aSF2[02][22]					:= {'F2_MENNOTA'	,SF2->F2_MENNOTA	,Alltrim(GetSx3Cache('F2_MENNOTA'	,cTITPais)),GetSx3Cache('F2_MENNOTA','X3_TIPO'),GetSx3Cache('F2_MENNOTA'	,'X3_PICTURE')}
			aSF2[02][23]					:= {'F2_TIPOCLI'	,SF2->F2_TIPOCLI	,Alltrim(GetSx3Cache('F2_TIPOCLI'	,cTITPais)),GetSx3Cache('F2_TIPOCLI','X3_TIPO'),GetSx3Cache('F2_TIPOCLI'	,'X3_PICTURE')}
			aSF2[02][24]					:= {'F2_TIPOREM'	,SF2->F2_TIPOREM	,Alltrim(GetSx3Cache('F2_TIPOREM'	,cTITPais)),GetSx3Cache('F2_TIPOREM','X3_TIPO'),GetSx3Cache('F2_TIPOREM'	,'X3_PICTURE')}
			aSF2[02][25]					:= {'F2_ESPECI1' 	,SF2->F2_ESPECI1	,Alltrim(GetSx3Cache('F2_ESPECI1'	,cTITPais)),GetSx3Cache('F2_ESPECI1','X3_TIPO'),GetSx3Cache('F2_ESPECI1'	,'X3_PICTURE')}
			aSF2[02][26]					:= {'F2_VOLUME1' 	,SF2->F2_VOLUME1	,Alltrim(GetSx3Cache('F2_VOLUME1'	,cTITPais)),GetSx3Cache('F2_VOLUME1','X3_TIPO'),GetSx3Cache('F2_VOLUME1'	,'X3_PICTURE')}
			aSF2[02][27]					:= {'F2_CAMPANA' 	,SF2->F2_CAMPANA	,Alltrim(GetSx3Cache('F2_CAMPANA'	,cTITPais)),GetSx3Cache('F2_CAMPANA','X3_TIPO'),GetSx3Cache('F2_CAMPANA'	,'X3_PICTURE')}
			aSF2[02][28]					:= {'F2_CAMPRO' 	,SF2->F2_CAMPRO		,Alltrim(GetSx3Cache('F2_CAMPRO'	,cTITPais)),GetSx3Cache('F2_CAMPRO'	,'X3_TIPO'),GetSx3Cache('F2_CAMPRO'		,'X3_PICTURE')}
			oProcess:IncRegua2("Generando Cabec ...")
			//Cliente-----------------------------------------------------------------------------------------------------------//
			cQuery := " SELECT "
			cQuery += "		 SA1.R_E_C_N_O_ A1_REC
			cQuery += "		 FROM " + RetSQLName("SA1") + " SA1 "
			cQuery += "		 WHERE "
			cQuery += "		 			SA1.A1_FILIAL      	= '" + xFilial('SA1')	+ "' "
			cQuery += "					AND SA1.A1_COD		= '" + SF2->F2_CLIENTE  	+ "' "
			cQuery += "					AND SA1.A1_LOJA   	= '" + SF2->F2_LOJA		+ "' "
			cQuery += "		 			AND SA1.D_E_L_E_T_ 	= ' ' "
			aCliFor := JursQL(cQuery,{'A1_REC'})
			oProcess:IncRegua2("Generando Client ...")
			iF  Len(aCliFor) <> 0
				SA1->(dbGoto(aCliFor[1][1]))
				aSF2[03][01] 				:=	{'A1_COD'    	,SA1->A1_COD     	,Alltrim(GetSx3Cache('A1_COD' 		,cTITPais)),GetSx3Cache('A1_COD'	,'X3_TIPO'),GetSx3Cache('A1_COD'	,'X3_PICTURE')} 	// Codigo do Fornecedor
				aSF2[03][02] 				:=	{'A1_NOME'   	,SA1->A1_NOME    	,Alltrim(GetSx3Cache('A1_NOME' 		,cTITPais)),GetSx3Cache('A1_NOME'	,'X3_TIPO'),GetSx3Cache('A1_NOME'	,'X3_PICTURE')} 	// Nome Fornecedor
				aSF2[03][03] 				:=	{'A1_END'    	,SA1->A1_END     	,Alltrim(GetSx3Cache('A1_END' 		,cTITPais)),GetSx3Cache('A1_END' 	,'X3_TIPO'),GetSx3Cache('A1_END' 	,'X3_PICTURE')} 	// Endereco
				aSF2[03][04] 				:=	{'A1_BAIRRO' 	,SA1->A1_BAIRRO  	,Alltrim(GetSx3Cache('A1_BAIRRO' 	,cTITPais)),GetSx3Cache('A1_BAIRRO'	,'X3_TIPO'),GetSx3Cache('A1_BAIRRO'	,'X3_PICTURE')} 	// Bairro
				aSF2[03][05] 				:=	{'A1_CEP'    	,SA1->A1_CEP     	,Alltrim(GetSx3Cache('A1_CEP' 		,cTITPais)),GetSx3Cache('A1_CEP' 	,'X3_TIPO'),GetSx3Cache('A1_CEP' 	,'X3_PICTURE')} 	// CEP
				aSF2[03][06] 				:=	{'A1_ENDCOB' 	,SA1->A1_ENDCOB  	,Alltrim(GetSx3Cache('A1_ENDCOB'	,cTITPais)),GetSx3Cache('A1_ENDCOB'	,'X3_TIPO'),GetSx3Cache('A1_ENDCOB'	,'X3_PICTURE')} 	// Endereco de Cobranca
				aSF2[03][07] 				:=	{'A1_ENDENT' 	,SA1->A1_ENDENT  	,Alltrim(GetSx3Cache('A1_ENDENT' 	,cTITPais)),GetSx3Cache('A1_ENDENT' ,'X3_TIPO'),GetSx3Cache('A1_ENDENT'	,'X3_PICTURE')} 	// Endereco de Entrega
				aSF2[03][08] 				:=	{'A1_MUN'    	,SA1->A1_MUN     	,Alltrim(GetSx3Cache('A1_MUN' 		,cTITPais)),GetSx3Cache('A1_MUN' 	,'X3_TIPO'),GetSx3Cache('A1_MUN' 	,'X3_PICTURE')} 	// Municipio
				aSF2[03][09] 				:=	{'A1_EST'    	,SA1->A1_EST     	,Alltrim(GetSx3Cache('A1_EST' 		,cTITPais)),GetSx3Cache('A1_EST' 	,'X3_TIPO'),GetSx3Cache('A1_EST' 	,'X3_PICTURE')} 	// Estado
				aSF2[03][10] 				:=	{'A1_CGC'    	,SA1->A1_CGC     	,Alltrim(GetSx3Cache('A1_CGC' 		,cTITPais)),GetSx3Cache('A1_CGC' 	,'X3_TIPO'),GetSx3Cache('A1_CGC' 	,'X3_PICTURE')} 	// CGC
				oProcess:IncRegua2("Generando Client ...")
				aSF2[03][11] 				:=	{'A1_INSCR'  	,SA1->A1_INSCR   	,Alltrim(GetSx3Cache('A1_INSCR' 	,cTITPais)),GetSx3Cache('A1_INSCR' 	,'X3_TIPO'),GetSx3Cache('A1_INSCR'  ,'X3_PICTURE')}	// Inscricao estadual
				aSF2[03][12] 				:=	{'A1_TRANSP' 	,SA1->A1_TRANSP  	,Alltrim(GetSx3Cache('A1_TRANSP' 	,cTITPais)),GetSx3Cache('A1_TRANSP' ,'X3_TIPO'),GetSx3Cache('A1_TRANSP' ,'X3_PICTURE')}	// Transportadora
				aSF2[03][13] 				:=	{'A1_TEL'    	,SA1->A1_TEL     	,Alltrim(GetSx3Cache('A1_TEL' 		,cTITPais)),GetSx3Cache('A1_TEL' 	,'X3_TIPO'),GetSx3Cache('A1_TEL' 	,'X3_PICTURE')} 	// Telefone
				aSF2[03][14] 				:=	{'A1_FAX'    	,SA1->A1_FAX     	,Alltrim(GetSx3Cache('A1_FAX' 		,cTITPais)),GetSx3Cache('A1_FAX' 	,'X3_TIPO'),GetSx3Cache('A1_FAX' 	,'X3_PICTURE')} 	// Fax
				aSF2[03][15] 				:=	{'A1_SUFRAMA'	,SA1->A1_SUFRAMA 	,Alltrim(GetSx3Cache('A1_SUFRAMA' 	,cTITPais)),GetSx3Cache('A1_SUFRAMA','X3_TIPO'),GetSx3Cache('A1_SUFRAMA','X3_PICTURE')} 	// Suframa
				aSF2[03][16] 				:=	{'A1_CALCSUF'	,SA1->A1_CALCSUF 	,Alltrim(GetSx3Cache('A1_CALCSUF' 	,cTITPais)),GetSx3Cache('A1_CALCSUF','X3_TIPO'),GetSx3Cache('A1_CALCSUF','X3_PICTURE')} 	// Classe Suframa
				aSF2[03][17] 				:= 	{'A1_MENSAGE'	,SA1->A1_MENSAGE 	,Alltrim(GetSx3Cache('A1_MENSAGE' 	,cTITPais)),GetSx3Cache('A1_MENSAGE','X3_TIPO'),GetSx3Cache('A1_MENSAGE','X3_PICTURE')} 	// Classe Suframa ' '+SA1->A1_MENSAGE
			Else
				aSF2[03] := {}
			EndIf
			oProcess:IncRegua2("Generando Client ...")
			//Impostos-----------------------------------------------------------------------------------------------------------//
			aSF2[04] := Array(10)
			oProcess:IncRegua2("Generando Imp ...")
			If 	SF2->F2_VALIMP1+SF2->F2_VALIMP2+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5+SF2->F2_VALIMP6+;
					SF2->F2_VALIMP7+SF2->F2_VALIMP8+SF2->F2_VALIMP9 <> 0
				// Se o campo F2_VALFAT (VALOR DA FATURA) estiver zerado, calcula o total da fatura
				// somando os valores dos impostos + o valor da mercadoria + Despesas + Seguro + Frete - Descontos
				aSF2[04][01] 				:= {'F2_VALIMP1'	,SF2->F2_VALIMP1	,Alltrim(GetSx3Cache('F2_VALIMP1'	,cTITPais)),GetSx3Cache('F2_VALIMP1','X3_TIPO'),GetSx3Cache('F2_VALIMP1','X3_PICTURE')}
				aSF2[04][02] 				:= {'F2_VALIMP2'	,SF2->F2_VALIMP2	,Alltrim(GetSx3Cache('F2_VALIMP2'	,cTITPais)),GetSx3Cache('F2_VALIMP2','X3_TIPO'),GetSx3Cache('F2_VALIMP2','X3_PICTURE')}
				aSF2[04][03] 				:= {'F2_VALIMP3'	,SF2->F2_VALIMP3	,Alltrim(GetSx3Cache('F2_VALIMP3'	,cTITPais)),GetSx3Cache('F2_VALIMP3','X3_TIPO'),GetSx3Cache('F2_VALIMP3','X3_PICTURE')}
				aSF2[04][04] 				:= {'F2_VALIMP4'	,SF2->F2_VALIMP4	,Alltrim(GetSx3Cache('F2_VALIMP4'	,cTITPais)),GetSx3Cache('F2_VALIMP4','X3_TIPO'),GetSx3Cache('F2_VALIMP4','X3_PICTURE')}
				aSF2[04][05] 				:= {'F2_VALIMP5'	,SF2->F2_VALIMP5	,Alltrim(GetSx3Cache('F2_VALIMP5'	,cTITPais)),GetSx3Cache('F2_VALIMP5','X3_TIPO'),GetSx3Cache('F2_VALIMP5','X3_PICTURE')}
				aSF2[04][06] 				:= {'F2_VALIMP6'	,SF2->F2_VALIMP6	,Alltrim(GetSx3Cache('F2_VALIMP6'	,cTITPais)),GetSx3Cache('F2_VALIMP6','X3_TIPO'),GetSx3Cache('F2_VALIMP6','X3_PICTURE')}
				aSF2[04][07] 				:= {'F2_VALIMP7'	,SF2->F2_VALIMP7	,Alltrim(GetSx3Cache('F2_VALIMP7'	,cTITPais)),GetSx3Cache('F2_VALIMP7','X3_TIPO'),GetSx3Cache('F2_VALIMP7','X3_PICTURE')}
				aSF2[04][08] 				:= {'F2_VALIMP8'	,SF2->F2_VALIMP8	,Alltrim(GetSx3Cache('F2_VALIMP8'	,cTITPais)),GetSx3Cache('F2_VALIMP8','X3_TIPO'),GetSx3Cache('F2_VALIMP8','X3_PICTURE')}
				aSF2[04][09] 				:= {'F2_VALIMP9'	,SF2->F2_VALIMP9	,Alltrim(GetSx3Cache('F2_VALIMP9'	,cTITPais)),GetSx3Cache('F2_VALIMP9','X3_TIPO'),GetSx3Cache('F2_VALIMP9','X3_PICTURE')}
				aSF2[04][10] 				:= {'F2_IMPTOT'		,0					,"Impostos",'N','@E 999,999,999.99'}
				aSF2[04][10][02] 			:= aSF2[02][01][02]
				aSF2[04][10][02] 			+= aSF2[02][02][02]
				aSF2[04][10][02] 			+= aSF2[02][03][02]
				aSF2[04][10][02] 			+= aSF2[02][04][02]
				aSF2[04][10][02] 			+= aSF2[02][05][02]
				aSF2[04][10][02] 			+= aSF2[02][06][02]
				If cPaisLoc == "ARG"
					aSF2[04][10][02] 		:= aSF2[02][07][02]	//SF2->F2_VALIMP7
					aSF2[04][10][02] 		+= aSF2[02][08][02]	//SF2->F2_VALIMP8
					aSF2[04][10][02] 		+= aSF2[02][09][02]	//SF2->F2_VALIMP9
				EndIf
			Else
				aSF2[04][01] 				:= {'F2_VALIMP1'	,0	,Alltrim(GetSx3Cache('F2_VALIMP1'	,cTITPais)),GetSx3Cache('F2_VALIMP1','X3_TIPO'),GetSx3Cache('F2_VALIMP1','X3_PICTURE')}
				aSF2[04][02] 				:= {'F2_VALIMP2'	,0	,Alltrim(GetSx3Cache('F2_VALIMP2'	,cTITPais)),GetSx3Cache('F2_VALIMP2','X3_TIPO'),GetSx3Cache('F2_VALIMP2','X3_PICTURE')}
				aSF2[04][03] 				:= {'F2_VALIMP3'	,0	,Alltrim(GetSx3Cache('F2_VALIMP3'	,cTITPais)),GetSx3Cache('F2_VALIMP3','X3_TIPO'),GetSx3Cache('F2_VALIMP3','X3_PICTURE')}
				aSF2[04][04] 				:= {'F2_VALIMP4'	,0	,Alltrim(GetSx3Cache('F2_VALIMP4'	,cTITPais)),GetSx3Cache('F2_VALIMP4','X3_TIPO'),GetSx3Cache('F2_VALIMP4','X3_PICTURE')}
				aSF2[04][05] 				:= {'F2_VALIMP5'	,0	,Alltrim(GetSx3Cache('F2_VALIMP5'	,cTITPais)),GetSx3Cache('F2_VALIMP5','X3_TIPO'),GetSx3Cache('F2_VALIMP5','X3_PICTURE')}
				aSF2[04][06] 				:= {'F2_VALIMP6'	,0	,Alltrim(GetSx3Cache('F2_VALIMP6'	,cTITPais)),GetSx3Cache('F2_VALIMP6','X3_TIPO'),GetSx3Cache('F2_VALIMP6','X3_PICTURE')}
				aSF2[04][07] 				:= {'F2_VALIMP7'	,0	,Alltrim(GetSx3Cache('F2_VALIMP7'	,cTITPais)),GetSx3Cache('F2_VALIMP7','X3_TIPO'),GetSx3Cache('F2_VALIMP7','X3_PICTURE')}
				aSF2[04][08] 				:= {'F2_VALIMP8'	,0	,Alltrim(GetSx3Cache('F2_VALIMP8'	,cTITPais)),GetSx3Cache('F2_VALIMP8','X3_TIPO'),GetSx3Cache('F2_VALIMP8','X3_PICTURE')}
				aSF2[04][09] 				:= {'F2_VALIMP9'	,0	,Alltrim(GetSx3Cache('F2_VALIMP9'	,cTITPais)),GetSx3Cache('F2_VALIMP9','X3_TIPO'),GetSx3Cache('F2_VALIMP9','X3_PICTURE')}
				aSF2[04][10] 				:= {'F2_IMPTOT'		,0	,"Impostos",'N','@E 999,999,999.99'}
			EndIf
			oProcess:IncRegua2("Generando Imp ...")
			//Valor da Fatura-------------------------------------------------------------------------------------------------------------------//
			aSF2[05] := Array(07)
			aSF2[05][01]					:= {'F2_VALFAT' 	,SF2->F2_VALFAT		,Alltrim(GetSx3Cache('F2_VALFAT' 	,cTITPais)),GetSx3Cache('F2_VALFAT'	,'X3_TIPO'),GetSx3Cache('F2_VALFAT'		,'X3_PICTURE')} 	// Valor Total da Fatura
			aSF2[05][02]					:= {'F2_DESPESA' 	,SF2->F2_DESPESA	,Alltrim(GetSx3Cache('F2_DESPESA'	,cTITPais)),GetSx3Cache('F2_DESPESA','X3_TIPO'),GetSx3Cache('F2_DESPESA'	,'X3_PICTURE')}
			aSF2[05][03]					:= {'F2_SEGURO' 	,SF2->F2_SEGURO		,Alltrim(GetSx3Cache('F2_SEGURO' 	,cTITPais)),GetSx3Cache('F2_SEGURO' ,'X3_TIPO'),GetSx3Cache('F2_SEGURO' 	,'X3_PICTURE')}
			aSF2[05][04]					:= {'F2_FRETE' 		,SF2->F2_FRETE		,Alltrim(GetSx3Cache('F2_FRETE'	 	,cTITPais)),GetSx3Cache('F2_FRETE'	,'X3_TIPO'),GetSx3Cache('F2_FRETE'		,'X3_PICTURE')}
			aSF2[05][05]					:= {'F2_DESCONT' 	,SF2->F2_DESCONT	,Alltrim(GetSx3Cache('F2_DESCONT'	,cTITPais)),GetSx3Cache('F2_DESCONT','X3_TIPO'),GetSx3Cache('F2_DESCONT'	,'X3_PICTURE')}
			aSF2[05][06]					:= {'F2_VALIMP' 	,0					,'Imposto','N','@E 999,999,999.99'} // Valor Total da Fatura + impostos
			aSF2[05][07]					:= {'F2_VALLIQ' 	,0					,'Total'  ,'N','@E 999,999,999.99'} // Valor liquido
			oProcess:IncRegua2("Generando Imp ...")
			aSF2[05][06][02] := SF2->F2_VALIMP1+SF2->F2_VALIMP2+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5+SF2->F2_VALIMP6
			If cPaisLoc == "ARG"
				aSF2[05][06][02] := SF2->F2_VALIMP7+SF2->F2_VALIMP8+SF2->F2_VALIMP9
			EndIf
			aSF2[05][07][02] := SF2->F2_VALMERC+SF2->F2_DESPESA+SF2->F2_SEGURO+SF2->F2_FRETE+aSF2[05][06][02]
			aSF2[05][07][02] -= SF2->F2_DESCONT
			oProcess:IncRegua2("Generando Imp ...")
			//Vendedor-----------------------------------------------------------------------------------------------------------//
			cQuery := "SELECT "
			cQuery += "		SUBSTRING(MAX(SX3.X3_CAMPO),8,2) NTOTAL "
			cQuery += "	FROM SX3010 SX3 "
			cQuery += "	WHERE "
			cQuery += " 	SX3.X3_CAMPO LIKE 'F2_VEND%' "
			aVend := Jursql(cQuery,{'NTOTAL'})
			oProcess:IncRegua2("Generando Vend ...")
			For nY:= 1 to aVend[01][01]
				cCampo := 'SF2->F2_VEND'+Str(nY,1,0)
				If !Empty(&cCampo)
					aadd(aSF2[06],Array(9))
					//aSF2[06][nY] := Array(9)
					If SA3->(dbSeek(xFilial("SA3")+&cCampo))
						aSF2[06][Len(aSF2[06])][01]	:= 	{'F2_VEND'+Str(nY,1,0) ,&cCampo	,Alltrim(GetSx3Cache('F2_VEND1' ,cTITPais)),GetSx3Cache('F2_VEND1'	,'X3_TIPO'),GetSx3Cache('F2_VEND1'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][02]	:=	{'A3_NOME'		,SA3->A3_NOME	,Alltrim(GetSx3Cache('A3_NOME'	,cTITPais)),GetSx3Cache('A3_NOME'	,'X3_TIPO'),GetSx3Cache('A3_NOME'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][03]	:=	{'A3_NREDUZ'	,SA3->A3_NREDUZ	,Alltrim(GetSx3Cache('A3_NREDUZ',cTITPais)),GetSx3Cache('A3_NREDUZ'	,'X3_TIPO'),GetSx3Cache('A3_NREDUZ'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][04]	:=	{'A3_PAIS'		,SA3->A3_PAIS	,Alltrim(GetSx3Cache('A3_PAIS'	,cTITPais)),GetSx3Cache('A3_PAIS'	,'X3_TIPO'),GetSx3Cache('A3_PAIS'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][05]	:=	{'A3_DDI'		,SA3->A3_DDI	,Alltrim(GetSx3Cache('A3_DDI'	,cTITPais)),GetSx3Cache('A3_DDI'	,'X3_TIPO'),GetSx3Cache('A3_DDI'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][06]	:=	{'A3_CEL'		,SA3->A3_CEL	,Alltrim(GetSx3Cache('A3_CEL'	,cTITPais)),GetSx3Cache('A3_CEL'	,'X3_TIPO'),GetSx3Cache('A3_CEL'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][07]	:=	{'A3_DDDTEL'	,SA3->A3_DDDTEL	,Alltrim(GetSx3Cache('A3_DDDTEL',cTITPais)),GetSx3Cache('A3_DDDTEL'	,'X3_TIPO'),GetSx3Cache('A3_DDDTEL'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][08]	:=	{'A3_TEL'		,SA3->A3_TEL	,Alltrim(GetSx3Cache('A3_TEL'	,cTITPais)),GetSx3Cache('A3_TEL'	,'X3_TIPO'),GetSx3Cache('A3_TEL'	,'X3_PICTURE')}
						aSF2[06][Len(aSF2[06])][09]	:=	{'A3_EMAIL'		,SA3->A3_EMAIL	,Alltrim(GetSx3Cache('A3_EMAIL' ,cTITPais)),GetSx3Cache('A3_EMAIL' 	,'X3_TIPO'),GetSx3Cache('A3_EMAIL' 	,'X3_PICTURE')}
						oProcess:IncRegua2("Generando Vend ...")						
					EndIf
				EndIf
			Next nY
			If Len(aSF2[06]) == 0
				aadd(aSF2[06],Array(9))
				aSF2[06][Len(aSF2[06])][01]	:= 	{'F2_VEND1' 	,''	,Alltrim(GetSx3Cache('F2_VEND1' ,cTITPais)),GetSx3Cache('F2_VEND1'	,'X3_TIPO'),GetSx3Cache('F2_VEND1'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][02]	:=	{'A3_NOME'		,''	,Alltrim(GetSx3Cache('A3_NOME'	,cTITPais)),GetSx3Cache('A3_NOME'	,'X3_TIPO'),GetSx3Cache('A3_NOME'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][03]	:=	{'A3_NREDUZ'	,''	,Alltrim(GetSx3Cache('A3_NREDUZ',cTITPais)),GetSx3Cache('A3_NREDUZ'	,'X3_TIPO'),GetSx3Cache('A3_NREDUZ'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][04]	:=	{'A3_PAIS'		,''	,Alltrim(GetSx3Cache('A3_PAIS'	,cTITPais)),GetSx3Cache('A3_PAIS'	,'X3_TIPO'),GetSx3Cache('A3_PAIS'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][05]	:=	{'A3_DDI'		,''	,Alltrim(GetSx3Cache('A3_DDI'	,cTITPais)),GetSx3Cache('A3_DDI'	,'X3_TIPO'),GetSx3Cache('A3_DDI'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][06]	:=	{'A3_CEL'		,''	,Alltrim(GetSx3Cache('A3_CEL'	,cTITPais)),GetSx3Cache('A3_CEL'	,'X3_TIPO'),GetSx3Cache('A3_CEL'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][07]	:=	{'A3_DDDTEL'	,''	,Alltrim(GetSx3Cache('A3_DDDTEL',cTITPais)),GetSx3Cache('A3_DDDTEL'	,'X3_TIPO'),GetSx3Cache('A3_DDDTEL'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][08]	:=	{'A3_TEL'		,''	,Alltrim(GetSx3Cache('A3_TEL'	,cTITPais)),GetSx3Cache('A3_TEL'	,'X3_TIPO'),GetSx3Cache('A3_TEL'	,'X3_PICTURE')}
				aSF2[06][Len(aSF2[06])][09]	:=	{'A3_EMAIL'		,''	,Alltrim(GetSx3Cache('A3_EMAIL' ,cTITPais)),GetSx3Cache('A3_EMAIL' 	,'X3_TIPO'),GetSx3Cache('A3_EMAIL' 	,'X3_PICTURE')}
			EndIf
			oProcess:IncRegua2("Generando Vend ...")
			//Transportadoras----------------------------------------------------------------------------------------------------//
			cQuery := " SELECT "
			cQuery += "		 SA4.R_E_C_N_O_ A4_REC
			cQuery += " FROM " + RetSQLName("SA4") + " SA4 "
			cQuery += " WHERE "
			cQuery += " 		SA4.A4_FILIAL      	= '" + xFilial('SA4')	+ "' "
			cQuery += "			AND SA4.A4_COD		= '" + SF2->F2_TRANSP  	+ "' "
			cQuery += " 		AND SA4.D_E_L_E_T_ 	= ' ' "
			aTrans := JursQL(cQuery,{'A4_REC'})
			oProcess:IncRegua2("Generando Transp ...")
			If Len(aTrans) <> 0
				SA4->(dbgoto(aTrans[01][01]))
				If !Empty(SA4->A4_COD)
					aSF2[07] 			:= Array(7)
					aSF2[07][01]		:= {'A4_NOME' 	,SA4->A4_NOME ,Alltrim(GetSx3Cache('A4_NOME',cTITPais)),GetSx3Cache('A4_NOME','X3_TIPO'),GetSx3Cache('A4_NOME','X3_PICTURE')}	// Nome Transportado
					aSF2[07][02]		:= {'A4_END' 	,SA4->A4_END  ,Alltrim(GetSx3Cache('A4_END ',cTITPais)),GetSx3Cache('A4_END ','X3_TIPO'),GetSx3Cache('A4_END ','X3_PICTURE')}	// Endereco
					aSF2[07][03]		:= {'A4_MUN' 	,SA4->A4_MUN  ,Alltrim(GetSx3Cache('A4_MUN ',cTITPais)),GetSx3Cache('A4_MUN ','X3_TIPO'),GetSx3Cache('A4_MUN ','X3_PICTURE')}	// Municipio
					aSF2[07][04]		:= {'A4_EST' 	,SA4->A4_EST  ,Alltrim(GetSx3Cache('A4_EST ',cTITPais)),GetSx3Cache('A4_EST ','X3_TIPO'),GetSx3Cache('A4_EST ','X3_PICTURE')}	// Estado
					aSF2[07][05]		:= {'A4_VIA' 	,SA4->A4_VIA  ,Alltrim(GetSx3Cache('A4_VIA ',cTITPais)),GetSx3Cache('A4_VIA ','X3_TIPO'),GetSx3Cache('A4_VIA ','X3_PICTURE')}	// Via de Transporte
					aSF2[07][06]		:= {'A4_CGC' 	,SA4->A4_CGC  ,Alltrim(GetSx3Cache('A4_CGC ',cTITPais)),GetSx3Cache('A4_CGC ','X3_TIPO'),GetSx3Cache('A4_CGC ','X3_PICTURE')}	// CGC
					aSF2[07][07]		:= {'A4_TEL' 	,SA4->A4_TEL  ,Alltrim(GetSx3Cache('A4_TEL ',cTITPais)),GetSx3Cache('A4_TEL ','X3_TIPO'),GetSx3Cache('A4_TEL ','X3_PICTURE')}	// Fone
					oProcess:IncRegua2("Generando Transp ...")					
				EndIf
			Else
				aSF2[07] 			:= Array(7)
				aSF2[07][01]		:= {'A4_NOME' 	,'' 	,Alltrim(GetSx3Cache('A4_NOME',cTITPais)),GetSx3Cache('A4_NOME','X3_TIPO'),GetSx3Cache('A4_NOME','X3_PICTURE')}	// Nome Transportado
				aSF2[07][02]		:= {'A4_END' 	,''  	,Alltrim(GetSx3Cache('A4_END ',cTITPais)),GetSx3Cache('A4_END ','X3_TIPO'),GetSx3Cache('A4_END ','X3_PICTURE')}	// Endereco
				aSF2[07][03]		:= {'A4_MUN' 	,''  	,Alltrim(GetSx3Cache('A4_MUN ',cTITPais)),GetSx3Cache('A4_MUN ','X3_TIPO'),GetSx3Cache('A4_MUN ','X3_PICTURE')}	// Municipio
				aSF2[07][04]		:= {'A4_EST' 	,''  	,Alltrim(GetSx3Cache('A4_EST ',cTITPais)),GetSx3Cache('A4_EST ','X3_TIPO'),GetSx3Cache('A4_EST ','X3_PICTURE')}	// Estado
				aSF2[07][05]		:= {'A4_VIA' 	,''  	,Alltrim(GetSx3Cache('A4_VIA ',cTITPais)),GetSx3Cache('A4_VIA ','X3_TIPO'),GetSx3Cache('A4_VIA ','X3_PICTURE')}	// Via de Transporte
				aSF2[07][06]		:= {'A4_CGC' 	,''  	,Alltrim(GetSx3Cache('A4_CGC ',cTITPais)),GetSx3Cache('A4_CGC ','X3_TIPO'),GetSx3Cache('A4_CGC ','X3_PICTURE')}	// CGC
				aSF2[07][07]		:= {'A4_TEL' 	,''  	,Alltrim(GetSx3Cache('A4_TEL ',cTITPais)),GetSx3Cache('A4_TEL ','X3_TIPO'),GetSx3Cache('A4_TEL ','X3_PICTURE')}	// Fone
				//aSF2[07] := {}
			EndIf
			oProcess:IncRegua2("Generando Transp ...")
			//Duplicatas--------------------------------------------------------------------------------------------------------//
			cQuery := " SELECT "
			cQuery += "		SE1.E1_FILIAL	, "
			cQuery += "		SE1.E1_PREFIXO	, "
			cQuery += "		SE1.E1_NUM		, "
			cQuery += "		SE1.E1_PARCELA	, "
			cQuery += "		SE1.E1_CLIENTE	, "
			cQuery += "		SE1.E1_LOJA		, "
			cQuery += "		SE1.E1_TIPO		, "
			cQuery += "		SE1.E1_VENCTO	, "
			cQuery += "		SE1.E1_VALOR 	  "
			cQuery += " FROM " + RetSQLName("SE1") + " SE1 "
			cQuery += " WHERE "
			cQuery += " 		SE1.E1_FILIAL      	= '" + xFilial('SE1')	+ "' "
			cQuery += "			AND SE1.E1_PREFIXO	= '" + SF2->F2_SERIE   	+ "' "
			cQuery += "			AND SE1.E1_NUM   	= '" + SF2->F2_DOC 		+ "' "
			cQuery += "			AND SE1.E1_CLIENTE 	= '" + SF2->F2_CLIENTE 	+ "' "
			cQuery += "			AND SE1.E1_LOJA 	= '" + SF2->F2_LOJA 	+ "' "
			cQuery += " 		AND SE1.D_E_L_E_T_ 	= ' ' "
			cQuery += " ORDER BY SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_TIPO,SE1.E1_VENCTO"
			aDupli := JursQL(cQuery,{'E1_FILIAL','E1_PREFIXO','E1_NUM','E1_PARCELA','E1_CLIENTE','E1_LOJA','E1_TIPO','E1_VENCTO','E1_VALOR'})
			oProcess:IncRegua2("Generando Dupli ...")
			If Len(aDupli) <> 0
				If Len(aSF2[08]) == 0
					For nX:= 1 to Len(aDupli)
						If AScan(aSF2[08],{|x| x[1] <> aDupli[nX][01] .and. x[2] <> aDupli[nX][01] .and. x[3] <> aDupli[nX][03] .and. x[4] <> aDupli[nX][04] }) == 0
							aadd(aSF2[08],Array(09))
							aSF2[08][Len(aSF2[08])][01] := {'E1_FILIAL ',aDupli[nX][01]	,Alltrim(GetSx3Cache('E1_FILIAL '	,cTITPais)),GetSx3Cache('E1_FILIAL ','X3_TIPO'),GetSx3Cache('E1_FILIAL '	,'X3_PICTURE')}	// Filial
							aSF2[08][Len(aSF2[08])][02] := {'E1_PREFIXO',aDupli[nX][02]	,Alltrim(GetSx3Cache('E1_PREFIXO'	,cTITPais)),GetSx3Cache('E1_PREFIXO','X3_TIPO'),GetSx3Cache('E1_PREFIXO'	,'X3_PICTURE')}	// Prefixo
							aSF2[08][Len(aSF2[08])][03] := {'E1_NUM'	,aDupli[nX][03]	,Alltrim(GetSx3Cache('E1_NUM'		,cTITPais)),GetSx3Cache('E1_NUM'	,'X3_TIPO'),GetSx3Cache('E1_NUM'		,'X3_PICTURE')}	// Numero
							aSF2[08][Len(aSF2[08])][04] := {'E1_PARCELA',aDupli[nX][04]	,Alltrim(GetSx3Cache('E1_PARCELA'	,cTITPais)),GetSx3Cache('E1_PARCELA','X3_TIPO'),GetSx3Cache('E1_PARCELA'	,'X3_PICTURE')}	// Parcela
							aSF2[08][Len(aSF2[08])][05] := {'E1_CLIENTE',aDupli[nX][05]	,Alltrim(GetSx3Cache('E1_CLIENTE'	,cTITPais)),GetSx3Cache('E1_CLIENTE','X3_TIPO'),GetSx3Cache('E1_CLIENTE'	,'X3_PICTURE')}	// Cliente
							aSF2[08][Len(aSF2[08])][06] := {'E1_LOJA'	,aDupli[nX][06]	,Alltrim(GetSx3Cache('E1_LOJA'		,cTITPais)),GetSx3Cache('E1_LOJA'	,'X3_TIPO'),GetSx3Cache('E1_LOJA'		,'X3_PICTURE')}	// Loja
							aSF2[08][Len(aSF2[08])][07] := {'E1_TIPO'	,aDupli[nX][07]	,Alltrim(GetSx3Cache('E1_TIPO'		,cTITPais)),GetSx3Cache('E1_TIPO'	,'X3_TIPO'),GetSx3Cache('E1_TIPO'		,'X3_PICTURE')}	// Tipo
							aSF2[08][Len(aSF2[08])][08] := {'E1_VENCTO'	,aDupli[nX][08]	,Alltrim(GetSx3Cache('E1_VENCTO'	,cTITPais)),GetSx3Cache('E1_VENCTO'	,'X3_TIPO'),GetSx3Cache('E1_VENCTO'		,'X3_PICTURE')}	// Vencimento
							aSF2[08][Len(aSF2[08])][09] := {'E1_VALOR'	,aDupli[nX][09]	,Alltrim(GetSx3Cache('E1_VALOR'		,cTITPais)),GetSx3Cache('E1_VALOR'	,'X3_TIPO'),GetSx3Cache('E1_VALOR'		,'X3_PICTURE')}	// Valor
							oProcess:IncRegua2("Generando Dupli ...")							
						EndIf
					Next nX
				EndIf
				oProcess:IncRegua2("Generando Dupli ...")
			Else
					aadd(aSF2[08],Array(09))
					aSF2[08][Len(aSF2[08])][01] := {'E1_FILIAL ',''					,Alltrim(GetSx3Cache('E1_FILIAL '	,cTITPais)),GetSx3Cache('E1_FILIAL ','X3_TIPO'),GetSx3Cache('E1_FILIAL '	,'X3_PICTURE')}	// Filial
					aSF2[08][Len(aSF2[08])][02] := {'E1_PREFIXO',''					,Alltrim(GetSx3Cache('E1_PREFIXO'	,cTITPais)),GetSx3Cache('E1_PREFIXO','X3_TIPO'),GetSx3Cache('E1_PREFIXO'	,'X3_PICTURE')}	// Prefixo
					aSF2[08][Len(aSF2[08])][03] := {'E1_NUM'	,''					,Alltrim(GetSx3Cache('E1_NUM'		,cTITPais)),GetSx3Cache('E1_NUM'	,'X3_TIPO'),GetSx3Cache('E1_NUM'		,'X3_PICTURE')}	// Numero
					aSF2[08][Len(aSF2[08])][04] := {'E1_PARCELA',''					,Alltrim(GetSx3Cache('E1_PARCELA'	,cTITPais)),GetSx3Cache('E1_PARCELA','X3_TIPO'),GetSx3Cache('E1_PARCELA'	,'X3_PICTURE')}	// Parcela
					aSF2[08][Len(aSF2[08])][07] := {'E1_TIPO'	,''					,Alltrim(GetSx3Cache('E1_TIPO'		,cTITPais)),GetSx3Cache('E1_TIPO'	,'X3_TIPO'),GetSx3Cache('E1_TIPO'		,'X3_PICTURE')}	// Tipo
					aSF2[08][Len(aSF2[08])][08] := {'E1_VENCTO'	,Date()				,Alltrim(GetSx3Cache('E1_VENCTO'	,cTITPais)),GetSx3Cache('E1_VENCTO'	,'X3_TIPO'),GetSx3Cache('E1_VENCTO'		,'X3_PICTURE')}	// Vencimento
					aSF2[08][Len(aSF2[08])][09] := {'E1_VALOR'	,0					,Alltrim(GetSx3Cache('E1_VALOR'		,cTITPais)),GetSx3Cache('E1_VALOR'	,'X3_TIPO'),GetSx3Cache('E1_VALOR'		,'X3_PICTURE')}	// Valor
					//aSF2[08] := {}
			EndIf
			oProcess:IncRegua2("Generando Cabec ...")
		EndIf
	EndIf
	FwFreeArray(aDupli )
	FwFreeArray(aSF2Rec)
	FwFreeArray(aCliFor)
	FwFreeArray(aTrans )
	FwFreeArray(aPed   )
	FwFreeArray(aVend  )
Return()

/*/{Protheus.doc} faSD2
Dados itens Remito
@type function
@version 1.0
@author Luiz Fael
@since 10/01/2023
@param oProcess, object, Objdeto Regua
@param oPrn, object, Objeto Impressao
@param aSF2, array, Dados Cabec
@param aSD2, array, Dados Itens
@return variant, Retorno
/*/
Static Function faSD2(oProcess,oPrn,aSF2,aSD2)
	Local nX 		:=  0
	Local nPos 		:= 	0
	Local nY		:=  0
	Local cCpoBase 	:= 	""
	Local cCpoImp 	:= 	""
	Local aImp 		:=  {}
	Local aPed 		:=  {}
	Local aSC6 		:=	{}
	Local aImpRet 	:=	{}
	Local aDados 	:= aSD2
	aSD2 := {}
	If cPaisLoc == "ARG" .OR. cPaisLoc == "BOL"
		cTITPais 	:=	'X3_TITSPA'
	Elseif cPaisLoc == "ENG"
		cTITPais 	:=	'X3_TITENG'
	Else
		cTITPais 	:=	'X3_TITULO'
	EndIf
	oProcess:SetRegua2(Len(aDados))
	For nX:= 1 to Len(aDados)
		SD2->(dbGoto(aDados[nX][1]))
		SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
		SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		AADD(aSD2,Array(27))
		//--------------------------------------------------------------------------------------------------------------------------------------------------//
		aSD2[Len(aSD2)][01]	:= {'D2_RECNO'  			,aDados[nX][1]					,'D2_RECNO'	,"N",''}
		//Produto---------------------------------------------------------------------------------------------------------------------------------------//
		aSD2[Len(aSD2)][02]	:= {'D2_ITEM'	   			,SD2->D2_ITEM					,Alltrim(GetSx3Cache('D2_ITEM'	 ,cTITPais)),GetSx3Cache('D2_ITEM'	,'X3_TIPO'),GetSx3Cache('D2_ITEM'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][03]	:= {'D2_PEDIDO'		    	,SD2->D2_PEDIDO					,Alltrim(GetSx3Cache('D2_PEDIDO' ,cTITPais)),GetSx3Cache('D2_PEDIDO','X3_TIPO'),GetSx3Cache('D2_PEDIDO'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][04]	:= {'D2_ITEMPV'	 		  	,SD2->D2_ITEMPV					,Alltrim(GetSx3Cache('D2_ITEMPV' ,cTITPais)),GetSx3Cache('D2_ITEMPV','X3_TIPO'),GetSx3Cache('D2_ITEMPV'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][05]	:= {'D2_COD'  				,SD2->D2_COD					,Alltrim(GetSx3Cache('D2_COD'	 ,cTITPais)),GetSx3Cache('D2_COD'  	,'X3_TIPO'),GetSx3Cache('D2_COD'  	,'X3_PICTURE')}
		aSD2[Len(aSD2)][06] := {"B1_UM"					,SB1->B1_UM						,Alltrim(GetSx3Cache('B1_UM'	 ,cTITPais)),GetSx3Cache("B1_UM"	,'X3_TIPO'),GetSx3Cache("B1_UM"		,'X3_PICTURE')}
		aSD2[Len(aSD2)][07]	:= {'D2_PRCVEN'	   			,SD2->D2_PRCVEN					,Alltrim(GetSx3Cache('D2_PRCVEN' ,cTITPais)),GetSx3Cache('D2_PRCVEN','X3_TIPO'),GetSx3Cache('D2_PRCVEN'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][08]	:= {'D2_QUANT'  			,SD2->D2_QUANT					,Alltrim(GetSx3Cache('D2_QUANT'	 ,cTITPais)),GetSx3Cache('D2_QUANT' ,'X3_TIPO'),GetSx3Cache('D2_QUANT' 	,'X3_PICTURE')}
		aSD2[Len(aSD2)][09]	:= {'D2_PRUNIT'  			,SD2->D2_PRUNIT					,Alltrim(GetSx3Cache('D2_PRUNIT' ,cTITPais)),GetSx3Cache('D2_PRUNIT','X3_TIPO'),GetSx3Cache('D2_PRUNIT'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][10]	:= {'D2_DESC'	   			,SD2->D2_DESC					,Alltrim(GetSx3Cache('D2_DESC'	 ,cTITPais)),GetSx3Cache('D2_DESC'	,'X3_TIPO'),GetSx3Cache('D2_DESC'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][11]	:= {'D2_TOTAL'	 			,SD2->D2_TOTAL					,Alltrim(GetSx3Cache('D2_TOTAL'	 ,cTITPais)),GetSx3Cache('D2_TOTAL'	,'X3_TIPO'),GetSx3Cache('D2_TOTAL'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][12]	:= {'D2_TES'	   			,SD2->D2_TES					,Alltrim(GetSx3Cache('D2_TES'	 ,cTITPais)),GetSx3Cache('D2_TES'	,'X3_TIPO'),GetSx3Cache('D2_TES'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][13]	:= {'F4_TEXTO '	   			,SF4->F4_TEXTO					,Alltrim(GetSx3Cache('F4_TEXTO'	 ,cTITPais)),GetSx3Cache('F4_TEXTO ','X3_TIPO'),GetSx3Cache('F4_TEXTO '	,'X3_PICTURE')}
		aSD2[Len(aSD2)][14]	:= {'D2_CF'		   			,SD2->D2_CF						,Alltrim(GetSx3Cache('D2_CF'	 ,cTITPais)),GetSx3Cache('D2_CF'	,'X3_TIPO'),GetSx3Cache('D2_CF'		,'X3_PICTURE')}
		aSD2[Len(aSD2)][15] := {"B1_PESOLIQ"			,SB1->B1_PESO * SD2->D2_QUANT	,'Peso.Liquido',"N",GetSx3Cache('D2_QUANT','X3_PICTURE')}
		aSD2[Len(aSD2)][16] := {"B1_DESC"	 			,SB1->B1_DESC					,Alltrim(GetSx3Cache('B1_DESC'	,cTITPais)),GetSx3Cache('B1_DESC'	,'X3_TIPO'),GetSx3Cache('B1_DESC'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][17] := {"B1_ORIGEM" 			,SB1->B1_ORIGEM					,Alltrim(GetSx3Cache('B1_ORIGEM',cTITPais)),GetSx3Cache('B1_ORIGEM'	,'X3_TIPO'),GetSx3Cache('B1_ORIGEM'	,'X3_PICTURE')}
		aSD2[Len(aSD2)][18] := {"B1_PESO"				,SB1->B1_PESO					,Alltrim(GetSx3Cache('B1_PESO'	,cTITPais)),GetSx3Cache('B1_PESO'	,'X3_TIPO'),GetSx3Cache('B1_PESO'	,'X3_PICTURE')}
		//------------------------------------------------------------------------------------------------------------------------------------------------//
		aSD2[Len(aSD2)][19]	:= {'D2_NUMLOTE'   			,SD2->D2_NUMLOTE				,Alltrim(GetSx3Cache('D2_NUMLOTE',cTITPais)),GetSx3Cache('D2_NUMLOTE','X3_TIPO'),GetSx3Cache('D2_NUMLOTE','X3_PICTURE')}
		aSD2[Len(aSD2)][20]	:= {'D2_NFORI'				,SD2->D2_NFORI					,Alltrim(GetSx3Cache('D2_NFORI'	 ,cTITPais)),GetSx3Cache('D2_NFORI'	 ,'X3_TIPO'),GetSx3Cache('D2_NFORI'  ,'X3_PICTURE')}
		aSD2[Len(aSD2)][21]	:= {'D2_SERIORI'  			,SD2->D2_SERIORI				,Alltrim(GetSx3Cache('D2_SERIORI',cTITPais)),GetSx3Cache('D2_SERIORI','X3_TIPO'),GetSx3Cache('D2_SERIORI','X3_PICTURE')}
		//Pedido de Vendas-------------------------------------------------------------------------------------------------------------------//
		cQuery := "SELECT "
		cQuery += "SC6.R_E_C_N_O_ AS 'C6_REC'  "
		cQuery += " FROM " + RetSQLName("SC6") + " SC6 "
		cQuery += " WHERE "
		cQuery += " SC6.C6_FILIAL  = '" + xFilial('SC6') +"' "
		cQuery += " AND SC6.C6_NUM  = '" +SD2->D2_PEDIDO+ "' "
		cQuery += " AND SC6.C6_ITEM = '" +SD2->D2_ITEMPV+ "' "
		cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
		aSC6 := JursQL(cQuery,{'C6_REC'})
		SC6->(dbGoto(aSC6[01][01]))
		aSD2[Len(aSD2)][22]	:= {'C6_NUM'  				,SC6->C6_NUM				,Alltrim(GetSx3Cache('C6_NUM'		,cTITPais)),GetSx3Cache('C6_NUM'	,'X3_TIPO'),GetSx3Cache('C6_NUM'		,'X3_PICTURE')}
		aSD2[Len(aSD2)][23]	:= {'C6_ITEM'  				,SC6->C6_ITEM				,Alltrim(GetSx3Cache('C6_ITEM'		,cTITPais)),GetSx3Cache('C6_ITEM'	,'X3_TIPO'),GetSx3Cache('C6_ITEM'		,'X3_PICTURE')}
		aSD2[Len(aSD2)][24]	:= {'C6_PEDCLI' 			,SC6->C6_PEDCLI				,Alltrim(GetSx3Cache('C6_PEDCLI'	,cTITPais)),GetSx3Cache('C6_PEDCLI'	,'X3_TIPO'),GetSx3Cache('C6_PEDCLI'		,'X3_PICTURE')}
		aSD2[Len(aSD2)][25]	:= {'C6_DESCRI' 			,SC6->C6_DESCRI				,Alltrim(GetSx3Cache('C6_DESCRI'	,cTITPais)),GetSx3Cache('C6_DESCRI'	,'X3_TIPO'),GetSx3Cache('C6_DESCRI'		,'X3_PICTURE')}
		aSD2[Len(aSD2)][26]	:= {'C6_VALDESC' 			,SC6->C6_VALDESC			,Alltrim(GetSx3Cache('C6_VALDESC'	,cTITPais)),GetSx3Cache('C6_VALDESC','X3_TIPO'),GetSx3Cache('C6_VALDESC'	,'X3_PICTURE')}
		//Carrega o Array com todos os impostos contidos no Item---------------------------------------------------------------//
		cQuery := "SELECT "
		cQuery += "SFC.FC_IMPOSTO, "
		cQuery += "SFC.FC_TES, "
		cQuery += "SFB.FB_CPOLVRO, "
		cQuery += "SFB.FB_DESCR, "
		cQuery += "SFB.FB_ALIQ, "
		cQuery += "SFB.R_E_C_N_O_ AS 'FB_REC' "
		cQuery += " FROM " + RetSQLName("SFC") + " SFC "
		cQuery += "   INNER JOIN " + RetSQLName("SFB") + " SFB "
		cQuery += "   ON( 	SFB.FB_FILIAL  = '" + xFilial('SFB') + "' "
		cQuery += "   	AND SFB.FB_CODIGO  =  SFC.FC_IMPOSTO  "
		cQuery += " 	AND SFB.D_E_L_E_T_ = ' ' ) "
		cQuery += " WHERE "
		cQuery += " SFC.FC_FILIAL  = '" + xFilial('SFC') +"' "
		cQuery += " AND SFC.FC_TES = '" + SD2->D2_TES + "' "
		cQuery += " AND SFC.D_E_L_E_T_ = ' ' "
		aImpRet := JursQL(cQuery,{'FC_IMPOSTO','FC_TES','FB_CPOLVRO','FB_DESCR','FB_ALIQ','FB_REC'})
		If Len(aImpRet) <> 0
			For nY:= 1 to Len(aImpRet)
				SFB->(dbGoto(aImpRet[nY][06]))
				cCpoBase 	:= "D2_BASIMP"+aImpRet[nY][03]//SFB->FB_CPOLVRO
				cCpoImp  	:= "D2_VALIMP"+aImpRet[nY][03]//SFB->FB_CPOLVRO
				nPos		:=	Ascan(aImp,{|x| x[2] == aImpRet[nY][02] })//SFC->FC_IMPOSTO
				If nPos == 0
					aadd(aImp,Array(05))
					aImp[Len(aImp)][01] := aImpRet[nY][01]	//SFC->FC_IMPOSTO
					aImp[Len(aImp)][02] := aImpRet[nY][04]	//SFB->FB_DESCR
					aImp[Len(aImp)][03] := aImpRet[nY][05] //SFB->FB_ALIQ
					aImp[Len(aImp)][04] := SD2->&(cCpoBase)
					aImp[Len(aImp)][05] := SD2->&(cCpoImp)
				Else
					aImp[Len(aImp)][04]	+= SD2->&(cCpoBase) // Base de Calculo
					aImp[Len(aImp)][05]	+= SD2->&(cCpoImp)  // Valor do Imposto
				Endif
			Next nY
			aSD2[Len(aSD2)][27] := aImp
		Else
			aSD2[Len(aSD2)][27]	:= {}
		EndIf
		oProcess:IncRegua2("Generando Prod ...")
	Next nX
	FwFreeArray(aImp	)
	FwFreeArray(aPed	)
	FwFreeArray(aSC6	)
	FwFreeArray(aImpRet	)
	FwFreeArray(aDados  )
Return()


/*/{Protheus.doc} getEmp
Pega Empresa
@type function
@version 1.0
@author Luiz Fael
@since 10/01/2023
@return variant, Matrix empresa
/*/
User Function getEmp()
	Local aDados := {}
	Local aEmp 	 := {}
	Local cQuery := ''
	cQuery := "SELECT "
	cquery += "EMP.M0_CODIGO		,"
	cquery += "EMP.M0_CODFIL		,"
	cquery += "EMP.M0_FILIAL		,"
	cquery += "EMP.M0_NOME			,"
	cquery += "EMP.M0_NOMECOM		,"
	cquery += "EMP.M0_FULNAME		,"
	cquery += "EMP.M0_TEL			,"
	cquery += "EMP.M0_FAX			,"
	cquery += "EMP.M0_EQUIP			,"
	cquery += "EMP.M0_TPINSC		,"
	cquery += "EMP.M0_CGC			,"
	cquery += "EMP.M0_CEI			,"
	cquery += "EMP.M0_INSC			,"
	cquery += "EMP.M0_INSCM			,"
	cquery += "EMP.M0_ENDENT		,"
	cquery += "EMP.M0_COMPENT		,"
	cquery += "EMP.M0_BAIRENT		,"
	cquery += "EMP.M0_CIDENT		,"
	cquery += "EMP.M0_ESTENT		,"
	cquery += "EMP.M0_CEPENT		,"
	cquery += "EMP.M0_CODMUN		,"
	cquery += "EMP.M0_ENDCOB		,"
	cquery += "EMP.M0_COMPCOB		,"
	cquery += "EMP.M0_BAIRCOB		,"
	cquery += "EMP.M0_CIDCOB		,"
	cquery += "EMP.M0_ESTCOB		,"
	cquery += "EMP.M0_CEPCOB		,"
	cquery += "EMP.M0_PRODRUR		,"
	cquery += "EMP.M0_FPAS			,"
	cquery += "EMP.M0_NATJUR		,"
	cquery += "EMP.M0_DTBASE		,"
	cquery += "EMP.M0_CNAE			,"
	cquery += "EMP.M0_ACTRAB		,"
	cquery += "EMP.M0_NUMPROP		,"
	cquery += "EMP.M0_MODEND		,"
	cquery += "EMP.M0_MODINSC		,"
	cquery += "EMP.M0_CAUSA			,"
	cquery += "EMP.M0_INSCANT		,"
	cquery += "EMP.M0_TPESTAB		,"
	cquery += "EMP.M0_TEL_IMP		,"
	cquery += "EMP.M0_FAX_IMP		,"
	cquery += "EMP.M0_IMP_CON		,"
	cquery += "EMP.M0_TEL_PO		,"
	cquery += "EMP.M0_FAX_PO		,"
	cquery += "EMP.M0_CODZOSE		,"
	cquery += "EMP.M0_DESZOSE		,"
	cquery += "EMP.M0_COD_ATV		,"
	cquery += "EMP.M0_INS_SUF		,"
	cquery += "EMP.M0_NIRE			,"
	cquery += "EMP.M0_DTRE			,"
	cquery += "EMP.M0_DSCCNA		,"
	cquery += "EMP.M0_ASSPAT1		,"
	cquery += "EMP.M0_ASSPAT2		,"
	cquery += "EMP.M0_ASSPAT3		,"
	cquery += "EMP.M0_RNTRC			,"
	cquery += "EMP.M0_DTRNTRC		"
	cQuery += " FROM SYS_COMPANY EMP "
	cQuery += " WHERE "
	cQuery += " EMP.M0_CODIGO  = '"+CEMPANT+"' "
	cQuery += " AND EMP.M0_CODFIL = '" + cFilAnt + "' "
	aDados := JursQL(cQuery,{	'M0_CODIGO','M0_CODFIL','M0_FILIAL','M0_NOME','M0_NOMECOM','M0_FULNAME','M0_TEL','M0_FAX','M0_EQUIP',;
		'M0_TPINSC','M0_CGC','M0_CEI','M0_INSC','M0_INSCM','M0_ENDENT','M0_COMPENT','M0_BAIRENT','M0_CIDENT','M0_ESTENT','M0_CEPENT',;
		'M0_CODMUN','M0_ENDCOB','M0_COMPCOB','M0_BAIRCOB','M0_CIDCOB','M0_ESTCOB','M0_CEPCOB','M0_PRODRUR','M0_FPAS','M0_NATJUR',;
		'M0_DTBASE','M0_CNAE','M0_ACTRAB','M0_NUMPROP','M0_MODEND','M0_MODINSC','M0_CAUSA','M0_INSCANT','M0_TPESTAB','M0_TEL_IMP',;
		'M0_FAX_IMP','M0_IMP_CON','M0_TEL_PO','M0_FAX_PO','M0_CODZOSE','M0_DESZOSE','M0_COD_ATV','M0_INS_SUF','M0_NIRE','M0_DTRE',;
		'M0_DSCCNA','M0_ASSPAT1','M0_ASSPAT2','M0_ASSPAT3','M0_RNTRC','M0_DTRNTRC'})
	aadd(aEmp,{'M0_CODIGO'	,aDados[1][01],''})
	aadd(aEmp,{'M0_CODFIL'	,aDados[1][02],''})
	aadd(aEmp,{'M0_FILIAL'	,aDados[1][03],''})
	aadd(aEmp,{'M0_NOME'	,aDados[1][04],''})
	aadd(aEmp,{'M0_NOMECOM'	,aDados[1][05],''})
	aadd(aEmp,{'M0_FULNAME'	,aDados[1][06],''})
	aadd(aEmp,{'M0_TEL'		,aDados[1][07],''})
	aadd(aEmp,{'M0_FAX'		,aDados[1][08],''})
	aadd(aEmp,{'M0_EQUIP'	,aDados[1][09],''})
	aadd(aEmp,{'M0_TPINSC'	,aDados[1][10],''})
	aadd(aEmp,{'M0_CGC'		,aDados[1][11],''})
	aadd(aEmp,{'M0_CEI'		,aDados[1][12],''})
	aadd(aEmp,{'M0_INSC'	,aDados[1][13],''})
	aadd(aEmp,{'M0_INSCM'	,aDados[1][14],''})
	aadd(aEmp,{'M0_ENDENT'	,aDados[1][15],''})
	aadd(aEmp,{'M0_COMPENT'	,aDados[1][16],''})
	aadd(aEmp,{'M0_BAIRENT'	,aDados[1][17],''})
	aadd(aEmp,{'M0_CIDENT'	,aDados[1][18],''})
	aadd(aEmp,{'M0_ESTENT'	,aDados[1][19],''})
	aadd(aEmp,{'M0_CEPENT'	,aDados[1][20],''})
	aadd(aEmp,{'M0_CODMUN'	,aDados[1][21],''})
	aadd(aEmp,{'M0_ENDCOB'	,aDados[1][22],''})
	aadd(aEmp,{'M0_COMPCOB'	,aDados[1][23],''})
	aadd(aEmp,{'M0_BAIRCOB'	,aDados[1][24],''})
	aadd(aEmp,{'M0_CIDCOB'	,aDados[1][25],''})
	aadd(aEmp,{'M0_ESTCOB'	,aDados[1][26],''})
	aadd(aEmp,{'M0_CEPCOB'	,aDados[1][27],''})
	aadd(aEmp,{'M0_PRODRUR'	,aDados[1][28],''})
	aadd(aEmp,{'M0_FPAS'	,aDados[1][29],''})
	aadd(aEmp,{'M0_NATJUR'	,aDados[1][30],''})
	aadd(aEmp,{'M0_DTBASE'	,aDados[1][31],''})
	aadd(aEmp,{'M0_CNAE'	,aDados[1][32],''})
	aadd(aEmp,{'M0_ACTRAB'	,aDados[1][33],''})
	aadd(aEmp,{'M0_NUMPROP'	,aDados[1][34],''})
	aadd(aEmp,{'M0_MODEND'	,aDados[1][35],''})
	aadd(aEmp,{'M0_MODINSC'	,aDados[1][36],''})
	aadd(aEmp,{'M0_CAUSA'	,aDados[1][37],''})
	aadd(aEmp,{'M0_INSCANT'	,aDados[1][38],''})
	aadd(aEmp,{'M0_TPESTAB'	,aDados[1][39],''})
	aadd(aEmp,{'M0_TEL_IMP'	,aDados[1][40],''})
	aadd(aEmp,{'M0_FAX_IMP'	,aDados[1][41],''})
	aadd(aEmp,{'M0_IMP_CON'	,aDados[1][42],''})
	aadd(aEmp,{'M0_TEL_PO'	,aDados[1][43],''})
	aadd(aEmp,{'M0_FAX_PO'	,aDados[1][44],''})
	aadd(aEmp,{'M0_CODZOSE'	,aDados[1][45],''})
	aadd(aEmp,{'M0_DESZOSE'	,aDados[1][46],''})
	aadd(aEmp,{'M0_COD_ATV'	,aDados[1][47],''})
	aadd(aEmp,{'M0_INS_SUF'	,aDados[1][48],''})
	aadd(aEmp,{'M0_NIRE'	,aDados[1][49],''})
	aadd(aEmp,{'M0_DTRE'	,aDados[1][50],''})
	aadd(aEmp,{'M0_DSCCNA'	,aDados[1][51],''})
	aadd(aEmp,{'M0_ASSPAT1'	,aDados[1][52],''})
	aadd(aEmp,{'M0_ASSPAT2'	,aDados[1][53],''})
	aadd(aEmp,{'M0_ASSPAT3'	,aDados[1][54],''})
	aadd(aEmp,{'M0_RNTRC'	,aDados[1][55],''})
	aadd(aEmp,{'M0_DTRNTRC'	,aDados[1][56],''})
Return(aEmp)

/*/{Protheus.doc} fSayDado
Imprime dados
@type function
@version 1.0
@author Luiz Fael
@since 10/01/2023
@param oPrn, object, objeto Impressao
@param nLinha, numeric, Linha
@param nCol, numeric, coluna
@param nQtLin, numeric, soma linha
@param oFonte, object, fontes carac
@param cTit, character, titulos
@param cCampo, character, campo
@param aDados, array, dados
@param nOpc, numeric, opcçãp
@return variant, Retorno
/*/
User Function fSayDado(oPrn,nLinha,nCol,nQtLin,oFonte,cTit,cCampo,aDados,nOpc)
	Local  nPos 	:= 0
	Local  cRet		:= ''
	default nLinha	:= 0
	default nCol	:= 0
	default nQtLin	:= 0
	default cTit	:= ''
	default cAlias	:= ''
	default cCampo	:= ''
	default aDados	:= {}
	default nOpc	:= 0
	If nOpc == 9 // imprime texto
		nLinha += nQtLin
		oPrn:Say(nLinha,nCol,cTit, oFonte)
	Else
		nPos := Ascan(aDados,{|x,y| x[1]==cCampo})
		If nPos <> 0
			If nOpc == 1 //Imprime o titulo da matrix
				nLinha += nQtLin
				oPrn:Say(nLinha,nCol,aDados[nPos][03]	, oFonte)
			ElseIf nOpc == 2 //Imprime o conteudo da matrix
				nLinha += nQtLin
				If aDados[nPos][04] == 'C'
					aDados[nPos][02] := Alltrim(aDados[nPos][02])
				ElseIf aDados[nPos][04] == 'N'
					aDados[nPos][02] := TRANSFORM(aDados[nPos][02],aDados[nPos][05])
				ElseIf aDados[nPos][04] == 'D'
					aDados[nPos][02] := DTOC(aDados[nPos][02])
				ElseIf aDados[nPos][04] == 'L'
					If aDados[nPos][02]
						aDados[nPos][02] := 'V'
					Else
						aDados[nPos][02] := 'F'
					Endif
				EndIf
				oPrn:Say(nLinha,nCol,cTit+aDados[nPos][02]	, oFonte)
			ElseIf nOpc == 3
				//retorna somente o conteudo da matrix
				cRet := aDados[nPos][02]
			EndIf
		EndIf
	EndIf
Return(cRet)
