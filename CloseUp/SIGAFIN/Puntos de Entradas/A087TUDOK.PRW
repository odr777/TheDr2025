//TODO: JLJR: Compilar en TST para PROTHEUS 12

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
/*/{Protheus.doc} A087TUDOK
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
User Function A087TUDOK()

Local lPantallaValida := .T.
Local nFilaDocCobro := 1
Local cMsgFalta := ""
	
Local aArea    := {}
Local nA       := 0
Local lComp1   := .F.
Local lComp2   := .F.
Local cCodReci := cRecibo
Local cCodDiar := cDiario

// If Empty(cNatureza)
//     cMsgFalta += "Falta 'Modalidad'" + CRLF
//     lPantallaValida := .F.
// EndIf
        
// If nPanel == N_DOCUMENTOS_COBRO
//     For nFilaDocCobro := 1 to Len(aCols)
//         If !aCols[nFilaDocCobro,(Len(aHeader)+1)] 
        
//             If Empty(AllTrim(GDFieldGet("EL_UCLVL",nFilaDocCobro)))
//                 cMsgFalta += " Fila " + cValToChar(nFilaDocCobro) + ": Falta 'Clase Valor'" + CRLF
//                 lPantallaValida := .F.
//             EndIf

//             If Empty(AllTrim(GDFieldGet("EL_HISTOR",nFilaDocCobro))) .And. !Empty(AllTrim(GDFieldGet("EL_BANCO",nFilaDocCobro)))
//                 cMsgFalta += " Fila " + cValToChar(nFilaDocCobro) + ": Falta 'Historial'" + CRLF
//                 lPantallaValida := .F.
//             EndIf
        
//         EndIf
//     Next nFilaDocCobro
// EndIf

// If !lPantallaValida
//     MsgAlert(cMsgFalta + "-Mientras no llene los datos No podrá Continuar con la siguiente Ventana","A087TUDOK.PRW")
// EndIf
	
If lPantallaValida .And. nPanel == N_RESUMEN
        
    aArea := SE1->(GetArea())
    For nA := 1 To Len(aRLocks)
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Orden de Pagamento / Só Compensação     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        SE1->(dbGoTo(aRLocks[nA]))
            
        If AllTrim(SE1->E1_TIPO) $ "RA|NCC" //
            lComp1 := .T.
        Else
            lComp2 := .T.
        EndIf
        
    Next nA
    RestArea(aArea)
        
    If lComp1 .And. lComp2
        cCodDiar := TP_TRASPASO
        // cCodReci := U_AgNxtTrp(" EL_RECIBO","SEL","EL_RECIBO LIKE 'C%' ","C00000" )
    Else
        cCodDiar := TP_INGRESO
        // cCodReci := U_AgNxtTrp(" EL_RECIBO","SEL","EL_RECIBO NOT LIKE 'C%' ","000000" )
    EndIf

    oPanelTop:Refresh()
    If cDiario <> cCodDiar
        cDiario := cCodDiar
        cMsgFalta += "El codigo diario se ha cambiado a "+cCodDiar+". "+CRLF
    EndIf
    // If cRecibo <> cCodReci
    //     cRecibo := cCodReci
    //     cMsgFalta += "El numero de recibo se ha cambiado a "+cCodReci+"."
    // EndIf
        
    If !Empty(cMsgFalta)
        // MsgAlert(cMsgFalta)
    EndIf
        
EndIf
	
	
Return lPantallaValida
