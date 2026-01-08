#include "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
 
User Function CN121PED()   
    Local aCab      := PARAMIXB[1] 
    Local aItens    := PARAMIXB[2]
    Local aResult   := Array(2)
    Local oModel    := Nil
    Local lVenda    := .F.
    Local cObs      := ""
    //Local aArea:= GetArea()
    /*Local aUmItem   := {}
    Local nIndex    := 0
    Local nX        := 0
    Local aTemp     := {}
 */
    If !(Empty(aCab) .Or. Empty(aItens))
        oModel := FwModelActive()      
        lVenda := Cn121RetSt( "VENDA",0, /*cPlan*/, /*cContra*/, .T., oModel )     
        If lVenda
            // SC5->C5_UOBSERV := CND->CND_COMPET
            
            /*aTemp   := aClone(aUmItem[nIndex])
            aTemp[1]:= "C6_QTDLIB"
            aAdd(aUmItem, aTemp)

            aAdd(aCab[Nx],{"C7_CC",CNB->CNB_CC,nil})*/
            
            cObs := "Periodo de facturación: " + CND->CND_COMPET
            aAdd(aCab,{"C5_UOBSERV",cObs,nil})
            
            /*ASIZE(aCab,Len(aCab)+1)
            For Cx:=1 to Len(aCab)

                If (aScan(aCab[Cx],{|x|x[1]=="CND_COMPET"}))
                    aCab[Cx][2] := CND->CND_COMPET
                Else
                    aAdd(aCab[Cx],{"C5_UOBSERV",CND->CND_COMPET,nil})

                    EndIf
            Next*/

            //for nX := 1 to Len(aItens)
              //  aUmItem := aItens[nX]
                
                /*nIndex  := aScan(aUmItem, {|x| AllTrim(x[1]) == "C6_QTDVEN"})
                if nIndex > 0
                    aTemp   := aClone(aUmItem[nIndex])
                    aTemp[1]:= "C6_QTDLIB"
                    aAdd(aUmItem, aTemp) //Equaliza a quantidade liberada com a quantidade, dessa forma o pedido é automaticamente liberado.
                    /*É importante frisar que com essa liberação, ao tentar estornar a medição, será apresentado o alerta A410LIBER */
                //endif

                /*nIndex  := aScan(aUmItem, {|x| AllTrim(x[1]) == "C6_UITEM"})
                if nIndex > 0
                    aTemp   := aClone(aUmItem[nIndex])
                    aTemp[1]:= "C6_PRODUTO"
                    aAdd(aUmItem, aTemp) //Equaliza a quantidade liberada com a quantidade, dessa forma o pedido é automaticamente liberado.
                    /*É importante frisar que com essa liberação, ao tentar estornar a medição, será apresentado o alerta A410LIBER */
                /*endif
            next nX*/
        EndIf
    EndIf
 
    aResult[1] := aCab
    aResult[2] := aItens
Return aResult
