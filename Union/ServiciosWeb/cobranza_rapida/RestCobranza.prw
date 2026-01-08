#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#Include "TopConn.ch"
#INCLUDE "RESTFUL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ RESTCOBRO ³ Autor ³ POST Nahim Terrazas 16/05/2019			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service para Realizar cobro de una CXC 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Ejemplo de JSON
{
"BANCO":
{
"FILIAL" : "0101",
"CODIGO" : "CX1",
"AGENCIA" : "000001",
"CUENTA" : "00000000001"
},
"CLIENTE":"CL0003",
"USRCOD":"000000",
"NUMTAR":"4049420112151597",
"NOMBANCO":"BMSC",
"CLIENTE":"CL0003",
"TIENDA":"01",
"NUMCXC":
{
"FILIAL":"01",
"NUMERO":"000000000567",
"PREFIJO":"A  ",
"MONTO":123.42,
"MONEDA":"01",
"PARCELA":"01"
}
,
"TIPOPAGO":"CD"
}

"CH"
"EF"
"TF"
"CD"
"CC"

*/

WSRESTFUL Cobranza DESCRIPTION "Cobranza"
WSMETHOD POST  DESCRIPTION "Realiza la cobranza Y/O RA de una cuenta por cobrar" WSSYNTAX ""
END WSRESTFUL

WSMETHOD POST  WSSERVICE Cobranza
	Local lPost := .T.
	Local cBody
	local nI
	Private jRespuesta := JsonObject():new() // objeto Json con informacion de respuesta
	private cValBody
	private oObj // cambiando para private para que pueda validar
	::SetContentType("application/json")
	cBody := Self:GetContent()
	FWJsonDeserialize(cBody,@oObj)

	//	oObj:productos[nX]:C6_PRODUTO
	// posicionarme en la SF2
	cNumFatAut	:= "" // Nahim
	cDadosAdt	:= "" // Nahim
	aRecAdt		:= {} // Nahim
	cValBody := oObj
	conout(cBody)
	if type("cValBody:ENVIROMENT") <> "U" // verifica ambiente para no realizar choques del mismo
		if !oObj:ENVIROMENT $ SUBSTR(UPPER(GetEnvServer()),1,7) // MP12PRD == MP12PRD
			cResponse:= '{'
			cResponse+= '"status" : "fail",'
			cResponse+= '"data" : {'
			cResponse += '"message" : " Ambiente de la petición: ' + oObj:ENVIROMENT +' Ambiente solicitado: ' +UPPER(GetEnvServer()) + "'"
			cResponse+= '}'
			//			cResponse += '"nroRecibo" : "' + jRespuesta['nroRecibo'] +'",'
			//			cResponse += '"tipoPago" : "' + jRespuesta['tipoPago'] +'"'
			cResponse += '}'
			cResponse := EncodeUtf8(cResponse)
			SetRestFault(400,cResponse)
			::SetResponse(cResponse)
			return lPost
		endif
	endif
	if type("oObj:FECHA") <> "U"
		conout("oObj:FECHA")
		cDataFact:= oObj:FECHA
		dDataFact := CTOD(cDataFact)
		ddatabase := dDataFact
	endif
	if type("oObj:DDATABASE") <> "U"
		conout("oObj:DDATABASE")
		cDataFact:= oObj:DDATABASE
		dDataFact := CTOD(cDataFact)
		ddatabase := dDataFact
	endif
	if empty(alltrim(oObj:SERIE)) // Nahim validación Serie es necesaria 
		Conout('Sin Serie')
		SetRestFault(400,"La Serie no puede estar vacia")
		return .F.
	endif

	if type("cValBody:IDAPP") <> "U" // nahim validando si existe cobranzas con ID de la App //
		DbSelectArea("SEL")
		SEL->(dBSetOrder(14))
		IF SEL->(DbSeek(xFilial("SEL")+ Padr(cvaltochar(oObj:IDAPP),TamSX3("EL_UIDAPPM")[1]))) // valido si está en la base de datos y devuelvo el recibo
			// mostrnaod r
			/*If !dbRLock() // verifica si está liberado
				Conout('SEL BLOQUEADO')
				cResponse:= '{'
				cResponse+= '"status" : "Fail",'
				cResponse+= '"data" : {'
				cResponse += '"message" : "Error interno de la transacción" '
				SetRestFault(500,cResponse)
			else*/
				cRecBo := SEL->EL_RECIBO
				cResponse:= '{'
				cResponse+= '"status" : "success",'
				cResponse+= '"data" : {'
				cResponse += '"recibo" : "' + cRecBo + '", '
				cResponse += '"serie" : "' + oObj:SERIE +'", '
				cResponse += '"encontrado" : "SI" '
			//ENDIF
			//			cResponse += '"nroRecibo" : "' + jRespuesta['nroRecibo'] +'",'
			//			cResponse += '"tipoPago" : "' + jRespuesta['tipoPago'] +'"'
			cResponse+= '}'
			cResponse += '}'
			cResponse := EncodeUtf8(cResponse)
			::SetResponse(cResponse)
			return lPost
		ENDIF
		SEL->(DBCLOSEAREA())
		// validar si existe el id en la SEL
	endif
	if type("cValBody:TOKEN") <> "U" // nahim validando si existe TOKEN EN LA COBRANZA//
		DbSelectArea("SEL")
		SEL->(dBSetOrder(14))
		IF SEL->(DbSeek(xFilial("SEL")+ Padr(cvaltochar(oObj:TOKEN),TamSX3("EL_UIDAPPM")[1]))) // valido si está en la base de datos y devuelvo el recibo
			// mostrnaod r
			cRecBo := SEL->EL_RECIBO
			cResponse:= '{'
			cResponse+= '"status" : "success",'
			cResponse+= '"data" : {'
			cResponse += '"recibo" : "' + cRecBo + '", '
			cResponse += '"serie" : "' + oObj:SERIE +'", '
			cResponse += '"encontrado" : "SI" '
			//			cResponse += '"nroRecibo" : "' + jRespuesta['nroRecibo'] +'",'
			//			cResponse += '"tipoPago" : "' + jRespuesta['tipoPago'] +'"'
			cResponse+= '}'
			cResponse += '}'
			cResponse := EncodeUtf8(cResponse)
			::SetResponse(cResponse)
			return lPost
		ENDIF
		SEL->(DBCLOSEAREA())
		// validar si existe el id en la SEL
	endif
	ntrans := cvaltochar(Randomize(1,34000))
	Conout("COMIENZA TRANSACTION "  +cvaltochar(ntrans) +  " - " + oObj:SERIE)
	Begin Transaction
		cRecBo :=  u_xFina087a(cNumFatAut,cDadosAdt,aRecAdt,oObj) // ejecuta la cobranza
	End Transaction

	aPedidos := oObj:PEDIDOS

	For nI:= 1 to Len(aPedidos)
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(FWxFilial('SC5') + aPedidos[nI] )
		RecLock("SC5",.F.)
		Replace 	C5_USTATUS      With "1"
		Replace 	C5_USERIE      With oObj:SERIE
		Replace 	C5_URECIBO      With cRecBo
		MsUnlock()
	Next nI
	//	cResponse := ReaCobro(oObj)
	Conout( cvaltochar(ntrans) +  " - ENVIANDO RECIBO "+ cRecBo + " - " + oObj:SERIE )
	// verificando si el recibo fue grabado con éxito:
	//	POSICIONE("SEL",1,XFILIAL("SEL")+SB9->B9_COD,"B1_DESC")

	// validación adicional para obtener el registro que corresponde Nahim 09/07/2020
	DbSelectArea("SEL")
	SEL->(dBSetOrder(14))
	if SEL->(DbSeek(xFilial("SEL")+ Padr(cvaltochar(oObj:IDAPP),TamSX3("EL_UIDAPPM")[1]))) // validación que transacción exista
		cResponse:= '{'
		cResponse+= '"status" : "success",'
		cResponse+= '"data" : {'
		cResponse += '"recibo" : "' + SEL->EL_RECIBO + '", '
		cResponse += '"serie" : "' + SEL->EL_SERIE +'" '
		cResponse+= '}'
		cResponse += '}'
		cResponse := EncodeUtf8(cResponse)
	else
		cResponse:= '{'
		cResponse+= '"status" : "Fail",'
		cResponse+= '"data" : {'
		cResponse += '"message" : "Error interno de la transacción" '
		cResponse+= '}'
		cResponse += '}'
		SetRestFault(500,cResponse)
	endif
	Conout(cvaltochar(ntrans) +  " TERMINA END TRANSACTION - "+ cRecBo + " - " + oObj:SERIE)
	::SetResponse(cResponse)
return lPost

// Realiza el cobro
