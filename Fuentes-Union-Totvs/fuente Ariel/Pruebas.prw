#INCLUDE "TOTVS.CH"
USER FUNCTION Prueba01()
    /* ESTO FUNCIONA EN NORMAL Y NO EN WEB
    Local cDirUsr := "D:\TOTVS\"
	Local cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
    __CopyFile(cDirSrv+"PRUEBA.PDF", cDirUsr+"PRUEBA.PDF")
    */
    Local cFile := ""// VALORES RETORNADOS NA LEITURA
    Local oFile := FwFileReader():New("system/cfd/facturas/PRUEBA.pdf") // CAMINHO ABAIXO DO ROOTPATH

    // SE FOR POSSÍVEL ABRIR O ARQUIVO, LEIA-O
    // SE NÃO, EXIBA O ERRO DE ABERTURA
    If (oFile:Open())
        cFile := oFile:FullRead() // EFETUA A LEITURA DO ARQUIVO
    ENDIF
  
RETURN
