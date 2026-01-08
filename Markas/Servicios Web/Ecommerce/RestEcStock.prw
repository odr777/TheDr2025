#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"
#include "fileio.ch"

WSRESTFUL STOCK DESCRIPTION "Serivcio rest de stock (ecommerce)"

	WSDATA productCode	AS String

	WSMETHOD GET DESCRIPTION "Obtiene el stock del producto enviado en el parámetro 'productCode'" WSSYNTAX "/ECOMMERCE/STOCK"

END WSRESTFUL

WSMETHOD GET WSRECEIVE productCode WSSERVICE STOCK
	Local lRet			:= .T.
	Local cResponse		:= ''
	Local cProductCode	:= ::productCode

	::SetContentType("application/json")

	if( !Empty(cProductCode) )//Sólo se realiza la petición cuando se recibe el parámetro 'productCode'
		cResponse:= getStock(cProductCode)
		if(!Empty(cResponse))//Ok
			::SetResponse(cResponse)
		else//Si no se encuentra el producto enviado en los parámetros
			lRet:= .F.
			SetRestFault(404,"Producto no localizado")
		endIf
	else
		lRet:= .F.
		SetRestFault(422, EncodeUtf8("No se ha enviado el código del producto"))
	endIf

Return lRet

/**
* @author: Denar Terrazas Parada
* @since: 30/08/2022
* @description: Función que obtiene el stock del producto informado en los parámetros
* @parameters: cProduct -> Product code (B1_COD)
*/
static function getStock(cProduct)
	Local aAreaB	:= getArea()
	Local cResponse	:= ''
	Local aObj		:= {}
	Local obj
	Local cCompany	:= FWCompany()
	Local cWhBranch	:= "% B2_FILIAL LIKE '" + cCompany + "%'%"//example: B2_FILIAL LIKE '01%'

	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU
		FROM %table:SB2%
		WHERE %notdel%
		AND B2_COD = %exp:cProduct%
		AND %exp:cWhBranch%

	EndSql

	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL
	//conout(cQuery[2])//   usar este en esste caso cuando es BEGIN SQL

	DbSelectArea(OrdenConsul) // seleccionar area Area

	If (OrdenConsul)->(!Eof())
		objSup := JsonObject():new() // objecto superior
		objSup['productCode'] := TRIM((OrdenConsul)->B2_COD)

		nGlobalQty:= 0

		While !(OrdenConsul)->(Eof())
			obj := JsonObject():new()

			obj['branch']		:= (OrdenConsul)->B2_FILIAL
			obj['warehouse']	:= (OrdenConsul)->B2_LOCAL
			obj['quantity']		:= (OrdenConsul)->B2_QATU

			nGlobalQty+= obj['quantity']

			AADD(aObj,obj)

			(OrdenConsul)->(dbSkip())
		EndDo

		objSup['globalQuantity']:= nGlobalQty
		objSup['detail']		:= aObj

		cMessage:= ''
		if(objSup['globalQuantity'] <= 0)
			cMessage:= 'No hay stock disponible'
		endIf
		objSup['message']:= cMessage

		cJson:= FWJsonSerialize(objSup,.T.,.T.)
		cResponse:= cJson
		cResponse:= EncodeUtf8(cResponse)
	endif

	restArea(aAreaB)

return cResponse
