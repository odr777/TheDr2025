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

user function xcobAuto()
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
	Local nMonto1 := 0
	Local nMonto2 := 0

	// nahim ID
	cTiempo := TIME()

	/*MONEDA PAGO*/
	cxMoeda := "01" //BS

	if nBcoMoed == 2
		cxMoeda = "2"
	endif

	/*MONEDA TITULO*/
	cxMoeTit := "01"

	nMonto1 = cvalorcob
	nMonto2 = 0

	if SF2->F2_MOEDA == 2
		cxMoeTit = "2"
		nMonto2 = cvalorcob
		nMonto1 = 0
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
	cBody +='	"MONEDA": '+ cxMoeTit + ', 		'
	cBody +='	"TIPOPAGO": "'+ cprefijo + '", 		'
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
	cBody +='	"MONTOM1": '+ CVALTOCHAR(nMonto1) + ','
	cBody +='	"NMULTA": '+ CVALTOCHAR(nxMulta) + ','
	cBody +='	"NDESCUENTO": '+ CVALTOCHAR(nxDescuento) + ','
	cBody +='	"MONTOM2": ' +CVALTOCHAR(nMonto2) + ''
	cBody +='		}									'
	cBody +='	],                                      '
	cBody +='	"ENVIROMENT":"'+ trim(UPPER(subst(GetEnvServer(),1,7)))+'",' // envía Nombre de ambiente 04/09/2020
	cBody +='	"PEDIDOS": [                            '
	cBody +='	]                                       '
	cBody +=' }                                         '

	cNumFatAut	:= "" // Nahim
	cDadosAdt	:= "" // Nahim
	aRecAdt		:= {} // Nahim

	oObj := nil

	FWJsonDeserialize(cbody,@oObj)

	Begin Transaction
		cRecBo :=  u_xxFina087a(cNumFatAut,cDadosAdt,aRecAdt,oObj) // ejecuta la cobranza
	End Transaction

return
