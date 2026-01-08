#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"
#Include "TopConn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥WS     ≥ RESTPEDVEN ≥ Autor ≥ POST Denar Terrazas					  ≥±±
±±      						 GET Erick Etcheverry ≥ Data ≥ 26/07/2018 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Web service para Ingresar un pedido 						  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ TdeP Horeb                                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

WSRESTFUL pedido DESCRIPTION "Obtener historial pedido movil"
	WSDATA CODVEN As String //Json Recebido

	WSMETHOD POST  DESCRIPTION "Inserta producto en base de dados protheus" WSSYNTAX ""
	WSMETHOD GET  	DESCRIPTION "Retorna lista de pedidos realizados en el movil" 	WSSYNTAX ""
//WSMETHOD PUT  	DESCRIPTION "Altera cliente" 			WSSYNTAX "/CLIENTES || /CLIENTES/{CGC}"

END WSRESTFUL

WSMETHOD POST  WSSERVICE pedido
	Local lPost := .T.
	Local cBody
	Local lAcepto := .F.
	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	LOCAL aUSR := {}
	private oObj
	PRIVATE lMsErroAuto := .F.
//	begin transaction
	::SetContentType("application/json;charset=utf-8")

	//	oJson := JsonObject():New()
	cBody := DecodeUTF8(Self:GetContent(), "cp1252")
	FWJsonDeserialize(cBody,@oObj)
	//	oObj  :=  oJson:FromJson(cBody)


	if empty(cBody)
		cBody := "Sin Valor"
	else
		if Type("oObj:DDATABASE") <> "U"// caso exista
			DDATABASE:= CTOD(oObj:DDATABASE)
		endif
		if type("oObj:TOKEN") <> "U" // nahim validando si existe TOKEN Pedido de venta
			if !empty(oObj:TOKEN) // que no sea vacio 16/06/2020
				DbSelectArea("SC5")
				SC5->(dBSetOrder(8))
				IF SC5->(DbSeek(xFilial("SC5")+ Padr(cvaltochar(oObj:TOKEN),TamSX3("C5_UIDAPP")[1]))) // valido si est· en la base de datos y devuelvo el recibo
					// mostrnaod r
					cJson := u_pedidobyid(oObj:C5_CLIENTE,oObj:C5_LOJACLI,SC5->C5_NUM)
					//		cJson := u_pedidobyid(oObj:C5_CLIENTE,oObj:C5_LOJACLI,cDoc)
					//cJson := EncodeUtf8(cJson)
					::SetResponse(cJson)
					return lPost
				ENDIF
				DBCLOSEAREA("SC5")
			endif
			// validar si existe el id en la SEL
		endif
		//	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

		cDoc := GetSxeNum("SC5","C5_NUM")
		RollBAckSx8()

		aCabec := {} // Pedido 0001
		aItens := {} // Productos Detalle 01 02 03

		aadd(aCabec,{"C5_NUM"   ,cDoc,Nil})
		aadd(aCabec,{"C5_TIPO" ,"N",Nil})  // siempre es N
		aadd(aCabec,{"C5_CLIENTE",oObj:C5_CLIENTE,Nil})
		aadd(aCabec,{"C5_LOJACLI",oObj:C5_LOJACLI,Nil})
		//		aadd(aCabec,{"C5_LOJAENT",'01',Nil})
		// caso
		if Type("oObj:TOKEN") <> "U"// caso exista
			aadd(aCabec,{"C5_UIDAPP",cvaltochar(oObj:TOKEN),Nil})
		endif
		if Type("oObj:C5_CONDPAG") <> "U"// caso exista
			aadd(aCabec,{"C5_CONDPAG",oObj:C5_CONDPAG,Nil})
		endif
		if Type("oObj:C5_UOBSERV") <> "U"// caso exista
			aadd(aCabec,{"C5_UOBSERV","VM: " + oObj:C5_UOBSERV,Nil})
		else
			aadd(aCabec,{"C5_UOBSERV","Venta MÛvil",Nil})
		endif
		if Type("oObj:DDATABASE") <> "U"// caso exista
			aadd(aCabec,{"C5_EMISSAO",CTOD(oObj:DDATABASE),Nil})
		endif
		IF oObj:C5_MOEDA <> Nil
			aadd(aCabec,{"C5_MOEDA",oObj:C5_MOEDA,Nil})
			//aadd(aCabec,{"C5_MOEDTIT",oObj:C5_MOEDA,Nil})
		endif

		/**
		* DT 17/06/2022
		* Union solicita que la moneda para el tÌtulo sea siempre en DÛlares
		**/
		aadd(aCabec,{"C5_MOEDTIT",2,Nil})
		/***************/

		aUSR := bscCodVen(oObj:USRCOD)
		//		if aUSR[3]
		if  Type("aUSR[3]") <> "U" //aUSR[1]
			aadd(aCabec,{"C5_VEND1",aUSR[1],Nil})
		ENDIF
		//		oObj:USRCOD validar si existe C5_VEND1 adicionar vendedor validar si es que hay
		//
		if Type("oObj:C5_UNITCLI") <> "U"// caso exista
			aadd(aCabec,{"C5_UNITCLI",oObj:C5_UNITCLI,Nil})
		endif
		if Type("oObj:C5_UNOMCLI") <> "U"// caso exista
			aadd(aCabec,{"C5_UNOMCLI",oObj:C5_UNOMCLI,Nil})
		endif
		if Type("oObj:C5_UTIPOEN") <> "U"// en caso tenga tipo de entrega se incluye Nahim 07/06/2020 Especifico UniÛn Agronegocios.
			aadd(aCabec,{"C5_UTIPOEN",cvaltochar(oObj:C5_UTIPOEN),Nil})
		endif

		if Type("oObj:C5_CODMPAG") <> "U"//FacturaciÛn electrÛnica - CÛdigo del MÈtodo de Pago
			aadd(aCabec,{"C5_CODMPAG",cvaltochar(oObj:C5_CODMPAG),Nil})
		endif

		if Type("oObj:C5_XCLDOCI") <> "U"//FacturaciÛn electrÛnica - Complemento de Documento de Identidad
			aadd(aCabec,{"C5_XCLDOCI",cvaltochar(oObj:C5_XCLDOCI),Nil})
		endif

		if Type("oObj:C5_XTIPDOC") <> "U"//FacturaciÛn electrÛnica - Tipo Documento de Identidad
			aadd(aCabec,{"C5_XTIPDOC",cvaltochar(oObj:C5_XTIPDOC),Nil})
		endif

		if Type("oObj:C5_XEMAIL") <> "U"//FacturaciÛn electrÛnica - Email
			aadd(aCabec,{"C5_XEMAIL",cvaltochar(oObj:C5_XEMAIL),Nil})
		endif

		if Type("oObj:C5_NUMTARG") <> "U"//FacturaciÛn electrÛnica - N˙mero Tarjeta
			aadd(aCabec,{"C5_NUMTARG",cvaltochar(oObj:C5_NUMTARG),Nil})
		endif

		nCanPro := len(oObj:productos)
		For nX := 1 To nCanPro // este for deberia ser por cada producto
			aLinha := {}
			cProduto:= oObj:productos[nX]:C6_PRODUTO
			//			cTes:= Posicione("SB1",1,xFilial("SB1")+ cProduto,"B1_TS")
			//			cTes:= IIF(!EMPTY(ALLTRIM(cTes)), cTes, "501")

			aadd(aLinha,{"C6_ITEM",StrZero(nX,2),Nil}) // se define los items (este es correlativo)
			aadd(aLinha,{"C6_PRODUTO",cProduto,Nil}) // codigo del producto WS
			aadd(aLinha,{"C6_QTDVEN",oObj:productos[nX]:C6_QTDVEN,Nil}) // Cantidad obtenida por cada Pedido WS
			aadd(aLinha,{"C6_QTDLIB",oObj:productos[nX]:C6_QTDVEN,Nil}) // Cantidad obtenida por cada Pedido WS


			if oObj:productos[nX]:B1_PRV1== 0 // caso el precio sea 0
				aadd(aLinha,{"C6_PRUNIT",0.01,Nil}) // precio venta en un comienzo NAHIM COMENTANDO 12/03/2020
				aadd(aLinha,{"C6_PRCVEN",0.01,Nil}) // precio venta en un comienzo NAHIM COMENTANDO 12/03/2020
			else
				if Type("oObj:online") == "U"  // Verifica si es online
					aadd(aLinha,{"C6_PRUNIT",oObj:productos[nX]:B1_PRV1,Nil}) // precio venta en un comienzo NAHIM COMENTANDO 14/09/2020
					aadd(aLinha,{"C6_PRCVEN",oObj:productos[nX]:B1_PRV1,Nil}) // precio venta en un comienzo NAHIM COMENTANDO 14/09/2020
				else // caso exista la variable
					if oObj:online <> '2' // 2 es online y el precio lo define la App
						aadd(aLinha,{"C6_PRUNIT",oObj:productos[nX]:B1_PRV1,Nil}) // precio venta en un comienzo NAHIM COMENTANDO 14/09/2020
						aadd(aLinha,{"C6_PRCVEN",oObj:productos[nX]:B1_PRV1,Nil}) // precio venta en un comienzo NAHIM COMENTANDO 14/09/2020
					endif
				endif
			endif
			if Type("oObj:productos[nX]:C6_LOCAL") <> "U"// caso exista
				if nX == 1 // caso sea el primero debe colocar el local.
					aadd(aCabec,{"C5_ULOCAL",oObj:productos[nX]:C6_LOCAL,Nil}) // adicionando local
					// caso sea el almacÈn 2 deberÌa
					If oObj:productos[nX]:C6_LOCAL $ GETMV("MV_XALMPVR")
//						if xfilial("SC5") == '0105' .and. (oObj:productos[nX]:C6_LOCAL == '02' .or. oObj:productos[nX]:C6_LOCAL == '06') // caso sea santa cruz y el local es el 2
						aadd(aCabec,{"C5_DOCGER",'2',Nil}) // adicionando local
//						elseif xfilial("SC5") <> '0105'  .and. oObj:productos[nX]:C6_LOCAL == '01'  // caso no sea santa cruz y sea tienda 2
//							aadd(aCabec,{"C5_DOCGER",'2',Nil}) // adicionando local
					endif
				endif
				//					aadd(aLinha,{"C6_LOCAL",oObj:productos[nX]:C6_LOCAL,Nil})
			endif
			//			aadd(aLinha,{"C6_PRUNIT",oObj:productos[nX]:B1_PRV1,Nil}) // precio WS NAHIM COMENTANDO 12/03/2020
			//			aadd(aLinha,{"C6_PRUNIT",oObj:productos[nX]:B1_PRV1,Nil})  // precio WS
			// 			aadd(aLinha,{"C6_VALOR",oObj:productos[nX]:B1_PRV1 * oObj:productos[nX]:C6_QTDVEN,Nil})  // precio WS
			//			aadd(aLinha,{"C6_TES",cTes,Nil}) // Tipo de entrada Salida
			if Type("oObj:productos[nX]:C6_DESCONT") <> "U"// caso exista
				aadd(aLinha,{"C6_DESCONT",oObj:productos[nX]:C6_DESCONT,Nil}) // porcentaje de descuento
			endif
			if Type("oObj:productos[nX]:C6_VALDESC") <> "U"// caso exista
				IF oObj:productos[nX]:C6_VALDESC >= (oObj:productos[nX]:B1_PRV1 * oObj:productos[nX]:C6_QTDVEN)
					conout((oObj:productos[nX]:B1_PRV1 * oObj:productos[nX]:C6_QTDVEN) - 0.01)
					aadd(aLinha,{"C6_VALDESC",(oObj:productos[nX]:B1_PRV1 * oObj:productos[nX]:C6_QTDVEN) - 0.01,Nil}) // porcentaje de descuento
				ELSE
					aadd(aLinha,{"C6_VALDESC",oObj:productos[nX]:C6_VALDESC,Nil}) // porcentaje de descuento
				ENDIF
			endif

			// JustificaciÛn de descuento C6_UTPLIQ
			if Type("oObj:productos[nX]:C6_UTPLIQ") <> "U"// caso exista
				aadd(aLinha,{"C6_UTPLIQ",oObj:productos[nX]:C6_UTPLIQ,Nil}) // justificaciÛn de descuento por linea. Nahim 07/06/2020
			endif

			//			if(oObj:productos[nX]:C6_DESCONT > 0)
			//			else
			//				aadd(aLinha,{"C6_VALDESC",oObj:productos[nX]:C6_VALDESC,Nil}) // valor de descuento
			aadd(aLinha,{"C6_VDOBS",oObj:productos[nX]:C6_VDOBS,Nil}) // obs descuento
			aadd(aItens,aLinha)
		Next nX

		MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, 3, .F.)
		//		MATA410(aCabec,aItens,3) // funcion Importante

		If !lMsErroAuto
			ConOut("Incluido com sucesso! " + cDoc)
			//MostraErro()
			lAcepto := .T.
		Else
			ConOut("Erro na inclusao!")
			cMessage := MostraErro("/temp","error.log")
			//			ConOut(MostraErro())
		EndIf
	endif

	//lAcepto := insertPed(cBody)
	if lAcepto
		// nahim probando 26/08/2019
		cJson := u_pedidobyid(oObj:C5_CLIENTE,oObj:C5_LOJACLI,SC5->C5_NUM)
		//		cJson := u_pedidobyid(oObj:C5_CLIENTE,oObj:C5_LOJACLI,cDoc)
		//cJson := EncodeUtf8(cJson)
		::SetResponse(cJson)
	else
		cMessage := StrTran( cMessage, Chr (13) , "\n" )
		cMessage := StrTran( cMessage, Chr (10) , "" )
		::SetResponse('{"Status":"Fail","message":"' + cMessage +'"}')
	endif
//	END transaction
Return lPost

WSMETHOD GET WSRECEIVE CODVEN WSSERVICE pedido // recibir por QueryString si hay codigo de usuario para filtrar
	Local aArea 	 := GetArea()
	Local cNextAlias := GetNextAlias()
	Local oPedido
	LOCAL aPedidos := {}
	Local cJSON		 := ""
	Local lRet		 := .T.
	local objProducto
	LOCAL aProds := {}
	local cFilt := ""

	::SetContentType("application/json;charset=utf-8")

	cCodUsr := ::CODVEN

	if !empty(cCodUsr)
		//		aUSR := bscCodVen(cCodUsr)
		//		if aUSR[3]
		BeginSQL Alias cNextAlias
			SELECT DISTINCT top 3000 C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_CONDPAG,C5_UNOMCLI,C5_LOJACLI,F2_EMISSAO,C5_DOCGER,
			C5_UTIPOEN,C5_UIDAPP,
			C5_CODMPAG, C5_XCLDOCI, C5_XTIPDOC, C5_XEMAIL, C5_NUMTARG, F2_NUMAUT,
			CASE
			WHEN C5_INCISS = 'n' AND C5_LIBEROK = '' AND C5_NOTA = '' AND C5_BLQ = '' THEN '#f059e5'
			WHEN C5_NOTA <> 'REMITO' AND C5_LIBEROK = '' AND C5_NOTA = '' AND C5_BLQ = '' THEN '#9ce564'
			WHEN C5_NOTA <> 'REMITO' AND (C5_NOTA <> '' OR C5_LIBEROK='E') AND C5_BLQ = '' THEN '#f45253'
			WHEN C5_NOTA <> 'REMITO' AND C5_BLQ = '1' THEN '#75a5d2'
			WHEN C5_NOTA <> 'REMITO' AND C5_BLQ = '2' THEN '#f0b759'
			WHEN C5_NOTA <> 'REMITO' AND C5_LIBEROK = 'P' THEN '#ececec'
			WHEN C5_NOTA = 'REMITO' AND C5_TIPOREM <> 'A' THEN '#a3a3a3'
			WHEN C5_NOTA = 'REMITO' AND C5_TIPOREM = 'A' THEN 'CONSIG'
			WHEN C9_BLCRED <> '  ' AND C9_BLCRED <> '09'AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' THEN '#851c85'
			WHEN C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ' THEN '#000000'
			WHEN C5_NOTA <> 'REMITO' AND  C5_LIBEROK <> ' ' AND C5_NOTA = '' AND C5_BLQ = '' AND C5_LIBEROK<>'P' THEN '#ebeb5f'
		END C5_COLOR,

		(SELECT MAX(
		case
		WHEN C9_BLCRED <> '  ' AND C9_BLCRED <> '09'AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' THEN '#851c85'
		WHEN C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ' THEN '#000000'
	END
	) ntp FROM SC9010 SC92 WHERE
	(( C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ')
	OR  ( C9_BLCRED <> '  ' AND C9_BLCRED <> '09' AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' ))
	AND SC92.C9_PEDIDO = SC9.C9_PEDIDO AND SC92.C9_FILIAL = SC9.C9_FILIAL AND SC92.D_E_L_E_T_!='*' ) COLOR,
	C5_UNITCLI,C5_USRREG,C5_VEND1,A3_NOME,C6_ENTREG,C6_ITEM,C6_PRODUTO,C6_LOCAL, C6_FILIAL,C6_DESCONT,C6_TES,C6_VALDESC,C6_PRCVEN,C5_UOBSERV
	,C6_UM, C6_QTDVEN,C6_PRUNIT,C6_VALOR, C6_LOTECTL,B1_DESC C6_UESPECI,C5_SERIE,C5_NOTA,
	C6_UTPLIQ,
	C5_TXMOEDA,C5_MOEDA,E4_DESCRI,B1_DESC ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC
	FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO
	FROM %Table:SC6% SC61
	WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC,
	(SELECT (TOTAL)
	FROM (SELECT SUM(C6_VALOR) TOTAL
	FROM %Table:SC6% SC61
	WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) TOTAL
	FROM  %Table:SC5% SC5
	JOIN %Table:SC6% SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL and SC6.D_E_L_E_T_<>'*'
	LEFT JOIN %Table:SA3% SA3 ON A3_COD=C5_VEND1  AND SA3.D_E_L_E_T_ LIKE ''
	JOIN %Table:SB1%  SB1 ON B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_ LIKE ''
	JOIN %Table:SE4% SE4 ON E4_CODIGO=C5_CONDPAG AND  SE4.D_E_L_E_T_ LIKE ''
	LEFT JOIN %Table:SC9% SC9 ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM
	AND C5_CLIENTE = C9_CLIENTE AND C5_LOJACLI = C9_LOJA
	AND SC9.D_E_L_E_T_<>'*' AND C9_ITEM = C6_ITEM
	LEFT JOIN %Table:SF2% SF2 ON F2_DOC=C5_NOTA and F2_SERIE = C5_SERIE and SF2.D_E_L_E_T_<>'*'
	WHERE UPPER(C5_USRREG) LIKE %exp:upper(CUSERNAME)% AND SC5.D_E_L_E_T_!='*'
	AND C5_FILIAL = %exp:xFilial('SC5')%
	ORDER BY 1,2 DESC
		EndSQL
		//		ENDIF
	ELSE
		BeginSQL Alias cNextAlias
			SELECT DISTINCT top 3000 C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_CONDPAG,C5_UNOMCLI,C5_LOJACLI,F2_EMISSAO,C5_DOCGER,
			C5_UTIPOEN,C5_UIDAPP,
			C5_CODMPAG, C5_XCLDOCI, C5_XTIPDOC, C5_XEMAIL, C5_NUMTARG, F2_NUMAUT,
			CASE
			WHEN C5_INCISS = 'n' AND C5_LIBEROK = '' AND C5_NOTA = '' AND C5_BLQ = '' THEN '#f059e5'
			WHEN C5_NOTA <> 'REMITO' AND C5_LIBEROK = '' AND C5_NOTA = '' AND C5_BLQ = '' THEN '#9ce564'
			WHEN C5_NOTA <> 'REMITO' AND (C5_NOTA <> '' OR C5_LIBEROK='E') AND C5_BLQ = '' THEN '#f45253'
			WHEN C5_NOTA <> 'REMITO' AND C5_BLQ = '1' THEN '#75a5d2'
			WHEN C5_NOTA <> 'REMITO' AND C5_BLQ = '2' THEN '#f0b759'
			WHEN C5_NOTA <> 'REMITO' AND C5_LIBEROK = 'P' THEN '#ececec'
			WHEN C5_NOTA = 'REMITO' AND C5_TIPOREM <> 'A' THEN '#a3a3a3'
			WHEN C5_NOTA = 'REMITO' AND C5_TIPOREM = 'A' THEN 'CONSIG'
			WHEN C9_BLCRED <> '  ' AND C9_BLCRED <> '09'AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' THEN '#851c85'
			WHEN C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ' THEN '#000000'
			WHEN C5_NOTA <> 'REMITO' AND  C5_LIBEROK <> ' ' AND C5_NOTA = '' AND C5_BLQ = '' AND C5_LIBEROK<>'P' THEN '#ebeb5f'
		END C5_COLOR,

		(SELECT MAX(
		case
		WHEN C9_BLCRED <> '  ' AND C9_BLCRED <> '09'AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' THEN '#851c85'
		WHEN C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ' THEN '#000000'
	END
	) ntp FROM SC9010 SC92 WHERE
	(( C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ')
	OR  ( C9_BLCRED <> '  ' AND C9_BLCRED <> '09' AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' ))
	AND SC92.C9_PEDIDO = SC9.C9_PEDIDO AND SC92.C9_FILIAL = SC9.C9_FILIAL AND SC92.D_E_L_E_T_!='*' ) COLOR,

	C5_UNITCLI,C5_USRREG,C5_VEND1,A3_NOME,C6_ENTREG,C6_ITEM,C6_PRODUTO,C6_LOCAL, C6_FILIAL, C6_DESCONT,C6_VALDESC,C6_PRCVEN,C5_UOBSERV
	,C6_TES,C6_UM, C6_QTDVEN,C6_PRUNIT,C6_VALOR, C6_LOTECTL,B1_DESC C6_UESPECI,C5_SERIE,C5_NOTA,
	C6_UTPLIQ,
	C5_TXMOEDA,C5_MOEDA,E4_DESCRI,B1_DESC ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC
	FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO
	FROM %Table:SC6% SC61
	WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC,
	(SELECT (TOTAL)
	FROM (SELECT SUM(C6_VALOR) TOTAL
	FROM %Table:SC6% SC61
	WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) TOTAL
	FROM  %Table:SC5% SC5
	JOIN %Table:SC6% SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL and SC6.D_E_L_E_T_<>'*'
	LEFT JOIN %Table:SA3% SA3 ON A3_COD=C5_VEND1  AND SA3.D_E_L_E_T_ LIKE ''
	JOIN %Table:SB1%  SB1 ON B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_ LIKE ''
	JOIN %Table:SE4% SE4 ON E4_CODIGO=C5_CONDPAG AND  SE4.D_E_L_E_T_ LIKE ''
	LEFT JOIN %Table:SC9% SC9 ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C5_CLIENTE = C9_CLIENTE AND C5_LOJACLI = C9_LOJA AND SC9.D_E_L_E_T_<>'*' AND C9_ITEM = C6_ITEM
	LEFT JOIN %Table:SF2% SF2 ON F2_DOC=C5_NOTA and F2_SERIE = C5_SERIE and SF2.D_E_L_E_T_<>'*'
	WHERE SC5.D_E_L_E_T_ LIKE ''
	AND C5_FILIAL = %exp:xFilial('SC5')%
	ORDER BY 1,2 DESC
		EndSQL
	endif
	DbSelectArea(cNextAlias) // seleccionar area Area

	(cNextAlias)->( DbGoTop() )

	//	oPedido	 := Pedido():New()

	If (cNextAlias)->( !Eof() )
		oPedido := JsonObject():new()
		oPedido['C5_NUM']		:=     "" // nuevo

		While !(cNextAlias)->(Eof() )

			IF alltrim(oPedido['C5_NUM']) != alltrim((cNextAlias)->C5_NUM)
				oPedido := JsonObject():new()
				//alert("Entro")
				oPedido['C5_NUM']		:= (cNextAlias)->C5_NUM
				oPedido['C5_USRREG']	:= (cNextAlias)->C5_USRREG
				oPedido['C5_CLIENTE']	:= (cNextAlias)->C5_CLIENTE
				oPedido['C5_CONDPAG']	:= (cNextAlias)->C5_CONDPAG
				oPedido['C5_UTIPOEN']	:= (cNextAlias)->C5_UTIPOEN // tipo de entrega Nahim 07/06/2020
				oPedido['C5_EMISSAO']	:= (cNextAlias)->C5_EMISSAO
				oPedido['C5_FILIAL']	:= (cNextAlias)->C5_FILIAL
				oPedido['C5_LOJACLI']	:= (cNextAlias)->C5_LOJACLI
				oPedido['C5_MOEDA']		:= (cNextAlias)->C5_MOEDA
				oPedido['C5_NOTA']		:= (cNextAlias)->C5_NOTA
				oPedido['C5_SERIE']		:= (cNextAlias)->C5_SERIE
				oPedido['C5_UNITCLI']	:= (cNextAlias)->C5_UNITCLI
				oPedido['C5_UOBSERV']	:= (cNextAlias)->C5_UOBSERV // agregando observaciÛn Nahim 04/02/2020
				oPedido['C5_DOCGER']	:= (cNextAlias)->C5_DOCGER // agregando documento a generar 14/04/2020
				oPedido['C5_UNOMCLI']	:= ALLTRIM((cNextAlias)->C5_UNOMCLI)
				oPedido['token']		:= (cNextAlias)->C5_UIDAPP // id App mÛvil (TOKEN)

				//Electronic Invoice
				oPedido['C5_CODMPAG']	:= ALLTRIM((cNextAlias)->C5_CODMPAG)
				oPedido['C5_XCLDOCI']	:= ALLTRIM((cNextAlias)->C5_XCLDOCI)
				oPedido['C5_XTIPDOC']	:= ALLTRIM((cNextAlias)->C5_XTIPDOC)
				oPedido['C5_XEMAIL']	:= ALLTRIM((cNextAlias)->C5_XEMAIL)
				oPedido['C5_NUMTARG']	:= ALLTRIM((cNextAlias)->C5_NUMTARG)
				oPedido['F2_NUMAUT']	:= TRIM((cNextAlias)->F2_NUMAUT)

				if !empty(cCodUsr)
					oPedido['C5_VEND1']	:=         cCodUsr
				else
					oPedido['C5_VEND1']	:=         (cNextAlias)->C5_VEND1
				endif
				//				oPedido['C5_VEND1']	:=         (cNextAlias)->C5_VEND1 // Nahim 14/03/2020
				oPedido['C5_LOJACLI']	:=     (cNextAlias)->C5_LOJACLI
				oPedido['F2_EMISSAO']	:=     (cNextAlias)->F2_EMISSAO
				oPedido['A3_NOME']	:=     ALLTRIM((cNextAlias)->A3_NOME)
				if !empty((cNextAlias)->COLOR) // caso que tenga color
					if (alltrim((cNextAlias)->C5_COLOR)) == '#ebeb5f' // sÛlo si es amarillo
						oPedido['C5_COLOR']   := alltrim((cNextAlias)->COLOR)
					else
						oPedido['C5_COLOR']   := alltrim((cNextAlias)->C5_COLOR)
					endif
				else
					oPedido['C5_COLOR']   := alltrim((cNextAlias)->C5_COLOR)
				endif

				/*
				oPedido	 := Pedido():New()
				oPedido:SetFilial((cNextAlias)->C5_FILIAL)
				oPedido:SetNum(alltrim((cNextAlias)->C5_NUM))
				oPedido		:SetNome((cNextAlias)->A3_NOME)
				oPedido:SetClient((cNextAlias)->C5_CLIENTE)
				oPedido:SetEmissao((cNextAlias)->C5_EMISSAO)
				oPedido:SetConPa((cNextAlias)->C5_CONDPAG)
				oPedido:SetNota((cNextAlias)->C5_NOTA)
				oPedido:SetMoeda((cNextAlias)->C5_MOEDA)
				oPedido:SetSerie((cNextAlias)->C5_SERIE)
				oPedido:SetNitCli((cNextAlias)->C5_UNITCLI)
				oPedido:SetUnomCli((cNextAlias)->C5_UNOMCLI)
				oPedido:SetVend((cNextAlias)->C5_VEND1 )
				oPedido:SetLojacli((cNextAlias)->C5_LOJACLI )
				*/
	ENDIF
	objProducto := JsonObject():new()
	objProducto['B1_COD']	   := (cNextAlias)->C6_PRODUTO
	objProducto['B1_DESC'] 	   := (cNextAlias)->B1_DESC
	objProducto['B1_PRV1']     := (cNextAlias)->C6_PRUNIT
	objProducto['C6_PRCVEN']     := (cNextAlias)->C6_PRCVEN // PRECIO DE VENTA SIN DESCUENTO
	objProducto['B1_UM']      := (cNextAlias)->C6_UM
	objProducto['C6_DESCONT']  := (cNextAlias)->C6_DESCONT
	objProducto['C6_VALDESC']  := (cNextAlias)->C6_VALDESC
	objProducto['C6_FILIAL']   := (cNextAlias)->C6_FILIAL
	objProducto['C6_ITEM']     := (cNextAlias)->C6_ITEM
	objProducto['C6_LOCAL']    := (cNextAlias)->C6_LOCAL
	objProducto['C6_QTDVEN']   := (cNextAlias)->C6_QTDVEN
	objProducto['C6_TES']   := (cNextAlias)->C6_TES
	objProducto['C6_UTPLIQ']	:= (cNextAlias)->C6_UTPLIQ// descuento justificaciÛn Nahim 07/06/2020
	objProducto['PEDVEN']   := alltrim((cNextAlias)->C5_NUM)

	//			objProducto['C6_VDOBS']    := (cNextAlias)->C6_VDOBS)

			/*
			objProducto := ProductoItem():new()
			objProducto:setB1_COD((cNextAlias)->C6_PRODUTO)
			objProducto:setB1_DESC((cNextAlias)->B1_DESC)
			objProducto:setB1_PRV1((cNextAlias)->C6_PRUNIT)
			objProducto:setB1_UM((cNextAlias)->C6_UM)
			objProducto:setCodPed((cNextAlias)->C5_NUM)
			objProducto:setC6_DESCONT((cNextAlias)->C6_DESCONT)
			objProducto:setC6_FILIAL((cNextAlias)->C6_FILIAL)
			objProducto:setC6_QTDVEN((cNextAlias)->C6_QTDVEN)
			objProducto:setC6_ITEM((cNextAlias)->C6_ITEM)*/

			AADD(aProds,objProducto)

			//oPedido:SetProd(objProducto)

			(cNextAlias)->( DbSkip() )

			IF (alltrim(oPedido['C5_NUM']) != alltrim((cNextAlias)->C5_NUM)) .or. (cNextAlias)->(Eof()) // caso estÈ cambiando de pedido vamos a v
				oPedido['APROD'] := aProds
				aProds := {}
				aadd(aPedidos,oPedido)
			ENDIF
		EndDo

		//		for i := 1 to len(aProds)
		//
		//			cProdPed := aProds[i]:['C5_NUM'] // obtengo el nro
		//			cProdFil := aProds[i]:['C5_FILIAL']
		//
		//			for j := 1 to len(aPedidos)
		//
		//				if aPedidos[j]:['C5_NUM'] == cProdPed .and. aPedidos[j]:['C5_FILIAL'] == cProdFil
		//					aPedidos[j]:['APROD'] :=(aProds[i])
		//				endif
		//			next
		//
		//		next

		cJson := FWJsonSerialize(aPedidos,.T.,.T.)

		cJson := EncodeUtf8(cJson)

		::SetResponse(cJson)

	Else
		SetRestFault(400, "Empty + "+CUSERNAME )
		lRet := .F.
	EndIf
	RestArea(aArea)
Return(lRet)

user function pedidoById(cClient,cLojaCLi,cNumPed)
	Local aArea 	 := GetArea()
	Local cNextAlias := GetNextAlias()
	Local oPedido
	LOCAL aPedidos := {}
	Local cJson		 := ""
	Local lRet		 := .T.
	local objProducto
	LOCAL aProds := {}

	BeginSQL Alias cNextAlias
		SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_LOJACLI,C5_CONDPAG,C5_UNOMCLI,C5_SERIE,C5_NOTA,C5_DOCGER,
		C5_UTIPOEN,
		C5_CODMPAG, C5_XCLDOCI, C5_XTIPDOC, C5_XEMAIL, C5_NUMTARG,
		CASE
		WHEN C5_INCISS = 'n' AND C5_LIBEROK = '' AND C5_NOTA = '' AND C5_BLQ = '' THEN '#f059e5'
		WHEN C5_NOTA <> 'REMITO' AND C5_LIBEROK = '' AND C5_NOTA = '' AND C5_BLQ = '' THEN '#9ce564'
		WHEN C5_NOTA <> 'REMITO' AND (C5_NOTA <> '' OR C5_LIBEROK='E') AND C5_BLQ = '' THEN '#f45253'
		WHEN C5_NOTA <> 'REMITO' AND C5_BLQ = '1' THEN '#75a5d2'
		WHEN C5_NOTA <> 'REMITO' AND C5_BLQ = '2' THEN '#f0b759'
		WHEN C5_NOTA <> 'REMITO' AND C5_LIBEROK = 'P' THEN '#ececec'
		WHEN C5_NOTA = 'REMITO' AND C5_TIPOREM <> 'A' THEN '#a3a3a3'
		WHEN C5_NOTA = 'REMITO' AND C5_TIPOREM = 'A' THEN 'CONSIG'
		WHEN C9_BLCRED <> '  ' AND C9_BLCRED <> '09'AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' THEN '#851c85'
		WHEN C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ' THEN '#000000'
		WHEN C5_NOTA <> 'REMITO' AND  C5_LIBEROK <> ' ' AND C5_NOTA = '' AND C5_BLQ = '' AND C5_LIBEROK<>'P' THEN '#ebeb5f'
	END C5_COLOR,

	(SELECT MAX(
	case
	WHEN C9_BLCRED <> '  ' AND C9_BLCRED <> '09'AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' THEN '#851c85'
	WHEN C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ' THEN '#000000'
	END
	) ntp FROM %Table:SC9% SC92 WHERE
	(( C9_BLEST <> '  ' AND C9_BLEST <> '10' AND  C9_BLEST <> 'ZZ')
	OR  ( C9_BLCRED <> '  ' AND C9_BLCRED <> '09' AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ' ))
	AND SC92.C9_PEDIDO = SC9.C9_PEDIDO AND SC92.C9_FILIAL = SC9.C9_FILIAL AND SC92.D_E_L_E_T_!='*' ) COLOR,

	C5_UNITCLI,C5_USRREG,C5_VEND1,A3_NOME,C6_ENTREG,C6_ITEM,C6_PRODUTO,C6_LOCAL, C6_FILIAL, C6_DESCONT,C5_UOBSERV,
	C6_UTPLIQ,C6_UM, C6_QTDVEN,C6_PRUNIT,C6_VALOR, C6_LOTECTL,B1_DESC C6_UESPECI,C6_VALDESC,C6_PRCVEN,
	C6_TES,C5_TXMOEDA,C5_MOEDA,E4_DESCRI,B1_DESC ,(SELECT (DSCTO/TOTAL) * 100.00 PDESC
	FROM (SELECT SUM(C6_VALOR) + SUM(C6_VALDESC) TOTAL, SUM(C6_VALDESC) DSCTO
	FROM %Table:SC6% SC61
	WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) C5_PDESC,
	(SELECT (TOTAL)
	FROM (SELECT SUM(C6_VALOR) TOTAL
	FROM %Table:SC6% SC61
	WHERE C6_NUM=SC5.C5_NUM AND C6_CLI=SC5.C5_CLIENTE AND SC61.D_E_L_E_T_!='*') A ) TOTAL
	FROM  %Table:SC5% SC5
	JOIN %Table:SC6% SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL
	LEFT JOIN %Table:SC9% SC9 ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C5_CLIENTE = C9_CLIENTE AND C5_LOJACLI = C9_LOJA AND SC9.D_E_L_E_T_<>'*' AND C9_ITEM = C6_ITEM
	LEFT JOIN %Table:SA3% SA3 ON A3_COD=C5_VEND1  AND SA3.D_E_L_E_T_ LIKE ''
	JOIN %Table:SB1%  SB1 ON B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_ LIKE ''
	JOIN %Table:SE4% SE4 ON E4_CODIGO=C5_CONDPAG AND  SE4.D_E_L_E_T_ LIKE ''
	WHERE C5_NUM = %exp:cNumPed%  AND C5_CLIENTE = %exp:cClient%
	and C5_LOJACLI = %exp:cLojaCLi%
	ORDER BY 1,2 DESC
	EndSQL

	cQuery := GetLastQuery()
	//	CONOUT(cvaltochar(cQuery[2]`````))
	//		Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.)

	DbSelectArea(cNextAlias) // seleccionar area Area

	(cNextAlias)->( DbGoTop() )

	//	oPedido	 := Pedido():New()
	oPedido := JsonObject():new()
	oPedido['C5_NUM']		:=     "" // nuevo
	If (cNextAlias)->( !Eof() )
		While !(cNextAlias)->(Eof() )
			IF alltrim(oPedido['C5_NUM']) != alltrim((cNextAlias)->C5_NUM)
				oPedido := JsonObject():new()
				//alert("Entro")
				oPedido['C5_USRREG']	:= (cNextAlias)->C5_USRREG
				oPedido['C5_NUM']		:= (cNextAlias)->C5_NUM
				oPedido['C5_CLIENTE']	:= (cNextAlias)->C5_CLIENTE
				oPedido['C5_CONDPAG']	:= (cNextAlias)->C5_CONDPAG
				oPedido['C5_UTIPOEN']	:= (cNextAlias)->C5_UTIPOEN // tipo de entrega (nuevo)
				oPedido['C5_EMISSAO']	:= (cNextAlias)->C5_EMISSAO
				oPedido['C5_FILIAL']	:= (cNextAlias)->C5_FILIAL
				oPedido['C5_LOJACLI']	:= (cNextAlias)->C5_LOJACLI
				oPedido['C5_MOEDA']		:= (cNextAlias)->C5_MOEDA
				oPedido['C5_NOTA']		:= (cNextAlias)->C5_NOTA
				oPedido['C5_SERIE']		:= (cNextAlias)->C5_SERIE
				oPedido['C5_UNITCLI']	:= (cNextAlias)->C5_UNITCLI
				oPedido['C5_DOCGER']	:= (cNextAlias)->C5_DOCGER // agregando documento a generar 14/04/2020
				oPedido['C5_UOBSERV']	:= (cNextAlias)->C5_UOBSERV // agregando observaciÛn Nahim 04/02/2020
				oPedido['C5_UNOMCLI']	:= AllTrim((cNextAlias)->C5_UNOMCLI)
				oPedido['C5_VEND1']		:= (cNextAlias)->C5_VEND1
				oPedido['C5_LOJACLI']	:= (cNextAlias)->C5_LOJACLI
				oPedido['A3_NOME']		:= AllTrim((cNextAlias)->A3_NOME)
				oPedido['F2_EMISSAO']	:=  ""

				//Electronic Invoice
				oPedido['C5_CODMPAG']	:= ALLTRIM((cNextAlias)->C5_CODMPAG)
				oPedido['C5_XCLDOCI']	:= ALLTRIM((cNextAlias)->C5_XCLDOCI)
				oPedido['C5_XTIPDOC']	:= ALLTRIM((cNextAlias)->C5_XTIPDOC)
				oPedido['C5_XEMAIL']	:= ALLTRIM((cNextAlias)->C5_XEMAIL)
				oPedido['C5_NUMTARG']	:= ALLTRIM((cNextAlias)->C5_NUMTARG)
				oPedido['F2_NUMAUT']	:=  ""

				// Nahim Gestionando el color
				if !empty((cNextAlias)->COLOR) // caso que tenga color
					if (alltrim((cNextAlias)->C5_COLOR)) == '#ebeb5f' // sÛlo si es amarillo
						oPedido['C5_COLOR']   := alltrim((cNextAlias)->COLOR)
					else
						oPedido['C5_COLOR']   := alltrim((cNextAlias)->C5_COLOR)
					endif
				else
					oPedido['C5_COLOR']   := alltrim((cNextAlias)->C5_COLOR)
				endif
			ENDIF
			/*objProducto := ProductoItem():new()
			objProducto:setB1_COD((cNextAlias)->C6_PRODUTO)
			objProducto:setB1_DESC((cNextAlias)->B1_DESC)
			objProducto:setB1_PRV1((cNextAlias)->C6_PRUNIT)
			objProducto:setB1_UM((cNextAlias)->C6_UM)
			objProducto:setCodPed((cNextAlias)->C5_NUM)
			objProducto:setC6_FILIAL((cNextAlias)->C6_FILIAL)
			objProducto:setC6_QTDVEN((cNextAlias)->C6_QTDVEN)
			objProducto:setC6_ITEM((cNextAlias)->C6_ITEM)
			objProducto:setC6_DESCONT((cNextAlias)->C6_DESCONT)
			cObs:= posicione("SC6",1, (cNextAlias)->C6_FILIAL + (cNextAlias)->C5_NUM + (cNextAlias)->C6_ITEM + (cNextAlias)->C6_PRODUTO, "SC6->C6_VDOBS")	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			objProducto:setC6_VDOBS( Trim(cObs))
			*/

	objProducto := JsonObject():new()
	objProducto['B1_COD']	   := (cNextAlias)->C6_PRODUTO
	objProducto['B1_DESC'] 	   := (cNextAlias)->B1_DESC
	objProducto['B1_PRV1']     := (cNextAlias)->C6_PRUNIT
	objProducto['B1_UM']      := (cNextAlias)->C6_UM

	objProducto['C6_PRCVEN']     := (cNextAlias)->C6_PRCVEN // FINAL 02/04/2020
	objProducto['C6_DESCONT']  := (cNextAlias)->C6_VALDESC // Nahim cambiando por valdes 02/04/2020
	//			objProducto['C6_DESCONT']  := (cNextAlias)->C6_DESCONT
	objProducto['C6_FILIAL']   := (cNextAlias)->C6_FILIAL
	objProducto['C6_ITEM']     := (cNextAlias)->C6_ITEM
	objProducto['C6_LOCAL']    := (cNextAlias)->C6_LOCAL
	objProducto['C6_QTDVEN']   := (cNextAlias)->C6_QTDVEN
	objProducto['C6_TES']   := (cNextAlias)->C6_TES
	objProducto['C6_UTPLIQ']	:= (cNextAlias)->C6_UTPLIQ// descuento justificaciÛn Nahim 07/06/2020
	objProducto['PEDVEN']   := alltrim((cNextAlias)->C5_NUM)
	AADD(aProds,objProducto)

	//oPedido:SetProd(objProducto)

	(cNextAlias)->( DbSkip() )
	IF (alltrim(oPedido['C5_NUM']) != alltrim((cNextAlias)->C5_NUM)) .or. (cNextAlias)->(Eof()) // caso estÈ cambiando de pedido vamos a v
		oPedido['APROD'] := aProds
		aProds := {}
		aadd(aPedidos,oPedido)
	ENDIF
EndDo

//		for i := 1 to len(aProds)
//
//			cProdPed := aProds[i]:getCodPed()
//			cProdFil := aProds[i]:getC6_FILIAL()
//
//			for j := 1 to len(aPedidos)
//
//				if aPedidos[j]:getNum() == cProdPed .and. aPedidos[j]:getFilial() == cProdFil
//					aPedidos[j]:SetProd(aProds[i])
//				endif
//			next
//
//		next

cResponse:= '{'
cResponse+= '"status" : "success",'
cResponse+= '"data" : '
cJson := FWJsonSerialize(aPedidos,.T.,.T.)
cResponse+= cJson
cResponse+= '}'

cJson := EncodeUtf8(cResponse)

Else
	cResponse:= '{'
	cResponse+= '"status" : "fail",'
	cResponse+= '"message" : "Buscando pedido ' + cNumPed + '"'
	cResponse+= '}'

	cJson := EncodeUtf8(cResponse)
EndIf
RestArea(aArea)
Return(cJson)

Static Function bscCodVen(cCodUsr) // trae codigo de vendedor
	Local cQryAux := ""
	Local cRet := ""
	Local aRet := {}

	cQryAux := ""
	cQryAux += " SELECT A3_FILIAL, A3_COD FROM " + RetSqlName("SA3") + " SA3 WHERE D_E_L_E_T_ = ' ' AND A3_CODUSR LIKE '%" + AllTrim(cCodUsr) + "%' "

	cQryAux := ChangeQuery(cQryAux)

	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal

	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		cRet := QRY_AUX->(A3_COD)
		aRet := {}
		AADD(aRet, cRet)
		AADD(aRet, QRY_AUX->(A3_FILIAL))
		AADD(aRet, .T.)

		QRY_AUX->(dbSkip())
	EndDo
	QRY_AUX->(dbCloseArea())
	if Empty(aRet)
		AADD(aRet, .F.)
	endif

Return aRet
