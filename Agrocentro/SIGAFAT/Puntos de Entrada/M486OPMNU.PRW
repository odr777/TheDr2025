#include 'protheus.ch'
#include 'parmtype.ch'
 
 
User Function M486OPMNU()
     Local aOpcAdi := {}
     aAdd(aOpcAdi, {"Imprimir", "U_ImpFacTra()",  0,1,0,NIL})    // Imprimir Factura Seleccionada
     aAdd(aOpcAdi, {"Anular"  , "U_AnuFac()",     0,1,0,NIL})    // Anular Factura Seleccionada
Return aOpcAdi
 
User Function ImpFacTra()
	_cDoc := SF2->F2_DOC
	_cSerieFac := SF2->F2_SERIE
	//cNomArq 	:= 'l01000000000000000031nf.pdf'		
	cNomArq	:= _cSerieFac + _cDoc + TRIM(SF2->F2_ESPECIE) + '.pdf'
	cDirUsr := GetTempPath()
	cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
	__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
	nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
	If nRet <= 32
		MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
	EndIf 
return nil

User Function AnuFac()
     cPerg := "MATA486G"
     u_zAtuPerg(cPerg+Space(2), "MV_PAR01", SF2->F2_SERIE)
     u_zAtuPerg(cPerg+Space(2), "MV_PAR02", SF2->F2_DOC)
     u_zAtuPerg(cPerg+Space(2), "MV_PAR03", SF2->F2_DOC)
     M486XFBOLB()
return nil
