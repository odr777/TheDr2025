#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

#DEFINE TP_MANUAL   "06"
#DEFINE TP_INGRESO  "07"
#DEFINE TP_EGRESO   "08"
#DEFINE TP_TRASPASO "09"
#Define N_DOCUMENTOS_COBRO 1
#Define N_RESUMEN 4
#Define CRLF Chr(13) + Chr(10)

//--------------------------------------------------------------------
/*/{Protheus.doc} A085NORP
@description de A087TUDOK:
    Este punto de entrada no es publico, buscando lo encontré en: A087TUDOK.prw
    // ACols
@author Jaime Luis Jiménez
@since  17/03/2017
@obs    Se debe revisar las variables Privadas, para poder programar correctamente.
        Private aCols (La misma variable de siempre, donde se accede a la Grilla).
@version MP11 R5
/*/
//--------------------------------------------------------------------
User Function A085NORP()

If __lSx8
    RollBackSX8()
EndIf

If cCodDiario == "09"
    cCodOrd := U_AgNxtTrp(" EK_ORDPAGO","SEK","EK_ORDPAGO LIKE 'C%' ","C00000" )
Else            
    cCodOrd := U_AgNxtTrp(" EK_ORDPAGO","SEK","EK_ORDPAGO NOT LIKE 'C%' ","000000" )
EndIf

Return(cCodOrd)

//--------------------------------------------------------------------
/*/{Protheus.doc} A085NORP
@description de A087TUDOK:
    Este punto de entrada no es publico, buscando lo encontré en: A087TUDOK.prw
    // ACols
@author Jaime Luis Jiménez
@since  17/03/2017
@obs    Se debe revisar las variables Privadas, para poder programar correctamente.
        Private aCols (La misma variable de siempre, donde se accede a la Grilla).
@version MP11 R5
/*/
//--------------------------------------------------------------------
User Function A085BXPA(nRet)

Local cRet     := ""
Local cCtaCtb  := ""
Local cCCCtb   := ""
Local cItCCtb  := ""
Local cClVlCtb := ""

Local cOrdAnt  := SEK->(Left(EK_NUM,6)+EK_TIPO+" ")
Local cTitAnt  := SEK->(EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_FORNECE+EK_LOJA)

Local aAreaSEK := SEK->(GetArea())
Local aAreaSE2 := SE2->(GetArea())

cCtaCtb := Posicione("SA6",1,xFilial("SA6")+SEK->(EK_BANCO+EK_AGENCIA+EK_CONTA),"A6_CONTA")

SEK->(dbSetOrder(1))

If SEK->(dbSeek(xFilial("SEK")+cOrdAnt+cTitAnt)) //posiciona a ordem de pagamento original
    If Empty(cCtaCtb)
        cCtaCtb := SEK->EK_UCONTA
    EndIf
EndIf    

If SE2->(dbSeek(xFilial("SE2")+cTitAnt)) //Posiciona o titulo original
    If Empty(cCtaCtb)
        cCtaCtb  := SE2->E2_CONTAD
    EndIf
    cClVlCtb := SE2->E2_CLVLDB
EndIf            
    
If Empty(cCtaCtb)
    cCtaCtb  := '46107001'
EndIf

RestArea(aAreaSEK)
RestArea(aAreaSE2)

cItCCtb  := Posicione("SA2",1,xFilial("SA2")+SEK->(EK_FORNECE+EK_LOJA),"A2_XITEM")

If nRet == 1
    cRet := cCtaCtb
ElseIf nRet == 2
    cRet := cCCCtb
ElseIf nRet == 3
    cRet := cItCCtb
Else
    cRet := cClVlCtb
EndIf
        
Return(cRet)


//--------------------------------------------------------------------
/*/{Protheus.doc} A085NORP
@description de A087TUDOK:
    Este punto de entrada no es publico, buscando lo encontré en: A087TUDOK.prw
    // ACols
@author Jaime Luis Jiménez
@since  17/03/2017
@obs    Se debe revisar las variables Privadas, para poder programar correctamente.
        Private aCols (La misma variable de siempre, donde se accede a la Grilla).
@version MP11 R5
/*/
//--------------------------------------------------------------------
User Function A085CONTAS(cOrdPgto,cTpDoc,nRet)

//cOrdPgto -> Numero de la Orden de Pago
//cTpDoc 1 -> Asineto a DEBITO
//cTpDoc 2 -> Asiento a CREDITO

Local cRet     := ""
Local cCtaCtb  := ""
Local cCCCtb   := ""
Local cItCCtb  := ""
Local cClVlCtb := ""

Local nx       := 0
Local aAreaSEK := SEK->(GetArea())
Local aAreaSE2 := SE2->(GetArea())

For nx := 1 To Len(aRecNoSE2)

    SE2->(dbGoTo(aRecNoSE2[nx,8]))

    cCtaCtb  := ""
    cCCCtb   := ""
    cItCCtb  := ""
    cClVlCtb := ""

    If cTpDoc == "2" .And. AllTrim(SE2->E2_TIPO) $ "PA|NCP"
        
        //Banco
        
        If SEK->(dbSeek(xFilial("SEK")+SE2->(E2_ORDPAGO+E2_TIPO)))
            cCtaCtb := SEK->EK_UCONTA
        EndIf
            
        If Empty(cCtaCtb)
            If Empty(SE2->E2_CONTAD)
                cCtaCtb  := '46107001'
            Else      
                cCtaCtb  := SE2->E2_CONTAD
            EndIf
        EndIf

        cItCCtb  := Posicione("SA2",1,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_XITEM")
        cClVlCtb := SE2->E2_CLVLDB

    Else

 //       If SEK->(dbSeek(xFilial("SEK")+SE2->(E2_ORDPAGO+E2_TIPO)))
 //           cCtaCtb := SEK->EK_UCONTA
 //       EndIf
            
        If Empty(cCtaCtb)
            If Empty(SE2->E2_CONTAD)
                cCtaCtb  := Posicione("SA2",1,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_CONTA")
            Else      
                cCtaCtb  := SE2->E2_CONTAD
            EndIf
        EndIf

        cItCCtb  := Posicione("SA2",1,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_XITEM")
        cClVlCtb := SE2->E2_CLVLDB

    EndIf 

Next

If nRet == 1
    cRet := cCtaCtb
ElseIf nRet == 2
    cRet := cCCCtb
ElseIf nRet == 3
    cRet := cItCCtb
Else
    cRet := cClVlCtb
EndIf

RestArea(aAreaSEK)
RestArea(aAreaSE2)

Return(cRet)


User Function A85ISCP()

Local lRet := .F.
Local nA   := 0

For nA := 1 To Len(aPagos)
            
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Orden de Pagamento / Só Compensação     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If aPagos[nA,15] == 0
        lRet := .T.
    EndIf
    
Next nA

Return(lRet)