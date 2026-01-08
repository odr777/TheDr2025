#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'RESTFUL.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#Include "Totvs.ch"

user function EnvNotif(cUsrTkn, cSucursal, cPedido)
	Local lRet := .F.
	Local cTknFB := ""
	Local aHeader := {}
	local cHeadRet:=""
	local oObjJson := nil
	Local cSup := alltrim(GETMV("MV_UTKNAPP"))
	
	cSup:="key=" + cSup
	
	cTknFB := AllTrim( GetNewPar("MV_UTKNAPP"  ,"") )
	url:= "https://fcm.googleapis.com/fcm/send"
	
	cJsonPed:= getPedido(cSucursal, cPedido)
	
	cBody := '{                                                       '
	cBody += '	"to" : "' + cUsrTkn + '",                             '
	cBody += '	"data" : {                                            '
	cBody += '		"body" : "Toca para ver",                         '
	cBody += '		"title" : "Nueva solicitud de compra",            '
	cBody += '		"content_available" : true,                       '
	cBody += '		"priority" : "high",                              '
	cBody += '		"data": {                                         '
	cBody += '			"pedido": 									  '
	cBody += cJsonPed
	cBody += '		}                                                 '
	cBody += '	}                                                     '
	cBody += '}                                                       '
	
	//aviso("",cBody,{'ok'},,,,,.t.)

	Aadd(aHeader, 'Content-Type: application/json')
	Aadd(aHeader, 'Authorization: '+ cSup)

	sPostRet := HttpPost(url,"",cBody,120,aHeader,@cHeadRet)
	//FWJsonDeserialize(sPostRet,@oObj)
	//if(sPostRet)

return

static function getPedido(cSucursal, cPedido)
	Local aArea 	 := GetArea()
	Local cResponse := ''
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario 
	OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
	
		SELECT C7_FILIAL, C7_NUM, C7_EMISSAO, C7_FORNECE, C7_ITEM, C7_PRODUTO, B1_DESC, C7_QUANT, C7_PRECO, C7_COND
		FROM %Table:SC7% SC7
		JOIN %Table:SB17% SB1 ON C7_PRODUTO = B1_COD
		WHERE SC7.%notdel%
		AND SB1.%notdel%
		AND C7_FILIAL = %exp:cSucursal%
		AND C7_NUM = %exp:cPedido%
	
	EndSql

	DbSelectArea(OrdenConsul)
	aObjPedidos := {}
	aItems := {}
	cNum:= ''
	If (OrdenConsul)->(!Eof())
		While !(OrdenConsul)->(Eof())

			cNum:= (OrdenConsul)->C7_NUM

			objCab := JsonObject():new()
			objCab['C7_FILIAL']  	:= (OrdenConsul)->C7_FILIAL
			objCab['C7_NUM']  		:= (OrdenConsul)->C7_NUM
			objCab['C7_FORNECE']  	:= (OrdenConsul)->C7_FORNECE
			objCab['C7_COND']  		:= (OrdenConsul)->C7_COND
			objCab['C7_EMISSAO']  	:= (OrdenConsul)->C7_EMISSAO
			objCab['USUARIO']		:= cNamUser
			objCab['USERCODE']		:= cCodUser
			while((OrdenConsul)->C7_NUM == cNum)
				objDet := JsonObject():new()
				objDet['C7_ITEM']  		:= (OrdenConsul)->C7_ITEM
				objDet['C7_PRODUTO']  	:= (OrdenConsul)->C7_PRODUTO
				objDet['C7_QUANT']  	:= (OrdenConsul)->C7_QUANT
				objDet['C7_PRECO']  	:= (OrdenConsul)->C7_PRECO
				objDet['B1_DESC']  		:= (OrdenConsul)->B1_DESC
				AADD(aItems,objDet)
				(OrdenConsul)->(dbSkip())
			enddo
			objCab['detalle'] 		:= aItems
			aItems := {}
			//AADD(aObjPedidos,objCab)
		EndDo

		cJson:= FWJsonSerialize(objCab,.T.,.T.)
		cResponse:= cJson
		
		//aviso("",cResponse,{'ok'},,,,,.t.)
		//cResponse := EncodeUtf8(cResponse)
	else
		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "SC7 Empty"'
		cResponse+= '}'
	endif
	RestArea(aArea)
return cResponse