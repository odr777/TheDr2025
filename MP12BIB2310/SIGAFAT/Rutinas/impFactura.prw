#include 'protheus.ch'
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  บAutor  ณOmar Delgadillo    บ Data ณ  26/03/2024		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprimir Factura de Venta บ								   ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BIB .2310                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Ajusta el precio de Venta a 2 Decimales en el Pedido de Venta
User Function impFactura(cDoc, cSerieFac, cEspecie)
	_cDoc 		:= cDoc
	_cSerieFac 	:= cSerieFac
	_cEspecie 	:= TRIM(cEspecie)
	lEnLinea	:= .F.

	lEnLinea := (GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+_cSerieFac,1,"0")=="1") .AND. (GETNEWPAR('MV_CFDUSO','0')<>"0")

	// Imprimir Factura		
	if (!lEnLinea)
		// Ajustar al formato del cliente
		U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1,"ORIGINAL")
		U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1,"COPIA")				
	else
		//cNomArq 	:= 'l01000000000000000031nf.pdf'		
		cNomArq	:= _cSerieFac + _cDoc + _cEspecie + '.pdf'
		cDirUsr := GetTempPath()
		cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
		__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
		nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
		If nRet <= 32
			// MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atenci๓n")
			Conout("No fue posible abrir el archivo " +cNomArq+ "!")
		EndIf
	endif
Return 
