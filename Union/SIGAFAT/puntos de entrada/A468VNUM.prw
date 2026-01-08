#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³A468VNUM  ºAuthor ³Erick Etcheverry	   Date ³  02/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida la serie al generar facturas						  º±±
±±º        		 	 		  	 	 	 	 	 	 	  		  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB  UNION                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function A468VNUM()
	Local aNotas := PARAMIXB[3]   /// valores pos 13 y 19
	Local aFats := PARAMIXB[4]
	Local lRet := PARAMIXB[2] //  Nahim Terrazas 25/05/2020
	local aNumeros := PARAMIXB[1] // Nahim obteniendo los nros que deberían ser los últimos correlativos.
	Local aAreaSFP := GetArea()
	Local cNextAlias := GetNextAlias() // NTP Alias del query
	Local lManual := .t.    ////serie manual no valida

	IF FUNNAME() $ "MATA461" .OR. FUNNAME() $ "MATA468N"

		if len(aFats) > 0
			for i:= 1 to len(aFats)

				if LPEDIDOS ///si esta generando desde pedido
					nMoeda := GETADVFVAL("SC5","C5_MOEDA",XFILIAL("SC5")+anotas[1][15][1],1,"")//PEDIDO
					nMTXa := GETADVFVAL("SC5","C5_TXMOEDA",XFILIAL("SC5")+anotas[1][15][1],1,"")//PEDIDO

					nValBrut := iif(nMoeda == 2,ROUND(xMoeda(aFats[i][10],2,1, ,4,nMTXa,1),2),aFats[i][10])

					cUnitCli:= GETADVFVAL("SC5","C5_UNITCLI",XFILIAL("SC5")+anotas[1][15][1],1,"")//pedido
					cUnomcli:= GETADVFVAL("SC5","C5_UNOMCLI",XFILIAL("SC5")+anotas[1][15][1],1,"")//pedido

					if nValBrut >= 3000 .and. !empty(ALLTRIM(cUnomcli)) .and. len(ALLTRIM(cUnitCli)) <=4
						MSGINFO("Esta por emitir una factura igual o mayor a Bs. 3.000!! Por favor, revisar el nombre y nit del cliente." , "AVISO:"  )
						lRet = .f.
					endif
				else
					nMoeda := GETADVFVAL("SF2","F2_MOEDA",XFILIAL("SF2")+aFats[i][3]+aFats[i][4]+aFats[i][7]+SD2->D2_SERIE+"N"+"RFN",2,"")//PEDIDO F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE
					nMTXa := GETADVFVAL("SF2","F2_TXMOEDA",XFILIAL("SF2")+aFats[i][3]+aFats[i][4]+aFats[i][7]+SD2->D2_SERIE+"N"+"RFN",2,"")

					nValBrut := iif(nMoeda == 2,ROUND(xMoeda(aFats[i][10],2,1, ,4,nMTXa ,1),2),aFats[i][10])//valbrut

					cNitCli:= GETADVFVAL("SC5","C5_UNITCLI",XFILIAL("SC5")+anotas[1][15][1],1,"0")//pedido
					cNomcli:= GETADVFVAL("SC5","C5_UNOMCLI",XFILIAL("SC5")+anotas[1][15][1],1,"0")//pedido

					/*cNitCli :=  GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+aFats[i][3]+aFats[i][4],1,"0")
					cNomcli :=  GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+aFats[i][3]+aFats[i][4],1,"0")*/

					if nValBrut >= 3000 .and. !empty(ALLTRIM(cNomcli)) .and. len(ALLTRIM(cNitCli)) <=4
						MSGINFO("Esta por emitir una factura igual o mayor a Bs. 3.000!! Por favor, revisar el nombre y nit del cliente." , "AVISO:"  )
						lRet = .f.
					endif
				ENDif

			next i
		endif

		dbSelectArea( "SFP" )
		dbSetOrder( 5 )

		IF SFP->(dbSeek(xFilial("SF2") + xFilial("SFP")+ cSerie + "1",.T.))//ESPECIE FACTURA

			if ! SFP->FP_DTAVAL >= DDATABASE
				MSGALERT( "Fecha de validez de la serie vencida, use otra serie o ajuste la serie en libros fiscales", "ATENCION" )
				lRet = .f.
			endif

			if SFP->FP_LOTE == '1' .and. lRet
				//MSGALERT( "Fecha de validez de la serie vencida, use otra serie o ajuste la serie en libros fiscales", "ATENCION" )
				lManual = .f.
			endif

		ENDIF

		cFactu := aNumeros[1][2]

		if lManual

			BeginSQL Alias cNextAlias
				SELECT isnull(MAX(F3_NFISCAL),'') CORRELATIVO FROM %table:SF3%
				WHERE  F3_SERIE LIKE %exp:cSerie% AND D_E_L_E_T_ LIKE '*' AND F3_ESPECIE = 'NF'
				AND F3_NFISCAL = %exp:cFactu% AND F3_FILIAL = %exp:xFilial("SF3")%
			EndSQL

			DbSelectArea(cNextAlias) // seleccionar area Area
			(cNextAlias)->( DbGoTop() )
			if (cNextAlias)->( !Eof() )
				if !empty((cNextAlias)->CORRELATIVO)
					lRet := .t.
				else
					if aFats[1][3] $ '->'
						lRet := .t.
					else
						(cNextAlias)->(dbCloseArea())
						// Nahim validando que sea el último
						BeginSQL Alias cNextAlias

							SELECT MAX(F3_NFISCAL) CORRELATIVO FROM %table:SF3%
							WHERE  F3_SERIE LIKE %exp:cSerie% AND D_E_L_E_T_ LIKE '' AND F3_ESPECIE = 'NF'
							AND F3_FILIAL = %exp:xFilial("SF3")%

						EndSQL
						DbSelectArea(cNextAlias) // seleccionar area Area
						(cNextAlias)->( DbGoTop() )

						if (cNextAlias)->( !Eof() )// Caso tenga información.

							nCorrel := val((cNextAlias)->CORRELATIVO) + 1
							if nCorrel <> val(aNumeros[1][2])// no son iguales
								alert("Favor digitar primero la factura Nro. " + cvaltochar(nCorrel) ) // Favor realizar primero l
								lRet := .F.
							endif
						endif
					endif
				endif
			endif
			(cNextAlias)->(dbCloseArea())
		endif

	ENDIF

	RestArea(aAreaSFP)

return lRet
