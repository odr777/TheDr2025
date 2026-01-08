#include 'protheus.ch'
#include 'parmtype.ch'

#Define N_RESUMEN 4
#DEFINE TP_MANUAL   "06"
#DEFINE TP_INGRESO  "07"
#DEFINE TP_EGRESO   "08"
#DEFINE TP_TRASPASO "09"

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA087TUDOK  บAutor ณTdeP Horeb SRL บ Data ณ  21/12/2019      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
AฑบDesc.     ณPUNTO DE ENTRADA que valida cada salto de pantalla en		  บฑฑ
ฑฑบ           cobros diversos FINA087A      							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP12BIB -BELEN											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A087TUDOK()
	Local lRet := .T.
	Local nX,i
	//local cNomCliTit	:= cNome

	if GetRemoteType() < 0 // nahim Terrazas toma en cuenta s๓lo si no es un web services
		return .T.
	endif
	if nPanel == N_RESUMEN //.AND. nTotalBx > 0 // valida solo cuando el panel es el ๚ltimo y cuando estoy pagando cuentas
		CambCorrCon() // verifica si tiene que cambiar el correlativo contable.
	endif
return .T.



/*/{Protheus.doc} CambCorrCon
	Cambia corrlativo contable
	@type  Static Function
	@author Nahim Terrazas
	@since 19/01/2021
	/*/
Static Function CambCorrCon()
Local lPantallaValida := .T.
Local nFilaDocCobro := 1
Local cMsgFalta := ""
	
Local aArea    := {}
Local nA       := 0
Local lComp1   := .F.
Local lComp2   := .F.
Local cCodReci := cRecibo
Local cCodDiar := cDiario

    aArea := SE1->(GetArea())
    For nA := 1 To Len(aRLocks)
            
            //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
            //ณ Orden de Pagamento / S๓ Compensa็ใo     ณ
            //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
Return 
