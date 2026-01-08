#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function PedidosResidualesCli() 
    Local   aArea       := GetArea()
    Local   NextArea    := GetNextAlias()
   // Local   nDim        := 0
   // Local   nPUni       := 0
    //Local   nTotal      := 0
    Local cSql              := ""
          cSql				:= 		 "select DISTINCT SC5.C5_CLIENTE+SC5.C5_LOJACLI,C5_CLIENTE,C5_LOJACLI,A1_NOME,"
          cSql				:= cSql +"A1_LOJA,A1_COND,A1_TABPADR,A1_UNOMFAC,A1_TIPDOC,A1_UNITFAC,A1_EMAIL"
          cSql				:= cSql +"FROM SC5010 SC5 LEFT JOIN SA1010 SA1 ON  SA1.A1_COD+SA1.A1_LOJA = SC5.C5_CLIENTE+SC5.C5_LOJACLI "
          cSql				:= cSql +"and SA1.D_E_L_E_T_ = ' '"
          cSql				:= cSql +"WHERE C5_EMISSAO BETWEEN '20210101' AND '20220318'"
          cSql				:= cSql +"AND C5_CLIENTE+C5_LOJACLI NOT IN(select C5_CLIENTE+C5_LOJACLI FROM SC5010 "
          cSql				:= cSql +"WHERE C5_EMISSAO= '20220319' AND D_E_L_E_T_ = ' ')"
          cSql				:= cSql +"AND SC5.D_E_L_E_T_ = ' '"
          cSql				:= cSql +"order by C5_CLIENTE"
    
    //Aviso("Atencion",cSql,{"Ok"},,,,,.T.)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
    
    dbSelectArea(NextArea)
    dbGoTop()   
    While (!Eof())
    aCabec := {}
    aadd(aCabec,{"C5_NUM",GetSxeNum("SC5","C5_NUM"),Nil})
    aadd(aCabec,{"C5_TIPO","N",Nil})
    aadd(aCabec,{"C5_CLIENTE",C5_CLIENTE,Nil})
    aadd(aCabec,{"C5_LOJACLI",A1_LOJA,Nil})
    aadd(aCabec,{"C5_LOJAENT",A1_LOJA,,Nil})
    aadd(aCabec,{"C5_CONDPAG",A1_COND,Nil})
    aadd(aCabec,{"C5_UNOME",A1_NOME,Nil})
    aadd(aCabec,{"C5_TABELA",A1_TABPADR,Nil})
    aadd(aCabec,{"C5_UNOMCLI",A1_UNOMFAC,Nil})
    aadd(aCabec,{"C5_XTIPDOC",A1_TIPDOC,Nil})
    aadd(aCabec,{"C5_UNITCLI",A1_UNITFAC,Nil})     
    aadd(aCabec,{"C5_VEND1","SC0022",Nil})
    aadd(aCabec,{"C5_ULOCAL","02",Nil})
    aadd(aCabec,{"C5_DOCGER","1",Nil})
    aadd(aCabec,{"C5_UTIPOEN","1",Nil})
    aadd(aCabec,{"C5_CODMPAG","1",Nil})
    aadd(aCabec,{"C5_TPDOCSE","1",Nil})
    aadd(aCabec,{"C5_XEMAIL",A1_EMAIL,Nil})
    aadd(aCabec,{"C5_UOBSERV","1",Nil})
    aItens := {}
    //While (!Eof())
        aLinha := {}
      //  nDim++
       // nPUni       := GetPrecio(B1_COD)
        //nTotal      := nPUni 
            aadd(aLinha,{"C6_ITEM","01",Nil})
            aadd(aLinha,{"C6_PRODUTO","000002",Nil})   
            aadd(aLinha,{"C6_UM","UN",Nil})          
            aadd(aLinha,{"C6_DESCRI","AGUJAS+TORN P/APLIC.ALLFLEX",Nil})
            aadd(aLinha,{"C6_QTDVEN",1,Nil})
            aadd(aLinha,{"C6_PRCVEN",4,Nil})
            aadd(aLinha,{"C6_PRUNIT",4,Nil})
            aadd(aLinha,{"C6_VALOR",4,Nil})
            aadd(aLinha,{"C6_SEGUM","CJ",Nil})
            aadd(aLinha,{"C6_QTDLIB",1,Nil})
            aadd(aLinha,{"C6_TES","510",Nil})
            aadd(aLinha,{"C6_LOCAL","02",Nil})
            aadd(aLinha,{"C6_CCUSTO","411102",Nil})
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




