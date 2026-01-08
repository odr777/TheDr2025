#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT462MNU บAutor  ณJorge Saavedra           บ Data ณ  07/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPunto de Entrada que adiciona un boton para imprimir        บฑฑ
ฑฑบ          ณde acuerdo a una rutina en especifica 					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INESCO                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT462MNU()
	Do Case
	Case FUNNAME() == 'MATA462TN'
		If aCfgNf[1]==64 // Impresion Entrada
//	 	AADD(AROTINA,{ 'Imprimir',"U_TRANSENT" , 0 , 5})
//		AADD(AROTINA,{ 'Imprimir con logo',"U_TRANSENT" , 0 , 5}) // con logo
			AADD(AROTINA,{ 'Imprimir sin logo',"U_TRANS2ENT" , 0 , 5}) //Sin logo
		endif
		If aCfgNf[1]==54

//	 			AADD(AROTINA,{ 'Imprimir',"U_TRANSSAL" , 0 , 5}) // Impresion salida                           	
//			 	AADD(AROTINA,{ 'Imprimir con logo',"U_TRANSSAL" , 0 , 5}) // Impresion salida con logo                           
			AADD(AROTINA,{ 'Imprimir sin logo',"U_TRANS2SAL" , 0 , 5}) // Impresion salida sin logo
			AAdd(aRotina,{ "Leyenda"  ,"LocxLegenda()",0 , 2,0,.F.} )
			//AAdd(aCores,{  ' F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  'U_IsTransPend() .AND.F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  '!U_IsTransPend() .AND. F2_TIPODOC	==	"54"'    		, 'BR_PRETO'}) 		// Remito transf.
			//AAdd(aCores,{  "F2_DOC=='EDU-SAL-0001'", 'BR_LARANJA'})
		Endif
//	 	AADD (AROTINA,{ 'Imp. Transf. Serie',"U_TRASERIE" , 0 , 5})
	Case FUNNAME()=='MATA102N'
		//AADD(AROTINA,{ 'Imprimir',"U_IMPREMITO()"     , 0 , 5})
		AADD(AROTINA,{ 'Imprimir Remito',"U_IMREM()"     , 0 , 5})
		AADD(AROTINA,{ 'Imprimir Remito sin cantidad',"U_IMREM2()"     , 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
		//AADD(AROTINA,{ 'Conocimiento',"U_CONOC_REM()"     , 0 , 5})
	Case FUNNAME()=='MATA462N'
		AADD(AROTINA,{ 'Imprimir',"U_IMPREMITO()"     , 0 , 5})
	Case FUNNAME()=='MATA466N'
		AADD(AROTINA,{ 'Imprimir nota',"U_NCPMLCL(F2_DOC,F2_DOC,F2_SERIE,F2_CLIENTE)"     , 0 , 5})
	Case FUNNAME()=='MATA101N'
		AADD(AROTINA,{ 'Imprimir',"U_FacEnt()"     , 0 , 5})
		//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
	Case FUNNAME() == 'MATA467N'
		//AADD(AROTINA,{ 'Cobro',"U_FactQR()"     , 0 , 5})
		AADD(AROTINA,{ 'Imprimir Factura',"U_FacturaMCL(F2_DOC,F2_DOC,F2_SERIE,F2_CLIENTE)"     , 0 , 5})
		AADD(AROTINA,{ 'Imprimir Venta Mayorista',"U_VTAMAYOR()"     , 0 , 5})
	EndCase

Return

