#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.CH"
#include 'parmtype.ch'

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ cobAutom    ¦ Autor ¦ Nahim Terrazas				09.12.19  ¦¦¦
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

	// nahim ID
	cTiempo := TIME()

	cxMoeda := "01"

	if nBcoMoed == 2
		cxMoeda = "2"
	endif

	/*MONEDA TITULO*/
	cxMoeTit := "01"

	if SF2->F2_MOEDA == 2
		cxMoeTit = "2"
	endif

	cIdApp := "VR"// Nahim 03/12/2019
	cIdApp += SUBSTR(cTiempo, 1, 2)              // Resulta: 10
	cIdApp += SUBSTR(cTiempo, 4, 2)              // Resulta: 37
	cIdApp += SUBSTR(cTiempo, 7, 2)              // Resulta: 17
	cIdApp += SUBSTR(cTiempo, 7, 2) +  cvaltochar(Randomize(1,34000))

	cBody :='{'
	cBody +='   "CLIENTE": "'+ SF2->F2_CLIENTE + '",'
	cBody +='   "IDAPP": "'+ cIdApp + '",'
	//			cBody +='	"TIENDA":"01",                          ' // PONER al final
	cBody +='	"DDATABASE":"'+DTOC(DDATABASE)+'", ' // adicionando fecha de compensación del título Nahim 27/03/2020
	cBody +='	"TIENDA":"'+ SF2->F2_LOJA + '",' // PONER al final
	cBody +='	"SERIE":"'+ cSerie + '",'    //////SERIE CAMBIAR
	cBody +='	"COBRADOR":"' + cCobrador +'",       '
	cBody +='	"PAGOS": [                              '
	cBody +='		   			{                       '
	cBody +='	"CODIGO": "'+ cbanco + '", 		'
	cBody +='	"AGENCIA": "'+ cagenban + '",		'
	cBody +='	"CUENTA": "'+ ccuentaBan + '", 		'
	cBody +='	"MONEDA": '+ cxMoeda + ', 		'
	cBody +='	"TIPOPAGO": "EF", 	'
	cBody +='	"VALOR": ' +CVALTOCHAR(cvalorcob) + ''
	cBody +='		}									'
	cBody +='	]	                                    '
	cBody +='	,                                       '
	cBody +='	"BAJAS": [                              '
	// objeto de título por pagar
	cBody +='		   			{                       '
	cBody +='	"FILIAL": "'+ xfilial("SF2") + '", 		'
	cBody +='	"PREFIJO": "'+ SF2->F2_SERIE + '",		'
	cBody +='	"NUMERO": "'+ SF2->F2_DOC + '", 		'
	cBody +='	"CUOTA": "  ",                  		' // no tiene cuotas porque es al contado.
	cBody +='	"MONEDA": '+ cxMoeTit + ', 		'
	cBody +='	"MONTOM1": 0,'
	cBody +='	"NMULTA": '+ CVALTOCHAR(nxMulta) + ','
	cBody +='	"NDESCUENTO": '+ CVALTOCHAR(nxDescuento) + ','
	cBody +='	"MONTOM2": ' +CVALTOCHAR(cvalorcob) + ''
	cBody +='		}									'
	cBody +='	],                                      '
	cBody +='	"ENVIROMENT":"'+ trim(UPPER(subst(GetEnvServer(),1,7)))+'",' // envía Nombre de ambiente 04/09/2020
	cBody +='	"PEDIDOS": [                            '
	cBody +='	]                                       '
	cBody +=' }                                         '

	//	aviso("",cBody,{'ok'},,,,,.t.)
	oObj := nil
	cCompenJson := U_postcobr(cbody)
	FWJsonDeserialize(cCompenJson,@oObj)
	if Type("oObj:data") <> "U" //
		retorno := {oObj:data:recibo,oObj:data:serie}
	else
		oObj := nil // intenta compensar el título por segunda vez
		cCompenJson := U_postcobr(cbody)
		FWJsonDeserialize(cCompenJson,@oObj)
		if Type("oObj:data") <> "U" //
			retorno := {oObj:data:recibo,oObj:data:serie}
		else
			ALERT("No se pudo compensar el título: " +  SF2->F2_DOC + " Favor informar al dep. Sistema") //  + Chr(13) + Chr(10)
			MemoWrite("error" + SF2->F2_DOC + ".LOG",cCompenJson) // guardando logs de usuario
		endif
	endif

return
