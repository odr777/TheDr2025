#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DPICK
title "REPORTE NOTA DE ENTREGA"
description "Cabecera"

columns

//CABECERA
define column PEDIDO       type 	character size 30  label "PEDIDO"
define column T_CLIENTE    type 	character size 30  label "T_CLIENTE"
define column F_IMPRESI    type 	character size 20  label "F_IMPRESI"
define column H_IMPRESI    type 	character size 20  label "H_IMPRESI"
define column SUCURSAL     type 	character size 30  label "SUCURSAL"
define column T_CAMBIO     type 	numeric size 20  decimals 2   label "T_CAMBIO"
define column CLIENTE      type 	character size 50  label "CLIENTE"
define column DIRECCION    type 	character size 30  label "DIRECCION"
define column F_EMISION    type 	character size 20  label "F_EMISION"
define column T_ENTREGA    type 	character size 30  label "T_ENTREGA"
define column F_ENTREGA    type 	character size 30  label "F_ENTREGA"
define column TELEFONO     type 	character size 30  label "TELEFONO"
define column FACTURA      type 	character size 30  label "FACTURA"
define column VENDEDOR     type 	character size 50  label "VENDEDOR"
define column T_VENDEDOR   type 	character size 30  label "T_VENDEDOR"
define column REG_POR      type 	character size 30  label "REG_POR"
define column T_REMITO     type 	character size 30  label "T_REMITO"
define column IMPRES_POR   type 	character size 30  label "IMPRES_POR"
define column COND_PAGO    type 	character size 30  label "COND_PAGO"
define column OBSERVASIO   type 	character size 50  label "OBSERVASIO"
define column F_VENCTO     type 	character size 20  label "F_VENCTO"
define column BODEGA       type 	character size 30  label "BODEGA"

//detalle
define column CORRELATI     type 	numeric size 3     label "CORRELATI"
define column CODIGO      	type 	character size 10  label "CODIGO"
define column U_MEDIDA      type 	character size 4   label "U_MEDIDA"
define column DESCRIPCIO    type 	character size 40  label "DESCRIPCIO"
define column FABRICA       type 	character size 4   label "FABRICA"
define column CANTIDAD      type 	character size 5    label "CANTIDAD"
define column P_UNITARIO    type 	numeric size 20  decimals 2 label "P_UNITARIO"
define column TOTAL         type 	numeric size 20  decimals 2 label "TOTAL"
define column LOTE          type 	character size 30  label "LOTE"
define column VALIDEZ       type 	character size 20  label "VALIDEZ"
define column UBUCACION     type 	character size 15  label "UBUCACION"

define column SUBTOTAL      type 	character size 30  label "SUBTOTAL"
define column DESCUENTOS    type 	character size 30  label "DESCUENTOS"
define column MON_TOTAL     type 	character size 30  label "MON_TOTAL"
define column RECARGO       type 	character size 30  label "RECARGO"
define column V_LITERAL     type 	character size 60  label "V_LITERAL"

define column NREDUZ		type 	character size tamSX3("A1_NREDUZ")[1]  label "NREDUZ"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias:= ""
local cAliasNew	:= getNextAlias()
Local cQuery	:= ""
Local cPerg		:= "MTR777"
Local cNreduz	:= ""
Private nTipo	:= 15
private valorBonificacion := 0.0
private nDescPor := 0.0
private cBonusTes  := SuperGetMv("MV_BONUSTS")
private nValfat
private nDescont
private nBasimpl
private nUtaten
Private cNum     := 0

//AjustaSX1(cPerg)
//pergunte(cPerg,.F.)

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cQuery := " SELECT SD2.R_E_C_N_O_, D2_PEDIDO, D2_QUANT, D2_FILIAL, "
cQuery += " D2_COD, D2_LOCAL, D2_NUMSEQ, D2_DOC,D2_SERIE,D2_ITEM, "
cQuery += " D2_LOTECTL, D2_POTENCI,D2_PRCVEN,D2_PRUNIT,D2_TOTAL,D2_NUMLOTE, D2_DTVALID, D2_LOCALIZ	, D2_UDESC, "
cQuery += " D2_DESCON, ROUND(F2_DESCONT, 2) F2_DESCONT, F2_VALFAT, F2_BASIMP1 , F2_UCTATEN , D2_TES, B1_UFABRIC, C6_BLQ, DB_LOCALIZ"
cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
cQuery += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_LOJA = F2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = D2_COD
cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6 ON C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN " + RetSqlName("SDB") + " SDB ON SDB.DB_FILIAL = SD2.D2_FILIAL AND SDB.DB_PRODUTO = SD2.D2_COD AND SDB.DB_LOCAL = SD2.D2_LOCAL "
cQuery += " AND SDB.DB_LOTECTL = SD2.D2_LOTECTL AND SDB.DB_SERIE = SD2.D2_SERIE AND SDB.DB_ESTORNO <> 'S' "
cQuery += " AND SDB.DB_DOC = "
cQuery += " CASE WHEN SD2.D2_REMITO <> '' "
cQuery += " THEN SD2.D2_REMITO "
cQuery += " ELSE SD2.D2_DOC "
cQuery += " END "
cQuery += " AND SDB.D_E_L_E_T_ <> '*' "
cQuery += " WHERE SD2.D2_FILIAL  = '" + xFilial("SC6") + "' "
cQuery += " AND SD2.D2_PEDIDO = '"+SC5->C5_NUM+"' "
cQuery += " AND SD2.D2_ESPECIE = 'NF' "
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY B1_UFABRIC, D2_UDESC "

cQuery:= ChangeQuery(cQuery)
//Aviso("",cQuery,{'ok'},,,,,.t.)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasNew, .F., .T.)
dbSelectArea(cAliasNew)
dbGoTop()

While (cAliasNew)->(!EOF())

	SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->D2_COD))

	nfecha_impresion :=  cValToChar(dtoc(DATE())) +" "+ cValToChar(Time())
	nhora_impresion :=  cValToChar(Time())
	nPedido := AllTrim(SC5->C5_NUM) + " " +  IIf(SC5->C5_MOEDA == 1, "(en Bolivianos)", "(en Dolar)")
	nTipo_Cliente := alltrim(IIF(SC5->C5_TIPOCLI $ '1|2|3','GRAN CONT.',IIF(SC5->C5_TIPOCLI=='6','EXENTO','')))

	nSucursal	:= AllTrim(SM0->M0_FILIAL)
	nCliente	:= cValToChar(SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI + " " + Alltrim(Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")))
	cNreduz		:= AllTrim(SA1->A1_NREDUZ)
	nTC :=  STR(POSICIONE("SM2",1,SC5->C5_EMISSAO,"M2_MOEDA2"))
	//	alert(nTC)
	nDireccion := alltrim(Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_END"))
	nFecha_Emision := cValToChar(DTOC(SC5->C5_EMISSAO))

	//	cDirAlmacen :=""
	//	nCliente 	:= 0
	//	ntienda	 	:= 0
	//	nCliente    := SC5->C5_CLIENTE
	//	nTienda	    := SC5->C5_LOJACLI
	//nTipoEntrega := alltrim(SC5->C5_UTIPOEN)
	nTipoEntrega := alltrim(IIF(SC5->C5_UTIPOEN == '1','Ent. Rapida',IIF(SC5->C5_UTIPOEN=='2','Ent. Sala',IIF(SC5->C5_UTIPOEN=='3','Ent. V. Mayor-ENC',IIF(SC5->C5_UTIPOEN=='4','Desp. Local',IIF(SC5->C5_UTIPOEN=='5','Desp. Provincial',IIF(SC5->C5_UTIPOEN=='6','Kardex','')))))))

	if(empty(nTipoEntrega))
		nTipoEntrega := "         "
	endif
	auxTel := alltrim(POSICIONE('SA1',1,XFILIAL('SE4')+SC5->C5_CLIENTE,"A1_TEL"))
	if(empty(auxTel))
		auxTel := "00"
	end if
	nTipo_Entrega := nTipoEntrega
	nFecha_Entrega := dtoc(SC5->C5_FECENT)
	ntelefono := "Telf.: " + auxTel
	nFactura := alltrim(SC5->C5_SERIE) + "/" + quitZero(alltrim(SC5->C5_NOTA))
	nVendedor :=  alltrim(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_COD")) +" "+ alltrim(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_NOME"))
	nTipo_Vendedor :=  Iif(SC5->C5_DOCGER == '1'," Ciudad",Iif(SC5->C5_DOCGER == '2',"Provincia","Entrega Futura"))
	nReg_Por := SC5->C5_USRREG

	nTipo_Remito := getRemito(SC5->C5_TIPOREM)

	nUsuarioA := Substr(CUsuario,7,15)
	nImpreso_Por := Upper(nUsuarioA)

	nCond_Pago := POSICIONE('SE4',1,XFILIAL('SE4')+SC5->C5_CONDPAGO,'E4_DESCRI')
	nObservacion :=  alltrim(SC5->C5_UOBSERV)
	nFecha_Vencto := dtoc(POSICIONE("SE1",1,xFilial("SE1")+SC5->C5_SERIE+SC5->C5_NOTA,"E1_VENCTO"))
	nBodega :=  SC5->C5_ULOCAL + " " + POSICIONE('NNR',1,xFilial('NNR')+SC5->C5_ULOCAL,'NNR_DESCRI')
	nUtaten := (cAliasNew)->F2_UCTATEN
	nTipo_Atención :=  Alltrim(nUtaten)

	//	nfechavalidez := dtoc((cAliasNew)->D2_DTVALID)
	nfechavalidez   := 		alltrim((cAliasNew)->D2_DTVALID)
	cAnho			:= 		SubStr(nfechavalidez, 1,4 )
	cMes			:= 		SubStr(nfechavalidez, 5,2 )
	cDia			:= 		SubStr(nfechavalidez, 7,2 )
	nfechavalidez	:= 		cDia + "/" + cMes + "/" + cAnho

	Ccodigo := (cAliasNew)->(D2_COD)

	//nUbicacion := alltrim(Posicione("SDB",1,xFilial("SDB")+Ccodigo+(cAliasNew)->(D2_LOCAL)+(cAliasNew)->(D2_NUMSEQ) + (cAliasNew)->(D2_DOC) + (cAliasNew)->(D2_SERIE) + SC5->C5_CLIENTE+SC5->C5_LOJACLI,"DB_LOCALIZ"))

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

	nSubtotal  := nValfat
	nDescuento := nDescont + valorBonificacion
	nDescuento := nDescuento - nDescPor
	nTotGral   := Round(nSubtotal+nDescuento,2)

	valorLiteral := "Son: " + Extenso(NOROUND(nBasimpl,2)) + IIf(SC5->C5_MOEDA == 1, " Bolivianos ", " Dolares")

	nUnidad := SB1->B1_UM
	cProducto   := SB1->B1_DESC  // DESCRIPCION

	cNum ++   // correlativo

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->PEDIDO       := nPedido
	(cWTabAlias)->T_CLIENTE    := nTipo_Cliente
	(cWTabAlias)->F_IMPRESI    := nfecha_impresion
	(cWTabAlias)->H_IMPRESI    := nhora_impresion
	(cWTabAlias)->SUCURSAL     := nSucursal
	(cWTabAlias)->T_CAMBIO     := val(nTC)
	(cWTabAlias)->CLIENTE      := nCliente
	(cWTabAlias)->NREDUZ	   := cNreduz
	(cWTabAlias)->DIRECCION    := nDireccion
	(cWTabAlias)->F_EMISION    := nFecha_Emision
	(cWTabAlias)->T_ENTREGA    := nTipo_Entrega
	(cWTabAlias)->F_ENTREGA    := nFecha_Entrega
	(cWTabAlias)->TELEFONO     := ntelefono
	(cWTabAlias)->FACTURA      := nFactura
	(cWTabAlias)->VENDEDOR     := nVendedor
	(cWTabAlias)->T_VENDEDOR   := nTipo_Vendedor
	(cWTabAlias)->REG_POR      := nReg_Por
	(cWTabAlias)->T_REMITO     := cValToChar(nTipo_Remito)
	(cWTabAlias)->IMPRES_POR   := nImpreso_Por
	(cWTabAlias)->COND_PAGO    := nCond_Pago
	(cWTabAlias)->OBSERVASIO   := nObservacion
	(cWTabAlias)->F_VENCTO     := nFecha_Vencto
	(cWTabAlias)->BODEGA       := nBodega

	(cWTabAlias)->CORRELATI    := cNum
	(cWTabAlias)->CODIGO       := alltrim(Ccodigo)    // codigo
	(cWTabAlias)->U_MEDIDA     := nUnidad
	(cWTabAlias)->DESCRIPCIO   := cProducto
	(cWTabAlias)->FABRICA      := (cAliasNew)->B1_UFABRIC
	(cWTabAlias)->CANTIDAD     := cValToChar((cAliasNew)->D2_QUANT)
	(cWTabAlias)->P_UNITARIO   := (cAliasNew)->D2_PRUNIT
	(cWTabAlias)->TOTAL        := cValor
	(cWTabAlias)->LOTE         := (cAliasNew)->D2_LOTECTL
	(cWTabAlias)->VALIDEZ      := nfechavalidez
	(cWTabAlias)->UBUCACION    := Trim((cAliasNew)->DB_LOCALIZ)

	(cWTabAlias)->SUBTOTAL     :=  cValToChar(TRANSFORM(nTotGral,"@E 99,999,999.99"))
	(cWTabAlias)->DESCUENTOS   :=  cValToChar(TRANSFORM( nDescuento ,"@E 99,999,999.99"))
	(cWTabAlias)->MON_TOTAL    :=  cValToCharl(TRANSFORM(nBasimpl,"@E 99,999,999.99"))
	(cWTabAlias)->RECARGO      :=  cValToChar(TRANSFORM(SC5->(C5_DESPESA+C5_SEGURO+C5_FRETE),"@E 99,999,999.99"))
	(cWTabAlias)->V_LITERAL    :=  cValToChar(valorLiteral)

	(cWTabAlias)->(MsUnlock())
	(cAliasNew)->(dbSkip())

enddo

return .T.

static function getRemito(valor)

	local nRemito := valor
	local Resp

	if nRemito == "0"
		Resp := "Ventas"

	elseif nRemito == "A"
		Resp := "Consignacion"

		//	elseif (nRemito == "R")
		//		return nRemitoR := "Reparacion en Gtia"

	endif

return Resp

//Static Function AjustaSX1(cPerg)
//	Local aHelpPor01 := {"Informe o numero do pedido inicial a ser ",    "considerado na selecao."}
//	Local aHelpEng01 := {"Enter the initial order number to be taken in","consideration."}
//	Local aHelpSpa01 := {"Digite el numero del pedido inicial que debe ","considerarse en la seleccion."}
//	Local aHelpPor02 := {"Informe o numero do pedido final a ser ",    "considerado na selecao."}
//	Local aHelpEng02 := {"Enter the final order number to be taken in","consideration."}
//	Local aHelpSpa02 := {"Digite el numero del pedido final que debe ","considerarse en la seleccion."}
//	Local aHelpPor03 := {"Seleciona a condicao do pedido de compras a",    "ser impressa."}
//	Local aHelpEng03 := {"Select the purchase order terms to print.",      ""}
//	Local aHelpSpa03 := {"Elija la condicion del pedido de compras que se","debe imprimir."}
//	PutSX1(cPerg,"01","De pedido ?",       "¿De pedido ?",       "From order ?","mv_ch1","C",6,0,0,"G","","","","","mv_par01","","","","",      "","","","","","","","","","","","",aHelpPor01,aHelpEng01,aHelpSpa01)
//	PutSX1(cPerg,"02","Ate pedido ?",      "¿A pedido ?",        "To order ?",  "mv_ch2","C",6,0,0,"G","","","","","mv_par02","","","","zzzzzz","","","","","","","","","","","","",aHelpPor02,aHelpEng02,aHelpSpa02)
//	//PutSX1(cPerg,"03","Pedidos liberados?","¿Pedidos Aprobados?","orders ?",    "mv_ch3","N",1,0,3,"C","","","","","mv_par03","Estoque","Stock","Inventory","","Credito","Credito","Credit","Credito/Estoque","Credito/Stock","Credit/Invent.","","","","","","",aHelpPor03,aHelpEng03,aHelpSpa03)
//	//if(FUNNAME()== 'MATA410')
//	SX1->(DbSetOrder(1))
//	if SX1->(DbSeek(cPerg+Space(4)+'01'))
//		RecLock('SX1',.F.)
//		SX1->X1_CNT01 := SC5->C5_NUM
//		SX1->(MsUnlock())
//	end
//	if SX1->(DbSeek(cPerg+Space(4)+'02'))
//		RecLock('SX1',.F.)
//		SX1->X1_CNT01 := SC5->C5_NUM
//		SX1->(MsUnlock())
//	end
//	//End
//return

//static function cambMoeda(cValor)
//	local cNewVal
//	cNewVal = xMoeda(cValor,1,2,,2,1,0)
//return cNewVal

static Function quitZero(cTexto)
	local aArea     := GetArea()
	local cRetorno  := ""
	local lContinua := .T.

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
