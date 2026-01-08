#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT462MNU บAutor  ณTdeP Horeb S.R.L.บ Data ณ  29/05/2017     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPunto de Entrada que adiciona un boton para imprimir        บฑฑ
ฑฑบ          ณde acuerdo a una rutina en especifica 					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BIB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT462MNU()

	Do Case
		Case FUNNAME() == 'MATA462TN' //Transferencia
		//	AADD(AROTINA,{ 'Imprimir',"U_REMITSUC()"     , 0 , 5})

		AADD(AROTINA,{ 'Imprimir',"U_TRAINV" , 0 , 5})

		If aCfgNf[1]==54 //Transferencia de Entrada
			AAdd(aRotina,{ "Leyenda"  ,"LocxLegenda()",0 , 2,0,.F.} )
			//AAdd(aCores,{  ' F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  'U_IsTransPend() .AND.F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  '!U_IsTransPend() .AND. F2_TIPODOC	==	"54"'    		, 'BR_PRETO'}) 		// Remito transf.
			//AAdd(aCores,{  "F2_DOC=='EDU-SAL-0001'", 'BR_LARANJA'})
		Endif
		//	 	AADD(AROTINA,{ 'Imp. Transf. Serie',"U_TRASERIE" , 0 , 5})
		CASE FUNNAME()='MATA462N' // Remito
		AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
		Case FUNNAME()$'MATA102N|MATA462N'
		AADD(AROTINA,{ 'Imprimir',"U_IMPREMITO()"     , 0 , 5})
		AADD(AROTINA,{ 'Imprimir PTD.',"U_ParDiGra()"     , 0 , 5})
		//AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
		//AADD(AROTINA,{ 'Conocimiento',"U_CONOC_REM()"     , 0 , 5})
		Case FUNNAME()=='MATA101N'
		AADD(AROTINA,{ 'Imprimir',"U_FacEnt()"     , 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
		Case FUNNAME() == 'MATA467N'
		//AADD(AROTINA,{ 'Cobro',"U_FactQR()"     , 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Factura',"U_GFATI301(F2_DOC,F2_DOC,F2_SERIE,1)"     , 0 , 9})
		AADD(AROTINA,{ 'Imprimir Factura',"U_FactLocal(F2_DOC,F2_DOC,F2_SERIE,1)"     , 0 , 9})
		AADD(AROTINA,{ 'Imp. Plan de Pago',"U_PlanPag(F2_CLIENTE,F2_DOC,F2_EMISSAO)"     , 0 , 9})
		Case FUNNAME()=='MATA465N'
		AADD(AROTINA,{ 'Imprimir',"U_IMPNCC(F1_DOC,F1_DOC,F1_SERIE,1)" , 0 , 5})
	EndCase

Return