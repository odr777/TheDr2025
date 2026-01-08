#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.CH"
#include 'parmtype.ch'

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CHECBOX    ¦ Autor ¦ Nahim Terrazas				09.12.19  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Baja Automática de títulos en facturación	 . 			  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

user function cobAutom()
	private retorno := ""
	MsgRun ("Cobrando", "Por favor espere", {|| compensa(@retorno) } )
return
/*
static function Llamacompensa()

close(oDlgTela)

return
*/
static function compensa(retorno)
	// las compensaciones son todas al contado

	/*
	aCols[1][AScan(aCposSEL,"EL_BANCO")] := aBancoXUs[1] //
	aCols[1][AScan(aCposSEL,"EL_AGENCIA")] := aBancoXUs[2] //
	aCols[1][AScan(aCposSEL,"EL_CONTA")] := aBancoXUs[3] //
	aCols[1][AScan(aCposSEL,"EL_MOEDA")] := cvaltochar(aBancoXUs[4]) // aaumentando moneda
	*/

	// nahim ID
	cTiempo := TIME()
	//	cIdApp := ""// EL_UIDAPPM
	cIdApp := "VR"// Nahim 03/12/2019
	cIdApp += SUBSTR(cTiempo, 1, 2)              // Resulta: 10
	cIdApp += SUBSTR(cTiempo, 4, 2)              // Resulta: 37
	cIdApp += SUBSTR(cTiempo, 7, 2)              // Resulta: 17
	cIdApp += SUBSTR(cTiempo, 7, 2) +  cvaltochar(Randomize(1,34000))
	aCobra := u_obteCobr(RetCodUsr()) // u_obteCobr(RetCodUsr())
	aBancoXUs := u_obtBanc(RetCodUsr())
	if empty(aBancoXUs) // Si es que no encuentra el cobrador
		// favor rellenar sq
//		alert("Favor digitar la información en la Caja Bancaria del cajero (SA6)")
		return
	endif
	cMoeda :=  cvaltochar(aBancoXUs[4]) // moneda en b
	// validando si todo está OK:

	if empty(aCobra) // Si es que no encuentra el cobrador
		// favor rellenar sq
		alert("Favor digitar la información del cobrador (SAQ)")
		return
	endif

	cBody :='{'
	cBody +='   "CLIENTE": "'+ SC5->C5_CLIENTE + '",'
	cBody +='   "IDAPP": "'+ cIdApp + '",'
	//			cBody +='	"TIENDA":"01",                          ' // PONER al final
	cBody +='	"DDATABASE":"'+DTOC(DDATABASE)+'", ' // adicionando fecha de compensación del título Nahim 27/03/2020
	cBody +='	"TIENDA":"'+ SC5->C5_LOJACLI + '",' // PONER al final
	cBody +='	"SERIE":"'+ aCobra[3] + '",'
	cBody +='	"COBRADOR":"' + aCobra[1] +'",       '
	cBody +='	"PAGOS": [                              '
	cBody +='		   			{                       '
	cBody +='	"CODIGO": "'+ aBancoXUs[1] + '", 		'
	cBody +='	"AGENCIA": "'+ aBancoXUs[2] + '",		'
	cBody +='	"CUENTA": "'+ aBancoXUs[3] + '", 		'
	cBody +='	"MONEDA": '+ cMoeda + ', 		'
	cBody +='	"TIPOPAGO": "EF", 	'
	cBody +='	"VALOR": ' +CVALTOCHAR(_nValFac) + ''
	cBody +='		}									'
	cBody +='	]	                                    '
	cBody +='	,                                       '
	cBody +='	"BAJAS": [                              '
	// objeto de título por pagar
	cBody +='		   			{                       '
	cBody +='	"FILIAL": "'+ xfilial("SC5") + '", 		'
	cBody +='	"PREFIJO": "'+ SC5->C5_SERIE + '",		'
	cBody +='	"NUMERO": "'+ SC5->C5_NOTA + '", 		'
	cBody +='	"CUOTA": "  ",                  		' // no tiene cuotas porque es al contado.
	cBody +='	"MONTOM1": 0,'
	cBody +='	"MONTOM2": ' +CVALTOCHAR(_nValFac) + ''
	cBody +='		}									'
	cBody +='	],                                      '
	cBody +='	"ENVIROMENT":"'+ trim(UPPER(subst(GetEnvServer(),1,7)))+'",' // envía Nombre de ambiente 04/09/2020
	cBody +='	"PEDIDOS": [                            '
	cBody +='	]                                       '
	cBody +=' }                                         '

	//	aviso("",cBody,{'ok'},,,,,.t.)
	oObj := nil
	//	postcobr
	//	cCompenJson := U_postcobr(cbody)
	oObj := nil
	cCompenJson := U_postcobr(cbody)
	FWJsonDeserialize(cCompenJson,@oObj)
	if Type("oObj:data") <> "U" //
		retorno := {oObj:data:recibo,oObj:data:serie}

		/*
		alert("Creado  " +  oObj:data:recibo +" - "+ oObj:data:serie )
		dbSelectArea("SX1")
		SX1->(DbSetOrder(1))

		SX1->(DbGoTop())
		If SX1->(DbSeek('RECIBOCOBR' + '01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := oObj:data:recibo
		SX1->(MsUnlock())
		End

		If SX1->(DbSeek('RECIBOCOBR' + '02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := oObj:data:recibo
		SX1->(MsUnlock())
		End

		If SX1->(DbSeek('RECIBOCOBR' + '03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := oObj:data:serie
		SX1->(MsUnlock())
		End

		If SX1->(DbSeek('RECIBOCOBR' + '04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  oObj:data:serie
		SX1->(MsUnlock())
		End
		U_RECIBOCOBR()
		*/

		//		cCompensaciones +="Se compensó el título: " +  oGetDados:aCols[nX,6]  + " - recibo: "  + oObj:data:recibo + Chr(13) + Chr(10)
	else
		oObj := nil // intenta compensar el título por segunda vez
		cCompenJson := U_postcobr(cbody)
		FWJsonDeserialize(cCompenJson,@oObj)
		if Type("oObj:data") <> "U" //
			retorno := {oObj:data:recibo,oObj:data:serie}
		else
			ALERT("No se pudo compensar el título: " +  SC5->C5_NOTA + " Favor informar al dep. Sistema") //  + Chr(13) + Chr(10)
			MemoWrite("error" + SC5->C5_NOTA + ".LOG",cCompenJson) // guardando logs de usuario
		endif
	endif

	/*
	cCompenJson := U_postcmp(cbody)
	FWJsonDeserialize(cCompenJson,@oObj)
	if Type("oObj:data") <> "U" //
	cCompensaciones +="Se compensó el título: " +  oGetDados:aCols[nX,6]  + " - recibo: "  + oObj:data:recibo + Chr(13) + Chr(10)
	else
	cCompensaciones +="No se pudo compensar el título: " +  oGetDados:aCols[nX,6]   + Chr(13) + Chr(10)
	endif
	*/
	//			if nX == 1  // primera compensación automática
	//				cPrimComp = oObj:data:recibo
	//			endif
	//			if nX == Len(oGetDados:aCols) // última compensación automática
	//				cUltimaCom = oObj:data:recibo
	//			endif
	// crea objeto para realizar la compensación
	//			alert(oGetDados:aCols[nX,2])
	//armar el objeto
	//			alert(oGetDados:aCols[nX,2])
	//			exit
	//	aviso("Se generaron las siguientes compensaciones",cCompensaciones,{'ok'},,,,,.t.)
	//	ALERT(cPrimComp)
	//	ALERT(cUltimaCom)
	//	alert("compensando..")
return
