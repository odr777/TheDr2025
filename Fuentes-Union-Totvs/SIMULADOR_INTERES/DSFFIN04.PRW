#include "PROTHEUS.ch"

//*******************************************************************************
//*			Autor: Marcelo Bandini												*
//*			Version: 1.0														*
//*			Fecha inicio: 16/2/2020												*
//*			Fecha modif.: 18/2/2020												* 
//*			Objetivo: Simular intereses a cobrar y generación de notas de débito* 
//*			Fichero: DSFFIN04.PRW												*
//*******************************************************************************

User Function DSFFIN04(aF2, aD2)
Local aCabec    := {}
Local aItens    := {}
Local aLinha    := {}
Local cSerie
Local nOpcX
Local cDoc      := GetSxeNum("SC5", "C5_NUM")
Local cTPDoc
Local cCond  
Local nTxmoeda 
Local cUM 
Local nDecTot
Local cPDV     
Local cEst
Local cTES 
Local nX
Local lRet
Local cSerComp
Local cDocAnt
Local cNat := "0-OTROS"
Private lMsErroAuto := .F.


aadd(aCabec, {"C5_FILIAL",  xFilial("SC5"),     Nil})
aadd(aCabec, {"C5_NUM",     cDoc,               Nil})
aadd(aCabec, {"C5_TIPO",    "N",                Nil})
aadd(aCabec, {"C5_CLIENTE", aF2[1],             Nil})
aadd(aCabec, {"C5_CLIENT",  aF2[1],             Nil})
aadd(aCabec, {"C5_LOJACLI", aF2[2],             Nil})
aadd(aCabec, {"C5_LOJAENT", aF2[2],             Nil})
aadd(aCabec, {"C5_CONDPAG", aF2[4],             Nil})
aadd(aCabec, {"C5_MOEDA",   aF2[3],             Nil})
aadd(aCabec, {"C5_VEND1",   aF2[5],             Nil})

aadd(aCabec, {"C5_ULOCAL",   "01",              Nil})
aadd(aCabec, {"C5_DOCGER",   "1",               Nil})
aadd(aCabec, {"C5_UTIPOEN",   "1",              Nil})
aadd(aCabec, {"C5_TIPOREM",   "0",              Nil})
aadd(aCabec, {"C5_TIPOCLI",   "3",              Nil})
aadd(aCabec, {"C5_EMISSAO",   ddatabase,        Nil})
aadd(aCabec, {"C5_LIBEROK",   "S",              Nil})
aadd(aCabec, {"C5_CODMPAG",   "1",              Nil})
aadd(aCabec, {"C5_TPDOCSE",   "1",              Nil})

 
For nX := 1 To Len(aD2)
    //--- Se informan los items del pedido de venta
    aLinha := {}
    aadd(aLinha,{"C6_FILIAL",    xfilial("SC6"),        Nil})
    aadd(aLinha,{"C6_ITEM",    StrZero(nX,2),           Nil})
    aadd(aLinha,{"C6_PRODUTO", aD2[nX,1],               Nil})
    aadd(aLinha,{"C6_UM",       "UN",                   Nil})
    aadd(aLinha,{"C6_QTDVEN",  ROUND(aD2[nX,2],2),      Nil})
    aadd(aLinha,{"C6_PRCVEN",  ROUND(aD2[nX,3],2),      Nil})
    aadd(aLinha,{"C6_PRUNIT",  ROUND(aD2[nX,3],2),      Nil})
    aadd(aLinha,{"C6_VALOR",   ROUND(aD2[nX,3],2),      Nil})
    aadd(aLinha,{"C6_TES",     aD2[nX,5],               Nil})
    aadd(aLinha,{"C6_LOCAL",     "01",                  Nil})
    //aadd(aLinha,{"C6_XRECE1",    aD2[nX,6],     Nil})
    aadd(aItens, aLinha)
Next nX


MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)

IF lMsErroAuto
    MostraErro()
    lRet := .F.
ELSE
    MSGINFO("SE GENERO EL PEDIDO N°: " + cDoc)
    lRet := .T.
    for nx := 1 to LEN(aItens)
        POSICIONE("SC6",1,XFILIAL("SC6") + cDoc + aItens[nx,2,2] + aItens[nx,3,2], "C6_NUM")
        reclock("SC6", .F.)
        SC6->C6_XRECE1 := aD2[nx,6]
        msunlock()
    next nx
ENDIF

RETURN {lRet, cDoc, cSerie}
