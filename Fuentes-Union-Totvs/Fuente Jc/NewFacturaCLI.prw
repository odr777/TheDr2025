#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function cliFacturasResidualescli() 
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
    Local   cxNroFct    := ""
    Local cSql              := "select DISTINCT C5_CLIENTE+C5_LOJACLI,A1_VEND,A1_UCCC,A1_TIPO,A1_EST,A1_REGIAO,C5_CLIENTE,C5_LOJACLI,A1_NOME,A1_LOJA,A1_COND,A1_CGC,A1_COD,A1_TABPADR,A1_UNOMFAC,A1_TIPDOC,A1_UNITFAC,A1_EMAIL FROM SC5010 SC5 LEFT JOIN SA1010 SA1 ON  SA1.A1_COD+SA1.A1_LOJA = SC5.C5_CLIENTE+SC5.C5_LOJACLI and SA1.D_E_L_E_T_ = ' ' WHERE C5_EMISSAO BETWEEN '20210101' AND '20220318'AND C5_CLIENTE+C5_LOJACLI NOT IN(SELECT F2_CLIENTE+F2_LOJA from SF2010 WHERE F2_SERIE IN ('S01','S02','S13','S14','S17') and  D_E_L_E_T_ = ' ' group by F2_CLIENTE+F2_LOJA) AND A1_MSBLQL='2' AND SC5.D_E_L_E_T_ = ' ' GROUP BY C5_CLIENTE+C5_LOJACLI,A1_VEND,A1_UCCC,A1_TIPO,A1_EST,A1_REGIAO,C5_CLIENTE,C5_LOJACLI,A1_NOME,A1_LOJA,A1_COND,A1_CGC,A1_COD,A1_TABPADR,A1_UNOMFAC,A1_TIPDOC,A1_UNITFAC,A1_EMAIL order by C5_CLIENTE"
    //      cSql				:=      "select DISTINCT top 1  SC5.C5_CLIENTE+SC5.C5_LOJACLI,C5_CLIENTE,C5_LOJACLI,A1_NOME,"
    //      cSql				:= cSql +"A1_LOJA,A1_COND,A1_CGC,A1_COD,A1_TABPADR,A1_UNOMFAC,A1_TIPDOC,A1_UNITFAC,A1_EMAIL"
   //       cSql				:= cSql +"FROM SC5010 SC5 LEFT JOIN SA1010 SA1 ON  SA1.A1_COD+SA1.A1_LOJA = SC5.C5_CLIENTE+SC5.C5_LOJACLI "
   //       cSql				:= cSql +"and SA1.D_E_L_E_T_ = ' ' WHERE C5_EMISSAO BETWEEN '20210101' AND '20220318'AND C5_CLIENTE+C5_LOJACLI NOT IN("
  //        cSql				:= cSql +"SELECT F2_CLIENTE+F2_LOJA from SF2010 WHERE F2_EMISSAO  >= '20220319' and D_E_L_E_T_ = ' '"
   //       cSql				:= cSql +"group by F2_CLIENTE+F2_LOJA) AND SC5.D_E_L_E_T_ = ' 'order by C5_CLIENTE"
    Private lMsErroAuto := .F.  
    // IMPRIME UN AVISO EN PANTALLA  
    //  para 500 fact  ini :17:02  --  fin :       
    //Aviso("Atencion",cSql,{"Ok"},,,,,.T.)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    
    dbSelectArea(NextArea)
    dbGoTop()
    
    While (!Eof())
        aCabec := {}
        codigcliente := ''
        cxNroFct := GtNxtFat("S17","01",18)
        AAdd( aCabec, { "F2_CLIENTE"  , A1_COD              , Nil } )//////
        codigcliente:= A1_COD
        AAdd( aCabec, { "F2_LOJA"     , A1_LOJA             , Nil } )//////
        LOJA:= A1_LOJA
        
        AAdd( aCabec, { "F2_SERIE"    , "S17"               , Nil } )//////
        AAdd( aCabec, { "F2_DOC"      , cxNroFct            , Nil } )//////
        AAdd( aCabec, { "F2_COND"     , "001"               , Nil } )//////
        AAdd( aCabec, { "F2_EMISSAO"  , "20220426"          , Nil } )//////
        AAdd( aCabec, { "F2_DTDIGIT"  , "20220426"          , Nil } )//////
        AAdd( aCabec, { "F2_VEND1"    , "SI0001"            , Nil } )//////
        AAdd( aCabec, { "F2_EST"      , A1_EST              , Nil } )//////
        AAdd( aCabec, { "F2_TIPO"     , "N"                 , Nil } )//////
        AAdd( aCabec, { "F2_TIPOCLI"  , A1_TIPO             , Nil } )//////
        AAdd( aCabec, { "F2_PREFIXO"  , "S17"               , Nil } )////
        AAdd( aCabec, { "F2_MOEDA"    , 2                   , Nil } )////
        AAdd( aCabec, { "F2_TXMOEDA"  , 6.96                , Nil } )////
        AAdd( aCabec, { "F2_FORMUL"   , "S"                 , Nil } )////
        AAdd( aCabec, { "F2_REGIAO"   , A1_REGIAO           , Nil } )////
        AAdd( aCabec, { "F2_TIPODOC"  , "01"                , Nil } )///
        AAdd( aCabec, { "F2_TABELA"   , "005"               , Nil } )/////
        AAdd(aCabec,  { "F2_SDOC"     , "S17"               , Nil } )////
        AAdd(aCabec,  { "F2_LIQPROD"  , "2"                 , Nil } )
       // aAdd(aCabec,  {"F2_UNITCLI"   ,  "5405882018"       , Nil } )////////AllTrim(A1_UNITFAC)
            NOMBREFAC := alltrim(A1_UNOMFAC)
            NITCLI    := alltrim(A1_UNITFAC)
          //  Aviso("Atencion",NOMBREFAC +":"+ A1_UNOMFAC ,{"Ok"},,,,,.T.)
           // Aviso("Atencion",NITCLI +":"+ A1_UNITFAC ,{"Ok"},,,,,.T.)
       // aAdd(aCabec,  {"F2_UNOMCLI"   ,  "juan carlos"      , Nil } )///////ALLTRIM(A1_UNOMFAC)
        aAdd(aCabec,  {"F2_USRREG"    , "JCAMPOS"           , Nil } )//////
        aAdd(aCabec,  {"F2_MODCONS"   , "1"                 , Nil } )////
        aAdd(aCabec,  {"F2_TPDOC"     , A1_TIPDOC           , Nil } )///
        aAdd(aCabec,  {"F2_XTIPDOC"   ,A1_TIPDOC            , Nil } )///
        aAdd(aCabec,  {"F2_XEMAIL"    , A1_EMAIL            , Nil } )///
    
            aItens := {}
            aLinha := {}
           
            AAdd( aLinha, { "D2_ITEM"   , "01"              , Nil } )
            AAdd( aLinha, { "D2_COD"    , "000012"          , Nil } )
            AAdd( aLinha, { "D2_QUANT"  , 3                 , Nil } )
            AAdd( aLinha, { "D2_PRCVEN" , 0.85              , Nil } )
            AAdd( aLinha, { "D2_TOTAL"  , 2.55              , Nil } )
            AAdd( aLinha, { "D2_PRUNIT" , 0.85              , Nil } )
            AAdd( aLinha, { "D2_CCUSTO" , A1_UCCC          , Nil } )
            AAdd( aLinha, { "D2_CONTA" , "11301001"        , Nil } )
            AAdd( aLinha, { "D2_SDOC"   , "S17"             , Nil } )
            AAdd( aLinha, { "D2_TES"    , "510"             , Nil } ) 
            AAdd( aLinha, { "D2_LOCAL"  , "02"              , Nil } )
            AAdd( aLinha, { "D2_SERIE"  , "S17"             , Nil } )
            aadd(aItens,aLinha)

        MSExecAuto( { |x,y,z| Mata467n(x,y,z) }, aCabec, aItens, 3 )
        //dbSelectArea("SF2") 
        //dbSetOrder(1)
        //dbSeek("0105"+cxNroFct+"S17"+codigcliente+LOJA+"S"+"N")
       // Reclock("SF2",.F.)
        ////F2_UNITCLI := NITCLI
       // F2_UNOMCLI := NOMBREFAC
        //MSUnlock()
     
        //Mostraerro()
        UpdNrFct(cxNroFct,"S17","01")
        dbSelectArea(NextArea)
        DbSkip()
              
    EndDo   

    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
       //Mostraerro()
Return Nil


Static Function GtNxtFat(cSerie,cTbla,nTamFN)
    Local   cXNroFct    := ""   
    Local   NextArea    := GetNextAlias()
    Local   cSql        := ""
    Local aArea               := GetArea()        
    cSql                := cSql + " Select X5_DESCSPA "
    cSql                := cSql + " From   SX5010 "
    cSql                := cSql + " Where  X5_TABELA = '" + cTbla  + "' And "
    cSql                := cSql +       "  X5_CHAVE  = '" + cSerie + "' And "
    cSql                := cSql +       "  SX5010.D_E_L_E_T_= ' '  "
    //Aviso("Atencion",cSql,{"Ok"},,,,,.T.)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()
    If ( !Eof() )
        cXNroFct        := PADL(AllTrim(X5_DESCSPA),nTamFN,"0")         
    EndIf

    #IFDEF TOP
        (NextArea)->(dBCloseArea(NextArea))
    #ENDIF
    RestArea(aArea) 
    
                    
Return cXNroFct  

Static Function UpdNrFct(cxNroFct,cXSre,cxTbl)
    Local bSw   := .F.
    //Local aArea       := GetArea()
    Local cNexFact := PADL( AllTrim(Str((Val(cxNroFct)+1))) ,18,"0")
    Local cSql  := " Update SX5010 Set "
    cSql        := cSql + " X5_DESCRI  = '" + cNexFact  + "', "
    cSql        := cSql + " X5_DESCSPA = '" + cNexFact  + "', "
    cSql        := cSql + " X5_DESCENG = '" + cNexFact  + "'"
    cSql        := cSql + " Where  X5_CHAVE  ='" + cXSre  + "' And "
    cSql        := cSql + " X5_TABELA   = '" + cxTbl + "'"
    //MsgAlert(cSql)
    nSql        := TCSQLExec(cSql)
    If ( nSql >= 0 )
        bSw     := .T.
    EndIf

    //RestArea(aArea) 
Return Nil 

Static Function GetPrecio (cCod)
	Local	nPrecio := 0
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
    Local cSql          := ""
   
    cSql				:= "SELECT DA1_PRCVEN FROM DA1010 WHERE D_E_L_E_T_ = ' ' AND DA1_CODTAB = '005'"
    cSql				:= cSql + " AND DA1_CODPRO = '" + cCod + "'"
    
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    dbSelectArea(NextArea)
    dbGoTop()

    if (Eof())
        nPrecio := 10
    else
        nPrecio := DA1_PRCVEN
    ENDIF

    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
Return  nPrecio




