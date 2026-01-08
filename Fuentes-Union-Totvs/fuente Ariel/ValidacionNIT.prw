#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function ValNitIMP() 
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
    Local cSql          := ""
    Local cFile1 := "D:\texto\cgc.txt"
    Local nCgc
 
    Local cBuffer   := ""
    
    Local cFile2 := "D:\texto\nitfac.txt"
    Local nNitfac
    
    Local cFile3 := "D:\texto\avance.txt"
    Local nAvance
    

    //cFileOpen := cGetFile("Arquivo TXT | *.txt","Seleccione el archivo",,"D:\",.T.)
    FT_FUSE("d:\texto\codigo.txt")             
    FT_FGOTOP()
    cBuffer := FT_FREADLN()                     
    FT_FUSE()

    nCgc    :=  fCreate(cFile1)
    nNitfac :=  fCreate(cFile2)
    nAvance :=  fCreate(cFile3)

    cSql := cSql +"SELECT TOP 50 A1_COD,A1_LOJA,A1_CGC,A1_UNITFAC,A1_EMAIL"
    cSql := cSql +" FROM SA1010"
    cSql := cSql +" WHERE D_E_L_E_T_ = ' '"
    cSql := cSql +" AND A1_TIPDOC = '5'"
    cSql := cSql +" AND A1_COD > '" + cBuffer + "'"
    cSql := cSql +" ORDER BY A1_COD,A1_LOJA"

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    
    dbSelectArea(NextArea)
    dbGoTop()   
    While (!Eof())
        If !ValNITVu(A1_CGC)
            fWrite(nCgc,A1_COD + "|" + A1_LOJA + "|" + A1_CGC + chr(13)+chr(10) )
        ENDIF
        If !ValNITVu(A1_UNITFAC)
            fWrite(nNitfac,A1_COD + "|" + A1_LOJA + "|" + A1_UNITFAC + chr(13)+chr(10) )    
        ENDIF
        fWrite(nAvance,A1_COD + "|" + A1_LOJA + "|" + chr(13)+chr(10) ) 
        DbSkip()
    EndDo   

   
    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    */
    fClose(nCgc)
    fClose(nNitfac)
    fClose(nAvance)
    
    RestArea(aArea)
      
Return Nil



