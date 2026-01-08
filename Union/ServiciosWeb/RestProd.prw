#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"

WSRESTFUL producto DESCRIPTION "Obtener Producto"

WSDATA count      AS INTEGER
WSDATA startIndex AS INTEGER

WSMETHOD GET DESCRIPTION "Obtiene productos" WSSYNTAX "/producto"

END WSRESTFUL

WSMETHOD GET WSRECEIVE startIndex, count WSSERVICE producto
	Local i
	LOCAL aProds := {}
	local objProducto

	::SetContentType("application/json")

	OrdenConsul	:= GetNextAlias()
	cValorP := SuperGetMv('MV_UCONSTP',.f.,"")
		cValorP :=  trim(cValorP)
		cValorP :=	"%" + cValorP + "%"
	if !empty(cValorP)
		BeginSql Alias OrdenConsul

			select B1_COD, B1_DESC, B1_UM, B1_PRV1, B2_LOCAL,(B2_QATU - B2_QPEDVEN - B2_RESERVA) B2_QATU, B2_FILIAL, B1_UFABRIC from %Table:SB1% SB1
			JOIN %Table:SB2% SB2 on
			B1_COD = B2_COD AND B2_FILIAL = %exp:xfilial("SB2")%
			Where SB1.D_E_L_E_T_ =' ' AND SB2.D_E_L_E_T_ = ' '
			AND B1_TIPO in ( %exp:cValorP% ) and B1_MSBLQL not in ('1')
		EndSql
	else
		BeginSql Alias OrdenConsul

			select B1_COD, B1_DESC, B1_UM, B1_PRV1, B2_LOCAL,(B2_QATU - B2_QPEDVEN - B2_RESERVA) B2_QATU, B2_FILIAL,B1_UFABRIC from %Table:SB1% SB1
			JOIN %Table:SB2% SB2 on
			B1_COD = B2_COD AND B2_FILIAL = %exp:xfilial("SB2")%
			Where SB1.D_E_L_E_T_ =' ' AND SB2.D_E_L_E_T_ = ' '
			and B1_MSBLQL not in ('1')
		EndSql
	endif

	//     	AND B1_FILIAL = B2_FILIAL
	DbSelectArea(OrdenConsul) // seleccionar area Area

	While !(OrdenConsul)->(Eof())
	
	
		objProducto := JsonObject():new()
		objProducto['B1_COD']	:= (OrdenConsul)->B1_COD
		objProducto['B1_DESC']	:= (OrdenConsul)->B1_DESC
		objProducto['B1_PRV1']	:= (OrdenConsul)->B1_PRV1
		objProducto['B1_UM']	:= (OrdenConsul)->B1_UM
		objProducto['B2_LOCAL']	:= (OrdenConsul)->B2_LOCAL
		objProducto['B2_QATU']	:= (OrdenConsul)->B2_QATU
		objProducto['B2_FILIAL']	:= (OrdenConsul)->B2_FILIAL
		objProducto['B1_UFABRIC']	:= (OrdenConsul)->B1_UFABRIC
		
//		objProducto:setB1_COD((OrdenConsul)->B1_COD)
//		objProducto:setB1_DESC((OrdenConsul)->B1_DESC)
//		objProducto:setB1_PRV1((OrdenConsul)->B1_PRV1)
//		objProducto:setB1_UM((OrdenConsul)->B1_UM)
//		objProducto:setLocal((OrdenConsul)->B2_LOCAL)
//		objProducto:setQactu((OrdenConsul)->B2_QATU)
//        "B1_COD": "BAB 8X38.5X45 CI P35X65-4     ",
//        "B1_DESC": "BOLSA ALTA BELEN 8X38.5X45 CI P/35X65   ",
//        "B1_PRV1": 0,
//        "B1_UM": "BU",
//        "B2_LOCAL": "31",
//        "B2_QATU": 6,
		aadd(aProds,objProducto)

		(OrdenConsul)->(dbSkip())
	END

	cJson := FWJsonSerialize(aProds,.T.,.T.)

	cJson := EncodeUtf8(cJson)

	::SetResponse(cJson)

Return .T.
