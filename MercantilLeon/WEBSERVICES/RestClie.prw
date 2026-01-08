#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"

WSRESTFUL CLIENTES DESCRIPTION "Servicio maestro clientes"
	WSDATA RECEIVE As String //Json Recebido

	WSMETHOD POST 	DESCRIPTION "Cadastra um novo cliente" 		WSSYNTAX "/CLIENTES"
	WSMETHOD GET  	DESCRIPTION "Retorna lista de clientes" 	WSSYNTAX "/CLIENTES"
//WSMETHOD PUT  	DESCRIPTION "Altera cliente" 			WSSYNTAX "/CLIENTES || /CLIENTES/{CGC}"

END WSRESTFUL

WSMETHOD POST WSRECEIVE RECEIVE WSSERVICE CLIENTES

	Local cJSON        := Self:GetContent() //  string JSON

	Local oParseJSON := Nil

	Local aDadosCli   := {} //–> Array para ExecAuto  MATA030

	Local cFileLog   := ""

	Local cJsonRet   := ""

	Local cArqLog     := ""

	Local cErro       := ""

	Local cCodSA1     := ""

	Local lRet        := .T.

	Private lMsErroAuto := .F.

	Private lMsHelpAuto := .F.

	// –> Crea logs

	If !ExistDir("\log_cli")

		MakeDir("\log_cli")

	EndIf

	// –> Deserializa a string JSON

	FWJsonDeserialize(cJson, @oParseJSON)

	SA1->( DbSetOrder(3) )

	If !(SA1->( DbSeek( xFilial("SA1") + oParseJSON:Client:A1_CGC ) ))

		cCodSA1 := GetNewCod()

		Aadd(aDadosCli, {"A1_FILIAL"  , xFilial("SA1")  , Nil} )

		Aadd(aDadosCli, {"A1_COD"     , cCodSA1   , Nil} )

		Aadd(aDadosCli, {"A1_LOJA"    , "01"      , Nil} )

		Aadd(aDadosCli, {"A1_CGC"     , oParseJSON:Client:A1_CGC  , Nil} )

		Aadd(aDadosCli, {"A1_NOME"    , oParseJSON:Client:A1_NOME , Nil} )

		Aadd(aDadosCli, {"A1_NREDUZ"  , oParseJSON:Client:A1_NOME , Nil} )

		conout(oParseJSON:Client:A1_END)

		Aadd(aDadosCli, {"A1_END"     , oParseJSON:Client:A1_END ,Nil} )

		Aadd(aDadosCli, {"A1_PESSOA"  , Iif(Len(oParseJSON:Client:A1_CGC)== 11, "F", "J")          , Nil} )

		Aadd(aDadosCli, {"A1_TIPO" , "2"                       , Nil} )

		Aadd(aDadosCli, {"A1_EST"  , oParseJSON:Client:A1_EST , Nil} )

		Aadd(aDadosCli, {"A1_MUN"  , oParseJSON:Client:A1_MUN,Nil} )

		Aadd(aDadosCli, {"A1_TEL"  , oParseJSON:Client:A1_TEL, Nil} )

		Aadd(aDadosCli, {"A1_CONTA"  , oParseJSON:Client:A1_CONTA, Nil} )

		Aadd(aDadosCli, {"A1_UCTAANT"  , oParseJSON:Client:A1_UCTAANT, Nil} )

		MsExecAuto({|x,y| MATA030(x,y)}, aDadosCli, 3)

		If lMsErroAuto

			cArqLog := oParseJSON:Client:A1_CGC + " - " +SubStr(Time(),1,5 ) + ".log"

			RollBackSX8()

			cErro := MostraErro("\log_cli", cArqLog)

			cErro := TrataErro(cErro) // –> Trata error para devolver para o client

			SetRestFault(400, cErro)

			lRet := .F.

		Else // todo ok

			ConfirmSX8()

			cJSONRet := '{ "status" : " success ", "data" : {   "A1_COD" : "'+ A1_COD +'"  } }'

			/*
			{
			status : "success",
			data : { "post" : { "id" : 2, "title" : "Another blog post", "body" : "More content" }}
			}*/

			::SetResponse( cJSONRet )

		EndIf

	Else // caso cliente ya existe

		/*SetRestFault(400, "Cliente ya existe" + SA1->A1_COD + " - " + SA1->A1_LOJA)
		lRet := .F.*/
		
		cMsg:= "Ya existe el cliente " + SA1->A1_COD
		
		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : ' + '"' + cMsg + '"'
		cResponse+= '}'
		::SetResponse(cResponse)

	EndIf

Return(lRet)

WSMETHOD GET WSSERVICE CLIENTES
	Local aArea 	 := GetArea()
	Local cNextAlias := GetNextAlias()
	Local oCliente
	LOCAL aCliente := {}
	Local cJSON		 := ""
	Local lRet		 := .T.

	::SetContentType("application/json;charset=utf-8")

	BeginSQL Alias cNextAlias
		SELECT A1_COD, A1_LOJA, A1_NOME, A1_END, A1_CGC, A1_EST, A1_TEL,A1_MUN,A1_TABELA,A1_CONTA ,A1_COND ,A1_NREDUZ,A1_UNOMFAC
		FROM %table:SA1% SA1
		WHERE SA1.%notdel% and SA1.A1_MSBLQL not in ('1') AND A1_GRPVEN LIKE '000003'
	EndSQL

	DbSelectArea(cNextAlias) // seleccionar area Area

	(cNextAlias)->( DbGoTop() )

	If (cNextAlias)->( !Eof() )
		While !(cNextAlias)->(Eof() )
			objClie := JsonObject():new()
			objClie['A1_COD']			:= (cNextAlias)->A1_COD
			objClie['A1_LOJA']			:= (cNextAlias)->A1_LOJA
			objClie['A1_NOME']			:= AllTrim((cNextAlias)->A1_NOME)
			objClie['A1_END']			:= (cNextAlias)->A1_END
			objClie['A1_CGC']			:= (cNextAlias)->A1_CGC
			objClie['A1_EST']			:= (cNextAlias)->A1_EST
			objClie['A1_TEL']			:= (cNextAlias)->A1_TEL
			objClie['A1_MUN']			:= (cNextAlias)->A1_MUN
			objClie['A1_TAB']		:= (cNextAlias)->A1_TABELA
			objClie['A1_CONTA']			:= (cNextAlias)->A1_CONTA
			objClie['A1_COND']			:= (cNextAlias)->A1_COND
			objClie['A1_NREDUZ']			:= AllTrim((cNextAlias)->A1_NREDUZ)
			objClie['A1_UNOMFAC']			:= AllTrim((cNextAlias)->A1_UNOMFAC)


			/*
			oCliente	 := Client():New()
			oCliente:SetCodigo( AllTrim((cNextAlias)->A1_COD ))
			oCliente:SetLoja( 	AllTrim((cNextAlias)->A1_LOJA))
			oCliente:SetNome( 	AllTrim((cNextAlias)->A1_NOME))
			oCliente:SetCGC( 	AllTrim((cNextAlias)->A1_CGC ))
			oCliente:SetEnd( 	AllTrim((cNextAlias)->A1_END ))
			oCliente:SetEst( 	AllTrim((cNextAlias)->A1_EST ))
			oCliente:SetTel(	AllTrim((cNextAlias)->A1_TEL ))
			oCliente:SetMun(	AllTrim((cNextAlias)->A1_MUN ))
			oCliente:SetTab(	AllTrim((cNextAlias)->A1_TABELA ))
			oCliente:SetConta(	AllTrim((cNextAlias)->A1_CONTA ))
			oCliente:setCond( AllTrim((cNextAlias)->A1_COND ))
			oCliente:setNreduz( AllTrim((cNextAlias)->A1_NREDUZ ))
			*/
			aadd(aCliente,objClie)

			(cNextAlias)->( DbSkip() )

		EndDo

		cJson := FWJsonSerialize(aCliente,.T.,.T.)
//		cJson := FWJsonSerialize(aCliente,.T.,.T.)

		cJson := EncodeUtf8(cJson)

		::SetResponse(cJson)
		(cNextAlias)->( DbCloseArea() )
	Else
		SetRestFault(400, "SA1 Empty")
		lRet := .F.
	EndIf
	RestArea(aArea)

Return(lRet)

Static Function TrataErro(cErroAuto)
	Local nLines   := MLCount(cErroAuto)
	Local cNewErro := ""
	Local nErr	   := 0
	For nErr := 1 To nLines
		cNewErro += AllTrim( MemoLine( cErroAuto, , nErr ) ) + " - "
	Next nErr
Return(cNewErro)

Static Function GetNewCod()
	Local cCod  := GetSX8Num("SA1", "A1_COD")
	Local aArea := GetArea()
	SA1->( DbSetOrder(1) )
	While SA1->( DbSeek( xFilial("SA1") + cCod ) )
		cCod := GetSX8Num("SA1", "A1_COD")
	EndDo
	RestArea(aArea)
Return(cCod)
