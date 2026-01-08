#Include "Protheus.ch"
#Include "Parmtype.ch"

#DEFINE H_TOTALVL 	15
#DEFINE H_DESCVL 	18
#DEFINE H_VALORIG  	20
#DEFINE H_MULTAS    21

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA085DEFS   บ Autor ณ TdeP บ Fecha ณ  11/04/17               บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescripcion ณ Punto de Entrada que ejecuta al momento realizar la Ordenบฑฑ
ฑฑบ          ณ  de Pago - con la Opcion Pago Automatico                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณBIB                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER Function A085DEFS
Local cTipo := ParamIxb
Local nPos	:= 0

//	oChkBox:Disable() //Deshabilitar check de "Debitar cheque" //NT: No funcion๓
//	lBaixaChq:=.T. NAHIM TERRAZAS DESHABILITANDO DEBITACIำN AUTOMมTICA DE CHษQUE.

cNatureza:= GETNEWPAR('MV_UNATOP','PAGOS')

If cTipo == "2"	//a085aPagos
	/*
	Aviso("Array A085DEFS -aPagos"	,u_zArrToTxt(aPagos, .T.)	,{"Ok"},,,,,.T.)
	Aviso("Array A085DEFS -aSaldos"	,u_zArrToTxt(aSaldos, .T.)	,{"Ok"},,,,,.T.)
	*/
	nPos := oLbx:nAt
	
	If !(aPagos[1][15]<>aSaldos[Len(aSaldos)] .And. mv_par10==3)		
		If aPagos[nPos][H_DESCVL]> 0 //Descuento
			//aSaldos[Len(aSaldos)]:= aPagos[nPos][H_TOTALVL]
		Endif	
	Endif
	
Endif

Return Nil