#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function PedidosResiduales() 
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
    Local   nDim        := 0
    Local   nPUni       := 0
    //Local   nTotal      := 0
    Local cSql          := ""
   
    cSql				:= "SELECT top 90 B1_COD"
    cSql				:= cSql + " FROM SB1010"
    cSql				:= cSql + " WHERE D_E_L_E_T_ = ' '"
    cSql				:= cSql + " AND B1_TIPO IN ('ME','SE','SM','MP')"
    cSql				:= cSql + " AND B1_UESTPRO IN ('1','3')"
    cSql				:= cSql + " AND B1_MSBLQL IN ('2',' ')"
    cSql				:= cSql + " AND B1_PRODSAT <> ' '"
    cSql				:= cSql + " AND B1_COD NOT IN ("
    cSql				:= cSql + "     SELECT C6_PRODUTO"
    cSql				:= cSql + "     FROM SC6010"
    cSql				:= cSql + "     WHERE D_E_L_E_T_ = ' '"
    cSql				:= cSql + "     AND C6_ENTREG > '20220101'"
    cSql				:= cSql + "     AND C6_FILIAL = '0105'"
    cSql				:= cSql + "    AND C6_NUM IN ("
    cSql				:= cSql + "             SELECT C5_NUM"
    cSql				:= cSql + "             FROM SC5010"
    cSql				:= cSql + "            WHERE D_E_L_E_T_ = ' '"
    cSql				:= cSql + "            AND C5_EMISSAO = '20220319'"
    cSql				:= cSql + "             AND C5_FILIAL = '0105'"
    cSql				:= cSql + "             )"
    cSql				:= cSql + "     )"
    cSql				:= cSql + " AND B1_COD not IN ("
    cSql				:= cSql + "         SELECT B2_COD"
    cSql				:= cSql + "        FROM SB2010"
    cSql				:= cSql + "        WHERE D_E_L_E_T_ = ' '"
    cSql				:= cSql + "         AND B2_LOCAL = '02'"
    cSql				:= cSql + "         AND B2_QATU > 0"
    cSql				:= cSql + "         )"
    cSql				:= cSql + " ORDER BY B1_COD"
    
    //Aviso("Atencion",cSql,{"Ok"},,,,,.T.)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    
    dbSelectArea(NextArea)
    dbGoTop()
   

    aCabec := {}
    aadd(aCabec,{"C5_NUM",GetSxeNum("SC5","C5_NUM"),Nil})
    aadd(aCabec,{"C5_TIPO","N",Nil})
    aadd(aCabec,{"C5_CLIENTE","008129",Nil})
    aadd(aCabec,{"C5_LOJACLI","01",Nil})
    aadd(aCabec,{"C5_LOJAENT","01",Nil})
    aadd(aCabec,{"C5_CONDPAG","001",Nil})
    aadd(aCabec,{"C5_UNOME","HASBUN  CARMEN",Nil})
    aadd(aCabec,{"C5_TABELA","005",Nil})
    aadd(aCabec,{"C5_UNOMCLI","ESTANCIAS P LTDA.",Nil})
    aadd(aCabec,{"C5_XTIPDOC","5",Nil})
    aadd(aCabec,{"C5_UNITCLI","296040025",Nil})     
    aadd(aCabec,{"C5_VEND1","SI0001",Nil})
    aadd(aCabec,{"C5_ULOCAL","02",Nil})
    aadd(aCabec,{"C5_DOCGER","1",Nil})
    aadd(aCabec,{"C5_UTIPOEN","1",Nil})
    aadd(aCabec,{"C5_CODMPAG","1",Nil})
    aadd(aCabec,{"C5_TPDOCSE","1",Nil})
    aadd(aCabec,{"C5_CLIENT","008129",Nil})
    aadd(aCabec,{"C5_TIPOCLI","1",Nil})

    aItens := {}
    While (!Eof())
        aLinha := {}
        nDim++
        nPUni       := GetPrecio(B1_COD)
        //nTotal      := nPUni 
            aadd(aLinha,{"C6_ITEM",StrZero(nDim,2),Nil})
            aadd(aLinha,{"C6_PRODUTO",B1_COD,Nil})
            aadd(aLinha,{"C6_QTDVEN",1,Nil})
            aadd(aLinha,{"C6_PRCVEN",nPUni,Nil})
            aadd(aLinha,{"C6_PRUNIT",nPUni,Nil})
            aadd(aLinha,{"C6_VALOR",nPUni,Nil})
            aadd(aLinha,{"C6_TES","510",Nil})
            aadd(aLinha,{"C6_LOCAL","02",Nil})
            aadd(aLinha,{"C6_CC","412101",Nil})
            aadd(aItens,aLinha)
        DbSkip()
    EndDo   

    MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,3)
    //Mostraerro()

    #IFDEF TOP
        dBCloseArea(NextArea)
    #ENDIF
    RestArea(aArea)
      
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




