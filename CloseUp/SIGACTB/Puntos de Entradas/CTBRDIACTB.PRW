#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

#DEFINE TP_MANUAL   "06"
#DEFINE TP_INGRESO  "07"
#DEFINE TP_EGRESO   "08"
#DEFINE TP_TRASPASO "09"

#DEFINE H_TOTALVL   15
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBRDIACTB  บAutor  ณEDUAR ANDIA     บ Data ณ  22/06/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para Asignar automaticamente el Control de Correlativos บฑฑ
ฑฑบ          ณ Contables                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTBRDIACTB

Local cLancPad := ParamIxb[1]
Local cCodDia  := ""
Local cCodReci := ""
Local nA       := 0
Local aArea    := {}
Local lComp1   := .F.
Local lComp2   := .F.

DO CASE
    //+-------------------------------------+
    //|Orden de Pago                        |
    //+-------------------------------------+
    CASE FUNNAME() $ "FINA085A"
    
        For nA := 1 To Len(aPagos)
            
            //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
            //ณ Orden de Pagamento / S๓ Compensa็ใo     ณ
            //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
            If aPagos[nA][H_TOTALVL] == 0
                cCodDia := TP_TRASPASO
            EndIf
        Next nA
        
        If Empty(cCodDia)
            cCodDia := TP_EGRESO
        Endif
        cCodDiario := cCodDia
    //+-------------------------------------+
    //|Anular Orden de Pago                 |
    //+-------------------------------------+
    CASE FUNNAME() $ "FINA086"
        
        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Orden de Pagamento / S๓ Compensa็ใo     ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        If lSoCompOP(TRB->NUMERO)
            cCodDia := TP_TRASPASO
        Endif
        
        If Empty(cCodDia)
            cCodDia := TP_INGRESO
        Endif
    
    //+-------------------------------------+
    //|Cobro Diverso                        |
    //+-------------------------------------+
    CASE FUNNAME() $ "FINA087A"
  
        cCodDia := cDiario

    OTHERWISE
        cCodDia := CTBSeqComp(cLancPad)
ENDCASE

Return(cCodDia)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBRDIACTB  บAutor  ณEDUAR ANDIA     บ Data ณ  22/06/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para Asignar automaticamente el Control de Correlativos บฑฑ
ฑฑบ          ณ Contables                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//+---------------------------------------------------------------------+
//|Retorna o c๓digo do livro diario do comprovante de acordo ao LP      |
//+---------------------------------------------------------------------+
Static Function CTBSeqComp(cLancPad)
Local cCodDia    := ""     
Local cSeqLan001 := GetNewPar("MV_SQSUB01","571")
Local cSeqLan002 := GetNewPar("MV_SQSUB02","570")
Local cSeqLan003 := GetNewPar("MV_SQSUB03","")

If AllTrim(cLancPad) $ cSeqLan001
    cCodDia := TP_INGRESO
ElseIf AllTrim(cLancPad) $ cSeqLan002
    cCodDia := TP_EGRESO
ElseIf Empty(cSeqLan003) .Or. AllTrim(cLancPad) $ cSeqLan003
    cCodDia := TP_TRASPASO
Else
   cCodDia := TP_MANUAL
EndIf
                           
Return cCodDia

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณlCompOP   บAutor  ณEDUAR ANDIA         บFecha ณ  22/06/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFunci๓n que Indica si la Orden de Pago es solo Compensaci๓n บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function lSoCompOP(cOrdPg)
Local aArea     := GetArea()
Local cQuery    := ""
Local nVlrComp  := 0
Local nVlrBco   := 0
Local lRet      := 0

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEK") + " SEK"
cQuery += " WHERE EK_FILIAL = '" + xFilial("SEK") +"'"
cQuery += " AND EK_ORDPAGO = '" + cOrdPg + "'"
cQuery += " AND SEK.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0
    StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())
    If  AllTrim(StrSQL->(EK_TIPO)) $ "PA|NCP" .AND. !(StrSQL->(EK_TIPODOC)$ "PA ")
        nVlrComp := nVlrComp + StrSQL->(EK_VLMOED1)
    Endif
    
    If  !Empty(StrSQL->(EK_BANCO)) .AND. StrSQL->(EK_TIPODOC)$ "CP"
        nVlrBco := nVlrBco + StrSQL->(EK_VLMOED1)               
    Endif
    
    StrSQL->(DbSkip())
EndDo

lRet := nVlrComp > 0 .AND. nVlrBco == 0

RestArea(aArea)
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณlCompOP   บAutor  ณEDUAR ANDIA         บFecha ณ  22/06/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFunci๓n que Indica si la Orden de Pago es solo Compensaci๓n บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AgNxtTrp(cCampo,cTabela,cCondQry,cNrStand)

Local cQuery     := ""
Local cCpoFil    := ""
Local cNxtTrp    := ""
Local nCasas     := 6
Default cCondQry := ""
Default cNrStand := "000000"

If Left(cTabela,1) == "S"
    cCpoFil := SubStr(cTabela,2,2)+"_FILIAL"
Else
    cCpoFil := cTabela+"_FILIAL"
EndIf

cQuery := "SELECT MAX("+cCampo+") AS NRTRAS "
cQuery += "FROM " + RetSqlName(cTabela)+ " TAB "
cQuery += "WHERE "
cQuery += cCpoFil+" = '" + xFilial(cTabela) +"' AND "

If !Empty(cCondQry)
    cQuery += cCondQry+" AND "
EndIf

cQuery += "D_E_L_E_T_<> '*' "

cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0
    StrSQL->(DbCloseArea())
Endif

dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())
    
    cNxtTrp := StrSQL->NRTRAS
       
    StrSQL->(DbSkip())
EndDo

cNxtTrp := Iif(Empty(cNxtTrp),cNrStand,cNxtTrp)

If Left(cNxtTrp,1) $ "1234567890"
    
    cNxtTrp := STRZERO(Val(cNxtTrp)+1,6)
    
Else

    cNxtTrp := Left(cNxtTrp,1)+STRZERO(Val(SubStr(cNxtTrp,2,5))+1,5)

EndIf 

Return(cNxtTrp)