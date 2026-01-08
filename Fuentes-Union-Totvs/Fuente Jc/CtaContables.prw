#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ Cta Contables ³ Autor ³ Juan Carlos Campos³ Data ³ 21/03/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service para obtener presupuesto para compras           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Union Agronegocios                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSRESTFUL CCUENTAS DESCRIPTION "Cuenta Contables"

	
	WSMETHOD GET  DESCRIPTION "Obtiene Cuenta Contables " WSSYNTAX " CCUENTAS""

END WSRESTFUL

WSMETHOD GET  WSRECEIVE cClient,cStore WSSERVICE CCUENTAS
	Local aArea 	 := GetArea()
	Local lRet := .T.
	
	::SetContentType("application/json")

	

	OrdenConsul	:= GetNextAlias()
	BeginSql Alias OrdenConsul
		SELECT
			NOMBRE_CUENTA,
			CUENTA,
			N_UNICO,
			C_UNICO,
			SUM(PRESUP) PRESUP,
			SUM(EJECUTADO) EJECUTADO,
			SUM(DIFER) DIFER
		FROM
			UC_VIEW_CTRPRE_2016_BS_GRAL
		WHERE
			ANIO = '2023'
			AND MES = '2'
			AND C_UNICO = '451104'
			AND CUENTA IN (
				'51106008',
				'51106001',
				'51106009',
				'51106010',
				'51106002',
				'51106004',
				'51106006',
				'51106007',
				'51106005',
				'51106003'
			)
		GROUP BY
			NOMBRE_CUENTA,
			CUENTA,
			N_UNICO,
			C_UNICO
	EndSql

	DbSelectArea(OrdenConsul)
	aObjCtasPC := {}
	If (OrdenConsul)->(!Eof())
		While !(OrdenConsul)->(Eof())
			objCtaPC := JsonObject():new()
			objCtaPC['NOMBRE_CUENTA']  	:= Alltrim((OrdenConsul)->NOMBRE_CUENTA)
			objCtaPC['CUENTA,']  	:= AllTrim((OrdenConsul)->CUENTA)
			objCtaPC['N_UNICO']  	:= AllTrim((OrdenConsul)->N_UNICO)
			objCtaPC['N_UNICO']  	:= AllTrim((OrdenConsul)->N_UNICO)
			objCtaPC['PRESUP']  	:= (OrdenConsul)->PRESUP
			objCtaPC['EJECUTADO']  	:= (OrdenConsul)->EJECUTADO
			objCtaPC['DIFER']  	:= (OrdenConsul)->DIFER
			AADD(aObjCtasPC,objCtaPC)
			(OrdenConsul)->(dbSkip())
		EndDo // hasta el final


		cJson:= FWJsonSerialize(aObjCtasPC,.T.,.T.)
		cResponse= cJson

		::SetResponse(cResponse)
	else
		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "Vacio"'
		cResponse+= '}'
		::SetResponse(cResponse)

		//lRet := .F.
	endif


	RestArea(aArea)

Return lRet
