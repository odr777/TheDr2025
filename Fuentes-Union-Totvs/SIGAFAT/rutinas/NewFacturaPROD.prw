#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function FacturasResidualesPROD() 
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
    Local   cxNroFct    := ""
    Local   nDim        := 0
    Local   nPUni       := 0
    Local cSql          := ""
   
    cSql				:= "SELECT top 90 B1_COD"
    cSql				:= cSql + " FROM SB1010"
    cSql				:= cSql + " WHERE D_E_L_E_T_ = ' '"
    cSql				:= cSql + " AND B1_TIPO IN ('ME','SE','SM','MP')"
    cSql				:= cSql + " AND B1_UESTPRO IN ('1','3')"
    cSql				:= cSql + " AND B1_MSBLQL IN ('2',' ')"
    cSql				:= cSql + " AND B1_PRODSAT <> ' '"
    cSql				:= cSql + " AND B1_COD NOT IN ("
    cSql				:= cSql + "     SELECT DISTINCT D2_COD"
    cSql				:= cSql + "     FROM SD2010"
    cSql				:= cSql + "     WHERE D_E_L_E_T_ = ' '"
    cSql				:= cSql + "     AND D2_SERIE IN ('S01','S02','L01','S03','S04')"
    cSql				:= cSql + "     AND D2_ESPECIE = 'NF'"
    cSql				:= cSql + "     )"
    cSql				:= cSql + " ORDER BY B1_COD"
    
    //Aviso("Atencion",cSql,{"Ok"},,,,,.T.)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    
    dbSelectArea(NextArea)
    dbGoTop() 
        aCabec := {}
        cxNroFct := GtNxtFat("S03","01",18)
        AAdd( aCabec, { "F2_CLIENTE"  , "008129"            , Nil } )
        AAdd( aCabec, { "F2_LOJA"     , "01"                , Nil } )
        AAdd( aCabec, { "F2_SERIE"    , "S03"               , Nil } )
        AAdd( aCabec, { "F2_DOC"      , cxNroFct            , Nil } )
        AAdd( aCabec, { "F2_COND"     , "001"               , Nil } )
        AAdd( aCabec, { "F2_EMISSAO"  , "20220329"          , Nil } )
        AAdd( aCabec, { "F2_DTDIGIT"  , "20220329"          , Nil } )
        AAdd( aCabec, { "F2_VEND1"    , "SI0001"          , Nil } )
        AAdd( aCabec, { "F2_EST"      , "01"                , Nil } )
        AAdd( aCabec, { "F2_TIPO"     , "N"                 , Nil } )
        AAdd( aCabec, { "F2_ESPECIE"  , "NF"                , Nil } )
        AAdd( aCabec, { "F2_PREFIXO"  , "S03"               , Nil } )
        AAdd( aCabec, { "F2_MOEDA"    , 2                   , Nil } )
        AAdd( aCabec, { "F2_TXMOEDA"  , 6.96                , Nil } )
        AAdd( aCabec, { "F2_FORMUL"   , "S"                 , Nil } )
        AAdd( aCabec, { "F2_TIPODOC"  , "01"                , Nil } )
        AAdd( aCabec, { "F2_TABELA"   , "005"               , Nil } )
        AAdd(aCabec,  { "F2_SDOC"     , "S03"               , Nil } )
        
        AAdd(aCabec,  { "F2_LIQPROD"     , "2"               , Nil } )
        aAdd(aCabec,  {"F2_UNITCLI"   , "296040025"         , Nil})
        aAdd(aCabec,  {"F2_UNOMCLI"   , "HASBUN  CARMEN"    , Nil})
        aAdd(aCabec,  {"F2_USRREG"    , "ACABALLERO"        , Nil})
        aAdd(aCabec,  {"F2_MODCONS"   , "1"                 , Nil})
        aAdd(aCabec,  {"F2_TPDOC"     , "1"                 , Nil})
    
        aItens := {}
        While (!Eof())
            aLinha := {}
            nDim++
            nPUni       := GetPrecio(B1_COD)
            AAdd( aLinha, { "D2_ITEM"   , StrZero(nDim,2)                         , Nil } )
            AAdd( aLinha, { "D2_COD"    , B1_COD                                              , Nil } )
            AAdd( aLinha, { "D2_QUANT"  , 3                                     , Nil } )
            AAdd( aLinha, { "D2_PRCVEN" , nPUni                                     , Nil } )
            AAdd( aLinha, { "D2_TOTAL"  , Round((nPUni*3),2)  , Nil } )
            AAdd( aLinha, { "D2_PRUNIT" , nPUni                                     , Nil } )
            AAdd( aLinha, { "D2_CCUSTO"  , "412101"  , Nil } )
            AAdd( aLinha, { "D2_SDOC"  , "S03"  , Nil } )
            AAdd( aLinha, { "D2_TES"    , "510"                                                     , Nil } ) 
            AAdd( aLinha, { "D2_LOCAL"  , "12"                                              , Nil } )
            AAdd( aLinha, { "D2_SERIE"  , "S03"                                                      , Nil } )
            aadd(aItens,aLinha)
        DbSkip()
    EndDo   

    MSExecAuto( { |x,y,z| Mata467n(x,y,z) }, aCabec, aItens, 3 )
    //Mostraerro()
    UpdNrFct(cxNroFct,"S03","01")

    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
      
Return Nil


Static Function GtNxtFat(cSerie,cTbla,nTamFN)
    Local   cXNroFct    := ""   
    Local   NextArea    := GetNextAlias()
    Local   cSql        := ""
    aArea               := GetArea()        
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

    If nPrecio = 0
        nPrecio := 5
    endif

    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
Return  nPrecio




